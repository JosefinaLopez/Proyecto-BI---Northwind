MERGE INTO Hechos_Sales AS Destino
USING (
    SELECT Customers_Id, Employee_Id, Product_Id, FechaKey, 
           SUM(Quantity) AS TotalQuantity, 
           SUM(UnitPrice) AS TotalUnitPrice, 
           SUM(TotalPrice) AS TotalTotalPrice
    FROM Hechos_Sales
    GROUP BY Customers_Id, Employee_Id, Product_Id, FechaKey
) AS Origen
ON Destino.Customers_Id = Origen.Customers_Id
   AND Destino.Employee_Id = Origen.Employee_Id
   AND Destino.Product_Id = Origen.Product_Id
   AND Destino.FechaKey = Origen.FechaKey
WHEN MATCHED AND (
    Destino.Quantity <> Origen.TotalQuantity
    OR Destino.UnitPrice <> Origen.TotalUnitPrice
    OR Destino.TotalPrice <> Origen.TotalTotalPrice
)
THEN
    UPDATE SET Quantity = Origen.TotalQuantity,
               UnitPrice = Origen.TotalUnitPrice,
               TotalPrice = Origen.TotalTotalPrice
WHEN NOT MATCHED THEN
    INSERT (RequiredDate, Customers_Id, Employee_Id, Product_Id, FechaKey, Quantity, UnitPrice, TotalPrice)
    VALUES (GETDATE(), Origen.Customers_Id, Origen.Employee_Id, Origen.Product_Id, Origen.FechaKey, Origen.TotalQuantity, Origen.TotalUnitPrice, Origen.TotalTotalPrice);

SELECT * FROM Hechos_Sales;


