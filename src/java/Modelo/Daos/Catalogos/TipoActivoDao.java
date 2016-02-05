/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoActivo;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class TipoActivoDao {
    private Session sesion;
    private Transaction tx;

    public TipoActivoDao(){
        
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
    
    public void guardar(TipoActivo tipo){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(tipo); 
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
    
    public void actualizar(TipoActivo tipo){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(tipo); 
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
    
    public void eliminar(TipoActivo tipo){
        try
        {
            iniciaOperacion();
            sesion.delete(tipo);
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
    
    public TipoActivo obtener(int idtipo) throws HibernateException{
        TipoActivo tipo = null;
        try
        {
            iniciaOperacion();
            tipo = (TipoActivo) sesion.get(TipoActivo.class, idtipo);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tipo;
    }
    
    public List<TipoActivo> obtenerLista() throws HibernateException{
        List<TipoActivo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoActivo").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoActivo> obtenerListaActivos() {
        List<TipoActivo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoActivo where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void actualizarEstatus(int estatus, int id) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update TipoActivo set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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

    public Object obtenerListaInactivos() {
        List<TipoActivo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoActivo where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
