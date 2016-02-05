/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Empleado;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class EmpleadoDao {
    private Session sesion;
    private Transaction tx;

    public EmpleadoDao(){
        
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
    
    public void guardar(Empleado emp){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(emp); 
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
    
    public void actualizar(Empleado emp){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(emp); 
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
    
    public void eliminar(Empleado emp){
        try
        {
            iniciaOperacion();
            sesion.delete(emp);
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
    
    public Empleado obtener(int numempleado) throws HibernateException{
        Empleado emp = null;
        try
        {
            iniciaOperacion();
            emp = (Empleado) sesion.get(Empleado.class, numempleado);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return emp;
    }
    
    public List<Empleado> obtenerLista() throws HibernateException{
        List<Empleado> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Empleado> obtenerListaActivos() throws HibernateException {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=1").list();
        } finally {
            sesion.close();
        }

        return lista;
    }
    public List<Empleado> obtenerListaInactivos() throws HibernateException {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=0").list();
        } finally {
            sesion.close();
        }

        return lista;
    }
    public void actualizarEstatus(int estatus, int idemp){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Empleado set estatus = " + Integer.toString(estatus) +
                    " where numempleado = " + Integer.toString(idemp)).executeUpdate();
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

    public List<Empleado> obtenerListaActivosDeSucursal(int idsuc) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=1 and persona.sucursal="+Integer.toString(idsuc)+
                    " order by persona.paterno, persona.materno, persona.nombre, clave, "+
                    " persona.direccion.poblacion.estado, persona.direccion.poblacion").list();
        } finally {
            sesion.close();
        }

        return lista;
    }

    public List<Empleado> obtenerListaActivosDeSucursalSinUsuario(int idsuc) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=1 and persona.sucursal="+Integer.toString(idsuc)+
                    " and numempleado not in (select distinct empleado from Usuario where estatus=1 and empleado.persona.sucursal="+Integer.toString(idsuc)+
                    ") order by persona.nombre, persona.paterno, persona.materno").list();
        } finally {
            sesion.close();
        }

        return lista;
    }

    public boolean ValidaClaveEmpleado(Empleado empl) {
        Empleado existe = obtenerPorClave(empl.getClave());
        if (existe == null)
            return false;
        else
            return true;
    }

    private Empleado obtenerPorClave(String clave) {
        Empleado emp = null;
        try
        {
            iniciaOperacion();
            emp = (Empleado) sesion.createQuery("from Empleado where clave='"+clave+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return emp;
    }

    public List<Empleado> obtenerListaActivosDeSucursalPorNombre(int idsuc) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=1 and persona.sucursal="+Integer.toString(idsuc)+
                    " order by persona.paterno, persona.materno, persona.nombre, clave").list();
        } finally {
            sesion.close();
        }

        return lista;
    }

    public List<Empleado> obtenerListaConsulta(String consulta) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery(consulta).list();
        } finally {
            sesion.close();
        }

        return lista;
    }

    public List<Empleado> obtenerListaActivosDeSucursalPorClave(int idsuc) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=1 and persona.sucursal="+Integer.toString(idsuc)+
                    " order by clave, persona.paterno, persona.materno, persona.nombre").list();
        } finally {
            sesion.close();
        }

        return lista;
    }
    
    public List<Empleado> obtenerListaFullDeSucursalPorClave(int idsuc) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where persona.sucursal="+Integer.toString(idsuc)+
                    " order by clave, persona.paterno, persona.materno, persona.nombre").list();
        } finally {
            sesion.close();
        }

        return lista;
    }

    public List<Empleado> obtenerListaInactivosDeSucursal(int idsuc) {
        List<Empleado> lista = null;

        try {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado where estatus=0 and persona.sucursal="+Integer.toString(idsuc)+
                    " order by persona.paterno, persona.materno, persona.nombre, clave, "+
                    " persona.direccion.poblacion.estado, persona.direccion.poblacion").list();
        } finally {
            sesion.close();
        }

        return lista;
    }
}
