CREATE DATABASE ComedorPinkFlor
GO

use ComedorPinkFlor

create table Tutores(
    RFC NVARCHAR(13) PRIMARY KEY,
    nombre NVARCHAR(30) not null,
    apellidoP NVARCHAR(30) not null,
    apellidoM NVARCHAR(30),
    trabajo NVARCHAR(30) not null
)

CREATE table TelefonosTutores(
     RFC NVARCHAR(13) foreign key references Tutores(rfc),
     telefono numeric(10) unique not null,
    primary key (RFC, telefono)
)

create TABLE Alumnos(
    matricula int PRIMARY KEY (matricula),
    nombre NVARCHAR(30) not null,
    apellidoP NVARCHAR(30) not null,
    apellidoM NVARCHAR(30) not null,
    grado tinyint not null,
    grupo CHAR(1) not null,
    RFC NVARCHAR(13) FOREIGN KEY REFERENCES Tutores(RFC)
)

CREATE TABLE Ingredientes(
    ingrediente_id int IDENTITY (1,1) PRIMARY KEY,
    nombre NVARCHAR (20) not null,
    cantidad MONEY not null, --Ingredientes en existencia
    fechaCad DATE not null,
    alergenico BIT not null
)

CREATE TABLE Alimentos(
    alimento_id INT IDENTITY (1,1) PRIMARY KEY,
    nombre NVARCHAR(30) not null,
    tipo CHAR(1) not null CONSTRAINT chk_tipoAlimento check (tipo in ('B','C','P')),
	costo money not null,
    carbohidratos MONEY not null,
    calorias MONEY not null,
    proteinas MONEY not null,
    grasas MONEY not null
)

CREATE TABLE Menus(
    menu_id INT identity primary key,
    fechaCreacion date
)

CREATE TABLE MenuContenido(
    menu_id int,
    alimento_ID int FOREIGN key references Alimentos(alimento_id),
	foreign key (menu_id) references Menus(menu_id),
    PRIMARY KEY (menu_id, alimento_ID)
)

create table Ordenes (
    orden_id int IDENTITY primary key,
    matricula int not null references Alumnos(matricula),
    diaInicio date not null,
    fecha date not null,
    menu_id int foreign key (menu_id) references Menus(menu_id)
    
)

CREATE TABLE OrdenDesglosada(
    orden_id INT references Ordenes(orden_id),
    alimento_ID int references Alimentos(alimento_ID),
    dia varchar(15) not null,
    primary key (orden_id, alimento_ID, dia)
)

CREATE TABLE PagoOrden(
	pago_id int identity primary key,
	orden_id int not null foreign key references Ordenes(orden_id),
	RFC nvarchar(13) not null foreign key references Tutores(RFC),
	total money not null,
    especial bit not null, 
)

CREATE TABLE PagoConcepto(
	pago_id int foreign key references PagoOrden(pago_id),
	folio int identity,
	cantidad money not null,
	fecha date not null,
	primary key (pago_id, folio)
)


CREATE TABLE Alergias(
    alu_matricula int FOREIGN KEY REFERENCES Alumnos(matricula),
    ingrediente_id int FOREIGN KEY REFERENCES Ingredientes(ingrediente_id),
    PRIMARY KEY (alu_matricula, ingrediente_id)
)

CREATE TABLE AlimentoContenido(
	alimento_id int foreign key references Alimentos(alimento_id),
	ingrediente_id int foreign key references Ingredientes(ingrediente_id),
	cantidad money not null, --Cantidad que lleva el alimento
	primary key(alimento_id,ingrediente_id)
)

--Nueva tabla en la que se registra la unidad especifica de cada ingrediente
create table IngredienteMedida(
	ing_id int primary key foreign key references Ingredientes(ingrediente_id),
	ing_unidadMedida varchar(5) not null
)

use master
drop database ComedorPinkFlor