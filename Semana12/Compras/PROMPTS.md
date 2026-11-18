App Compras · Grupo B (SwiftUI + SwiftData) · Programación en Móviles
Avanzado · Tecsup

# Cómo usamos la IA

Primero hicimos el expediente con el modelo, los roles, las reglas y los
casos de prueba. Con él usamos la IA para construir el código paso a
paso, un commit por pantalla o regla, en la rama ai-assisted. Cada
consulta se anota con el formato de la guía: Contexto, Tarea,
Restricciones, Formato esperado y qué hicimos con la respuesta.

- Verificamos cada respuesta compilando y ejecutando la app en el
  simulador.

- Comparamos los resultados con los cálculos hechos a mano del
  expediente (IGV, aprobación y costo promedio).

- Cuando Xcode marcó errores, los corregimos y lo anotamos en la
  consulta correspondiente.

# Resumen de las 21 consultas

| **N.º** | **Consulta**                              | **Rama**           | **Decisión** |
|---------|-------------------------------------------|--------------------|--------------|
| 01      | Expediente y requerimientos funcionales   | main               | Aceptada     |
| 02      | Creación del proyecto y ramas de Git      | main / ai-assisted | Modificada   |
| 03      | Modelo de datos (4 clases @Model)         | ai-assisted        | Aceptada     |
| 04      | Sesión y seguridad de claves              | ai-assisted        | Aceptada     |
| 05      | Pantalla de registro (B2)                 | ai-assisted        | Aceptada     |
| 06      | Pantalla de inicio de sesión (B1)         | ai-assisted        | Modificada   |
| 07      | Pestañas por rol y menú del avatar        | ai-assisted        | Aceptada     |
| 08      | Reglas de negocio                         | ai-assisted        | Aceptada     |
| 09      | Productos (B3) con foto                   | ai-assisted        | Aceptada     |
| 10      | Proveedores (B4)                          | ai-assisted        | Modificada   |
| 11      | Nueva compra (B5)                         | ai-assisted        | Aceptada     |
| 12      | Mis compras (B6)                          | ai-assisted        | Aceptada     |
| 13      | Aprobar (B7)                              | ai-assisted        | Aceptada     |
| 14      | Por pagar (B8)                            | ai-assisted        | Modificada   |
| 15      | Resumen (B9)                              | ai-assisted        | Aceptada     |
| 16      | Datos de demostración                     | ai-assisted        | Modificada   |
| 17      | Ícono, logo y pantalla de bienvenida      | ai-assisted        | Aceptada     |
| 18      | Prompts para las fotos de productos       | ai-assisted        | Aceptada     |
| 19      | Corrección del mensaje de error del login | ai-assisted        | Aceptada     |
| 20      | Ajuste de las pantallas a la maqueta      | ai-assisted        | Aceptada     |
| 21      | Todas las compras y seguimiento           | ai-assisted        | Aceptada     |

# Detalle de cada consulta

## Consulta 01 · Expediente y requerimientos funcionales

Fecha: 17/11/2026 · Herramienta: Claude · Rama: main

|                                  |                                                                                                                                                                                                                  |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Trabajo de la semana, Grupo B: app Compras con SwiftUI + SwiftData, roles Comprador y Supervisor. Teníamos la guía con el modelo, las 9 pantallas, las reglas de negocio y los casos de prueba.                  |
| **Tarea**                        | Armar el expediente con ficha técnica, modelo de datos, matriz de permisos, requerimientos funcionales y no funcionales, reglas con ejemplos numéricos, pantallas, casos de prueba y plan de commits.            |
| **Restricciones**                | Respetar las reglas de la guía (IGV 18 %, límite S/ 5,000, costo promedio ponderado, delete rule .deny). Que se vea como una app real, no cosas puestas por poner.                                               |
| **Formato esperado**             | Documento editable exportable a Word, con tablas y un diagrama del modelo.                                                                                                                                       |
| **Qué hicimos con la respuesta** | Lo aceptamos y lo revisamos contra la guía. Comprobamos a mano los ejemplos (1,416.00; 112.00; 115.56; 7,080.00). Luego lo actualizamos con los cambios del proyecto (33 RF, rama ai-assisted, pantallas extra). |

## Consulta 02 · Creación del proyecto y ramas de Git

Fecha: 17/11/2026 · Herramienta: Claude · Rama: main / ai-assisted

