use ComedorPinkFlor
--Procedimientos Almacenados
--1 Saber que Comidas puedo hacer con los ingredientes que se tienen el almacen
go
CREATE PROCEDURE SP_ComidasDisponibles as
SELECT a.nombre as Comidas FROM Alimentos a 
INNER JOIN Comida.AlimentoContenido ac
on a.alimento_id = ac.alimento_id
INNER JOIN Comida.Ingredientes i 
on ac.ingrediente_id = i.ingrediente_id
WHERE i.ingrediente_id NOT IN
(
select ing_id from Comida.Ingredientes i 
inner join Comida.IngredienteMedida im
on i.ingrediente_id=im.ing_id
WHERE cantidad < 1
)
GROUP BY a.nombre
EXEC SP_ComidasDisponibles

--2 SP para agregar el menu 
go
CREATE PROCEDURE SP_Menu_Semanal
-- IDs de los alimentos
@C1 int ,@B1 int, @P1 int,
@C2 int ,@B2 int, @P2 int,
@C3 int ,@B3 int, @P3 int,
@C4 int ,@B4 int, @P4 int,
@C5 int ,@B5 int, @P5 int,
@C6 int ,@B6 int, @P6 int,
@C7 int ,@B7 int, @P7 int
AS
BEGIN 
BEGIN TRY
BEGIN TRANSACTION
INSERT Into Servicios.Menus VALUES
(GETDATE())
--variable para cachar la PK del menu mas reciente e insertarlo en MC
DECLARE @ID_Menu int = (SELECT top 1 menu_id FROM Servicios.Menus order by menu_id desc)
insert into Servicios.MenuContenido VALUES
--comida
(@ID_Menu,@C1),
(@ID_Menu,@C2),
(@ID_Menu,@C3),
(@ID_Menu,@C4),
(@ID_Menu,@C5),
(@ID_Menu,@C6),
(@ID_Menu,@C7),
--bebida
(@ID_Menu,@B1),
(@ID_Menu,@B2),
(@ID_Menu,@B3),
(@ID_Menu,@B4),
(@ID_Menu,@B5),
(@ID_Menu,@B6),
(@ID_Menu,@B7),
--postre
(@ID_Menu,@P1),
(@ID_Menu,@P2),
(@ID_Menu,@P3),
(@ID_Menu,@P4),
(@ID_Menu,@P5),
(@ID_Menu,@P6),
(@ID_Menu,@P7)

COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
RAISERROR('ERROR AL INSERTAR',16,1)
END CATCH
END

--3. Procedimiento para agregar un tutor y alumno
go
CREATE PROCEDURE SP_Alumno_Tutor
--variables que se cacharan en el programa 
@RFC VARCHAR(13),@nomT VARCHAR(30),@apT VARCHAR(30),@amT VARCHAR(30),@trabjo VARCHAR(30),
@Matricula INT,@noA VARCHAR(30),@apA VARCHAR(30),@amA VARCHAR(30),@grado TINYINT,@grupo CHAR(1)
as
IF not EXISTS(select matricula from Escolar.Alumnos WHERE matricula=@matricula)--checa si la matricula ya esta repetida
--empieza el SP
BEGIN
--empieza la Transaccion
BEGIN TRAN TR_Inscripcion
--inserta en ambas tablas
INSERT INTO Escolar.tutores VALUES
(@RFC,@nomT,@apT,@amT,@trabjo)
INSERT INTO Escolar.Alumnos VALUES
(@Matricula,@noA,@apA,@amA,@grado,@grupo,@RFC)
--checha si el nombre del alumno o del tutor estan en blanco
if(datalength(@noA)=0 or datalength(@nomT)=0)
--si estan en blanco hace el rollback
ROLLBACK TRAN TR_Inscripcion
ELSE
--si no, le hace commit
COMMIT TRAN TR_Inscripcion
END
--en caso de que la matricula esta repeitda, en el programa lo que haria seria una ventana de error con este mensaje
else
BEGIN
PRINT 'Alumno con matriula repetida'
End
-- datos pa probarel SP
EXEC SP_Alumno_Tutor 'paia990613hsr','angel','prado','isiordia','Estudiante',201618,'juan','perez','garcia',1,'A'
go

