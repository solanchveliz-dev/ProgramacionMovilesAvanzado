# ACTIVIDAD PROPUESTA 01: FACTURA DE CURSOS

## 1. Descripción

El programa permitirá generar una factura por la compra de cursos. Para ello, almacenará los datos del estudiante y los cursos adquiridos, calculará el subtotal, el IGV, los descuentos correspondientes y el total final que deberá pagar el estudiante.

---

## 2. Requerimientos funcionales

### RF01: Registrar los datos del estudiante

El sistema deberá almacenar los siguientes datos del estudiante:

- Nombre completo.
- DNI.
- Condición de alumno de Tecsup.

### RF02: Registrar los datos de un curso

El sistema deberá almacenar los siguientes datos de cada curso:

- Nombre del curso.
- Precio unitario.
- Cantidad adquirida.

### RF03: Registrar varios cursos

El sistema deberá permitir almacenar uno o más cursos dentro de un arreglo.

### RF04: Calcular el total de cada curso

El sistema deberá multiplicar el precio del curso por la cantidad adquirida.

**Fórmula:**

```text
Total del curso = Precio × Cantidad
