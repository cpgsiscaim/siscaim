/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Generales.Conexion;
import Modelo.Entidades.Contrato;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ContratoDao {
    private Session sesion;
    private Transaction tx;

    public ContratoDao(){
        
    }
    
    private void iniciaOperacion() throws HibernateException
    {
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
    }
        
    private void manejaExcepcion(HibernateException he) throws HibernateException
    {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos", he);
    }
    
    public void guardar(Contrato con){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(con); 
            tx.commit(); 
        }catch(HibernateException he) 
        { 
            manejaExcepcion(he);
            throw he; 
        }finally 
        { 
            sesion.close(); 
        }  
    }
    
    public void actualizar(Contrato con){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(con); 
            tx.commit();
        }catch (HibernateException he) 
        { 
            manejaExcepcion(he); 
            throw he; 
        }finally 
        { 
            sesion.close(); 
        }         
    }
    
    public void eliminar(Contrato con){
        try
        {
            iniciaOperacion();
            sesion.delete(con);
            tx.commit();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
    }
    
    public Contrato obtener(int idcon) throws HibernateException{
        Contrato con = null;
        try
        {
            iniciaOperacion();
            con = (Contrato) sesion.get(Contrato.class, idcon);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return con;
    }
    
    public List<Contrato> obtenerLista() throws HibernateException{
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Contrato> obtenerListaActivos() throws HibernateException{
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=1 order by "+
                    "fechaIni desc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idcon){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Contrato set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idcon)).executeUpdate();
            tx.commit();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }        
    }
    
    public List<Contrato> obtenerListaInactivos() throws HibernateException{
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Contrato> obtenerContratosDeCliente(int idCli) throws HibernateException {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=1 and cliente="+Integer.toString(idCli)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Contrato> obtenerContratosInactivosDeCliente(int idCli) throws HibernateException {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=0 and cliente="+Integer.toString(idCli)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean ValidaContrato(Contrato con) {
        Contrato existe = obtenerPorNumContrato(con.getContrato(), con.getCliente().getId(), con.getSucursal().getId());
        if (existe == null)
            return false;
        else
            return true;

    }

    private Contrato obtenerPorNumContrato(String contrato, int idcli, int idsuc) {
        Contrato con = null;
        try
        {
            iniciaOperacion();
            con = (Contrato) sesion.createQuery("from Contrato where contrato='"+contrato+"'"+
                    " and cliente="+Integer.toString(idcli)+" and sucursal="+Integer.toString(idsuc)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return con;

    }
    
    public List<Contrato> obtenerContratosDeClienteYSucursal(int idCli, int idSuc) throws HibernateException {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=1 and cliente="+Integer.toString(idCli)+
                    " and sucursal="+Integer.toString(idSuc)+" and fechaFin>=date(now())").list();
            //+" and fechaFin>=date(now())"
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Contrato> obtenerContratosInactivosDeClienteYSucursal(int idCli, int idSuc) throws HibernateException {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=0 and cliente="+Integer.toString(idCli)+
                    " and sucursal="+Integer.toString(idSuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Contrato> obtenerContratosDeClienteYSucursalConcluidos(int idCli, int idSuc) {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=1 and cliente="+Integer.toString(idCli)+
                    " and sucursal="+Integer.toString(idSuc)+" and fechaFin<date(now())").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Contrato> obtenerContratosDeClienteYSucursalTodos(int idCli, int idSuc) {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Contrato where estatus=1 and cliente="+Integer.toString(idCli)+
                    " and sucursal="+Integer.toString(idSuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean VerificaSiTieneCTS(int idcon) {
        boolean hay = false;
        Long count = new Long(0);
        try
        {
            iniciaOperacion();
            count = (Long)sesion.createQuery("select count(*) from CentroDeTrabajo where estatus=1 and contrato="+Integer.toString(idcon)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        if (count.intValue()>0)
            hay = true;
        return hay;
    }

    public double GenerarProdsDeCt(int idcon, int idct) {
        double res = 0;
        Conexion conn = new Conexion();
        Connection conne = null;

        //PreparedStatement ps = null;
        //ResultSet rs = null;
        try
        {
            //Pedimos una conexion al pool
            conne = conn.conectar();

            String query = "call generaProductosDeCt(?,?,?)";
            CallableStatement cs = conne.prepareCall(query);
            cs.setInt(1, idcon);
            cs.setInt(2, idct);
            cs.registerOutParameter(3, java.sql.Types.DOUBLE);
            cs.execute();
            res = cs.getDouble(3);
            
        }catch(SQLException e)
        {
            System.out.println("Ocurrió un error en la capa de datos JDBC:"+ e.getMessage());
            res = -1;
        }
        finally
        {
            try
            {
                if (conne!= null && !conne.isClosed())
                {
                   conne.close();
                }
            }
            catch(SQLException e)
            {
                 System.out.println("Ocurrió un error al cerrar la conexión JDBC:"+e.getMessage());
            }
        }
        
        return res;
    }

    public int EliminaProdsDeCts(int idcon) {
        int res = 0;
        Conexion conn = new Conexion();
        Connection conne = null;

        //PreparedStatement ps = null;
        //ResultSet rs = null;
        try
        {
            //Pedimos una conexion al pool
            conne = conn.conectar();

            String query = "call eliminaProductosDeCts(?,?)";
            CallableStatement cs = conne.prepareCall(query);
            cs.setInt(1, idcon);
            cs.registerOutParameter(2, java.sql.Types.INTEGER);
            cs.execute();
            res = cs.getInt(2);
            
        }catch(SQLException e)
        {
            System.out.println("Ocurrió un error en la capa de datos JDBC:"+ e.getMessage());
        }
        finally
        {
            try
            {
                if (conne!= null && !conne.isClosed())
                {
                   conne.close();
                }
            }
            catch(SQLException e)
            {
                 System.out.println("Ocurrió un error al cerrar la conexión JDBC:"+e.getMessage());
            }
        }
        
        return res;
    }

    public List<Contrato> obtenerContratosDeConsulta(String sql) {
        List<Contrato> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
