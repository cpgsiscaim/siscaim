/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Operacion;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class OperacionDao {
    private Session sesion;
    private Transaction tx;

    public OperacionDao(){
        
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
    
    public void guardar(Operacion operacion){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(operacion); 
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
    
    public void actualizar(Operacion operacion){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(operacion); 
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
    
    public void eliminar(Operacion operacion){
        try
        {
            iniciaOperacion();
            sesion.delete(operacion);
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
    
    public Operacion obtener(int idoperacion) throws HibernateException{
        Operacion operacion = null;
        try
        {
            iniciaOperacion();
            operacion = (Operacion) sesion.get(Operacion.class, idoperacion);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return operacion;
    }
    
    public List<Operacion> obtenerLista() throws HibernateException{
        List<Operacion> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Operacion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Operacion> obtenerListaActivas() throws HibernateException{
        List<Operacion> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Operacion where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
