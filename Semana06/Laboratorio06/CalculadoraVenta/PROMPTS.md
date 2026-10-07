# PROMPTS.md — Semana 06 · Ejercicio 4 (rama ai-assisted)

## Prompt usado (estructura CTRFE)

### Contexto
Estoy en el curso Programación en Móviles Avanzado (Swift, UIKit con Storyboard).
Mi proyecto tiene un Navigation Controller y dos pantallas ya diseñadas y conectadas:
- "Nueva Venta" (NuevaVentaViewController) con 5 UITextField:
  tfElectrodomestico, tfPrecio, tfCantidad, tfMeses, tfInteres.
- "Resultado" (ResultadoViewController) con 6 UILabel:
  lblSubtotal, lblIgv, lblBase, lblIntereses, lblTotal, lblCuota.
El botón "Calcular" tiene un segue Show con identifier "showResultado".

### Tarea
1. Define `class VentaModel: NSObject` con 6 propiedades Double:
   subtotal, igv, base, intereses, total, cuota.
2. En "Nueva Venta", implementa el cálculo con estas fórmulas y arma un VentaModel:
   subtotal = precioUnitario × cantidad · igv = subtotal × 0.18 ·
   base = subtotal + igv · intereses = base × (tasa / 100) × meses ·
   total = base + intereses · cuota = total / meses
3. Pasa el VentaModel a "Resultado" con `prepare(for:sender:)`.
4. En "Resultado", muestra cada valor con `String(format: "S/. %.2f", valor)`.

### Restricciones
- Usa solo lo visto hasta la semana 6: clases, UINavigationController,
  prepare(for:sender:), IBOutlet/IBAction.
- No uses Combine, Codable ni persistencia.
- Explica por qué usas `class` y no `struct` para VentaModel.

### Formato
Código separado por archivo (VentaModel.swift, NuevaVentaViewController.swift,
ResultadoViewController.swift), con comentarios cortos en español.

### Ejemplo
Entrada: precio 1750, cantidad 2, meses 12, interés 1 %.
Salida esperada: Subtotal S/. 3500.00 · IGV S/. 630.00 · Base S/. 4130.00 ·
Intereses S/. 495.60 · Total S/. 4625.60 · Cuota S/. 385.47

---

## ¿Por qué class y no struct? (respuesta de la IA)
Se usó `class VentaModel: NSObject` para mantener el mismo patrón que ClienteModel
del ejercicio manual. Una class es un tipo por referencia: Resultado recibe el mismo
objeto creado en Nueva Venta. Con un struct el paso de datos hacia adelante también
funcionaría, porque se copia el valor antes de abrir la pantalla; la diferencia
se notaría solo si una pantalla modificara el modelo y la otra esperara ver el cambio.

---

## Reflexión: qué hizo distinto la IA
- Validó los campos sin que se lo pidiera: usó `Double(tf.text ?? "") ?? 0`
  en vez de `text!`, así un campo vacío vale 0 y la app no se cae.
- Evitó dividir entre cero: si meses es 0, la cuota queda en 0.
- No usó `guard let` ni alertas; se mantuvo en lo visto en clase.
- Pasó los datos con el segue y `prepare(for:sender:)`, en vez de
  `instantiateViewController` + `present` como en la ventana modal.
- Tuve que corregir dónde iba cada parte: `pVenta` debía estar en
  ResultadoViewController (la pantalla que recibe), no en Nueva Venta.
- Con los datos de ejemplo, los resultados coincidieron con el diseño del docente.
