use ComedorPinkFlor

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