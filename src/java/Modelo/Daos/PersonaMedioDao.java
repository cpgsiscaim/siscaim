/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.PersonaMedio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class PersonaMedioDao {
    private Session sesion;
    private Transaction tx;

    public PersonaMedioDao(){
        
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
    
    public void guardar(PersonaMedio pmed){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(pmed); 
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
    
    public void actualizar(PersonaMedio pmed){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(pmed); 
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
    
    public void eliminar(PersonaMedio pmed){
        try
        {
            iniciaOperacion();
            sesion.delete(pmed);
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
    
    public PersonaMedio obtener(int idmedio) throws HibernateException{
        PersonaMedio pmed = null;
        try
        {
            iniciaOperacion();
            pmed = (PersonaMedio) sesion.get(PersonaMedio.class, idmedio);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return pmed;
    }
    
    public List<PersonaMedio> obtenerActivosDePersona(int idPer) throws HibernateException{
        List<PersonaMedio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PersonaMedio where estatus=1 and persona="+Integer.toString(idPer)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<PersonaMedio> obtenerInactivosDePersona(int idPer) throws HibernateException{
        List<PersonaMedio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PersonaMedio where estatus=0 and persona="+Integer.toString(idPer)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void actualizarEstatus(int estatus, int idMp){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update PersonaMedio set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idMp)).executeUpdate();
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

    public PersonaMedio obtenerMedioPersonaPorMedio(String medio, int idpersona) {
        PersonaMedio pmed = null;
        try
        {
            iniciaOperacion();
            pmed = (PersonaMedio) sesion.createQuery("from PersonaMedio where estatus=1 and medio.medio='"+medio+"' and persona="+Integer.toString(idpersona)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return pmed;
    }
    
    public List<PersonaMedio> obtenerCorreosDePersona(int idpersona) {
        List<PersonaMedio> correos = null;
        try
        {
            iniciaOperacion();
            correos = sesion.createQuery("from PersonaMedio where estatus=1 and medio.tipo=3 and persona="+Integer.toString(idpersona)).list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return correos;
    }
    
}
