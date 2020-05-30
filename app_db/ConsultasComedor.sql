use comedorpinkflor
/* 1. obtener los nombres de los tutores que deben dinero durante el mes de marzo del 2020*/
SELECT t.tutor_nombre FROM tutores t
inner JOIN Pagos p
on t.tutor_RFC = p.tutor_rfc
WHERE MONTH(p.pago_fecha) = 3
/* 2. obtener el nombre de los alumnos cuyos tutores deben mas de $100*/
SELECT a.alu_nombre FROM Alumnos a
WHERE a.tutor_RFC in 
(
    select Pagos.tutor_rfc FROM Pagos
    WHERE Pagos.pago_cantidad > 100
)
/* 3.Obtener el ingrediente mas utilizado en los menus que tienen adeudos los tutores */
GO
WITH ingredientesMenusPagos(ingredientesP)
as(
SELECT i.ing_nombre FROM Pagos p
JOIN MenuContenido mc on p.menu_id = mc.menu_id
JOIN AlimentoContenido ac on mc.ali_ID = ac.ali_id
join Ingredientes i on i.ing_id = ac.ing_id
)
SELECT top 1 ingredientesP from ingredientesMenusPagos
GROUP BY ingredientesP 
ORDER by COUNT(ingredientesP) DESC
/* 4.Obtener el nombre del tutor que debe mas dinero */
GO
with adeudostotal(tutor_rfc,total)
as
(
    select pagos.tutor_rfc,sum(Pagos.pago_cantidad) FROM Pagos
    GROUP BY Pagos.tutor_rfc
)
SELECT Tutores.tutor_nombre FROM Tutores
WHERE Tutores.tutor_RFC = 
(
    select top 1 adeudostotal.tutor_rfc FROM adeudostotal
    ORDER BY adeudostotal.total desc
)
/*5. Cuantas personas deben por cada concepto  */
SELECT Pagos.pago_concepto,COUNT(Pagos.pago_concepto) as Tutores from Pagos
GROUP BY Pagos.pago_concepto

/*6. Obtener los alimentos que tienen "pollo" como ingrediente y tienen mas de 300 calorias */
SELECT a.ali_nombre FROM Alimentos a
INNER JOIN AlimentoContenido ac on ac.ali_id = a.ali_ID
INNER JOIN Ingredientes i on i.ing_id = ac.ing_id
WHERE i.ing_nombre = 'pollo' and a.ali_calorias > 300

/*7. Obtener el ingrediente mas usado en los alimentos */
go
with cantidadIngredientes(nombre,cantidad)
AS
(
    SELECT Ingredientes.ing_nombre,COUNT(AlimentoContenido.ing_id) FROM Ingredientes
    JOIN AlimentoContenido ON Ingredientes.ing_id = AlimentoContenido.ing_id
    JOIN Alimentos on Alimentos.ali_ID = AlimentoContenido.ali_id
    GROUP BY Ingredientes.ing_nombre
)
SELECT top 1 * from cantidadIngredientes
ORDER BY cantidadIngredientes.cantidad DESC

/*8. Saber que alimentos estan almenos en 2 menus */
go
WITH mismosalimentos(alimentos,menus)
as(
SELECT MenuContenido.ali_ID,COUNT(MenuContenido.ali_ID) as menus from MenuContenido
GROUP BY MenuContenido.ali_ID
)
SELECT*FROM mismosalimentos
WHERE menus > 2

/*9. obtener las bebidas que estan en el menu mas caro */
select Alimentos.ali_nombre as Bebida from Alimentos
where ali_tipo = 'B' and ali_id in (
select ali_id as bebidas from MenuContenido
join Menus on MenuContenido.menu_id = Menus.menu_id
where (Menus.menu_id = (select top 1 Menu_id from Menus order by Menu_costo desc)))

/*10. obtener el nombre de los alumnos que tienen 'pastel' como postre */
use ComedorPinkFlor
SELECT Alumnos.alu_nombre FROM Alumnos
WHERE Alumnos.alu_matricula IN
(
select p.alu_matricula FROM pagos p
JOIN MenuContenido mc on mc.menu_id = p.menu_id
JOIN Alimentos a on a.ali_ID = mc.ali_ID
WHERE a.ali_nombre = 'pastel' and a.ali_tipo = 'p'
)

