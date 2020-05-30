/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package comedorpinkflor;

import components.*;
import controllers.AgregarAlumnos;
import controllers.AgregarTutores;
import controllers.ConConsultas;
import controllers.ModificarCon;
import models.Modelo;

import javax.swing.*;
import java.sql.SQLException;
import java.sql.Statement;

public class ComedorPinkFlor {


    public static void main(String[] args) throws SQLException {


        Statement conexion = ConexionSQL.getConexion();
        if(conexion == null) {
            System.out.println("Conexion no realizada");
        }
        else {
            System.out.println("Conexion buena");
        }

        //Modelo
        Modelo modelo = new Modelo(conexion);

        //Vistas
        Principal vistaPrincipal = new Principal();
        FormularioTutores formularioTutores = new FormularioTutores();
        ModificarTutor modificarTutor = new ModificarTutor();
        FormularioAlumno formularioAlumno = new FormularioAlumno();
        Consultas consultas = new Consultas();
        Tabs tabs = new Tabs(formularioTutores.Tutores, modificarTutor.ModificarTutor, formularioAlumno.Alumno, consultas.Consultas);

        //Controladores
        AgregarTutores contAddTutores = new AgregarTutores(formularioTutores, modelo);
        ModificarCon conModTutor = new ModificarCon(modificarTutor, modelo);
        AgregarAlumnos conAddAlumnos = new AgregarAlumnos(formularioAlumno, modelo);
        ConConsultas conConsultas = new ConConsultas(consultas, modelo);




        vistaPrincipal.add(tabs.panelTabs);
        vistaPrincipal.setVisible(true);




    }
    
}