|                                  |                                                                                                                                                                                                                                                                                      |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Repositorio ACTIVIDADSEMANA11 con trabajos anteriores en las ramas main y ai-assisted.                                                                                                                                                                                               |
| **Tarea**                        | Guiarnos para crear el proyecto Compras en la carpeta Semana12 y organizar las ramas sin perder trabajos anteriores.                                                                                                                                                                 |
| **Restricciones**                | Hacerlo desde Xcode, sin comandos. No borrar ni sobrescribir ramas existentes.                                                                                                                                                                                                       |
| **Formato esperado**             | Pasos numerados.                                                                                                                                                                                                                                                                     |
| **Qué hicimos con la respuesta** | Modificamos el plan: el primer commit quedó en main y la IA proponía otra rama, pero decidimos trabajar sobre nuestra rama ai-assisted. Al subirla hubo un aviso de 'out of date'; no hicimos force-push, hicimos Pull y resolvimos un conflicto de .DS_Store eligiendo una versión. |

## Consulta 03 · Modelo de datos (4 clases @Model)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                                                        |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Expediente aprobado con las entidades Usuario, Proveedor, Producto y Compra.                                                                                           |
| **Tarea**                        | Generar las clases @Model con sus relaciones y el contenedor de SwiftData.                                                                                             |
| **Restricciones**                | Relaciones 1 a muchos con .deny e inverse; atributos de la guía; archivo ComprasData.sqlite.                                                                           |
| **Formato esperado**             | Un archivo .swift por clase + ContenedorDatos.swift.                                                                                                                   |
| **Qué hicimos con la respuesta** | Lo aceptamos. Agregamos atributos propios (sal, codigo, foto, fechaPago) que están justificados en el expediente. Verificamos que la app abre con los contadores en 0. |

## Consulta 04 · Sesión y seguridad de claves

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                                                                           |
|----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Modelo listo; faltaba el registro y el login.                                                                                                                                             |
| **Tarea**                        | Crear la sesión (@Observable) y el servicio de autenticación.                                                                                                                             |
| **Restricciones**                | Usuario único sin distinguir mayúsculas, clave mínimo 6, error genérico, usar FetchDescriptor + \#Predicate + fetchCount como dice la pista de la guía. No guardar claves en texto plano. |
| **Formato esperado**             | Sesion.swift y ServicioAuth.swift.                                                                                                                                                        |
| **Qué hicimos con la respuesta** | Lo aceptamos. La clave se guarda como hash SHA-256 con sal; lo comprobamos viendo el hash en pantalla.                                                                                    |

## Consulta 05 · Pantalla de registro (B2)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                                   |
|----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Servicio de autenticación listo.                                                                                                                  |
| **Tarea**                        | Crear la pantalla Crear cuenta con aviso en vivo de usuario repetido.                                                                             |
| **Restricciones**                | Campos de la leyenda B2; entrar directo a la app al registrarse.                                                                                  |
| **Formato esperado**             | RegistroView.swift + pantalla temporal para probarla.                                                                                             |
| **Qué hicimos con la respuesta** | Lo aceptamos y probamos los casos 1 (mtorres / MTORRES) y las validaciones de clave. Después pedimos rediseñarla para que se vea como la maqueta. |

## Consulta 06 · Pantalla de inicio de sesión (B1)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                               |
|----------------------------------|-----------------------------------------------------------------------------------------------|
| **Contexto**                     | Registro listo.                                                                               |
| **Tarea**                        | Crear el login y la vista raíz que muestra login o app según la sesión.                       |
| **Restricciones**                | Mensaje 'Usuario o clave incorrectos'; patrón if let usuario = sesion.usuario de la guía.     |
| **Formato esperado**             | LoginView.swift, RootView.swift y ComprasApp.swift.                                           |
| **Qué hicimos con la respuesta** | Lo modificamos: Xcode marcó que faltaba import SwiftData en RootView; lo agregamos y compiló. |

## Consulta 07 · Pestañas por rol y menú del avatar

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                |
|----------------------------------|--------------------------------------------------------------------------------|
| **Contexto**                     | Login funcionando.                                                             |
| **Tarea**                        | Mostrar 4 pestañas al comprador y 5 al supervisor, con avatar y Cerrar sesión. |
| **Restricciones**                | Pestañas exactas de la guía.                                                   |
| **Formato esperado**             | MainTabView, AvatarMenu y una pantalla temporal para las pestañas pendientes.  |
| **Qué hicimos con la respuesta** | Lo aceptamos. Comprobamos las pestañas con un usuario de cada rol.             |

