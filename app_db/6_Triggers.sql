-- ## TRIGGERS ##
--Trigger para ver si la orden del padre contiene algo a lo que el nino es alergico
use ComedorPinkFlor
go

create TRIGGER OrdenAlergica ON Servicios.OrdenDesglosada--nombre del trigger
FOR INSERT--tigger para insert
as 
BEGIN
--cachamos la matriucla de la orden mas reciente
DECLARE @matricula int = (SELECT top 1 matricula FROM Ordenes ORDER by orden_id desc)
--checamos si alguna comida que esta en la orden contiene un ingrediente al cual el alumno con la matricula anterior
--es alergio
if exists (select a.ingrediente_id FROM Servicios.OrdenDesglosada od INNER JOIN Comida.AlimentoContenido ac 
on ac.alimento_id = od.alimento_id inner JOIN Comida.Ingredientes i 
on i.ingrediente_id = ac.ingrediente_id INNER JOIN Escolar.Alergias a 
on a.ingrediente_id = i.ingrediente_id
WHERE a.alu_matricula = @matricula
GROUP by a.ingrediente_id)
--si es alergico, imprime el mensaje, cacha el id de la orden y la borra 
PRINT 'Es alergico'
declare @ID_Last_Orden int = (select top 1 orden_id from Servicios.OrdenDesglosada order by orden_id desc)
--aqui podriamos poner un rollback en ves de eso
DELETE from Servicios.OrdenDesglosada WHERE orden_id = @ID_Last_Orden
DELETE from Servicios.Ordenes WHERE orden_id = @ID_Last_Orden

END
--para probar con una alumno alergico
/*insert into Servicios.Ordenes VALUES
(181517,GETDATE(),GETDATE(),0,1)
go
DECLARE @ID int = (select top 1 orden_id from Servicios.Ordenes order by orden_id desc)
PRINT @ID
INSERT into Servicios.OrdenDesglosada VALUES
(@ID,1,'Lunes')
SELECT*FROM Servicios.Ordenes
SELECT*FROM Servicios.OrdenDesglosada
*/

-- Trigger para checar que la orden se haya hecho almenos 3 dias antes
go
create TRIGGER PreOrden ON Servicios.Ordenes
FOR insert
as 
BEGIN
DECLARE @day NVARCHAR(8) = FORMAT((select top 1 fecha from Servicios.Ordenes order by orden_id desc),'dddd')
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
	DECLARE @especial BIT = (select top 1 especial from Servicios.Ordenes order by orden_id desc)
	if(@especial=1)
	BEGIN
	DECLARE @nuevoTotal money = (select top 1 total from Servicios.PagoOrden order by pago_id desc)
	DECLARE @id_pago int =(select top 1 pago_id from Servicios.PagoOrden order by pago_id desc)
	PRINT @nuevoTotal
	SET @nuevoTotal += (@nuevoTotal*0.1)
	PRINT @nuevoTotal
	UPDATE Servicios.PagoOrden set total = @nuevoTotal WHERE pago_id = @id_pago
	END
END

--EXEC SP_Pago_Orden 21,'LOMT920505LO5',1
--SELECT*FROM Servicios.PagoOrden 