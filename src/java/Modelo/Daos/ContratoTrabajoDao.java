/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.ContratoTrabajo;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ContratoTrabajoDao {
    private Session sesion;
    private Transaction tx;

    public ContratoTrabajoDao(){
        
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
    
    public void guardar(ContratoTrabajo con){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(con); 
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
    
    public void actualizar(ContratoTrabajo con){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(con); 
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
    
    public void eliminar(ContratoTrabajo con){
        try
        {
            iniciaOperacion();
            sesion.delete(con);
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
    
    public ContratoTrabajo obtener(int idcon) throws HibernateException{
        ContratoTrabajo con = null;
        try
        {
            iniciaOperacion();
            con = (ContratoTrabajo) sesion.get(ContratoTrabajo.class, idcon);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return con;
    }

    public ContratoTrabajo obtenerContratoTrabajoDeEmpleado(int numempleado) {
        ContratoTrabajo con = null;
        try
        {
            iniciaOperacion();
            con = (ContratoTrabajo) sesion.createQuery("from ContratoTrabajo where empleado="+Integer.toString(numempleado)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return con;
    }
    
}
