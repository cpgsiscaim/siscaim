/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Vacaciones;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class VacacionesDao {
    private Session sesion;
    private Transaction tx;
    
    public VacacionesDao(){}
    
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
    
    public void guardar(Vacaciones vac){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(vac); 
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
    
    public void actualizar(Vacaciones vac){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(vac); 
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
    
    public void eliminar(Vacaciones vac){
        try
        {
            iniciaOperacion();
            sesion.delete(vac);
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
    
    public Vacaciones obtener(int idvac) throws HibernateException{
        Vacaciones vac = null;
        try
        {
            iniciaOperacion();
            vac = (Vacaciones) sesion.get(Vacaciones.class, idvac);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return vac;
    }
    
    public Vacaciones obtenerVacacionesDeEmpleadoYAntiguedad(int numempleado, int anti) throws HibernateException{
        Vacaciones vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = (Vacaciones) sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and antiguedad="+Integer.toString(anti)+" and estatus in (1,2,4,5)").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public Vacaciones obtenerVacacionesDeEmpleadoYNomina(int numempleado, int idnom) {
        Vacaciones vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = (Vacaciones) sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and nomina="+Integer.toString(idnom)+" and estatus=1").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public List<Vacaciones> obtenerVacacionesPagadasDeEmpleado(int numempleado) {
        List<Vacaciones> vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and estatus=2").list();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public List<Vacaciones> obtenerVacacionesDeEmpleadoNoPagadas(int numempleado) {
        List<Vacaciones> vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public List<Vacaciones> obtenerVacacionesDeEmpleadoCanceladas(int numempleado) {
        List<Vacaciones> vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public Vacaciones obtenerVacacionesDeEmpleadoYNominaPagadas(int numempleado, int idnom) {
        Vacaciones vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = (Vacaciones) sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and nomina="+Integer.toString(idnom)+" and estatus=2").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public Vacaciones obtenerVacacionesDeEmpleadoYAntiguedadGozadas(int numempleado, int anti) {
        Vacaciones vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = (Vacaciones) sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and antiguedad="+Integer.toString(anti)+" and estatus=4").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public List<Vacaciones> obtenerVacacionesDeEmpleado(int numempleado) {
        List<Vacaciones> vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and estatus<>0 and estatus<>3").list();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public List<Vacaciones> obtenerVacacionesPagadasOGozadasDeEmpleado(int numempleado) {
        List<Vacaciones> vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and estatus in (2,4)").list();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public Vacaciones obtenerVacacionesDeEmpleadoYNominaPagadasOGozadas(int numempleado, int idnom) {
        Vacaciones vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = (Vacaciones) sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and nomina="+Integer.toString(idnom)+" and (estatus=1 or estatus=4)").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }

    public Vacaciones obtenerVacacionesDeEmpleadoYAntiguedadPagadasPorPagarGozadas(int numempleado, int anti) {
        Vacaciones vacas = null;
        
        try
        {
            iniciaOperacion();
            vacas = (Vacaciones) sesion.createQuery("from Vacaciones where empleado = "+Integer.toString(numempleado)+
                    " and antiguedad="+Integer.toString(anti)+" and estatus in (1,2,4,5)").uniqueResult();
        }finally
        {
            sesion.close();
        }
        
        return vacas;
    }
    
}
