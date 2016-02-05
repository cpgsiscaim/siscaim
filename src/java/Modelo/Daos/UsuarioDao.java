/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Usuario;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class UsuarioDao {
    
    private Session sesion;
    private Transaction tx;

    public UsuarioDao(){
        
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
    
    public void guardar(Usuario usuario){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(usuario); 
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
    
    public void actualizar(Usuario usuario){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(usuario); 
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
    
    public void eliminar(Usuario usuario){
        try
        {
            iniciaOperacion();
            sesion.delete(usuario);
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
    
    public Usuario obtener(int idusuario) throws HibernateException{
        Usuario usuario = null;
        try
        {
            iniciaOperacion();
            usuario = (Usuario) sesion.get(Usuario.class, idusuario);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return usuario;
    }
    
    public Usuario obtenerPorUsuario(String susuario) throws HibernateException{
        Usuario usuario = null;
        try
        {
            iniciaOperacion();
            usuario = (Usuario) sesion.createQuery("from Usuario u where u.usuario='"+susuario+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return usuario;
    }

    public List<Usuario> obtenerLista() throws HibernateException{
        List<Usuario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Usuario").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Usuario> obtenerUsuariosDeSucursal(int idsuc) {
        List<Usuario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Usuario where estatus=1 and empleado.persona.sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean ValidaUsuario(Usuario us) {
        Usuario existe = obtenerPorUsuario(us.getUsuario());
        if (existe == null)
            return false;
        else
            return true;
    }

    public void actualizarEstatus(int est, int idusuario) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Usuario set estatus = " + Integer.toString(est) + " where id = " + Integer.toString(idusuario)).executeUpdate();
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

    public List<Usuario> obtenerUsuariosInactivosDeSucursal(int idsuc) {
        List<Usuario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Usuario where estatus=0 and empleado.persona.sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Usuario> obtenerListaActivos() throws HibernateException{
        List<Usuario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Usuario where estatus=1"+
                    " order by empleado.persona.paterno, empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
