/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Existencia;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author temoc
 */
public class ExistenciaDao {
    private Session sesion;
    private Transaction tx;

    public ExistenciaDao(){
        
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
    
    public void guardar(Existencia exis){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(exis); 
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
    
    public void actualizar(Existencia exis){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(exis); 
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
    
    public void eliminar(Existencia exis){
        try
        {
            iniciaOperacion();
            sesion.delete(exis);
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
    
    public Existencia obtener(int idexis) throws HibernateException{
        Existencia exis = null;
        try
        {
            iniciaOperacion();
            exis = (Existencia) sesion.get(Existencia.class, idexis);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return exis;
    }
    
    public List<Existencia> obtenerLista() throws HibernateException{
        List<Existencia> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Existencia").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Existencia> obtenerExistenciasDeAlmacen(int idalm) throws HibernateException{
        List<Existencia> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Existencia where almacen="+Integer.toString(idalm)+
                    " and producto.estatus=1" +
                    " order by producto.descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }


    public float obtenerExistenciaDeProductoEnAlmacen(int idalm, int idprod) throws HibernateException{
        Float exis = new Float(0);
        
        try
        {
            iniciaOperacion();
            exis = (Float)sesion.createQuery("select existencia from Existencia where almacen="+Integer.toString(idalm)+" and producto="+Integer.toString(idprod)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return exis!=null?exis.floatValue():0f;
    }

    public List<Existencia> obtenerExistenciasDeProducto(int idprod) throws HibernateException{
        List<Existencia> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Existencia where producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

}
