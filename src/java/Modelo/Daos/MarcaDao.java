/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Marca;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class MarcaDao {
    private Session sesion;
    private Transaction tx;

    public MarcaDao(){
        
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
    
    public void guardar(Marca marca){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(marca); 
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
    
    public void actualizar(Marca marca){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(marca); 
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
    
    public void eliminar(Marca marca){
        try
        {
            iniciaOperacion();
            sesion.delete(marca);
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
    
    public Marca obtener(int idmarca) throws HibernateException{
        Marca marca = null;
        try
        {
            iniciaOperacion();
            marca = (Marca) sesion.get(Marca.class, idmarca);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return marca;
    }
    
    public List<Marca> obtenerLista() throws HibernateException{
        List<Marca> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Marca").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Marca> obtenerListaActivas() throws HibernateException{
        List<Marca> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Marca where estatus=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idmarca){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Marca set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idmarca)).executeUpdate();
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
    
    public List<Marca> obtenerListaInactivas() throws HibernateException{
        List<Marca> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Marca where estatus=0 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Marca obtenerPorClave(String clave) throws HibernateException{
        Marca marca = null;
        try
        {
            iniciaOperacion();
            marca = (Marca) sesion.createQuery("from Marca where clave='"+clave+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return marca;
    }
    
    public boolean ValidaMarca(Marca mar) {
        Marca existe = obtenerPorClave(mar.getClave());
        if (existe == null)
            return false;
        else
            return true;
    }
    
}
