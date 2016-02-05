/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Generales.Conexion;
import Modelo.Entidades.CentroDeTrabajo;
import Modelo.Entidades.Cliente;
import Modelo.Entidades.Contrato;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import org.hibernate.Criteria;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author TEMOC
 */
public class CentroTrabDao {
    private Session sesion;
    private Transaction tx;

    public CentroTrabDao(){
        
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
    
    public void guardar(CentroDeTrabajo ctrab){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(ctrab); 
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
    
    public void actualizar(CentroDeTrabajo ctrab){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(ctrab); 
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
    
    public void eliminar(CentroDeTrabajo ctrab){
        try
        {
            iniciaOperacion();
            sesion.delete(ctrab);
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
    
    public CentroDeTrabajo obtener(int idctrab) throws HibernateException{
        CentroDeTrabajo ctrab = null;
        try
        {
            iniciaOperacion();
            ctrab = (CentroDeTrabajo) sesion.get(CentroDeTrabajo.class, idctrab);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return ctrab;
    }
    
    public List<CentroDeTrabajo> obtenerLista() throws HibernateException{
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<CentroDeTrabajo> obtenerListaActivos() throws HibernateException{
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo where estatus=1 order by "+
                    "nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idctrab){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update CentroDeTrabajo set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idctrab)).executeUpdate();
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
    
    public List<CentroDeTrabajo> obtenerListaInactivos() throws HibernateException{
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<CentroDeTrabajo> obtenerCentroDeTrabajosDeContrato(int idCon) throws HibernateException {
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo where estatus=1 and contrato="+Integer.toString(idCon)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<CentroDeTrabajo> obtenerCentroDeTrabajosDeContrato2(int idCon) throws HibernateException {
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            Criteria crit = sesion.createCriteria(CentroDeTrabajo.class);
            lista = crit.add( Restrictions.eq("estatus", 1))
                    .add( Restrictions.eq("contrato.id", idCon))
                    .setFetchMode("contrato", FetchMode.LAZY)
                    .setFetchMode("cliente", FetchMode.LAZY)
            .list();
            //lista = sesion.createQuery("from CentroDeTrabajo where estatus=1 and contrato="+Integer.toString(idCon)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
    
    public List<CentroDeTrabajo> obtenerCentroDeTrabajosInactivosDeContrato(int idCon) throws HibernateException {
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo where estatus=0 and contrato="+Integer.toString(idCon)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<CentroDeTrabajo> obtenerCTSDeCliente(int idcli) {
        List<CentroDeTrabajo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo where estatus=1 and cliente="+Integer.toString(idcli)+
                    " order by contrato").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Integer> obtenerIdsDeCTSDeContrato(int idcon) {
        List<Integer> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("select id from CentroDeTrabajo where estatus=1 and contrato="+Integer.toString(idcon)).list();
        }finally
        {
            sesion.close();
        }
        return lista;
    }

    public double obtenerTotalDeCT(int idct) {
        double res = 0;
        Conexion conn = new Conexion();
        Connection conne = null;

        try
        {
            //Pedimos una conexion al pool
            conne = conn.conectar();

            String query = "call obtenerTotalDeCT(?,?)";
            CallableStatement cs = conne.prepareCall(query);
            cs.setInt(1, idct);
            cs.registerOutParameter(2, java.sql.Types.DOUBLE);
            cs.execute();
            res = cs.getDouble(2);
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

    public List<Cliente> obtenerClientesDeCtsExternos(int idsuc) {
        List<Cliente> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("select distinct ct.cliente from CentroDeTrabajo ct where ct.estatus=1 and ct.surtidoexterno=1"
                    +" and ct.sucalterna="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        return lista;
    }

    public List<Contrato> obtenerContratosExternosDeClienteYSucursalTodos(int idcli, int idsuc) {
        List<Contrato> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("select distinct ct.contrato from CentroDeTrabajo ct where ct.estatus=1 and ct.surtidoexterno=1"
                    +" and ct.cliente="+Integer.toString(idcli)+" and ct.sucalterna="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        return lista;
    }

    public List<CentroDeTrabajo> obtenerCentroDeTrabajosExternosDeContratoYSucursal(int idcon, int idsuc) {
        List<CentroDeTrabajo> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CentroDeTrabajo ct where ct.estatus=1 and ct.surtidoexterno=1"
                    +" and ct.contrato="+Integer.toString(idcon)+" and ct.sucalterna="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        return lista;
    }

    public List<CentroDeTrabajo> obtenerCtsDeSql(String sql) {
        List<CentroDeTrabajo> lista = null;
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
