Modelo final elegido para la competencia 2

Archivo elegido: results_v016_s5_14

Los archivos se ejecutan en el orden que indica el nombre (numero de job):

j1_clase_ternaria: crea la clase target en el dataset original
j2_inflacion: ajusta las variables monetarias utilizando el IPC para descontar el efecto de la j2_inflacion
j3_feature_engineering: crea columnas adicionales para mejorar la performance del modelo (sumas, promedios moviles y pendientes)
j4_undersampling: se undersamplea la clase mayoritaria para tener un dataset mas chico y lograr una mejor perfomance en entrenamiento.
j5_optimizacion: optimizacion de hiperparametros utilizando el dataset undersampleado
j6_entrenamiento: se entrena 100 LGBM utilizando los hiperparametros optimos encontrado en el paso anterior y variando solo la semilla del modelo.
j7_test: se testean los 100 modelos del punto anterior en junio 2021 y se promedian las predicciones para evaluar el desempeño del semillero en junio.
j8_final_train: se reentrenan los 100 modelos individuales del semillero en la totalidad de los datos disponibles (esto es, agregando el mes de test)
j9_prediccion_kaggle: se genera la prediccion para kaggle promediando las predicciones de los 100 modelos individuales
j10_kaggle_submit: carga las predicciones en kaggle y guarda los resultados.

Archivos adicionales que se encuentran en la carpeta:

optimization_lgbm.db: contiene los resultados de la optimizacion del modelo y los hiperparametros optimos
