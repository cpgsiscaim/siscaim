/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.HistorialIMSS;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class HistorialIMSSDao {
    private Session sesion;
    private Transaction tx;
    
    public HistorialIMSSDao(){}
    
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
    
    public void guardar(HistorialIMSS hist){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(hist); 
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
    
    public void actualizar(HistorialIMSS hist){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(hist); 
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
    
    public void eliminar(HistorialIMSS hist){
        try
        {
            iniciaOperacion();
            sesion.delete(hist);
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
    
    public HistorialIMSS obtener(int idhist) throws HibernateException{
        HistorialIMSS hist = null;
        try
        {
            iniciaOperacion();
            hist = (HistorialIMSS) sesion.get(HistorialIMSS.class, idhist);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return hist;
    }
    
    public List<HistorialIMSS> obtenerHistorialDeEmpleado(int empleado) throws HibernateException{
        List<HistorialIMSS> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from HistorialIMSS where empleado="+Integer.toString(empleado)+
                    " order by fechaalta desc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public HistorialIMSS obtenerHistorialActivoDeEmpleado(int numempleado) {
        HistorialIMSS hist = null;
        
        try
        {
            iniciaOperacion();
            hist = (HistorialIMSS) sesion.createQuery("from HistorialIMSS where empleado="+Integer.toString(numempleado)+
                    " and fechabaja=null").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return hist;
    }
        
}
