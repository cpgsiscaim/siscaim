package Modelo.Daos;

/* @author germain */
import Configuracion.HibernateUtil;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import Modelo.Entidades.Movimientos;

public class MovimientoChequeraDao {
  private Session sesion;
  private Transaction tx;
  public MovimientoChequeraDao()  {
    
  }
  
  private void iniciaOperacion() throws HibernateException   {
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
  }
  
  private void manejaExcepcion(HibernateException he) throws HibernateException   {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos :/", he);
  }
  
  public void guardar(Movimientos movi){
        try { 
            iniciaOperacion(); 
            sesion.save(movi); 
            tx.commit(); 
        }catch(HibernateException he) { 
            manejaExcepcion(he);
            throw he; 
        }finally         { 
            sesion.close(); 
        }  
  }
  
  public void actualizar(Movimientos movi){
        try { 
            iniciaOperacion(); 
            sesion.update(movi); 
            tx.commit();
        }catch (HibernateException he) { 
            manejaExcepcion(he); 
            throw he; 
        }finally  { 
            sesion.close(); 
        }         
  }
  
  public void eliminar(Movimientos movi){
        try        {
            iniciaOperacion();
            sesion.delete(movi);
            tx.commit();
        }catch (HibernateException he)    {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }
  }
  
  public Movimientos obtener(int idmov) throws HibernateException{
        Movimientos movi = null;
        try  {
            iniciaOperacion();
            movi = (Movimientos) sesion.get(Movimientos.class, idmov);
        }catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }        
        return movi;
  }  
  public void updateAbono(int id, float cm, String cc) {
      try   {
          iniciaOperacion();
          sesion.createQuery("update from Abono set cantidad="+cm+", concepto='"+cc+"' where id="+id).executeUpdate();                       
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
  public void updateCargo(int id, float cm, String cc) {
      try   {
          iniciaOperacion();
          sesion.createQuery("update from Cargo set cantidad="+cm+", concepto='"+cc+"' where id="+id).executeUpdate();                       
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
    public void updateFecha(int id, String cf) {
      try   {
          iniciaOperacion();
          sesion.createQuery("update from Movimientos set fecha='"+cf+"' where id="+id).executeUpdate();                       
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
  public void borraMovimiento(int id)   {
      try   {
          iniciaOperacion();
          int n = sesion.createQuery("delete from Movimientos where id="+id).executeUpdate();          
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
  
  public void borraCargo(int id)   {
      try   {
          int n = sesion.createQuery("delete from Cargo where id="+id).executeUpdate();
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
  
  public List<Movimientos> obtenerLista() throws HibernateException{
    List<Movimientos> lista = null;
    try {
      iniciaOperacion();
      lista = sesion.createQuery("from Movimientos order by fecha asc, id").list();
    }finally {
      sesion.close();
    }        
    return lista;
  }  
      
  public List<Movimientos> obtenerMovimientosDeSucursal(int idSucSel) throws HibernateException {
        List<Movimientos> lista = null;        
        try  {
          iniciaOperacion();
          lista = sesion.createQuery("from Movimientos where cheq="+Integer.toString(idSucSel)).list(); //Integer.toString(idSucSel
          System.out.println("En Dao: "+lista.size()+" con id_suc: "+idSucSel);
        }finally    {
            sesion.close();
        }        
        return lista;
  }
  public List<Movimientos> obtenerMovimientosDeTarjeta(int idCheq) throws HibernateException    {
      List<Movimientos> lista = null;
      try   {
          iniciaOperacion();
          lista = sesion.createQuery("from Movimientos where cheq="+Integer.toString(idCheq)+" order by fecha asc").list();
      }finally  {
          sesion.close();
      }
      return lista;
  }

    public List<Movimientos> obtenerCargosDeTarjeta(int idTar) {
      List<Movimientos> lista = null;
      try   {
          iniciaOperacion();
          lista = sesion.createQuery("from Movimientos where cheq="+Integer.toString(idTar)+
                  " and abon=1 and carg<>1 order by fecha asc").list();
      }finally  {
          sesion.close();
      }
      return lista;
    }

    public List<Movimientos> obtenerMovimientosDeTarjetaDeTipoYDelPeriodo(int idCheq, int tipo, String fechaI, String fechaF) {
      List<Movimientos> lista = null;
      try   {
          iniciaOperacion();
          lista = sesion.createQuery("from Movimientos where cheq="+Integer.toString(idCheq)+
                  " and fecha>='"+fechaI+"' and fecha<='"+fechaF+"'"+
                  " and tipo="+Integer.toString(tipo)+
                  " order by fecha asc").list();
      }finally  {
          sesion.close();
      }
      return lista;
    }

    public List<Movimientos> obtenerMovimientosDeTarjetaDeTipoAnteriores(int idTar, int tipo, String fechaI) {
      List<Movimientos> lista = null;
      try   {
          iniciaOperacion();
          lista = sesion.createQuery("from Movimientos where cheq="+Integer.toString(idTar)+
                  " and fecha<'"+fechaI+"'"+
                  " and tipo="+Integer.toString(tipo)+
                  " order by fecha asc").list();
      }finally  {
          sesion.close();
      }
      return lista;
    }
}
