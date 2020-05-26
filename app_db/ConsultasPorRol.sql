use ComedorPinkFlor
--favor de recontar las consultas y ver cuantas nos faltan
/* Consultas para tutores*/

/* 1. obtener los nombres de los tutores que deben dinero durante el mes de marzo del 2020*/
SELECT t.nombre FROM tutores t
JOIN PagoOrden pm
on t.RFC = pm.RFC
join PagoConcepto pc
on pm.pago_id = pc.pago_id
WHERE MONTH(pc.fecha) = 3

/*17 obtener el grado que tenga el mayor numero de 
 alumnos que han consumido de un menu especial*/
SELECT top 1 a.grado,(po.orden_id) as Especiales FROM Alumnos a
JOIN PagoOrden po on po.RFC = a.RFC
WHERE po.especial = 1
ORDER BY a.grado, Especiales DESC
/*18 obtener el nombre de los alumnos cuyos tutores trabajen donde mismo*/
GO
WITH MismoTrabajo(trabajo,tutores)
as
(
select t.trabajo,COUNT(t.trabajo) as tutores from Tutores t
    GROUP BY trabajo
)
SELECT Alumnos.nombre FROM Alumnos
INNER JOIN Tutores on Alumnos.RFC = Tutores.RFC
WHERE Tutores.trabajo in
(
    select MismoTrabajo.trabajo from MismoTrabajo
    WHERE MismoTrabajo.tutores > 1
)
-- 31 Identificar quien no tiene registrado Apellido Materno--
SELECT nombre,
       apellidoP,
       nombre+' '+apellidoP  AS NombrePrimerApellido,
       COALESCE(tutor_nombre+' '+tutor_apellidoP+' '+tutor_apellidoM,
           tutor_nombre+' '+tutor_apellidoM,
           'Sin apellido materno') AS [Nombre Completo]
FROM Tutores AS p;
-- 35 Tutores con más de 2 niños
select t.apellidoP, t.nombre from Tutores T
inner join ((select RFC,count(RFC) cant from Alumnos group by (RFC))) T2
on T.RFC=T2.RFC
where cant > 1

--36 Menu con más calorias
select top(1) menu_id, avg(calorias) PromedioCalorias from Alimentos inner join MenuContenido MC
    on Alimentos.alimento_id = MC.alimento_ID
    group by (menu_id) order by (PromedioCalorias) desc
--37 Menu con menos calorías
select top(1) menu_id, avg(calorias) PromedioCalorias from Alimentos inner join MenuContenido MC
    on Alimentos.alimento_id = MC.alimento_ID
    group by (menu_id) order by (PromedioCalorias)
--38 Menu con mas proteinas
select top(1) menu_id, sum(proteinas) ProteinasTotal from Alimentos inner join MenuContenido MC
    on Alimentos.alimento_id = MC.alimento_id
    group by (menu_id) order by (ProteinasTotal) desc
--39 Alimentos que estan en Ordenes especiales
select distinct nombre from PagoOrden po
INNER JOIN OrdenDesglosada od on od.orden_id = po.orden_id
inner join Alimentos A on od.alimento_ID = A.alimento_id
where po.especial = 1
--41. Obtener número de telefono de los tutores que son Gerentes
Select t.trabajo, tt.telefono from Tutores T
inner join TelefonosTutores TT
on T.RFC = TT.RFC
where t.trabajo = 'Gerente'
--42. Obtener el nombre de los tutores que no tienen telefono asignado
Select nombre+' '+apellidoP from
Tutores TU
inner join
(Select T.RFC from
Tutores T
left join TelefonosTutores TT
on T.RFC = TT.RFC
where TT.RFC is null)TEL
on TU.RFC = TEL.RFC
--44. Obtener el nombre de los tutores que tengan alumnos de tercer grado
Select nombre+' '+apellidoP from Tutores T
inner join
(Select RFC from Alumnos
where grado = 3)TG
on T.RFC = TG.RFC
--45. Obtener el nombre de los alumnos que no pertenezcan al grupo A y sean de tercer grado
Select nombre+' '+apellidoP from Alumnos
where grupo != 'A' and grado = 3
--50. Menu con menos proteinas
select top(1) menu_id, sum(proteinas) ProteinasTotal from Alimentos inner join MenuContenido MC
    on Alimentos.alimento_id = MC.alimento_id
    group by (menu_id) order by (ProteinasTotal)



