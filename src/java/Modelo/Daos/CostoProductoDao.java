/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.CostoProducto;
import Modelo.Entidades.PrecioProducto;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class CostoProductoDao {
    private Session sesion;
    private Transaction tx;

    public CostoProductoDao(){
        
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
    
    public void guardar(CostoProducto costo){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(costo); 
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
    
    public void actualizar(CostoProducto costo){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(costo); 
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
    
    public void eliminar(CostoProducto costo){
        try
        {
            iniciaOperacion();
            sesion.delete(costo);
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
    
    public CostoProducto obtener(int idcos) throws HibernateException{
        CostoProducto costo = null;
        try
        {
            iniciaOperacion();
            costo = (CostoProducto) sesion.get(CostoProducto.class, idcos);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return costo;
    }
    
    public List<CostoProducto> obtenerCostosDeProducto(int idprod) throws HibernateException{
        List<CostoProducto> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from CostoProducto cp left join fetch cp.producto left join fetch cp.sucursal where cp.producto="+Integer.toString(idprod)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public CostoProducto obtenerCostoDeProductoYSucursal(int idprod, int idsuc) {
        CostoProducto cp = null;
        try
        {
            iniciaOperacion();
            cp = (CostoProducto)sesion.createQuery("from CostoProducto where producto="+Integer.toString(idprod)
                    + " and sucursal="+Integer.toString(idsuc)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        return cp;
    }

}
