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
go
CREATE PROCEDURE SP_Menu_Semanal
--Aqui se guardan la PK de los alimentos, solo deje 3 para probar
@C1 INT = 1,--@C2 INT,@C3 INT,@C4 INT,@C5 INT,@C6 INT,@C7 INT,
@B1 INT,--@B2 INT,@B3 INT,@B4 INT,@B5 INT,@B6 INT,@B7 INT,
@P1 INT--@P2 INT,@P3 INT,@P4 INT,@P5 INT,@P6 INT,@P7 INT
as
--se agregar un nuevo menu, solo ponemos la fecha por que se incrementa solo
INSERT into Menus VALUES(GETDATE())
--variable para guardar la PK mas reciente en la tabla de menus
Declare @KEY INT 
--aqui le damos la clave mas reciente
set @KEY= (select top 1 menu_id from Menus order by menu_id desc)
--puse que imprimiera para ver si llevababa la PK mas reciente
print @key
--Aqui es donde se pone manoso
--Aqui quiero insertar los alimentos que le mande con la llave mas reciente
--pero da un error de FK
INSERT into MenuContenido VALUES
    --Comida
	(@KEY,@C1),
	/*(@KEY,@C2),
	(@KEY,@C3),
	(@KEY,@C4),
	(@KEY,@C5),
	(@KEY,@C6),
	(@KEY,@C7),*/
--Bebidas
	(@KEY,@B1),
	/*(@KEY,@B2),
	(@KEY,@B3),
	(@KEY,@B4),
	(@KEY,@B5),
	(@KEY,@B6),
	(@KEY,@B7),*/
--Postres
	(@KEY,@P1)
	/*(@KEY,@P2),
	(@KEY,@P3),
	(@KEY,@P4),
	(@KEY,@P5),
	(@KEY,@P6),
	(@KEY,@P7)*/
--Aqui acaba el SP
EXEC SP_Menu_Semanal 1,12,19 --Ejecuta y manda los valores al SP
drop PROCEDURE SP_Menu_Semanal -- borra el SP