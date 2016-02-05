/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.CategoriaOp;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class CategoriaOpDao {
    
    private Session sesion;
    private Transaction tx;

    public CategoriaOpDao(){
        
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
    
    public void guardar(CategoriaOp cat){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(cat); 
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
    
    public void actualizar(CategoriaOp cat){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(cat); 
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
    
    public void eliminar(CategoriaOp cat){
        try
        {
            iniciaOperacion();
            sesion.delete(cat);
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
    
    public CategoriaOp obtener(int idcatop) throws HibernateException{
        CategoriaOp cat = null;
        try
        {
            iniciaOperacion();
            cat = (CategoriaOp) sesion.get(CategoriaOp.class, idcatop);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cat;
    }
    
    public List<CategoriaOp> obtenerLista() throws HibernateException{
        List<CategoriaOp> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CategoriaOp").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }  
    
}
