# ACTIVIDAD PROPUESTA 02: GESTIÓN DE CLIENTES

## 1. Descripción

El programa permitirá representar y mostrar la información de diferentes tipos de clientes de una entidad bancaria. Se trabajará con clientes naturales y jurídicos aplicando clases, herencia, sobrescritura de métodos y polimorfismo en Swift.

---

## 2. Requerimientos funcionales

### RF01: Registrar datos generales del cliente

El sistema deberá almacenar los siguientes datos comunes:

- Código del cliente.
- Dirección.
- Fecha de registro.
- Número de cuenta.
- Monto mínimo de apertura.

### RF02: Registrar un cliente natural

El sistema deberá permitir crear un cliente natural con los siguientes datos específicos:

- Nombre completo.
- DNI.
- Datos generales heredados de la clase `Cliente`.

### RF03: Registrar un cliente jurídico

El sistema deberá permitir crear un cliente jurídico con los siguientes datos específicos:

- Razón social.
- RUC.
- Representante legal.
- Datos generales heredados de la clase `Cliente`.

### RF04: Mostrar los datos generales

El sistema deberá mostrar el código, dirección, fecha de registro, número de cuenta y monto mínimo de apertura de cada cliente.

### RF05: Mostrar los datos del cliente natural

El sistema deberá mostrar el nombre completo y DNI del cliente natural, además de sus datos generales.

### RF06: Mostrar los datos del cliente jurídico

El sistema deberá mostrar la razón social, RUC y representante legal del cliente jurídico, además de sus datos generales.

### RF07: Mostrar el monto con dos decimales

El sistema deberá presentar el monto mínimo de apertura en soles y con dos cifras decimales.

Ejemplo:

```text
Monto mínimo de apertura: S/ 500.00
