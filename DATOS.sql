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

	select * from IngredienteMedida


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

