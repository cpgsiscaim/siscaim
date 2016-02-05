/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Daos;

import Configuracion.HibernateUtil;
import Generales.Conexion;
import Modelo.Entidades.*;
import java.sql.*;
import java.util.*;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author TEMOC
 */
public class MovimientoDao {
    private Session sesion;
    private Transaction tx;

    public MovimientoDao(){
        
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
    /*
    public void guardar(Cliente clie){
        try 
        { 
            iniciaOperacion(); 
            sesion.save(clie); 
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
    
    public void actualizar(Cliente clie){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(clie); 
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
    
    public void eliminar(Cliente clie){
        try
        {
            iniciaOperacion();
            sesion.delete(clie);
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
    */
    public Cabecera obtenerCabecera(int idcab) throws HibernateException{
        Cabecera cab = null;
        try
        {
            iniciaOperacion();
            cab = (Cabecera) sesion.get(Cabecera.class, idcab);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cab;
    }
    
    public void actualizarCabecera(Cabecera cab){
        try 
        { 
            iniciaOperacion(); 
            sesion.update(cab); 
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
    
    public void eliminarCabecera(Cabecera cab){
        try
        {
            iniciaOperacion();
            sesion.delete(cab);
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
    
    public Cabecera obtenerCabeceraPorFolio(int folio) throws HibernateException{
        Cabecera cab = null;
        try
        {
            iniciaOperacion();
            cab = (Cabecera)sesion.createQuery("from Cabecera where folio="+Integer.toString(folio)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cab;
    }
    
    public void actualizarEstatusCabecera(int estatus, int idcab){
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Cabecera set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(idcab)).executeUpdate();
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
    /*
    public List<Cliente> obtenerLista() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cliente> obtenerListaActivos() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente where estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    

    
    public List<Cliente> obtenerListaInactivos() throws HibernateException{
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente where estatus=0").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
*/
    public List<Cabecera> obtenerInactivosDeSucursalYTipo(int idSuc, int idTMov) throws HibernateException {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cabecera where estatus=0 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cabecera> obtenerMovimientosDeSucursalYTipo(int idSuc, int idTMov) throws HibernateException {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc);
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    /*
    public List<Cliente> obtenerInactivosDeSucursal(int idSucSel) throws HibernateException {
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cliente where estatus=0 and sucursal="+Integer.toString(idSucSel)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cliente> obtenerClientesDeSucursalFiltrado(String consulta) throws HibernateException {
        List<Cliente> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery(consulta).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }    
*/
    public Cabecera obtenerIdCabecera(int folio, int tipomov, int idserie, int estatus, int folioo, String idserieo) throws HibernateException{
        Cabecera cab = null;
        try
        {
            iniciaOperacion();
            cab = (Cabecera)sesion.createQuery("from Cabecera where folio="+Integer.toString(folio)+" and tipomov="+Integer.toString(tipomov)+
                    " and serie="+Integer.toString(idserie)+" and estatus="+Integer.toString(estatus)+" and folioOriginal="+Integer.toString(folioo)+
                    " and serieOriginal='"+idserieo+"'").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cab;
    }
    public void guardarCabecera(Cabecera cab) {
        try 
        { 
            iniciaOperacion(); 
            sesion.save(cab);
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

    public boolean ValidaCabecera(Cabecera cab) {
        Cabecera xcab = obtenerCabeceraPorFolio(cab.getFolio());
        if (xcab!=null)
            return false;
        return true;
    }

    public List<Detalle> obtenerDetalleDeMov(int idcab) {
        List<Detalle> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Detalle where estatus=1 and cabecera="+ Integer.toString(idcab)+" order by producto.descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;        
    }

    public void guardarDetalle(Detalle det) {
        try 
        { 
            iniciaOperacion(); 
            sesion.save(det);
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

    public Detalle obtenerDetalle(int id) {
        Detalle det = null;
        try
        {
            iniciaOperacion();
            det = (Detalle) sesion.get(Detalle.class, id);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return det;
    }

    public void actualizarDetalle(Detalle det) {
        try 
        { 
            iniciaOperacion(); 
            sesion.update(det); 
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
    
    public void eliminarDetalle(Detalle det){
        try
        {
            iniciaOperacion();
            sesion.delete(det);
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


    public void actualizarEstatusDetalle(int estatus, int id) {
        try
        {
            iniciaOperacion();
            int filas = sesion.createQuery("update Detalle set estatus = " + Integer.toString(estatus) + " where id = " + Integer.toString(id)).executeUpdate();
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

    public List<Detalle> obtenerDetalleInactivosDeMov(int id) {
        List<Detalle> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Detalle where estatus=0 and cabecera="+ Integer.toString(id)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Existencia obtenerExistenciaActual(int idAlm, int idProd) {
        Existencia ex = null;
        try
        {
            iniciaOperacion();
            ex = (Existencia)sesion.createQuery("from Existencia where almacen="+Integer.toString(idAlm)+" and producto="+Integer.toString(idProd)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return ex;
    }

    public void guardaExistencia(Existencia exNva) {
        try 
        { 
            iniciaOperacion(); 
            sesion.save(exNva);
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

    public void actualizarExistencia(Existencia exAct) {
        try 
        { 
            iniciaOperacion(); 
            sesion.update(exAct); 
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

    public float obtenerTotalDeMovimiento(int idcab) {
        Double total = null;
        //select sum(importe) from Detalle where cabecera=41
        try
        {
            iniciaOperacion();
            total = (Double)sesion.createQuery("select sum(importe) from Detalle where cabecera="+Integer.toString(idcab)+
                    " and estatus=1").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        if (total==null)
            total = new Double(0);

        return total.floatValue();
    }

    public float obtenerTotalDeMovimientoSP(int idcab) {
        Double total = null;
        //select sum(importe) from Detalle where cabecera=41
        try
        {
            iniciaOperacion();
            total = (Double)sesion.createQuery("select sum(importe) from Detalle where cabecera="+Integer.toString(idcab)+
                    " and imprimir=1 and estatus=1").uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }

        //String mensaje = "";
        if (total==null)
            total = new Double(0);
            //mensaje = "Error null";
        
        return total.floatValue();
    }
    
    public Cabecera obtenerCabeceraPorSerieFolioTipoMov(int idser, int folio, int idtipomov) {
        Cabecera cab = null;
        try
        {
            iniciaOperacion();
            cab = (Cabecera)sesion.createQuery("from Cabecera where folio="+Integer.toString(folio)+" and tipomov="+Integer.toString(idtipomov)+
                    " and serie="+Integer.toString(idser)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cab;
    }

    public float obtenerDesctoDeMovimiento(int idcab, int cat) {
        Double desc = null;
        //select sum(deta_cantidad*deta_costo*(deta_descuento/100)) from detalle where cabecera_cabe_id=46
        String precos = "costo";
        if (cat==2)
            precos = "precio";
        String sql = "select sum(cantidad*" + precos + "*(descuento/100)) from Detalle where cabecera="+Integer.toString(idcab)+" and estatus=1";
        try
        {
            iniciaOperacion();
            desc = (Double)sesion.createQuery(sql).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }

        if (desc==null)
            desc = new Double(0);
        return desc.floatValue();
    }

    public float obtenerDesctoDeMovimientoSP(int idcab, int cat) {
        Double desc = null;
        //select sum(deta_cantidad*deta_costo*(deta_descuento/100)) from detalle where cabecera_cabe_id=46
        String precos = "costo";
        if (cat==2)
            precos = "precio";
        String sql = "select sum(cantidad*" + precos + "*(descuento/100)) from Detalle where cabecera="+Integer.toString(idcab)+" and imprimir=1 and estatus=1";
        try
        {
            iniciaOperacion();
            desc = (Double)sesion.createQuery(sql).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }

        if (desc==null)
            desc = new Double(0);
        
        return desc.floatValue();
    }
    
    public List<Cabecera> obtenerMovimientosOtrasEntradasSalidas(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String cat = "1";//otras entradas
            if (idTMov == 7)
                cat = "2";//otras salidas
            lista = sesion.createQuery("from Cabecera where estatus=1 and tipomov in (select id from TipoMov where estatus=2 and categoria=" + cat + ")"+
                    " and sucursal="+Integer.toString(idSuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cabecera> obtenerInactivosOtrasEntradasSalidas(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String cat = "1";//otras entradas
            if (idTMov == 7)
                cat = "2";//otras salidas
            lista = sesion.createQuery("from Cabecera where estatus=0 and tipomov in (select id from TipoMov where estatus=2 and categoria=" + cat + ")"+
                    " and sucursal="+Integer.toString(idSuc)).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cabecera> obtenerAplicadosOtrasEntradasSalidas(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String cat = "1";//otras entradas
            if (idTMov == 7)
                cat = "2";//otras salidas
            lista = sesion.createQuery("from Cabecera where estatus=2 and tipomov in (select id from TipoMov where estatus=2 and categoria=" + cat + ")"+
                    " and sucursal="+Integer.toString(idSuc)+" order by fechaInventario desc, folio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cabecera> obtenerAplicadosDeSucursalYTipo(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cabecera where estatus=2 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" order by fechaInventario desc, folio").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public Cabecera obtenerCabeceraSalidaProgramada(int idcli, int idcon, int idct, String fechasp, int idtmov) {
        Cabecera cab = null;
        try
        {
            iniciaOperacion();
            cab = (Cabecera)sesion.createQuery("from Cabecera where cliente="+Integer.toString(idcli)+" and tipomov="+Integer.toString(idtmov)+
                    " and contrato="+Integer.toString(idcon) + " and fechaCaptura = '" + fechasp + "' and centrotrabajo = " + Integer.toString(idct)).uniqueResult();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        return cab;
    }

    public void eliminaSalidasProgsDeContrato(int idcli, int idcon) {
        try
        {
            iniciaOperacion();
            sesion.createQuery("delete from Detalle where cabecera in (select id from Cabecera where cliente="+Integer.toString(idcli)+" and tipomov=20"+
                    " and contrato="+Integer.toString(idcon)+")").executeUpdate();
            sesion.createQuery("delete from Cabecera where cliente="+Integer.toString(idcli)+" and tipomov=20"+
                    " and contrato="+Integer.toString(idcon)).executeUpdate();
            tx.commit();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        
        //return cab;
    }

    public List<Cabecera> obtenerMovimientosFiltrado(String consulta) {
        List<Cabecera> lista = null;

        try
        {
            iniciaOperacion();
            lista = sesion.createQuery(consulta).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List obtenerKardexProducto(int idprod, String fechaini, String fechafin) {
        List kardex = null;
        try
        {
            iniciaOperacion();
            kardex = sesion.createQuery("select new List(c.fechaInventario, c.serie.serie, c.folio, c.tipomov.descripcion, c.tipomov.categoria, "+
                    "d.cantidad*up.valor, d.precio, d.costo, d.importe, d.producto.unidad.clave) "+
                    "from Cabecera c, Detalle d, UnidadProducto up where c.id = d.cabecera.id and d.producto="+Integer.toString(idprod)+
                    " and c.fechaInventario>='"+fechaini+"' and c.fechaInventario<='"+fechafin+"' and c.estatus = 2"+
                    " and up.producto.id="+Integer.toString(idprod)+ " and up.unidad=d.unidad"+
                    " order by c.fechaInventario, c.tipomov.categoria").list();
            
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return kardex;
    }

    public Float obtenerSaldoInicialProducto(int idprod, String fechaini) {
        float saldo = 0;
        try
        {
            iniciaOperacion();
            Double totentradas = (Double)sesion.createQuery("select sum(d.cantidad*up.valor) "+
                    "from Cabecera c, Detalle d, UnidadProducto up where c.id = d.cabecera.id and d.producto="+Integer.toString(idprod)+
                    " and up.producto.id="+Integer.toString(idprod)+ " and up.unidad=d.unidad"+
                    " and c.fechaInventario<'"+fechaini+"' and c.estatus = 2 and c.tipomov.categoria=1").uniqueResult();
            Double totsalidas = (Double)sesion.createQuery("select sum(d.cantidad*up.valor) "+
                    "from Cabecera c, Detalle d, UnidadProducto up where c.id = d.cabecera.id and d.producto="+Integer.toString(idprod)+
                    " and up.producto.id="+Integer.toString(idprod)+ " and up.unidad=d.unidad"+
                    " and c.fechaInventario<'"+fechaini+"' and c.estatus = 2 and c.tipomov.categoria=2").uniqueResult();
            saldo = (totentradas!=null?totentradas.floatValue():0) - (totsalidas!=null?totsalidas.floatValue():0);
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return new Float(saldo);
    }

    /*public List<Detalle> obtenerAcumuladoDeProductos(int idsuc, int idruta, String fechaini, String fechafin) {
        List<Detalle> acum =  null;
        try
        {
            iniciaOperacion();
            String consulta = "";
            if (!fechaini.equals("") && !fechafin.equals("")){
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(idsuc)+
                    " and centrotrabajo.ruta.id="+Integer.toString(idruta)+" and fechaCaptura>='"+fechaini+"'"+
                    " and fechaCaptura<='"+fechafin+"'";
            } else if (!fechaini.equals("")){
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(idsuc)+
                    " and centrotrabajo.ruta.id="+Integer.toString(idruta)+" and fechaCaptura='"+fechaini+"'";
            } else {
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(idsuc)+
                    " and centrotrabajo.ruta.id="+Integer.toString(idruta)+" and fechaCaptura='"+fechafin+"'";
            }
            
            List<Cabecera> movs = sesion.createQuery(consulta).list();
            acum = new ArrayList<Detalle>();
            for (int i=0; i < movs.size(); i++){
                Cabecera cab = movs.get(i);
                List<Detalle> detalles = null;
                detalles = sesion.createQuery("from Detalle where estatus=1 and cabecera="+ Integer.toString(cab.getId())+
                        " order by producto.descripcion").list();
                for (int j=0; j < detalles.size(); j++){
                    Detalle det = detalles.get(j);
                    UnidadProductoDao upDao = new UnidadProductoDao();
                    UnidadProducto up = upDao.obtener(det.getUnidad().getId(), det.getProducto().getId());
                    if (acum.isEmpty()){
                        //pasar la cantidad y la unidad a la minima
                        det.setCantidad(det.getCantidad()*up.getValor());
                        det.setUnidad(det.getProducto().getUnidad());
                        //agregar a la lista del acumulado
                        acum.add(det);
                    } else {
                        boolean esta = false;
                        int pos = 0;
                        for (int a=0; a < acum.size(); a++){
                            Detalle acumx = acum.get(a);
                            if (acumx.getProducto().getId()==det.getProducto().getId()){
                                esta = true; pos = a;
                                break;
                            }
                        }
                        if (esta){
                            Detalle acumx = acum.get(pos);
                            //aumentar la cantidad en unidad minima
                            acumx.setCantidad(acumx.getCantidad()+(det.getCantidad()*up.getValor()));
                            //actualizar el acumulado
                            acum.set(pos, acumx);
                        } else {
                            //pasar la cantidad y la unidad a la minima
                            det.setCantidad(det.getCantidad()*up.getValor());
                            det.setUnidad(det.getProducto().getUnidad());
                            //agregar a la lista del acumulado
                            acum.add(det);
                        }
                    }
                }
            }
            
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return acum;
    }*/

    public List<Cabecera> obtenerMovsSalidasDeCT(int idct) {
        List<Cabecera> movs = null;
        try
        {
            iniciaOperacion();
            movs = sesion.createQuery("from Cabecera where estatus in (1,2) and centrotrabajo="+ Integer.toString(idct)+
                    " and tipomov.categoria=2 and tipomov.estatus=1 and tipomov.id not in (7,9)"+
                    " order by fechaCaptura, contrato.contrato, centrotrabajo.nombre, serie.serie, folio").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return movs;
    }

    public List<Cabecera> obtenerMovsSalidasDeContrato(int idcon) {
        List<Cabecera> movs = null;
        try
        {
            iniciaOperacion();
            movs = sesion.createQuery("from Cabecera where estatus in (1,2) and contrato="+ Integer.toString(idcon)+
                    " and tipomov.categoria=2 and tipomov.estatus=1 and tipomov.id not in (7,9)"+
                    " order by fechaCaptura, contrato.contrato, centrotrabajo.nombre, serie.serie, folio").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return movs;
    }

    public Object obtenerMovsSalidasDeCliente(int idcli) {
        List<Cabecera> movs = null;
        try
        {
            iniciaOperacion();
            movs = sesion.createQuery("from Cabecera where estatus in (1,2) and cliente="+ Integer.toString(idcli)+
                    " and tipomov.categoria=2 and tipomov.estatus=1 and tipomov.id not in (7,9)"+
                    " order by fechaCaptura, contrato.contrato, centrotrabajo.nombre, serie.serie, folio").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return movs;
    }
    
    public List<Cabecera> obtenerMovsEntradasDeCT(int idct) {
        List<Cabecera> movs = null;
        try
        {
            iniciaOperacion();
            movs = sesion.createQuery("from Cabecera where estatus in (1,2) and centrotrabajo="+ Integer.toString(idct)+
                    " and tipomov.categoria=1 and tipomov.estatus=1 and tipomov.id not in (5,8) order by fechaInventario, fechaCaptura").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return movs;
    }

    public List<Cabecera> obtenerMovsEntradasDeContrato(int idcon) {
        List<Cabecera> movs = null;
        try
        {
            iniciaOperacion();
            movs = sesion.createQuery("from Cabecera where estatus in (1,2) and contrato="+ Integer.toString(idcon)+
                    " and tipomov.categoria=1 and tipomov.estatus=1 and tipomov.id not in (5,8) order by fechaInventario, fechaCaptura").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return movs;
    }

    public List<Cabecera> obtenerMovsEntradasDeCliente(int idcli) {
        List<Cabecera> movs = null;
        try
        {
            iniciaOperacion();
            movs = sesion.createQuery("from Cabecera where estatus in (1,2) and cliente="+ Integer.toString(idcli)+
                    " and tipomov.categoria=1 and tipomov.estatus=1 and tipomov.id not in (5,8) order by fechaInventario, fechaCaptura").list();
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return movs;
    }

    public List<CentroDeTrabajo> obtenerCTSAcumuladoPeriodo(int idsuc, int idruta, String fechaini, String fechafin) {
        List<CentroDeTrabajo> cts = null;
        try
        {
            iniciaOperacion();
            cts = sesion.createQuery("from CentroDeTrabajo where (ruta=" + Integer.toString(idruta) +
                    " or (rutaalterna="+ Integer.toString(idruta)+" and surtidoexterno=1)) and id in ("
                    + "select distinct centrotrabajo from Cabecera where estatus=1 and centrotrabajo is not null"+
                    " and fechaCaptura>='" + fechaini + "' and fechaCaptura<='" + fechafin + "'"+
                    " and contrato.fechaFin>=date(now()) and cliente.estatus=1 and contrato.estatus=1 and centrotrabajo.estatus=1)"+
                    " order by cliente.datosFiscales.razonsocial").list();
            /*cts = sesion.createQuery("select distinct centrotrabajo from Cabecera where estatus=1 "+
                    " and centrotrabajo.ruta.id=" + Integer.toString(idruta) +
                    " and fechaCaptura>='" + fechaini + "' and fechaCaptura<='" + fechafin + "'").list();*/
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return cts;
    }

    public List<CentroDeTrabajo> obtenerCTSAcumulado(int idsuc, int idruta, String fecha) {
        List<CentroDeTrabajo> cts = null;
        try
        {
            iniciaOperacion();
            cts = sesion.createQuery("from CentroDeTrabajo where (ruta=" + Integer.toString(idruta) +
                    " or (rutaalterna="+ Integer.toString(idruta)+" and surtidoexterno=1)) and id in ("
                    + "select distinct centrotrabajo from Cabecera where estatus=1 and centrotrabajo is not null"+
                    " and fechaCaptura='" + fecha + "' and contrato.fechaFin>=date(now()))"+
                    " order by cliente.datosFiscales.razonsocial").list();
            /*cts = sesion.createQuery("select distinct centrotrabajo from Cabecera where estatus=1 "+
                    " and centrotrabajo.ruta.id=" + Integer.toString(idruta) +
                    " and fechaCaptura='" + fecha + "'").list();*/
        }catch (HibernateException he)
        {
            manejaExcepcion(he);
            throw he;
        }finally
        {
            sesion.close();
        }
        return cts;
    }

    public int generaDetalleDeSalidaProgramada(int idcab, int idct, int idcon, int idcli, int idsuc, int mul) {
        int res = 0;
        Conexion conn = new Conexion();
        Connection conne = null;

        //PreparedStatement ps = null;
        //ResultSet rs = null;
        try
        {
            //Pedimos una conexion al pool
            conne = conn.conectar();

            //obtener las categorias
            /*String query = "call generaDetalle("+ Integer.toString(idcab) +","+Integer.toString(idct) +","+
                    Integer.toString(idcon)+","+Integer.toString(idcli)+","+Integer.toString(idsuc)+","+
                    Integer.toString(res)+")";*/
            String query = "call generaDetalle(?,?,?,?,?,?,?)";
            CallableStatement cs = conne.prepareCall(query);
            cs.setInt(1, idcab);
            cs.setInt(2, idct);
            cs.setInt(3, idcon);
            cs.setInt(4, idcli);
            cs.setInt(5, idsuc);
            cs.setInt(6, mul);
            cs.registerOutParameter(7, java.sql.Types.INTEGER);
            cs.execute();
            res = cs.getInt(7);
            
            /*ps = conne.prepareStatement(query);
                        
            rs = ps.executeQuery();
            
            while (rs.next())
            {
                res = rs.getInt(1);
            }
            * */
        }catch(SQLException e)
        {
            System.out.println("Ocurrió un error en la capa de datos JDBC:"+ e.getMessage());
        }
        finally
        {
            try
            {
                if (conne!= null && !conne.isClosed())
                {
                   conne.close();
                }
            }
            catch(SQLException e)
            {
                 System.out.println("Ocurrió un error al cerrar la conexión JDBC:"+e.getMessage());
            }
        }
        
        return res;
    }

    public List<Detalle> obtenerDetalleDeSalidaProgramada(int idcab) {
        List<Detalle> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Detalle where estatus=1 and cambio=0 and cabecera="+ Integer.toString(idcab)+" order by producto.descripcion").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;        
    }

    public List<Cabecera> obtenerMovimientosDeSucursalYTipoSP(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" and contrato.fechaFin>=date(now()) and contrato.estatus=1"+
                    " and cliente.estatus=1 and centrotrabajo.estatus=1").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cabecera> obtenerMovimientosDeSucursalYTipoEntrada(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" and proveedor.estatus=1";
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cabecera> obtenerMovimientosDeSucursalYTipoSalida(int idSuc, int idTMov) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" and cliente.estatus=1";
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void eliminaSPsDeCTs(int idcli, int idcon, String ctssel) {
        try
        {
            iniciaOperacion();
            sesion.createQuery("delete from Detalle where cabecera in (select id from Cabecera where cliente="+Integer.toString(idcli)+" and tipomov=20"+
                    " and contrato="+Integer.toString(idcon)+" and centrotrabajo  in ("+ctssel+"))").executeUpdate();
            sesion.createQuery("delete from Cabecera where cliente="+Integer.toString(idcli)+" and tipomov=20"+
                    " and contrato="+Integer.toString(idcon)+" and centrotrabajo  in ("+ctssel+"))").executeUpdate();
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

    public List<Cabecera> obtenerMovimientosOtrasEntradasSalidasPeriodo(int idSuc, int idTMov, String feini, String fefin) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String cat = "1";//otras entradas
            if (idTMov == 7)
                cat = "2";//otras salidas
            lista = sesion.createQuery("from Cabecera where estatus=1 and tipomov in (select id from TipoMov where estatus=2 and categoria=" + cat + ")"+
                    " and sucursal="+Integer.toString(idSuc)+" and fechaCaptura>='"+feini+"'"+
                    " and fechaCaptura<='"+fefin+"' order by fechaCaptura").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cabecera> obtenerMovimientosDeSucursalYTipoSPPeriodo(int idSuc, int idTMov, String feini, String fefin) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery("from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" and contrato.fechaFin>=date(now()) and contrato.estatus=1"+
                    " and cliente.estatus=1 and centrotrabajo.estatus=1 and fechaCaptura>='"+feini+"'"+
                    " and fechaCaptura<='"+fefin+"' order by fechaCaptura, cliente, contrato, centrotrabajo").list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cabecera> obtenerMovimientosDeSucursalYTipoEntradaPeriodo(int idSuc, int idTMov, String feini, String fefin) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" and proveedor.estatus=1"+
                    " and fechaCaptura>='"+feini+"' and fechaCaptura<='"+fefin+"' order by fechaCaptura";
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cabecera> obtenerMovimientosDeSucursalYTipoSalidaPeriodo(int idSuc, int idTMov, String feini, String fefin) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+" and cliente.estatus=1"+
                    " and fechaCaptura>='"+feini+"' and fechaCaptura<='"+fefin+"' order by fechaCaptura";
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public List<Cabecera> obtenerMovimientosDeSucursalYTipoPeriodo(int idSuc, int idTMov, String feini, String fefin) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(idTMov) +
                    " and sucursal="+Integer.toString(idSuc)+
                    " and fechaCaptura>='"+feini+"' and fechaCaptura<='"+fefin+"' order by fechaCaptura";
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }
    
    public List<Cabecera> obtenerSalidasProgramadasDeCT(int idct) {
        List<Cabecera> lista = null;
        
        try
        {
            iniciaOperacion();
            String sql = "from Cabecera where estatus=1 and tipomov=20"+
                    " and centrotrabajo="+Integer.toString(idct)+
                    "  order by fechaCaptura";
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }
        
        return lista;
    }

    public void eliminaDetalleDeMov(int idmov) {
        try
        {
            iniciaOperacion();
            sesion.createQuery("delete from Detalle where cabecera="+Integer.toString(idmov)).executeUpdate();
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

    public void eliminaPedidosDeMesDeSucursalyProv(int mes, int idsuc, int idprov, int tipomov) {
        try
        {
            iniciaOperacion();
            sesion.createQuery("delete from Detalle where cabecera in "+
                    "(select id from Cabecera where mes="+Integer.toString(mes)+
                    " and tipomov="+Integer.toString(tipomov) +" and sucursal="+ Integer.toString(idsuc) +
                    " and proveedor="+Integer.toString(idprov)+")").executeUpdate();
            sesion.createQuery("delete from Cabecera where mes="+Integer.toString(mes)+
                    " and tipomov="+Integer.toString(tipomov)+" and sucursal="+ Integer.toString(idsuc)+
                    " and proveedor="+Integer.toString(idprov)).executeUpdate();
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

    public List<Detalle> obtenerDetallesDeSql(String sql) {
        List<Detalle> lista = null;
        try
        {
            iniciaOperacion();
            lista = sesion.createQuery(sql).list();
        }finally
        {
            sesion.close();
        }        
        return lista;
    }
}
