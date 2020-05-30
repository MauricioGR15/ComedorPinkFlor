package controllers;

import components.BajaAlergias;
import models.Modelo;

import java.sql.SQLException;
import java.util.ArrayList;

public class ConBaja {

    BajaAlergias vista;
    Modelo modelo;
    ArrayList<String> alumnos = null;

    public ConBaja(BajaAlergias vista, Modelo modelo){
        this.vista = vista;
        this.modelo = modelo;
        agregarInfo();
    }

    public void agregarInfo(){
        try {
            vista.tabla.setModel(modelo.vistaAlergias());
            alumnos = modelo.alumnosAlergias();

            vista.cb_alumnos.addItem("Seleccione");
            for(String alumno: alumnos){
                vista.cb_alumnos.addItem(alumno);
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

}
