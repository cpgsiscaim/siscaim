/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.ContactoCT;
import Modelo.Entidades.PersonaMedio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ContactoCTDao {
    private Session sesion;
    private Transaction tx;
    
    public ContactoCTDao(){
        
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
    
    public void guardar(ContactoCT cct){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(cct); 
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
    
    public void actualizar(ContactoCT cct){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(cct); 
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
    
    public void eliminar(ContactoCT cct){
        try
        {
            iniciaOperacion();
            sesion.delete(cct);
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
    
    public ContactoCT obtener(int idcct) throws HibernateException{
        ContactoCT cct = null;
        try
        {
            iniciaOperacion();
            cct = (ContactoCT) sesion.get(ContactoCT.class, idcct);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cct;
    }
    
    public List<ContactoCT> obtenerContactosDeCT(int idct) throws HibernateException{
        List<ContactoCT> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ContactoCT where ct="+Integer.toString(idct)).list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<PersonaMedio> obtenerMediosDeContactosDeCT(int idct) throws HibernateException{
        List<PersonaMedio> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PersonaMedio where persona in "+
                    "(select contacto from ContactoCT where ct="+Integer.toString(idct)+")").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