--4. SP para hacer la orden semanal
CREATE PROCEDURE SP_Orden_Semanal
@ComidaL int,@ComidaMa int,@ComidaMi int,@ComidaJ int,@ComidaV int,
@BebidaL int,@BebidaMa int,@BebidaMi int,@BebidaJ int,@BebidaV int,
@PostreL int,@PostreMa int,@PostreMi int,@PostreJ int,@PostreV int,
@Matricula INT,--tenemos que ver como vamos a cachar la matricula,RFC y el ID Menu del lado del cliente
@ID_Menu INT,
@Especial BIT,
@RFC VARCHAR(13)
as
 BEGIN
 	BEGIN TRY
	BEGIN TRANSACTION

	INSERT into Servicios.Ordenes VALUES
	(@Matricula,GETDATE(),GETDATE(),@ID_Menu,@Especial)
	DECLARE @ID_Orden INT = (SELECT top 1 orden_id from Servicios.Ordenes order by orden_id desc)

	INSERT into Servicios.OrdenDesglosada VALUES
	(@ID_Orden,@ComidaL,'Lunes'),
	(@ID_Orden,@BebidaL,'Lunes'),
	(@ID_Orden,@PostreL,'Lunes'),
	
	(@ID_Orden,@ComidaMa,'Martes'),
	(@ID_Orden,@BebidaMa,'Martes'),
	(@ID_Orden,@PostreMa,'Martes'),

	(@ID_Orden,@ComidaMi,'Miercoles'),
	(@ID_Orden,@BebidaMi,'Miercoles'),
	(@ID_Orden,@PostreMi,'Miercoles'),

	(@ID_Orden,@ComidaJ,'Jueves'),
	(@ID_Orden,@BebidaJ,'Jueves'),
	(@ID_Orden,@PostreJ,'Jueves'),

	(@ID_Orden,@ComidaV,'Viernes'),
	(@ID_Orden,@BebidaV,'Viernes'),
	(@ID_Orden,@PostreV,'Viernes')

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	RAISERROR('ERROR AL INSERTAR',16,1)
	ROLLBACK TRANSACTION
	END CATCH
	
END

--5 SP para pagar la orden
go
CREATE PROCEDURE SP_Pago_Orden
@ID_Orden int, @RFC NVARCHAR(13),@Espececial bit
as
BEGIN
BEGIN TRY
	BEGIN TRANSACTION

	declare @total money = (select sum(a.costo) from Servicios.OrdenDesglosada od 
	inner join Comida.Alimentos a on od.alimento_ID = a.alimento_id
	inner JOIN Servicios.Ordenes o on o.orden_id =od.orden_id
	WHERE od.orden_id = @ID_Orden)
	--si es especial se le va a cobrar un 10% mas del total de la orden
	if(@Espececial!=0)
	set @total += @total/0.1
	--hace la insercion a ambas tablas de pago
	INSERT into Servicios.PagoOrden VALUES
	(@ID_Orden,@RFC,@total)
	--cachamos la orden mas reciente que hicimos
	DECLARE @ID_Pago INT = (select top 1 orden_id from Servicios.PagoOrden order by orden_id desc)
	INSERT into Servicios.PagoConcepto VALUES
	(@ID_Pago,@total,GETDATE())

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	RAISERROR('ERROR AL INSERTAR',16,1)
	ROLLBACK TRANSACTION
END CATCH
END


--6 SPs para insertar un alimento y su contenido 
go
CREATE PROCEDURE SP_Insert_Alimento
@nombre NVARCHAR(30), @tipo char(1),@costo money,
@carbos money, @calos money,@prote money, @gras money
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
	INSERT into Alimentos VALUES
	(@nombre,@tipo,@costo,@carbos,@calos,@prote,@gras)
END TRY

BEGIN CATCH
	RAISERROR('ERROR AL INSERTAR',16,1)
	ROLLBACK TRANSACTION
END CATCH
End

go
CREATE PROCEDURE SP_Ingredientes_Temporal
@in NVARCHAR(30), @ic money
AS
BEGIN
DECLARE @ID_Ali INT = (select top 1 alimento_id from Comida.Alimentos order by alimento_id desc)
	INSERT into #IngTemporal VALUES
	(@ID_Ali, (select ingrediente_id from Comida.Ingredientes where nombre = @in), @ic)
END

go
CREATE PROCEDURE SP_Temporal_To_Contenido
AS
BEGIN
SELECT* INTO Comida.Ingredientes FROM #IngTemporal
COMMIT TRANSACTION
END

--7 Para dar de baja a un Alumno
go
CREATE PROCEDURE SP_Borrar_Alumno
@matricula INT
AS
BEGIN 
BEGIN TRANSACTION
BEGIN TRY
	DELETE from Escolar.Alergias WHERE alu_matricula = @matricula
	--checa si hay alumnos que comparten el mismo tutor
	Declare @rfc nvarchar(13) = (SELECT RFC from Escolar.Alumnos WHERE matricula =@matricula)
	--si no hay mas de un alumno, lo borra a el y a su tutor, si no, solo borra al alumno
	IF((SELECT COUNT(matricula) from Escolar.Alumnos where rfc=@rfc)<2)
	BEGIN
	DELETE from Escolar.Alumnos WHERE matricula = @matricula
	DELETE from Escolar.TelefonosTutores WHERE rfc = @rfc
	DELETE from Escolar.Tutores WHERE rfc = @rfc;
	END
	
	ELSE
	BEGIN
	DELETE from Escolar.Alumnos WHERE matricula = @matricula;
	END

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	RAISERROR('ERROR AL BORRAR',16,1)
	ROLLBACK TRANSACTION
END CATCH
END

