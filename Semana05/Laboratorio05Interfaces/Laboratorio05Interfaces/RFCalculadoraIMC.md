# Requerimientos Funcionales – Calculadora de IMC

- **RF-01 – Ingreso del peso:** Permitir ingresar el peso de la persona expresado en kilogramos (kg).

- **RF-02 – Ingreso de la altura:** Permitir ingresar la altura de la persona expresada en metros (m).

- **RF-03 – Procesamiento de datos:** Convertir los valores ingresados en los campos de texto a datos numéricos antes de realizar el cálculo.

- **RF-04 – Cálculo del IMC:** Calcular el Índice de Masa Corporal utilizando la fórmula:

  `IMC = peso / (altura × altura)`

  Donde:
  - `peso` = peso de la persona en kilogramos.
  - `altura` = altura de la persona en metros.
  - `IMC` = Índice de Masa Corporal.

- **RF-05 – Ejecución del cálculo:** Iniciar el cálculo al presionar el botón **"Calcular IMC"**.

- **RF-06 – Visualización del IMC:** Mostrar el resultado del IMC obtenido con dos decimales.

- **RF-07 – Clasificación del IMC:** Determinar la categoría correspondiente según el resultado obtenido:
  - Menor de 18.5: **Bajo peso**
  - De 18.5 a 24.9: **Peso normal**
  - De 25.0 a 29.9: **Sobrepeso**
  - 30.0 o superior: **Obesidad**

- **RF-08 – Visualización de la clasificación:** Mostrar la categoría correspondiente junto con el resultado del IMC.

- **RF-09 – Actualización de resultados:** Permitir realizar un nuevo cálculo cuando se modifiquen los valores de peso o altura y se presione nuevamente el botón de cálculo.

- **RF-10 – Validación de datos:** Verificar que los campos de peso y altura contengan valores válidos antes de realizar el cálculo.

- **RF-11 – Presentación de resultados:** Mostrar de forma clara y diferenciada el **IMC calculado** y su **clasificación**.
