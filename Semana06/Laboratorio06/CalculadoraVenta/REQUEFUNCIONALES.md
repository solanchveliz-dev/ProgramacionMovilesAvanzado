# Calculadora de Venta a Plazos de Electrodoméstico

**Curso:** Programación en Móviles Avanzado · **Semana:** 06 · **Ejercicio:** 4 (rama `ai-assisted`)

## 1. Descripción

Aplicación iOS desarrollada en UIKit con Storyboard que calcula la venta a plazos de un electrodoméstico. El usuario ingresa los datos de la venta y la app muestra el detalle del pago en una segunda pantalla, usando navegación **Show** y un modelo propio (`VentaModel`).

## 2. Tecnologías

- Swift · UIKit · Storyboard (Interface Builder)
- `UINavigationController` y segue Show
- Paso de datos con `prepare(for:sender:)`

## 3. Estructura del proyecto

| Archivo | Responsabilidad |
|---|---|
| `VentaModel.swift` | Clase `NSObject` con 6 propiedades `Double`: subtotal, igv, base, intereses, total, cuota |
| `NuevaVentaViewController.swift` | Lee los 5 campos, aplica las fórmulas y envía el modelo |
| `ResultadoViewController.swift` | Recibe `pVenta` y muestra los resultados en soles |
| `Main.storyboard` | Navigation Controller → Nueva Venta → (Show `showResultado`) → Resultado |

## 4. Requerimientos funcionales

| Código | Requerimiento |
|---|---|
| RF01 | La pantalla "Nueva Venta" permitirá ingresar el electrodoméstico, precio unitario, cantidad, número de meses e interés mensual. |
| RF02 | Los campos numéricos mostrarán el teclado decimal. |
| RF03 | El sistema calculará el subtotal, IGV, base, intereses, total y cuota mensual según las fórmulas definidas. |
| RF04 | Los campos vacíos o con valores no numéricos serán considerados como 0, evitando el cierre inesperado de la aplicación. |
| RF05 | Cuando el número de meses sea 0, la cuota mensual será S/. 0.00. |
| RF06 | El resultado será enviado a la pantalla "Resultado" mediante un objeto `VentaModel` utilizando el segue `showResultado`. |
| RF07 | La pantalla "Resultado" mostrará los seis resultados con formato monetario `S/. 0.00`. |
| RF08 | El usuario podrá regresar a "Nueva Venta" mediante el botón de retroceso del Navigation Controller. |
| RF09 | Al tocar fuera de los campos de texto, el teclado será ocultado. |

## 5. Fórmulas de cálculo

```
Subtotal      = Precio unitario × Cantidad
IGV           = Subtotal × 0.18
Base          = Subtotal + IGV
Intereses     = Base × (Interés mensual / 100) × Meses
Total         = Base + Intereses
Cuota mensual = Total / Meses
```

## 6. Caso de prueba

**Datos de entrada**

| Campo | Valor |
|---|---|
| Electrodoméstico | Refrigeradora |
| Precio unitario | 1750 |
| Cantidad | 2 |
| Meses | 12 |
| Interés mensual (%) | 1 |

**Resultado esperado**

| Concepto | Valor |
|---|---|
| Subtotal | S/. 3500.00 |
| IGV (18%) | S/. 630.00 |
| Base | S/. 4130.00 |
| Intereses | S/. 495.60 |
| Total | S/. 4625.60 |
| Cuota mensual | S/. 385.47 |

**Caso adicional:** dejar "Meses" vacío → la cuota debe mostrarse S/. 0.00 y la app no debe cerrarse (RF04 y RF05).
