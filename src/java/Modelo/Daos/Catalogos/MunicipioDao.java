/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.Municipio;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class MunicipioDao {
    
    private Session sesion;
    private Transaction tx;
    
    
    public MunicipioDao(){
        
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
    
    
    public Municipio obtener(int idmun) throws HibernateException{
        Municipio mun = null;
        try
        {
            iniciaOperacion();
            mun = (Municipio) sesion.get(Municipio.class, idmun);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return mun;
    }
    

    public List<Municipio> obtenerLista() throws HibernateException{
        List<Municipio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Municipio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Municipio> obtenerListaPorPrioridad() throws HibernateException{
        List<Municipio> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Municipio order by prioridad desc, municipio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Municipio> obtenerMunisDeEdoAlfabetico(int idestado) {
        List<Municipio> munis = null;

        try
        {
            iniciaOperacion();
            munis = sesion.createQuery("from Municipio where estado="+ Integer.toString(idestado) +" order by municipio").list();
        }finally
        {
            sesion.close();
        }
        
        return munis;
    }
    
}
