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

INSERT INTO Dimension_Customers (Customers_Id, CompanyName, ContactName, City, Country, PostalCode)
SELECT c.CustomerID, 
c.CompanyName, 
c.ContactName, 
c.City, 
c.Country, 
c.PostalCode
FROM Northwind.dbo.Customers c
WHERE c.PostalCode IS NOT NULL
GO

SELECT *FROM Dimension_Customers
GO

INSERT INTO Dimension_Tiempo
SELECT
o.OrderDate,
DATEPART(YEAR, o.OrderDate) AS Año,
DATEPART(QUARTER, o.OrderDate) AS Semestre,
CEILING(DATEPART(MONTH, o.OrderDate) / 3.0) AS Trimestre,
DATEPART(MONTH, o.OrderDate) AS Mes ,
DATEPART(WEEK, o.OrderDate) AS Semana,
DATEPART(DAY, o.OrderDate) AS Día ,
DATEPART(WEEKDAY, o.OrderDate) AS DíaDeSemana 
FROM Northwind.dbo.Orders o
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

INSERT INTO Hechos_Sales
SELECT
    o.RequiredDate,
    o.CustomerID,
    o.EmployeeID,
    od.ProductID,
    dt.FechaKey,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice AS TotalPrice
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] od ON od.OrderID = o.OrderID
INNER JOIN DWNorthwind.dbo.Dimension_Tiempo dt ON dt.Fecha = o.RequiredDate
GROUP BY o.RequiredDate, o.CustomerID,o.EmployeeID, od.ProductID, dt.FechaKey, od.Quantity, od.UnitPrice
GO
SELECT *FROM Hechos_Sales
GO
/*OJO Ejecute despues de llenar el DW*/
EXEC SYS.SP_MSFOREACHTABLE 'ALTER TABLE ? CHECK CONSTRAINT ALL'
GO
EXEC SYS.SP_MSFOREACHTABLE 'ALTER TABLE ? ENABLE TRIGGER ALL'
GO