/* Consultas para nutriologo*/
/*6. Obtener los alimentos que tienen "pollo" como ingrediente y tienen mas de 300 calorias */
SELECT a.nombre FROM Alimentos a
INNER JOIN AlimentoContenido ac on ac.alimento_id = a.alimento_id
INNER JOIN Ingredientes i on i.ingrediente_id = ac.ingrediente_id
WHERE i.nombre = 'pollo' and a.calorias > 300
/*8. Saber que alimentos estan almenos en 2 menus */
go
WITH mismosalimentos(alimentos,menus)
as(
SELECT MenuContenido.alimento_ID,COUNT(MenuContenido.alimento_ID) as menus from MenuContenido
GROUP BY MenuContenido.alimento_ID
)
SELECT*FROM mismosalimentos
WHERE menus > 2
/*21. obtener los alimentos con menos grasas de cada uno de los menus */
SELECT mc.menu_id,nombre,grasas FROM Alimentos a inner JOIN MenuContenido mc
on a.alimento_id = mc.alimento_ID
WHERE tipo ='C'
GROUP by mc.menu_id,nombre,grasas
ORDER by grasas

/*27. Obtener el nombre completo de los tutores que nunca han pedido un menu especial*/
SELECT  t.nombre+' '+t.apellidoP+' '+coalesce(t.apellidoM,' ') as NombreCompleto
FROM Tutores t JOIN PagoOrden po on po.RFC = t.RFC
WHERE po.especial = 0
/*28.Obtener las fechas en los que se sirvieron hamburguesas a los alumno de 5to
o 6to grado*/
SELECT pc.fecha,al.grado from Alimentos a
JOIN PagoConcepto pc on pc.pago_id = a.alimento_id
JOIN PagoOrden po on po.pago_id = pc.pago_id
JOIN Alumnos al on al.RFC =po.RFC
WHERE (al.grado = 5 OR al.grado = 6)
AND al.nombre = 'hamburguesa'

--47. Obtener el ingrediente que es alergenico por más alumnos
Select nombre, MAX(Alergicos) from Ingredientes I
inner join
(Select ingrediente_id, COUNT(alu_matricula)[Alergicos] from Alergias
GROUP BY ingrediente_id)A
on I.ingrediente_id = A.ingrediente_id
GROUP BY i.nombre
--49. Obtener el grado que tenga más alumnos con alguna alergia
SELECT top 1 grado, COUNT(matricula) as NumAlumnos FROM Alumnos inner join Alergias
on Alumnos.matricula = Alergias.alu_matricula
group by grado
ORDER by NumAlumnos desc

/* Consultas para Almacen*/
/* 3.Obtener el ingrediente mas utilizado en los menus que tienen adeudos los tutores */
GO
WITH ingredientesMenusPagos(ingredientesP)
as(
SELECT i.nombre FROM Ingredientes i 
JOIN AlimentoContenido ac 
on i.ingrediente_id = ac.ingrediente_id
JOIN OrdenDesglosada od
on od.alimento_ID=ac.alimento_id
JOIN PagoOrden po 
on po.orden_id = od.orden_id
)
SELECT top 1 ingredientesP as Ingrediente from ingredientesMenusPagos
GROUP BY ingredientesP 
ORDER by COUNT(ingredientesP) DESC
/*7. Obtener el ingrediente mas usado en los alimentos */
go
with cantidadIngredientes(nombre,cantidad)
AS
(
    SELECT Ingredientes.nombre,COUNT(AlimentoContenido.ingrediente_id) FROM Ingredientes
    JOIN AlimentoContenido ON Ingredientes.ingrediente_id = AlimentoContenido.ingrediente_id
    JOIN Alimentos on Alimentos.alimento_id = AlimentoContenido.alimento_id
    GROUP BY Ingredientes.nombre
)
SELECT top 1 * from cantidadIngredientes
ORDER BY cantidadIngredientes.cantidad DESC

