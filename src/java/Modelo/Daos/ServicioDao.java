/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Servicio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ServicioDao {
    private Session sesion;
    private Transaction tx;

    public ServicioDao(){
        
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
    
    public void guardar(Servicio ser){
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
    
    public void actualizar(Servicio ser){
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
    
    public void eliminar(Servicio ser){
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
    
    public Servicio obtener(int idser) throws HibernateException{
        Servicio ser = null;
        try
        {
            iniciaOperacion();
            ser = (Servicio) sesion.get(Servicio.class, idser);
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
    
    public List<Servicio> obtenerLista() throws HibernateException{
        List<Servicio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Servicio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Servicio> obtenerListaServiciosDeActivo(int idact) throws HibernateException{
        List<Servicio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Servicio where estatus=1 and equipo="+Integer.toString(idact)).list();
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
            int filas = sesion.createQuery("update Servicio set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idser)).executeUpdate();
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
    
    public List<Servicio> obtenerInactivosDeActivo(int idact) throws HibernateException{
        List<Servicio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Servicio where estatus=0 and equipo="+Integer.toString(idact)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    
}
