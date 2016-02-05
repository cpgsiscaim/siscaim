/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Medio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class MedioDao {
    private Session sesion;
    private Transaction tx;

    public MedioDao(){
        
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
    
    public void guardar(Medio medio){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(medio); 
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
    
    public void actualizar(Medio medio){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(medio); 
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
    
    public void eliminar(Medio medio){
        try
        {
            iniciaOperacion();
            sesion.delete(medio);
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
    
    public Medio obtener(int idmedio) throws HibernateException{
        Medio medio = null;
        try
        {
            iniciaOperacion();
            medio = (Medio) sesion.get(Medio.class, idmedio);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return medio;
    }
    
    public List<Medio> obtenerLista() throws HibernateException{
        List<Medio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Medio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public int obtenerMaxId() throws HibernateException {
        int max = 0;
        try
        {
            iniciaOperacion();
            max = Integer.parseInt(sesion.createQuery("select max(id) from Medio").uniqueResult().toString());
        }finally
        {
            sesion.close();
        }
        
        return max;
    }

    public Medio obtenerMedioPorValorYTipo(String valor, int idtipomedio) {
        Medio medio = null;
        try
        {
            iniciaOperacion();
            medio = (Medio) sesion.createQuery("from Medio where medio='"+valor+"' and tipo="+Integer.toString(idtipomedio)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return medio;
    }
    
}
