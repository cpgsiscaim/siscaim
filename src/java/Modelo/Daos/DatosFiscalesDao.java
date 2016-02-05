/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.DatosFiscales;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class DatosFiscalesDao {
    private Session sesion;
    private Transaction tx;

    public DatosFiscalesDao(){
        
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
    
    public void guardar(DatosFiscales datf){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(datf); 
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
    
    public void actualizar(DatosFiscales datf){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(datf); 
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
    
    public void eliminar(DatosFiscales datf){
        try
        {
            iniciaOperacion();
            sesion.delete(datf);
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
    
    public DatosFiscales obtener(int iddatf) throws HibernateException{
        DatosFiscales datf = null;
        try
        {
            iniciaOperacion();
            datf = (DatosFiscales) sesion.get(DatosFiscales.class, iddatf);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return datf;
    }
    
    public List<DatosFiscales> obtenerLista() throws HibernateException{
        List<DatosFiscales> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DatosFiscales").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
