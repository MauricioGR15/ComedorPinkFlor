use ComedorPinkFlor

insert into Tutores values 
	('MALO871112LF5','Oriana','Martinez','Lilian','Administrador'),
	('PESA901212FE5','Adriana','Perez','Sicairos','Profesor'),
	('LOMT920505LO5','Mario','Lopez',null,'Abogado'),
	('PILR750814JD3','Rodrigo','Piedras','Lara','Gerente'),
	('AGAT790115LR3','Tomasa','Aguilar',null,'Vendedor'),
	('LOMG820115GR5','Guadalupe','Lopez','Madrigal','Vendedor'),
	('LOSR851215RG2','Rosario','Lomeli','Santana','Profesor'),
	('GADA900910Q35','Alicia','Garcia','Diaz','Administrador'),
	('ROCR87050645T','Raul','Roman','Casta�eda','Abogado'),
	('RORA751218GR2','Alberto','Rodriguez','Ramirez','Taquero'),
	('GUCM900915T4C','Marco','Guimares','Cazarez','Ing en Sistemas'),
	('HAJM840405GR4','Mack','Hardy',null,'Agricultor'),
	('ZEMP920120FE1','Zepeda','Miyazaki','Perla','Administrador'),
	('GAPM900101LFG','Maria','Gavilan','Padilla','Profesor'),
	('MEMG930828GRG','Gabriela','Mendez','Mendieta','Biomedico'),
	('LOPC931228F45','Cristina','Lopez','Pi�a','Contador'),
	('LOSM901225DQ2','Mireya','Lopez','Santillan','Ing en Sistemas'),
	('GULA930404FE1','Alejandra','Guzman','Lopez','Bioquimico'),
	('PEPF941010FE5','Francisco','Perez','Perea','Gerente'),
	('ANTJ870607GH4','Jazmin','Angulo','Torres','Vendedor'),
	('GORS910519F13','Sebastian','Govea','Romero','Musico')


insert into TelefonosTutores values 
	('MALO871112LF5',6672154623),
	('MALO871112LF5',6678154231),
	('PESA901212FE5',6671546387),
	('PESA901212FE5',6674859123),
	('PILR750814JD3',6677451268),
	('PILR750814JD3',6671346851),
	('AGAT790115LR3',6671235986)

insert into Alumnos values 
	(191618,'Miguel','Aguiar','Martinez',4,'B','MALO871112LF5'),
	(191720,'Mariana','Aguiar','Martinez',3,'C','MALO871112LF5'),
	(191413,'Ivana','Pe�a','Sicairos',5,'B','PESA901212FE5'),
	(181417,'Alberto','Pe�a','Sicairos',1,'A','PESA901212FE5'),
	(171567,'Gabriela','Lopez','Escobar',2,'B','LOMT920505LO5'),
	(181517,'Evelyn','Piedras','Sainz',3,'D','PILR750814JD3'),
	(201618,'Jason','Aguilar','Martinez',6,'A','AGAT790115LR3'),
	(201648,'Paul','Ramos','Zepeda',1,'A','ZEMP920120FE1'),
	(201315,'Liliana','Ramos','Zepeda',2,'A','ZEMP920120FE1'),
	(184621,'Mariana','Ramos','Zepeda',4,'B','ZEMP920120FE1'),
	(196321,'Ana Laura','Ra,ps','Zepeda',3,'C','ZEMP920120FE1'),
	(198452,'Carlos','Leon','Mendez',4,'B','MEMG930828GRG'),
	(184113,'Saul','Leon','Mendez',6,'A','MEMG930828GRG'),
	(174123,'Julissa','Arreola','Guzman',2,'A','GULA930404FE1'),
	(174852,'Melissa','Arreola','Guzman',2,'A','GULA930404FE1'),
	(184123,'Genaro','Rodriguez','Herrera',3,'D','RORA751218GR2'),
	(184756,'Pedro','Rodriguez','Herrera',3,'D','RORA751218GR2'),
	(175421,'Marissa','Rodriguez','Herrera',4,'C','RORA751218GR2'),
	(192465,'Leonel','Govea','Garcia',3,'B','GORS910519F13'),
	(201236,'Gimena','Gavilan','Garcia',5,'A','GADA900910Q35')

insert into Menus values 
	(1),
	(1),
	(1),
	(0),
	(1),
	(1),
	(0)


