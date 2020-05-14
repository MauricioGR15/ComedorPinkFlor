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