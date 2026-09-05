# Prompts utilizados – Laboratorio 03

## Herramienta de IA utilizada

ChatGPT


## Ejercicio 6 – Gestión de notas

### Prompt (estructura CTRFE):

CONTEXTO:

Estoy realizando el Laboratorio 03 de Swift.

En esta semana estamos aprendiendo sobre colecciones,
como arrays y diccionarios.


TAREA:

Ayúdame a realizar un programa para registrar las notas
de varios alumnos.

Primero quiero que el programa me pregunte cuántos alumnos
voy a registrar.

Dependiendo de la cantidad que coloque, debe pedirme:

- El nombre del alumno.
- La primera nota.
- La segunda nota.
- La tercera nota.

Los nombres y las notas deben guardarse en un diccionario
`[String: [Double]]`.

Después necesito que calcule el promedio de cada alumno.

Usando `switch`, debe indicar si el alumno está:

- Excelente.
- Bueno.
- Aprobado.
- Desaprobado.

También necesito que al final muestre:

1. El promedio general.
2. La nota más alta.
3. La nota más baja.
4. El porcentaje de alumnos aprobados.
5. Los alumnos ordenados de mayor a menor promedio.


RESTRICCIONES:

Usa solamente temas de Swift que hemos aprendido
hasta la semana 3.

No uses `struct` ni `class`.

Puedes utilizar:

- Arrays.
- Diccionarios.
- `if` y `else`.
- `for`.
- `switch`.

Cada línea del código debe tener un comentario específico
que explique qué está haciendo.


FORMATO:

Dame el código completo para ejecutarlo en un
Swift Playground.

Al inicio coloca:

`// Desarrollado por: Naomi Veliz`

Los comentarios deben estar en español y ser fáciles
de entender.

Los resultados deben mostrarse de forma ordenada
en la consola.


EJEMPLO:

Si indico que quiero registrar 3 alumnos, el programa
debe pedirme los datos de esos 3 alumnos.

Por ejemplo:

- Ana: 18, 19 y 17.
- Luis: 15, 14 y 16.
- Pedro: 10, 12 y 11.

Al finalizar quiero ver el promedio de cada alumno,
su clasificación y las estadísticas generales.

También quiero ver a los alumnos ordenados desde
el mayor promedio hasta el menor.


### ¿Funcionó a la primera?

Sí.

El programa permitió registrar los alumnos y sus notas.

También mostró los promedios, las clasificaciones,
las estadísticas y el orden de los alumnos.


### ¿La IA usó algo que no conocías?

Sí.

No tenía muy claro cómo guardar varias notas de cada
alumno dentro de un diccionario.

Con este ejercicio entendí mejor cómo funciona
`[String: [Double]]`.


## Ejercicio 7 – Inventario con menú

### Prompt (estructura CTRFE):

CONTEXTO:

Estoy realizando el Laboratorio 03 de Swift.

En esta semana estamos trabajando con colecciones
y ahora necesito realizar un ejercicio de inventario.


TAREA:

Ayúdame a crear un programa que primero me pregunte
cuántos productos quiero registrar.

Por cada producto debe pedirme:

- Nombre.
- Precio.
- Stock.

Después de registrar los productos quiero que aparezca
un menú con estas opciones:

1. Ver inventario.
2. Buscar producto.
3. Ver productos con stock bajo.
4. Calcular el valor total del inventario.
5. Salir.

Quiero que el menú siga apareciendo utilizando `while`
hasta que seleccione la opción 5.

Cuando busque un producto debe mostrar su precio
y su stock.

Si el producto no existe, debe indicar que no fue
encontrado.

Para el stock bajo considera los productos que tengan
menos de 5 unidades.

Para calcular el valor total del inventario debe
multiplicar el precio de cada producto por su stock.

Después debe sumar los resultados para obtener
el valor total.


RESTRICCIONES:

Usa solamente los temas de Swift que hemos aprendido
hasta la semana 3.

No uses `struct` ni `class`.

Puedes utilizar:

- Diccionarios.
- `if` y `else`.
- `for`.
- `while`.
- `switch`.

Cada línea del código debe tener un comentario específico
que explique qué está haciendo.


FORMATO:

Dame el código completo para ejecutarlo en un
Swift Playground.

Al inicio coloca:

`// Desarrollado por: Naomi Veliz`

Los comentarios deben estar en español y ser fáciles
de entender.

El menú y los resultados deben mostrarse de manera
ordenada en la consola.


EJEMPLO:

Si registro estos productos:

- Laptop: precio S/. 2500 y stock 3.
- Mouse: precio S/. 50 y stock 10.

Al seleccionar ver inventario deben aparecer
los dos productos.

Si selecciono productos con stock bajo debe aparecer
Laptop porque tiene menos de 5 unidades.

Si busco Mouse debe mostrar su precio y su stock.

Al calcular el valor total debe considerar el precio
y el stock de cada producto.


### ¿Funcionó a la primera?

No.

Al ejecutarlo apareció un error relacionado con
`String(format:)`.

Después agregué `import Foundation` y el programa
pudo ejecutarse correctamente.


### ¿La IA usó algo que no conocías?

Sí.

No sabía que necesitaba `import Foundation` para usar
`String(format:)`.

También entendí mejor cómo utilizar diccionarios para
guardar los precios y stocks de los productos.
