/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.ContactoProveedor;
import Modelo.Entidades.PersonaMedio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ContactoProveedorDao {
    private Session sesion;
    private Transaction tx;

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
    
    public void guardar(ContactoProveedor cp){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(cp); 
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
    
    public void actualizar(ContactoProveedor cp){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(cp); 
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
    
    public void eliminar(ContactoProveedor cp){
        try
        {
            iniciaOperacion();
            sesion.delete(cp);
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
    
    public ContactoProveedor obtener(int idcc) throws HibernateException{
        ContactoProveedor cp = null;
        try
        {
            iniciaOperacion();
            cp = (ContactoProveedor) sesion.get(ContactoProveedor.class, idcc);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cp;
    }
    
    public List<ContactoProveedor> obtenerContactosDeProveedor(int idprov) throws HibernateException{
        List<ContactoProveedor> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ContactoProveedor where proveedor="+Integer.toString(idprov)).list();
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
    
    public List<PersonaMedio> obtenerMediosDeContactosDeProveedor(int idprov) throws HibernateException{
        List<PersonaMedio> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PersonaMedio where persona in "+
                    "(select contacto from ContactoProveedor where proveedor="+Integer.toString(idprov)+")").list();
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
