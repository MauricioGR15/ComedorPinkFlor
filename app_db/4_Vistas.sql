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
SELECT i.nombre as Nombre, CONCAT(i.cantidad,' ',im.ing_unidadMedida) as Cantidad FROM Comida.Ingredientes i 
inner join Comida.IngredienteMedida im 
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



--Vista para obtener ingredientes cercanos a caducar o caducados
GO
create view vista_ingredientesPorCaducar as
select I.ingrediente_id, nombre Ingrediente, CONCAT(cantidad,' ',ing_unidadMedida) Existencia,
       IIF(DATEDIFF(DAY, fechaCad, GETDATE()) < 1,
           'Caducado',
           CONCAT(DATEDIFF(DAY, fechaCad, GETDATE()), N' días')) Restan
           from
Comida.Ingredientes I inner join Comida.IngredienteMedida IM
on I.ingrediente_id=IM.ing_id
where MONTH(fechaCad)=MONTH(GETDATE())

go
select * from vista_ingredientesPorCaducar

--Vista para ingredientes mas usados en Alimentos
GO
create view vista_IngredientesMasUsados as
select top (10) nombre, Cant  from
(select ingrediente_id, count(ingrediente_id) Cant from Comida.AlimentoContenido group by (ingrediente_id)) T
inner join Comida.Ingredientes I on
I.ingrediente_id = T.ingrediente_id
order by (Cant) desc


go
create view vista_niñosAlergias as
select a.matricula, a.nombre, apellidoP, a2.ingrediente_id id,c.nombre ingrediente from
Escolar.Alumnos a inner join Escolar.Alergias a2
on a.matricula = a2.alu_matricula
inner join Comida.Ingredientes c
on a2.ingrediente_id = c.ingrediente_id

go 
select distinct a.matricula from Escolar.Alumnos a INNER JOIN Escolar.Alergias a2
on a.matricula = a2.alu_matricula

go

select al.ingrediente_id, nombre from 
Escolar.Alergias al inner join Comida.Ingredientes c
on al.ingrediente_id = c.ingrediente_id 
where alu_matricula = 171567

go
select * from Escolar.Alergias where alu_matricula = 171567 and ingrediente_id = 5

go
TRUNCATE table Escolar.Alergias
go
insert Escolar.Alergias values 
(171567, 10),
(171567, 11),
(171567, 12),
(171567, 14),
(171567, 5),
(181517,1)
--(181517,2),
--(181517,3)

