/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Nomina;
import Modelo.Entidades.Plaza;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class NominaDao {
    private Session sesion;
    private Transaction tx;

    public NominaDao(){
        
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
    
    public void guardar(Nomina nom){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(nom); 
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
    
    public void actualizar(Nomina nom){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(nom); 
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
    
    public void eliminar(Nomina nom){
        try
        {
            iniciaOperacion();
            sesion.delete(nom);
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
    
    public Nomina obtener(int idnom) throws HibernateException{
        Nomina nom = null;
        try
        {
            iniciaOperacion();
            nom = (Nomina) sesion.get(Nomina.class, idnom);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return nom;
    }
    
    public List<Nomina> obtenerLista() throws HibernateException{
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Nomina> obtenerListaActivas() throws HibernateException{
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus in (1,2)").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idnom){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Nomina set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idnom)).executeUpdate();
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
    
    public List<Nomina> obtenerListaInactivas() throws HibernateException{
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Nomina> obtenerAbiertasDeSucursal(int idsuc) throws HibernateException{
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus = 1 and sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Nomina> obtenerCerradasDeSucursal(int idsuc) throws HibernateException{
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus = 2 and sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    
    public List<Nomina> obtenerInactivasDeSucursal(int idsuc) throws HibernateException{
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus = 0 and sucursal="+Integer.toString(idsuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Nomina> obtenerListaActivasNormalesDeAnio(int anio) {
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus > 0 and anio="+Integer.toString(anio)+
                    " and tiponomina.id=1 order by anio desc, quincena desc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public int obtenerAnioInicial() {
        int anio = 0;
        try
        {
            iniciaOperacion();
            Integer ax = (Integer)sesion.createQuery("select min(anio) from Nomina where estatus > 0").uniqueResult();
            if (ax!=null)
                anio = ax.intValue();
            else
                anio = 0;
        }finally
        {
            sesion.close();
        }
        return anio;
    }


    public Nomina obtenerNominaNormalDeQuincenaYSucursal(int idquin, int anioant, int idsuc) {
        Nomina nom = null;

        try
        {
            iniciaOperacion();
            nom = (Nomina)sesion.createQuery("from Nomina where quincena="+Integer.toString(idquin)+
                    " and anio="+Integer.toString(anioant)+ " and tiponomina=1 and estatus <> 0"+
                    " and sucursal="+Integer.toString(idsuc)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return nom;
    }

    public void actualizaFechaCierre(int idnom) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Nomina set fechacierre = now() where id = " + Integer.toString(idnom)).executeUpdate();
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

    public List<Nomina> obtenerListaActivasNormalesDeQuinYAnio(int anioact, int idquin) {
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus > 0 and anio="+Integer.toString(anioact)+
                    " and quincena="+Integer.toString(idquin)+
                    " and tiponomina.id=1 order by anio desc, quincena desc").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean existeNominaDeSucursalEnQuinYAnio(int anioact, int idquin, int idsuc) {
        boolean existe = false;
        try
        {
            iniciaOperacion();
            Long ax = (Long)sesion.createQuery("select count(*) from Nomina where estatus > 0"+
                    " and anio="+Integer.toString(anioact)+" and quincena="+Integer.toString(idquin)+
                    " and sucursal="+Integer.toString(idsuc)).uniqueResult();
            if (ax.intValue()>0)
                existe = true;
        }finally
        {
            sesion.close();
        }
        return existe;
    }

    public List<Integer> obtenerAniosHistoricos() {
        List<Integer> anios = null;
        try
        {
            iniciaOperacion();
            anios = sesion.createQuery("select distinct anio from Nomina where estatus > 0 order by anio desc").list();
        }finally
        {
            sesion.close();
        }
        
        return anios;
    }

    public List<Quincena> obtenerQuincenasHistoricasDeAnio(int anio) {
        List<Quincena> quinhist = null;
        
        try
        {
            iniciaOperacion();
            quinhist = sesion.createQuery("select distinct nom.quincena from Nomina nom where nom.estatus > 0 and nom.anio="+Integer.toString(anio)+
                    " and nom.tiponomina.id=1 order by nom.quincena.id desc").list();
        }finally
        {
            sesion.close();
        }
        
        return quinhist;
    }

    public List<Nomina> obtenerListaActivasAguinaldoDeAnio(int anioact) {
        List<Nomina> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Nomina where estatus > 0 and anio="+Integer.toString(anioact)+
                    " and tiponomina.id=4 order by sucursal").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public boolean existeNominaAguinaldoDeSucursalEnAnio(int anioact, int idsuc) {
        boolean existe = false;
        try
        {
            iniciaOperacion();
            Long ax = (Long)sesion.createQuery("select count(*) from Nomina where estatus > 0"+
                    " and anio="+Integer.toString(anioact)+" and tiponomina.id=4"+
                    " and sucursal="+Integer.toString(idsuc)).uniqueResult();
            if (ax.intValue()>0)
                existe = true;
        }finally
        {
            sesion.close();
        }
        return existe;
    }

    public List<Integer> obtenerAniosHistoricosAguinaldos() {
        List<Integer> anios = null;
        try
        {
            iniciaOperacion();
            anios = sesion.createQuery("select distinct anio from Nomina where estatus > 0 and tiponomina = 4 order by anio desc").list();
        }finally
        {
            sesion.close();
        }
        
        return anios;
    }

    public Nomina obtenerNominaAguinaldoDeSucursalYAnio(int idsuc, int anio) {
        Nomina nom = null;

        try
        {
            iniciaOperacion();
            nom = (Nomina)sesion.createQuery("from Nomina where anio="+Integer.toString(anio)+
                    " and tiponomina=4 and estatus <> 0"+
                    " and sucursal="+Integer.toString(idsuc)).uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return nom;
    }

}
