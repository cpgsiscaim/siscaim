/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.CuentasTelecomm;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class CuentasTelecommDao {
    private Session sesion;
    private Transaction tx;

    public CuentasTelecommDao(){
        
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
    
    public void guardar(CuentasTelecomm cuenta){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(cuenta); 
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
    
    public void actualizar(CuentasTelecomm cuenta){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(cuenta); 
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
    
    public void eliminar(CuentasTelecomm cuenta){
        try
        {
            iniciaOperacion();
            sesion.delete(cuenta);
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
    
    public CuentasTelecomm obtener(int idcuenta) throws HibernateException{
        CuentasTelecomm cuenta = null;
        try
        {
            iniciaOperacion();
            cuenta = (CuentasTelecomm) sesion.get(CuentasTelecomm.class, idcuenta);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cuenta;
    }
    
    public List<CuentasTelecomm> obtenerListaActivas() throws HibernateException{
        List<CuentasTelecomm> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CuentasTelecomm where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<CuentasTelecomm> obtenerListaInactivas() throws HibernateException{
        List<CuentasTelecomm> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CuentasTelecomm where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
