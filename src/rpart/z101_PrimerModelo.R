# Arbol elemental con libreria  rpart
# Debe tener instaladas las librerias  data.table ,  rpart  y  rpart.plot

# cargo las librerias que necesito
require("data.table")
require("rpart")
require("rpart.plot")

# Aqui se debe poner la carpeta de la materia de SU computadora local
setwd("C:/Eugenio/Maestria/DMEyF") # Establezco el Working Directory

# cargo el dataset que tiene la clase calculada !
dataset <- fread("./datasets/competencia_01_crudo.csv")

# generar clase ternaria ----------------------------------------------------------------------------------

# importo librerias adicionales

library(dplyr)
library(tidyr)
library(lubridate)

# convierto el periodo a tipo date y genero los 2 periodos subsiguientes para cada fila

dataset$periodo0 <- as.Date(paste0(dataset$foto_mes,"01"),"%Y%m%d")

dataset$periodo1 <- dataset$periodo0 %m+% months(1)
dataset$periodo2 <- dataset$periodo1 %m+% months(1)

# concateno el numero del cliente con los 3 periodos relevantes

dataset$cliente_periodo0 <- paste(dataset$numero_de_cliente, dataset$periodo0, sep = " - ")
dataset$cliente_periodo1 <- paste(dataset$numero_de_cliente, dataset$periodo1, sep = " - ")
dataset$cliente_periodo2 <- paste(dataset$numero_de_cliente, dataset$periodo2, sep = " - ")

# para el caso general, asigno baja+1 y baja+2 si la combinacion (id,periodo) no esta en la columna original

dataset <- dataset %>% mutate(clase_ternaria = case_when(
  !(cliente_periodo1 %in% dataset$cliente_periodo0) ~ "BAJA+1",
  !(cliente_periodo2 %in% dataset$cliente_periodo0) ~ "BAJA+2",
  .default = "CONTINUA"
))

# corrijo las asignaciones del paso anterior para los ultimos 2 meses

ultimo_periodo <- max(dataset$periodo0)
anteultimo_periodo <- ultimo_periodo %m-% months(1)

dataset <- dataset %>% mutate(clase_ternaria = case_when(
  (periodo0 == anteultimo_periodo) & (clase_ternaria != "BAJA+1") ~ NA,
  periodo0 == ultimo_periodo ~ NA,
  .default = clase_ternaria
))

# totales para cada periodo

dataset %>%
  group_by(periodo0, clase_ternaria) %>%
  summarize(count = n()) %>%
  arrange(periodo0, clase_ternaria) %>% 
  pivot_wider(names_from = clase_ternaria, values_from = count)

# elimino columnas auxiliares

dataset <- dataset %>% select(-c(periodo0:cliente_periodo2))


# ------------------------------------------------------------------------------------------------------

dtrain <- dataset[foto_mes <= 202104] # defino donde voy a entrenar
dapply <- dataset[foto_mes == 202106] # defino donde voy a aplicar el modelo

unique(dtrain$foto_mes)


# genero el modelo,  aqui se construye el arbol
# quiero predecir clase_ternaria a partir de el resto de las variables
modelo <- rpart(
    formula = "clase_ternaria ~ .",
    data = dtrain, # los datos donde voy a entrenar
    xval = 0,
    cp = -1, # esto significa no limitar la complejidad de los splits
    minsplit = 250, # minima cantidad de registros para que se haga el split
    minbucket = 100, # tamaño minimo de una hoja
    maxdepth = 7  # profundidad maxima del arbol
)


# grafico el arbol
prp(modelo,
    extra = 101, digits = -5,
    branch = 1, type = 4, varlen = 0, faclen = 0
)


# aplico el modelo a los datos nuevos
prediccion <- predict(
    object = modelo,
    newdata = dapply,
    type = "prob"
)

# prediccion es una matriz con TRES columnas,
# llamadas "BAJA+1", "BAJA+2"  y "CONTINUA"
# cada columna es el vector de probabilidades

# agrego a dapply una columna nueva que es la probabilidad de BAJA+2
dapply[, prob_baja2 := prediccion[, "BAJA+2"]]

# solo le envio estimulo a los registros
#  con probabilidad de BAJA+2 mayor  a  1/40
dapply[, Predicted := as.numeric(prob_baja2 > 1 / 40)]

# genero el archivo para Kaggle
# primero creo la carpeta donde va el experimento
dir.create("./exp/")
dir.create("./exp/KA2001")

# solo los campos para Kaggle
fwrite(dapply[, list(numero_de_cliente, Predicted)],
        file = "./exp/KA2001/K101_001.csv",
        sep = ","
)
