# Prompts utilizados — Laboratorio 04

## Herramienta de IA utilizada

ChatGPT

## Caso 2B — Biblioteca

### Prompt 1:

Soy estudiante de Swift de la cuarta semana y trabajo en un Playground de Xcode.

Necesito una biblioteca con enum EstadoLibro, struct Libro y class Biblioteca con los métodos agregar, prestar, devolver e inventario.

Utiliza solamente struct, class, herencia, protocolos, enums, arrays, bucles y funciones. No utilices optionals, guard let, firstIndex(where:), didSet, propiedades calculadas ni genéricos.

Recorre el arreglo por índice mediante for i in 0..<libros.count y utiliza switch para mostrar el estado de los libros.

Entrega solamente código Swift, con las firmas exactas que se indican en el ejercicio y con un comentario en cada línea explicando lo que hace.

La salida debe ser idéntica a la salida esperada de la Parte A.

### Respuesta de la IA:

La IA generó un programa completo en Swift con el enum EstadoLibro, el struct Libro y la class Biblioteca. También implementó los métodos para agregar, prestar, devolver y mostrar el inventario. El arreglo se recorrió mediante índices y se utilizó switch para mostrar el estado de cada libro.

### ¿Funcionó a la primera?

Sí, el programa compiló y mostró los resultados solicitados. Swift presentó advertencias porque inicialmente no se utilizaban los valores Bool devueltos por prestar(titulo:) y devolver(titulo:), pero estas advertencias no impedían la ejecución.

Para corregirlas, se utilizó "_ =" antes de las llamadas a los métodos.

### ¿Usó algo que no hemos visto en clase?

Sí, utilizó "_ =" antes de algunas llamadas:

_ = biblioteca.prestar(titulo: "El Quijote")

La IA explicó que sirve para ejecutar la función e ignorar intencionalmente el valor Bool que devuelve. No fue necesario reemplazarlo porque no cambia la lógica ni el resultado del programa.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?

La IA agregó comentarios más detallados para explicar el funcionamiento del código. También utilizó "_ =" para evitar las advertencias generadas al ignorar los valores Bool devueltos por los métodos prestar y devolver.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?

Al principio no comprendía completamente esta línea:

_ = biblioteca.prestar(titulo: "La ciudad y los perros")

Luego entendí que ejecuta el método, pero ignora intencionalmente el resultado Bool.

### ¿Qué me pareció mejor de mi versión?

Mi versión me permitió practicar personalmente el recorrido del arreglo por índices y comprender cómo se cambia directamente el estado de un libro dentro del arreglo.

### ¿Qué me pareció mejor de la versión de la IA?

La versión de la IA tiene comentarios más detallados y organiza claramente el enum, el struct, la clase, los métodos y la simulación.
