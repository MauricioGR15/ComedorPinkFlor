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


/* Consultas para nutriologo*/
/*6. Obtener los alimentos que tienen "pollo" como ingrediente y tienen mas de 300 calorias */
SELECT a.nombre FROM Alimentos a
INNER JOIN AlimentoContenido ac on ac.id = a.alimento_id
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
/* Consultas para Admin SU*/    