insert into Ingredientes values 
	('Pimienta',14,'20220220',0),
	('Sal de mar',20,'20220415',0),
	('Ajo',15,'20210506',0),
	('Sal carbonada',4,'20230505',0),
	('Tomate',30,'20200415',0),
	('Cebolla',22,'20200404',1),
	('Espinacas',15,'20200404',0),
	('Brocoli',30,'20200405',0),
	('Coliflor',12,'20200607',0),
	('Calabaza',12,'20200330',0),
	('Apio',15,'20200608',1),
	('Chayote',20,'20200515',0),
	('Sirloin',30,'20200614',0),
	('Cabreria',14,'20200314',0),
	('Pastor',23,'20200330',1),
	('Leche',50,'20200815',0),
	('Azucar',30,'20210916',1),
	('Zanahoria', 25, '2020-05-25', 0),
	('Frijol', 28, '2020-04-10', 0),
	('Salchicha de puerco', 26, '2020-06-06', 1),
	('Tocino', 27, '2020-04-05', 1),
	('Cilantro', 22, '2020-05-12', 1),
	('Aguacate', 22, '2020-05-13', 0),
	('Tortilla', 30, '2020-06-10', 0),
	('Cebada', 31, '2020-07-15', 0),
	('Arroz', 28, '2020-05-01', 0),
	('Harina', 23, '2020-12-28', 0),
	('Huevos', 25, '2020-05-03', 0),
	('Extracto de vainilla', 27, '2020-04-02', 1),
	('Chocolate amargo', 21, '2020-05-05', 1)

insert into IngredienteMedida values
	(1,'Gr'),
	(2,'Gr'),
	(3,'Gr'),
	(4,'Gr'),
	(5,'Kg'),
	(6,'Kg'),
	(7,'Kg'),
	(8,'Kg'),
	(9,'Kg'),
	(10,'Kg'),
	(11,'Kg'),
	(12,'Kg'),
	(13,'Kg'),
	(14,'Kg'),
	(15,'Kg'),
	(16,'Lt'),
	(17,'Gr')


insert into Alergias values 
	(171567,13),
	(171567,15),
	(181517,1)


--ALIMENTOS
--Le falta el costo
insert into Alimentos values
	('Sopa de verduras','C',40,35,442,25,10),
	('Carne en su jugo','C',45,42,430,29,16),
	('Tamal de puerco','C',25,28,445,7,30),
	('Sopa de tortillas','C',30,28,423,8,4),
	('Asado','C',50,34,440,34,26),
	('Sirloin','C',50,35,435,36,25),
	('Papa con carne','C',50,27,380,32,18),
	('Tostadas de frijol','C',35,20,280,10,15),
	('Tacos dorados','C',40,34,350,10,25),
	('Ceviche','C',45,18,215,30,0),
	('Hamburguesa','C',60,55,540,15,60),

	('Refresco','B',15,10,41,1,1),
	('Cebada','B',12,6,30,3,0),
	('Horchata','B',20,7,30,3,2),
	('Jamaica','B',15,7,40,4,0),
	('Te Jazmin','B',20,9,32,4,0),
	('Agua embotellada','B',15,0,0,0,0),
	('Limonada','B',12,5,30,1,0),

	('Suffle','P',25,30,278,5,1),
	('Pastel de vainilla','P',30,42,300,6,2),
	('Pastel de chocolate','P',30,50,345,5,3),
	('Brownie','P',25,38,285,4,2),
	('Crepa','P',40,40,289,3,1),
	('Waffle','P',25,37,259,5,3),
	('Nieve','P',20,28,180,5,1)

insert into MenuContenido values 
--Comida
	(1,1),
	(1,3),
	(1,4),
	(1,6),
	(1,7),
	(1,9),
	(1,10),
--Bebidas
	(1,12),
	(1,13),
	(1,14),
	(1,15),
	(1,16),
	(1,17),
	(1,18),
--Postres
	(1,19),
	(1,20),
	(1,21),
	(1,22),
	(1,23),
	(1,24),
	(1,25),

--Comida
	(2,2),
	(2,5),
	(2,6),
	(2,7),
	(2,8),
	(2,11),
	(2,10),
--Bebidas
	(2,12),
	(2,13),
	(2,14),
	(2,15),
	(2,16),
	(2,17),
	(2,18),
--Postres
	(2,19),
	(2,20),
	(2,21),
	(2,22),
	(2,23),
	(2,24),
	(2,25),

--Comida
	(3,3),
	(3,4),
	(3,5),
	(3,6),
	(3,7),
	(3,9),
	(3,10),
--Bebidas
	(3,12),
	(3,13),
	(3,14),
	(3,15),
	(3,16),
	(3,17),
	(3,18),
--Postres
	(3,19),
	(3,20),
	(3,21),
	(3,22),
	(3,23),
	(3,24),
	(3,25),

