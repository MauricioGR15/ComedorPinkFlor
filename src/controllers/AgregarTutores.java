package controllers;

import classes.Tutor;
import components.FormularioTutores;
import models.Modelo;

import javax.swing.*;
import java.sql.SQLException;
import java.util.ArrayList;


public class AgregarTutores {

    FormularioTutores vista;
    Modelo modelo;
    Tutor tutor;

    public AgregarTutores(FormularioTutores formularioTutores, Modelo model){
        vista = formularioTutores;
        modelo = model;
        escuchadores();
    }

    private Tutor getState(){
        String rfc = vista.tf_rfc.getText();
        String nombre = vista.tf_nombre.getText();
        String apeP = vista.tf_apellidoPat.getText();
        String apeM = vista.tf_apellidoMat.getText();
        String trabajo = vista.tf_trabajo.getText();
        ArrayList<Long> telefonos = separarTelefonos(vista.tf_telefono.getText());

        return tutor = new Tutor(rfc, nombre, apeP, apeM, trabajo,telefonos);
    }

    public ArrayList<Long> separarTelefonos(String texto){

        String[] arregloString = texto.split(",\\s", -2);
        ArrayList<Long> telefonos = new ArrayList<>();

        for (String i: arregloString)
            telefonos.add(Long.parseLong(i));

        return telefonos;
    }

    public void escuchadores(){
        vista.btn_registrar.addActionListener(e -> {
            try {
                if(modelo.registrarTutor(getState())){
                    JOptionPane.showMessageDialog(null, "Se ha registrado con éxito");
                }
                else{
                    JOptionPane.showMessageDialog(null, "Ha ocurrido un error");
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        });
    }



}
