package controllers;

import classes.Alumno;
import components.FormularioAlumno;
import models.Modelo;

import javax.swing.*;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.sql.SQLException;
import java.util.ArrayList;

public class AgregarAlumnos implements ItemListener {

    private final FormularioAlumno vista;
    private final Modelo modelo;

    public AgregarAlumnos(FormularioAlumno vista, Modelo modelo){
        this.vista = vista;
        this.modelo = modelo;
        try {
            agregarTutores();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        escuchadores();
    }

    private Alumno getState(){
        int matricula = Integer.parseInt(vista.tf_noControl.getText());
        String nombre = vista.tf_nombre.getText();
        String apeP = vista.tf_apellidoPat.getText();
        String apeM = vista.tf_apellidoMat.getText();
        String rfc = (String) vista.cb_tutores.getSelectedItem();
        short grado = (short) vista.cb_grado.getSelectedItem();
        char grupo = (char) vista.cb_grupo.getSelectedItem();

        return new Alumno(matricula,nombre,apeP,apeM,rfc,grado,grupo);
    }

    private void escuchadores (){
        vista.btn_registrar.addActionListener(e -> {
            try{
                if(modelo.insertALumno(getState())){
                    JOptionPane.showMessageDialog(null, "Se registró con éxito");
                }
            }catch (SQLException error){
                System.out.println(error.getMessage());
                JOptionPane.showMessageDialog(null, "Fallo al registrar");
            }
        });
    }

    private void agregarTutores() throws SQLException {
        ArrayList<String> listaTutores = modelo.selectTutoresCombo();

        vista.cb_tutores.addItem("Seleccione");
        for (String tutor:listaTutores) {
            vista.cb_tutores.addItem(tutor);
        }
    }

    @Override
    public void itemStateChanged(ItemEvent e) {
        if(e.getStateChange()!=ItemEvent.SELECTED) {
            return;
        }
    }
}