--Comida
	(4,2),
	(4,3),
	(4,4),
	(4,6),
	(4,8),
	(4,1),
	(4,10),
--Bebidas
	(4,12),
	(4,13),
	(4,14),
	(4,15),
	(4,16),
	(4,17),
	(4,18),
--Postres
	(4,19),
	(4,20),
	(4,21),
	(4,22),
	(4,23),
	(4,24),
	(4,25),

--Comida
	(5,1),
	(5,2),
	(5,3),
	(5,4),
	(5,5),
	(5,6),
	(5,10),
--Bebidas
	(5,12),
	(5,13),
	(5,14),
	(5,15),
	(5,16),
	(5,17),
	(5,18),
--Postres
	(5,19),
	(5,20),
	(5,21),
	(5,22),
	(5,23),
	(5,24),
	(5,25),

--Comida
	(6,4),
	(6,5),
	(6,6),
	(6,7),
	(6,8),
	(6,9),
	(6,10),
--Bebidas
	(6,12),
	(6,13),
	(6,14),
	(6,15),
	(6,16),
	(6,17),
	(6,18),
--Postres
	(6,19),
	(6,20),
	(6,21),
	(6,22),
	(6,23),
	(6,24),
	(6,25),

--Comida
	(7,1),
	(7,3),
	(7,2),
	(7,6),
	(7,7),
	(7,9),
	(7,11),
--Bebidas
	(7,12),
	(7,13),
	(7,14),
	(7,15),
	(7,16),
	(7,17),
	(7,18),
--Postres
	(7,19),
	(7,20),
	(7,21),
	(7,22),
	(7,23),
	(7,24),
	(7,25)

--PAGOS
insert into PagoMenu values
	(1,1,'ZEMP920120FE1',184621,55000), --15 (Omar)
	(2,2,'ZEMP920120FE1',201315,48780), --25 (Omar)
	(3,3,'GULA930404FE1',174123,53200), --10 (Omar)
	(4,4,'GULA930404FE1',174852,51890), --25 (Mauricio)
	(5,5,'LOMT920505LO5',171567,54000)  --25 (Mauricio)


--Sopa de verduras
INSERT INTO AlimentoContenido values (1, 5, 100)
INSERT INTO AlimentoContenido values (1, 6, 50)
INSERT INTO AlimentoContenido values (1, 3, 10)
INSERT INTO AlimentoContenido values (1, 18, 50)
INSERT INTO AlimentoContenido values (1, 10, 50)
INSERT INTO AlimentoContenido values (1, 11, 50)
INSERT INTO AlimentoContenido values (1, 12, 50)
INSERT INTO AlimentoContenido values (1, 1, 2)
INSERT INTO AlimentoContenido values (1, 4, 5)

--Carne en su jugo
INSERT INTO AlimentoContenido values (2, 20, 100)
INSERT INTO AlimentoContenido values (2, 21, 100)
INSERT INTO AlimentoContenido values (2, 19, 200)
INSERT INTO AlimentoContenido values (2, 6, 50)
INSERT INTO AlimentoContenido values (2, 1, 2)
INSERT INTO AlimentoContenido values (2, 4, 5)

--Sopa de tortillas
INSERT INTO AlimentoContenido values (3, 5, 100)
INSERT INTO AlimentoContenido values (3, 3, 10)
INSERT INTO AlimentoContenido values (3, 6, 100)
INSERT INTO AlimentoContenido values (3, 22, 25)
INSERT INTO AlimentoContenido values (3, 23, 100)
INSERT INTO AlimentoContenido values (3, 24, 200)

--Cebada
INSERT INTO AlimentoContenido values (13, 25, 150)
INSERT INTO AlimentoContenido values (13, 17, 25)

--Horchata
INSERT INTO AlimentoContenido values (15, 26, 100)
INSERT INTO AlimentoContenido values (15, 17, 10)

--Pastel de vainilla
INSERT INTO AlimentoContenido values (20, 27, 200)
INSERT INTO AlimentoContenido values (20, 17, 50)
INSERT INTO AlimentoContenido values (20, 28, 100)
INSERT INTO AlimentoContenido values (20, 29, 10)
INSERT INTO AlimentoContenido values (20, 16, 100)

--Pastel de chocolate
INSERT INTO AlimentoContenido values (21, 27, 200)
INSERT INTO AlimentoContenido values (21, 17, 50)
INSERT INTO AlimentoContenido values (21, 28, 100)
INSERT INTO AlimentoContenido values (21, 30, 100)
INSERT INTO AlimentoContenido values (21, 16, 100)



