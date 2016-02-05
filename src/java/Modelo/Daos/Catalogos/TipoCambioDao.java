/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoCambio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */

public class TipoCambioDao {
    private Session sesion;
    private Transaction tx;

    public TipoCambioDao(){
        
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
    
    public void guardar(TipoCambio tipo){
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
    
    public void actualizar(TipoCambio tipo){
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
    
    public void eliminar(TipoCambio tipo){
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
    
    public TipoCambio obtener(int idtipo) throws HibernateException{
        TipoCambio tipo = null;
        try
        {
            iniciaOperacion();
            tipo = (TipoCambio) sesion.get(TipoCambio.class, idtipo);
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
    
    public List<TipoCambio> obtenerLista() throws HibernateException{
        List<TipoCambio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoCambio> obtenerListaActivos() {
        List<TipoCambio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambio where estatus=1").list();
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
            int filas = sesion.createQuery("update TipoCambio set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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
        List<TipoCambio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambio where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

}
