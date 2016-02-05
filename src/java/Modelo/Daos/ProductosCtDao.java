/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Producto;
import Modelo.Entidades.ProductosCt;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ProductosCtDao {
    private Session sesion;
    private Transaction tx;

    public ProductosCtDao(){
        
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
    
    public void guardar(ProductosCt prodct){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(prodct); 
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
    
    public void actualizar(ProductosCt prodct){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(prodct); 
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
    
    public void eliminar(ProductosCt prodct){
        try
        {
            iniciaOperacion();
            sesion.delete(prodct);
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
    
    public ProductosCt obtener(int idprodct) throws HibernateException{
        ProductosCt prodct = null;
        try
        {
            iniciaOperacion();
            prodct = (ProductosCt) sesion.get(ProductosCt.class, idprodct);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return prodct;
    }
    
    public List<ProductosCt> obtenerLista() throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<ProductosCt> obtenerListaActivosDeCT(int idct) throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt where estatus=1 and categoria=1 and centrotrab="+Integer.toString(idct) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idprodct){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update ProductosCt set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idprodct)).executeUpdate();
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
    
    public List<ProductosCt> obtenerListaInactivosDeCT(int idct) throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt where estatus=0 and categoria=1 and centrotrab="+Integer.toString(idct) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<ProductosCt> obtenerListaActivosDeContrato(int idcon) throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt where estatus=1 and categoria=0 and contrato="+Integer.toString(idcon) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<ProductosCt> obtenerListaInactivosDeContrato(int idcon) throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt where estatus=0 and categoria=0 and contrato="+Integer.toString(idcon) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Producto> obtenerProductosDisponiblesDeContrato(int idcon) throws HibernateException{
        List<Producto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Producto where estatus=1 and id not in (select distinct producto from ProductosCt where estatus=1 and categoria=0 and contrato="+Integer.toString(idcon) +")" +
                    " order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<ProductosCt> obtenerBasicosActivosDeCT(int idct) throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt where estatus=1 and tipo=0 and categoria=1 and centrotrab="+Integer.toString(idct) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<ProductosCt> obtenerCambiosActivosDeCT(int idct) throws HibernateException{
        List<ProductosCt> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from ProductosCt where estatus=1 and tipo=1 and categoria=1 and centrotrab="+Integer.toString(idct) +" order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<ProductosCt> obtenerDeConsulta(String consulta) {
        List<ProductosCt> lista = null;
        
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

    public boolean TieneProdsCT(int idct) {
        boolean hay = true;
        Long count = new Long(0);
        
        try
        {
            iniciaOperacion();
            count = (Long)sesion.createQuery("select count(*) from ProductosCt where estatus=1 and categoria=1 and centrotrab="+Integer.toString(idct)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        if (count.intValue()==0)
            hay = false;
        
        return hay;
    }

    public ProductosCt obtenerProductoCtDeProdYCt(int idprod, int idct) {
        ProductosCt prodct = null;
        try
        {
            iniciaOperacion();
            prodct = (ProductosCt) sesion.createQuery("from ProductosCt where estatus=1 and categoria=1 and centrotrab="+Integer.toString(idct)+
                    " and producto="+Integer.toString(idprod)).uniqueResult();
            if (prodct==null)
                prodct = (ProductosCt) sesion.createQuery("from ProductosCt where estatus=0 and categoria=1 and centrotrab="+Integer.toString(idct)+
                    " and producto="+Integer.toString(idprod)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return prodct;
    }

    public ProductosCt obtenerPctDeContratoDeProdYCon(int idprod, int idcon) {
        ProductosCt prodct = null;
        try
        {
            iniciaOperacion();
            prodct = (ProductosCt) sesion.createQuery("from ProductosCt where estatus=1 and categoria=0 and contrato="+Integer.toString(idcon)+
                    " and producto="+Integer.toString(idprod)).uniqueResult();
            if (prodct==null)
                prodct = (ProductosCt) sesion.createQuery("from ProductosCt where estatus=0 and categoria=0 and contrato="+Integer.toString(idcon)+
                    " and producto="+Integer.toString(idprod)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return prodct;
    }
}
