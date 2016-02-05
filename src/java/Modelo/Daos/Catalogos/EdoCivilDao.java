/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

/**
 *
 * @author roman
 */
import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.Civil;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class EdoCivilDao {
    private Session sesion;
    private Transaction tx;
    
    public EdoCivilDao(){
        
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
    //obtener lista de edo. civil
    public List<Civil> obtenerLista() throws HibernateException{
        List<Civil> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Civil").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