## Consulta 08 · Reglas de negocio

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                      |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Faltaban los cálculos del negocio.                                                                                                   |
| **Tarea**                        | Programar IGV, aprobación desde S/ 5,000, costo promedio ponderado, vencimiento, pago y validación de RUC.                           |
| **Restricciones**                | Que las pantallas no calculen nada; todo en un archivo aparte.                                                                       |
| **Formato esperado**             | ReglasCompra.swift, Formato.swift y una vista de verificación.                                                                       |
| **Qué hicimos con la respuesta** | Lo aceptamos y lo verificamos en el Preview contra los casos 3, 5, 6 y 11 (1,416.00; 7,080.00; 112.00; 115.56; 4,997.30 / 5,012.64). |

## Consulta 09 · Productos (B3) con foto

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                        |
|----------------------------------|--------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Reglas listas. Pedimos un diseño de app real.                                                          |
| **Tarea**                        | Lista de productos con stock en color, valor del inventario, búsqueda, formulario con foto y detalle.  |
| **Restricciones**                | \+ y borrar solo supervisor; borrado bloqueado si tiene compras.                                       |
| **Formato esperado**             | ProductosView, ProductoFormView, ProductoDetalleView y Estilo.                                         |
| **Qué hicimos con la respuesta** | Lo aceptamos. Más adelante lo ajustamos a la maqueta (valor del inventario abajo, iniciales en color). |

## Consulta 10 · Proveedores (B4)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                  |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Productos listos.                                                                                                                |
| **Tarea**                        | Lista de proveedores con insignia Por pagar / Al día y total comprado, formulario con RUC validado.                              |
| **Restricciones**                | Valores calculados desde las compras; .deny al borrar.                                                                           |
| **Formato esperado**             | ProveedoresView, ProveedorFormView, ProveedorDetalleView.                                                                        |
| **Qué hicimos con la respuesta** | Xcode mostró 'Cannot find LogoProveedor'. El archivo estaba completo; se resolvió limpiando la compilación (Clean Build Folder). |

## Consulta 11 · Nueva compra (B5)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                                                          |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Catálogo listo.                                                                                                                                                          |
| **Tarea**                        | Formulario de compra con resumen en vivo y envío a aprobación.                                                                                                           |
| **Restricciones**                | Botón 'Enviar a aprobación' desde S/ 5,000; guardar quién registró la compra.                                                                                            |
| **Formato esperado**             | NuevaCompraView.swift.                                                                                                                                                   |
| **Qué hicimos con la respuesta** | Lo aceptamos. Registramos 2 impresoras a S/ 650 al crédito: total 1,534.00, aprobada y por pagar. Agregamos 'Fecha de la factura' para poder probar el caso 8 (vencida). |

## Consulta 12 · Mis compras (B6)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                             |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Compras registrándose.                                                                                                      |
| **Tarea**                        | Lista de compras del comprador con filtro Todas / Pendientes / Rechazadas y motivo de rechazo.                              |
| **Restricciones**                | El comprador solo ve las suyas y no puede pagar (caso 9).                                                                   |
| **Formato esperado**             | MisComprasView y componentes de compra.                                                                                     |
| **Qué hicimos con la respuesta** | Lo aceptamos. Nos confundió ver 'Aprobada' en la lista y 'Por pagar' en el detalle; pedimos mostrar los dos estados juntos. |

## Consulta 13 · Aprobar (B7)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                               |
|----------------------------------|---------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Compras grandes quedaban pendientes.                                                                          |
| **Tarea**                        | Tarjeta de compra pendiente con vista previa de stock y costo antes y después; aprobar o rechazar con motivo. |
| **Restricciones**                | Motivo obligatorio; usar \#Predicate (Nivel +).                                                               |
| **Formato esperado**             | AprobarView.swift.                                                                                            |
| **Qué hicimos con la respuesta** | Lo aceptamos y entendimos que Aprobar queda vacío si las compras son menores a S/ 5,000.                      |

## Consulta 14 · Por pagar (B8)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                   |
|----------------------------------|---------------------------------------------------------------------------------------------------|
| **Contexto**                     | Compras al crédito aprobadas.                                                                     |
| **Tarea**                        | Lista Pendientes / Vencidas / Pagadas con deslizar Pagar y total por pagar.                       |
| **Restricciones**                | Solo compras aprobadas al crédito; solo el supervisor paga.                                       |
| **Formato esperado**             | PorPagarView.swift.                                                                               |
| **Qué hicimos con la respuesta** | Lo modificamos después de comparar con la maqueta: Pendientes ahora incluye también las vencidas. |

