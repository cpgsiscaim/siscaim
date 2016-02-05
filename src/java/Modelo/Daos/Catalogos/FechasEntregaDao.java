/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.FechasEntrega;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class FechasEntregaDao {
    private Session sesion;
    private Transaction tx;
    
    public FechasEntregaDao(){
        
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
    
    public void guardar(FechasEntrega fechaent){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(fechaent); 
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
    
    public void actualizar(FechasEntrega fechaent){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(fechaent); 
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
    
    public void eliminar(FechasEntrega fechaent){
        try
        {
            iniciaOperacion();
            sesion.delete(fechaent);
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
    
    public FechasEntrega obtener(int id) throws HibernateException{
        FechasEntrega fechaent = null;
        try
        {
            iniciaOperacion();
            fechaent = (FechasEntrega) sesion.get(FechasEntrega.class, id);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return fechaent;
    }
    
    public List<FechasEntrega> obtenerFechasDeEntidad(int ent, int ident) throws HibernateException{
        List<FechasEntrega> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from FechasEntrega where entidad="+Integer.toString(ent) +" and identidad="+Integer.toString(ident)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void eliminarFechasDeEntidad(int ent, int ident) throws HibernateException{
        
        try
        {
            iniciaOperacion();
            int f = sesion.createQuery("delete from FechasEntrega where entidad="+Integer.toString(ent) +" and identidad="+Integer.toString(ident)).executeUpdate();
            tx.commit();
        }finally
        {
            sesion.close();
        }
        
    }
}
