package classes;

import java.util.ArrayList;

public class Tutor {

    private final String rfc, nombre, apePat, apeMat, trabajo;
    private  final ArrayList<Long> telefonos;


    public Tutor(String rfc, String nombre, String apePat, String apeMat, String trabajo,ArrayList<Long> telefonos){
        this.rfc = rfc;
        this.nombre = nombre;
        this.apePat = apePat;
        this.apeMat = apeMat;
        this.telefonos = telefonos;
        this.trabajo = trabajo;
    }

    public String getRfc() {
        return rfc;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApePat() {
        return apePat;
    }

    public String getApeMat() {
        return apeMat;
    }

    public ArrayList<Long> getTelefonos() {
        return telefonos;
    }

    public String getTrabajo() {
        return trabajo;
    }
}
