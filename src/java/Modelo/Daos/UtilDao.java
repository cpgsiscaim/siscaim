/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Usuario;
import java.util.Date;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class UtilDao {
    private Session sesion;
    private Transaction tx;

    public UtilDao(){
        
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

    public Date hoy() throws HibernateException{
        Date fecha = null;
        try
        {
            iniciaOperacion();
            fecha = (Date) sesion.createQuery("select curdate() from Utilerias").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return fecha;
    }
    
    public int grupos() throws HibernateException{
        int g = 0;
        try
        {
            iniciaOperacion();
            g = (Integer)sesion.createQuery("select grupos from Utilerias").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return g;
    }
    
    //select year(curdate()) from Utilerias
    public int AñoActual() throws HibernateException{
        int g = 0;
        try
        {
            iniciaOperacion();
            g = (Integer)sesion.createQuery("select year(curdate()) from Utilerias").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return g;
    }
    
}