/*13.Obtener los ID de las ordenes vendidas que tuvieron alimentos con
mas de 500 calorias en el ultimo mes*/
SELECT o.orden_id, MONTH(fecha) as mes FROM Ordenes o
JOIN PagoOrden po on po.orden_id = o.orden_id
JOIN OrdenDesglosada od on od.orden_id = po.orden_id
JOIN Alimentos a on a.alimento_id = od.alimento_ID
WHERE a.calorias>500 and MONTH(o.fecha) = (MONTH(GETDATE())-1)
/*19 obtener los numeros de telefono de los tutores de los alumnos
 que sufren alguna alergia*/

 SELECT tt.telefono,t.nombre from TelefonosTutores tt
 INNER JOIN Tutores t on t.RFC = tt.RFC
 INNER JOIN Alumnos a on t.RFC = a.RFC
 INNER JOIN Alergias al on al.alu_matricula = a.matricula
 GROUP BY t.nombre,tt.telefono
 /*23. Obtener los nombres completos de los alumnos del grupo donde hay mas 
alumnos con alergias*/
GO
with GrupoMasAlgergias(grupo,NumAlumnos)
as
(
  select top 1 Alumnos.grupo,COUNT(Alumnos.grupo) as alumnos FROM  Alumnos
    JOIN Alergias on Alumnos.matricula = Alergias.alu_matricula
    GROUP by Alumnos.grupo
    ORDER BY alumnos desc
)
select CONCAT(a.apellidoP,' ',a.apellidoM,' ',a.nombre) as Nombre_completo from Alumnos a
where a.grupo = 
(
  select GrupoMasAlgergias.grupo FROM GrupoMasAlgergias
)
-- 32 Existencia de los ingredientes en Almacen
select nombre Ingrediente,CONCAT(cantidad,' ',ing_unidadMedida) Existencia from Ingredientes
inner join IngredienteMedida
on Ingredientes.ingrediente_id = IngredienteMedida.ing_id
-- 33 Ingredientes mas usados en Alimentos
select top (5) nombre, Cant  from
(select ingrediente_id, count(ingrediente_id) Cant from AlimentoContenido group by (ingrediente_id)) T
inner join Ingredientes I on
I.ingrediente_id = T.ingrediente_id
order by (Cant) desc
-- 34 Ingredientes por caducarse
select I.ingrediente_id, nombre Ingrediente, CONCAT(cantidad,' ',ing_unidadMedida) Existencia,
       IIF(DATEDIFF(DAY, ing_fechaCad, GETDATE()) < 1,
           'Caducado',
           CONCAT(DATEDIFF(DAY, ing_fechaCad, GETDATE()), N' días')) Restan
           from
Ingredientes I inner join IngredienteMedida IM
on I.ingrediente_id=IM.ing_id
where MONTH(fechaCad)=MONTH(GETDATE())




