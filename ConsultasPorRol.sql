use ComedorPinkFlor
/* Consultas para tutores*/

/* 1. obtener los nombres de los tutores que deben dinero durante el mes de marzo del 2020*/
SELECT t.nombre FROM tutores t
 JOIN PagoMenu pm
on t.RFC = pm.RFC
join PagoConcepto pc
on pm.pago_id = pc.pago_id
WHERE MONTH(pc.fecha) = 3
/*9. obtener las bebidas que estan en el menu mas caro */
select Alimentos.nombre as Bebida from Alimentos
where tipo = 'B' and alimento_id in (
select alimento_id as bebidas from MenuContenido
join Menus on MenuContenido.menu_id = Menus.menu_id
where (Menus.menu_id = (select top 1 m.Menu_id from Menus m
join PagoMenu pm on pm.menu_id = m.menu_id order by pm.total desc)))

/*17 otener el grado que tenga el mayor numero de 
 alumnos que han consumido de un menu especial*/
SELECT top 1 a.grado,pm.total FROM Alumnos a
JOIN PagoMenu pm on pm.matricula = a.matricula
join Menus m on m.menu_id = pm.menu_id
WHERE m.tipo = 0
ORDER BY pm.total DESC
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
-- 31 Identificar quien no tiene registrado Apellido Materno

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
--39 Alimentos que estan en menus especiales
select distinct nombre from menus m inner join MenuContenido
    MC on m.menu_id = MC.menu_id
    inner join Alimentos A on MC.alimento_id = A.alimento_id
    where m.tipo = 0
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
/*21. obtener el alimento con menos grasas de cada uno de los menus */
select alimentos.nombre,alimentos.grasas,case alimentos.tipo 
when 'P' then 'Postre'
when 'B' then 'Bebida'
when 'C' then 'Comida'
end as tipos,
pm.menu_id FROM PagoMenu pm
JOIN MenuContenido on MenuContenido.menu_id = pm.menu_id
JOIN Alimentos on Alimentos.alimento_id = MenuContenido.alimento_ID
WHERE Alimentos.grasas IN
(
    select MIN(Alimentos.grasas) from PagoMenu pm
    JOIN MenuContenido mc on mc.menu_id = pm.menu_id
    JOIN Alimentos on Alimentos.alimento_id = mc.alimento_ID
    GROUP BY pm.menu_id
)
/*27. Obtener el nombre completo de los tutores que nunca han pedido un menu especial*/
SELECT t.nombre+' '+t.apellidoP+' '+coalesce(t.apellidoM,' ') as NombreCompleto
FROM Tutores t JOIN PagoMenu p on p.RFC = t.RFC
JOIN Menus m on m.menu_id = p.menu_id
WHERE m.tipo != 0
/*28.Obtener las fechas en los que se sirvieron hamburguesas a los alumno de 5to
y 6to grado*/
SELECT pc.fecha,a.nombre,a.grado from PagoMenu pm
JOIN PagoConcepto pc on pc.pago_id = pm.pago_id
JOIN Alumnos a on a.matricula = pm.matricula
JOIN MenuContenido mc on mc.menu_id = pm.menu_id
JOIN Alimentos al on al.alimento_id = mc.alimento_ID
WHERE (a.grado = 5 OR a.grado = 6)
AND al.nombre = 'hamburguesa'

--47. Obtener el ingrediente que es alergenico por más alumnos
Select nombre, MAX(Alergicos) from Ingredientes I
inner join
(Select ingrediente_id, COUNT(alu_matricula)[Alergicos] from Alergias
GROUP BY ingrediente_id)A
on I.ingrediente_id = A.ingrediente_id
GROUP BY i.nombre
--49. Obtener el grupo que tenga más alumnos con alguna alergia (corregir)
Select alu_grupo, MAX(AluAler) from
(Select alu_grupo,COUNT(distinct Alu.alu_matricula)AluAler from Alumnos Alu
inner join Alergias Ale
on Ale.alu_matricula = Alu.alu_matricula
GROUP BY alu_grupo)A
GROUP BY alu_grupo

