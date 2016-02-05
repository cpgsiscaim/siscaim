/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Proveedor;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ProveedorDao {
    private Session sesion;
    private Transaction tx;

    public ProveedorDao(){
        
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
    
    public void guardar(Proveedor prov){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(prov); 
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
    
    public void actualizar(Proveedor prov){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(prov); 
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
    
    public void eliminar(Proveedor prov){
        try
        {
            iniciaOperacion();
            sesion.delete(prov);
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
    
    public Proveedor obtener(int idprov) throws HibernateException{
        Proveedor prov = null;
        try
        {
            iniciaOperacion();
            prov = (Proveedor) sesion.get(Proveedor.class, idprov);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return prov;
    }
    
    public List<Proveedor> obtenerLista() throws HibernateException{
        List<Proveedor> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Proveedor").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Proveedor> obtenerListaActivos() throws HibernateException{
        List<Proveedor> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Proveedor where estatus=1 order by datosfiscales.razonsocial, datosfiscales.persona.paterno, datosfiscales.persona.materno, datosfiscales.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idprov){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Proveedor set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idprov)).executeUpdate();
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
    
    public List<Proveedor> obtenerListaInactivos() throws HibernateException{
        List<Proveedor> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Proveedor where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Proveedor> obtenerProveedoresDeSucursal(int idSucSel) throws HibernateException {
        /*List<Proveedor> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Proveedor where estatus=1 and sucursal="+Integer.toString(idSucSel)+
                    "order by datosfiscales.razonsocial, "+
                    "datosfiscales.persona.paterno, datosfiscales.persona.materno,"+
                    " datosfiscales.persona.nombre").list();
        }finally
        {
            sesion.close();
        }*/
        List<Proveedor> lista = null;
        List<Proveedor> lista1 = null;
        List<Proveedor> lista2 = null;
        List<Proveedor> glob1 = null;
        List<Proveedor> glob2 = null;
        
        try
        {
            iniciaOperacion();
            lista1 = sesion.createQuery("from Proveedor where estatus=1 and tipo=0 and nacional=0 and sucursal="+Integer.toString(idSucSel)+" order by datosfiscales.razonsocial").list();
            lista2 = sesion.createQuery("from Proveedor where estatus=1 and tipo=1 and nacional=0 and sucursal="+Integer.toString(idSucSel)+" order by datosfiscales.persona.nombre, datosfiscales.persona.paterno, datosfiscales.persona.materno").list();
            glob1 = sesion.createQuery("from Proveedor where estatus=1 and tipo=0 and nacional=1 order by datosfiscales.razonsocial").list();
            glob2 = sesion.createQuery("from Proveedor where estatus=1 and tipo=1 and nacional=1 order by datosfiscales.persona.nombre, datosfiscales.persona.paterno, datosfiscales.persona.materno").list();
        }finally
        {
            sesion.close();
        }
        if (glob1 != null || glob2 != null || lista1 != null || lista2 != null)
            lista = new ArrayList<Proveedor>();
        if (glob1 != null)
            lista.addAll(glob1);
        if (glob2 != null)
            lista.addAll(glob2);
        if (lista1 != null)
            lista.addAll(lista1);
        if (lista2 != null)
            lista.addAll(lista2);
        
        return lista;
    }
    
    public List<Proveedor> obtenerInactivosDeSucursal(int idSucSel) throws HibernateException {
        /*List<Proveedor> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Proveedor where estatus=0 and sucursal="+Integer.toString(idSucSel)+
                    "order by datosfiscales.razonsocial, "+
                    "datosfiscales.persona.paterno, datosfiscales.persona.materno,"+
                    " datosfiscales.persona.nombre").list();
        }finally
        {
            sesion.close();
        }*/
        List<Proveedor> lista = null;
        List<Proveedor> lista1 = null;
        List<Proveedor> lista2 = null;
        List<Proveedor> glob1 = null;
        List<Proveedor> glob2 = null;
        
        try
        {
            iniciaOperacion();
            lista1 = sesion.createQuery("from Proveedor where estatus=0 and tipo=0 and nacional=0 and sucursal="+Integer.toString(idSucSel)+" order by datosfiscales.razonsocial").list();
            lista2 = sesion.createQuery("from Proveedor where estatus=0 and tipo=1 and nacional=0 and sucursal="+Integer.toString(idSucSel)+" order by datosfiscales.persona.nombre, datosfiscales.persona.paterno, datosfiscales.persona.materno").list();
            glob1 = sesion.createQuery("from Proveedor where estatus=0 and tipo=0 and nacional=1 order by datosfiscales.razonsocial").list();
            glob2 = sesion.createQuery("from Proveedor where estatus=0 and tipo=1 and nacional=1 order by datosfiscales.persona.nombre, datosfiscales.persona.paterno, datosfiscales.persona.materno").list();
        }finally
        {
            sesion.close();
        }
        if (glob1 != null || glob2 != null || lista1 != null || lista2 != null)
            lista = new ArrayList<Proveedor>();
        if (glob1 != null)
            lista.addAll(glob1);
        if (glob2 != null)
            lista.addAll(glob2);
        if (lista1 != null)
            lista.addAll(lista1);
        if (lista2 != null)
            lista.addAll(lista2);
        
        
        return lista;
    }
    
    public List<Proveedor> obtenerProveedoresDeSucursalFiltrado(String consulta) throws HibernateException {
        List<Proveedor> lista = null;
        
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

    public List<Proveedor> obtenerProveedoresDeSucursalPaginado(int idSucSel, int pag, int eles) {
        List<Proveedor> lista = null;
        List<Proveedor> lista1 = null;
        List<Proveedor> lista2 = null;
        List<Proveedor> glob1 = null;
        List<Proveedor> glob2 = null;
        
        try
        {
            iniciaOperacion();
            lista1 = sesion.createQuery("from Proveedor where estatus=1 and tipo=0 and nacional=0 and sucursal="+Integer.toString(idSucSel)+" order by datosfiscales.razonsocial").list();
            lista2 = sesion.createQuery("from Proveedor where estatus=1 and tipo=1 and nacional=0 and sucursal="+Integer.toString(idSucSel)+" order by datosfiscales.persona.nombre, datosfiscales.persona.paterno, datosfiscales.persona.materno").list();
            glob1 = sesion.createQuery("from Proveedor where estatus=1 and tipo=0 and nacional=1 order by datosfiscales.razonsocial").list();
            glob2 = sesion.createQuery("from Proveedor where estatus=1 and tipo=1 and nacional=1 order by datosfiscales.persona.nombre, datosfiscales.persona.paterno, datosfiscales.persona.materno").list();
        }finally
        {
            sesion.close();
        }
        if (glob1 != null || glob2 != null || lista1 != null || lista2 != null)
            lista = new ArrayList<Proveedor>();
        if (glob1 != null)
            lista.addAll(glob1);
        if (glob2 != null)
            lista.addAll(glob2);
        if (lista1 != null)
            lista.addAll(lista1);
        if (lista2 != null)
            lista.addAll(lista2);
        
        return lista;
    }
    
}
