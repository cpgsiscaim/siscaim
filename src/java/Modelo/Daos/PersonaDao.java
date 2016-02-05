/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Persona;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class PersonaDao {
    private Session sesion;
    private Transaction tx;

    public PersonaDao(){
        
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
    
    public void guardar(Persona per){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(per); 
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
    
    public void actualizar(Persona per){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(per); 
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
    
    public void eliminar(Persona per){
        try
        {
            iniciaOperacion();
            sesion.delete(per);
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
    
    public Persona obtener(String idpersona) throws HibernateException{
        Persona pers = null;
        try
        {
            iniciaOperacion();
            pers = (Persona) sesion.get(Persona.class, idpersona);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return pers;
    }
    
    public List<Persona> obtenerLista() throws HibernateException{
        List<Persona> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Persona").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Persona> obtenerListaSexo(char sexo) throws HibernateException{
        List<Persona> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Persona where Sexo='"+sexo+"'").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public int obtenerMaxId() {
        int max = 0;
        try
        {
            iniciaOperacion();
            max = Integer.parseInt(sesion.createQuery("select max(id) from Persona").uniqueResult().toString());
        }finally
        {
            sesion.close();
        }
        
        return max;
    }

}
