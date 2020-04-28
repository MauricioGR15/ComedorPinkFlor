use ComedorPinkFlor
--Sentencias para el admin--
--1 Agregar un nuevos tutores y alumnos 
INSERT INTO Tutores VALUES
('161710084888','Kimberly','Stella','Oleg','Gravida Sit Amet Associates'),
('161804128252','Kasper','Levi','Shaine','Nulla Cras Eu Company'),
('168506129124','Ina','Charde','Dalton','Tempus Scelerisque PC'),
('162506108196','Barclay','Bell','Mallory','Ipsum Dolor Sit Associates'),
('160703308528','Karen','Nolan','Porter','Purus Industries'),
('161203081680','Knox','Cassady','Kennedy','Augue Consulting'),
('161709251639','Valentine','Finn','Jade','Et Eros Industries'),
('164602148274','Francesca','Neil','Derek','Varius Et Foundation'),
('161502298316','Regan','Hall','Oren','Sagittis Duis Consulting'),
('163704204969','Quin','Felicia','Gary','Luctus Aliquet PC');


insert into Alumnos values 
	(201236,'Mike','Stella','Oleg',4,'B','161710084888'),
	(201237,'Steve','Levi','Shaine',3,'C','161804128252'),
	(201238,'Thomas','Charde','Dalton',5,'B','168506129124'),
	(201239,'Timmy','Bell','Mallory',1,'A','162506108196'),
	(201240,'Kyle','Nolan','Porter',2,'B','160703308528'),
	(201241,'Cartaman','Cassady','Kennedy',3,'D','161203081680'),
	(201242,'Butters','Finn','Jade',6,'A','164602148274'),
	(201243,'Stan','Neil','Derek',1,'A','161502298316'),
	(201244,'Jimmy','Hall','Oren',2,'A','163704204969'),
    (201245,'Craig','Marsh','Pines',2,'A','163704204234');
	
INSERT INTO TelefonosTutores VALUES
('161710084888','(728) 674-5489'),
('161804128252','(635) 373-9210'),
('168506129124','(135) 708-4434'),
('162506108196','(879) 820-1160'),
('160703308528','(973) 692-5789'),
('161203081680','(940) 533-5241'),
('161709251639','(211) 384-3321'),
('164602148274','(315) 850-4990'),
('161502298316','(584) 452-1153'),
('163704204969','(395) 365-1118');

--2 Update a los grados y/o grupos de los alumnos, y cambiar 
--les puse valores solo para probarlos, pero en el programa se le manda el parametro
update Alumnos set grado = grado+1 WHERE matricula BETWEEN 170000 and 179999
update Alumnos set grupo = 'A' where grupo = 'B'

--3 Dar de baja alumnos y sus tutores de cierta generacion
go
delete from Alumnos WHERE matricula BETWEEN 170000 and 179999
go
delete from Tutores WHERE RFC NOT IN 
(
    select RFC FROM Alumnos
)
DELETE from TelefonosTutores WHERE RFC NOT IN
(
    select RFC FROM Alumnos
)

--Sentencias para el de almacen--
--1 Hacerle un update a la cantidad de ingredientes que se tienen
UPDATE Ingredientes set cantidad = 0 WHERE nombre = 'NOMBRE INGREDIENTE'
--2 Agregar nuevos ingredientes
INSERT into Ingredientes VALUES
('Esparragos', 20, '20200912', 0),
('Remolachas', 22, '20200913', 0),
('Queso Oaxaca', 10, '20200913', 0)
--3 Ver los ingredientes que hay en stock 


--Sentencias para el de Nutriologo--
--1 Agregar nuevos menus
--Favor de poner todo lo que se ocupa para agregar un menu ya sea normal o especial, no entendi 
--como le hacian

--2 Borrar menus obsoletos y tambien se borre de la tabla donde guiarda su contenido
delete from Menus WHERE menu_id = 2
go
DELETE from MenuContenido WHERE menu_id not IN
(
	select menu_id from Menus
)

--Sentencias para el de Cocina--
--1 Mostrar que ingredientes necesitan para x menu
use ComedorPinkFlor
--aqui podemos poner una variable que cache el id del menu, y asi meter
--todo esto dentro de un proceseo almacenado dentro de una TM
SELECT m.menu_id as ID, case m.tipo when 0 then 'Especial' when 1 then 'Normal' end as Tipo from Menus m
WHERE m.menu_id = 2 --aqui iria la variable
SELECT m.menu_id as ID,i.nombre as Ingrediente FROM menus m  JOIN MenuContenido mc
on m.menu_id = mc.menu_id 
JOIN alimentos a on a.alimento_id = mc.alimento_ID
JOIN AlimentoContenido ac on ac.alimento_id = a.alimento_id
JOIN Ingredientes i on i.ingrediente_id = ac.ingrediente_id
WHERE m.menu_id = 2--en vez del 2 la variable

--podiramos poner otro rol, como de enfermeria para agregar a los
--alumnos con alergias, pero no se si seria estrechar mucho el 
--asunto de los roles

--El que nos faltaria seria al cajero, a no ser que tambien se les ocurran
--para los alumnos y tutores(ya que ellos mas que nada solo hacen consultas a la BD)