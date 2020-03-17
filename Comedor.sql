CREATE DATABASE ComedorPinkFlor
GO

use ComedorPinkFlor

create table Tutores(
    tutor_RFC NVARCHAR(13) PRIMARY KEY,
    tutor_nombre NVARCHAR(30) not null,
    tutor_apellidoP NVARCHAR(30) not null,
    tutor_apellidoM NVARCHAR(30) not null,
    tutor_trabajo NVARCHAR(30) not null
)

CREATE table TelefonosTutores(
     tutor_RFC NVARCHAR(13) foreign key references Tutores(tutor_rfc),
     tutor_telefono numeric(10) unique not null,
    primary key (tutor_RFC, tutor_telefono)
)

create TABLE Alumnos(
    alu_matricula int PRIMARY KEY (alu_matricula),
    alu_nombre NVARCHAR(30) not null,
    alu_apellidoP NVARCHAR(30) not null,
    alu_apellidoM NVARCHAR(30) not null,
    alu_grado tinyint not null,
    alu_grupo CHAR(1) not null,
    tutor_RFC NVARCHAR(13) FOREIGN KEY REFERENCES Tutores(tutor_RFC)
)

CREATE TABLE Ingredientes(
    ing_id int IDENTITY (1,1) PRIMARY KEY,
    ing_nombre NVARCHAR (20) not null,
    ing_cantidad NUMERIC not null,
    ing_fechaCad DATE not null,
    ing_alergenico BIT not null
)

CREATE TABLE Alimentos(
    ali_ID INT IDENTITY (1,1) PRIMARY KEY,
    ali_nombre NVARCHAR(30) not null,
    ali_tipo CHAR(1) not null CONSTRAINT chk_tipoAlimento check (ali_tipo in ('B','C','P')),
    ali_carbos MONEY not null,
    ali_calorias MONEY not null,
    ali_proteinas MONEY not null,
    ali_grasas MONEY not null
)

CREATE TABLE Menus(
    menu_id INT,
    menu_renglon INT IDENTITY (1,1),
    menu_tipo BIT,
    menu_costo MONEY,
    PRIMARY KEY (menu_id)
)

CREATE TABLE MenuContenido(
    menu_id int,
    ali_ID int FOREIGN key references Alimentos(ali_id),
	foreign key (menu_id) references Menus(menu_id),
    PRIMARY KEY (menu_id, ali_ID)
)

CREATE TABLE Pagos(
    pago_ID int IDENTITY (1,1) not null,
    menu_id int not null,
    tutor_rfc NVARCHAR(13) not null,
	alu_matricula int,
    pago_cantidad MONEY not null,
    pago_concepto NVARCHAR(20) not null,
    pago_fecha DATE not null,
    FOREIGN KEY (tutor_rfc) REFERENCES Tutores(tutor_RFC),
    FOREIGN KEY (menu_id) REFERENCES Menus(menu_id),
	FOREIGN KEY (alu_matricula) REFERENCES Alumnos(alu_matricula),
    PRIMARY KEY (pago_ID, menu_id, tutor_rfc)
)

CREATE TABLE Alergias(
    alu_matricula int FOREIGN KEY REFERENCES Alumnos(alu_matricula),
    ing_id int FOREIGN KEY REFERENCES Ingredientes(ing_id),
    alergia_descripcion NVARCHAR(50) not null,
    PRIMARY KEY (alu_matricula, ing_id)
)

CREATE TABLE AlimentoContenido(
	ali_id int foreign key references Alimentos(ali_id),
	ing_id int foreign key references Ingredientes(ing_id),
	primary key(ali_id,ing_id)
)

use master
drop database ComedorPinkFlor