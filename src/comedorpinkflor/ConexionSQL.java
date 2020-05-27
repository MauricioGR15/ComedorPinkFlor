package comedorpinkflor;

import java.sql.*;
import javax.swing.JOptionPane;

public class ConexionSQL {

    static private Statement statement = null;
    static private Connection conn;

    static synchronized Statement getConexion(){
        if(statement == null) {
            String url = "jdbc:sqlserver://localhost;databaseName=ComedorPinkFlor;user=sa;password=sa;";

            try{
                conn = DriverManager.getConnection(url);
                statement = conn.createStatement();
            }catch (SQLException e){
                e.printStackTrace();
                return null;
            }
        }
        return statement;
    }

    static synchronized public void close(){
        try {
            conn.close();
            statement.close();
        }catch (SQLException ignored){
        }
    }


}