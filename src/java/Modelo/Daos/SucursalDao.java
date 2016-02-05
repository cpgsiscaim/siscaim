/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Sucursal;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class SucursalDao {
    private Session sesion;
    private Transaction tx;

    public SucursalDao(){
        
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
    
    public void guardar(Sucursal suc){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(suc); 
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
    
    public void actualizar(Sucursal suc){
        try 
        { 
            iniciaOperacion(); 
            sesion.merge(suc); 
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
    
    public void eliminar(Sucursal suc){
        try
        {
            iniciaOperacion();
            sesion.delete(suc);
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
    
    public Sucursal obtener(int idsuc) throws HibernateException{
        Sucursal suc = null;
        try
        {
            iniciaOperacion();
            suc = (Sucursal) sesion.get(Sucursal.class, idsuc);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return suc;
    }
    
    public List<Sucursal> obtenerLista() throws HibernateException{
        List<Sucursal> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Sucursal").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Sucursal> obtenerListaSuc() throws HibernateException{
        List<Sucursal> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Sucursal where tipo=1 and estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idSuc){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Sucursal set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idSuc)).executeUpdate();
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
    
    public List<Sucursal> obtenerListaInactivas() throws HibernateException{
        List<Sucursal> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Sucursal where tipo=1 and estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Sucursal> obtenerListaSucYMatriz() throws HibernateException{
        List<Sucursal> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Sucursal where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
