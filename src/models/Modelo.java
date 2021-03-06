package models;

import classes.Alumno;
import classes.Ingrediente;
import classes.Tutor;

import javax.swing.table.DefaultTableModel;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Modelo {

    private final Statement connection;
    private String query;

    public Modelo(Statement con) {
        connection = con;
    }

    public boolean registrarTutor(Tutor tutor) throws SQLException {
        query = "exec SP_InsertaTutor '" + tutor.getRfc() + "','" + tutor.getNombre() + "','" + tutor.getApePat() + "',"
                + "'" + tutor.getApeMat() + "','" + tutor.getTrabajo() + "'";
        try {
            abrirTran();
            connection.execute(query);
            for (Long tel : tutor.getTelefonos())
                insertTelefono(tutor.getRfc(), tel);
            commitTran();
        } catch (SQLException e) {
            rollback();
            System.out.println(e.getMessage());
            return false;
        }
        return true;
    }

    public void insertTelefono(String rfc, long tel) throws SQLException {
        query = "exec SP_InsertTelefono '" + rfc + "'," + tel;
        connection.execute(query);

    }

    public ArrayList<String> selectTutoresCombo() throws SQLException {
        query = "select rfc from Escolar.Tutores";
        ResultSet rs = connection.executeQuery(query);
        ArrayList<String> listaTutores = new ArrayList<>();

        while (rs.next())
            listaTutores.add(rs.getString("rfc"));

        return listaTutores;
    }

    public Tutor selectTutor(String rfc) throws SQLException {
        query = "select rfc, nombre, apellidoP, apellidoM, trabajo from Escolar.Tutores where rfc = '" + rfc + "'";
        ResultSet rs = connection.executeQuery(query);
        String nom = "", apeP = "", apeM = "", trabajo = "";

        if (!rs.isBeforeFirst())
            return null;

        while (rs.next()) {
            nom = rs.getString("nombre");
            apeP = rs.getString("apellidoP");
            apeM = rs.getString("apellidoM");
            trabajo = rs.getString("trabajo");
        }
        return new Tutor(rfc, nom, apeP, apeM, trabajo, null);
    }

    public boolean updateTutor(Tutor tutor) throws SQLException {
        query = "exec sp_updateTutor '" + tutor.getRfc() + "','" + tutor.getNombre() + "','" + tutor.getApePat() + "',"
                + "'" + tutor.getApeMat() + "','" + tutor.getTrabajo() + "'";
        connection.execute(query);
        return true;
    }

    public boolean insertALumno(Alumno alumno) throws SQLException {
        query = "exec sp_insertAlumno " + alumno.getMatricula() + ", '" + alumno.getNombre() + "','" + alumno.getApellidoP() +
                "','" + alumno.getApellidoM() + "'," + alumno.getGrado() + ",'" + alumno.getGrupo() + "','" + alumno.getRfc() + "'";
        connection.execute(query);
        return true;
    }

    public DefaultTableModel vistaStock() throws SQLException {
        query = "select * from VW_IngredientesStock";
        ResultSet rs = connection.executeQuery(query);
        String[] columnas = {"Ingrediente", "Cantidad"};
        String[] registros = new String[columnas.length];
        DefaultTableModel tableModel = new DefaultTableModel(null, columnas);

        while (rs.next()) {
            registros[0] = rs.getString("Nombre");
            registros[1] = rs.getString("Cantidad");
            tableModel.addRow(registros);
        }

        return tableModel;
    }

    public DefaultTableModel vistaCaducar() throws SQLException {
        query = "select * from vista_ingredientesPorCaducar";
        ResultSet rs = connection.executeQuery(query);
        String[] columnas = {"Id ingrediente", "Ingrediente", "Existencia", "Días Restantes"};
        String[] registros = new String[columnas.length];
        DefaultTableModel tableModel = new DefaultTableModel(null, columnas);

        while (rs.next()) {
            registros[0] = rs.getInt("ingrediente_id") + "";
            registros[1] = rs.getString("Ingrediente");
            registros[2] = rs.getString("Existencia");
            registros[3] = rs.getString("Restan");
            tableModel.addRow(registros);
        }
        return tableModel;
    }

    public DefaultTableModel vistaIngredientesMasUsados() throws SQLException {
        query = "select * from vista_IngredientesMasUsados";
        ResultSet rs = connection.executeQuery(query);
        String[] columnas = {"Nombre", "Presente en alimentos diferentes"};
        String[] registros = new String[columnas.length];
        DefaultTableModel tableModel = new DefaultTableModel(null, columnas);

        while (rs.next()) {
            registros[0] = rs.getString("nombre");
            registros[1] = rs.getInt("Cant") + "";
            tableModel.addRow(registros);
        }

        return tableModel;
    }

    public DefaultTableModel vistaAlergicos() throws SQLException {
        query = "select * from VW_Alergias";
        ResultSet rs = connection.executeQuery(query);
        String[] columnas = {"Nombre", "Grado y grupo", "Ingrediente"};
        String[] registros = new String[columnas.length];
        DefaultTableModel tableModel = new DefaultTableModel(null, columnas);

        while (rs.next()) {
            registros[0] = rs.getString("Nombre");
            registros[1] = rs.getInt("Grado") + "° " + rs.getString("Grupo");
            registros[2] = rs.getString("IngredienteMedida");
            tableModel.addRow(registros);
        }

        return tableModel;
    }

    public DefaultTableModel vistaAlergias() throws SQLException {
        query = "select * from vista_niñosAlergias";
        ResultSet rs = connection.executeQuery(query);
        String[] columnas = {"Matricula", "Nombre", "Apellido", "Id Ingrediente", "Ingrediente"};
        String[] registros = new String[columnas.length];
        DefaultTableModel tableModel = new DefaultTableModel(null, columnas);

        while (rs.next()) {
            registros[0] = rs.getInt("matricula") + "";
            registros[1] = rs.getString("nombre");
            registros[2] = rs.getString("apellidoP");
            registros[3] = rs.getInt("id") + "";
            registros[4] = rs.getString("ingrediente");
            tableModel.addRow(registros);
        }

        return tableModel;
    }

    public ArrayList<String> alumnosAlergias() throws SQLException {
        query = "select distinct a.matricula from Escolar.Alumnos a INNER JOIN Escolar.Alergias a2 on " +
                "a.matricula = a2.alu_matricula";
        ResultSet rs = connection.executeQuery(query);
        ArrayList<String> alumnos = new ArrayList<>();
        while(rs.next()){
            alumnos.add(rs.getString("matricula"));
        }
        return alumnos;
    }

    public ArrayList<Ingrediente> alergiaDeAlumno(int matricula) throws SQLException {
        query = "select al.ingrediente_id, nombre from \n" +
                "Escolar.Alergias al inner join Comida.Ingredientes c\n" +
                "on al.ingrediente_id = c.ingrediente_id \n" +
                "where alu_matricula = " + matricula;
        ResultSet rs = connection.executeQuery(query);
        ArrayList<Ingrediente> ingredientes = new ArrayList<>();
        int id;
        String nombre;
        while (rs.next()){
            id = rs.getInt("ingrediente_id");
            nombre = rs.getString("nombre");
            Ingrediente ingrediente = new Ingrediente(id,nombre);
            ingredientes.add(ingrediente);
        }

        return ingredientes;
    }

    public boolean bajaAlergia(int matricula, int id) throws SQLException {
        query = "delete from Escolar.Alergias where alu_matricula = "+ matricula +" and ingrediente_id = " + id;
        return connection.execute(query);
    }



    public void abrirTran() throws SQLException {
        connection.execute("begin tran");
    }

    public void commitTran() throws SQLException {
        connection.execute("commit tran");
    }

    public void rollback() throws SQLException {
        connection.execute("rollback tran");
    }
}
