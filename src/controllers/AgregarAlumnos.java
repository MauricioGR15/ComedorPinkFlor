package controllers;

import Util.Util;
import classes.Alumno;
import components.FormularioAlumno;
import models.Modelo;


import javax.swing.*;
import javax.swing.event.PopupMenuEvent;
import javax.swing.event.PopupMenuListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.sql.SQLException;
import java.util.ArrayList;

public class AgregarAlumnos implements ItemListener, PopupMenuListener, KeyListener {

    private final FormularioAlumno vista;
    private final Modelo modelo;

    public AgregarAlumnos(FormularioAlumno vista, Modelo modelo) {
        this.vista = vista;
        this.modelo = modelo;
        try {
            agregarTutores();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        escuchadores();
    }

    private Alumno getState() {
        int matricula = Integer.parseInt(vista.tf_noControl.getText());
        String nombre = vista.tf_nombre.getText();
        String apeP = vista.tf_apellidoPat.getText();
        String apeM = vista.tf_apellidoMat.getText();
        String rfc = (String) vista.cb_tutores.getSelectedItem();
        short grado = (short) vista.cb_grado.getSelectedItem();
        char grupo = (char) vista.cb_grupo.getSelectedItem();

        return new Alumno(matricula, nombre, apeP, apeM, rfc, grado, grupo);
    }

    private void escuchadores() {
        vista.tf_noControl.addKeyListener(this);
        vista.tf_nombre.addKeyListener(this);
        vista.tf_apellidoPat.addKeyListener(this);
        vista.tf_apellidoMat.addKeyListener(this);
        vista.cb_tutores.addPopupMenuListener(this);

        vista.btn_registrar.addActionListener(e -> {
            if(!checaEspacios())
                return;
            try {
                if (modelo.insertALumno(getState())) {
                    JOptionPane.showMessageDialog(null, "Se registró con éxito");
                    reset();
                }
            } catch (SQLException error) {
                System.out.println(error.getMessage());
                JOptionPane.showMessageDialog(null, "Fallo al registrar");
            }
        });
    }

    private void agregarTutores() throws SQLException {
        ArrayList<String> listaTutores = modelo.selectTutoresCombo();

        vista.cb_tutores.addItem("Seleccione");
        for (String tutor : listaTutores) {
            vista.cb_tutores.addItem(tutor);
        }
    }

    private boolean checaEspacios(){
        if(vista.tf_noControl.getText().isEmpty() || vista.tf_nombre.getText().isEmpty() || vista.tf_apellidoPat.getText().isEmpty() ||
        vista.tf_apellidoMat.getText().isEmpty()){
            JOptionPane.showMessageDialog(null,"Hay espacios vacíos");
            return false;
        }
        return true;
    }

    private void reset(){
        vista.tf_noControl.setText("");
        vista.tf_nombre.setText("");
        vista.tf_apellidoPat.setText("");
        vista.tf_apellidoMat.setText("");
        vista.cb_tutores.setSelectedIndex(0);
    }

    @Override
    public void itemStateChanged(ItemEvent e) {
        if (e.getStateChange() != ItemEvent.SELECTED) {
            return;
        }

    }

    @Override
    public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
        vista.cb_tutores.removeAllItems();
        try {
            agregarTutores();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    @Override
    public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {

    }

    @Override
    public void popupMenuCanceled(PopupMenuEvent e) {

    }

    @Override
    public void keyTyped(KeyEvent e) {
        if (e.getSource() == vista.tf_noControl) {
            Util.onlyNumbers(e, (JTextField) e.getSource());
            Util.soundAlert(e, (JTextField) e.getSource(), 10);
        }
        if(e.getSource() == vista.tf_nombre || e.getSource() == vista.tf_apellidoPat || e.getSource() == vista.tf_apellidoMat){
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
