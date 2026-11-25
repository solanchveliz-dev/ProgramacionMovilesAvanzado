# Laboratorio Semana 13 – Consumir API desde una aplicación (SwiftUI)

**Curso:** Programación en Móviles Avanzados – Tecsup
**API:** https://jsonplaceholder.typicode.com/users
**Arquitectura:** MVVM (Models / ViewModels / View)

| Carpeta | Contenido |
|---|---|
| `Actividad01_Semana13_API` | GET de usuarios + filtro de búsqueda |
| `Actividad02_Semana13_MetodosAPI` | CRUD: GET, POST, PUT, DELETE con `dataTask` |
| `Actividad03_Semana13_AsyncAwait` | Mismo CRUD migrado a `async/await` con `URLSession.shared.data` |

## Nota sobre la guía
En la Actividad 02, paso 2, la guía repetía la imagen del POST y dejaba `// TO DO`
en lugar del método **PUT**. Se implementó `updateUser(user:)` siguiendo el mismo
patrón (`URLRequest` + `httpMethod = "PUT"` + `JSONEncoder` + `dataTask`).

## Mejoras de diseño (Actividades 02 y 03)
- Avatar circular con iniciales y degradado.
- Barra de búsqueda con ícono y contador de resultados.
- Botón "Agregar Usuario" destacado; formulario con secciones, íconos, botón Cancelar y validación.
- JSONPlaceholder siempre devuelve `id = 11` al crear: se asigna un id local único para evitar ids repetidos en la lista.

Ver `COMANDOS.md` para subir el proyecto a GitHub y abrirlo en Xcode.
