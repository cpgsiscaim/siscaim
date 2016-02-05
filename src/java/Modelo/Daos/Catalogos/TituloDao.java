/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.Titulo;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class TituloDao {
    private Session sesion;
    private Transaction tx;
    
    
    public TituloDao(){
        
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

    public List<Titulo> obtenerLista() throws HibernateException{
        List<Titulo> lista = null;
        
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
    
    public List<Titulo> obtenerListaActivos() throws HibernateException{
        List<Titulo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Titulo where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
