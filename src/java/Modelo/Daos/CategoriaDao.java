/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Categoria;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class CategoriaDao {
    private Session sesion;
    private Transaction tx;

    public CategoriaDao(){
        
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
    
    public void guardar(Categoria cat){
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
    
    public void actualizar(Categoria cat){
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
    
    public void eliminar(Categoria cat){
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
    
    public Categoria obtener(int idcat) throws HibernateException{
        Categoria cat = null;
        try
        {
            iniciaOperacion();
            cat = (Categoria) sesion.get(Categoria.class, idcat);
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
    
    public List<Categoria> obtenerLista() throws HibernateException{
        List<Categoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Categoria").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Categoria> obtenerListaActivas() throws HibernateException{
        List<Categoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Categoria where estatus=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idcat){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Categoria set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idcat)).executeUpdate();
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
    
    public List<Categoria> obtenerListaInactivas() throws HibernateException{
        List<Categoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Categoria where estatus=0 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean ValidaCategoria(Categoria cat) {
        Categoria existe = obtenerPorClave(cat.getClave());
        if (existe == null)
            return false;
        else
            return true;
    }

    public Categoria obtenerPorClave(String clave) {
        Categoria cat = null;
        try
        {
            iniciaOperacion();
            cat = (Categoria) sesion.createQuery("from Categoria where clave='"+clave+"'").uniqueResult();
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
}