/* Consultas para Cocina*/ 
/*10. obtener los alumnos que tendran/tuvieron 'pastel' como postre en el mes*/
use ComedorPinkFlor
SELECT Alumnos.nombre FROM Alumnos
WHERE Alumnos.RFC IN
(
select po.RFC from PagoOrden po
JOIN Ordenes o on o.orden_id = po.orden_id
JOIN OrdenDesglosada od on od.orden_id = o.orden_id
JOIN Alimentos ali on ali.alimento_id = od.alimento_ID
JOIN Tutores t on t.RFC = po.RFC
JOIN Alumnos a on a.RFC = t.RFC
WHERE ali.nombre = 'pastel' and ali.tipo = 'p'and month(o.fecha) = month(GETDATE())
)
/*12.Obtener a los alumnos que comeran el mismo postre en la semana*/
SELECT a.nombre,al.nombre FROM Alumnos a
JOIN PagoOrden po on po.RFC = a.RFC
join Ordenes o on o.orden_id = po.orden_id
JOIN OrdenDesglosada od on od.orden_id = po.orden_id
JOIN Alimentos al on al.alimento_id = od.alimento_ID
WHERE  DATENAME(week, GETDATE()) = DATENAME(week,o.fecha) and count(al.alimento_id)>2 and al.tipo = 'P'
GROUP BY a.nombre, al.nombre

/*20. obtener los postres que estuvieron en un menu especial */
SELECT a.nombre,case a.tipo when 'P' then 'Postre' end as tipo
FROM Alimentos a
INNER JOIN OrdenDesglosada od 
on od.alimento_ID = a.alimento_id
INNER JOIN Ordenes o 
on o.orden_id = od.orden_id
INNER JOIN PagoOrden po 
on po.orden_id = o.orden_id
WHERE po.especial = 0 and a.tipo = 'P'
/*25. Obtener el nombre de los ingredientes que no han estado en ningun menu*/
SELECT i.nombre FROM Ingredientes i
WHERE i.ingrediente_id not IN
(
 select ac.ingrediente_id from AlimentoContenido ac
 JOIN MenuContenido mc on mc.alimento_ID = ac.ingrediente_id
)
/*26. ver en cuantas veces aparece cada alimento en distintos menus*/
SELECT a.nombre,COUNT(a.nombre) as Veces_Repetidas FROM Alimentos a
JOIN MenuContenido mc on a.alimento_id =mc.alimento_ID
GROUP BY a.nombre
--40 Alimentos que mas ingredientes usan
select top (5) alimento_id,count(ingrediente_id) [Ingredientes diferentes] from AlimentoContenido
group by  (alimento_id) order by (count(ingrediente_id)) desc
--43. Obtener la ID de los alimentos que utilizan menos ingredientes
Select top (2) alimento_id,count(ingrediente_id) [Ingredientes diferentes] from AlimentoContenido
group by  (alimento_id) order by (count(ingrediente_id))
--48. Obtener los ingredientes más utilizados en alimentos
Select top 5 ingrediente_id, COUNT(alimento_id)Alimentos from AlimentoContenido
GROUP BY ingrediente_id
ORDER BY Alimentos desc


