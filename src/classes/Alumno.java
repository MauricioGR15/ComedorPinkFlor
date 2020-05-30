package classes;

public class Alumno {

    int matricula;
    String nombre, apellidoP, apellidoM, rfc;
    char grupo;
    short grado;

    public Alumno(int matricula, String nombre, String apellidoP, String apellidoM, String rfc, short grado, char grupo){
        this.matricula = matricula;
        this.nombre = nombre;
        this.apellidoP = apellidoP;
        this.apellidoM = apellidoM;
        this.rfc = rfc;
        this.grado = grado;
        this.grupo = grupo;
    }

    public int getMatricula() {
        return matricula;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApellidoP() {
        return apellidoP;
    }

    public String getApellidoM() {
        return apellidoM;
    }

    public String getRfc() {
        return rfc;
    }

    public char getGrupo() {
        return grupo;
    }

    public short getGrado() {
        return grado;
    }






}
