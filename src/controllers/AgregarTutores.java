package controllers;

import Util.Util;
import classes.Tutor;
import components.FormularioTutores;
import models.Modelo;

import javax.swing.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.sql.SQLException;
import java.util.ArrayList;


public class AgregarTutores implements KeyListener {

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

    public void setState(Tutor tutor) {
        vista.tf_rfc.setText(tutor.getRfc());
        vista.tf_nombre.setText(tutor.getNombre());
        vista.tf_apellidoPat.setText(tutor.getApePat());
        vista.tf_apellidoMat.setText(tutor.getApeMat());
        vista.tf_trabajo.setText(tutor.getTrabajo());
        vista.tf_telefono.setText("");
    }

    public ArrayList<Long> separarTelefonos(String texto){

        String[] arregloString = texto.split(",\\s", -2);
        ArrayList<Long> telefonos = new ArrayList<>();

        for (String i: arregloString)
            telefonos.add(Long.parseLong(i));

        return telefonos;
    }

    public void escuchadores(){
        vista.tf_rfc.addKeyListener(this);
        vista.tf_nombre.addKeyListener(this);
        vista.tf_apellidoMat.addKeyListener(this);
        vista.tf_apellidoPat.addKeyListener(this);
        vista.tf_trabajo.addKeyListener(this);

        vista.btn_registrar.addActionListener(e -> {
            if(!checarTextos())
                return;
            try {
                if(modelo.registrarTutor(getState())){
                    JOptionPane.showMessageDialog(null, "Se ha registrado con éxito");
                    setState(new Tutor("","","","","",null));
                }
                else{
                    JOptionPane.showMessageDialog(null, "Ha ocurrido un error");
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        });
    }

    public boolean checarTextos(){
        if(vista.tf_rfc.getText().isEmpty() || vista.tf_nombre.getText().isEmpty() || vista.tf_apellidoPat.getText().isEmpty() ||
        vista.tf_apellidoMat.getText().isEmpty() || vista.tf_telefono.getText().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Hay espacios en blanco");
            return false;
        }
        return true;
    }


    @Override
    public void keyTyped(KeyEvent e) {
        if(e.getSource() == vista.tf_rfc){
            Util.soundAlert(e, (JTextField) e.getSource(),13);
        }
        if(e.getSource() == vista.tf_nombre || e.getSource() == vista.tf_apellidoPat || e.getSource() == vista.tf_apellidoMat
        || e.getSource() == vista.tf_trabajo){
            Util.soundAlert(e, (JTextField) e.getSource(), 30);
        }
    }

    @Override
    public void keyPressed(KeyEvent e) {

    }

    @Override
    public void keyReleased(KeyEvent e) {

    }
}
