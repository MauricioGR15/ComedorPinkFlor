package controllers;

import classes.Tutor;
import components.ModificarTutor;
import models.Modelo;

import javax.swing.*;
import java.sql.SQLException;

public class ModificarCon {

    private final ModificarTutor vista;
    Modelo modelo;

    public ModificarCon(ModificarTutor vista, Modelo modelo){
        this.modelo = modelo;
        this.vista = vista;
        escuchadores();
    }

    public void setState(Tutor tutor) {
        vista.tf_nombre.setText(tutor.getNombre());
        vista.tf_apellidoPat.setText(tutor.getApePat());
        vista.tf_apellidoMat.setText(tutor.getApeMat());
        vista.tf_trabajo.setText(tutor.getTrabajo());
    }

    public Tutor getState(){
        String rfc = vista.tf_rfc.getText();
        String nombre = vista.tf_nombre.getText();
        String apellidoP = vista.tf_apellidoPat.getText();
        String apellidoM = vista.tf_apellidoMat.getText();
        String trabajo = vista.tf_trabajo.getText();

        return new Tutor(rfc, nombre, apellidoP, apellidoM, trabajo, null);
    }

    private boolean checaEspacios(){
        if(vista.tf_rfc.getText().isEmpty() || vista.tf_nombre.getText().isEmpty() || vista.tf_apellidoPat.getText().isEmpty() ||
        vista.tf_apellidoMat.getText().isEmpty() || vista.tf_trabajo.getText().isEmpty()){
            JOptionPane.showMessageDialog(null, "Hay espacios vacíos");
            return false;
        }
        return true;
    }

    public void escuchadores(){
        vista.btn_buscar.addActionListener(e -> {

            try {
                Tutor tutor = modelo.selectTutor(vista.tf_rfc.getText());
                setState(tutor);
            } catch (SQLException | NullPointerException throwables) {
                JOptionPane.showMessageDialog(null, "No existe ese rfc en la base de datos");
            }
        });

        vista.btn_modificar.addActionListener(e -> {
            if(!checaEspacios())
                return;
            try {
                if(modelo.updateTutor(getState())){
                    JOptionPane.showMessageDialog(null, "Actualizado con éxito");
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        });
    }

}

