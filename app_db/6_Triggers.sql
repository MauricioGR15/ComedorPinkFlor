-- ## TRIGGERS ##
--Trigger para ver si la orden del padre contiene algo a lo que el nino es alergico
use ComedorPinkFlor
go

create TRIGGER OrdenAlergica ON Servicios.OrdenDesglosada--nombre del trigger
FOR INSERT--tigger para insert
as 
BEGIN
--cachamos la matriucla de la orden mas reciente
DECLARE @matricula int = (SELECT top 1 matricula FROM inserted)
--checamos si alguna comida que esta en la orden contiene un ingrediente al cual el alumno con la matricula anterior
--es alergio
if exists (select a.ingrediente_id FROM Servicios.OrdenDesglosada od INNER JOIN Comida.AlimentoContenido ac 
on ac.alimento_id = od.alimento_id inner JOIN Comida.Ingredientes i 
on i.ingrediente_id = ac.ingrediente_id INNER JOIN Escolar.Alergias a 
on a.ingrediente_id = i.ingrediente_id
WHERE a.alu_matricula = @matricula
GROUP by a.ingrediente_id)
BEGIN
--si es alergico, imprime el mensaje, cacha el id de la orden y la borra 
PRINT 'Es alergico'
declare @ID_Last_Orden int = (select top 1 orden_id from Servicios.OrdenDesglosada order by orden_id desc)
--aqui podriamos poner un rollback en ves de eso
DELETE from Servicios.OrdenDesglosada WHERE orden_id = @ID_Last_Orden
DELETE from Servicios.Ordenes WHERE orden_id = @ID_Last_Orden
END

ELSE
BEGIN
PRINT 'no es alergico'
END
END
/*
SELECT*FROM Servicios.Ordenes
SELECT*FROM Servicios.OrdenDesglosada
*/

-- Trigger para checar que la orden se haya hecho almenos 3 dias antes
go
create TRIGGER PreOrden ON Servicios.Ordenes
FOR insert
as 
BEGIN
DECLARE @day NVARCHAR(8) = FORMAT((select fecha from inserted),'dddd')
PRINT @day
if(@day='Monday')
PRINT'Es lunes, ya paso el tiempo para las ordenes de la semana'
ROLLBACK
END

--valores pa probar
/*INSERT into Servicios.Ordenes VALUES
(201648,'2020-06-01',GETDATE(),0,2)
*/
 
--Trigger que calcula el precio despues que se actualiza la fecha al finalizar de insertar los alimentos de esa orden
go
CREATE TRIGGER CalcularPrecio ON Servicios.Ordenes
AFTER UPDATE
as
BEGIN
	--Se guarda la id del orden
	declare @orden_id int, @total money
	Select @orden_id = orden_id from inserted
	--Obtenemos el precio total de la suma de los costos de los alimentos
	Set @total = (Select top(1) Total from(Select orden_id, SUM(costo)Total from Servicios.OrdenDesglosada OD 
    inner join Comida.Alimentos A on OD.alimento_ID = A.alimento_id 
	WHERE orden_id = @orden_id
	GROUP BY orden_id)T)
	--Actualizamos el total del pago orden correspondiente
	UPDATE PagoOrden
	SET total = @total
	WHERE orden_id = @orden_id
END

--Trigger que afecte el PagoOrden despues que se inserto en PagoConcepto, restandole al total lo que se pago
go
CREATE TRIGGER PagarOrden ON Servicios.PagoConcepto
AFTER INSERT
as
BEGIN
	declare @pago_id int
	declare @cantidad int
	--Guardamos la id del pago y la cantidad de lo recientemente insertado
	select @pago_id = pago_id from inserted
	select @cantidad = cantidad from inserted
	--Se resta la cantidad al total
	UPDATE Servicios.PagoOrden
	SET total = total - @cantidad
	WHERE pago_id = @pago_id
END

--Trigger si al ordenar el menu es 'especial' cobrarle un 10% extra
go
CREATE TRIGGER ExtraEspecial ON Servicios.PagoOrden
AFTER INSERT
as
BEGIN 
--cachamos el bit para ver si especial
	DECLARE @especial BIT = (select especial from inserted)
	if(@especial=1)
	--si es espcial
	BEGIN
	--agarramos el total
	DECLARE @nuevoTotal money = (select total from inserted)
	--agarramos el id del pago
	DECLARE @id_pago int =(select pago_id from inserted)
	--imprmimos el total anterior y el total nuevo +10%
	PRINT @nuevoTotal
	SET @nuevoTotal += (@nuevoTotal*0.1)
	PRINT @nuevoTotal
	--hace el update para ponerle el nuevo total
	UPDATE Servicios.PagoOrden set total = @nuevoTotal WHERE pago_id = @id_pago
	END
END
--EXEC SP_Pago_Orden 31,'LOMT920505LO5',1