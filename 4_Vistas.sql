use ComedorPinkFlor
--1 Vista para ver el menu de la semana
go
create view VW_MenuSemanal as 
SELECT a.nombre as Alimento, case a.tipo 
when 'C' then 'Comida'
when 'B' then 'Bebida'
when 'P' then 'Postre' end as Tipo FROM Menus m inner JOIN MenuContenido mc
on m.menu_id = mc.menu_id
inner JOIN Alimentos a
on a.alimento_id = mc.alimento_ID
WHERE fechaCreacion = (select max(fechaCreacion) FROM Menus)

--2 Vista para ver las ordenes  de la semana
GO
create VIEW VW_OrdenesSemanal as 
SELECT t.nombre as Nombre, o.orden_id as NumOrden,po.total as Total FROM Ordenes o 
inner JOIN PagoOrden po
on o.orden_id = po.orden_id
INNER JOIN Tutores t 
ON t.RFC = po.RFC
WHERE  DATENAME(week, GETDATE()) = DATENAME(week,o.fecha)

--3 Vista para mostrar los ingredietes que se tienen en stock
go
CREATE VIEW VW_IngredientesStock as
SELECT i.nombre as Nombre, CONCAT(i.cantidad,im.ing_unidadMedida) as Cantidad FROM Ingredientes i inner join IngredienteMedida im 
on i.ingrediente_id = im.ing_id

--4 Vista para mostrar los alumnos que tienen alergias y a que son alergicos
go
CREATE VIEW VW_Alergias as
SELECT CONCAT(a.apellidoP,' ',a.apellidoM,' ',a.nombre)as Nombre,a.grado as Grado,a.grupo as grupo,
i.nombre as IngredienteMedida FROM Alumnos a inner join Alergias al 
on a.matricula = al.alu_matricula 
inner JOIN Ingredientes i
on i.ingrediente_id = al.ingrediente_id


--5 Vista para saber con anticipación cuantos niños recibirán cada alimento en la semana
go
create view VW_AlimentosSemanales as
SELECT nombre,COUNT(od.alimento_ID) as Cantidad from Ordenes o 
inner JOIN OrdenDesglosada od 
on od.orden_id =o.orden_id
inner JOIN Alimentos a 
on a.alimento_id = od.alimento_ID
WHERE  DATENAME(week, GETDATE()) = DATENAME(week,o.fecha)
group by nombre

