package Modelo.Daos;
import Configuracion.HibernateUtil;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import Modelo.Entidades.Cargo;
/**
 *
 * @author marba
 */
public class CargoDao {
  private Session sesion;
  private Transaction tx;
  public CargoDao() {
      
  }
   private void iniciaOperacion() throws HibernateException   {
        sesion = HibernateUtil.getSessionFactory().openSession();
        tx = sesion.beginTransaction();
  }
   private void manejaExcepcion(HibernateException he) throws HibernateException   {
        tx.rollback();
        throw new HibernateException("Ocurrió un error en la capa de acceso a datos del CARGO :/", he);
  }
  
  public void borraCargo(int id)   {
      try   {
          iniciaOperacion();
          int n = sesion.createQuery("delete from Cargo where id="+id).executeUpdate();
          tx.commit();
      }catch(HibernateException he) {
          manejaExcepcion(he);
          throw he;
      } finally {
          sesion.close();
      }
  }
  
  public List<Cargo> obtenerLista() throws HibernateException{
    List<Cargo> lista = null;
    try {
      iniciaOperacion();
      lista = sesion.createQuery("from Cargo").list();
    }finally {
      sesion.close();
    }        
    return lista;
  }
  
    public Double obtenerTotalCargosTar(int idtar) throws HibernateException  {
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

    public Double obtenerTotalDeTipoAntesDeFecha(int idtar, int tipo, String fechaI) {
        Double total = 0.0;
        try  {
            iniciaOperacion();
            total = (Double) sesion.createQuery("select sum(cantidad) from Cargo where id in "+
                    "(select carg.id from Movimientos where abon.id=1 and carg.id<>1 and cheq="+Integer.toString(idtar)+
                  " and fecha<'"+fechaI+"'"+
                  " and t_pago="+Integer.toString(tipo)+")").uniqueResult();
        }catch (HibernateException he) {
            manejaExcepcion(he);
            throw he;
        }finally   {
            sesion.close();
        }        
        return total;
    }
}
