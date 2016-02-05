/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Agente;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class AgenteDao {
    private Session sesion;
    private Transaction tx;

    public AgenteDao(){
        
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
    
    public void guardar(Agente agente){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(agente); 
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
    
    public void actualizar(Agente agente){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(agente); 
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
    
    public void eliminar(Agente agente){
        try
        {
            iniciaOperacion();
            sesion.delete(agente);
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
    
    public Agente obtener(int idagente) throws HibernateException{
        Agente agente = null;
        try
        {
            iniciaOperacion();
            agente = (Agente) sesion.get(Agente.class, idagente);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return agente;
    }
    
    public List<Agente> obtenerLista() throws HibernateException{
        List<Agente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Agente").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Agente> obtenerListaActivos() throws HibernateException{
        List<Agente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Agente where estatus=1 order by "+
                    "empleado.persona.paterno, empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idagente){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Agente set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idagente)).executeUpdate();
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
    
    public List<Agente> obtenerListaInactivos() throws HibernateException{
        List<Agente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Agente where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Agente> obtenerAgentesDeSucursal(int idSucSel) throws HibernateException {
        List<Agente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Agente where estatus=1 and sucursal="+Integer.toString(idSucSel)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
