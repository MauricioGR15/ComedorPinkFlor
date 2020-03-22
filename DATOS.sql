use ComedorPinkFlor

insert into Tutores values 
	('MALO871112LF5','Oriana','Martinez','Lilian','Administradora'),
	('PESA901212FE5','Adriana','Perez','Sicairos','Maestra'),
	('LOMT920505LO5','Mario','Lopez','Madrid','Abohado'),
	('PILR750814JD3','Rodrigo','Piedras','Lara','Gerente'),
	('AGAT790115LR3','Tomasa','Aguilar','Arreaga','Vendedora')


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
	(191413,'Ivana','Peña','Sicairos',5,'B','PESA901212FE5'),
	(181417,'Alberto','Peña','Sicairos',1,'A','PESA901212FE5'),
	(171567,'Gabriela','Lopez','Escobar',2,'B','LOMT920505LO5'),
	(181517,'Evelyn','Piedras','Sainz',3,'D','PILR750814JD3'),
	(201618,'Jason','Aguilar','Martinez',6,'A','AGAT790115LR3')

insert into Menus values 
	(1,1,450),
	(2,1,460),
	(3,1,454),
	(4,0,670),
	(5,1,600),
	(6,1,570),
	(7,0,650)


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
	('Azucar',30,'20210916',1)
	

	insert into Ingredientes values
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
	(171567,13,'Salen ronchas en la piel'),
	(171567,15,'Ojos hinchados'),
	(181517,1,'Vomito y tos')


--ALIMENTOS
insert into Alimentos values
	('Sopa de verduras','C',35,442,25,10),
	('Carne en su jugo','C',42,430,29,16),
	('Tamal de puerco','C',28,445,7,30),
	('Sopa de tortillas','C',28,423,8,4),
	('Asado','C',34,440,34,26),
	('Sirloin','C',35,435,36,25),
	('Papa con carne','C',27,380,32,18),
	('Tostadas de frijol','C',20,280,10,15),
	('Tacos dorados','C',34,350,10,25),
	('Ceviche','C',18,215,30,0),
	('Hamburguesa','C',55,540,15,60),

	('Refresco','B',10,41,1,1),
	('Cebada','B',6,30,3,0),
	('Horchata','B',7,30,3,2),
	('Jamaica','B',7,40,4,0),
	('Te Jazmin','B',9,32,4,0),
	('Agua embotellada','B',0,0,0,0),
	('Limonada','B',5,30,1,0),

	('Suffle','P',30,278,5,1),
	('Pastel de vainilla','P',42,300,6,2),
	('Pastel de chocolate','P',50,345,5,3),
	('Brownie','P',38,285,4,2),
	('Crepa','P',40,289,3,1),
	('Waffle','P',37,259,5,3),
	('Nieve','P',28,180,5,1)

--PAGOS
INSERT INTO Pagos values (1, 'MALO871112LF5', 191618, 800, 1000, 'Mensual', '20200315')
INSERT INTO Pagos values (2, 'MALO871112LF5', 191618, 600, 800, 'Mensual', '20200415')
INSERT INTO Pagos values (2, 'PESA901212FE5', 191413, 1800, 2000, 'Trimestral', '20200229')
INSERT INTO Pagos values (3, 'LOMT920505LO5', 171567, 2500, 2500, 'Semestral', '20200430')
INSERT INTO Pagos values (1, 'PILR750814JD3', 181517, 1600, 1400, 'Bimestral', '20200303')
INSERT INTO Pagos values (4, 'PILR750814JD3', 181517, 750, 800, 'Mensual', '20200403')
INSERT INTO Pagos values (6, 'AGAT790115LR3', 201618, 700, 700, 'Mensual', '20200228')
INSERT INTO Pagos values (4, 'MALO871112LF5', 191720, 1500, 1200, 'Bimestral', '20200320')
INSERT INTO Pagos values (2, 'AGAT790115LR3', 201618, 1800, 1500, 'Trimestral', '20200328')
INSERT INTO Pagos values (7, 'PESA901212FE5', 181417, 850, 800, 'Mensual', '20200302')


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
INSERT INTO AlimentoContenido values (21, 27, 200)
INSERT INTO AlimentoContenido values (21, 17, 50)
INSERT INTO AlimentoContenido values (21, 28, 100)
INSERT INTO AlimentoContenido values (21, 29, 10)
INSERT INTO AlimentoContenido values (21, 16, 100)

--Pastel de chocolate
INSERT INTO AlimentoContenido values (21, 27, 200)
INSERT INTO AlimentoContenido values (21, 17, 50)
INSERT INTO AlimentoContenido values (21, 28, 100)
INSERT INTO AlimentoContenido values (21, 30, 100)
INSERT INTO AlimentoContenido values (21, 16, 100)

