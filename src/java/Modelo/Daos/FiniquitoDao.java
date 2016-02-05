/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Finiquito;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class FiniquitoDao {
    private Session sesion;
    private Transaction tx;

    public FiniquitoDao(){
        
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
    
    public void guardar(Finiquito fin){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(fin); 
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
    
    public void actualizar(Finiquito fin){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(fin); 
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
    
    public void eliminar(Finiquito fin){
        try
        {
            iniciaOperacion();
            sesion.delete(fin);
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
    
    public Finiquito obtener(int idplaza) throws HibernateException{
        Finiquito fin = null;
        try
        {
            iniciaOperacion();
            fin = (Finiquito) sesion.get(Finiquito.class, idplaza);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return fin;
    }
    
    public Finiquito obtenerFiniquitoDeEmpleado(int numempleado) throws HibernateException{
        Finiquito fini = null;
        
        try
        {
            iniciaOperacion();
            fini = (Finiquito)sesion.createQuery("from Finiquito where empleado = "+Integer.toString(numempleado)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return fini;
    }
    
}
