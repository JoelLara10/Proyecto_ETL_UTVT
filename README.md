# Proyecto ETL UTVT — CargaVentas

## Comercializadora UTVT S.A. de C.V. — Sistema de Carga al Data Warehouse

---

## 📋 Descripción General

Este repositorio contiene el proyecto ETL desarrollado con **SQL Server Integration Services (SSIS)** para cargar datos de ventas desde archivos CSV hacia el Data Warehouse **DWUTVTVentas**. El proceso implementa limpieza, validación, transformación, cálculo de métricas y auditoría de errores.

---

## 🏗️ Arquitectura del Proyecto

```
Archivos CSV (Entrada)
       │
       ▼
┌─────────────────────────────────────────┐
│          SSIS — CargaVentas.dtsx        │
│                                         │
│  Control Flow:                          │
│  1. Registrar Inicio (LogProceso)       │
│  2. SEQ Carga Clientes → DimCliente    │
│  3. SEQ Carga Productos → DimProducto  │
│  4. SEQ Carga Ventas → FactVentas      │
│  5. Registrar Estadísticas             │
│  6. Mover archivos (procesados/)       │
│  7. Comprimir archivos (.zip)          │
└─────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────┐
│         SQL Server — DWUTVTVentas       │
│   DimCliente │ DimProducto │ FactVentas │
│   LogErrores │ LogProceso              │
└─────────────────────────────────────────┘
```

---

## 📁 Estructura del Repositorio

```
Proyecto_ETL_UTVT/
├── data/
│   ├── entrada/          ← Archivos CSV de origen
│   │   ├── Clientes.csv
│   │   ├── Productos.csv
│   │   └── Ventas.csv
│   ├── procesados/       ← Archivos después de carga exitosa
│   └── errores/          ← Archivos de registros rechazados
├── database/
│   └── create_DWUTVTVentas.sql   ← Script DDL completo
├── ssis/
│   └── CargaVentas.dtsx          ← Paquete SSIS
├── docs/
│   ├── Diagrama_ETL.pdf
│   ├── Arquitectura_Proyecto.pdf
│   └── Diccionario_Datos.xlsx
├── evidencias/
│   ├── capturas_ssis_video/
│   ├── capturas_sql/
│   └── capturas_git/
├── README.md
├── .gitignore
└── Release_1.0.txt
```

---

## 🗄️ Base de Datos: DWUTVTVentas

| Tabla | Descripción |
|---|---|
| `DimCliente` | Dimensión de clientes (sin duplicados, activos) |
| `DimProducto` | Dimensión de productos (categorías válidas, precio > 0) |
| `FactVentas` | Tabla de hechos con Subtotal, IVA y Total calculados |
| `LogErrores` | Auditoría de registros rechazados |
| `LogProceso` | Bitácora de ejecución del paquete |

---

## ✅ Reglas de Calidad de Datos

### Clientes
- Texto en MAYÚSCULAS y sin espacios innecesarios (TRIM)
- Solo clientes con `Activo = 1`
- Sin duplicados por `IdCliente`
- Campos nulos reemplazados por valores predeterminados

### Productos
- Solo categorías válidas: `Computo`, `Accesorios`, `Muebles`, `Redes`, `Almacenamiento`, `Infraestructura`
- `Precio > 0` y `Costo > 0`
- Solo productos con `Activo = 1`
- Sin duplicados por `IdProducto`

### Ventas
- `Cantidad > 0` y `PrecioUnitario > 0`
- `FechaVenta` no nula
- Cliente y Producto deben existir en sus dimensiones
- Sin duplicados por `IdVenta`
- Cálculos: `Subtotal = Cantidad × PrecioUnitario`, `IVA = Subtotal × 0.16`, `Total = Subtotal + IVA`

---

## ▶️ Instrucciones de Ejecución

### 1. Crear la base de datos
```sql
-- Ejecutar en SQL Server Management Studio:
-- database/create_DWUTVTVentas.sql
```

### 2. Configurar rutas en el paquete SSIS
Ajustar las variables en `CargaVentas.dtsx`:
| Variable | Valor |
|---|---|
| `RutaEntrada` | Ruta a `data/entrada/` |
| `RutaProcesado` | Ruta a `data/procesados/` |
| `RutaErrores` | Ruta a `data/errores/` |

### 3. Configurar Connection Managers
- `CM_DWUTVTVentas`: cadena de conexión a SQL Server local
- `CM_FF_Clientes`, `CM_FF_Productos`, `CM_FF_Ventas`: archivos CSV de entrada

### 4. Ejecutar el paquete
- Abrir `ssis/CargaVentas.dtsx` en SQL Server Data Tools (SSDT)
- Ejecutar con F5 o Deploy al SQL Server Agent

---

## 📊 Variables del Paquete

| Variable | Tipo | Propósito |
|---|---|---|
| `RutaEntrada` | String | Carpeta de archivos CSV origen |
| `RutaProcesado` | String | Carpeta de archivos procesados |
| `RutaErrores` | String | Carpeta de archivos de errores |
| `FechaProceso` | DateTime | Fecha y hora de ejecución |
| `TotalLeidos` | Int32 | Total de registros leídos |
| `TotalInsertados` | Int32 | Total de registros insertados |
| `TotalErrores` | Int32 | Total de registros rechazados |

---

## 🌿 Ramas de Desarrollo

| Rama | Descripción |
|---|---|
| `main` | Versión estable del proyecto |
| `feature/clientes` | Desarrollo del Data Flow de Clientes |
| `feature/productos` | Desarrollo del Data Flow de Productos |
| `feature/ventas` | Desarrollo del Data Flow de Ventas |

---

## 📦 Release

- **Release 1.0** — Primera versión funcional completa del proceso ETL

---

## 👤 Autor

- **Proyecto:** Examen Práctico — ETL con SSIS, SQL Server y Git
- **Empresa:** Comercializadora UTVT S.A. de C.V.
- **Materia:** Business Intelligence / Integración de Datos
