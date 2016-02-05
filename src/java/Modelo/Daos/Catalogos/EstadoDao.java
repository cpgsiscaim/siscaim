/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.Municipio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class EstadoDao {
    private Session sesion;
    private Transaction tx;

    public EstadoDao(){
        
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
    

    public List<Estado> obtenerLista() throws HibernateException{
        List<Estado> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Estado").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Estado> obtenerListaPorPrioridad() throws HibernateException{
        List<Estado> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Estado order by prioridad desc, estado").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List obtenerMunicipios(int idestado) throws HibernateException{
        //FROM Usuario u inner join fetch u.permisos
        List<Municipio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("FROM Estado e inner join fetch e.municipios where e.idestado="+Integer.toString(idestado)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
        
    }
    
}