/* Consultas para Cajero*/
/* 2. obtener el nombre de los alumnos cuyos tutores deben mas de $100*/
SELECT a.nombre FROM Alumnos a
JOIN PagoOrden po ON
a.RFC = po.RFC
JOIN Ordenes o ON
o.orden_id = po.orden_id
where po.pago_id NOT IN
(
    select pago_id FROM PagoConcepto
    WHERE total>100
)
/* 4.Obtener el nombre del tutor que pago mas en la semana*/
--falta como saber que debe
select nombre as Nombre,apellidoP as ApellidoPaterno,apellidoM as ApellidoMaterno FROM Tutores t
WHERE RFC in
(
select top 1 po.RFC FROM PagoOrden po INNER JOIN PagoConcepto pc on po.pago_id = pc.pago_id
WHERE DATENAME(week, GETDATE()) = DATENAME(week,pc.fecha)
ORDER BY total desc 
)
/*11.Obtener el nombre de los tutores la semana donde hubo mas ventas  */
GO
WITH masventas(pagos,fecha)
as(
select COUNT(pc.pago_id),pc.fecha FROM PagoConcepto pc
GROUP BY pc.fecha
)
SELECT t.nombre,mv.pagos FROM PagoConcepto pc 
JOIN PagoOrden po on po.pago_id = pc.pago_id
JOIN Tutores t on t.RFC = po.RFC
JOIN masventas mv on mv.fecha = pc.fecha
WHERE pc.fecha= 
(
SELECT top 1 masventas.fecha FROM masventas
ORDER BY masventas.pagos DESC
)
/*14 obtener las ganancias promedios durante el mes de marzo de cada grado*/
SELECT a.grado,avg(pc.cantidad) as alumnos FROM PagoConcepto pc
JOIN PagoOrden po on po.pago_id = pc.pago_id
join Alumnos a on a.RFC = po.RFC
WHERE month (pc.fecha) =1
GROUP by a.grado
/*15 obtener el alumno de cada grado que haya tenido la orden semanal mas cara*/
GO
WITH AlumnoMasCaro (costo)
AS(
    SELECT MAX(po.total)from PagoOrden po
    JOIN Alumnos a on po.RFC = a.RFC
    GROUP BY a.grado
)
SELECT a.nombre,a.grado FROM Alumnos a
INNER JOIN PagoOrden po on a.RFC = po.RFC
WHERE po.total IN
(
    select*FROM AlumnoMasCaro
)
GROUP BY a.grado,a.nombre

/*16 Obetner el total de ventas de cada uno de los menus del mes*/
SELECT m.menu_id,count(po.orden_id) as Ventas FROM PagoOrden po
INNER JOIN Ordenes o on po.orden_id = o.orden_id
INNER JOIN Menus m on m.menu_id = o.menu_id
WHERE MONTH(GETDATE())=MONTH(fecha)
GROUP by m.menu_id


/*24. Conocer que tipo de menu fue el mas vendido en el ultimo mes y cuanto genero*/
GO
with MenuMasVendido (MenuTipo,cantidad)
as 
(
    SELECT top 1 po.especial,(po.total) as cantidad FROM Menus m
    JOIN PagoOrden po on po.menu_id = m.menu_id
    GROUP BY po.especial
    ORDER BY cantidad desc
)
SELECT case po.especial
when 0 then 'Especial'
when 1 then 'Normal'end as Tipo,
SUM(po.total) as Total
from Menus m
JOIN PagoOrden po on po.menu_id = m.menu_id
WHERE po.especial =
(
select MenuMasVendido.MenuTipo FROM MenuMasVendido
)
GROUP by po.especial
/*29.Obtener las ganancias mensuales de los menus normales y menus especiales*/
go
WITH GananciasMensualesMenu(Tipo,Mes,Cantidad)
as(
SELECT case po.especial when 0 then 'Especial' when 1 then 'Normal' end as Tipo ,
month(pc.fecha) as Mes ,po.total FROM Menus m
JOIN PagoOrden po on po.menu_id = m.menu_id
JOIN PagoConcepto pc on pc.pago_id = po.pago_id
group BY MONTH(pc.fecha),po.especial,po.total
)
SELECT*FROM GananciasMensualesMenu gmm
PIVOT(sum(gmm.Cantidad) FOR Tipo IN (Especial,Normal)) 
as GananciasPivot

--46. Obtener el número de ordenes que ha realizado cada tutor
SELECT t.RFC as RFC,t.nombre as NombreTutor,count(o.orden_id) as Ordenes FROM Ordenes o
INNER JOIN PagoOrden po on o.orden_id = po.orden_id
INNER JOIN Tutores t on t.RFC = po.RFC
GROUP BY t.RFC,t.nombre
/*2. obtener las bebidas que estaban en la orden mas cara*/
select Alimentos.nombre as Bebida from Alimentos
where tipo = 'B' and alimento_id in (
select alimento_id from OrdenDesglosada od
where od.orden_id = 
(
    select top 1 orden_id FROM PagoOrden po order by po.total desc
)
)

/* Consultas para Admin SU*/    