/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Unidad;
import Modelo.Entidades.UnidadProducto;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class UnidadProductoDao {
    private Session sesion;
    private Transaction tx;

    public UnidadProductoDao(){
        
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
    
    public void guardar(UnidadProducto unidprod){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(unidprod); 
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
    
    public void actualizar(UnidadProducto unidprod){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(unidprod); 
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
    
    public void eliminar(UnidadProducto unidprod){
        try
        {
            iniciaOperacion();
            sesion.delete(unidprod);
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
    
    public UnidadProducto obtener(int idunidprod) throws HibernateException{
        UnidadProducto unidprod = null;
        try
        {
            iniciaOperacion();
            unidprod = (UnidadProducto) sesion.get(UnidadProducto.class, idunidprod);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return unidprod;
    }
    
    public UnidadProducto obtener(int iduni, int idprod) throws HibernateException{
        UnidadProducto unidprod = null;
        List<UnidadProducto> lista = null;
        try
        {
            iniciaOperacion();
            lista = (List<UnidadProducto>) sesion.createQuery("from UnidadProducto where unidad="+Integer.toString(iduni)+
                    " and producto="+Integer.toString(idprod)+" and estatus=1").setMaxResults(1).list();//uniqueResult();
            if (!lista.isEmpty()){
                unidprod = lista.get(0);
            }
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return unidprod;
    }

    public UnidadProducto obtenerUnidadEmpaqueDeProducto(int idprod) throws HibernateException{
        UnidadProducto unidprod = null;
        try
        {
            iniciaOperacion();
            unidprod = (UnidadProducto) sesion.createQuery("from UnidadProducto where producto="+Integer.toString(idprod)+
                    " and empaque=1 and estatus=1").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return unidprod;
    }
    
    public List<UnidadProducto> obtenerLista() throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<UnidadProducto> obtenerListaActivas() throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<UnidadProducto> obtenerListaActivasNoMinNoEmp() throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=1 and minima=0 and empaque=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idunidprod){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update UnidadProducto set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idunidprod)).executeUpdate();
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
    
    public List<UnidadProducto> obtenerListaInactivas() throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<UnidadProducto> obtenerListaInactivasNoMinNoEmp() throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=0 and minima=0 and empaque=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<UnidadProducto> obtenerListaActivasDeProducto(int idprod) throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=1 and producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<UnidadProducto> obtenerListaActivasDeProductoNoMinNoEmp(int idprod) throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=1 and minima=0 and empaque=0 and producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<UnidadProducto> obtenerListaInactivasDeProducto(int idprod) throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=0 and producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<UnidadProducto> obtenerListaInactivasDeProductoNoMinNoEmp(int idprod) throws HibernateException{
        List<UnidadProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from UnidadProducto where estatus=0 and minima=0 and empaque=0 and producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Unidad> obtenerUnidadesDisponiblesDeProducto(int idprod) throws HibernateException{
        List<Unidad> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Unidad where id not in (select distinct unidad from UnidadProducto where estatus=1 and producto="+Integer.toString(idprod)+")").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Unidad> obtenerUnidadesDisponiblesDeProductoNoMinNoEmp(int idprod) throws HibernateException{
        List<Unidad> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Unidad where id not in (select distinct unidad from UnidadProducto where estatus=1 and minima=0 and empaque=0 and producto="+Integer.toString(idprod)+")").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public UnidadProducto obtenerUnidadMinimaDeProducto(int idprod) {
        UnidadProducto unidprod = null;
        try
        {
            iniciaOperacion();
            unidprod = (UnidadProducto) sesion.createQuery("from UnidadProducto where producto="+Integer.toString(idprod)+
                    " and minima=1 and estatus=1").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return unidprod;
    }

    public UnidadProducto obtenerUnidadInactivaDeProducto(int iduni, int idprod) {
        UnidadProducto up = null;
        try
        {
            iniciaOperacion();
            up = (UnidadProducto)sesion.createQuery("from UnidadProducto where producto="+Integer.toString(idprod)+
                    " and unidad="+Integer.toString(iduni)+" and estatus=0").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return up;
        
    }
    
}
