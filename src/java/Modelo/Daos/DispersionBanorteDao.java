/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.DispersionBanorte;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class DispersionBanorteDao {
    private Session sesion;
    private Transaction tx;

    public DispersionBanorteDao(){
        
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
    
    public void guardar(DispersionBanorte disp){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(disp); 
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
    
    public void actualizar(DispersionBanorte disp){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(disp); 
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
    
    public void eliminar(DispersionBanorte disp){
        try
        {
            iniciaOperacion();
            sesion.delete(disp);
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
    
    public DispersionBanorte obtener(int id) throws HibernateException{
        DispersionBanorte disp = null;
        try
        {
            iniciaOperacion();
            disp = (DispersionBanorte) sesion.get(DispersionBanorte.class, id);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return disp;
    }
    
    public int obtenerSiguienteConsecutivoDeNomina(int idnom) {
        int sig = 0;
        try
        {
            iniciaOperacion();
            Integer ax = (Integer)sesion.createQuery("select max(consecutivo) from DispersionBanorte where nomina = "+Integer.toString(idnom)).uniqueResult();
            if (ax!=null)
                sig = ax.intValue()+1;
            else
                sig = 1;
        }finally
        {
            sesion.close();
        }
        return sig;
    }
}
