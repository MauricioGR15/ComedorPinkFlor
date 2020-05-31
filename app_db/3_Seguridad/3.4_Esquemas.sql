use ComedorPinkFlor

go
create schema Comida AUTHORIZATION dbo
go
alter schema Comida transfer dbo.Ingredientes
alter schema Comida transfer dbo.IngredienteMedida
alter schema Comida transfer dbo.Alimentos
alter schema Comida transfer dbo.AlimentoContenido

go
create schema Servicios AUTHORIZATION dbo
go
alter schema Servicios transfer dbo.Ordenes
alter schema Servicios transfer dbo.OrdenDesglosada
alter schema Servicios transfer dbo.PagoOrden
alter schema Servicios transfer dbo.PagoConcepto
alter schema Servicios transfer dbo.Menus
alter schema Servicios transfer dbo.MenuContenido

go
create schema Escolar AUTHORIZATION dbo
go
alter schema Escolar transfer dbo.Alumnos
alter schema Escolar transfer dbo.Tutores
alter schema Escolar transfer dbo.TelefonosTutores
alter schema Escolar transfer dbo.Alergias
