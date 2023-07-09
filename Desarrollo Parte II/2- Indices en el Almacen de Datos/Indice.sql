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

/*Indice Customers*/
Create Clustered Index Ix_Customer_Company ON dbo.Dimension_Customer (CompanyName)
GO
Create NonClustered Index Ix_Customer_City ON dbo.Dimension_Customer (City)
GO
Create NonClustered Index Ix_Customer_Country ON dbo.Dimension_Customer (Country)
GO

/*Indice Employees*/
Create Clustered Index Ix_Employees_FirstName ON dbo.Dimension_Employees (FirstName)
GO
Create NonClustered Index Ix_Employees_Title ON dbo.Dimension_Employees (Title)
GO

/*Indice Tiempo*/
Create Clustered Index IX_Tiempo_FECHA ON dbo.Dimension_Tiempo(FECHA)
GO
Create Index  IX_Tiempo_Año ON dbo.Dimension_Tiempo(Año) WITH(FILLFACTOR=80)
GO
Create Index IX_Tiempo_TRIMESTRE ON dbo.Dimension_Tiempo(TRIMESTRE) WITH(FILLFACTOR=80)
GO
Create Index IX_Tiempo_MES ON dbo.Dimension_Tiempo(MES) WITH(FILLFACTOR=80)
GO

/*Indice Products*/
Create Clustered Index Ix_Products_ProductName ON dbo.Dimension_Products (ProductName)
GO

/*Indice Hechos*/
Create ColumnStore Index Ix_Hechos_Sales_All ON dbo.Hechos_Sales(Cod_Id,E_Id,P_Id,FechaKey)
GO

