use ComedorPinkFlor
--Procedimientos Almacenados
--1 Saber que Comidas puedo hacer con los ingredientes que se tienen el almacen
go
CREATE PROCEDURE SP_ComidasDisponibles as
SELECT a.nombre as Comidas FROM Comida.Alimentos a 
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
@C5 int ,@B5 int, @P5 int
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
		--bebida
		(@ID_Menu,@B1),
		(@ID_Menu,@B2),
		(@ID_Menu,@B3),
		(@ID_Menu,@B4),
		(@ID_Menu,@B5),
		--postre
		(@ID_Menu,@P1),
		(@ID_Menu,@P2),
		(@ID_Menu,@P3),
		(@ID_Menu,@P4),
		(@ID_Menu,@P5)
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION
RAISERROR('Hubo un error al registrar el menu',16,1)
END CATCH
END

--3. Procedimiento para agregar un tutor y alumno
go
CREATE PROCEDURE SP_Alumno_Tutor
@RFC VARCHAR(13),@nomT VARCHAR(30),@apT VARCHAR(30),@amT VARCHAR(30),@trabjo VARCHAR(30),
@Matricula INT,@noA VARCHAR(30),@apA VARCHAR(30),@amA VARCHAR(30),@grado TINYINT,@grupo CHAR(1)
as
BEGIN
BEGIN TRY
BEGIN TRAN TR_Inscripcion
INSERT INTO tutores VALUES
(@RFC,@nomT,@apT,@amT,@trabjo)
INSERT INTO Alumnos VALUES
(@Matricula,@noA,@apA,@amA,@grado,@grupo,@RFC)
COMMIT TRAN TR_Inscripcion
END TRY
	BEGIN CATCH
	RAISERROR('ERROR AL INSERTAR',16,1)
	ROLLBACK TRANSACTION
	END CATCH
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
	--Declare @rfc nvarchar(13) = (SELECT RFC from Escolar.Alumnos WHERE matricula =@matricula)
	--si no hay mas de un alumno, lo borra a el y a su tutor, si no, solo borra al alumno
	--IF((SELECT COUNT(matricula) from Escolar.Alumnos where rfc=@rfc)<2)
	--BEGIN
	DELETE from Escolar.Alumnos WHERE matricula = @matricula
	--DELETE from Escolar.TelefonosTutores WHERE rfc = @rfc
	--DELETE from Escolar.Tutores WHERE rfc = @rfc;
	--END
	
	DELETE from Escolar.Alumnos WHERE matricula = @matricula;
	COMMIT TRANSACTION
END TRY

BEGIN CATCH
	RAISERROR('ERROR AL DAR DE BAJA ALUMNO',16,1)
	ROLLBACK TRANSACTION
END CATCH
END

exec SP_Borrar_Alumno 171567

select * from Escolar.Alumnos
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
	RAISERROR('ERROR AL DAR DE BAJA AL TUTOR',16,1)
	ROLLBACK TRANSACTION
END CATCH
END

exec SP_Borrar_Tutor '1234'

--9 Para dar de alta a un Tutor
go
alter PROCEDURE SP_InsertaTutor
@rfc NVARCHAR(13),
@nombre NVARCHAR(30),
@apePaterno NVARCHAR(30),
@apeMaterno NVARCHAR(30),
@trabajo NVARCHAR(50)
AS
begin 
	insert into Escolar.Tutores (RFC, nombre, apellidoP, apellidoM, trabajo) values (@rfc, @nombre, @apePaterno, @apeMaterno, @trabajo)
end

--Insercion de telefonos
GO
alter PROCEDURE SP_InsertTelefono
@rfc NVARCHAR(13), @tel numeric(10)
AS
begin try
	insert into Escolar.TelefonosTutores values (@rfc, @tel)
end try
begin catch
	RAISERROR('Error en la inserción de un número de Teléfono',16,1)
end catch


select * from Escolar.Tutores where rfc = '1'

--Actualizar tutor
GO
alter PROCEDURE sp_updateTutor
@rfc NVARCHAR(13),
@nombre NVARCHAR(30),
@apePaterno NVARCHAR(30),
@apeMaterno NVARCHAR(30),
@trabajo NVARCHAR(50)
as
UPDATE Escolar.Tutores set 
nombre = @nombre,
apellidoP = @apePaterno,
apellidoM = @apeMaterno,
trabajo = @trabajo
where rfc = @rfc

--Insercion de alumno
Go
create PROCEDURE sp_insertALumno
@matricula int ,
@nombre NVARCHAR(30) ,
@apellidoP NVARCHAR(30),
@apellidoM NVARCHAR(30),
@grado tinyint,
@grupo CHAR(1),
@RFC NVARCHAR(13)
as
insert into Escolar.Alumnos values (@matricula,@nombre, @apellidoP, @apellidoM, @grado, @grupo, @RFC)

--Dar de baja/eliminar una alargia de un niño
select * from Escolar.Alergias

