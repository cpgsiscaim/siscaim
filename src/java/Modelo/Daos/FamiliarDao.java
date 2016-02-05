/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Familiar;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class FamiliarDao {
    private Session sesion;
    private Transaction tx;

    public FamiliarDao(){
        
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
    
    public void guardar(Familiar fam){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(fam); 
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
    
    public void actualizar(Familiar fam){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(fam); 
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
    
    public void eliminar(Familiar fam){
        try
        {
            iniciaOperacion();
            sesion.delete(fam);
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
    
    public Familiar obtener(int idequi) throws HibernateException{
        Familiar fam = null;
        try
        {
            iniciaOperacion();
            fam = (Familiar) sesion.get(Familiar.class, idequi);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return fam;
    }
    
    public List<Familiar> obtenerLista() throws HibernateException{
        List<Familiar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Familiar").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Familiar> obtenerListaActivos() throws HibernateException{
        List<Familiar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Familiar where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idequi){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Familiar set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idequi)).executeUpdate();
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
    
    public List<Familiar> obtenerListaInactivos() throws HibernateException{
        List<Familiar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Familiar where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Familiar> obtenerActivosDeEmpleado(int idEmp) throws HibernateException {
        List<Familiar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Familiar where estatus=1 and empleado="+Integer.toString(idEmp)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Familiar> obtenerInactivosDeEmpleado(int idEmp) throws HibernateException {
        List<Familiar> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Familiar where estatus=0 and empleado="+Integer.toString(idEmp)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
