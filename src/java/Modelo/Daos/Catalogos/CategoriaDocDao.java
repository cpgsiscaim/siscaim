/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.CategoriaDoc;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class CategoriaDocDao {
    private Session sesion;
    private Transaction tx;
    
    public CategoriaDocDao(){
        
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
    
    public void guardar(CategoriaDoc catdoc){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(catdoc); 
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
    
    public void actualizar(CategoriaDoc catdoc){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(catdoc); 
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
    
    public void eliminar(CategoriaDoc catdoc){
        try
        {
            iniciaOperacion();
            sesion.delete(catdoc);
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
    
    public CategoriaDoc obtener(int idtipo) throws HibernateException{
        CategoriaDoc catdoc = null;
        try
        {
            iniciaOperacion();
            catdoc = (CategoriaDoc) sesion.get(CategoriaDoc.class, idtipo);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return catdoc;
    }
    
    public List<CategoriaDoc> obtenerLista() throws HibernateException{
        List<CategoriaDoc> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CategoriaDoc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<CategoriaDoc> obtenerListaActivos() {
        List<CategoriaDoc> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CategoriaDoc where estatus=1 order by descripcion").list();
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
            int filas = sesion.createQuery("update CategoriaDoc set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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

    public List<CategoriaDoc> obtenerListaInactivos() {
        List<CategoriaDoc> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CategoriaDoc where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
