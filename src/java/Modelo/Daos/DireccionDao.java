/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Direccion;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class DireccionDao {
    private Session sesion;
    private Transaction tx;

    public DireccionDao(){
        
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
    
    public void guardar(Direccion dir){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(dir); 
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
    
    public void actualizar(Direccion dir){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(dir); 
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
    
    public void eliminar(Direccion dir){
        try
        {
            iniciaOperacion();
            sesion.delete(dir);
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
    
    public Direccion obtener(int iddir) throws HibernateException{
        Direccion dir = null;
        try
        {
            iniciaOperacion();
            dir = (Direccion) sesion.get(Direccion.class, iddir);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return dir;
    }
    
    public List<Direccion> obtenerLista() throws HibernateException{
        List<Direccion> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Direccion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
