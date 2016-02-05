/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Modelo.Entidades.Catalogos.TipoDocumento;
import Modelo.Entidades.Documento;
import Modelo.Entidades.Empleado;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author usuario
 */
public class DocumentoDao {
    private Session sesion;
    private Transaction tx;

    public DocumentoDao(){
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
    
    public void guardar(Documento dir){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(dir); 
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
    
    public void actualizar(Documento dir){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(dir); 
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
    
    public void eliminar(Documento dir){
        try
        {
            iniciaOperacion();
            sesion.delete(dir);
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
    
    public Documento obtener(int iddir) throws HibernateException{
        Documento dir = null;
        try
        {
            iniciaOperacion();
            dir = (Documento) sesion.get(Documento.class, iddir);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return dir;
    }
    
    public List<Documento> obtenerLista() throws HibernateException{
        List<Documento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Documento").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Documento> obtenerActivosDeEmpleado(int numemp) throws HibernateException{
        List<Documento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Documento where estatus=1 and empleado="+Integer.toString(numemp)+
                    " order by tipodoc.categoria.descripcion, tipodoc.descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Documento> obtenerInactivosDeEmpleado(int numemp) throws HibernateException{
        List<Documento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Documento where estatus=0 and empleado="+Integer.toString(numemp)+
                    " order by tipodoc.categoria.descripcion, tipodoc.descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void actualizarEstatusDeDocumento(int estatus, int idDoc) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Documento set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idDoc)).executeUpdate();
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

    public List<Empleado> obtenerEmpleadosConDocumentos(String docs, String idsuc, String estatus, String cotiza) {
        List<Empleado> lista = null;
        try
        {
            iniciaOperacion();
            /*"from Empleado where numempleado in (select distinct empleado.numempleado "+
                    "from Documento where tipodoc in ("+docs+")) and persona.sucursal.id="+idsuc+" and estatus in ("+estatus+")"*/
            String sql = "from Empleado where numempleado in (select distinct empleado.numempleado "+
                    "from Documento where tipodoc in ("+docs+") and estatus=1) and persona.sucursal.id="+idsuc+
                    " and estatus in ("+estatus+") and cotiza in ("+cotiza+")"+
                    " order by persona.paterno, persona.materno, persona.nombre";
            lista = sesion.createQuery(sql).list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return lista;
    }

    public int ContarDocumentosDeEmpleado(int numempleado, String docs) {
        int tot = 0;
        try
        {
            iniciaOperacion();
            /*"from Empleado where numempleado in (select distinct empleado.numempleado "+
                    "from Documento where tipodoc in ("+docs+")) and persona.sucursal.id="+idsuc+" and estatus in ("+estatus+")"*/
            String sql = "select count(*) from Documento where empleado="+Integer.toString(numempleado)+
                    "and tipodoc in ("+docs+") and estatus=1)";
            tot = ((Long)sesion.createQuery(sql).uniqueResult()).intValue();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return tot;
    }

    public List<Documento> obtenerDocumentosDeEmpleadoDeCategoria(int numemp, int idcat) {
        List<Documento> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Documento where estatus=1 and empleado="+Integer.toString(numemp)+
                    " and tipodoc.categoria="+Integer.toString(idcat)+
                    " order by tipodoc.categoria.descripcion, tipodoc.descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
}
