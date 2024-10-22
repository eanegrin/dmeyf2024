Archivos utilizados para generar la prediccion final del modelo elegido en la competencia 1.

Se deben correr en el siguiente orden:
1. e1_clase_ternaria: toma la base de datos original y agrega la columna con la clase e1_clase_ternaria
2. e2_feature_engineering: toma el output del script anterior, y agrega columnas adicionales para mejorar la performance del modelo.
3. e3_gbdt_model: entrena un modelo de LightGBM sobre el dataset resultado del punto anterior y genera el archivo con la prediccion final lista para subir a kaggle.

Archivos adicionales que se encuentran en la carpeta:
optimization_lgbm.db: contiene los resultados de la optimizacion del modelo en e3_gbdt_model, se puede cargar desde este archivo si se quieren ver los resultados de la optimizacion.
pero no es necesario para generar el archivo final.