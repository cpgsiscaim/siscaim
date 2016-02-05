/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos.Catalogos;

import Configuracion.HibernateUtil;
import Modelo.Daos.UtilDao;
import Modelo.Entidades.Catalogos.Quincena;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class QuincenaDao {
    private Session sesion;
    private Transaction tx;

    public QuincenaDao(){
        
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
    
    public void guardar(Quincena quin){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(quin); 
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
    
    public void actualizar(Quincena quin){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(quin); 
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
    
    public void eliminar(Quincena quin){
        try
        {
            iniciaOperacion();
            sesion.delete(quin);
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
    
    public Quincena obtener(int idquin) throws HibernateException{
        Quincena quin = null;
        try
        {
            iniciaOperacion();
            quin = (Quincena) sesion.get(Quincena.class, idquin);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return quin;
    }
    
    public List<Quincena> obtenerLista() throws HibernateException{
        List<Quincena> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Quincena").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Quincena obtenerQuincenaActual() {
        Quincena quin = new Quincena();
        UtilDao uDao = new UtilDao();
        Date hoy = uDao.hoy();
        Calendar choy = Calendar.getInstance();
        choy.setTime(hoy);
        int mes = choy.get(Calendar.MONTH)+1;
        int dia = choy.get(Calendar.DAY_OF_MONTH);
        if (dia==31)
            dia = 30;
        try
        {
            iniciaOperacion();
            quin = (Quincena) sesion.createQuery("from Quincena where nummes="+Integer.toString(mes) + " and inicio<=" + Integer.toString(dia) + " and fin>=" + Integer.toString(dia)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return quin;
    }

    public Quincena obtenerQuincenaActiva() {
        Quincena quin = null;
        
        try
        {
            iniciaOperacion();
            quin = (Quincena)sesion.createQuery("from Quincena where estatus=1").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return quin;
    }

    public List<Quincena> obtenerQuincenasHastaActiva() {
        List<Quincena> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Quincena where id <= (select id from "
                    + "Quincena where estatus=1)").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void actualizaEstatusActiva(int idquin, int estatus) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Quincena set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idquin)).executeUpdate();
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

}
