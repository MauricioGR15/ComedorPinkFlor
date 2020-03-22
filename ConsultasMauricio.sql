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
select top (5) ing_nombre, Cant  from
(select ing_id, count(ing_id) Cant from AlimentoContenido group by (ing_id)) T
inner join Ingredientes I on
I.ing_id = T.ing_id
order by (Cant) desc


-- 34 Ingredientes por caducarse
select I.ing_id, ing_nombre Ingrediente, CONCAT(ing_cantidad,' ',ing_unidadMedida) Existencia,
       IIF(DATEDIFF(DAY, ing_fechaCad, GETDATE()) < 1,
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

