package Modelo.Daos;
/* @author germain  */

import Configuracion.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import Modelo.Entidades.Abono;

public class AbonoDao {
  private Session sesion;
  private Transaction tx;
  public AbonoDao() {
    
  }
  private void iniciaOperacion() throws HibernateException   {
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
  }
  
  private void manejaExcepcion(HibernateException he) throws HibernateException   {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos :/", he);
  }
  
  public void guardar(Abono abono){
        try { 
            iniciaOperacion(); 
            sesion.save(abono); 
            tx.commit(); 
        }catch(HibernateException he) { 
            manejaExcepcion(he);
            throw he; 
        }finally         { 
            sesion.close(); 
        }  
  }
    public void borrarAbono(int id)   {
      try   {
          iniciaOperacion();
          sesion.createQuery("delete from Abono where id="+id).executeUpdate();
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
  public void actualizar(Abono abono){
        try { 
            iniciaOperacion(); 
            sesion.update(abono); 
            tx.commit();
        }catch (HibernateException he) { 
            manejaExcepcion(he); 
            throw he; 
        }finally  { 
            sesion.close(); 
        }         
  }
  
  public void eliminar(Abono abono){
        try        {
            iniciaOperacion();
            sesion.delete(abono);
            tx.commit();
        }catch (HibernateException he)    {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }
  }
  
/*  public Double obtenerTotalCargosTar(int idtar) throws HibernateException  {
      Double total = 0.0;
      try   {
          iniciaOperacion();
          total = (Double) sesion.createQuery("select sum(cantidad) from Cargo where che="+Integer.toString(idtar)
                  +" and t_pago=0").uniqueResult();
      } catch (HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally   {
            sesion.close();
        }        
        return total;       
  }

  public Double obtenerTotalCargosEfe(int idtar) throws HibernateException  {
      Double total = 0.0;
      try   {
          iniciaOperacion();
          total = (Double) sesion.createQuery("select sum(cantidad) from Cargo where che="+Integer.toString(idtar)
                  +" and t_pago=1").uniqueResult();
      } catch (HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally   {
            sesion.close();
        }        
        return total;       
  }
*/  
  public Double obtenerTotalTar(int idtar) throws HibernateException  {
      Double total = 0.0;
      try  {
            iniciaOperacion();
            total = (Double) sesion.createQuery("select sum(cantidad) from Abono where che="+Integer.toString(idtar)
                    +" and tipo=0").uniqueResult();
        }catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }        
        return total;
  } 

  public Double obtenerTotalEfe(int idtar) throws HibernateException  {
      Double total = 0.0;
      try  {
            iniciaOperacion();
            total = (Double) sesion.createQuery("select sum(cantidad) from Abono where che="+Integer.toString(idtar)
                    +" and tipo=1").uniqueResult();
        }catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }        
        return total;
  } 
  
  public Abono obtener(int idabono) throws HibernateException{
        Abono abono = null;
        try  {
            iniciaOperacion();
            abono = (Abono) sesion.get(Abono.class, idabono);
        }catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }        
        return abono;
  }

    public Double obtenerTotalDeTipoAntesDeFecha(int idtar, int tipo, String fechaI) {
        Double total = 0.0;
        try  {
            iniciaOperacion();
            total = (Double) sesion.createQuery("select sum(cantidad) from Abono where id in "+
                    "(select abon.id from Movimientos where abon.id<>1 and carg.id=1 and cheq="+Integer.toString(idtar)+
                  " and fecha<'"+fechaI+"'"+
                  " and tipo="+Integer.toString(tipo)+")").uniqueResult();
        }catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }        
        return total;
    }
  
  
}