--8 Para dar de baja a un Tutor
go
CREATE PROCEDURE SP_Borrar_Tutor
@RFC INT
AS
BEGIN 
	BEGIN TRANSACTION
	BEGIN TRY
	DELETE from Escolar.Alergias WHERE alu_matricula IN
	(select matricula from Escolar.Alumnos WHERE RFC = @RFC)
	DELETE from Escolar.Alumnos WHERE matricula IN
	(select matricula from Escolar.Alumnos WHERE RFC = @RFC)
	DELETE from Escolar.TelefonosTutores WHERE rfc = @rfc
	DELETE from Escolar.Tutores WHERE rfc = @rfc;

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	RAISERROR('ERROR AL BORRAR',16,1)
	ROLLBACK TRANSACTION
END CATCH
END


-- ## TRIGGERS ##
--1. Trigger para ver si la orden del padre contiene algo a lo que el nino es alergico
go

CREATE TRIGGER NewOrden ON Servicios.OrdenDesglosada--nombre del trigger
FOR INSERT--tigger para insert
as 
BEGIN
--cachamos la matriucla de la orden mas reciente
DECLARE @matricula int = (SELECT top 1 matricula FROM Ordenes ORDER by orden_id desc)
--checamos si alguna comida que esta en la orden contiene un ingrediente al cual el alumno con la matricula anterior
--es alergio
if exists (select a.ingrediente_id FROM OrdenDesglosada od INNER JOIN AlimentoContenido ac 
on ac.alimento_id = od.alimento_id inner JOIN Ingredientes i 
on i.ingrediente_id = ac.ingrediente_id INNER JOIN Alergias a 
on a.ingrediente_id = i.ingrediente_id
WHERE a.alu_matricula = @matricula
GROUP by a.ingrediente_id)
--si es alergico, imprime el mensaje, cacha el id de la orden y la borra 
PRINT 'Es alergico'
declare @ID_Last_Orden int = (select top 1 orden_id from OrdenDesglosada order by orden_id desc)
--aqui podriamos poner un rollback en ves de eso
DELETE from OrdenDesglosada WHERE orden_id = @ID_Last_Orden
DELETE from Ordenes WHERE orden_id = @ID_Last_Orden

END
--drop TRIGGER NewOrden

--para probar con una alumno alergico
go
insert into Ordenes VALUES
(181517,GETDATE(),GETDATE(),0,1)
--select*FROM Ordenes
go
DECLARE @ID int = (select top 1 orden_id from Ordenes order by orden_id desc)
PRINT @ID
INSERT into OrdenDesglosada VALUES
(@ID,1,'Lunes')
--select*FROM OrdenDesglosada

--2. Trigger para checar que la orden solo se haga con 3 dias maximos de anticipacion
go
CREATE TRIGGER PreOrden ON Ordenes--nombre del trigger
FOR insert--tigger para insert
as 
BEGIN
--cachamos la fecha de la orden y le agregamos 3 para ver si es antes solo por 3 dias
DECLARE @day date = (select top 1 DATEADD(dd,3,fecha)from Ordenes order by fecha desc)
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
SELECT*FROM Alumnos
SELECT*FROM Ordenes

--Agregar alumnos y tutores (Insertar)
--Insertar un alimento y su  contenido (PA)
--Modificar un alumno o tutor (modificar)
 

 
--3. Trigger para crear la tabla temporal de para el contenido del alimento
go
CREATE TRIGGER TablaTemporal ON comida.Alimentos
FOR insert
as
BEGIN
CREATE table #IngTemporal (
	id_alimento INT,
	id_ingrediente INT,
	cantidad money

)
END
--4. Trigger para eliminar la tabla temporal
go
CREATE TRIGGER DeleteTemporal ON comida.AlimentoContenido
FOR insert
as
BEGIN
drop table #IngTemporal
END

--Trigger que calcula el precio despues que se actualiza la fecha al finalizar de insertar los alimentos de esa orden
CREATE TRIGGER CalcularPrecio ON Ordenes
AFTER UPDATE
as
BEGIN
	--Se guarda la id del orden
	declare @orden_id int, @total money
	Select @orden_id = orden_id from inserted
	--Obtenemos el precio total de la suma de los costos de los alimentos
	Set @total = (Select top(1) Total from(Select orden_id, SUM(costo)Total from OrdenDesglosada OD inner join Alimentos A on OD.alimento_ID = A.alimento_id 
	GROUP BY orden_id)T)
	--Actualizamos el total del pago orden correspondiente
	UPDATE PagoOrden
	SET total = @total
	WHERE orden_id = @orden_id
END

--Trigger que afecte el PagoOrden despues que se inserto en PagoConcepto, restandole al total lo que se pago
CREATE TRIGGER PagarOrden ON PagoConcepto
AFTER INSERT
as
BEGIN
	declare @pago_id int
	declare @cantidad int
	--Guardamos la id del pago y la cantidad de lo recientemente insertado
	select @pago_id = pago_id from inserted
	select @cantidad = cantidad from inserted
	--Se resta la cantidad al total
	UPDATE PagoOrden
	SET total = total - @cantidad
	WHERE pago_id = @pago_id
END
