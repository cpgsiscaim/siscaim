package Configuracion;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 *
 * @author TEMOC
 */
import org.hibernate.HibernateException;
import org.hibernate.SessionFactory; 
import org.hibernate.cfg.AnnotationConfiguration;

public class HibernateUtil
{  
    private static final SessionFactory sessionFactory;   

    static 
    { 
        try 
        { 
            sessionFactory = new AnnotationConfiguration().configure().buildSessionFactory(); 
        } catch (HibernateException he) 
        { 
           System.err.println("Ocurrió un error en la inicialización de la SessionFactory: " + he); 
            throw new ExceptionInInitializerError(he); 
        } 
    }  

    public static SessionFactory getSessionFactory() 
    { 
        return sessionFactory; 
    }
    
    public static void destroy() 
    { 
        sessionFactory.close(); 
    } 
}
