--Tutor
grant select on schema::Escolar to tutor
deny insert, delete, update on schema::Escolar to tutor
--Nutriologo
grant select, insert, execute, update on schema::Servicios to nutriologo
deny delete on schema::Servicios to nutriologo
grant select, insert, execute, update on schema::Comida to nutriologo
deny delete on schema::Comida to nutriologo
--Almacen
grant select,update, execute on schema::Comida to almacen
deny insert, delete on schema::Comida to almacen
--Cocina
grant select on schema::Comida to cocina
deny delete, update, insert on schema::Comida to cocina
--Cajero/administrador
grant select, update, execute, insert, delete on schema::Escolar to cajero
grant select, update, execute, insert, delete on schema::Servicios to cajero
--AdminSistema
GRANT ALTER, CONTROL, DELETE, EXECUTE, INSERT, REFERENCES, SELECT, UPDATE, VIEW CHANGE TRACKING, VIEW DEFINITION ON Schema::dbo TO administrador
GRANT ALTER, CONTROL, DELETE, EXECUTE, INSERT, REFERENCES, SELECT, UPDATE, VIEW CHANGE TRACKING, VIEW DEFINITION ON Schema::Comida TO administrador
GRANT ALTER, CONTROL, DELETE, EXECUTE, INSERT, REFERENCES, SELECT, UPDATE, VIEW CHANGE TRACKING, VIEW DEFINITION ON Schema::Servicios TO administrador
GRANT ALTER, CONTROL, DELETE, EXECUTE, INSERT, REFERENCES, SELECT, UPDATE, VIEW CHANGE TRACKING, VIEW DEFINITION ON Schema::Escolar TO administrador
