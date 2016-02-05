/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Empleado;
import Modelo.Entidades.MovimientoExtraordinario;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class MovimientoExtraordinarioDao {
    private Session sesion;
    private Transaction tx;

    public MovimientoExtraordinarioDao(){
        
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
    
    public void guardar(MovimientoExtraordinario movex){
        try 
        { 
            iniciaOperacion();
            sesion.save(movex);
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
    
    public void actualizar(MovimientoExtraordinario movex){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(movex); 
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
    
    public void eliminar(MovimientoExtraordinario movex){
        try
        {
            iniciaOperacion();
            sesion.delete(movex);
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
    
    public MovimientoExtraordinario obtener(int idmovex) throws HibernateException{
        MovimientoExtraordinario movex = null;
        try
        {
            iniciaOperacion();
            movex = (MovimientoExtraordinario) sesion.get(MovimientoExtraordinario.class, idmovex);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return movex;
    }
    
    public List<MovimientoExtraordinario> obtenerLista() throws HibernateException{
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<MovimientoExtraordinario> obtenerListaActivos() throws HibernateException{
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public void actualizarEstatus(int estatus, int idmovex){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update MovimientoExtraordinario set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idmovex)).executeUpdate();
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
    
    public List<MovimientoExtraordinario> obtenerListaInactivos() throws HibernateException{
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<MovimientoExtraordinario> obtenerListaActivosDePlazayQuincena(int idPlaza, int idQuin, int anio) throws HibernateException{
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=1 and fijo=0 and plaza=" +
                    Integer.toString(idPlaza)+" and quincena=" + Integer.toString(idQuin) +
                    " and anio=" + Integer.toString(anio)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<MovimientoExtraordinario> obtenerListaInactivosDePlazayQuincena(int idPlaza, int idQuin, int anio) throws HibernateException{
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=0 and plaza=" + Integer.toString(idPlaza)+" and quincena=" + Integer.toString(idQuin) + " and anio=" + Integer.toString(anio)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<MovimientoExtraordinario> obtenerListaActivosDePlaza(int idPlaza) throws HibernateException{
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=1 and plaza=" + Integer.toString(idPlaza)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<MovimientoExtraordinario> obtenerActivosDePlazaQuincenaAnioTiponom(int idplz, int idquin, int anio, int tiponom) {
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=1 and plaza=" + Integer.toString(idplz)+
                    " and quincena="+Integer.toString(idquin)+ " and anio="+Integer.toString(anio)+
                    " and tiponomina="+Integer.toString(tiponom)+ " and fijo=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void eliminarMovsDePlazaAnioQuincena(int idplz, int idquin, int aniosig) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("delete from MovimientoExtraordinario where plaza = " + Integer.toString(idplz)+
                    " and quincena = " + Integer.toString(idquin) + " and anio = " + Integer.toString(aniosig)).executeUpdate();
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

    public int obtenerTotalFaltasEmpleadoEnElAnio(int numempleado, int anio) {
        Double faltas = new Double(0);
        try
        {
            iniciaOperacion();
            faltas = (Double) sesion.createQuery("select sum(importe) from MovimientoExtraordinario where plaza.empleado = " + Integer.toString(numempleado)+
                    " and estatus=1 and tipocambio=2 and perded=16 and anio = " + Integer.toString(anio)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        if (faltas!=null)
            return faltas.intValue();
        else
            return 0;
    }
    
    public int obtenerFaltasDePlazaEnElAnio(int idplz, int anio) {
        Double faltas = new Double(0);
        try
        {
            iniciaOperacion();
            faltas = (Double) sesion.createQuery("select sum(importe) from MovimientoExtraordinario where plaza = " + Integer.toString(idplz)+
                    " and estatus=1 and tipocambio=2 and perded=16 and anio = " + Integer.toString(anio)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        if (faltas!=null)
            return faltas.intValue();
        else
            return 0;
    }

    public List<MovimientoExtraordinario> obtenerFijosDePlazaTiponom(int idplz, int tiponom) {
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=1 and plaza=" + Integer.toString(idplz)+
                    " and tiponomina="+Integer.toString(tiponom)+" and fijo=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void desactivaPrestacionesImssDePlaza(int idplz) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update MovimientoExtraordinario set estatus=0 where plaza = " +
                    Integer.toString(idplz)+" and prestacionimss = 1 and estatus=1").executeUpdate();
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

    public void eliminarMovimientoDePerydedDePlazaEnQuincenaYAnio(int idperyded, int idplz, int idquin, int anio) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("delete from MovimientoExtraordinario where plaza = " +
                    Integer.toString(idplz)+" and perded = "+Integer.toString(idperyded)+
                    " and quincena="+Integer.toString(idquin)+" and anio="+Integer.toString(anio)).executeUpdate();
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

    public void activarMovimientoDePerydedDePlazaEnQuincenaYAnio(int idperyded, int idplz, int idquin, int anio) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update MovimientoExtraordinario set estatus=1 where plaza = " +
                    Integer.toString(idplz)+" and perded = "+Integer.toString(idperyded)+" and estatus=1"+
                    " and quincena="+Integer.toString(idquin)+" and anio="+Integer.toString(anio)).executeUpdate();
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

    public List<MovimientoExtraordinario> obtenerListaActivosFijosDePlaza(int idplz) {
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=1 and fijo=1 and plaza=" +
                    Integer.toString(idplz)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<MovimientoExtraordinario> obtenerListaInactivosFijosDePlaza(int idplz) {
        List<MovimientoExtraordinario> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from MovimientoExtraordinario where estatus=0 and fijo=1 and plaza=" +
                    Integer.toString(idplz)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

}
