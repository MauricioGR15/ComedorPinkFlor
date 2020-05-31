package controllers;

import classes.Ingrediente;
import components.BajaAlergias;
import models.Modelo;

import javax.swing.*;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.sql.SQLException;
import java.util.ArrayList;

public class ConBaja implements ItemListener {

    BajaAlergias vista;
    Modelo modelo;
    ArrayList<String> alumnos = null;

    public ConBaja(BajaAlergias vista, Modelo modelo) {
        this.vista = vista;
        this.modelo = modelo;
        agregarInfo();
        escuchadores();
    }

    public void agregarInfo() {
        try {
            vista.tabla.setModel(modelo.vistaAlergias());
            llenarAlumnos();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public void llenarAlumnos() throws SQLException {
        alumnos = modelo.alumnosAlergias();
        vista.cb_alumnos.removeAllItems();
        vista.cb_alumnos.addItem("Seleccione");
        for (String alumno : alumnos) {
            vista.cb_alumnos.addItem(alumno);
        }
    }

    public void llenarAlergias(int matricula) {
        vista.cb_alergias.removeAllItems();
        try {
            ArrayList<Ingrediente> ingredientes = modelo.alergiaDeAlumno(matricula);
            for (Ingrediente ing : ingredientes) {
                vista.cb_alergias.addItem(ing);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void escuchadores() {

        vista.cb_alergias.addItemListener(this);

        vista.btn_baja.addActionListener(e -> {
            if(vista.cb_alumnos.getSelectedIndex() == 0)
                return;
            int matricula = Integer.parseInt((String) vista.cb_alumnos.getSelectedItem());
            Ingrediente ing = (Ingrediente) vista.cb_alergias.getSelectedItem();
            int ingId = ing.getId();
            int res = JOptionPane.showConfirmDialog(null, "Está seguro de quitar esa alergia?");
            if(res  == JOptionPane.YES_OPTION){
                try {
                    boolean baja = modelo.bajaAlergia(matricula, ingId);
                    if(!baja){
                        JOptionPane.showMessageDialog(null,"Se ha quitado esa alérgia con éxito");
                        llenarAlergias(matricula);
                        vista.cb_alergias.setSelectedIndex(0);
                        vista.tabla.setModel(modelo.vistaAlergias());
                        vista.tabla.updateUI();
                    }
                } catch (Exception throwables) {
                    vista.cb_alergias.removeAllItems();
                    agregarInfo();
                }
            }
        });

        vista.cb_alumnos.addActionListener(e -> {
                    if (vista.cb_alumnos.getSelectedIndex() == 0){
                        vista.cb_alergias.removeAllItems();
                        return;
                    }

            String matricula = (String) vista.cb_alumnos.getSelectedItem();
            if(matricula == null) return;
            llenarAlergias(Integer.parseInt(matricula));
                }
        );

    }

    @Override
    public void itemStateChanged(ItemEvent e) {
        if(e.getStateChange()!=ItemEvent.SELECTED) {
            return;
        }
        if (vista.cb_alergias.getSelectedItem() == null)
            return;

        Ingrediente ing = (Ingrediente) vista.cb_alergias.getSelectedItem();
        System.out.println(ing.getId() + " " + ing.getNombre());

    }

}
