/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Generales.Conexion;
import Modelo.Entidades.Empleado;
import Modelo.Entidades.Plaza;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class PlazaDao {
    private Session sesion;
    private Transaction tx;

    public PlazaDao(){
        
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
    
    public void guardar(Plaza plaza){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(plaza); 
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
    
    public void actualizar(Plaza plaza){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(plaza); 
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
    
    public void eliminar(Plaza plaza){
        try
        {
            iniciaOperacion();
            sesion.delete(plaza);
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
    
    public Plaza obtener(int idplaza) throws HibernateException{
        Plaza plaza = null;
        try
        {
            iniciaOperacion();
            plaza = (Plaza) sesion.get(Plaza.class, idplaza);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return plaza;
    }
    
    public List<Plaza> obtenerLista() throws HibernateException{
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Plaza> obtenerListaActivas() throws HibernateException{
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus = 1 "
                    +" order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idplaza){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Plaza set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idplaza)).executeUpdate();
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
    
    public List<Plaza> obtenerListaInactivas() throws HibernateException{
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Plaza> obtenerListaActivasDeCT(int idCt) throws HibernateException{
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus=1 and ctrabajo=" + Integer.toString(idCt)
                    +" order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Plaza> obtenerListaInactivasDeCT(int idCt) throws HibernateException{
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus=0 and ctrabajo=" + Integer.toString(idCt)
                    +" order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Empleado> obtenerEmpleadosDeSucursalSinAsignarEnCT(int idSuc, int idCt) {
        List<Empleado> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Empleado e where e.estatus=1 and e.numempleado not in "+
                    "(select distinct p.empleado from Plaza p where p.estatus=1 and p.ctrabajo=" + Integer.toString(idCt)+") "+
                    "and e.persona.sucursal="+Integer.toString(idSuc)+
                    "order by persona.paterno, persona.materno, persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Plaza> obtenerListaActivasDeEmpleado(int idEmp) throws HibernateException{
        List<Plaza> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus=1 and empleado=" + Integer.toString(idEmp)).list();
        }finally
        {
            sesion.close();
        }
                
        return lista;
    }
    
    public List<Plaza> obtenerListaActivas2(String ffinquin) throws HibernateException{
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus = 1 "
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+ffinquin+"'"
                    + "order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Plaza> obtenerListaActivasDeSuc(String finiquin, String ffinquin, int idsuc) {
        
        Conexion conn = new Conexion();
        Connection conne = null;

        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Integer> idsplazas = new ArrayList<Integer>();
        String sids = "";
        try
        {
            //Pedimos una conexion al pool
            conne = conn.conectar();

            String query = "select plaz_id from plazas p, clientes cl, contratos con, ctrabajo ct "+
                "where cl.clie_id=p.cliente_clie_id and con.id=p.contrato_id "+
                "and ct.ctra_id=p.ctrabajo_ctra_id and "+
                "(p.plaz_estatus = 1 "+
                "and cl.estatus=1 and con.estatus=1 and ct.estatus=1 "+
                "and con.fechafin>='"+finiquin+"' and con.fechaini<='"+ffinquin+"' "+
                "and ((p.sucursal_sucu_id="+Integer.toString(idsuc) +" and ct.surtidoexterno=0) "+
                "or (ct.surtidoexterno=1 and ct.sucalterna_sucu_id="+Integer.toString(idsuc) +"))) "+
                "union "+
                "select plaz_id from plazas p, clientes cl, contratos con, ctrabajo ct "+
                "where cl.clie_id=p.cliente_clie_id and con.id=p.contrato_id "+
                "and ct.ctra_id=p.ctrabajo_ctra_id and "+
                "(p.plaz_estatus = 0 and p.fechabaja>'"+finiquin+"' "+
                "and cl.estatus=1 and con.estatus=1 and ct.estatus=1 "+
                "and con.fechafin>='"+finiquin+"' and con.fechaini<='"+ffinquin+"' "+
                "and ((p.sucursal_sucu_id="+Integer.toString(idsuc)+" and ct.surtidoexterno=0) "+
                "or (ct.surtidoexterno=1 and ct.sucalterna_sucu_id="+Integer.toString(idsuc) +"))) "+
                "order by plaz_id";

            ps = conne.prepareStatement(query);
            
            rs = ps.executeQuery();
            
            while (rs.next())
            {
                //idsplazas.add(new Integer(rs.getInt(1)));
                if(sids.equals(""))
                    sids+=rs.getString(1);
                else
                    sids+=","+rs.getString(1);
            }
        }catch(SQLException e)
        {
            System.out.println("Ocurrió un error en la capa de datos JDBC:"+ e.getMessage());
        }
        finally
        {
            try
            {
                if (conne!= null && !conne.isClosed())
                {
                   conne.close();
                }
            }
            catch(SQLException e)
            {
                 System.out.println("Ocurrió un error al cerrar la conexión JDBC:"+e.getMessage());
            }
        }
        
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where id in ("+sids+")"
                    + "order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();            
            /*lista = sesion.createQuery("from Plaza where (estatus = 1 "
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+finiquin+"'"
                    +" and ((sucursal="+Integer.toString(idsuc)+"and ctrabajo.surtidoexterno=0)"//
                    +" or (ctrabajo.surtidoexterno=1 and "
                    +"ctrabajo.sucalterna="+Integer.toString(idsuc)
                    +"))) union from Plaza where (estatus = 0 and fechabaja>'"+finiquin+"'"
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+finiquin+"'"
                    +" and ((sucursal="+Integer.toString(idsuc)+"and ctrabajo.surtidoexterno=0)"//
                    +" or (ctrabajo.surtidoexterno=1 and "
                    +"ctrabajo.sucalterna="+Integer.toString(idsuc)
                    +"))"
                    +")"
                    + "order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();*/
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean EmpleadoEstaEnPlazaActiva(Plaza plz) {
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus=1 and ctrabajo=" + Integer.toString(plz.getCtrabajo().getId())
                    +" and empleado="+Integer.toString(plz.getEmpleado().getNumempleado())).list();
        }finally
        {
            sesion.close();
        }
        if (lista == null || lista.isEmpty())
            return false;
        else
            return true;
    }

    public List<Plaza> obtenerPlazasVigentesDeEmpleado(int numempleado, Date hoy) {
        List<Plaza> lista = null;
        List<Plaza> filtro = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where estatus = 1"
                    +" and empleado="+Integer.toString(numempleado)
                    +" order by sucursal.id, fechaalta, contrato.contrato, ctrabajo.nombre").list();
            
            filtro = new ArrayList<Plaza>();
            for (int i=0; i < lista.size(); i++){
                Plaza p = lista.get(i);
                if ((p.getContrato().getFechaFin().equals(hoy) || p.getContrato().getFechaFin().after(hoy))
                        && p.getContrato().getEstatus()==1 && p.getCtrabajo().getEstatus()==1
                        && p.getCliente().getEstatus()==1)
                    filtro.add(p);
            }
        }finally
        {
            sesion.close();
        }
        
        return filtro;
    }

    public List<Plaza> obtenerPlazasNoVigentesDeEmpleado(int numempleado, Date hoy) {
        List<Plaza> lista = null;
        List<Plaza> filtro = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where "
                    +" empleado="+Integer.toString(numempleado)
                    +" order by sucursal.id, fechaalta, contrato.contrato, ctrabajo.nombre").list();
            
            filtro = new ArrayList<Plaza>();
            for (int i=0; i < lista.size(); i++){
                Plaza p = lista.get(i);
                if (p.getContrato().getFechaFin().before(hoy))
                    filtro.add(p);
            }
        }finally
        {
            sesion.close();
        }
        
        return filtro;
    }

    public Plaza obtenerUltimaPlazaDeEmpleado(int idEmp) {
        Plaza pza = null;
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where empleado=" + Integer.toString(idEmp)+
                    " order by fechaalta desc limit 1").list();
        }finally
        {
            sesion.close();
        }
        
        if (lista!=null && !lista.isEmpty())
            pza = lista.get(0);
        
        return pza;
    }

    public List<Plaza> obtenerListaActivasDeSucAguinaldos(String finiquin, String ffinquin, int idsuc) {
        Conexion conn = new Conexion();
        Connection conne = null;

        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Integer> idsplazas = new ArrayList<Integer>();
        String sids = "";
        try
        {
            //Pedimos una conexion al pool
            conne = conn.conectar();

            String query = "select plaz_id from plazas p, clientes cl, contratos con, ctrabajo ct "+
                "where cl.clie_id=p.cliente_clie_id and con.id=p.contrato_id "+
                "and ct.ctra_id=p.ctrabajo_ctra_id and "+
                "(p.plaz_estatus = 1 "+
                "and cl.estatus=1 and con.estatus=1 and ct.estatus=1 "+
                "and con.fechafin>='"+finiquin+"' and con.fechaini<='"+ffinquin+"' "+
                "and ((p.sucursal_sucu_id="+Integer.toString(idsuc) +" and ct.surtidoexterno=0) "+
                "or (ct.surtidoexterno=1 and ct.sucalterna_sucu_id="+Integer.toString(idsuc) +"))) "+
                "union "+
                "select plaz_id from plazas p, clientes cl, contratos con, ctrabajo ct "+
                "where cl.clie_id=p.cliente_clie_id and con.id=p.contrato_id "+
                "and ct.ctra_id=p.ctrabajo_ctra_id and "+
                "(p.plaz_estatus = 0 and p.fechabaja>'"+finiquin+"' "+
                "and cl.estatus=1 and con.estatus=1 and ct.estatus=1 "+
                "and con.fechafin>='"+finiquin+"' and con.fechaini<='"+ffinquin+"' "+
                "and ((p.sucursal_sucu_id="+Integer.toString(idsuc)+" and ct.surtidoexterno=0) "+
                "or (ct.surtidoexterno=1 and ct.sucalterna_sucu_id="+Integer.toString(idsuc) +"))) "+
                "order by plaz_id";

            ps = conne.prepareStatement(query);
            
            rs = ps.executeQuery();
            
            while (rs.next())
            {
                //idsplazas.add(new Integer(rs.getInt(1)));
                if(sids.equals(""))
                    sids+=rs.getString(1);
                else
                    sids+=","+rs.getString(1);
            }
        }catch(SQLException e)
        {
            System.out.println("Ocurrió un error en la capa de datos JDBC:"+ e.getMessage());
        }
        finally
        {
            try
            {
                if (conne!= null && !conne.isClosed())
                {
                   conne.close();
                }
            }
            catch(SQLException e)
            {
                 System.out.println("Ocurrió un error al cerrar la conexión JDBC:"+e.getMessage());
            }
        }
        
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where id in ("+sids+")"
                    + "order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();            
            /*lista = sesion.createQuery("from Plaza where (estatus = 1 "
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+finiquin+"'"
                    +" and ((sucursal="+Integer.toString(idsuc)+"and ctrabajo.surtidoexterno=0)"//
                    +" or (ctrabajo.surtidoexterno=1 and "
                    +"ctrabajo.sucalterna="+Integer.toString(idsuc)
                    +"))) union from Plaza where (estatus = 0 and fechabaja>'"+finiquin+"'"
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+finiquin+"'"
                    +" and ((sucursal="+Integer.toString(idsuc)+"and ctrabajo.surtidoexterno=0)"//
                    +" or (ctrabajo.surtidoexterno=1 and "
                    +"ctrabajo.sucalterna="+Integer.toString(idsuc)
                    +"))"
                    +")"
                    + "order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();*/
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Plaza obtenerUltimaPlazaDeEmpleadoEnElAnioEnSucursal(int idEmp, String fini, int idSuc) {
        Plaza plaza = null;
        List<Plaza> lista = new ArrayList<Plaza>();
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where empleado="+idEmp
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+fini+"' and sucursal="+idSuc
                    +" order by estatus desc, fechaalta desc, fechabaja asc").list();
            
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        if (!lista.isEmpty())
            plaza = lista.get(0);
        return plaza;
    }

    public List<Plaza> obtenerPlazasDeEmpleadoEnElAnioEnSucursal(int idEmp, String finiquin,int idSuc) {
        List<Plaza> plazas = new ArrayList<Plaza>();
        try
        {
            iniciaOperacion();
            plazas = sesion.createQuery("from Plaza where empleado="+idEmp
                    +" and cliente.estatus=1 and contrato.estatus=1 and ctrabajo.estatus=1"
                    +" and contrato.fechaFin>='"+finiquin+"' and sucursal="+idSuc
                    +" and (fechabaja is null or fechabaja>='"+finiquin+"')"
                    +" order by fechaalta, fechabaja desc").list();
            
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return plazas;
    }
}
