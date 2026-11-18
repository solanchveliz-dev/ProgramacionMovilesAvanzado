# Compras · Requerimientos (Grupo B)

App iOS para que una distribuidora registre compras a proveedores, controle su inventario a costo promedio y gestione lo que debe. Las compras desde S/ 5,000 las aprueba un supervisor.

**Integrantes:** (completar)
**Tecnología:** SwiftUI + SwiftData (SQLite) · iOS 17+ · Ramas: `main` y `ai-assisted`

## Roles

| Rol | Pestañas | Qué hace |
| --- | --- | --- |
| Comprador | Productos, Proveedores, Compra, Mis compras | Registra compras y ve solo las suyas |
| Supervisor | Resumen, Aprobar, Por pagar, Productos, Proveedores | Administra el catálogo, aprueba, paga y ve todo |

## Requerimientos funcionales

| Código | Requerimiento | Rol |
| --- | --- | --- |
| RF-01 | Registrarse con nombre, usuario único, clave (mínimo 6) y rol. | Todos |
| RF-02 | Iniciar sesión; si falla, mostrar "Usuario o clave incorrectos". | Todos |
| RF-03 | Ver las pestañas según su rol y cerrar sesión desde el avatar. | Todos |
| RF-04 | Ver y buscar productos con su stock en color y el valor del inventario. | Todos |
| RF-05 | Crear, editar y borrar productos (no se borra si tiene compras). | Supervisor |
| RF-06 | Ver y buscar proveedores con su total comprado y estado "Por pagar" o "Al día". | Todos |
| RF-07 | Crear, editar y borrar proveedores con RUC válido (no se borra si tiene compras). | Supervisor |
| RF-08 | Registrar una compra al contado o a crédito 30 días, con IGV calculado. | Comprador |
| RF-09 | Aprobar al instante las compras menores a S/ 5,000 y enviar a aprobación las demás. | Sistema |
| RF-10 | Ver solo sus compras y el motivo cuando una es rechazada. | Comprador |
| RF-11 | Aprobar o rechazar con motivo las compras desde S/ 5,000. | Supervisor |
| RF-12 | Actualizar el stock y el costo promedio al aprobar una compra. | Sistema |
| RF-13 | Pagar las compras a crédito y ver las vencidas. | Supervisor |
| RF-14 | Ver el resumen: inventario, crédito fiscal, por pagar, por aprobar y total por proveedor. | Supervisor |
| RF-15 | Ver todas las compras y el detalle de cada una con su seguimiento. | Supervisor |

## Requerimientos no funcionales

| Código | Requerimiento |
| --- | --- |
| RNF-01 | Las claves se guardan como hash SHA-256 con sal, nunca en texto plano. |
| RNF-02 | Los datos se guardan en el teléfono y no se pierden al cerrar la app. |
| RNF-03 | No se borra un usuario, producto o proveedor que tenga compras. |
| RNF-04 | Los montos se muestran en soles con 2 decimales (S/ 1,416.00). |
| RNF-05 | Funciona en iPhone con iOS 17 o superior, en modo claro y oscuro. |

## Reglas de negocio

- **IGV:** 18 % del subtotal. Total = subtotal + IGV. Ej.: 10 × S/ 120 = 1,200 + 216 = **S/ 1,416.00**.
- **Aprobación:** menor a S/ 5,000 se aprueba sola; desde S/ 5,000 queda pendiente hasta que el supervisor decida.
- **Costo promedio:** (stock × costo + cantidad × costo nuevo) / (stock + cantidad). Ej.: (40 × 110 + 10 × 120) / 50 = **S/ 112.00**.
- **Pago:** contado queda pagada; crédito vence a los 30 días y, si pasa la fecha, se marca **VENCIDA**.
- **Rechazo:** exige motivo y no cambia el stock.

## Modelo de datos

| Clase | Datos principales | Relación |
| --- | --- | --- |
| Usuario | nombre, usuario, clave, rol | tiene muchas compras |
| Proveedor | nombre, RUC | tiene muchas compras |
| Producto | nombre, categoría, stock, costo promedio, foto | tiene muchas compras |
| Compra | fecha, cantidad, costo, IGV, total, crédito, vence, estado, pagada | pertenece a un comprador, un proveedor y un producto |
