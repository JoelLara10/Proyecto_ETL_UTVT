-- ============================================================
-- Script de creación de la base de datos DWUTVTVentas
-- Comercializadora UTVT S.A. de C.V.
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DWUTVTVentas')
BEGIN
    CREATE DATABASE DWUTVTVentas;
END
GO

USE DWUTVTVentas;
GO

-- ============================================================
-- 1. DimCliente
-- ============================================================
IF OBJECT_ID('dbo.DimCliente', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimCliente (
        IdClienteSK      INT IDENTITY(1,1) PRIMARY KEY,
        IdClienteOrigen  INT NOT NULL,
        Nombre           VARCHAR(100) NOT NULL,
        Apellido         VARCHAR(100) NOT NULL,
        Correo           VARCHAR(150) NULL,
        Telefono         VARCHAR(20)  NULL,
        Ciudad           VARCHAR(100) NULL,
        Estado           VARCHAR(100) NULL,
        Pais             VARCHAR(100) NULL,
        FechaRegistro    DATE         NULL,
        FechaCarga       DATETIME     NOT NULL DEFAULT GETDATE()
    );
END
GO

-- ============================================================
-- 2. DimProducto
-- ============================================================
IF OBJECT_ID('dbo.DimProducto', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DimProducto (
        IdProductoSK     INT IDENTITY(1,1) PRIMARY KEY,
        IdProductoOrigen INT NOT NULL,
        NombreProducto   VARCHAR(150) NOT NULL,
        Categoria        VARCHAR(100) NOT NULL,
        Precio           DECIMAL(12,2) NOT NULL,
        Costo            DECIMAL(12,2) NOT NULL,
        FechaCarga       DATETIME     NOT NULL DEFAULT GETDATE()
    );
END
GO

-- ============================================================
-- 3. FactVentas
-- ============================================================
IF OBJECT_ID('dbo.FactVentas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FactVentas (
        IdVentaSK        INT IDENTITY(1,1) PRIMARY KEY,
        IdVentaOrigen    INT NOT NULL,
        IdClienteSK      INT NOT NULL REFERENCES dbo.DimCliente(IdClienteSK),
        IdProductoSK     INT NOT NULL REFERENCES dbo.DimProducto(IdProductoSK),
        Cantidad         INT NOT NULL,
        PrecioUnitario   DECIMAL(12,2) NOT NULL,
        Subtotal         DECIMAL(12,2) NOT NULL,
        IVA              DECIMAL(12,2) NOT NULL,
        Total            DECIMAL(12,2) NOT NULL,
        FechaVenta       DATE         NOT NULL,
        Sucursal         VARCHAR(100) NULL,
        FechaCarga       DATETIME     NOT NULL DEFAULT GETDATE()
    );
END
GO

-- ============================================================
-- 4. LogErrores
-- ============================================================
IF OBJECT_ID('dbo.LogErrores', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LogErrores (
        IdError           INT IDENTITY(1,1) PRIMARY KEY,
        NombrePaquete     VARCHAR(100) NOT NULL,
        NombreFlujo       VARCHAR(100) NOT NULL,
        ArchivoOrigen     VARCHAR(150) NOT NULL,
        FilaOrigen        VARCHAR(MAX) NULL,
        DescripcionError  VARCHAR(500) NOT NULL,
        FechaError        DATETIME     NOT NULL DEFAULT GETDATE()
    );
END
GO

-- ============================================================
-- 5. LogProceso
-- ============================================================
IF OBJECT_ID('dbo.LogProceso', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LogProceso (
        IdProceso          INT IDENTITY(1,1) PRIMARY KEY,
        NombrePaquete      VARCHAR(100) NOT NULL,
        FechaInicio        DATETIME     NOT NULL,
        FechaFin           DATETIME     NULL,
        DuracionSegundos   INT          NULL,
        TotalLeidos        INT          NULL,
        TotalInsertados    INT          NULL,
        TotalErrores       INT          NULL,
        Estatus            VARCHAR(50)  NOT NULL,
        Mensaje            VARCHAR(500) NULL
    );
END
GO

-- ============================================================
-- Índices para evitar duplicados en cargas repetidas
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_DimCliente_Origen')
    CREATE UNIQUE INDEX UQ_DimCliente_Origen  ON dbo.DimCliente(IdClienteOrigen);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_DimProducto_Origen')
    CREATE UNIQUE INDEX UQ_DimProducto_Origen ON dbo.DimProducto(IdProductoOrigen);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UQ_FactVentas_Origen')
    CREATE UNIQUE INDEX UQ_FactVentas_Origen  ON dbo.FactVentas(IdVentaOrigen);
GO

PRINT 'Base de datos DWUTVTVentas creada correctamente.';