/*11.Obtener el nombre de los tutores el dia donde mas ventas hubo */
GO
WITH masventas(pagos,fecha)
as(
select COUNT(Pagos.pago_ID),Pagos.pago_fecha FROM Pagos
GROUP BY Pagos.pago_fecha
)
SELECT t.tutor_nombre,mv.pagos FROM Pagos p 
JOIN Tutores t on t.tutor_RFC = p.tutor_rfc
JOIN masventas mv on mv.fecha = p.pago_fecha
WHERE p.pago_fecha = 
(
SELECT top 1 masventas.fecha FROM masventas
ORDER BY masventas.pagos DESC
)
/*12.Obtener el nombre de los alumnos que comieron del mismo menu*/
SELECT Alumnos.alu_nombre, Pagos.menu_id FROM Alumnos
inner JOIN Pagos on Pagos.alu_matricula = Alumnos.alu_matricula
GROUP BY Pagos.menu_id, Alumnos.alu_nombre

/*13.Obtener el ID de los menus que tengan alimentos con
mas de 500 calorias durante el mes de enero*/
SELECT m.menu_id FROM Menus m
INNER JOIN MenuContenido mc on mc.menu_id = m.menu_id
INNER JOIN Alimentos a on a.ali_ID =mc.ali_ID
WHERE ali_calorias > 500

/*14 obtener las ganancias promedios durante el mes de marzo de cada grado*/
SELECT a.alu_grado,avg(p.pago_cantidad) as alumnos FROM Pagos p
INNER JOIN Alumnos a on a.alu_matricula = p.alu_matricula
WHERE year (p.pago_fecha) =1
GROUP by a.alu_grado

/*15 obtener el alumno de cada grado que haya tenido el menu mas caro*/
GO
WITH AlumnoMasCaro (costo)
AS(
    SELECT MAX(m.menu_costo)from Menus m
    JOIN Pagos p on m.menu_id = p.menu_id
    JOIN Alumnos a on p.alu_matricula = a.alu_matricula
    GROUP BY a.alu_grado
)
SELECT Alumnos.alu_nombre,Alumnos.alu_grado FROM Alumnos
INNER JOIN Pagos on Alumnos.alu_matricula = Pagos.alu_matricula
WHERE Pagos.pago_cantidad IN
(
    select*FROM AlumnoMasCaro
)
GROUP BY Alumnos.alu_grado,Alumnos.alu_nombre
/*16 Obetner el total de ventas de cada uno de los menus durante el mes de marzo*/
SELECT Menus.menu_renglon,count(Pagos.menu_id) as ventas FROM Menus 
inner JOIN Pagos on Pagos.menu_id = Pagos.menu_id
WHERE MONTH(Pagos.pago_fecha) =3
GROUP by  Menus.menu_renglon 

/*17 otener el grado que tenga el mayor numero de 
 alumnos que han consumido de un menu especial*/
SELECT top 1 Alumnos.alu_grado,Pagos.pago_cantidad FROM Alumnos
JOIN Pagos on Pagos.alu_matricula = Alumnos.alu_matricula
join Menus on Menus.menu_id = pagos.menu_id
WHERE Menus.menu_tipo = 0
ORDER BY Pagos.pago_cantidad DESC

/*18 obtener el nombre de los alumnos cuyos tutores trabajen donde mismo*/
GO
WITH MismoTrabajo(trabajo,tutores)
as
(
select tutor_trabajo,COUNT(tutor_trabajo) as tutores from Tutores
    GROUP BY tutor_trabajo
)
SELECT Alumnos.alu_nombre FROM Alumnos
INNER JOIN Tutores on Alumnos.tutor_RFC = Tutores.tutor_RFC
WHERE Tutores.tutor_trabajo in
(
    select MismoTrabajo.trabajo from MismoTrabajo
    WHERE MismoTrabajo.tutores > 1
)
/*19 obtener los numeros de telefono de los tutores de los alumnos
 que sufren alguna alergia*/

 SELECT tt.tutor_telefono,t.tutor_nombre from TelefonosTutores tt
 INNER JOIN Tutores t on t.tutor_RFC = tt.tutor_RFC
 INNER JOIN Alumnos a on t.tutor_RFC = a.tutor_RFC
 INNER JOIN Alergias al on al.alu_matricula = a.alu_matricula
 GROUP BY t.tutor_nombre,tt.tutor_telefono

