create schema Comida AUTHORIZATION dbo

alter schema Comida transfer dbo.Ingredientes
alter schema Comida transfer dbo.IngredienteMedida
alter schema Comida transfer dbo.Alimentos
alter schema Comida transfer dbo.AlimentoContenido

create schema Servicios AUTHORIZATION dbo

alter schema Servicios transfer dbo.Ordenes
alter schema Servicios transfer dbo.OrdenDesglosada
alter schema Servicios transfer dbo.PagoOrden
alter schema Servicios transfer dbo.PagoConcepto
alter schema Servicios transfer dbo.Menus
alter schema Servicios transfer dbo.MenuContenido

create schema Escolar AUTHORIZATION dbo

alter schema Escolar transfer dbo.Alumnos
alter schema Escolar transfer dbo.Tutores
alter schema Escolar transfer dbo.TelefonosTutores
alter schema Escolar transfer dbo.Alergias

use ComedorPinkFlor

select * from dbo.Alumnos