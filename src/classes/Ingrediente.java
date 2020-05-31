package classes;

public class Ingrediente {

    private final int Id;
    private final String nombre;

    public Ingrediente(int id, String nombre){
        Id = id;
        this.nombre = nombre;
    }

    public int getId() {
        return Id;
    }

    public String getNombre() {
        return nombre;
    }

    @Override
    public String toString() {
        return nombre;
    }
}
