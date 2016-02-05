/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Ruta;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class RutaDao {
    private Session sesion;
    private Transaction tx;

    public RutaDao(){
        
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
    
    public void guardar(Ruta ruta){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(ruta); 
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
    
    public void actualizar(Ruta ruta){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(ruta); 
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
    
    public void eliminar(Ruta ruta){
        try
        {
            iniciaOperacion();
            sesion.delete(ruta);
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
    
    public Ruta obtener(int idruta) throws HibernateException{
        Ruta ruta = null;
        try
        {
            iniciaOperacion();
            ruta = (Ruta) sesion.get(Ruta.class, idruta);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return ruta;
    }
    
    public List<Ruta> obtenerLista() throws HibernateException{
        List<Ruta> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ruta").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Ruta> obtenerListaActivas() throws HibernateException{
        List<Ruta> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ruta where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idruta){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Ruta set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idruta)).executeUpdate();
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
    
    public List<Ruta> obtenerListaInactivas() throws HibernateException{
        List<Ruta> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ruta where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Ruta> obtenerRutasDeSucursal(int idSucSel) throws HibernateException {
        List<Ruta> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ruta where estatus=1 and sucursal="+Integer.toString(idSucSel)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Ruta> obtenerRutasInactivasDeSucursal(int idSucSel) throws HibernateException {
        List<Ruta> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Ruta where estatus=0 and sucursal="+Integer.toString(idSucSel)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
}
