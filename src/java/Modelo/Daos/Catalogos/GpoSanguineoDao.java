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

public class GpoSanguineoDao {
    private Session sesion;
    private Transaction tx;
    public GpoSanguineoDao(){
        
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
    //obtener lista de gpo. sanguineo
    public List<Civil> obtenerLista() throws HibernateException {
        List<Civil> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from GpoSanguineo").list();
        } finally {
            sesion.close();
        }

        return lista;
    }
}
