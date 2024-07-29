# README

## Consolidado de informacion que administra el sistema

### Tabla: Clientes

#### Valores de Entrada:

1. **DUI**: Documento Único de Identidad del cliente.
2. **Nombre Completo**: El nombre completo del cliente.

### Tabla: Medidores

#### Valores de Entrada:

1. **Cliente**: El cliente asociado al medidor.
2. **Medidor**: El identificador del medidor.
3. **Dirección**: La dirección donde está ubicado el medidor (opcional).
4. **Sector**: El sector donde está ubicado el medidor.
5. **Activo**: Indica si el medidor está activo (por defecto es verdadero).

### Tabla: Periodos

#### Valores de Entrada:

1. **Mes**: El mes del periodo.
2. **Año**: El año del periodo.
3. **Fecha de Asamblea**: La fecha de la asamblea relacionada con el periodo.

### Tabla: Facturas

#### Valores de Entrada:

1. **Medidor**: El medidor asociado a la factura.
2. **Periodo**: El periodo de facturación correspondiente.
3. **Cliente**: El cliente asociado a la factura (se asigna automáticamente si no se proporciona).
4. **Lectura Anterior (metros cúbicos)**: La lectura anterior del medidor en metros cúbicos.
5. **Lectura Actual (metros cúbicos)**: La lectura actual del medidor en metros cúbicos.
6. **Valor por Metro Cúbico**: El costo por cada metro cúbico de consumo.
7. **Fecha de Emisión**: La fecha en que se emite la factura.
8. **Fecha de Vencimiento**: La fecha límite para el pago de la factura.
9. **Fecha de Pago**: La fecha en que se realiza el pago (opcional).
10. **Monto Total Pagado**: El monto total pagado (opcional).
11. **Observaciones**: Comentarios adicionales sobre la factura (opcional).

#### Valores Calculados por el Sistema:

1. **Número de Factura**: Se genera automáticamente incrementando el último número de factura registrado.
2. **Consumo (metros cúbicos)**: Calculado como la diferencia entre la lectura actual y la lectura anterior.
3. **Cargo Total**: Calculado multiplicando el consumo en metros cúbicos por el valor por metro cúbico.
4. **Recargo Después de Vencimiento**: Calculado como el 5% del cargo total.
5. **Cuota Social Pendiente**: Se establece en 0 si no se proporciona.
6. **Cargo Total Facturas Pendientes**: Se establece en 0 si no se proporciona.
7. **Cargo Total Después de Vencimiento**: Calculado sumando el cargo total, el recargo después de vencimiento y el cargo total de facturas pendientes.