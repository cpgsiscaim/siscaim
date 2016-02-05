/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Aguinaldo;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class AguinaldoDao {
    private Session sesion;
    private Transaction tx;

    public AguinaldoDao(){
        
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
    
    public void guardar(Aguinaldo agui){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(agui); 
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
    
    public void actualizar(Aguinaldo agui){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(agui); 
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
    
    public void eliminar(Aguinaldo agui){
        try
        {
            iniciaOperacion();
            sesion.delete(agui);
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
    
    public Aguinaldo obtener(int idagui) throws HibernateException{
        Aguinaldo agui = null;
        try
        {
            iniciaOperacion();
            agui = (Aguinaldo) sesion.get(Aguinaldo.class, idagui);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return agui;
    }
    
    public List<Aguinaldo> obtenerLista() throws HibernateException{
        List<Aguinaldo> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Aguinaldo").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Aguinaldo obtenerAguinaldoDeEmpleadoEnElAnio(int numempleado, int anio) {
        Aguinaldo agui = null;
        try
        {
            iniciaOperacion();
            agui = (Aguinaldo) sesion.createQuery("from Aguinaldo where empleado="+Integer.toString(numempleado)+
                    " and anio="+Integer.toString(anio)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return agui;
    }

    public void actualizaFechaPagoDeAguinaldo(int idagui, int estatus) {
        String fechaap = "null";
        if (estatus==2)
            fechaap = "now()";
        
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Aguinaldo set fechapago="+fechaap+
                    " where id = " + Integer.toString(idagui)).executeUpdate();
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
