use ComedorPinkFlor
--1 Vista para ver el menu de la semana
go
create view VW_MenuSemanal as 
SELECT a.nombre as Alimento, case a.tipo 
when 'C' then 'Comida'
when 'B' then 'Bebida'
when 'P' then 'Postre' end as Tipo FROM Servicios.Menus m inner JOIN Servicios.MenuContenido mc
on m.menu_id = mc.menu_id
inner JOIN Comida.Alimentos a
on a.alimento_id = mc.alimento_ID
WHERE fechaCreacion = (select max(fechaCreacion) FROM Servicios.Menus)

--2 Vista para ver las ordenes  de la semana
GO
create VIEW VW_OrdenesSemanal as 
SELECT t.nombre as Nombre, o.orden_id as NumOrden,po.total as Total FROM Servicios.Ordenes o 
inner JOIN Servicios.PagoOrden po
on o.orden_id = po.orden_id
INNER JOIN Escolar.Tutores t 
ON t.RFC = po.RFC
WHERE  DATENAME(week, GETDATE()) = DATENAME(week,o.fecha)

--3 Vista para mostrar los ingredietes que se tienen en stock
go
CREATE VIEW VW_IngredientesStock as
SELECT i.nombre as Nombre, CONCAT(i.cantidad,' ',im.ing_unidadMedida) as Cantidad FROM Comida.Ingredientes i inner join Comida.IngredienteMedida im 
on i.ingrediente_id = im.ing_id

--4 Vista para mostrar los alumnos que tienen alergias y a que son alergicos
go
CREATE VIEW VW_Alergias as
SELECT CONCAT(a.apellidoP,' ',a.apellidoM,' ',a.nombre)as Nombre,a.grado as Grado,a.grupo as grupo,
i.nombre as IngredienteMedida FROM Escolar.Alumnos a inner join Escolar.Alergias al 
on a.matricula = al.alu_matricula 
inner JOIN Comida.Ingredientes i
on i.ingrediente_id = al.ingrediente_id


--5 Vista para saber con anticipación cuantos niños recibirán cada alimento en la semana
go
create view VW_AlimentosSemanales as
SELECT nombre,COUNT(od.alimento_ID) as Cantidad from Servicios.Ordenes o 
inner JOIN Servicios.OrdenDesglosada od 
on od.orden_id =o.orden_id
inner JOIN Comida.Alimentos a 
on a.alimento_id = od.alimento_ID
WHERE  DATENAME(week, GETDATE()) = DATENAME(week,o.fecha)
group by nombre

select * from Comida.Alimentos