/* Consultas para Almacen*/
/* 3.Obtener el ingrediente mas utilizado en los menus que tienen adeudos los tutores */
GO
WITH ingredientesMenusPagos(ingredientesP)
as(
SELECT i.nombre FROM Ingredientes i 
JOIN AlimentoContenido ac 
on i.ingrediente_id = ac.ingrediente_id
JOIN MenuContenido mc 
on mc.alimento_ID = ac.alimento_id
JOIN PagoMenu pm
on pm.pago_id = mc.menu_id
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

/*13.Obtener los ID de los menus vendidos que tuvieron alimentos con
mas de 500 calorias en el mes de enero*/
SELECT mc.menu_id FROM MenuContenido mc
JOIN PagoMenu pm on pm.menu_id = mc.menu_id
JOIN PagoConcepto pc on pc.pago_id = pm.pago_id
JOIN Alimentos a on a.alimento_id = mc.alimento_ID
WHERE a.calorias>500 and MONTH(pc.fecha) = 1
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
/*10. obtener los alumnos que tendran 'pastel' como postre el dia de hoy*/
use ComedorPinkFlor
SELECT Alumnos.nombre FROM Alumnos
WHERE Alumnos.RFC IN
(
select pm.RFC from PagoMenu pm 
JOIN PagoConcepto pc on pc.pago_id = pm.pago_id
JOIN MenuContenido mc on mc.menu_id = pm.menu_id
JOIN Alimentos ali on ali.alimento_id = mc.alimento_ID
JOIN Tutores t on t.RFC = pm.RFC
JOIN Alumnos a on a.RFC = t.RFC
WHERE ali.nombre = 'pastel' and ali.tipo = 'p'and pc.fecha = GETDATE()
)
/*12.Obtener a los alumnos que comeran del mismo menu el dia de hoy*/
SELECT a.nombre, pm.menu_id FROM Alumnos a
JOIN PagoMenu pm on pm.RFC = a.RFC
join PagoConcepto pc on pc.pago_id = pm.pago_id
WHERE pc.fecha = GETDATE()
GROUP BY pm.menu_id, a.nombre
/*20. obtener los postres que estuvieron en un menu especial */
SELECT a.nombre,case a.tipo when 'P' then 'Postre' end as tipo
FROM Alimentos a
INNER JOIN MenuContenido mc on mc.alimento_ID = a.alimento_ID
INNER JOIN Menus m on m.menu_id = mc.menu_id
WHERE m.tipo = 0 and a.tipo = 'P'
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
WHERE a.RFC in 
(
    select pm.RFC FROM PagoMenu pm
    JOIN PagoConcepto pc 
    ON pc.pago_id = pm.pago_id
    WHERE pc.cantidad > 100
)
/* 4.Obtener el nombre del tutor que debe mas dinero */
GO
with adeudostotal(tutor_rfc,total)
as
(
    select pm.RFC,sum(pc.cantidad) FROM PagoMenu pm
    JOIN PagoConcepto pc on pc.pago_id = pm.pago_id

    GROUP BY pm.RFC
)
SELECT Tutores.nombre FROM Tutores
WHERE Tutores.rfc = 
(
    select top 1 adeudostotal.tutor_rfc FROM adeudostotal
    ORDER BY adeudostotal.total desc
)
/*11.Obtener el nombre de los tutores el dia donde mas ventas hubo */
GO
WITH masventas(pagos,fecha)
as(
select COUNT(pc.pago_id),pc.fecha FROM PagoConcepto pc
GROUP BY pc.fecha
)
SELECT t.nombre,mv.pagos FROM PagoConcepto pc 
JOIN PagoMenu pm on pm.pago_id = pc.pago_id
JOIN Tutores t on t.RFC = pm.RFC
JOIN masventas mv on mv.fecha = pc.fecha
WHERE pc.fecha= 
(
SELECT top 1 masventas.fecha FROM masventas
ORDER BY masventas.pagos DESC
)
/*14 obtener las ganancias promedios durante el mes de marzo de cada grado*/
SELECT a.grado,avg(pc.cantidad) as alumnos FROM PagoConcepto pc
JOIN PagoMenu pm on pm.pago_id = pc.pago_id
join Alumnos a on a.matricula = pm.matricula
WHERE month (pc.fecha) =1
GROUP by a.grado
/*15 obtener el alumno de cada grado que haya tenido el menu mas caro*/
GO
WITH AlumnoMasCaro (costo)
AS(
    SELECT MAX(pm.total)from Menus m
    JOIN PagoMenu pm on m.menu_id = pm.menu_id
    JOIN Alumnos a on pm.matricula = a.matricula
    GROUP BY a.grado
)
SELECT a.nombre,a.grado FROM Alumnos a
INNER JOIN PagoMenu pm on a.matricula = pm.matricula
WHERE pm.total IN
(
    select*FROM AlumnoMasCaro
)
GROUP BY a.grado,a.nombre

/*16 Obetner el total de ventas de cada uno de los menus durante el mes de marzo*/
SELECT m.menu_id,count(pm.menu_id) as ventas FROM Menus m
JOIN PagoMenu pm on pm.menu_id = m.menu_id
JOIN PagoConcepto pc on pc.pago_id =pm.pago_id
WHERE MONTH(pc.fecha) =3
GROUP by  m.menu_id

/*22. Obtner a los tutores que han gastado mas de $3000 en los ultimos 3 meses y
 darles un descuento del 10% y mostrar el total con el descuento*/
SELECT t.nombre,t.apellidoP,t.apellidoM,pm.total,
(pm.total*.9) as Con_Desc FROM Tutores t
join PagoMenu pm on pm.RFC = t.RFC
join PagoConcepto pc on pc.pago_id = pm.pago_id
WHERE pm.total >= 3000 and
(MONTH(pc.fecha) < GETDATE() and MONTH(pc.fecha)>DATEADD(m,-3,GETDATE()))
/*24. Conocer que tipo de menu fue el mas vendido en el ultimo mes y cuanto genero*/
GO
with MenuMasVendido (MenuTipo,cantidad)
as 
(
    SELECT top 1 m.tipo,(m.tipo) as cantidad FROM Menus m
    JOIN PagoMenu pm on pm.menu_id = m.menu_id
    GROUP BY m.tipo
    ORDER BY cantidad desc
)
SELECT case m.tipo 
when 0 then 'Especial'
when 1 then 'Normal'end as Tipo,
SUM(pm.total) as Total
from Menus m
JOIN PagoMenu pm on pm.menu_id = m.menu_id
WHERE m.tipo =
(
select MenuMasVendido.MenuTipo FROM MenuMasVendido
)
GROUP by m.tipo
/*29.Obtener las ganancias mensuales de los menus normales y menus especiales*/
go
WITH GananciasMensualesMenu(Tipo,Mes,Cantidad)
as(
SELECT case m.tipo when 0 then 'Especial' when 1 then 'Normal' end as Tipo ,
month(pc.fecha) as Mes ,pm.total FROM Menus m
JOIN PagoMenu pm on pm.menu_id = m.menu_id
JOIN PagoConcepto pc on pc.pago_id = pm.pago_id
group BY MONTH(pc.fecha),m.tipo,pm.total
)
SELECT*FROM GananciasMensualesMenu gmm
PIVOT(sum(gmm.Cantidad) FOR Tipo IN (Especial,Normal)) 
as GananciasPivot

--46. Obtener el número de pagos que ha realizado cada tutor(checar este, noe entendi de donde viene el "pagos")
Select nombre+' '+apellidoP, Pagos
from Tutores T inner join
(Select pm.RFC, COUNT(pm.[pago_id])[PagoMenu] from PagoMenu pm
GROUP BY RFC)TP
on T.RFC = TP.RFC

/* Consultas para Admin SU*/    