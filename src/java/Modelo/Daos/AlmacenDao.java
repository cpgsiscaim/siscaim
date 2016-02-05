/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Almacen;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class AlmacenDao {
    private Session sesion;
    private Transaction tx;

    public AlmacenDao(){
        
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
    
    public void guardar(Almacen alma){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(alma); 
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
    
    public void actualizar(Almacen alma){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(alma); 
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
    
    public void eliminar(Almacen alma){
        try
        {
            iniciaOperacion();
            sesion.delete(alma);
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
    
    public Almacen obtener(int idalma) throws HibernateException{
        Almacen alma = null;
        try
        {
            iniciaOperacion();
            alma = (Almacen) sesion.get(Almacen.class, idalma);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return alma;
    }
    
    public List<Almacen> obtenerLista() throws HibernateException{
        List<Almacen> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Almacen").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Almacen> obtenerListaActivos() throws HibernateException{
        List<Almacen> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Almacen as a where a.estatus=1").list();//left join fetch a.sucursal
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idalma){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Almacen set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idalma)).executeUpdate();
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
    
    public List<Almacen> obtenerListaInactivos() throws HibernateException{
        List<Almacen> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Almacen as a where a.estatus=0").list();//left join fetch a.sucursal 
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
    
    public List<Almacen> obtenerListaActivosDeSucursal(int idsuc) throws HibernateException{
        List<Almacen> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Almacen where estatus=1 and sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
}
