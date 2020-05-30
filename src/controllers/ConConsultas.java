package controllers;

import components.Consultas;
import models.Modelo;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.SQLException;

public class ConConsultas implements ActionListener {

    Consultas vista;
    Modelo modelo;

    public ConConsultas(Consultas vista, Modelo modelo) {
        this.vista = vista;
        this.modelo = modelo;
        try {
            vista.tablaVistas.setModel(modelo.vistaStock());
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        escuchadores();
    }

    public void escuchadores() {
        vista.rb_caducar.addActionListener(this);
        vista.rb_inventario.addActionListener(this);
        vista.rb_usados.addActionListener(this);
        vista.rb_alergicos.addActionListener(this);
    }

    public void handleChange(){
        try {
            if (vista.rb_inventario.isSelected()) {
                vista.tablaVistas.setModel(modelo.vistaStock());
            }
            else if (vista.rb_caducar.isSelected()) {
                vista.tablaVistas.setModel(modelo.vistaCaducar());
            }
            else if(vista.rb_alergicos.isSelected()){
                vista.tablaVistas.setModel(modelo.vistaAlergicos());
            }
            else{
                vista.tablaVistas.setModel(modelo.vistaIngredientesMasUsados());
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        handleChange();
    }
}
