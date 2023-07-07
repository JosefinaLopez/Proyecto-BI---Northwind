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


use DWNorthwind
GO

/*Ojo ejecutar esto primero para poder hacer el llenado*/

Exec SYS.sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
Exec SYS.sp_MSforeachtable 'ALTER TABLE ? DISABLE TRIGGER ALL'
GO
EXEC SYS.SP_MSFOREACHTABLE 
			'
			BEGIN TRY
				 SET QUOTED_IDENTIFIER ON
				 TRUNCATE TABLE ?
			END TRY
			BEGIN CATCH
				DELETE FROM ?
			END CATCH;'
GO

INSERT INTO Dimension_Employees
SELECT
LastName,
FirstName,
Title,
t.TerritoryDescription
FROM Northwind.dbo.Employees e
INNER JOIN Northwind.dbo.EmployeeTerritories et ON et.EmployeeID = e.EmployeeID
INNER JOIN Northwind.dbo.Territories t ON t.TerritoryID = et.TerritoryID
GO

SELECT *FROM Dimension_Employees
GO

INSERT INTO Dimension_Customers(Cod_Id,CompanyName,ContactName,City,Country,PostalCode)
Select c.CustomerID,
c.CompanyName,
c.ContactName,
c.City,
c.Country,
c.PostalCode
From Northwind.dbo.Customers c
WHERE c.PostalCode IS NOT NULL
GO
Select*from Dimension_Customers
GO


DECLARE @FechaDesde as datetime, @FechaHasta as datetime
DECLARE @FechaAAAAMMDD int
DECLARE @Año as smallint,@Semestre as smallint, @Trimestre smallint, @Mes smallint
DECLARE @Semana smallint, @Dia smallint, @DiaSemana smallint
SET DATEFORMAT dmy
SET LANGUAGE SPANISH
BEGIN TRANSACTION
    --TRUNCATE TABLE FROM DI_TIEMPO
   
    --RAngo de fechas a generar: del 01/01/1996 al 31/12/Año actual+2
    SELECT @FechaDesde = CAST('19960101' AS Datetime)
    SELECT @FechaHasta = CAST(CAST(YEAR(GETDATE())+2 AS CHAR(4)) + '1231' AS datetime)
   
    WHILE (@FechaDesde <= @FechaHasta) BEGIN
    SELECT @FechaAAAAMMDD = YEAR(@FechaDesde)*10000+
                            MONTH(@FechaDesde)*100+
                            DATEPART(dd, @FechaDesde)
    SELECT @Año = DATEPART(yy, @FechaDesde)
	SELECT @Semestre=MONTH(GETDATE())/6+1 
    SELECT @Trimestre = DATEPART(qq, @FechaDesde)
    SELECT @Mes = DATEPART(m, @FechaDesde)
    SELECT @Semana = DATEPART(wk, @FechaDesde)
    SELECT @Dia = RIGHT('0' + DATEPART(dd, @FechaDesde),2)
    SELECT @DiaSemana = DATEPART(DW, @FechaDesde)
	 INSERT INTO dbo.Dimension_Tiempo
    (
        FECHAKEY,
        Fecha,
        Año,
		Semestre,
        Trimestre,
        Mes,
        Semana,
        Dia,
        DiaSemana)
		 VALUES
    (
        @FechaAAAAMMDD,
        @FechaDesde,
        @Año,
		@Semestre,
        @Trimestre,
        @Mes,
        @Semana,
        @Dia,
        @DiaSemana)
		--Incremento del bucle
    SELECT @FechaDesde = DATEADD(DAY, 1, @FechaDesde)
    END
    COMMIT TRANSACTION
GO
SELECT *FROM Dimension_Tiempo
GO


INSERT INTO Dimension_Products
SELECT
p.ProductName,
p.UnitPrice,
p.UnitsInStock,
p.Discontinued
FROM Northwind.dbo.Products p
GO

SELECT *FROM Dimension_Products

INSERT INTO Hechos_Sales (Employee_Id, Product_Id, FechaKey, Customers_Id, Quantity, UnitPrice, TotalPrice)
SELECT
    DE.Employee_Id,
    P.ProductID,
    DT.FechaKey,
    DC.Customers_Id,
    OD.Quantity,
    P.UnitPrice,
    OD.Quantity * P.UnitPrice AS TotalPrice
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] OD ON o.OrderID = OD.OrderID
INNER JOIN Northwind.dbo.Products P ON OD.ProductID = P.ProductID
INNER JOIN Dimension_Employees DE ON o.EmployeeID = DE.Employee_Id
INNER JOIN Dimension_Tiempo DT ON DT.Fecha = o.RequiredDate
INNER JOIN Dimension_Customers DC ON o.CustomerID = DC.Cod_Id
GO
SELECT *FROM Hechos_Sales


/*OJO Ejecute despues de llenar el DW*/
EXEC SYS.SP_MSFOREACHTABLE 'ALTER TABLE ? CHECK CONSTRAINT ALL'
GO
EXEC SYS.SP_MSFOREACHTABLE 'ALTER TABLE ? ENABLE TRIGGER ALL'
GO