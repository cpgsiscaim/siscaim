/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.Banco;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class BancoDao {
    private Session sesion;
    private Transaction tx;

    public BancoDao(){
        
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
    
    public void guardar(Banco bank){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(bank); 
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
    
    public void actualizar(Banco bank){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(bank); 
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
    
    public void eliminar(Banco bank){
        try
        {
            iniciaOperacion();
            sesion.delete(bank);
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
    
    public Banco obtener(int idban) throws HibernateException{
        Banco bank = null;
        try
        {
            iniciaOperacion();
            bank = (Banco) sesion.get(Banco.class, idban);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return bank;
    }
    
    public List<Banco> obtenerListaActivos() throws HibernateException{
        List<Banco> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Banco where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Banco> obtenerListaInactivos() throws HibernateException{
        List<Banco> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Banco where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
