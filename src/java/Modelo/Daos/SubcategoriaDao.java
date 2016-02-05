/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Subcategoria;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class SubcategoriaDao {
    private Session sesion;
    private Transaction tx;

    public SubcategoriaDao(){
        
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
    
    public void guardar(Subcategoria scat){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(scat); 
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
    
    public void actualizar(Subcategoria scat){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(scat); 
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
    
    public void eliminar(Subcategoria scat){
        try
        {
            iniciaOperacion();
            sesion.delete(scat);
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
    
    public Subcategoria obtener(int idscat) throws HibernateException{
        Subcategoria scat = null;
        try
        {
            iniciaOperacion();
            scat = (Subcategoria) sesion.get(Subcategoria.class, idscat);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return scat;
    }
    
    public List<Subcategoria> obtenerLista() throws HibernateException{
        List<Subcategoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Subcategoria").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Subcategoria> obtenerListaActivas() throws HibernateException{
        List<Subcategoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Subcategoria where estatus=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idscat){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Subcategoria set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idscat)).executeUpdate();
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
    
    public List<Subcategoria> obtenerListaInactivas() throws HibernateException{
        List<Subcategoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Subcategoria where estatus=0 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Subcategoria> obtenerListaActivasDeCategoria(int idCat) throws HibernateException{
        List<Subcategoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Subcategoria where estatus=1 and categoria="+ Integer.toString(idCat) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Subcategoria> obtenerListaInactivasDeCategoria(int idCat) throws HibernateException{
        List<Subcategoria> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Subcategoria where estatus=0 and categoria="+ Integer.toString(idCat) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Subcategoria obtenerPorClave(String clave) throws HibernateException{
        Subcategoria sub = null;
        try
        {
            iniciaOperacion();
            sub = (Subcategoria) sesion.createQuery("from Subcategoria where clave='"+clave+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return sub;
    }
    
    public boolean ValidaMarca(Subcategoria sub) {
        Subcategoria existe = obtenerPorClave(sub.getClave());
        if (existe == null)
            return false;
        else
            return true;
    }

}
