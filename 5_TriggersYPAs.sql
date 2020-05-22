--Procedimientos Almacenados
--1 Saber que Comidas puedo hacer con los ingredientes que se tienen el almacen
CREATE PROCEDURE SP_ComidasDisponibles as
SELECT a.nombre as Comidas FROM Alimentos a 
INNER JOIN AlimentoContenido ac
on a.alimento_id = ac.alimento_id
INNER JOIN Ingredientes i 
on ac.ingrediente_id = i.ingrediente_id
WHERE i.ingrediente_id NOT IN
(
select ing_id from Ingredientes i 
inner join IngredienteMedida im
on i.ingrediente_id=im.ing_id
WHERE cantidad < 1
)
GROUP BY a.nombre
EXEC SP_ComidasDisponibles

--2 SP para agregar el menu de la semana o reutiizar uno anterior
--voy a hacerlo solo con un alimento de cada tipo para probar, luego ponemos los 7 de cada uno
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
INSERT Into Menus VALUES
(GETDATE())
--variable para cachar la PK del menu mas reciente e insertarlo en MC
DECLARE @ID_Menu int = (SELECT top 1 menu_id FROM Menus order by menu_id desc)
insert into MenuContenido VALUES
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
--le mandamos los valores para ejecutarlo
EXEC SP_Menu_Semanal 1,10,21
--y checamos que se hayan insertado
select*FROM Menus
select*from MenuContenido

--3. Procedimiento para agregar un tutor y alumno
go
CREATE PROCEDURE SP_Alumno_Tutor
--variables que se cacharan en el programa 
@RFC VARCHAR(13),@nomT VARCHAR(30),@apT VARCHAR(30),@amT VARCHAR(30),@trabjo VARCHAR(30),
@Matricula INT,@noA VARCHAR(30),@apA VARCHAR(30),@amA VARCHAR(30),@grado TINYINT,@grupo CHAR(1)
as
IF not EXISTS(select matricula from Alumnos WHERE matricula=@matricula)--checa si la matricula ya esta repetida
--empieza el SP
BEGIN
--empieza la Transaccion
BEGIN TRAN TR_Inscripcion
--inserta en ambas tablas
INSERT INTO tutores VALUES
(@RFC,@nomT,@apT,@amT,@trabjo)
INSERT INTO Alumnos VALUES
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

--drop PROCEDURE SP_Alumno_Tutor

--4. SP para hacer la orden semanal
--Se tomara la orden con 2 ventanas, la primera sera nomas para elegir los items de la orden de la semana
--la segunda ventana pedira los datos del tutor(mas que nada su RFC), el tota y todo lo demas que va en PagoOrden
-- y ver que no se haga mas de 3 dias antes del lunes
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

	INSERT into Ordenes VALUES
	(@Matricula,GETDATE(),GETDATE(),@ID_Menu,@Especial)
	DECLARE @ID_Orden INT = (SELECT top 1 orden_id from Ordenes order by orden_id desc)

	INSERT into OrdenDesglosada VALUES
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

	--y aqui mandamos a ejecutar el SP para calcular el pago de la orden
	EXEC SP_Pago_Orden @ID_Orden,@RFC,@Especial

	COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
	RAISERROR('ERROR AL INSERTAR',16,1)
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

	declare @total money = (select sum(a.costo) from OrdenDesglosada od inner join Alimentos a on od.alimento_ID = a.alimento_id
	inner JOIN Ordenes o on o.orden_id =od.orden_id
	WHERE od.orden_id = @ID_Orden)
	--si es especial se le va a cobrar un 10% mas del total de la orden
	if(@Espececial!=0)
	set @total += @total/0.1
	--hace la insercion a ambas tablas de pago
	INSERT into PagoOrden VALUES
	(@ID_Orden,@RFC,@total)
	--cachamos la orden mas reciente que hicimos
	DECLARE @ID_Pago INT = (select top 1 orden_id from PagoOrden order by orden_id desc)
	INSERT into PagoConcepto VALUES
	(@ID_Pago,@total,GETDATE())

	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	RAISERROR('ERROR AL INSERTAR',16,1)
END CATCH

END

drop PROCEDURE SP_Pago_Orden


--faltaria poner las transaccionesver los alimentos que se tienen en stock  (Utilizando la vista que ya tenemos)

-- ## TRIGGERS ##

--1. Trigger para ver si la orden del padre contiene algo a lo que el nino es alergico
go

CREATE TRIGGER NewOrden ON OrdenDesglosada--nombre del trigger
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

 
--Trigger que cheque la informacion antes de insertar un alimento (integridad de datos)
--Trigger que calcula el precio despues que se actualiza la fecha al finalizar de insertar los alimentos de esa orden
--Trigger que afecte el PagoOrden despues que se inserto en PagoConcepto, restandole al total lo que se pago

