/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Empresa;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class EmpresaDao {
    private Session sesion;
    private Transaction tx;

    public EmpresaDao(){
        
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
    
    public void guardar(Empresa empresa){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(empresa); 
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
    
    public void actualizar(Empresa empresa){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(empresa); 
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
    
    public void eliminar(Empresa empresa){
        try
        {
            iniciaOperacion();
            sesion.delete(empresa);
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
    
    public Empresa obtener(int id) throws HibernateException{
        Empresa empresa = null;
        try
        {
            iniciaOperacion();
            empresa = (Empresa) sesion.get(Empresa.class, id);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return empresa;
    }
    

    public List<Empresa> obtenerLista() throws HibernateException{
        List<Empresa> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Empresa").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public String obtenerLogo(int idempr) throws HibernateException{
        String logo = null;
        
        try
        {
            iniciaOperacion();
            logo = (String)sesion.createQuery("select logo from Empresa where id="+Integer.toString(idempr)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return logo;
    }
    
}
