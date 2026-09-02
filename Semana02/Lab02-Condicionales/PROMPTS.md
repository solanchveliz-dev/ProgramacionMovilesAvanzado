# Prompts utilizados – Laboratorio 02

## Herramienta de IA utilizada
ChatGPT

## Ejercicio 6 – Carrito mejorado

### Prompt (estructura CTRFE):

CONTEXTO:
Estoy desarrollando un laboratorio de Swift en un Playground de Xcode.
Ya tengo un carrito de compras con 5 productos, sus precios y cantidades.
También calculo subtotales, descuento general, categoría del cliente, IGV y total final.

TAREA:
Mejora mi carrito de compras agregando estas funcionalidades:
1. Si se compran 3 o más unidades del mismo producto, aplicar 5% de descuento extra a ese producto.
2. Si el cupón ingresado es "DESCUENTO20", aplicar 20% adicional al total.
3. Si el total supera S/. 3000, el envío debe ser gratis; de lo contrario cuesta S/. 25.
4. Por cada S/. 100 de compra, el cliente gana 1 punto de fidelidad.
5. Si algún precio es negativo o alguna cantidad es 0, mostrar un mensaje de error.

RESTRICCIONES:
Usa Swift básico.
Utiliza if, else if y else.
No uses funciones avanzadas que todavía no hemos aprendido.
Mantén los mismos 5 productos del carrito original.
Cada línea de código generada debe tener un comentario específico explicando qué hace.
No uses comentarios genéricos como "calcula algo".

FORMATO:
Entrega el código completo listo para copiar en un Swift Playground.
Los comentarios deben estar en español y colocados junto a cada línea o inmediatamente encima de ella.

EJEMPLO:
Si la cantidad de USB Cable es 3, debe aplicarse el 5% de descuento adicional únicamente al subtotal de USB Cable.
Si el cupón es "DESCUENTO20", debe aplicarse después el descuento correspondiente al total.

### ¿Funcionó a la primera?
Sí. El código ejecutó correctamente y mostró los descuentos, el envío gratis, el IGV, el total final y los puntos de fidelidad.

### ¿La IA usó algo que no conocías?
Sí. Revisé por qué se usa 0.95 para aplicar un descuento de 5% y 0.80 para aplicar un descuento de 20%.

## Ejercicio 7 – Juego de adivinanza

### Prompt (estructura CTRFE):

CONTEXTO:
Estoy desarrollando el Ejercicio 7 del Laboratorio 02 de Swift en un Playground de Xcode.
El ejercicio debe ser un juego sencillo de adivinanza de números y está permitido usar IA.

TAREA:
Genera un programa en Swift que tenga un número secreto fijo y simule exactamente 5 intentos usando variables.
El programa debe recorrer los intentos con un ciclo while.
En cada intento debe comparar el número con el número secreto y mostrar:
- "Muy bajo" si el intento es menor que el número secreto.
- "Muy alto" si el intento es mayor que el número secreto.
- "¡Correcto!" si el intento es igual al número secreto.
También debe contar cuántos intentos se necesitaron.
Si después de 5 intentos no se adivina, debe mostrar:
"Perdiste. El número era: X"

RESTRICCIONES:
Usa Swift básico.
Debes usar while.
Simula los intentos usando variables como intento1, intento2, intento3, intento4 e intento5.
No uses funciones avanzadas ni entrada por teclado.
Cada línea del código generado debe tener un comentario específico explicando qué hace.
Los comentarios deben explicar especialmente las comparaciones <, > y ==.

FORMATO:
Entrega el código completo listo para copiar en un Swift Playground.
Escribe los comentarios en español y colócalos antes de cada línea o instrucción.

EJEMPLO:
Si el número secreto es 42 y un intento vale 20, debe mostrar "Muy bajo".
Si un intento vale 50, debe mostrar "Muy alto".
Si un intento vale 42, debe mostrar "¡Correcto!".

### ¿Funcionó a la primera?
Sí. El programa recorrió los intentos con while, mostró "Muy bajo", "Muy alto" y "¡Correcto!" según cada comparación y contó correctamente los intentos.

### ¿La IA usó algo que no conocías?
No. Ya conocía las comparaciones con <, > y ==, pero reforcé cómo combinarlas con un while y una variable Bool para detener el ciclo cuando se adivina el número.
