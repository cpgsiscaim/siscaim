/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoMedio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class TipoMedioDao {
    private Session sesion;
    private Transaction tx;
    
    
    public TipoMedioDao(){
        
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

    public TipoMedio obtener(int idtipo) throws HibernateException{
        TipoMedio tipo = null;
        try
        {
            iniciaOperacion();
            tipo = (TipoMedio) sesion.get(TipoMedio.class, idtipo);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tipo;
    }
    
    public List<TipoMedio> obtenerLista() throws HibernateException{
        List<TipoMedio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoMedio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<TipoMedio> obtenerListaActivos() throws HibernateException{
        List<TipoMedio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoMedio where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
