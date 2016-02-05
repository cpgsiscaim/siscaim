/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Ubicacion;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class UbicacionDao {
    private Session sesion;
    private Transaction tx;

    public UbicacionDao(){
        
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
    
    public void guardar(Ubicacion ubi){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(ubi); 
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
    
    public void actualizar(Ubicacion ubi){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(ubi); 
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
    
    public void eliminar(Ubicacion ubi){
        try
        {
            iniciaOperacion();
            sesion.delete(ubi);
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
    
    public Ubicacion obtener(int idubi) throws HibernateException{
        Ubicacion ubi = null;
        try
        {
            iniciaOperacion();
            ubi = (Ubicacion) sesion.get(Ubicacion.class, idubi);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return ubi;
    }
    
    public List<Ubicacion> obtenerLista() throws HibernateException{
        List<Ubicacion> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ubicacion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Ubicacion> obtenerListaActivasDeAlmacen(int idalma) throws HibernateException{
        List<Ubicacion> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ubicacion where estatus=1 and almacen="+Integer.toString(idalma)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idubi){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Ubicacion set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idubi)).executeUpdate();
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
    
    public List<Ubicacion> obtenerListaInactivasDeAlmacen(int idalma) throws HibernateException{
        List<Ubicacion> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ubicacion where estatus=0 and almacen="+Integer.toString(idalma)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
    
}
