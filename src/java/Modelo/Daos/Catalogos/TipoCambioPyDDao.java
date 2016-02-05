/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoCambioPyD;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class TipoCambioPyDDao {
    private Session sesion;
    private Transaction tx;

    public TipoCambioPyDDao(){
        
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
    
    public void guardar(TipoCambioPyD tipo){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(tipo); 
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
    
    public void actualizar(TipoCambioPyD tipo){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(tipo); 
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
    
    public void eliminar(TipoCambioPyD tipo){
        try
        {
            iniciaOperacion();
            sesion.delete(tipo);
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
    
    public TipoCambioPyD obtener(int idtipo) throws HibernateException{
        TipoCambioPyD tipo = null;
        try
        {
            iniciaOperacion();
            tipo = (TipoCambioPyD) sesion.get(TipoCambioPyD.class, idtipo);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tipo;
    }
    
    public List<TipoCambioPyD> obtenerLista() throws HibernateException{
        List<TipoCambioPyD> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambioPyD").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoCambioPyD> obtenerListaActivos(int idperded) {
        List<TipoCambioPyD> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambioPyD where estatus=1 and perded="+Integer.toString(idperded)).list();
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
            int filas = sesion.createQuery("update TipoCambioPyD set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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

    public Object obtenerListaInactivos(int idperded) {
        List<TipoCambioPyD> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambioPyD where estatus=0 and perded="+Integer.toString(idperded)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<TipoCambioPyD> obtenerTiposCambiosDisponibles(int idperded) {
        List<TipoCambioPyD> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambio where estatus=1 and id not in (select distinct tipocambio from TipoCambioPyD where estatus=1 and perded="+Integer.toString(idperded)+")").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<TipoCambioPyD> obtenerListaActivosGeneral() throws HibernateException{
        List<TipoCambioPyD> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoCambioPyD where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

}
