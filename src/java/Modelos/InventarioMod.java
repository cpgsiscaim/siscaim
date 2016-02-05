/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Entidades.*;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.*;

/**
 *
 * @author usuario
 */
public class InventarioMod {
    int grupos = 0;
    public InventarioMod(){
    }

    public Sesion AcumuladoProductos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //obtener las sucursales
                datos = ObtenerSucursales(datos);
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                datos = CargaRutas(datos);
                //obtener el período inicial, por default el mes actual, si es sal prog del 1 al 8 del mes actual
                datos = ObtenerPeriodo(datos);
                break;
            case -1:
                //cargar rutas de la sucursal seleccionada
                datos = CargaRutas(datos);
                break;
            case 1:
                datos = ObtenerCTS(datos);
                //datos = CalcularAcumulado(datos);
                break;
            case 2: case 3:
                datos = ImprimirReporte(datos);
                break;
            case 4: case 5:
                //imprimir prods x ct
                datos = ObtenerMovimientosDeCts(datos);
                datos = ImprimirReporte(datos);
               break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }
    
    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }
    
    private HashMap ObtenerSucursales(HashMap datos) {
        SucursalDao sucDao = new SucursalDao();
        datos.put("sucursales", sucDao.obtenerListaSucYMatriz());
        return datos;
    }

    private HashMap CargaRutas(HashMap datos) {
        RutaDao rutDao = new RutaDao();
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        SucursalDao sucdao = new SucursalDao();
        sucSel = sucdao.obtener(sucSel.getId());
        datos.put("sucursalSel", sucSel);
        datos.put("rutas", rutDao.obtenerRutasDeSucursal(sucSel.getId()));
        return datos;
    }

    private HashMap CalcularAcumulado(HashMap datos) {
        //obtener las cabeceras de los movimientos de los cts con ruta igual a la seleccionada
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        Ruta rut = (Ruta)datos.get("ruta");
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();
        String sqlfechai = fechaini.substring(6,10)+"-"+fechaini.substring(3,5)+"-"+fechaini.substring(0,2);
        String sqlfechaf = fechafin.substring(6,10)+"-"+fechafin.substring(3,5)+"-"+fechafin.substring(0,2);
        MovimientoDao movDao = new MovimientoDao();
        //datos.remove("acumulado");
        //datos.put("acumulado", movDao.obtenerAcumuladoDeProductos(suc.getId(), rut.getId(), fechaini, fechafin));
        List<Detalle> acum =  null;
        //obtener los movs
        String consulta = "";
        if (rut.getId()!=-1){
            if (!fechaini.equals("") && !fechafin.equals("")){
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                    " and (centrotrabajo.ruta.id="+Integer.toString(rut.getId())+
                    " or (centrotrabajo.rutaalterna.id="+Integer.toString(rut.getId())+
                    " and centrotrabajo.surtidoexterno=1)"+
                    ") and fechaCaptura>='"+sqlfechai+"'"+
                    " and fechaCaptura<='"+sqlfechaf+"'";
            } else if (!fechaini.equals("")){
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                    " and (centrotrabajo.ruta.id="+Integer.toString(rut.getId())+
                    " or (centrotrabajo.rutaalterna.id="+Integer.toString(rut.getId())+
                    " and centrotrabajo.surtidoexterno=1)"+
                    ") and fechaCaptura='"+sqlfechai+"'";
            } else {
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                    " and (centrotrabajo.ruta.id="+Integer.toString(rut.getId())+
                    " or (centrotrabajo.rutaalterna.id="+Integer.toString(rut.getId())+
                    " and centrotrabajo.surtidoexterno=1)"+
                    ") and fechaCaptura='"+sqlfechaf+"'";
            }
        } else {
            if (!fechaini.equals("") && !fechafin.equals("")){
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                    " and fechaCaptura>='"+sqlfechai+"'"+
                    " and fechaCaptura<='"+sqlfechaf+"'"+
                    " and tipomov.categoria=2";
            } else if (!fechaini.equals("")){
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                    " and fechaCaptura='"+sqlfechai+"'"+
                    " and tipomov.categoria=2";
            } else {
                consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                    " and fechaCaptura='"+sqlfechaf+"'"+
                    " and tipomov.categoria=2";
            }
        }
        List<Cabecera> movs = movDao.obtenerMovimientosFiltrado(consulta);
        acum = new ArrayList<Detalle>();
        for (int i=0; i < movs.size(); i++){
            Cabecera cab = movs.get(i);
            List<Detalle> detalles = null;
            detalles = movDao.obtenerDetalleDeMov(cab.getId());
            
            //actualizar precios de productos
            CostoProductoDao cpdao = new CostoProductoDao();
            PrecioProductoDao ppdao = new PrecioProductoDao();
            UnidadProductoDao updao = new UnidadProductoDao();
            float tope = 0.0f;
            for (int d=0; d < detalles.size(); d++){
                Detalle det = detalles.get(d);
                //calcular el precio del producto con el costo y factor actuales
                CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(det.getProducto().getId(), det.getSucursal().getId());
                PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(det.getListaPrecios(), det.getProducto().getId(), det.getSucursal().getId());
                UnidadProducto up = updao.obtener(det.getUnidad().getId(), det.getProducto().getId());
                if (up==null)
                    up = updao.obtenerUnidadInactivaDeProducto(det.getUnidad().getId(), det.getProducto().getId());
                float prenvo = cp.getCosto()*pp.getFactor()*up.getValor();
                tope+=prenvo*det.getCantidad();
                if (prenvo!=det.getPrecio()){
                    det.setPrecio(prenvo);
                    det.setImporte(prenvo*det.getCantidad());
                    movDao.actualizarDetalle(det);
                    detalles.set(d, det);
                }
            }
            //actualizar el tope del ct si cambio
            if (tope!=cab.getCentrotrabajo().getTopeInsumos()){
                CentroTrabDao ctdao = new CentroTrabDao();
                cab.getCentrotrabajo().setTopeInsumos(tope);
                ctdao.actualizar(cab.getCentrotrabajo());
            }
            //fin actualizar precios de productos
            
            for (int j=0; j < detalles.size(); j++){
                Detalle det = detalles.get(j);
                UnidadProductoDao upDao = new UnidadProductoDao();
                UnidadProducto up = upDao.obtener(det.getUnidad().getId(), det.getProducto().getId());
                //si la unidad es null, está dada de baja, obtener la unidad dada de baja
                if (up==null)
                    up = upDao.obtenerUnidadInactivaDeProducto(det.getUnidad().getId(), det.getProducto().getId());
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
        datos.put("acumulado", acum);
        
        return datos;
    }
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }

    public Sesion GenerarPedidos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //obtener las sucursales
                datos = ObtenerSucursales(datos);
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                datos = CargaRutas(datos);
                //obtener almacenes y sus ubicaciones de la sucursal
                datos = CargaAlmacenesDeSucursal(datos);
                datos = ObtenerPeriodo(datos);
                break;
            case -1:
                //cargar rutas de la sucursal seleccionada
                datos = CargaRutas(datos);
                break;
            case 1:
                datos = CalcularProductosAPedir(datos);
                break;
            case 2:
                datos = GeneraPedidos(datos);
                break;
            case 3:
                datos = ObtenerCabecera(datos);
                break;
            case 98: case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }
    
    private HashMap CalcularProductosAPedir(HashMap datos) {
        //obtener las cabeceras de los movimientos de los cts con ruta igual a la seleccionada
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        Ruta rut = (Ruta)datos.get("ruta");
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();        
        MovimientoDao movDao = new MovimientoDao();
        List<HashMap> prodspedir = new ArrayList<HashMap>();
        datos = CalcularAcumulado(datos);
        List<Detalle> acum = (List<Detalle>)datos.get("acumulado");
        //obtener la existencia actual y calcular la cantidad a pedir
        NumberFormat formato = new DecimalFormat("#,##0.00");
        int tipopedido = Integer.parseInt(datos.get("tipopedido").toString());
        for (int i=0; i < acum.size(); i++){
            Detalle det = acum.get(i);
            if (det.getProducto().getSurtido()==tipopedido || suc.getTipo()==0){
                HashMap prodp = new HashMap();
                prodp.put("detalle", det);
                //obtener la existencia actual del producto actual
                ExistenciaDao exDao = new ExistenciaDao();
                float exis = exDao.obtenerExistenciaDeProductoEnAlmacen(det.getAlmacen().getId(), det.getProducto().getId());
                //float cantped = det.getCantidad()-(exis-det.getProducto().getStockMinimo());
                float cantped = det.getCantidad()-exis;//*1.20f;
                if (cantped>=0){
                    prodp.put("existencia", formato.format(exis));
                    prodp.put("pedir", formato.format(Math.round(cantped*1.20f)));
                    prodspedir.add(prodp);
                }
            }
        }
        
        datos.put("acumulado", prodspedir);
        return datos;
    }

    private HashMap GeneraPedidos(HashMap datos) {
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        SucursalDao sucDao = new SucursalDao();
        sucsel = sucDao.obtener(sucsel.getId());
        datos.put("sucursalSel", sucsel);
        Ruta ruta = (Ruta)datos.get("ruta");
        if (ruta.getId()!=-1){
            RutaDao rtDao = new RutaDao();
            ruta = rtDao.obtener(ruta.getId());
            datos.put("ruta", ruta);
        }
        //obtener los proveedores del acumulado
        List<HashMap> prodspedir = (List<HashMap>)datos.get("acumulado");
        List<Proveedor> provs = new ArrayList<Proveedor>();
        for (int i=0; i < prodspedir.size(); i++){
            HashMap prodsp = (HashMap)prodspedir.get(i);
            float pedir = Math.round(Float.parseFloat(prodsp.get("pedir").toString().replace(",", "")));
            Detalle det = (Detalle)prodsp.get("detalle");
            if (pedir>0){
                Proveedor prov = det.getProducto().getProveedor();
                if (provs.isEmpty()){
                    provs.add(prov);
                } else {
                    boolean esta = false;
                    for (int p=0; p < provs.size(); p++){
                        Proveedor lsprov = provs.get(p);
                        if (lsprov.getId()== prov.getId()){
                            esta = true;
                            break;
                        }
                    }
                    if (!esta){
                        provs.add(prov);
                    }
                }
            }
        }
        
        //Obtener el almacen y la ubicacion
        List<Almacen> alms = (List<Almacen>)datos.get("almacenes");
        List<Ubicacion> ubis = (List<Ubicacion>)datos.get("ubicaciones");
        Almacen alm = alms.get(0);
        Ubicacion ubi = ubis.get(0);
        if (alms.size()>1 || ubis.size()>1){
            alm = (Almacen)datos.get("almacen");
            ubi = (Ubicacion)datos.get("ubicacion");
        }
        
        //eliminar los pedidos del mes existentes
        Date fechini = (Date)datos.get("fechai");
        Date fechfin = (Date)datos.get("fechaf");
        Calendar cfech = Calendar.getInstance();
        cfech.setTime(fechini);
        int mes = cfech.get(Calendar.MONTH)+1;
        //para cada proveedor generar su movimiento
        MovimientoDao movDao = new MovimientoDao();
        List<Cabecera> movs = new ArrayList<Cabecera>();
        int tipopedido = Integer.parseInt(datos.get("tipopedido").toString());
        for (int i=0; i < provs.size(); i++){
            Proveedor prov = provs.get(i);
            //obtener el tipomov = 5
            TipoMovDao tmovDao = new TipoMovDao();
            TipoMov tmov = tmovDao.obtener(5);//5= PEDIDO CORPORATIVO,24=PEDIDO LOCAL
            if (tipopedido==2 && sucsel.getTipo()==1)
                tmov = tmovDao.obtener(24);
            movDao.eliminaPedidosDeMesDeSucursalyProv(mes, sucsel.getId(), prov.getId(), tmov.getId());
            //obtener la fecha
            UtilDao utDao = new UtilDao();
            Date hoy = utDao.hoy();
            
            Cabecera cab = new Cabecera();
            cab.setProveedor(prov);
            cab.setTipomov(tmov);
            cab.setSerie(tmov.getSerie());
            cab.setFolio(tmov.getSerie().getFolio().intValue());
            cab.setFechaCaptura(hoy);
            cab.setSucursal(sucsel);
            cab.setEstatus(1);
            cab.setMes(mes);
            //guarda la cabecera
            movDao.guardarCabecera(cab);
            movs.add(cab);
            //actualiza el folio de la serie
            Serie ser = cab.getSerie();
            ser.setFolio(ser.getFolio()+1);
            SerieDao serDao = new SerieDao();
            serDao.actualizar(ser);
            
            
            //obtener y guardar el detalle del pedido
            //List<Detalle> detalle = new ArrayList<Detalle>();
            CostoProductoDao cpdao = new CostoProductoDao();
            for (int p=0; p < prodspedir.size(); p++){
                HashMap prodsp = prodspedir.get(p);
                Detalle deta = (Detalle)prodsp.get("detalle");
                Detalle nvo = new Detalle();
                float cant = Math.round(Float.parseFloat(prodsp.get("pedir").toString().replace(",", "")));
                if (prov.getId()==deta.getProducto().getProveedor().getId()){
                    nvo.setCabecera(cab);
                    nvo.setProducto(deta.getProducto());
                    nvo.setSucursal(sucsel);
                    nvo.setEstatus(1);
                    nvo.setAlmacen(alm);
                    nvo.setUbicacion(ubi);
                    nvo.setCantidad(cant);
                    nvo.setUnidad(deta.getUnidad());
                    CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(deta.getProducto().getId(), sucsel.getId());
                    nvo.setCosto(cp.getCosto());
                    nvo.setPrecio(0);
                    nvo.setImporte(cant*nvo.getCosto());
                    nvo.setCategoria(deta.getProducto().getCategoria());
                    nvo.setSubcategoria(deta.getProducto().getSubcategoria());
                    nvo.setDescripcion(deta.getProducto().getDescripcion());
                    /*nvo.setCostoUltimo(deta.getProducto().getCostoUltimo());
                    nvo.setCostoPromedio(deta.getProducto().getCostoPromedio());
                    nvo.setCostoActual(deta.getProducto().getCostoActual());*/
                    nvo.setDescuento(0);
                    nvo.setDescuento1(deta.getProducto().getDescuento1());
                    nvo.setDescuento2(deta.getProducto().getDescuento2());
                    nvo.setDescuento3(deta.getProducto().getDescuento3());
                    nvo.setDescuento4(deta.getProducto().getDescuento4());
                    nvo.setDescuento5(deta.getProducto().getDescuento5());
                    nvo.setIva(deta.getProducto().getIvaNacional());
                    nvo.setIvaExtranjero(deta.getProducto().getIvaExtranjero());
                    nvo.setIeps(deta.getProducto().getIep());
                    //detalle.add(deta);
                    movDao.guardarDetalle(nvo);
                }
            }
        }
        datos.put("pedidos", movs);
        
        return datos;
    }

    private HashMap CargaAlmacenesDeSucursal(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        AlmacenDao almDao = new AlmacenDao();
        List<Almacen> almacenes = almDao.obtenerListaActivosDeSucursal(suc.getId());
        List<Ubicacion> ubis = new ArrayList<Ubicacion>();
        for (int i=0; i < almacenes.size(); i++){
            Almacen alm = almacenes.get(i);
            UbicacionDao ubiDao = new UbicacionDao();
            ubis.addAll(ubiDao.obtenerListaActivasDeAlmacen(alm.getId()));
        }
        datos.put("almacenes", almacenes);
        datos.put("ubicaciones", ubis);
        return datos;
    }
    
    private HashMap ObtenerCabecera(HashMap datos){
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        cab = movDao.obtenerCabecera(cab.getId());
        datos.put("cabecera", cab);
        datos.put("tipomovSel", cab.getTipomov());
        return datos;
    }

    private HashMap ObtenerCTS(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        Ruta ruta = (Ruta)datos.get("ruta");
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();
        fechaini = fechaini.substring(6,10)+"-"+fechaini.substring(3,5)+"-"+fechaini.substring(0,2);
        fechafin = fechafin.substring(6,10)+"-"+fechafin.substring(3,5)+"-"+fechafin.substring(0,2);
        MovimientoDao movDao = new MovimientoDao();
        List<CentroDeTrabajo> cts = new ArrayList<CentroDeTrabajo>();
        if (!fechaini.equals("") && !fechafin.equals(""))
            cts = movDao.obtenerCTSAcumuladoPeriodo(suc.getId(), ruta.getId(), fechaini, fechafin);
        else if (!fechaini.equals(""))
            cts = movDao.obtenerCTSAcumulado(suc.getId(), ruta.getId(), fechaini);
        else
            cts = movDao.obtenerCTSAcumulado(suc.getId(), ruta.getId(), fechafin);
        
        datos.put("cts", cts);
        return datos;
    }

    private HashMap ObtenerMovimientosDeCts(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        Ruta rut = (Ruta)datos.get("ruta");
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();
        fechaini = fechaini.substring(6,10)+"-"+fechaini.substring(3,5)+"-"+fechaini.substring(0,2);
        fechafin = fechafin.substring(6,10)+"-"+fechafin.substring(3,5)+"-"+fechafin.substring(0,2);
        String cts = datos.get("cts").toString();
        MovimientoDao movDao = new MovimientoDao();
        //obtener los movs
        String consulta = "";
        if (!fechaini.equals("") && !fechafin.equals("")){
            consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                " and fechaCaptura>='"+fechaini+"'"+
                " and fechaCaptura<='"+fechafin+"' and centrotrabajo in ("+cts+")";
        } else if (!fechaini.equals("")){
            consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                " and fechaCaptura='"+fechaini+"'"+
                " and centrotrabajo in ("+cts+")";
        } else {
            consulta = "from Cabecera where estatus=1 and sucursal="+Integer.toString(suc.getId())+
                " and fechaCaptura='"+fechafin+"'"+
                " and centrotrabajo in ("+cts+")";
        }
        List<Cabecera> movs = movDao.obtenerMovimientosFiltrado(consulta);
        String smovs = "";
        for (int i=0; i < movs.size(); i++){
            Cabecera mov = movs.get(i);
            if (smovs.equals(""))
                smovs = Integer.toString(mov.getId());
            else
                smovs += ","+Integer.toString(mov.getId());
        }
        
        HashMap param = (HashMap)datos.get("parametros");
        param.put("MOVS", smovs);
        datos.put("parametros", param);
        
        return datos;
    }
    
    private HashMap ObtenerPeriodo(HashMap datos) {
        UtilDao udao = new UtilDao();
        Calendar cale = Calendar.getInstance();
        cale.setTime(udao.hoy());
        Calendar feci = Calendar.getInstance();
        feci.set(cale.get(cale.YEAR), cale.get(cale.MONTH), 1);
        datos.put("fechai", feci.getTime());
        
        Calendar fecf = Calendar.getInstance();
        int mes = cale.get(cale.MONTH)+1;
        int df = 30;
        switch (mes){
            case 1: case 3: case 5: case 7: case 8: case 10: case 12: df = 31; break;
            case 2: 
                if ((cale.get(cale.YEAR) % 4 == 0) && ((cale.get(cale.YEAR) % 100 != 0) || (cale.get(cale.YEAR) % 400 == 0)))
                    df = 29;
                else
                    df = 28;
                break;
        }
        fecf.set(cale.get(cale.YEAR), cale.get(cale.MONTH), df);
        datos.put("fechaf", fecf.getTime());
        return datos;
    }
}
