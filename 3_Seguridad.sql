use ComedorPinkFlor

create role tutor
create role nutriologo
create role almacen 
create role cocina
create role cajero
create role administrador

create login tutor_1 with password = 'tutor123'
create login nutriologo_1 with password = 'nutri123'
create login almacen_1 with password = 'almacen123'
create login cocina_1 with password = 'cocina123'
create login cajero_1 with password = 'cajero123'
create login administrador_1 with password = 'amin123'

create user tutor1 for login tutor_1
create user nutriologo1 for login nutriologo_1
create user almacen1 for login almacen_1
create user cocina1 for login cocina_1
create user cajero1 for login cajero_1
create user admin1 for login administrador_1

alter role tutor add member tutor1
alter role nutriologo add member nutriologo1
alter role almacen add member  almacen1
alter role cocina add member cocina1
alter role cajero add member cajero1
alter role administrador add member admin1

create schema General

alter schema general transfer dbo.MenuVentasNutriologo
alter schema general transfer  dbo.MenusEleccionTutores
alter schema general transfer dbo.TelefonosTutoresAlergias
alter schema general transfer dbo.AlimentosMensuales
alter schema general transfer dbo.VentasMenuMensual

--Tutor
grant select on schema::general to tutor
deny insert, delete, update on schema::general to tutor
--Nutriologo
grant select, insert, execute, update on schema::general to nutriologo
deny delete on schema::general to nutriologo
--Almacen
grant select,update, execute on schema::general to almacen
deny insert, delete on schema::general to almacen
--Cocina
grant select on schema::general to cocina
deny delete, update, insert on schema::general to cocina
--Cajero/administrador
grant select, update, execute, insert, delete on schema::general to cajero
--AdminSistema
GRANT ALTER, CONTROL, DELETE, EXECUTE, INSERT, REFERENCES, SELECT, UPDATE, VIEW CHANGE TRACKING, VIEW DEFINITION ON Schema::dbo TO administrador
GRANT ALTER, CONTROL, DELETE, EXECUTE, INSERT, REFERENCES, SELECT, UPDATE, VIEW CHANGE TRACKING, VIEW DEFINITION ON Schema::general TO administrador