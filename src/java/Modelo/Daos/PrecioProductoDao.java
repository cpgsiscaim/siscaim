/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.PrecioProducto;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class PrecioProductoDao {
    private Session sesion;
    private Transaction tx;

    public PrecioProductoDao(){
        
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
    
    public void guardar(PrecioProducto precio){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(precio); 
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
    
    public void actualizar(PrecioProducto precio){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(precio); 
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
    
    public void eliminar(PrecioProducto precio){
        try
        {
            iniciaOperacion();
            sesion.delete(precio);
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
    
    public PrecioProducto obtener(int idpre) throws HibernateException{
        PrecioProducto precio = null;
        try
        {
            iniciaOperacion();
            precio = (PrecioProducto) sesion.get(PrecioProducto.class, idpre);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return precio;
    }
    
    public List<PrecioProducto> obtenerPreciosDeProducto(int idprod) throws HibernateException{
        List<PrecioProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PrecioProducto pp left join fetch pp.producto left join fetch pp.sucursal where pp.producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public PrecioProducto obtenerPrecioNDeProductoYSucursal(int num, int idprod, int idsuc) {
        PrecioProducto pp = null;
        try
        {
            iniciaOperacion();
            pp = (PrecioProducto)sesion.createQuery("from PrecioProducto where producto="+Integer.toString(idprod)
                    + " and sucursal="+Integer.toString(idsuc)
                    + " and num="+Integer.toString(num)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        return pp;
    }

    public List<PrecioProducto> obtenerPreciosDeProductoYSucursal(int idprod, int idsuc) {
        List<PrecioProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PrecioProducto where producto="+Integer.toString(idprod)+
                    " and sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
