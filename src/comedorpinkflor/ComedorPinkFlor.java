/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package comedorpinkflor;

import javax.swing.*;
import java.sql.SQLException;
import java.sql.Statement;

public class ComedorPinkFlor {


    public static void main(String[] args) throws SQLException {

        Statement conexion = ConexionSQL.getConexion();
        System.out.println("Conexion");
        if(conexion == null) {
            System.out.println("Conexion no realizada");
        }
        else {
            System.out.println("Conexion buena");
        }
    }
    
}
