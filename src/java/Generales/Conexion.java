/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Generales;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.mysql.jdbc.Driver;

/**
 *
 * @author temoc
 */
public class Conexion {
    public Conexion(){
        
    }
    
    public Connection conectar(){
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/marba?autoReconnect=true";
            try {
                con = DriverManager.getConnection(url, "root","d3r3k");
            } catch (SQLException ex) {
                Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Conexion.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }
    
}
