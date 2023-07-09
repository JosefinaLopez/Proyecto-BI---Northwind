MERGE INTO Hechos_Sales AS Destino
USING (
    SELECT cod_Id,E_ID, P_ID, FechaKey, 
           SUM(Quantity) AS TotalQuantity, 
           SUM(UnitPrice) AS TotalUnitPrice, 
           SUM(TotalPrice) AS TotalTotalPrice
    FROM Hechos_Sales
    GROUP BY cod_Id, E_ID, P_ID, FechaKey
) AS Origen
ON Destino.cod_Id = Origen.cod_Id
   AND Destino.E_ID = Origen.E_ID
   AND Destino.P_ID = Origen.P_ID
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
    INSERT (cod_Id,E_ID, P_ID, FechaKey,Quantity, UnitPrice, TotalPrice)
    VALUES (Origen.cod_Id, Origen.E_ID, Origen.P_ID, Origen.FechaKey, Origen.TotalQuantity, Origen.TotalUnitPrice, Origen.TotalTotalPrice);

SELECT * FROM Hechos_Sales;