## Consulta 15 · Resumen (B9)

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                  |
|----------------------------------|--------------------------------------------------------------------------------------------------|
| **Contexto**                     | Todas las pantallas operativas.                                                                  |
| **Tarea**                        | Resumen con inventario, crédito fiscal, por pagar, por aprobar y total por proveedor con barras. |
| **Restricciones**                | Nivel Reto de la guía.                                                                           |
| **Formato esperado**             | ResumenView.swift.                                                                               |
| **Qué hicimos con la respuesta** | Lo aceptamos y luego lo ajustamos a la maqueta (4 tarjetas y barras por proveedor).              |

## Consulta 16 · Datos de demostración

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                            |
|----------------------------------|--------------------------------------------------------------------------------------------|
| **Contexto**                     | Para exponer necesitábamos un catálogo cargado.                                            |
| **Tarea**                        | Botón del supervisor que carga proveedores y productos de ejemplo.                         |
| **Restricciones**                | No duplicar datos; solo los productos que tienen foto.                                     |
| **Formato esperado**             | DatosDemo.swift + botón ⋯ en Resumen.                                                      |
| **Qué hicimos con la respuesta** | Lo modificamos: dejamos 7 productos (quitamos tóner y papel) porque solo teníamos 7 fotos. |

## Consulta 17 · Ícono, logo y pantalla de bienvenida

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                                                                            |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Contexto**                     | La guía pide ícono profesional con el nombre 'Compras'.                                                                                                    |
| **Tarea**                        | Generar el ícono de 1024 px, el logo y una pantalla de bienvenida.                                                                                         |
| **Restricciones**                | PNG cuadrado, sin transparencia ni esquinas redondeadas.                                                                                                   |
| **Formato esperado**             | AppIcon-1024.png, LogoCaja.png, SplashView.swift.                                                                                                          |
| **Qué hicimos con la respuesta** | Usamos el ícono generado. Para el logo pusimos nuestra propia imagen (caja con carrito). Corregimos la imagen que había quedado en 'Unassigned' en Assets. |

## Consulta 18 · Prompts para las fotos de productos

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                     |
|----------------------------------|-----------------------------------------------------------------------------------------------------|
| **Contexto**                     | Queríamos que el catálogo se vea real.                                                              |
| **Tarea**                        | Escribir prompts para generar las fotos de cada producto con fondo transparente.                    |
| **Restricciones**                | Mismo estilo en todas, sin marcas ni texto.                                                         |
| **Formato esperado**             | Un prompt por producto (laptop, monitor, mouse, teclado, router, switch, impresora).                |
| **Qué hicimos con la respuesta** | Generamos las imágenes con otra herramienta de IA, las agregamos a Assets con los nombres prod\_\*. |

## Consulta 19 · Corrección del mensaje de error del login

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                           |
|----------------------------------|-----------------------------------------------------------------------------------------------------------|
| **Contexto**                     | Al poner una clave incorrecta la clave se borraba pero no salía ningún mensaje.                           |
| **Tarea**                        | Encontrar por qué no aparecía 'Usuario o clave incorrectos'.                                              |
| **Restricciones**                | Mantener el caso de prueba 2.                                                                             |
| **Formato esperado**             | Cambio de una línea.                                                                                      |
| **Qué hicimos con la respuesta** | Lo aceptamos: el mensaje se borraba al limpiar la clave; ahora solo se quita cuando se vuelve a escribir. |

## Consulta 20 · Ajuste de las pantallas a la maqueta

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                                |
|----------------------------------|------------------------------------------------------------------------------------------------|
| **Contexto**                     | La rúbrica da puntos por pantallas fieles a la maqueta.                                        |
| **Tarea**                        | Comparar las 9 maquetas con la app y ajustar diseño y lógica.                                  |
| **Restricciones**                | No cambiar las reglas de negocio.                                                              |
| **Formato esperado**             | Archivos de las pantallas reemplazados.                                                        |
| **Qué hicimos con la respuesta** | Lo aceptamos. Mantuvimos nuestro color morado-azul del ícono en lugar del verde de la maqueta. |

## Consulta 21 · Todas las compras y seguimiento

Fecha: 17/11/2026 · Herramienta: Claude · Rama: ai-assisted

|                                  |                                                                                               |
|----------------------------------|-----------------------------------------------------------------------------------------------|
| **Contexto**                     | No se entendía el estado de una compra y el supervisor no podía 'ver todo'.                   |
| **Tarea**                        | Agregar la lista de todas las compras para el supervisor y una línea de tiempo en el detalle. |
| **Restricciones**                | Cumplir 'ver todo' de la guía; poder abrir el detalle desde cualquier lista.                  |
| **Formato esperado**             | TodasComprasView y cambios en el detalle.                                                     |
| **Qué hicimos con la respuesta** | Lo aceptamos.                                                                                 |