/*20. obtener los postres que estuvieron en un menu especial */
SELECT a.ali_nombre,case a.ali_tipo when 'P' then 'Postre' end as tipo
FROM Alimentos a
INNER JOIN MenuContenido mc on mc.ali_ID = a.ali_ID
INNER JOIN Menus m on m.menu_id = mc.menu_id
WHERE m.menu_tipo = 0 and a.ali_tipo = 'P'

/*21. obtener el alimento con menos grasas de cada uno de los menus */
select alimentos.ali_nombre,alimentos.ali_grasas,case alimentos.ali_tipo 
when 'P' then 'Postre'
when 'B' then 'Bebida'
when 'C' then 'Comida'
end as tipos,
Pagos.menu_id FROM Pagos
JOIN MenuContenido on MenuContenido.menu_id = Pagos.menu_id
JOIN Alimentos on Alimentos.ali_ID = MenuContenido.ali_ID
WHERE Alimentos.ali_grasas IN
(
    select MIN(Alimentos.ali_grasas) from Pagos
    JOIN MenuContenido mc on mc.menu_id = Pagos.menu_id
    JOIN Alimentos on Alimentos.ali_ID = mc.ali_ID
    GROUP BY Pagos.menu_id
)

/*22. Obtner a los tutores que han gastado mas de $3000 en los ultimos 3 meses y
 darles un descuento del 10% y mostrar el total con el descuento*/
SELECT t.tutor_nombre,t.tutor_apellidoP,t.tutor_apellidoM,pago_cantidad,
(pago_cantidad*.9) as Con_Desc FROM Tutores t
join Pagos p on p.tutor_rfc = t.tutor_RFC
WHERE p.pago_cantidad >= 3000 and
(MONTH(p.pago_fecha) < GETDATE() and MONTH(p.pago_fecha)>DATEADD(m,-3,GETDATE()))

/*23. Obtener los nombres completos de los alumnos del grupo donde hay mas 
alumnos con alergias*/
GO
with GrupoMasAlgergias(grupo,NumAlumnos)
as
(
  select top 1 Alumnos.alu_grupo,COUNT(Alumnos.alu_grupo) as alumnos FROM  Alumnos
    JOIN Alergias on Alumnos.alu_matricula = Alergias.alu_matricula
    GROUP by Alumnos.alu_grupo
    ORDER BY alumnos desc
)
select CONCAT(a.alu_apellidoP,' ',a.alu_apellidoM,' ',alu_nombre) as Nombre_completo from Alumnos a
where a.alu_grupo = 
(
  select GrupoMasAlgergias.grupo FROM GrupoMasAlgergias
)
/*24. Conocer que tipo de menu fue el mas vendido en el ultimo mes y cuanto genero*/
GO
with MenuMasVendido (MenuTipo,cantidad)
as 
(
    SELECT top 1 m.menu_tipo,(m.menu_tipo) as cantidad FROM Menus m
    JOIN Pagos p on p.menu_id = m.menu_id
    GROUP BY m.menu_tipo
    ORDER BY cantidad desc
)
SELECT case m.menu_tipo 
when 0 then 'Especial'
when 1 then 'Normal'end as Tipo,
SUM(p.pago_cantidad) as Total
from Menus m
JOIN Pagos p on p.menu_id = m.menu_id
WHERE m.menu_tipo =
(
select MenuMasVendido.MenuTipo FROM MenuMasVendido
)
GROUP by m.menu_tipo

/*25. Obtener el nombre de los ingredientes que no han estado en ningun menu*/
SELECT i.ing_nombre FROM Ingredientes i
WHERE i.ing_id not IN
(
 select ac.ing_id from AlimentoContenido ac
 JOIN MenuContenido mc on mc.ali_ID = ac.ali_id
)

