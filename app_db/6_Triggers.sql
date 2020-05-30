-- ## TRIGGERS ##
--Trigger para ver si la orden del padre contiene algo a lo que el nino es alergico
go

CREATE TRIGGER NewOrden ON Servicios.OrdenDesglosada--nombre del trigger
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
DELETE from OrdenDesglosada WHERE orden_id = @ID_Last_Orden
DELETE from Ordenes WHERE orden_id = @ID_Last_Orden

END
--drop TRIGGER NewOrden

--para probar con una alumno alergico
go
insert into Servicios.Ordenes VALUES
(181517,GETDATE(),GETDATE(),0,1)
--select*FROM Ordenes
go
DECLARE @ID int = (select top 1 orden_id from Servicios.Ordenes order by orden_id desc)
PRINT @ID
INSERT into Servicios.OrdenDesglosada VALUES
(@ID,1,'Lunes')
--select*FROM OrdenDesglosada

-- Trigger para checar que la orden solo se haga con 3 dias maximos de anticipacion
go
CREATE TRIGGER PreOrden ON Servicios.Ordenes--nombre del trigger
FOR insert--tigger para insert
as 
BEGIN
--cachamos la fecha de la orden y le agregamos 3 para ver si es antes solo por 3 dias
DECLARE @day date = (select top 1 DATEADD(dd,3,fecha)from Servicios.Ordenes order by fecha desc)
PRINT @day
--vemos la fecha del siguiente lunes
Declare @monday date = (select DATEADD(dd, -(DATEPART(dw, @day)-9), @day))
--comparamos ambas fechas , y @day es menor aun despues de sumarle 3 dias manda el mensaje
if(@day<@monday)
PRINT'Aun no puede ordenar'
ROLLBACK
END

--valores pa probar
INSERT into Ordenes VALUES
(201648,GETDATE(),GETDATE(),0,2)
SELECT*FROM Escolar.Alumnos
SELECT*FROM Servicios.Ordenes
 


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