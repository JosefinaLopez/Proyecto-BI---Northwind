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
/*Llenado de clientes*/
Insert Into Dimension_Customer(CustomerID,CompanyName,ContactName,City,Country)
Select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.City,
c.Country
From Northwind.dbo.Customers c
GO
SELECT*FROM Dimension_Customer

/*Llenado de empleado*/
INSERT INTO Dimension_Employees(EmployeeID,LastName,FirstName,Title,Territories)
SELECT
e.EmployeeID,
e.LastName,
e.FirstName,
e.Title,
t.TerritoryDescription
FROM Northwind.dbo.Employees e
INNER JOIN Northwind.dbo.EmployeeTerritories et ON et.EmployeeID = e.EmployeeID
INNER JOIN Northwind.dbo.Territories t ON t.TerritoryID = et.TerritoryID
GO

SELECT *FROM Dimension_Employees
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

/*Llenado de productos*/
INSERT INTO Dimension_Products(ProductID,ProductName,UnitPrice,[Units in Stock],Discontinued)
SELECT
p.ProductID,
p.ProductName,
p.UnitPrice,
p.UnitsInStock,
p.Discontinued
FROM Northwind.dbo.Products p
GO
SELECT *FROM Dimension_Products

/*Llenado de hechos*/
INSERT INTO Hechos_Sales ( Cod_Id,E_Id,P_Id, FechaKey, cod_Id, Quantity, UnitPrice, TotalPrice)
SELECT
   DC.Cod_Id,
   DE.E_Id,
   P.ProductID,
   DT.FechaKeY,
   OD.Quantity,
   P.UnitPrice,
   OD.Quantity * P.UnitPrice AS TotalPrice
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] OD ON o.OrderID = OD.OrderID
INNER JOIN Northwind.dbo.Products P ON OD.ProductID = P.ProductID
INNER JOIN Dimension_Employees DE ON o.EmployeeID = DE.EmployeeID
INNER JOIN Dimension_Tiempo DT ON DT.Fecha = o.RequiredDate
INNER JOIN Dimension_Customer DC ON o.CustomerID = DC.CustomerID
GO
SELECT *FROM Hechos_Sales

/*OJO Ejecute despues de llenar el DW*/
EXEC SYS.SP_MSFOREACHTABLE 'ALTER TABLE ? CHECK CONSTRAINT ALL'
GO
EXEC SYS.SP_MSFOREACHTABLE 'ALTER TABLE ? ENABLE TRIGGER ALL'
GO