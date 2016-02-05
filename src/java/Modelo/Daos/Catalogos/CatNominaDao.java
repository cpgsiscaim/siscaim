/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

/**
 *
 * @author roman
 */
import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.PerPagos;
import Modelo.Entidades.Catalogos.Puestos;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.TipoIncidencia;
import Modelo.Entidades.Catalogos.TipoNomina;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class CatNominaDao {
    private Session sesion;
    private Transaction tx;
    
    public CatNominaDao(){
        
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
    //obtener lista de edo. civil
    public List<PerPagos> obtenerListaPerPagos() throws HibernateException{
        List<PerPagos> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PerPagos where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
    
    public List<Puestos> obtenerListaPuestos() throws HibernateException{
        List<Puestos> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Puestos where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<PeryDed> obtenerListaPeryDed() throws HibernateException{
        List<PeryDed> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PeryDed where estatus=1 order by PeroDed").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<TipoIncidencia> obtenerListaTipoIncidencia() throws HibernateException{
        List<TipoIncidencia> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoIncidencia where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
     public List<TipoNomina> obtenerListaTipoNomina() throws HibernateException{
        List<TipoNomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from TipoNomina where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
     
     public PerPagos obtenerPerPago(int numPerPagos) throws HibernateException{
        PerPagos pago = null;
        try
        {
            iniciaOperacion();
            pago = (PerPagos) sesion.get(PerPagos.class, numPerPagos);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return pago;
    }
     
    public void guardarPerPago(PerPagos emp){
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
    public void actualizarPerPago(PerPagos emp){
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
    public void actualizarEstatusPerPago(int estatus, int idemp){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update PerPagos set estatus = " + Integer.toString(estatus) +
                    " where idPerPagos = " + Integer.toString(idemp)).executeUpdate();
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
    // ----PUESTOS--- 
    public void guardarPuesto(Puestos emp){
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
    
    public Puestos obtenerPuesto(int numPerPagos) throws HibernateException{
        Puestos pago = null;
        try
        {
            iniciaOperacion();
            pago = (Puestos) sesion.get(Puestos.class, numPerPagos);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return pago;
    }
    public void actualizarPuesto(Puestos emp){
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
    public void actualizarEstatusPuesto(int estatus, int idemp){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Puestos set estatus = " + Integer.toString(estatus) +
                    " where idPuestos = " + Integer.toString(idemp)).executeUpdate();
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
    // ----TIPO DE NOMINA--- 
    public void guardarTnomina(TipoNomina emp){
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
    public TipoNomina obtenerTnomina(int idtipon) throws HibernateException{
        TipoNomina tipon = null;
        try
        {
            iniciaOperacion();
            tipon = (TipoNomina) sesion.get(TipoNomina.class, idtipon);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tipon;
    }
    
    public void actualizarTnomina(TipoNomina tipon){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(tipon); 
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
    public void actualizarEstatusTnomina(int estatus, int idtipon){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update TipoNomina set estatus = " + Integer.toString(estatus) +
                    " where IdTnomina = " + Integer.toString(idtipon)).executeUpdate();
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
    // ----PERCEPCIONES Y DEDUCCIONES--- 
    public void guardarPeryDed(PeryDed pyd){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(pyd); 
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
    public PeryDed obtenerPeryDed(int idperyded) throws HibernateException{
        PeryDed pyd = null;
        try
        {
            iniciaOperacion();
            pyd = (PeryDed) sesion.get(PeryDed.class, idperyded);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return pyd;
    }
    
    public void actualizarPeryDed(PeryDed pyd){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(pyd); 
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
    public void actualizarEstatusPeryDed(int estatus, int idpyd){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update PeryDed set estatus = " + Integer.toString(estatus) +
                    " where idPeryded = " + Integer.toString(idpyd)).executeUpdate();
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
    // ----tipo incidenias--- 
    public void guardarTincidencia(TipoIncidencia tinc){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(tinc); 
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
    public TipoIncidencia obtenerTincidencia(int idtinc) throws HibernateException{
        TipoIncidencia tinc = null;
        try
        {
            iniciaOperacion();
            tinc = (TipoIncidencia) sesion.get(TipoIncidencia.class, idtinc);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return tinc;
    }
    public void actualizarTincidencia(TipoIncidencia tinc){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(tinc); 
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
    public void actualizarEstatusTincidenia(int estatus, int idtinc){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update TipoIncidencia set estatus = " + Integer.toString(estatus) +
                    " where idTipincidencia = " + Integer.toString(idtinc)).executeUpdate();
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

    public List<PeryDed> obtenerListaDed() {
        List<PeryDed> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from PeryDed where estatus=1 and PeroDed=2").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
