/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoDocumento;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class TipoDocumentoDao {
    private Session sesion;
    private Transaction tx;
    
    public TipoDocumentoDao(){
        
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
    
    public void guardar(TipoDocumento tipodoc){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(tipodoc); 
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
    
    public void actualizar(TipoDocumento tipodoc){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(tipodoc); 
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
    
    public void eliminar(TipoDocumento tipodoc){
        try
        {
            iniciaOperacion();
            sesion.delete(tipodoc);
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
    
    public TipoDocumento obtener(int idtipo) throws HibernateException{
        TipoDocumento tipodoc = null;
        try
        {
            iniciaOperacion();
            tipodoc = (TipoDocumento) sesion.get(TipoDocumento.class, idtipo);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tipodoc;
    }
    
    public List<TipoDocumento> obtenerLista() throws HibernateException{
        List<TipoDocumento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoDocumento").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoDocumento> obtenerListaActivos() {
        List<TipoDocumento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoDocumento where estatus=1 order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void actualizarEstatus(int estatus, int id) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update TipoDocumento set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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

    public List<TipoDocumento> obtenerListaInactivos() {
        List<TipoDocumento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoDocumento where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<TipoDocumento> obtenerListaActivosDeCategoria(int idcat) {
        List<TipoDocumento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoDocumento where estatus=1 and categoria="+Integer.toString(idcat)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<TipoDocumento> obtenerListaActivosYOtros() {
        List<TipoDocumento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoDocumento where estatus in (1,2) order by descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
}
