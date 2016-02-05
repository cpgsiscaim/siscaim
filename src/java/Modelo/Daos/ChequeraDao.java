package Modelo.Daos;

import Configuracion.HibernateUtil;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import Modelo.Entidades.Chequera;

public class ChequeraDao {
  private Session sesion;
  private Transaction tx;
  public ChequeraDao()  {
    
  }
  private void iniciaOperacion() throws HibernateException   {
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
  }
  private void manejaExcepcion(HibernateException he) throws HibernateException   {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos :/", he);
  }
  public void guardar(Chequera chequera){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(chequera); 
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
  
  public void actualizar(Chequera chequera){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(chequera); 
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
  public void eliminar(Chequera chequera) {
        try
        {
            iniciaOperacion();
            sesion.delete(chequera);
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
  
  public List<Chequera> obtenerLista() throws HibernateException{
        List<Chequera> lista = null;        
        try   {
            iniciaOperacion();
            lista = sesion.createQuery("from Chequera where estatus=1").list();
        }finally     {
            sesion.close();
        }    
        return lista;
    }
  
  public List<Chequera> validacion(int id_usuario) throws HibernateException{
      List<Chequera> liston = null;
      try   {
          iniciaOperacion();
          liston = sesion.createQuery("from Chequera where user="+id_usuario).list();
      }finally  {
          sesion.close();
      }
      return liston;
  }
  public Chequera obtener (int idcheq) throws HibernateException    {
      Chequera cheq = null;
      try   {
          iniciaOperacion();
          cheq = (Chequera) sesion.get(Chequera.class, idcheq);
      } catch (HibernateException he)   {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
      return cheq;
  }

    public List<Chequera> obtenerTarjetasAdministradasPorUsuario(int idusuario) {
        List<Chequera> lista = null;
        
        try   {
            iniciaOperacion();
            lista = sesion.createQuery("from Chequera where user="+Integer.toString(idusuario)).list();
        }finally     {
            sesion.close();
        }
        
        return lista;
    }

    public void actualizarEstatus(int idtar, int est) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Chequera set estatus = " + Integer.toString(est) + " where id = " + Integer.toString(idtar)).executeUpdate();
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

    public List<Chequera> obtenerListaBaja() {
        List<Chequera> lista = null;        
        try   {
            iniciaOperacion();
            lista = sesion.createQuery("from Chequera where estatus=0").list();
        }finally     {
            sesion.close();
        }    
        return lista;
    }

    public List<Chequera> obtenerTarjetasDeTitular(int idusuario) {
        List<Chequera> lista = null;
        
        try   {
            iniciaOperacion();
            lista = sesion.createQuery("from Chequera where ustitular="+Integer.toString(idusuario)).list();
        }finally     {
            sesion.close();
        }
        
        return lista;
    }
}