/*26. ver en cuantas veces aparece cada alimento en distintos menus*/
SELECT a.ali_nombre,COUNT(a.ali_nombre) as Veces_Repetidas FROM Alimentos a
JOIN MenuContenido mc on a.ali_ID =mc.ali_ID
GROUP BY a.ali_nombre

/*27. Obtener el nombre completo de los tutores que nunca han pedido un menu especial*/
SELECT t.tutor_nombre+' '+t.tutor_apellidoP+' '+coalesce(t.tutor_apellidoM,' ') as NombreCompleto
FROM Tutores t JOIN Pagos p on p.tutor_rfc = t.tutor_RFC
JOIN Menus m on m.menu_id = p.menu_id
WHERE m.menu_tipo != 0

/*28.Obtener las fechas en los que se sirvieron hamburguesas a los alumno de 5to
y 6t0 grado*/
SELECT p.pago_fecha,a.alu_nombre,a.alu_grado from pagos p
JOIN Alumnos a on a.alu_matricula = p.alu_matricula
JOIN MenuContenido mc on mc.menu_id = p.menu_id
JOIN Alimentos al on al.ali_ID = mc.ali_ID
WHERE (a.alu_grado = 5 OR a.alu_grado = 6)
AND al.ali_nombre = 'hamburguesa'

/*29.Obtener las ganancias mensuales de los menus normales y menus especiales*/
go
WITH GananciasMensualesMenu(Tipo,Mes,Cantidad)
as(
SELECT case m.menu_tipo when 0 then 'Especial' when 1 then 'Normal' end as Tipo ,
month(p.pago_fecha) as Mes ,p.pago_cantidad FROM Menus m
JOIN Pagos p on p.menu_id = m.menu_id
group BY MONTH(p.pago_fecha),m.menu_tipo,p.pago_cantidad
)
SELECT*FROM GananciasMensualesMenu gmm
PIVOT(sum(gmm.Cantidad) FOR Tipo IN (Especial,Normal)) 
as GananciasPivot

-- 31 Identificar quien no tiene registrado Apellido Materno

SELECT tutor_nombre,
       tutor_apellidoP,
       tutor_nombre+' '+tutor_apellidoP  AS NombrePrimerApellido,
       COALESCE(tutor_nombre+' '+tutor_apellidoP+' '+tutor_apellidoM,
           tutor_nombre+' '+tutor_apellidoM,
           'Sin apellido materno') AS [Nombre Completo]
FROM Tutores AS p;

-- 32 Existencia de los ingredientes en Almacen
select ing_nombre Ingrediente,CONCAT(ing_cantidad,' ',ing_unidadMedida) Existencia from Ingredientes
inner join IngredienteMedida
on Ingredientes.ing_id = IngredienteMedida.ing_id

-- 33 Ingredientes mas usados en Alimentos
select top (5) nombre, Cant  from
(select ingrediente_id, count(ingrediente_id) Cant from Comida.AlimentoContenido group by (ingrediente_id)) T
inner join Comida.Ingredientes I on
I.ingrediente_id = T.ingrediente_id
order by (Cant) desc


-- 34 Ingredientes por caducarse
select I.ing_id, ing_nombre Ingrediente, CONCAT(ing_cantidad,' ',ing_unidadMedida) Existencia,
       IF(DATEDIFF(DAY, ing_fechaCad, GETDATE()) < 1,
           'Caducado',
           CONCAT(DATEDIFF(DAY, ing_fechaCad, GETDATE()), N' días')) Restan
           from
Ingredientes I inner join IngredienteMedida IM
on I.ing_id=IM.ing_id
where MONTH(ing_fechaCad)=MONTH(GETDATE())

-- 35 Tutores con más de 2 niños
select tutor_apellidoP, tutor_nombre from Tutores T
inner join ((select tutor_RFC,count(tutor_RFC) cant from Alumnos group by (tutor_RFC))) T2
on T.tutor_RFC=T2.tutor_RFC
where cant > 1

--36 Menu con más calorias
select top(1) menu_id, avg(ali_calorias) PromedioCalorias from Alimentos inner join MenuContenido MC
    on Alimentos.ali_ID = MC.ali_ID
    group by (menu_id) order by (PromedioCalorias) desc

