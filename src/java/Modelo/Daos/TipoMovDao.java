/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.TipoMov;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class TipoMovDao {
    private Session sesion;
    private Transaction tx;

    public TipoMovDao(){
        
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
    
    public void guardar(TipoMov tmov){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(tmov); 
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
    
    public void actualizar(TipoMov tmov){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(tmov); 
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
    
    public void eliminar(TipoMov tmov){
        try
        {
            iniciaOperacion();
            sesion.delete(tmov);
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
    
    public TipoMov obtener(int idtmov) throws HibernateException{
        TipoMov tmov = null;
        try
        {
            iniciaOperacion();
            tmov = (TipoMov) sesion.get(TipoMov.class, idtmov);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tmov;
    }
    
    public List<TipoMov> obtenerLista() throws HibernateException{
        List<TipoMov> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoMov").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<TipoMov> obtenerListaActivos() throws HibernateException{
        List<TipoMov> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoMov where estatus=1 order by categoria").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idtmov){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update TipoMov set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idtmov)).executeUpdate();
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
    
    public List<TipoMov> obtenerListaInactivos() throws HibernateException{
        List<TipoMov> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoMov where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoMov> obtenerTiposMovsOtrasEntradasSalidas(int cat) {
        List<TipoMov> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoMov where estatus=2 and categoria="+Integer.toString(cat)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;        
    }
        
}
