/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Serie;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class SerieDao {
    private Session sesion;
    private Transaction tx;

    public SerieDao(){
        
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
    
    public void guardar(Serie ser){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(ser); 
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
    
    public void actualizar(Serie ser){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(ser); 
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
    
    public void eliminar(Serie ser){
        try
        {
            iniciaOperacion();
            sesion.delete(ser);
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
    
    public Serie obtener(int idser) throws HibernateException{
        Serie ser = null;
        try
        {
            iniciaOperacion();
            ser = (Serie) sesion.get(Serie.class, idser);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return ser;
    }
    
    public List<Serie> obtenerLista() throws HibernateException{
        List<Serie> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Serie").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Serie> obtenerListaActivas() throws HibernateException{
        List<Serie> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Serie where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idser){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Serie set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idser)).executeUpdate();
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
    
    public List<Serie> obtenerListaInactivas() throws HibernateException{
        List<Serie> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Serie where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
    
    public Serie obtenerPorClave(String clave) throws HibernateException{
        Serie ser = null;
        try
        {
            iniciaOperacion();
            ser = (Serie) sesion.createQuery("from Serie where serie='"+clave+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return ser;
    }
    
    public boolean ValidaSerie(Serie ser) {
        Serie existe = obtenerPorClave(ser.getSerie());
        if (existe == null)
            return false;
        else
            return true;
    }    
}
