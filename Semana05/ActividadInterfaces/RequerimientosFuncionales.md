# Requerimientos Funcionales

- **RF-01 – Ingreso del capital inicial:** Permitir ingresar el monto inicial del préstamo expresado en soles.

- **RF-02 – Ingreso de la tasa de interés:** Permitir ingresar la tasa de interés anual expresada en porcentaje.

- **RF-03 – Ingreso del plazo:** Permitir ingresar el plazo del préstamo expresado en años.

- **RF-04 – Conversión de la tasa de interés:** Convertir la tasa de interés anual a una tasa mensual mediante la siguiente operación:

  `r = tasa anual / 100 / 12`

- **RF-05 – Determinación del número de pagos:** Calcular el número total de pagos mensuales a partir del plazo ingresado:

  `n = plazo en años × 12`

- **RF-06 – Aplicación de la fórmula de amortización:** Calcular la cuota mensual utilizando la fórmula establecida en la actividad:

  `M = P × [r(1 + r)^n / ((1 + r)^n - 1)]`

  Donde:

  - `M` = cuota mensual.
  - `P` = capital inicial del préstamo.
  - `r` = tasa de interés mensual.
  - `n` = número total de pagos.

- **RF-07 – Cálculo del monto total:** Obtener el monto total a pagar mediante la multiplicación de la cuota mensual por el número total de pagos:

  `Monto total = M × n`

- **RF-08 – Ejecución del cálculo:** Ejecutar el proceso de cálculo al seleccionar el botón **"Calcular préstamo"**.

- **RF-09 – Visualización de la cuota mensual:** Mostrar la cuota mensual calculada en soles utilizando dos decimales.

- **RF-10 – Visualización del monto total:** Mostrar el monto total a pagar en soles utilizando dos decimales.

- **RF-11 – Actualización de resultados:** Actualizar los valores mostrados cuando se ingresen nuevos datos y se vuelva a ejecutar el cálculo.

- **RF-12 – Procesamiento de datos:** Convertir los valores ingresados mediante los campos de texto a datos numéricos antes de realizar las operaciones matemáticas.
