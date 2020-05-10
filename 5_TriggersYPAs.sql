--Procedimientos Almacenados
--1 Saber que Comidas puedo hacer con los ingredientes que se tienen el almacen
CREATE PROCEDURE ComidasDisponibles as
SELECT a.nombre as Comidas FROM Alimentos a 
INNER JOIN AlimentoContenido ac
on a.alimento_id = ac.alimento_id
INNER JOIN Ingredientes i 
on ac.ingrediente_id = i.ingrediente_id
WHERE i.ingrediente_id NOT IN
(
select ing_id from Ingredientes i 
inner join IngredienteMedida im
on i.ingrediente_id=im.ing_id
WHERE cantidad < 1
)
GROUP BY a.nombre

EXEC ComidasDisponibles

