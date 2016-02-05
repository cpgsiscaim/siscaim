/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.ContactoCliente;
import Modelo.Entidades.PersonaMedio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ContactoClienteDao {
    private Session sesion;
    private Transaction tx;
    
    public ContactoClienteDao(){}
    
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
    
    public void guardar(ContactoCliente cc){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(cc); 
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
    
    public void actualizar(ContactoCliente cc){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(cc); 
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
    
    public void eliminar(ContactoCliente cc){
        try
        {
            iniciaOperacion();
            sesion.delete(cc);
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
    
    public ContactoCliente obtener(int idcc) throws HibernateException{
        ContactoCliente cc = null;
        try
        {
            iniciaOperacion();
            cc = (ContactoCliente) sesion.get(ContactoCliente.class, idcc);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cc;
    }
    
    public List<ContactoCliente> obtenerContactosDeCliente(int idcli) throws HibernateException{
        List<ContactoCliente> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ContactoCliente where cliente="+Integer.toString(idcli)).list();
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
    
    public List<PersonaMedio> obtenerMediosDeContactosDeCliente(int idcli) throws HibernateException{
        List<PersonaMedio> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PersonaMedio where persona in "+
                    "(select contacto from ContactoCliente where cliente="+Integer.toString(idcli)+")").list();
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
