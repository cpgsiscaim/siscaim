/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoFamiliar;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class TipoFamiliarDao {
    private Session sesion;
    private Transaction tx;
    
    public TipoFamiliarDao(){
        
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
    
    public void guardar(TipoFamiliar tipo){
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
    
    public void actualizar(TipoFamiliar tipo){
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
    
    public void eliminar(TipoFamiliar tipo){
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
    
    public TipoFamiliar obtener(int idtipo) throws HibernateException{
        TipoFamiliar tipo = null;
        try
        {
            iniciaOperacion();
            tipo = (TipoFamiliar) sesion.get(TipoFamiliar.class, idtipo);
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
    
    public List<TipoFamiliar> obtenerLista() throws HibernateException{
        List<TipoFamiliar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoFamiliar").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoFamiliar> obtenerListaActivos() {
        List<TipoFamiliar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoFamiliar where estatus=1").list();
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
            int filas = sesion.createQuery("update TipoFamiliar set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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
        List<TipoFamiliar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoFamiliar where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
