/*
 * 
 *                    Descripcion : Creacion del Datawarehouse de Northwind 
 *
 *                    Fecha de Creacion : Sabado, 25/06/2023 05:13 p.m
 *
 *                         Autores: Rodrigo Joao Lopez Marenco
 *                                  Josefina del Carmen Lopez Cruz
 *                                  Obeth Joshua Aburto Lopez
 *                            Facultad de Ciencias e Ingenieria 
 *                            Estudiantes de Ingenieria de Sistemas
 */
 USE master
GO
IF DB_ID('DWNorthwind') IS NOT NULL
BEGIN
     ALTER DATABASE  DWNorthwind SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  DROP DATABASE DWNorthwind
END
GO
CREATE DATABASE DWNorthwind
GO
USE DWNorthwind
GO
/* 
 * TABLE: Dimension_Customers 
 */



CREATE TABLE Dimension_Customer(
     Cod_Id         int             IDENTITY(1,1),
    CustomerID     nchar(10)       NOT NULL,
    CompanyName    nvarchar(50)    NOT NULL,
    ContactName    nvarchar(50)    NULL,
    City           nvarchar(50)    NULL,
    Country        nvarchar(50)    NULL,
	Fecha_Inicial Datetime NOT NULL,
    Fecha_Final Datetime NOT NULL
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (Cod_Id)
)
go



IF OBJECT_ID('Dimension_Customer') IS NOT NULL
    PRINT '<<< CREATED TABLE Dimension_Customer >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Dimension_Customer >>>'
go

/* 
 * TABLE: Dimension_Employees 
 */

CREATE TABLE Dimension_Employees(
    E_Id           int             IDENTITY(1,1),
    EmployeeID     int             NOT NULL,
    LastName       nvarchar(50)    NOT NULL,
    FirstName      nvarchar(50)    NOT NULL,
    Title          nvarchar(50)    NOT NULL,
    Territories    nvarchar(50)    NOT NULL,
	Fecha_Inicial Datetime NOT NULL,
    Fecha_Final Datetime NOT NULL
     CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (E_Id)
)
go



IF OBJECT_ID('Dimension_Employees') IS NOT NULL
    PRINT '<<< CREATED TABLE Dimension_Employees >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Dimension_Employees >>>'
go

/* 
 * TABLE: Dimension_Products 
 */

CREATE TABLE Dimension_Products(
   P_Id              int             IDENTITY(1,1),
    ProductID         int             NOT NULL,
    ProductName       nvarchar(50)    NOT NULL,
    UnitPrice         money           NOT NULL,
    [Units in Stock]  smallint        NOT NULL,
    Discontinued      bit             NOT NULL,
	Fecha_Inicial Datetime NOT NULL,
    Fecha_Final Datetime NOT NULL
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (P_Id)
)

go



IF OBJECT_ID('Dimension_Products') IS NOT NULL
    PRINT '<<< CREATED TABLE Dimension_Products >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Dimension_Products >>>'
go

/* 
 * TABLE: Dimension_Tiempo 
 */

CREATE TABLE Dimension_Tiempo(
   FechaKey     int         NOT NULL,
    Fecha        datetime    NOT NULL,
    Año          smallint    NOT NULL,
    Semestre     smallint    NOT NULL,
    Trimestre    smallint    NOT NULL,
    Mes          smallint    NOT NULL,
    Semana       smallint    NOT NULL,
    Dia          smallint    NOT NULL,
    DiaSemana    smallint    NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY NONCLUSTERED (FechaKey)
)
go



IF OBJECT_ID('Dimension_Tiempo') IS NOT NULL
    PRINT '<<< CREATED TABLE Dimension_Tiempo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Dimension_Tiempo >>>'
go

/* 
 * TABLE: Hechos_Sales 
 */

CREATE TABLE Hechos_Sales(
    Cod_Id        int               NOT NULL,
    E_Id          int               NOT NULL,
    P_Id          int               NOT NULL,
    FechaKey      int               NOT NULL,
    Quantity      numeric(10, 0)    NOT NULL,
    UnitPrice     numeric(10, 0)    NOT NULL,
    TotalPrice    numeric(10, 0)    NOT NULL
)
go



IF OBJECT_ID('Hechos_Sales') IS NOT NULL
	PRINT '<<< CREATED TABLE Hechos_Sales >>>'
ELSE
	PRINT '<<< FAILED CREATING TABLE Hechos_Sales >>>'
go

/* 
 * TABLE: Hechos_Sales 
 */

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Customer1 
    FOREIGN KEY (Cod_Id)
    REFERENCES Dimension_Customer(Cod_Id)
go

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Employees2 
    FOREIGN KEY (E_Id)
    REFERENCES Dimension_Employees(E_Id)
go

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Products3 
    FOREIGN KEY (P_Id)
    REFERENCES Dimension_Products(P_Id)
go

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Tiempo4 
    FOREIGN KEY (FechaKey)
    REFERENCES Dimension_Tiempo(FechaKey)
go



go

