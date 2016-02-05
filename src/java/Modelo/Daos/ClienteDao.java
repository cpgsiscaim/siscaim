/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Cliente;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class ClienteDao {
    private Session sesion;
    private Transaction tx;

    public ClienteDao(){
        
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
    
    public void guardar(Cliente clie){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(clie); 
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
    
    public void actualizar(Cliente clie){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(clie); 
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
    
    public void eliminar(Cliente clie){
        try
        {
            iniciaOperacion();
            sesion.delete(clie);
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
    
    public Cliente obtener(int idclie) throws HibernateException{
        Cliente clie = null;
        try
        {
            iniciaOperacion();
            clie = (Cliente) sesion.get(Cliente.class, idclie);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return clie;
    }
    
    public List<Cliente> obtenerLista() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cliente> obtenerListaActivos() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idclie){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Cliente set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idclie)).executeUpdate();
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
    
    public List<Cliente> obtenerListaInactivos() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cliente> obtenerClientesDeSucursal(int idSucSel) throws HibernateException {
        List<Cliente> lista = null;
        List<Cliente> lista1 = null;
        List<Cliente> lista2 = null;
        List<Cliente> glob1 = null;
        List<Cliente> glob2 = null;
        
        try
        {
            iniciaOperacion();
            lista1 = sesion.createQuery("from Cliente where estatus=1 and tipo=0 and cglobal=0 and sucursal="+Integer.toString(idSucSel)+" order by datosFiscales.razonsocial").list();
            lista2 = sesion.createQuery("from Cliente where estatus=1 and tipo=1 and cglobal=0 and sucursal="+Integer.toString(idSucSel)+" order by datosFiscales.persona.nombre, datosFiscales.persona.paterno, datosFiscales.persona.materno").list();
            glob1 = sesion.createQuery("from Cliente where estatus=1 and tipo=0 and cglobal=1 order by datosFiscales.razonsocial").list();
            glob2 = sesion.createQuery("from Cliente where estatus=1 and tipo=1 and cglobal=1 order by datosFiscales.persona.nombre, datosFiscales.persona.paterno, datosFiscales.persona.materno").list();
        }finally
        {
            sesion.close();
        }
        if (glob1 != null || glob2 != null || lista1 != null || lista2 != null)
            lista = new ArrayList<Cliente>();
        if (glob1 != null)
            lista.addAll(glob1);
        if (glob2 != null)
            lista.addAll(glob2);
        if (lista1 != null)
            lista.addAll(lista1);
        if (lista2 != null)
            lista.addAll(lista2);
        /*
        if (lista1 != null || lista2 != null)
            lista = new ArrayList<Cliente>();
        if (lista1 != null)
            lista.addAll(lista1);
        if (lista2 != null)
            lista.addAll(lista2);
        */
            
        
        return lista;
    }
    
    public List<Cliente> obtenerInactivosDeSucursal(int idSucSel) throws HibernateException {
        List<Cliente> lista = null;
        List<Cliente> lista1 = null;
        List<Cliente> lista2 = null;
        List<Cliente> glob1 = null;
        List<Cliente> glob2 = null;
        
        try
        {
            iniciaOperacion();
            lista1 = sesion.createQuery("from Cliente where estatus=0 and tipo=0 and cglobal=0 and sucursal="+Integer.toString(idSucSel)+" order by datosFiscales.razonsocial").list();
            lista2 = sesion.createQuery("from Cliente where estatus=0 and tipo=1 and cglobal=0 and sucursal="+Integer.toString(idSucSel)+" order by datosFiscales.persona.nombre, datosFiscales.persona.paterno, datosFiscales.persona.materno").list();
            glob1 = sesion.createQuery("from Cliente where estatus=0 and tipo=0 and cglobal=1 order by datosFiscales.razonsocial").list();
            glob2 = sesion.createQuery("from Cliente where estatus=0 and tipo=1 and cglobal=1 order by datosFiscales.persona.nombre, datosFiscales.persona.paterno, datosFiscales.persona.materno").list();
        }finally
        {
            sesion.close();
        }
        if (glob1 != null || glob2 != null || lista1 != null || lista2 != null)
            lista = new ArrayList<Cliente>();
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
    
    public List<Cliente> obtenerClientesDeSucursalFiltrado(String consulta) throws HibernateException {
        List<Cliente> lista = null;
        
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
    
    public List<Cliente> obtenerListaActivosGlobales() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente where estatus=1 and cglobal=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
