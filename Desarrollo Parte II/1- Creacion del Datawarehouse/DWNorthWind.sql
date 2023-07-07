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

CREATE DATABASE DWNorthwind
GO

USE DWNorthwind
go
/* 
	* TABLE: Dimension_Customers 
	*/

CREATE TABLE Dimension_Customers(
	Customers_Id    int            IDENTITY(1,1),
    Cod_Id          varchar(5)     NOT NULL,
    CompanyName     varchar(50)    NOT NULL,
    ContactName     varchar(50)    NOT NULL,
    City            varchar(50)    NOT NULL,
    Country         varchar(50)    NOT NULL,
    PostalCode      varchar(10)    NOT NULL,
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (Customers_Id)
)
go



IF OBJECT_ID('Dimension_Customers') IS NOT NULL
	PRINT '<<< CREATED TABLE Dimension_Customers >>>'
ELSE
	PRINT '<<< FAILED CREATING TABLE Dimension_Customers >>>'
go

/* 
	* TABLE: Dimension_Employees 
	*/

CREATE TABLE Dimension_Employees(
	Employee_Id    int            IDENTITY(1,1),
    LastName       varchar(50)    NOT NULL,
    FirstName      varchar(50)    NOT NULL,
    Title          varchar(50)    NOT NULL,
    Territories    varchar(50)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (Employee_Id)
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
	Product_Id        int               IDENTITY(1,1),
    ProductName       varchar(50)       NOT NULL,
    UnitPrice         numeric(10, 2)    NOT NULL,
    [Units in Stock]  int               NOT NULL,
    Discontinued      bit               NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (Product_Id)
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
	FechaKey     int              NOT NULL,
    Fecha        datetime         NOT NULL,
    Año          smallint         NOT NULL,
    Semestre     smallint         NOT NULL,
    Trimestre    smallint         NOT NULL,
    Mes          smallint         NOT NULL,
    Semana       smallint         NOT NULL,
    Dia          smalldatetime    NOT NULL,
    DiaSemana    smallint         NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY NONCLUSTERED (FechaKey)
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
    Employee_Id     int         NOT NULL,
    Product_Id      int         NOT NULL,
    FechaKey        int         NOT NULL,
    Customers_Id    int         NOT NULL,
	Quantity        NUMERIC       (10,0) NOT NULL,
    UnitPrice       NUMERIC       (10,0) NOT NULL, 
    TotalPrice      NUMERIC       (10,0) NOT NULL
)
GO


IF OBJECT_ID('Hechos_Sales') IS NOT NULL
	PRINT '<<< CREATED TABLE Hechos_Sales >>>'
ELSE
	PRINT '<<< FAILED CREATING TABLE Hechos_Sales >>>'
go

/* 
 * TABLE: Hechos_Sales 
 */

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Employees2 
    FOREIGN KEY (Employee_Id)
    REFERENCES Dimension_Employees(Employee_Id)
go

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Products3 
    FOREIGN KEY (Product_Id)
    REFERENCES Dimension_Products(Product_Id)
go

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Tiempo4 
    FOREIGN KEY (FechaKey)
    REFERENCES Dimension_Tiempo(FechaKey)
go

ALTER TABLE Hechos_Sales ADD CONSTRAINT RefDimension_Customers5 
    FOREIGN KEY (Customers_Id)
    REFERENCES Dimension_Customers(Customers_Id)
go

