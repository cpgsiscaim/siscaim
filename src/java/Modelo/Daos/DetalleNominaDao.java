/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.DetalleNomina;
import Modelo.Entidades.Nomina;
import Modelo.Entidades.Plaza;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class DetalleNominaDao {
    private Session sesion;
    private Transaction tx;

    public DetalleNominaDao(){
        
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
    
    public void guardar(DetalleNomina dnom){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(dnom); 
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
    
    public void actualizar(DetalleNomina dnom){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(dnom); 
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
    
    public void eliminar(DetalleNomina dnom){
        try
        {
            iniciaOperacion();
            sesion.delete(dnom);
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
    
    public DetalleNomina obtener(int iddnom) throws HibernateException{
        DetalleNomina dnom = null;
        try
        {
            iniciaOperacion();
            dnom = (DetalleNomina) sesion.get(DetalleNomina.class, iddnom);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return dnom;
    }
    
    public List<DetalleNomina> obtenerNoAplicadosDeNomina(int idnom) throws HibernateException{
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where estatus=0 and nomina="+Integer.toString(idnom)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<DetalleNomina> obtenerAplicadosDeNomina(int idnom) throws HibernateException{
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where estatus=1 and nomina="+Integer.toString(idnom)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public float obtenerTotalDeNomina(int idnom) {
        float total = 0;

        try
        {
            iniciaOperacion();
            Double totpercep = (Double)sesion.createQuery("select sum(monto) from DetalleNomina where estatus > 0 "
                    + "and nomina="+Integer.toString(idnom)+ " and movimiento.PeroDed = 1").uniqueResult();
            Double totdeduc = (Double)sesion.createQuery("select sum(monto) from DetalleNomina where estatus > 0 "
                    + "and nomina="+Integer.toString(idnom)+ " and movimiento.PeroDed = 2").uniqueResult();
            if (totpercep==null)
                totpercep = new Double(0);
            if (totdeduc==null)
                totdeduc = new Double(0);
            total = totpercep.floatValue()-totdeduc.floatValue();
        }finally
        {
            sesion.close();
        }
        
        return total;
    }

    public float obtenerTotalPagadoDeNomina(int idnom) {
        float total = 0;

        try
        {
            iniciaOperacion();
            Double totpercep = (Double)sesion.createQuery("select sum(monto) from DetalleNomina where estatus = 2 "
                    + "and nomina="+Integer.toString(idnom)+ " and movimiento.PeroDed = 1").uniqueResult();
            Double totdeduc = (Double)sesion.createQuery("select sum(monto) from DetalleNomina where estatus = 2 "
                    + "and nomina="+Integer.toString(idnom)+ " and movimiento.PeroDed = 2").uniqueResult();
            if (totpercep==null)
                totpercep = new Double(0);
            if (totdeduc==null)
                totdeduc = new Double(0);
            total = totpercep.floatValue()-totdeduc.floatValue();
        }finally
        {
            sesion.close();
        }
        
        return total;
    }

    public List<Plaza> obtenerPlazasDeNomina(int idnom) {
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where id in (select distinct plaza from DetalleNomina "
                    + "where nomina="+Integer.toString(idnom)+" and estatus > 0) order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public float obtenerTotalPercepcionesDePlazaEnNomina(int idplz, int idnom) {
        float total = 0;

        try
        {
            iniciaOperacion();
            Double totpercep = (Double)sesion.createQuery("select sum(monto) from DetalleNomina where estatus > 0 "
                    + "and nomina="+Integer.toString(idnom)+ " and movimiento.PeroDed = 1 "
                    + "and plaza="+Integer.toString(idplz)).uniqueResult();
            if (totpercep==null)
                totpercep = new Double(0);
            total = totpercep.floatValue();
        }finally
        {
            sesion.close();
        }
        
        return total;
    }
    
    public float obtenerTotalDeduccionesDePlazaEnNomina(int idplz, int idnom) {
        float total = 0;

        try
        {
            iniciaOperacion();
            Double totdeduc = (Double)sesion.createQuery("select sum(monto) from DetalleNomina where estatus > 0 "
                    + "and nomina="+Integer.toString(idnom)+ " and movimiento.PeroDed = 2 "
                    + "and plaza="+Integer.toString(idplz)).uniqueResult();
            if (totdeduc==null)
                totdeduc = new Double(0);
            total = totdeduc.floatValue();
        }finally
        {
            sesion.close();
        }
        
        return total;
    }

    public int obtenerEstatusDePlazaEnNomina(int idplz, int idnom) {
        int estatus = 0;
        
        try
        {
            iniciaOperacion();
            Integer estat = (Integer)sesion.createQuery("select distinct estatus from DetalleNomina where "
                    + "nomina="+Integer.toString(idnom)
                    + " and plaza="+Integer.toString(idplz)).uniqueResult();
            if (estat==null)
                estat = new Integer(0);
            estatus = estat.intValue();
        }finally
        {
            sesion.close();
        }
        
        return estatus;
    }

    public void eliminaDetalleDeNomina(int idnom) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("delete DetalleNomina where nomina = " + Integer.toString(idnom)+
                    " and estatus in (0,1)").executeUpdate();
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

    public List<Plaza> obtenerPlazasPagadasDeNomina(int idnom) {
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where id in (select distinct plaza from DetalleNomina "
                    + "where nomina="+Integer.toString(idnom)+" and estatus=2) order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void cambiaEstatusDePlazaEnNomina(int idplz, int idnom, int estatus) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update DetalleNomina set estatus="+Integer.toString(estatus) +
                    " where nomina = " + Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)).executeUpdate();
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

    public void eliminaDetalleDePlazaEnNomina(int idnom, int idplz) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("delete from DetalleNomina where nomina = " + Integer.toString(idnom)+
                    " and plaza = "+Integer.toString(idplz)).executeUpdate();
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

    public List<Plaza> obtenerPlazasNoPagadasDeNomina(int idnom) {
        List<Plaza> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where id in (select distinct plaza from DetalleNomina "
                    + "where nomina="+Integer.toString(idnom)+" and estatus=1) order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<DetalleNomina> obtenerDetallesDeNomina(int idnom) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " order by plaza.empleado.persona.paterno, plaza.empleado.persona.materno, "+
                    "plaza.empleado.persona.nombre, cotiza, movimiento, estatus").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<DetalleNomina> obtenerDetallesDeNominaCotizaDePlaza(int idnom, int idplz) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+ " and cotiza=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<DetalleNomina> obtenerDetallesDeNominaNoCotizaDePlaza(int idnom, int idplz) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+ " and cotiza=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void cambiaEstatusPagoAPlazaEnNomina(int idnom, int idplz, int cotiza, int estatus) {
        String fechaap = "null";
        if (estatus==2)
            fechaap = "now()";
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update DetalleNomina set estatus="+Integer.toString(estatus) +
                    ", fechaaplicacion="+fechaap+
                    " where nomina = " + Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+
                    " and cotiza="+Integer.toString(cotiza)).executeUpdate();
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

    public List<DetalleNomina> obtenerDetallesDeNominaConEstatusYCotiza(int idnom, int pago, int bcotiza) {
        List<DetalleNomina> lista = null;
        String scotiza = "0,1";
        if (bcotiza>-1)
            scotiza = Integer.toString(bcotiza);
        String spago = "1";
        if (pago==1)
            spago="2";
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " and estatus="+spago+" and cotiza in ("+scotiza+")"+
                    " order by plaza.empleado.persona.paterno, plaza.empleado.persona.materno, "+
                    "plaza.empleado.persona.nombre, cotiza, movimiento, estatus").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public DetalleNomina obtenerDetalleNominaAguinaldoPagadoDeEmpleado(int idnom, int numempleado) {
        DetalleNomina det = null;
        try
        {
            iniciaOperacion();
            det = (DetalleNomina)sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " and plaza.empleado="+Integer.toString(numempleado)+
                    " and estatus = 2").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return det;
    }

    public List<Plaza> obtenerPlazasCotizaDeNomina(int idnom) {
        List<Plaza> lista = null;
        //
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Plaza where id in (select distinct plaza from DetalleNomina "
                    + "where nomina="+Integer.toString(idnom)+" and estatus > 0 and cotiza=1) order by empleado.persona.paterno, "
                    + "empleado.persona.materno, empleado.persona.nombre").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
public List<DetalleNomina> obtenerPercepcionesDeNominaCotizaDePlaza(int idnom, int idplz) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+ " and cotiza=1 and movimiento.PeroDed = 1 and estatus>0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

public List<DetalleNomina> obtenerDeduccionesDeNominaCotizaDePlaza(int idnom, int idplz) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where nomina="+Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+ " and cotiza=1 and movimiento.PeroDed = 2 and estatus>0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void eliminarDetalleDePerydedDePlazaEnNomina(int idperyded, int idplz, int idnom) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("delete from DetalleNomina"+                    
                    " where nomina = " + Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+
                    " and movimiento="+Integer.toString(idperyded)).executeUpdate();
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

    public void activarDetalleDePerydedDePlazaEnNomina(int idperyded, int idplz, int idnom) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update DetalleNomina set estatus=1"+                    
                    " where nomina = " + Integer.toString(idnom)+
                    " and plaza="+Integer.toString(idplz)+
                    " and movimiento="+Integer.toString(idperyded)).executeUpdate();
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

    public List<DetalleNomina> obtenerDetalleDeEmpleado(int numempleado) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where estatus in (1,2)"+
                    " and plaza.empleado.numempleado="+Integer.toString(numempleado)+
                    " and nomina.estatus in (1,2) order by nomina.anio desc, nomina.quincena.id desc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Nomina> obtenerNominasDeEmpleado(int numempleado) {
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where id in (select distinct nomina.id from DetalleNomina where estatus in (1,2)"+
                    " and plaza.empleado.numempleado="+Integer.toString(numempleado)+
                    " and nomina.estatus in (1,2)) order by sucursal, anio desc, quincena.id desc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<DetalleNomina> obtenerPercepcionesDeEmpleadoEnNomina(int numempleado, int idnom) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where estatus in (1,2)"+
                    " and plaza.empleado.numempleado="+Integer.toString(numempleado)+
                    " and nomina.id="+Integer.toString(idnom)+
                    " and movimiento.PeroDed=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<DetalleNomina> obtenerDeduccionesDeEmpleadoEnNomina(int numempleado, int idnom) {
        List<DetalleNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from DetalleNomina where estatus in (1,2)"+
                    " and plaza.empleado.numempleado="+Integer.toString(numempleado)+
                    " and nomina.id="+Integer.toString(idnom)+
                    " and movimiento.PeroDed=2").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