--37 Menu con menos calorías
select top(1) menu_id, avg(ali_calorias) PromedioCalorias from Alimentos inner join MenuContenido MC
    on Alimentos.ali_ID = MC.ali_ID
    group by (menu_id) order by (PromedioCalorias)

--38 Menu con mas proteinas
select top(1) menu_id, sum(ali_proteinas) ProteinasTotal from Alimentos inner join MenuContenido MC
    on Alimentos.ali_ID = MC.ali_ID
    group by (menu_id) order by (ProteinasTotal) desc

--39 Alimentos que estan en menus especiales
select distinct ali_nombre from menus m inner join MenuContenido
    MC on m.menu_id = MC.menu_id
    inner join Alimentos A on MC.ali_ID = A.ali_ID
    where menu_tipo = 0

--40 Alimentos que mas ingredientes usan
select top (5) ali_id,count(ing_id) [Ingredientes diferentes] from AlimentoContenido
group by  (ali_id) order by (count(ing_id)) desc

--41. Obtener número de telefono de los tutores que son Gerentes
Select tutor_telefono from
(Select tutor_trabajo, tutor_telefono from Tutores T
inner join TelefonosTutores TT
on T.tutor_RFC = TT.tutor_RFC
where tutor_trabajo = 'Gerente')TA

--42. Obtener el nombre de los tutores que no tienen telefono asignado
Select tutor_nombre+' '+tutor_apellidoP[NombreTutor] from
Tutores TU
inner join
(Select T.tutor_RFC from
Tutores T
left join TelefonosTutores TT
on T.tutor_RFC = TT.tutor_RFC
where TT.tutor_RFC is null)TEL
on TU.tutor_RFC = TEL.tutor_RFC

--43. Obtener la ID de los alimentos que utilizan menos ingredientes
Select top (2) ali_id,count(ing_id) [Ingredientes diferentes] from AlimentoContenido
group by  (ali_id) order by (count(ing_id))

--44. Obtener el nombre de los tutores que tengan alumnos de tercer grado
Select nombre+' '+apellidoP[NombreTutor] from Escolar.Tutores T
inner join
(Select RFC from Escolar.Alumnos
where grado = 3)TG
on T.RFC = TG.RFC

--45. Obtener el nombre de los alumnos que no pertenezcan al grupo A y sean de tercer grado
Select alu_nombre+' '+alu_apellidoP from Alumnos
where alu_grupo != 'A' and alu_grado = 3

--46. Obtener el número de pagos que ha realizado cada tutor
Select tutor_nombre+' '+tutor_apellidoP[NombreTutor], Pagos
from Tutores T inner join
(Select tutor_rfc, COUNT(pago_ID)[Pagos] from Pagos
GROUP BY tutor_rfc)TP
on T.tutor_RFC = TP.tutor_rfc

--47. Obtener el ingrediente que es alergenico por más alumnos
Select ing_nombre, MAX(Alergicos) from Ingredientes I
inner join
(Select ing_id, COUNT(alu_matricula)[Alergicos] from Alergias
GROUP BY ing_id)A
on I.ing_id = A.ing_id
GROUP BY ing_nombre

--48. Obtener los ingredientes más utilizados en alimentos
Select top 5 ingrediente_id, COUNT(alimento_id)Alimentos from Comida.AlimentoContenido
GROUP BY ingrediente_id
ORDER BY Alimentos desc

--49. Obtener el grupo que tenga más alumnos con alguna alergia
Select alu_grupo, MAX(AluAler) from
(Select alu_grupo,COUNT(distinct Alu.alu_matricula)AluAler from Alumnos Alu
inner join Alergias Ale
on Ale.alu_matricula = Alu.alu_matricula
GROUP BY alu_grupo)A
GROUP BY alu_grupo

--50. Menu con menos proteinas
select top(1) menu_id, sum(ali_proteinas) ProteinasTotal from Alimentos inner join MenuContenido MC
    on Alimentos.ali_ID = MC.ali_ID
    group by (menu_id) order by (ProteinasTotal)


use ComedorPinkFlor


