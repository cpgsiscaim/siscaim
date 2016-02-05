/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.ContactoContrato;
import Modelo.Entidades.PersonaMedio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ContactoContratoDao {
    private Session sesion;
    private Transaction tx;

    public ContactoContratoDao(){
        
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
    
    public void guardar(ContactoContrato cc){
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
    
    public void actualizar(ContactoContrato cc){
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
    
    public void eliminar(ContactoContrato cc){
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
    
    public ContactoContrato obtener(int idcc) throws HibernateException{
        ContactoContrato cc = null;
        try
        {
            iniciaOperacion();
            cc = (ContactoContrato) sesion.get(ContactoContrato.class, idcc);
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
    
    public List<ContactoContrato> obtenerContactosDeContrato(int idcontr) throws HibernateException{
        List<ContactoContrato> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ContactoContrato where contrato="+Integer.toString(idcontr)).list();
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
    
    public List<PersonaMedio> obtenerMediosDeContactosDeContrato(int idcontr) throws HibernateException{
        List<PersonaMedio> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PersonaMedio where persona in "+
                    "(select contacto from ContactoContrato where contrato="+Integer.toString(idcontr)+")").list();
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
