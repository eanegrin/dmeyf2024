
Modelo final elegido para la competencia 3: Modelo v010

Archivo elegido: results_v010_12.csv

El modelo es un ensamble que promedia 10 predicciones del modelo v07 y 10 predicciones del modelo v08

---------------------------------------------------------------------------------------------------------------

Para replicar los resultados, en primer lugar se deben correr los siguientes jobs de los modelos v07 y v08:

j1_clase_ternaria: crea la clase target en el dataset original. (Nota: es el mismo job en ambos modelos por lo que solo se necesita correr 1 vez)
j2_inflacion: ajusta las variables monetarias utilizando el IPC para descontar el efecto de la j2_inflacion. (Nota: es el mismo job en ambos modelos por lo que solo se necesita correr 1 vez)
j4_feature_engineering: crea columnas adicionales para mejorar la performance del modelo.
j5_undersampling: se undersamplea la clase mayoritaria para tener un dataset mas chico y lograr una mejor perfomance en entrenamiento.
j6_optimizacion: optimizacion de hiperparametros utilizando el dataset undersampleado.

(j3_data_quality no es necesario correrlo dado que es solo para diagnosticar problemas de calidad o data drifting en nuestros datos)

jobs modelo v07: https://github.com/eanegrin/dmeyf2024/tree/main/competencia_3/model_v07
jobs modelo v08: https://github.com/eanegrin/dmeyf2024/tree/main/competencia_3/model_v08

----------------------------------------------------------------------------------------------------------------

En segundo lugar, se ejecutan en orden los jobs del modelo v010 que se encuentran en la carpeta: 
https://github.com/eanegrin/dmeyf2024/tree/main/competencia_3/model_v10

Los archivos se ejecutan en el orden que indica el nombre (numero de job):

j1_model_v07_train: se entrenan el modelo v07 utilizando 10 semillas para generar 10 versiones distintas del modelo.
j1_model_v08_train: se entrenan el modelo v08 utilizando 10 semillas para generar 10 versiones distintas del modelo.
j2_model_v07_prediccion: Se generan las predicciones de septiembre para cada semilla del modelo v07.
j2_model_v08_prediccion: Se generan las predicciones de septiembre para cada semilla del modelo v07.
j3_prediccion_final: Se cargan las predicciones generadas en el paso anterior y se promedian para generar la prediccion final.
j4_kaggle_submit: Se sube la prediccion del modelo final a kaggle utilizando distintos puntos de corte.

Como prediccion final se elije el archivo que establece el corte en 10916 envios.

-----------------------------------------------------------------------------------------------------------------

Archivos adicionales que se encuentran en la carpeta:

optimization_lgbm_v07.db: contiene los resultados de la optimizacion del modelo v07 y los hiperparametros optimos
optimization_lgbm_v08.db: contiene los resultados de la optimizacion del modelo v07 y los hiperparametros optimos
