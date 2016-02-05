/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Producto;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ProductoDao {
    private Session sesion;
    private Transaction tx;

    public ProductoDao(){
        
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
    
    public void guardar(Producto prod){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(prod); 
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
    
    public void actualizar(Producto prod){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(prod); 
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
    
    public void eliminar(Producto prod){
        try
        {
            iniciaOperacion();
            sesion.delete(prod);
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
    
    public Producto obtener(int idprod) throws HibernateException{
        Producto prod = null;
        try
        {
            iniciaOperacion();
            prod = (Producto) sesion.get(Producto.class, idprod);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return prod;
    }
    
    public List<Producto> obtenerLista() throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Producto> obtenerListaActivos() throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Producto> obtenerActivosDeSucursal(int idsuc) throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 and sucursal="+ Integer.toString(idsuc) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idprod){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Producto set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idprod)).executeUpdate();
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
    
    public List<Producto> obtenerListaInactivos() throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Producto> obtenerInactivosDeSucursal(int idsuc) throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=0 and sucursal="+ Integer.toString(idsuc) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public Producto obtenerPorClave(String clave) throws HibernateException{
        Producto prod = null;
        try
        {
            iniciaOperacion();
            prod = (Producto) sesion.createQuery("from Producto where clave='"+clave+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return prod;
    }
    
    public boolean ValidaProducto(Producto prod) {
        Producto existe = obtenerPorClave(prod.getClave());
        if (existe == null)
            return false;
        else
            return true;
    }
    
    public List<Producto> obtenerProductosFiltrado(String consulta) throws HibernateException {
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery(consulta).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Producto> obtenerProductosDeConsumo() throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 and servicio=0 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Producto> obtenerProductosDeConsumoDeSucursal(int idsuc) throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 and servicio=0 and sucursal=" + Integer.toString(idsuc) + " order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Producto> obtenerProductosDeServicio() throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 and servicio=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Producto> obtenerProductosDeServicioDeSucursal(int idsuc) throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 and servicio=1 and sucursal=" + Integer.toString(idsuc) + " order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Producto> obtenerProductoEquivalenteDeSucursal(String clave, int idsuc, int idtiposuc) {
        List<Producto> prod = null;
        try
        {
            iniciaOperacion();
            if (idtiposuc!=0)
                prod = (List<Producto>) sesion.createQuery("from Producto where clave like '_-"+clave+"' and sucursal="+Integer.toString(idsuc)
                        + " and estatus=1").list();
            else
                prod = (List<Producto>) sesion.createQuery("from Producto where clave = '"+clave+"' and sucursal="+Integer.toString(idsuc)
                        + " and estatus=1").list();
                
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return prod;
    }
    
}
