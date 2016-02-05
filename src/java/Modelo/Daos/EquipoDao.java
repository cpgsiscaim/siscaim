/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Equipo;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class EquipoDao {
    private Session sesion;
    private Transaction tx;

    public EquipoDao(){
        
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
    
    public void guardar(Equipo equi){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(equi); 
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
    
    public void actualizar(Equipo equi){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(equi); 
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
    
    public void eliminar(Equipo equi){
        try
        {
            iniciaOperacion();
            sesion.delete(equi);
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
    
    public Equipo obtener(int idequi) throws HibernateException{
        Equipo equi = null;
        try
        {
            iniciaOperacion();
            equi = (Equipo) sesion.get(Equipo.class, idequi);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return equi;
    }
    
    public List<Equipo> obtenerLista() throws HibernateException{
        List<Equipo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Equipo").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Equipo> obtenerListaActivos() throws HibernateException{
        List<Equipo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Equipo where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idequi){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Equipo set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idequi)).executeUpdate();
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
    
    public List<Equipo> obtenerListaInactivos() throws HibernateException{
        List<Equipo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Equipo where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Equipo> obtenerActivosDeSucursalYTipo(int idSucSel, int idTipo) throws HibernateException {
        List<Equipo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Equipo where estatus=1 and sucursal="+Integer.toString(idSucSel)+" and tipoactivo="+Integer.toString(idTipo)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Equipo> obtenerInactivosDeSucursalYTipo(int idSucSel, int idTipo) throws HibernateException {
        List<Equipo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Equipo where estatus=0 and sucursal="+Integer.toString(idSucSel)+" and tipoactivo="+Integer.toString(idTipo)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Equipo> obtenerEquiposDeSucursalFiltrado(String consulta) throws HibernateException {
        List<Equipo> lista = null;
        
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
    
}
