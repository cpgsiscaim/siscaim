/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Unidad;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class UnidadDao {
    private Session sesion;
    private Transaction tx;

    public UnidadDao(){
        
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
    
    public void guardar(Unidad uni){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(uni); 
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
    
    public void actualizar(Unidad uni){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(uni); 
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
    
    public void eliminar(Unidad uni){
        try
        {
            iniciaOperacion();
            sesion.delete(uni);
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
    
    public Unidad obtener(int iduni) throws HibernateException{
        Unidad uni = null;
        try
        {
            iniciaOperacion();
            uni = (Unidad) sesion.get(Unidad.class, iduni);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return uni;
    }
    
    public List<Unidad> obtenerLista() throws HibernateException{
        List<Unidad> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Unidad").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Unidad> obtenerListaActivas() throws HibernateException{
        List<Unidad> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Unidad where estatus=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int iduni){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Unidad set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(iduni)).executeUpdate();
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
    
    public List<Unidad> obtenerListaInactivas() throws HibernateException{
        List<Unidad> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Unidad where estatus=0 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Unidad obtenerPorClave(String clave) throws HibernateException{
        Unidad uni = null;
        try
        {
            iniciaOperacion();
            uni = (Unidad) sesion.createQuery("from Unidad where clave='"+clave+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return uni;
    }
    
    public boolean ValidaUnidad(Unidad uni) {
        Unidad existe = obtenerPorClave(uni.getClave());
        if (existe == null)
            return false;
        else
            return true;
    }
    
}
