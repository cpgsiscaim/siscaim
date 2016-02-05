/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Entidades.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author TEMOC
 */
public class MovimientoMod {
    int grupos = 0;
    public MovimientoMod(){
    }

    public Sesion GestionarMovimientos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        int idop = Integer.parseInt(datos.get("idoperacion").toString());
        switch (paso){
            case 0:
                if (idop!=224){
                    //obtener sucursales y tipos de mov
                    datos = CargarSucursalesYTiposMov(datos);
                    //cargar datos de sucursal del usuario
                    datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                    if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                        datos.put("matriz", "1");
                    else
                        datos.put("matriz", "0");
                    datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                    datos = FiltrarTiposMov(datos);
                    datos = ObtenerLogotipo(datos);
                    //obtener el período inicial, por default el mes actual, si es sal prog del 1 al 8 del mes actual
                    datos = ObtenerPeriodo(datos);
                } else {
                    datos.put("sucursales", ObtenerSucursales());
                    datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                    if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                        datos.put("matriz", "1");
                    else
                        datos.put("matriz", "0");
                    
                    datos = ObtenerAlmacenesDeSucursal(datos);
                    List<Almacen> almacenes = (List<Almacen>)datos.get("almacenes");
                    if (almacenes.size()==1){
                        datos.put("almacenSel", almacenes.get(0));
                    }
                    
                    datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                    datos = ObtenerLogotipo(datos);                    
                }
                
                break;
            case 1:
                //cargar sucursal
                datos = CargaSucursalSel(datos);
                //cargar tipo movimiento
                datos = CargaTipoMovSel(datos);
                //cargar movimientos de la suc seleccionada
                datos = ObtenerMovimientos(datos);
                //carga las rutas
                datos = ObtenerRutas(datos);
                //quitar bandera de filtro por si está activa
                datos.remove("banfiltro");
                break;
            case -1:
                //cargar datos del producto
                datos = CargarDatosDelProducto(datos);
                break;
            case -2:
                datos = CargaContratosDeCliente(datos);
                break;
            case -3:
                datos = CargaCentrosDelContrato(datos);
                break;
            case 2:
                //ir a nuevo movimiento
                datos = CargarCatalogosCabecera(datos);
                //sesion.setPaginaSiguiente(datos.get("paginaSig").toString());
                break;
            case 3: case 5: case 51:
                //guardar mov cab
                datos = GuardaCabecera(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Movimientos/nuevomovimiento.jsp");
                    datos.remove("error");
                } else {
                    datos = GuardaDetalles(datos);
                    String aplicarinv = datos.get("aplicarinv").toString();
                    if (aplicarinv.equals("on")){
                        datos = AplicarMovimiento(datos);
                        datos.remove("aplicarinv");
                    }
                    datos = QuitarCatalogosCabecera(datos);
                    //datos = ObtenerMovimientos(datos);
                    int banfiltro = Integer.parseInt(datos.get("banfiltro")!=null?datos.get("banfiltro").toString():"0");
                    if (banfiltro==0)
                        datos = ObtenerMovimientos(datos);
                    else {
                        MovimientoDao movDao = new MovimientoDao();
                        List<Cabecera> lista = movDao.obtenerMovimientosFiltrado(datos.get("consultafiltro").toString());
                        if (lista.size()>grupos){
                            datos.put("grupos", "1");
                            datos.put("inicial", "1");
                            datos.put("listacompleta", lista);
                            datos = ObtenerGrupoCab(datos);                        
                        } else {
                            datos.put("grupos", "0");
                            datos.put("listadoCab", lista);
                        }
                    }
                }
                break;
            case 4:
                //ir a editar mov cab
                datos = ObtenerCabecera(datos);
                datos = RespaldaMovimiento(datos);
                datos = CargarCatalogosCabecera(datos);
                Cabecera cab = (Cabecera)datos.get("cabecera");
                if (cab.getTipomov().getId()==20 || cab.getTipomov().getId()==21){
                    datos = CargaContratosDeCliente(datos);
                    datos = CargaCentrosDelContrato(datos);
                }
                datos = ObtenerDetalles(datos);
                if (cab.getTipomov().getId()!=25){
                    datos = ObtenerTotalDelMovimiento(datos);
                    datos = ObtenerTotalDescuento(datos);
                }
                break;
            case 6:
                //baja del cliente
                datos = BajaDeCabecera(datos);
                break;
            case 7:
                //ir a inactivos
                datos = ObtenerInactivosCab(datos);
                break;
            case 8:
                //activar cliente
                datos = ActivarCabecera(datos);
                break;
            case 9: case 17:
                //aplicar mov(9) || (17)
                datos = ObtenerCabecera(datos);
                datos = ObtenerDetalles(datos);
                datos = ObtenerTotalDelMovimiento(datos);
                datos = ObtenerTotalDescuento(datos);
                break;
            case 10:
                //ir a nuevo detalle
                datos.put("acciondet", "nuevoDet");
                datos = CargaDatosDeCabecera(datos);
                Cabecera cabe = (Cabecera)datos.get("cabecera");
                if (datos.get("accion").toString().equals("editar")){
                    if (cabe.getTipomov().getId()==6){
                        String sero = datos.get("serori").toString();
                        int folo = Integer.parseInt(datos.get("folori").toString());
                        if (!cabe.getSerieOriginal().equals(sero) || cabe.getFolioOriginal()!=folo)
                            datos = ValidaSerieFolioOriginal(datos);
                        if (datos.get("error")!=null){
                            sesion.setError(true);
                            sesion.setMensaje(datos.get("error").toString());
                            sesion.setPaginaSiguiente("/Inventario/Movimientos/nuevomovimiento.jsp");
                            datos.remove("error");
                            datos.put("bandet", "1");
                        } else {
                            datos = CargarCatalogosDetalle(datos);
                        }
                    } else {
                        datos = CargarCatalogosDetalle(datos);
                    }
                } else {
                    if (cabe.getTipomov().getId()==6){
                    datos = ValidaSerieFolioOriginal(datos);
                    if (datos.get("error")!=null){
                        sesion.setError(true);
                        sesion.setMensaje(datos.get("error").toString());
                        sesion.setPaginaSiguiente("/Inventario/Movimientos/nuevomovimiento.jsp");
                        datos.remove("error");
                        datos.put("bandet", "1");
                    } else {
                        datos = CargarCatalogosDetalle(datos);
                    }
                    } else {
                        datos = CargarCatalogosDetalle(datos);
                    }
                }
                break;
            case 11: 
                //agregar detalles
                datos = AgregarDetalles(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Movimientos/agregardetalle.jsp");
                    datos.remove("error");
                }
                break;
            case 13:
                //guardar detalle
                datos = GuardarDetalle(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Movimientos/nuevomovimientodet.jsp");
                    datos.remove("error");
                }
                //datos = ObtenerTotalDescuento(datos);
                break;
            case 12:
                //ir a editar detalle
                datos.put("acciondet", "editarDet");
                datos = CargaDatosDeCabecera(datos);                
                Cabecera cabee = (Cabecera)datos.get("cabecera");
                if (datos.get("accion").toString().equals("editar")){
                    if (cabee.getTipomov().getId()==6){
                        String sero = datos.get("serori").toString();
                        int folo = Integer.parseInt(datos.get("folori").toString());
                        if (!cabee.getSerieOriginal().equals(sero) || cabee.getFolioOriginal()!=folo)
                            datos = ValidaSerieFolioOriginal(datos);
                        if (datos.get("error")!=null){
                            sesion.setError(true);
                            sesion.setMensaje(datos.get("error").toString());
                            sesion.setPaginaSiguiente("/Inventario/Movimientos/nuevomovimiento.jsp");
                            datos.remove("error");
                            datos.put("bandet", "1");
                        } else {
                            datos = ObtenerDetalle(datos);
                            datos = CargarCatalogosDetalle(datos);
                            datos.put("detallep", datos.get("detalle"));
                            datos = CargarDatosDelProducto(datos);
                        }
                    } else {
                        datos = ObtenerDetalle(datos);
                        datos = CargarCatalogosDetalle(datos);
                        datos.put("detallep", datos.get("detalle"));
                        datos = CargarDatosDelProducto(datos);
                    }
                } else {
                    if (cabee.getTipomov().getId()==6){
                        datos = ValidaSerieFolioOriginal(datos);
                        if (datos.get("error")!=null){
                            sesion.setError(true);
                            sesion.setMensaje(datos.get("error").toString());
                            sesion.setPaginaSiguiente("/Inventario/Movimientos/nuevomovimiento.jsp");
                            datos.remove("error");
                            datos.put("bandet", "1");
                        } else {
                            datos = ObtenerDetalle(datos);
                            datos = CargarCatalogosDetalle(datos);
                            datos.put("detallep", datos.get("detalle"));
                            datos = CargarDatosDelProducto(datos);
                        }
                    } else {
                        datos = ObtenerDetalle(datos);
                        datos = CargarCatalogosDetalle(datos);
                        datos.put("detallep", datos.get("detalle"));
                        datos = CargarDatosDelProducto(datos);
                    }
                }
                break;
            case 14:
                //baja de detalle
                datos = BajaDeDetalle(datos);
                break;
            case 15:
                //ir a inactivos det
                datos = ObtenerDetallesInactivos(datos);
                break;
            case 16:
                datos = ActivarDetalle(datos);
                break;
            case 18:
                datos = AplicarMovimiento(datos);
                break;
            case 20:
                datos = ImportarCompraDePedido(datos);
                break;
            case 21:
                //cargar contratos de cliente
                datos = CargarContratosDeCliente(datos);
                break;
            case 22:
                //guarda cabecera e ir a detalle
                datos = GuardaCabecera(datos);
                //datos = CargarCatalogosDetalle(datos);
                break;
            case 23:
                //importar movimiento seleccionado
                datos = ImportarMovimiento(datos);
                break;
            case 24:
                //ir a importar cotizacion
                datos = CargaCotizaciones(datos);
                break;
            case 25:
                //obtener movs aplicados de suc y tipomov
                datos = ObtenerMovimientosAplicados(datos);
                break;
            case 26:
                //imprimir movimiento
                datos = ObtenerCabecera(datos);
                break;
            case 27: case 41:
                datos = ImprimirReporte(datos);
                break;
            case 28:
                datos = AplicarFiltros(datos);
                List<Cabecera> lista = (List<Cabecera>)datos.get("listadoFil");
                if (lista.size()>0){
                    datos.put("banfiltro", "1");
                    if (lista.size()>grupos){
                        datos.put("grupos", "1");
                        datos.put("inicial", "1");
                        datos.put("listacompleta", lista);
                        datos = ObtenerGrupoCab(datos);                        
                    } else {
                        datos.put("grupos", "0");
                        datos.put("listadoCab", lista);
                        //datos.put("sinresultados", "0");
                    }
                }
                else {
                    //datos.put("sinresultados", "1");
                    //sesion.setPaginaSiguiente("/Empresa/GestionarClientes/filtrarclientes.jsp");
                    datos.remove("banfiltro");
                    datos.remove("listadoFil");
                    datos.remove("condiciones");
                    sesion.setError(true);
                    sesion.setMensaje("Los filtros aplicados no arrojaron resultados");
                }
                break;
            case 29:
                //quitar filtros
                datos.remove("banfiltro");
                datos.remove("listadoFil");
                datos.remove("condiciones");
                datos = ObtenerMovimientos(datos);
                break;
            case 31:
                datos = ImprimirXls(datos);
                break;
            case 40:
                datos = ObtenerAlmacenesDeSucursal(datos);
                List<Almacen> almas = (List<Almacen>)datos.get("almacenes");
                if (almas.size()==1){
                    datos.put("almacenSel", almas.get(0));
                }                
                break;
            case 60:
                //ir al principio
                datos = CargarPrincipioCab(datos);
                break;
            case 61:
                //mostrar anteriores
                datos = CargarAnterioresCab(datos);
                break;
            case 62:
                //mostrar siguientes
                datos = CargarSiguientesCab(datos);
                break;
            case 63:
                //mostrar siguientes
                datos = CargarFinalCab(datos);
                break;
            case 90:
                //cancelar imprimir movimiento
                datos.remove("cabecera");
                break;
            case 91:
                //cancelar importar cotizacion
                datos.remove("cotizaciones");
                break;
            case 92:
                //cancelar importar pedido
                datos.remove("pedidos");
                break;
            case 94:
                //cancelar inactivos det
                datos.remove("inactivosDet");
                break;
            case 95:
                //cancelar nuevo detalle
                datos = QuitarCatalogosDetalle(datos);
                datos.put("bandet", "1");
                break;
            case 96: case 93:
                //cancelar detalles(96) || cancelar aplicar mov (93)
                if (paso!=93)
                    datos = CancelarDetalle(datos);
                datos.remove("detalles");
                datos.remove("cabecera");
                datos.remove("accioncab");
                datos.remove("totalmov");
                datos.remove("totaldesc");
                break;
            case 97:
                //cancelar inactivos cab
                datos.remove("inactivosCab");
                break;
            case 98:
                //cancelar nuevo mov cab
                datos = QuitarCatalogosCabecera(datos);
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
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }
    
    private HashMap CargarSucursalesYTiposMov(HashMap datos) {
        datos.put("sucursales", ObtenerSucursales());
        datos.put("tiposmovs", ObtenerTiposMovs());
        UtilDao utDao = new UtilDao();
        datos.put("hoy", utDao.hoy());
        return datos;
    }
    
    
    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }
    
    private List<TipoMov> ObtenerTiposMovs() {
        TipoMovDao tmovDao = new TipoMovDao();
        return tmovDao.obtenerListaActivos();
    }
    
    private HashMap CargaSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        if (sucSel.getId() != 0){
            SucursalDao sucDao = new SucursalDao();
            datos.put("sucursalSel", sucDao.obtener(sucSel.getId()));
        }
        return datos;
    }
    
    private HashMap CargaTipoMovSel(HashMap datos) {
        TipoMov tmovSel = (TipoMov) datos.get("tipomovSel");
        if (tmovSel.getId() != 0){
            TipoMovDao tmovDao = new TipoMovDao();
            datos.put("tipomovSel", tmovDao.obtener(tmovSel.getId()));
        }
        return datos;
    }
    
    private HashMap ObtenerMovimientos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();
        
        UtilMod utmod = new UtilMod();
        String fechIniSql = utmod.ConvertirFechaASql(fechaini);
        String fechFinSql = utmod.ConvertirFechaASql(fechafin);
        
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaDI = null, fechaDF = null;
        try {
            fechaDI = formatoDelTexto.parse(fechaini);
            fechaDF = formatoDelTexto.parse(fechafin);
        } catch (ParseException ex) {
        }
        datos.put("fechai", fechaDI);
        datos.put("fechaf", fechaDF);
        
        List<Cabecera> listado = new ArrayList<Cabecera>();
        MovimientoDao movDao = new MovimientoDao();
        if (sucSel.getId() != 0){
            if (tmovSel.getId()==7 || tmovSel.getId()==8){
                //si otras entradas u otras salidas
                listado = movDao.obtenerMovimientosOtrasEntradasSalidasPeriodo(sucSel.getId(), tmovSel.getId(), fechIniSql, fechFinSql);
            } else if (tmovSel.getId()==20 || tmovSel.getId()==21){
                listado = movDao.obtenerMovimientosDeSucursalYTipoSPPeriodo(sucSel.getId(), tmovSel.getId(), fechIniSql, fechFinSql);
            } else if (tmovSel.getCategoria()==1)
                listado = movDao.obtenerMovimientosDeSucursalYTipoEntradaPeriodo(sucSel.getId(), tmovSel.getId(), fechIniSql, fechFinSql);
            else if (tmovSel.getCategoria()==2)
                listado = movDao.obtenerMovimientosDeSucursalYTipoSalidaPeriodo(sucSel.getId(), tmovSel.getId(), fechIniSql, fechFinSql);
            else if (tmovSel.getId()==25)
                listado = movDao.obtenerMovimientosDeSucursalYTipoPeriodo(sucSel.getId(), tmovSel.getId(), fechIniSql, fechFinSql);
        }
        //obtener los totales de cada movimientos
        List<Float> totales = new ArrayList<Float>();
        for (int i=0; i < listado.size(); i++){
            Cabecera cab = listado.get(i);
            float total = 0.0f;
            if (cab.getTipomov().getId()==20 || cab.getTipomov().getId()==21)
                total = movDao.obtenerTotalDeMovimientoSP(cab.getId());
            else if (cab.getTipomov().getId()!=25)
                total = movDao.obtenerTotalDeMovimiento(cab.getId());
            totales.add(new Double((utmod.Redondear(total, 2))).floatValue());
        }
        
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompleta", listado);
            datos.put("totalescompleta", totales);
            datos = ObtenerGrupoCab(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("listadoCab", listado);
            datos.put("totales", totales);
        }

        //datos.put("listadoCab", listado);
        //datos.put("condiciones", "");
        //datos.remove("filtro");
        return datos;
    }
    
    private HashMap ObtenerGrupoCab(HashMap datos) {
        List<Cabecera> movs = (List<Cabecera>)datos.get("listacompleta");
        List<Float> totales = (List<Float>)datos.get("totalescompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Cabecera> grupo = new ArrayList<Cabecera>();
        List<Float> tots = new ArrayList<Float>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin > movs.size()){
            fin = movs.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(movs.get(i));
            tots.add(totales.get(i));
        }
        datos.put("listadoCab", grupo);
        datos.put("totales", tots);
        return datos;
    }

    private HashMap CargarCatalogosCabecera(HashMap datos) {
        int paso = Integer.parseInt(datos.get("paso").toString());
        datos.put("accion", "nuevo");
        if (paso == 4)
            datos.put("accion", "editar");
        String titulo = "";
        //segun el tipo de movimiento
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        //datos.put("seriedelmov", tmovSel.getSerie());
        switch (tmovSel.getId()){
            case 5: //pedido
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevopedidocab.jsp");
                titulo = "Nuevo Pedido";
                if (paso == 4)
                    titulo = "Editar Pedido";
                break;
            case 6: //compra
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevopedidocab.jsp");
                titulo = "Nueva Compra";
                if (paso == 4)
                    titulo = "Editar Compra";
                break;
            case 7: //otras salidas
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevootroscab.jsp");
                titulo = "Otra Salida Nueva";
                //obtener los tipos de movimientos para otras entradas
                datos = ObtenerCatalogosOtrasEntradasSalidas(datos);
                if (paso == 4)
                    titulo = "Editar Otra Salida";
                break;
            case 8: //otras entradas
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevootroscab.jsp");
                titulo = "Otra Entrada Nueva";
                //obtener los tipos de movimientos para otras entradas
                datos = ObtenerCatalogosOtrasEntradasSalidas(datos);
                if (paso == 4)
                    titulo = "Editar Otra Entrada";
                break;
            case 9: //cotizacion
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevopedidocab.jsp");
                titulo = "Nueva Cotización";
                if (paso == 4)
                    titulo = "Editar Cotización";
                break;
            case 10: //facturacion (venta)
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevopedidocab.jsp");
                titulo = "Nueva Factura";
                if (paso == 4)
                    titulo = "Editar Factura";
                break;
            case 20: //salida programada
                //datos.put("paginaSig", "/Inventario/Movimientos/nuevopedidocab.jsp");
                titulo = "Nueva Salida Programada de CT";
                if (paso == 4)
                    titulo = "Editar Salida Programada de CT";
                break;
            case 21:
                titulo = "Nueva Salida Extraordinaria de CT";
                if (paso == 4)
                    titulo = "Editar Salida Extraordinaria de CT";
                break;
            case 25:
                titulo = "Nuevo Levantamiento Físico";
                if (paso == 4)
                    titulo = "Editar Levantamiento Físico";
                break;
        }
        datos.put("titulo", titulo);
        
        
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        //cargar proveedores
        if (tmovSel.getCategoria()==1){
            ProveedorDao provDao = new ProveedorDao();
            datos.put("proveedores", provDao.obtenerListaActivos());//.obtenerProveedoresDeSucursal(sucSel.getId()));
        } else if (tmovSel.getCategoria()==2) {
        //cargar clientes
            ClienteDao cliDao = new ClienteDao();
            datos.put("clientes", cliDao.obtenerClientesDeSucursal(sucSel.getId()));
        }
        
        if (tmovSel.getId()==25){
            //obtener el listado de productos activos y sus existencias
            ProductoDao prdao = new ProductoDao();
            List<Producto> productos = prdao.obtenerListaActivos();
            //definir almacenes
            Sucursal suc = (Sucursal)datos.get("sucursalSel");
            AlmacenDao almdao = new AlmacenDao();
            List<Almacen> alms = almdao.obtenerListaActivosDeSucursal(suc.getId());
            //obtener la existencia de cada uno de los productos
            //List<Float> existencias = new ArrayList<Float>();
            List<Detalle> detalles = new ArrayList<Detalle>();
            ExistenciaDao exdao = new ExistenciaDao();
            for (int i=0; i < productos.size(); i++){
                Producto pr = productos.get(i);
                Detalle det = new Detalle();
                float ex = 0.0f;
                for (int a=0; a < alms.size(); a++){
                    Almacen al = alms.get(a);
                    ex = exdao.obtenerExistenciaDeProductoEnAlmacen(al.getId(), pr.getId());
                    det.setAlmacen(al);
                    det.setAuto(1);
                    det.setCantidad(ex);//en cantidad del detalle la existencia actual
                    det.setImporte(0);
                    if (ex>=0)
                        det.setImporte(ex);//en importe la existencia física, por default igual a la ex. actual
                    det.setProducto(pr);
                    det.setCategoria(pr.getCategoria());
                    det.setUnidad(pr.getUnidad());
                    det.setDescripcion(pr.getDescripcion());
                    det.setPrecio(0);
                    det.setCosto(0);
                    det.setCostoUltimo(0);
                    det.setCostoPromedio(0);
                    det.setCostoActual(0);
                    det.setDescuento1(0);
                    det.setDescuento2(0);
                    det.setDescuento3(0);
                    det.setDescuento4(0);
                    det.setDescuento(0);
                    det.setIva(0);
                    det.setIeps(0);
                    det.setIvaExtranjero(0);
                    det.setImprimir(1);
                    //existencias.add(new Float(ex));
                    detalles.add(det);
                }
            }
            datos.put("detalles", detalles);
            //datos.put("existencias", existencias);
        }
        
        return datos;
    }
    
    private HashMap ObtenerCabecera(HashMap datos){
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        cab = movDao.obtenerCabecera(cab.getId());
        
        List<Detalle> detalles = movDao.obtenerDetalleDeMov(cab.getId());
        if (cab.getTipomov().getId()!=25){
            //Actualizar precios de productos del detalle
            CostoProductoDao cpdao = new CostoProductoDao();
            PrecioProductoDao ppdao = new PrecioProductoDao();
            UnidadProductoDao updao = new UnidadProductoDao();
            //boolean actualizacion = false;
            float tope = 0.0f;
            for (int i=0; i < detalles.size(); i++){
                Detalle det = detalles.get(i);
                //calcular el precio del producto con el costo y factor actuales
                CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(det.getProducto().getId(), det.getSucursal().getId());
                PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(det.getListaPrecios()==0?1:det.getListaPrecios(), det.getProducto().getId(), det.getSucursal().getId());
                UnidadProducto up = updao.obtener(det.getUnidad().getId(), det.getProducto().getId());
                if (up==null)
                    up = updao.obtenerUnidadInactivaDeProducto(det.getUnidad().getId(), det.getProducto().getId());
                float prenvo = cp.getCosto()*pp.getFactor()*up.getValor();
                tope+=prenvo*det.getCantidad();
                if (prenvo!=det.getPrecio()){
                    //actualizacion = true;
                    det.setPrecio(prenvo);
                    det.setImporte(prenvo*det.getCantidad());
                    movDao.actualizarDetalle(det);
                    detalles.set(i, det);
                }
            }
            //actualizar el tope del ct si cambio
            if (cab.getCentrotrabajo()!=null && tope!=cab.getCentrotrabajo().getTopeInsumos()){
                CentroTrabDao ctdao = new CentroTrabDao();
                cab.getCentrotrabajo().setTopeInsumos(tope);
                ctdao.actualizar(cab.getCentrotrabajo());
                //actualizar el total del movimiento en el listado
                List<Cabecera> listado = (List<Cabecera>)datos.get("listadoCab");
                List<Float> totales = (List<Float>)datos.get("totales");
                for (int i=0; i < listado.size(); i++){
                    Cabecera mov = listado.get(i);
                    if (cab.getId()==mov.getId()){
                        totales.set(i, tope);
                        break;
                    }
                }
                datos.put("totales", totales);
            }
        }
        datos.put("cabecera", cab);
        datos.put("serori", cab.getSerieOriginal()!=null?cab.getSerieOriginal():"");
        datos.put("folori", Integer.toString(cab.getFolioOriginal()));
        return datos;
    }

    private HashMap BajaDeCabecera(HashMap datos) {
        String varios = datos.get("varios").toString();
        MovimientoDao movDao = new MovimientoDao();
        if (varios.equals("0")){
            Cabecera cab = (Cabecera) datos.get("cabecera");
            movDao.actualizarEstatusCabecera(0, cab.getId());
        } else {
            //dar de baja los movimientos seleccionados
            StringTokenizer tokens=new StringTokenizer(varios, ",");
            while(tokens.hasMoreTokens()){
                movDao.actualizarEstatusCabecera(0, Integer.parseInt(tokens.nextToken()));
            }
        }
        datos = ObtenerMovimientos(datos);
        datos.remove("cabecera");
        datos.remove("varios");
        return datos;
    }

    private HashMap ObtenerInactivosCab(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        List<Cabecera> listado = new ArrayList<Cabecera>();
        MovimientoDao movDao = new MovimientoDao();
        if (tmovSel.getId()!=7 && tmovSel.getId()!=8)
            listado = movDao.obtenerInactivosDeSucursalYTipo(sucSel.getId(), tmovSel.getId());
        else
            listado = movDao.obtenerInactivosOtrasEntradasSalidas(sucSel.getId(), tmovSel.getId());
        datos.put("inactivosCab", listado);
        return datos;
    }
    
    private HashMap ActivarCabecera(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        movDao.actualizarEstatusCabecera(1, cab.getId());
        datos = ObtenerInactivosCab(datos);
        datos = ObtenerMovimientos(datos);
        datos.remove("cabecera");
        return datos;
    }
    
    private HashMap CargarContratosDeCliente(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        ContratoDao conDao = new ContratoDao();
        datos.put("contratos", conDao.obtenerContratosDeCliente(cab.getCliente().getId()));
        return datos;
    }

    private HashMap CargarCatalogosDetalle(HashMap datos) {
        //cargar productos
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        ProductoDao proDao = new ProductoDao();
        List<Producto> prodsact = proDao.obtenerListaActivos();//obtenerActivosDeSucursal(sucSel.getId());//.obtenerListaActivos();
        List<Producto> productos = new ArrayList<Producto>();
        
        if (datos.get("acciondet").toString().equals("editarDet")){
            Detalle det = (Detalle)datos.get("detalle");
            productos.add(det.getProducto());
        }
        
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        if (detalles != null){
            for (int j = 0; j < prodsact.size(); j++){
                Producto prd = prodsact.get(j);
                boolean esta = false;
                for (int i = 0; i < detalles.size(); i++){
                    Detalle dtx = detalles.get(i);
                    Producto prdet = dtx.getProducto();
                    if (prdet.getId()==prd.getId()){
                        esta = true;
                        break;
                    }
                }
                if (!esta)
                    productos.add(prd);
            }
        } else {
            productos.addAll(prodsact);
        }
        
        datos.put("productos", productos);
        //Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        AlmacenDao almaDao = new AlmacenDao();
        List<Almacen> almacenes = almaDao.obtenerListaActivosDeSucursal(sucSel.getId());
        datos.put("almacenes", almacenes);
        //cargar ubicaciones de almacenes
        List<Ubicacion> ubicaciones = new ArrayList<Ubicacion>();
        for (int i=0; i < almacenes.size(); i++){
            Almacen alm = almacenes.get(i);
            UbicacionDao ubiDao = new UbicacionDao();
            List<Ubicacion> ubiAlm = ubiDao.obtenerListaActivasDeAlmacen(alm.getId());
            for (int u=0; u < ubiAlm.size(); u++){
                ubicaciones.add(ubiAlm.get(u));
            }
        }
        datos.put("ubicaciones", ubicaciones);
        return datos;
    }

    private HashMap GuardaCabecera(HashMap datos) {
        MovimientoDao movDao = new MovimientoDao();
        Cabecera cab = (Cabecera)datos.get("cabecera");
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        TipoMovDao tmovDao = new TipoMovDao();
        ClienteDao cliDao = new ClienteDao();
        
            switch (tmov.getId()){
                case 5: case 6://pedidos(5) | compra (6)
                    //obtener el proveedor seleccionado
                    ProveedorDao provDao = new ProveedorDao();
                    cab.setProveedor(provDao.obtener(cab.getProveedor().getId()));
                    break;
                case 9: case 10://cotizacion(9) | factura (10)
                    //obtener el cliente seleccionado
                    cab.setCliente(cliDao.obtener(cab.getCliente().getId()));
                    break;
                case 20: case 21:
                    //obtener el cliente seleccionado
                    datos = CargaDatosDeCabecera(datos);
                    break;
            }
            
        if (datos.get("accion").toString().equals("nuevo")){
            switch (tmov.getId()){
                case 5: case 6: case 9: case 10: case 20: case 21: case 25:
                    //tmov = tmovDao.obtener(tmov.getId());
                    //obtener la serie y el folio
                    cab.setTipomov(tmov);
                    cab.setSerie(tmov.getSerie());
                    cab.setFolio(tmov.getSerie().getFolio().intValue());
                    datos.put("seriedelmov", tmov.getSerie());
                    break;
                case 7: case 8:
                    cab.setTipomov(tmovDao.obtener(cab.getTipomov().getId()));
                    cab.setSerie(cab.getTipomov().getSerie());
                    cab.setFolio(cab.getTipomov().getSerie().getFolio().intValue());
                    datos.put("seriedelmov", cab.getSerie());
                    break;
            }
            
            cab.setSucursal(sucSel);
            cab.setEstatus(1);
            //si mov es compra (6) validar proveedor-serie orig-folio orig no exista
            if (tmov.getId()==6){
                if (!ValidaSerieyFolioOriginal(cab)){
                    datos.put("error", "La Serie y el Folio Original del Proveedor ya existen");
                    return datos;
                }
            }
            movDao.guardarCabecera(cab);
            datos = ActualizaFolioDeSerie(datos,1);//incrementa
            //datos.put("accioncab", "nuevo");
        } else {
            switch (tmov.getId()){
                case 7: case 8://otras salidas (7) | otras entradas (8)
                    TipoMov tmova = (TipoMov) datos.get("tipomovactual");
                    if (tmova.getId()!=cab.getTipomov().getId()){
                        cab.setTipomov(tmovDao.obtener(cab.getTipomov().getId()));
                        cab.setSerie(cab.getTipomov().getSerie());
                        cab.setFolio(cab.getTipomov().getSerie().getFolio().intValue());
                        datos.put("seriedelmov", cab.getSerie());
                        datos = ActualizaFolioDeSerie(datos,1);
                    }
                    break;
                case 6:
                    String serori = datos.get("serori").toString();
                    int folori = Integer.parseInt(datos.get("folori").toString());
                    if (!cab.getSerieOriginal().equals(serori) || cab.getFolioOriginal()!=folori){
                        if (!ValidaSerieyFolioOriginal(cab)){
                            datos.put("error", "La Serie y el Folio Original del Proveedor ya existen");
                            return datos;
                        }
                    }
                    break;
            }
            movDao.actualizarCabecera(cab);
            //datos.put("accioncab", "editar");
        }
        datos.put("cabecera", cab);
        /*int banfiltro = Integer.parseInt(datos.get("banfiltro")!=null?datos.get("banfiltro").toString():"0");
        if (banfiltro==0)
            datos = ObtenerMovimientos(datos);
        else {
            List<Cabecera> lista = movDao.obtenerMovimientosFiltrado(datos.get("consultafiltro").toString());
            if (lista.size()>grupos){
                datos.put("grupos", "1");
                datos.put("inicial", "1");
                datos.put("listacompleta", lista);
                datos = ObtenerGrupoCab(datos);                        
            } else {
                datos.put("grupos", "0");
                datos.put("listadoCab", lista);
            }
        }*/
        /*if (!datos.get("paso").toString().equals("51"))
            datos = ObtenerDetalles(datos);
        //datos = QuitarCatalogosCabecera(datos);*/       
        return datos;
    }

    private HashMap QuitarCatalogosCabecera(HashMap datos) {
        datos.remove("accion");
        datos.remove("cabecera");
        datos.remove("proveedores");
        datos.remove("clientes");
        datos.remove("contratos");
        datos.remove("centros");
        datos.remove("titulo");
        datos.remove("otrostiposmovs");
        datos.remove("detalles");
        datos.remove("cabecera");
        datos.remove("accioncab");
        datos.remove("totalmov");
        datos.remove("totaldesc");
        datos.remove("bandet");
        datos.remove("bancon");
        datos.remove("acciondet");
        datos.remove("serori");
        datos.remove("folori");
        return datos;
    }

    private HashMap ObtenerDetalles(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        /*if (tmov.getId()==20)
            detalles = movDao.obtenerDetalleDeSalidaProgramada(cab.getId());
        else*/
        List<Detalle> detalles = movDao.obtenerDetalleDeMov(cab.getId());
        /*/Actualizar precios de productos del detalle
        CostoProductoDao cpdao = new CostoProductoDao();
        PrecioProductoDao ppdao = new PrecioProductoDao();
        UnidadProductoDao updao = new UnidadProductoDao();
        //boolean actualizacion = false;
        float tope = 0.0f;
        for (int i=0; i < detalles.size(); i++){
            Detalle det = detalles.get(i);
            //calcular el precio del producto con el costo y factor actuales
            CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(det.getProducto().getId(), det.getSucursal().getId());
            PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(det.getListaPrecios(), det.getProducto().getId(), det.getSucursal().getId());
            UnidadProducto up = updao.obtener(det.getUnidad().getId(), det.getProducto().getId());
            if (up==null)
                up = updao.obtenerUnidadInactivaDeProducto(det.getUnidad().getId(), det.getProducto().getId());
            float prenvo = cp.getCosto()*pp.getFactor()*up.getValor();
            tope+=prenvo*det.getCantidad();
            if (prenvo!=det.getPrecio()){
                //actualizacion = true;
                det.setPrecio(prenvo);
                det.setImporte(prenvo*det.getCantidad());
                movDao.actualizarDetalle(det);
                detalles.set(i, det);
            }
        }
        //actualizar el tope del ct si cambio
        if (tope!=cab.getCentrotrabajo().getTopeInsumos()){
            CentroTrabDao ctdao = new CentroTrabDao();
            cab.getCentrotrabajo().setTopeInsumos(tope);
            ctdao.actualizar(cab.getCentrotrabajo());
        }*/
        
        /*if (actualizacion)
            pcts = pctDao.obtenerListaActivosDeCT(ct.getId());*/
        /*if (tmov.getId()==20){
            //quitar los productos a cambio
            List<Detalle> detborrados = datos.get("detborrados")!=null?(List<Detalle>)datos.get("detborrados"):new ArrayList<Detalle>();
            
            for (int i=0; i < detalles.size(); i++){
                Detalle det = detalles.get(i);
                if (det.getImprimir()==0){//det.getCambio()==1 && det.getAuto()==1){
                    detborrados.add(det);
                }
            }
            
            for (int b=0; b < detborrados.size(); b++){
                Detalle detb = detborrados.get(b);
                detalles.remove(detb);
            }
            
            datos.put("detborrados", detborrados);
        }*/
        datos.put("detalles", detalles);
        return datos;
    }

    private HashMap QuitarCatalogosDetalle(HashMap datos) {
        datos.remove("acciondet");
        datos.remove("detalle");
        datos.remove("productos");
        datos.remove("almacenes");
        datos.remove("ubicaciones");
        return datos;
    }

    private HashMap GuardarDetalle(HashMap datos) {
        //obtener la lista de detalles actual
        List<Detalle> detalles = datos.get("detalles")!=null?(List<Detalle>)datos.get("detalles"):new ArrayList<Detalle>();
        Detalle det = (Detalle)datos.get("detalle");
        float total = Float.parseFloat(datos.get("totalmov").toString());
        Cabecera cab = (Cabecera)datos.get("cabecera");
        //obtener el producto completo
        Producto prod = det.getProducto();
        ProductoDao proDao = new ProductoDao();
        prod = proDao.obtener(prod.getId());
        det.setProducto(prod);
            det.setCategoria(det.getProducto().getCategoria());
            det.setSubcategoria(det.getProducto().getSubcategoria());
            det.setDescripcion(det.getProducto().getDescripcion());
            /*det.setCostoUltimo(det.getProducto().getCostoUltimo());
            det.setCostoPromedio(det.getProducto().getCostoPromedio());
            det.setCostoActual(det.getProducto().getCostoActual());*/
            det.setDescuento1(det.getProducto().getDescuento1());
            det.setDescuento2(det.getProducto().getDescuento2());
            det.setDescuento3(det.getProducto().getDescuento3());
            det.setDescuento4(det.getProducto().getDescuento4());
            det.setDescuento5(det.getProducto().getDescuento5());
            det.setIva(det.getProducto().getIvaNacional());
            det.setIvaExtranjero(det.getProducto().getIvaExtranjero());
            det.setIeps(det.getProducto().getIep());
        //obtener la unidad
        Unidad uni = det.getUnidad();
        UnidadDao uniDao = new UnidadDao();
        uni = uniDao.obtener(uni.getId());
        det.setUnidad(uni);
        //si mov es 7 u 8 cargar costo del producto en costo(7) o precio (8)
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        if (tmov.getId()==8){
            //det.setCosto(prod.getCostoUltimo());
        } else if (tmov.getId()==7){
            //det.setPrecio(prod.getCostoUltimo());
        }
        //si mov es 7 u 8 calcular el importe
        if (tmov.getId()==7 || tmov.getId()==8){
            UnidadProductoDao upDao = new UnidadProductoDao();
            UnidadProducto up = upDao.obtener(det.getUnidad().getId(), det.getProducto().getId());
            //det.setImporte(det.getCantidad()*up.getValor()*prod.getCostoUltimo());
        }
        if (det.getImprimir()==1)
            total += det.getImporte();
        else
            total -= det.getImporte();
        if (tmov.getId()==20 || tmov.getId()==21){
            //validar el tope de insumos del ct
            float topei = cab.getCentrotrabajo().getTopeInsumos();
            if (total>topei){
                datos.put("error", "El Tope de Insumos del CT actual ha sido excedido");
                return datos;
            }
        }
        
        //MovimientoDao movDao = new MovimientoDao();
        if (datos.get("acciondet").toString().equals("nuevoDet")){
            Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
            det.setSucursal(sucSel);
            det.setEstatus(1);
            detalles.add(det);
        } else {
            int ind = Integer.parseInt(datos.get("indicedet").toString());
            detalles.set(ind, det);
        }
        //datos = ObtenerDetalles(datos);
        datos.put("detalles", detalles);
        datos = QuitarCatalogosDetalle(datos);
        datos.put("bandet", "1");
        datos = ObtenerTotalDelMovimientoTemp(datos);
        return datos;
    }

    private HashMap ObtenerDetalle(HashMap datos) {
        /*Detalle det = (Detalle)datos.get("detalle");
        MovimientoDao movDao = new MovimientoDao();
        det = movDao.obtenerDetalle(det.getId());*/
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        int indice = Integer.parseInt(datos.get("indicedet").toString());
        datos.put("detalle", detalles.get(indice));
        return datos;
    }

    private HashMap BajaDeDetalle(HashMap datos) {
        /*Detalle det = (Detalle)datos.get("detalle");
        MovimientoDao movDao = new MovimientoDao();
        movDao.actualizarEstatusDetalle(0, det.getId());
        datos = ObtenerDetalles(datos);
        datos.remove("detalle");*/
        String variosdet = datos.get("variosdet").toString();
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        List<Detalle> detborrados = datos.get("detborrados")!=null?(List<Detalle>)datos.get("detborrados"):new ArrayList<Detalle>();
        if (variosdet.equals("0")){
            int indice = Integer.parseInt(datos.get("indicedet").toString());
            Detalle det = detalles.get(indice);
            if (det.getId()!=0)
                detborrados.add(det);
            detalles.remove(indice);
        } else {
            //dar de baja los movimientos seleccionados
            List<Detalle> detborrar = new ArrayList<Detalle>();
            StringTokenizer tokens=new StringTokenizer(variosdet, ",");
            while(tokens.hasMoreTokens()){
                int indice =Integer.parseInt(tokens.nextToken());
                Detalle det = detalles.get(indice);
                if (det.getId()!=0){
                    detborrados.add(det);
                }
                detborrar.add(det);
                //detalles.remove(indice);
            }
            //quitar los detalles del listado
            for (int i=0; i < detborrar.size(); i++){
                Detalle db = detborrar.get(i);
                for (int d = 0; d < detalles.size(); d++){
                    Detalle dl = detalles.get(d);
                    if (db.getProducto().getClave().equals(dl.getProducto().getClave())){
                        detalles.remove(d);
                        break;
                    }
                }
            }
        }
        datos.put("detalles", detalles);
        datos = CalcularTotalesDeDetalles(datos);
        datos.put("detborrados", detborrados);
        datos.remove("indicedet");
        datos.remove("variosdet");
        return datos;
    }

    private HashMap ObtenerDetallesInactivos(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        datos.put("inactivosDet", movDao.obtenerDetalleInactivosDeMov(cab.getId()));        
        return datos;
    }

    private HashMap ActivarDetalle(HashMap datos) {
        Detalle det = (Detalle)datos.get("detalle");
        MovimientoDao movDao = new MovimientoDao();
        movDao.actualizarEstatusDetalle(1, det.getId());
        datos = ObtenerDetallesInactivos(datos);
        datos = ObtenerDetalles(datos);
        datos.remove("detalle");
        return datos;
    }

    private HashMap AplicarMovimiento(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        cab.setEstatus(2);
        MovimientoDao movDao = new MovimientoDao();
        movDao.actualizarCabecera(cab);
        //actualizar existencias
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        UnidadProductoDao upDao = new UnidadProductoDao();
        
        List<Detalle> detAjusteEntrada = new ArrayList<Detalle>();
        List<Detalle> detAjusteSalida = new ArrayList<Detalle>();
        Cabecera ajusteEnt = new Cabecera();
        Cabecera ajusteSal = new Cabecera();
        boolean bAjusteEntrada = false;
        boolean bAjusteSalida = false;
        
        for (int i=0; i < detalles.size(); i++){
            Detalle det = detalles.get(i);
            if (det.getImprimir()==1){
                if (cab.getTipomov().getId()!=25){
                    //obtener la cantidad en unidad minima del producto
                    UnidadProducto up = upDao.obtener(det.getUnidad().getId(), det.getProducto().getId());
                    if (up==null)
                        up = upDao.obtenerUnidadInactivaDeProducto(det.getUnidad().getId(), det.getProducto().getId());
                    float cantidad = det.getCantidad()*up.getValor();
                    Existencia exAct = movDao.obtenerExistenciaActual(det.getAlmacen().getId(), det.getProducto().getId());
                    float nvaEx = 0;
                    if (exAct==null){
                        //guarda el nuevo registro
                        Existencia exNva = new Existencia();
                        exNva.setAlmacen(det.getAlmacen());
                        exNva.setProducto(det.getProducto());
                        if (cab.getTipomov().getCategoria()==1){
                            nvaEx = 0 + cantidad;
                        } else {
                            nvaEx = 0 - cantidad;
                        }                
                        exNva.setExistencia(nvaEx);
                        movDao.guardaExistencia(exNva);
                    }
                    else {
                        if (cab.getTipomov().getCategoria()==1){
                            nvaEx = exAct.getExistencia() + cantidad;
                        } else {
                            nvaEx = exAct.getExistencia() - cantidad;
                        }
                        exAct.setExistencia(nvaEx);
                        movDao.actualizarExistencia(exAct);
                    }
                } else {
                    //si la existencia actual es cero y es igual a la física, no afectar
                    //si la existencia actual es distinta de cero y es igual a la física, no afectar
                    if (!((det.getCantidad()==0 && det.getImporte()==0) || 
                            (det.getCantidad()>0 && det.getCantidad()==det.getImporte()))){
                        //si la existencia actual(cant) es mayor a la física(imp), generar ajuste de inventario salida(22)
                        TipoMovDao tmovDao = new TipoMovDao();
                        Detalle dt = new Detalle();
                        dt.setCabecera(det.getCabecera());
                        dt.setAlmacen(det.getAlmacen());
                        dt.setSucursal(det.getSucursal());
                        dt.setCategoria(det.getCategoria());
                        dt.setProducto(det.getProducto());
                        dt.setUnidad(det.getUnidad());
                        dt.setDescripcion(det.getDescripcion());
                        dt.setCantidad(det.getCantidad());
                        dt.setPrecio(det.getPrecio());
                        dt.setCosto(det.getCosto());
                        dt.setCostoUltimo(det.getCostoUltimo());
                        dt.setCostoPromedio(det.getCostoPromedio());
                        dt.setCostoActual(det.getCostoActual());
                        dt.setDescuento1(det.getDescuento1());
                        dt.setDescuento2(det.getDescuento2());
                        dt.setDescuento3(det.getDescuento3());
                        dt.setDescuento4(det.getDescuento4());
                        dt.setImporte(det.getImporte());
                        dt.setDescuento(det.getDescuento());
                        dt.setIva(det.getIva());
                        dt.setIeps(det.getIeps());
                        dt.setIvaExtranjero(det.getIvaExtranjero());
                        dt.setAuto(det.getAuto());
                        dt.setImprimir(det.getImprimir());
                        dt.setEstatus(1);
                        if (det.getCantidad()>det.getImporte()){
                            if (!bAjusteSalida){
                                ajusteSal.setFechaCaptura((Date)datos.get("hoy"));
                                ajusteSal.setEstatus(2);
                                ajusteSal.setFechaInventario((Date)datos.get("hoy"));
                                TipoMov tmov = tmovDao.obtener(22);
                                ajusteSal.setTipomov(tmov);
                                ajusteSal.setSerie(tmov.getSerie());
                                ajusteSal.setFolio(tmov.getSerie().getFolio().intValue());
                                ajusteSal.setPlazo(0);
                                ajusteSal.setAño(0);
                                ajusteSal.setMes(0);
                                ajusteSal.setDia(0);
                                ajusteSal.setFlete(0);
                                ajusteSal.setSucursal(cab.getSucursal());
                                bAjusteSalida = true;
                            }
                            detAjusteSalida.add(dt);
                        } else if (det.getCantidad()<det.getImporte()){
                            //si la existencia actual es menor a la física, generar ajuste de inventario entrada(2)
                            if (!bAjusteEntrada){
                                ajusteEnt.setFechaCaptura((Date)datos.get("hoy"));
                                ajusteEnt.setEstatus(2);
                                ajusteEnt.setFechaInventario((Date)datos.get("hoy"));
                                TipoMov tmov = tmovDao.obtener(2);
                                ajusteEnt.setTipomov(tmov);
                                ajusteEnt.setSerie(tmov.getSerie());
                                ajusteEnt.setFolio(tmov.getSerie().getFolio().intValue());
                                ajusteEnt.setPlazo(0);
                                ajusteEnt.setAño(0);
                                ajusteEnt.setMes(0);
                                ajusteEnt.setDia(0);
                                ajusteEnt.setFlete(0);
                                ajusteEnt.setSucursal(cab.getSucursal());
                                bAjusteEntrada = true;
                            }
                            detAjusteEntrada.add(dt);                            
                        }
                    }
                }
            }
        }
        
        if (cab.getTipomov().getId()==25){
            //si el mov es levantamiento físico, guardar los mov de ajuste de inventario generados
            
            if (bAjusteEntrada){
                //guarda ajuste de entrada
                movDao.guardarCabecera(ajusteEnt);
                datos.put("seriedelmov", ajusteEnt.getTipomov().getSerie());
                datos = ActualizaFolioDeSerie(datos,1);
                //guarda los detalles del ajuste de entrada
                for (int i=0; i < detAjusteEntrada.size(); i++){
                    Detalle det = detAjusteEntrada.get(i);
                    det.setCabecera(ajusteEnt);
                    det.setCantidad(det.getImporte()-det.getCantidad());
                    det.setImporte(0);
                    movDao.guardarDetalle(det);
                    //actualiza o registra existencia
                    Existencia exAct = movDao.obtenerExistenciaActual(det.getAlmacen().getId(), det.getProducto().getId());
                    float nvaEx = 0;
                    if (exAct==null){
                        //guarda el nuevo registro
                        Existencia exNva = new Existencia();
                        exNva.setAlmacen(det.getAlmacen());
                        exNva.setProducto(det.getProducto());
                        nvaEx = 0 + det.getCantidad();
                        exNva.setExistencia(nvaEx);
                        movDao.guardaExistencia(exNva);
                    }
                    else {
                        nvaEx = exAct.getExistencia() + det.getCantidad();
                        exAct.setExistencia(nvaEx);
                        movDao.actualizarExistencia(exAct);
                    }
                }
            }
            
            if (bAjusteSalida){
                //guarda ajuste de salida
                movDao.guardarCabecera(ajusteSal);
                datos.put("seriedelmov", ajusteSal.getTipomov().getSerie());
                datos = ActualizaFolioDeSerie(datos,1);
                //guarda los detalles del ajuste de entrada
                for (int i=0; i < detAjusteSalida.size(); i++){
                    Detalle det = detAjusteSalida.get(i);
                    det.setCabecera(ajusteSal);
                    det.setCantidad(det.getCantidad()-det.getImporte());
                    det.setImporte(0);
                    movDao.guardarDetalle(det);
                    //actualiza o registra existencia
                    Existencia exAct = movDao.obtenerExistenciaActual(det.getAlmacen().getId(), det.getProducto().getId());
                    //float nvaEx = 0;
                    /*if (exAct==null){
                        //guarda el nuevo registro
                        Existencia exNva = new Existencia();
                        exNva.setAlmacen(det.getAlmacen());
                        exNva.setProducto(det.getProducto());
                        nvaEx = 0 - det.getCantidad();
                        exNva.setExistencia(nvaEx);
                        movDao.guardaExistencia(exNva);
                    }
                    else {*/
                        //nvaEx = ;
                        exAct.setExistencia(exAct.getExistencia() - det.getCantidad());
                        movDao.actualizarExistencia(exAct);
                    //}
                }
            }
        }
        
        datos.remove("cabecera");
        datos.remove("detalles");
        datos = ObtenerMovimientos(datos);
        return datos;
    }

    private HashMap ActualizaFolioDeSerie(HashMap datos, int op) {
        Serie ser = (Serie)datos.get("seriedelmov");
        if (op==1)//aumenta
            ser.setFolio(ser.getFolio()+1);
        else //resta
            ser.setFolio(ser.getFolio()-1);
        SerieDao serDao = new SerieDao();
        serDao.actualizar(ser);
        return datos;
    }

    private HashMap CancelarDetalle(HashMap datos) {
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        if (datos.get("accioncab").toString().equals("nuevo")
                && detalles.size()==0){
            Cabecera cab = (Cabecera)datos.get("cabecera");
            //actualizar la serie
            SerieDao serDao = new SerieDao();
            datos = ActualizaFolioDeSerie(datos, 0);
            //eliminar la cabecera
            MovimientoDao movDao = new MovimientoDao();
            movDao.eliminarCabecera(cab);
            datos = ObtenerMovimientos(datos);
        }
        return datos;
    }

    private HashMap ObtenerTotalDelMovimiento(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        if (cab.getTipomov().getId()==20 || cab.getTipomov().getId()==21)
            datos.put("totalmov", Float.toString(movDao.obtenerTotalDeMovimientoSP(cab.getId())));
        else
            datos.put("totalmov", Float.toString(movDao.obtenerTotalDeMovimiento(cab.getId())));
        return datos;
    }

    private HashMap ImportarCompraDePedido(HashMap datos) {
        //obtener pedidos activos
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        MovimientoDao movDao = new MovimientoDao();
        datos.put("pedidos", movDao.obtenerMovimientosDeSucursalYTipo(sucSel.getId(), 5));
        return datos;
    }

    private HashMap ObtenerTotalDescuento(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        Cabecera cab = (Cabecera)datos.get("cabecera");
        MovimientoDao movDao = new MovimientoDao();
        if (cab.getTipomov().getId()==20 || cab.getTipomov().getId()==21)
            datos.put("totaldesc", Float.toString(movDao.obtenerDesctoDeMovimientoSP(cab.getId(), tmov.getCategoria())));
        else
            datos.put("totaldesc", Float.toString(movDao.obtenerDesctoDeMovimiento(cab.getId(), tmov.getCategoria())));
        return datos;
    }

    private HashMap CargaCotizaciones(HashMap datos) {
        //obtener cotizaciones activos
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        MovimientoDao movDao = new MovimientoDao();
        datos.put("cotizaciones", movDao.obtenerMovimientosDeSucursalYTipo(sucSel.getId(), 9));
        return datos;
    }

    private HashMap ImportarMovimiento(HashMap datos) {
        datos = ObtenerCabecera(datos);
        Cabecera cab = (Cabecera)datos.get("cabecera");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        UtilDao utDao = new UtilDao();
        Cabecera cabimp = new Cabecera();
        cabimp.setSucursal(sucSel);
        cabimp.setTipomov(tmov);
        cabimp.setEstatus(1);
        cabimp.setSerie(tmov.getSerie());
        cabimp.setFolio(tmov.getSerie().getFolio().intValue());
        if (tmov.getCategoria()==1)
            cabimp.setProveedor(cab.getProveedor());
        else
            cabimp.setCliente(cab.getCliente());
        cabimp.setFechaCaptura(utDao.hoy());
        MovimientoDao movDao = new MovimientoDao();
        movDao.guardarCabecera(cabimp);
        //obtener el id de la nueva fact
        cabimp = movDao.obtenerCabeceraPorSerieFolioTipoMov(cabimp.getSerie().getId(), cabimp.getFolio(), cabimp.getTipomov().getId());
        
        datos.put("seriedelmov", tmov.getSerie());
        datos = ActualizaFolioDeSerie(datos,1);//incrementa
        datos = ObtenerMovimientos(datos);
        
        //obtener el detalle de la cotizacion|pedido y guardarla
        datos = ObtenerDetalles(datos);
        List<Detalle> detallesped = (List<Detalle>)datos.get("detalles");
        for (int i=0; i < detallesped.size(); i++){
            Detalle detp = detallesped.get(i);
            Detalle detc = new Detalle();
            detc.setCabecera(cabimp);
            detc.setProducto(detp.getProducto());
            detc.setUnidad(detp.getUnidad());
            detc.setCantidad(detp.getCantidad());
            if (tmov.getCategoria()==1)
                detc.setCosto(detp.getCosto());
            else
                detc.setPrecio(detp.getPrecio());
            detc.setDescuento(detp.getDescuento());
            detc.setImporte(detp.getImporte());
            detc.setAlmacen(detp.getAlmacen());
            detc.setUbicacion(detp.getUbicacion());
            detc.setSucursal(sucSel);
            detc.setCategoria(detc.getProducto().getCategoria());
            detc.setDescripcion(detc.getProducto().getDescripcion());
            /*detc.setCostoUltimo(detc.getProducto().getCostoUltimo());
            detc.setCostoPromedio(detc.getProducto().getCostoPromedio());
            detc.setCostoActual(detc.getProducto().getCostoActual());*/
            detc.setDescuento1(detc.getProducto().getDescuento1());
            detc.setDescuento2(detc.getProducto().getDescuento2());
            detc.setDescuento3(detc.getProducto().getDescuento3());
            detc.setDescuento4(detc.getProducto().getDescuento4());
            detc.setDescuento5(detc.getProducto().getDescuento5());
            detc.setIva(detc.getProducto().getIvaNacional());
            detc.setIvaExtranjero(detc.getProducto().getIvaExtranjero());
            detc.setIeps(detc.getProducto().getIep());
            detc.setEstatus(1);
            movDao.guardarDetalle(detc);
            if (tmov.getId()==6)
                ActualizarCostoUltimo(detc);
        }
        return datos;
    }

    private HashMap ObtenerCatalogosOtrasEntradasSalidas(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        TipoMovDao tmovDao = new TipoMovDao();
        if (tmov.getId()==8)
            datos.put("otrostiposmovs", tmovDao.obtenerTiposMovsOtrasEntradasSalidas(1));
        else
            datos.put("otrostiposmovs", tmovDao.obtenerTiposMovsOtrasEntradasSalidas(2));
        return datos;
    }

    private HashMap ObtenerMovimientosAplicados(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        List<Cabecera> listado = new ArrayList<Cabecera>();
        MovimientoDao movDao = new MovimientoDao();
        if (tmov.getId()==7 || tmov.getId()==8){
            //si otras entradas u otras salidas
            listado = movDao.obtenerAplicadosOtrasEntradasSalidas(sucSel.getId(), tmov.getId());
        } else
            listado = movDao.obtenerAplicadosDeSucursalYTipo(sucSel.getId(), tmov.getId());
        datos.put("listaaplicados", listado);
        return datos;
    }

    private HashMap CargarDatosDelProducto(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        Detalle det = (Detalle)datos.get("detallep");
        ProductoDao proDao = new ProductoDao();
        det.setProducto(proDao.obtener(det.getProducto().getId()));
        datos.put("detallep", det);
        //obtener unidades
        UnidadProductoDao unDao = new UnidadProductoDao();
        datos.put("unidades", unDao.obtenerListaActivasDeProducto(det.getProducto().getId()));
        List<String> precios = new ArrayList<String>();
        List<String> desctos = new ArrayList<String>();
        UtilMod utmod = new UtilMod();
        CostoProductoDao cpdao = new CostoProductoDao();
        CostoProducto costo = cpdao.obtenerCostoDeProductoYSucursal(det.getProducto().getId(), sucSel.getId());
        if (tmov.getCategoria()==1){//entrada
            desctos.add(Float.toString(det.getProducto().getProveedor().getDescuento1()));
            desctos.add(Float.toString(det.getProducto().getProveedor().getDescuento2()));
            desctos.add(Float.toString(det.getProducto().getProveedor().getDescuento3()));
        } else { //salida
            PrecioProductoDao ppdao = new PrecioProductoDao();
            List<PrecioProducto> preciosProd = ppdao.obtenerPreciosDeProductoYSucursal(det.getProducto().getId(), sucSel.getId());
            for (int i=0; i < preciosProd.size(); i++){
                PrecioProducto pp = preciosProd.get(i);
                precios.add(Float.toString(new Double(utmod.Redondear(pp.getFactor()*costo.getCosto(),2)).floatValue()));
            }
            /*precios.add(Float.toString(new Double(utmod.Redondear(det.getProducto().getPrecio1()*det.getProducto().getCostoUltimo(),2)).floatValue()));
            precios.add(Float.toString(new Double(utmod.Redondear(det.getProducto().getPrecio2()*det.getProducto().getCostoUltimo(),2)).floatValue()));
            precios.add(Float.toString(new Double(utmod.Redondear(det.getProducto().getPrecio3()*det.getProducto().getCostoUltimo(),2)).floatValue()));
            precios.add(Float.toString(new Double(utmod.Redondear(det.getProducto().getPrecio4()*det.getProducto().getCostoUltimo(),2)).floatValue()));
            precios.add(Float.toString(new Double(utmod.Redondear(det.getProducto().getPrecio5()*det.getProducto().getCostoUltimo(),2)).floatValue()));*/
            desctos.add(Float.toString(det.getProducto().getDescuento1()));
            desctos.add(Float.toString(det.getProducto().getDescuento2()));
            desctos.add(Float.toString(det.getProducto().getDescuento3()));
            desctos.add(Float.toString(det.getProducto().getDescuento4()));
            desctos.add(Float.toString(det.getProducto().getDescuento5()));
        }
        datos.put("costo", Float.toString(costo.getCosto()));
        datos.put("precios", precios);
        datos.put("descuentos", desctos);
        return datos;
    }

    private HashMap CargaDatosDeCabecera(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        if (datos.get("accion").toString().equals("nuevo")){
            cab.setSucursal(sucSel);
            cab.setEstatus(1);
            switch (tmov.getId()){
                case 5: case 6://pedidos(5) | compra (6)
                    cab.setTipomov(tmov);
                    //obtener el proveedor seleccionado
                    ProveedorDao provDao = new ProveedorDao();
                    cab.setProveedor(provDao.obtener(cab.getProveedor().getId()));
                    break;
                case 7: case 8://otras salidas (7) | otras entradas (8)
                    //obtener el movimiento
                    TipoMov tipomov = cab.getTipomov();
                    TipoMovDao tmDao = new TipoMovDao();
                    tipomov = tmDao.obtener(tipomov.getId());
                    cab.setTipomov(tipomov);
                    //cab.setSerie(tipomov.getSerie());
                    //cab.setFolio(tipomov.getSerie().getFolio().intValue());
                    //datos.put("seriedelmov", cab.getSerie());
                    break;
                case 9: case 10: case 20: case 21://cotizacion(9) | factura (10)
                    cab.setTipomov(tmov);
                    //obtener el cliente seleccionado
                    ClienteDao cliDao = new ClienteDao();
                    cab.setCliente(cliDao.obtener(cab.getCliente().getId()));
                    if (tmov.getId()==20 || tmov.getId()==21){
                        if (Integer.parseInt(datos.get("paso").toString())==-3 
                            || Integer.parseInt(datos.get("paso").toString())>0){
                            ContratoDao conDao = new ContratoDao();
                            cab.setContrato(conDao.obtener(cab.getContrato().getId()));
                            if (Integer.parseInt(datos.get("paso").toString())>0){
                                CentroTrabDao ctDao = new CentroTrabDao();
                                cab.setCentrotrabajo(ctDao.obtener(cab.getCentrotrabajo().getId()));
                            }
                        }
                    }
                        
                    break;
            }
        }
        datos.put("cabecera", cab);
        return datos;
    }

    private HashMap ObtenerTotalDelMovimientoTemp(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        float subt = 0, descto = 0, precos = 0;
        for (int i = 0; i < detalles.size(); i++){
            Detalle dt = detalles.get(i);
            if (dt.getImprimir()==1){
                subt += dt.getImporte();
                precos = dt.getCosto();
                if (tmov.getCategoria()==2)
                    precos = dt.getPrecio();
                descto += dt.getCantidad()*precos*(dt.getDescuento()/100);
            }
        }
        datos.put("totalmov", Float.toString(subt));
        datos.put("totaldesc", Float.toString(descto));
        return datos;
    }

    private HashMap GuardaDetalles(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        if (cab.getTipomov().getId()==6 && cab.getFlete()>0){
            //aplicar el flete a los costos de cada detalle
            //calcular el total
            float total = 0;
            for (int i = 0; i < detalles.size(); i++){
                Detalle det = detalles.get(i);
                if (det.getImprimir()==1)
                    total += det.getImporte();
            }
            //para cada detalle
            UtilMod umod = new UtilMod();
            for (int i = 0; i < detalles.size(); i++){
                Detalle det = detalles.get(i);
                float factor = new Double(umod.Redondear(new Double(det.getImporte()/total), 2)).floatValue();
                float nuevo = new Double(umod.Redondear(new Double(det.getCosto()+((cab.getFlete()*factor)/det.getCantidad())),2)).floatValue();
                det.setCosto(nuevo);
                det.setImporte(det.getCosto()*det.getCantidad());
            }
        }
        
        MovimientoDao movDao = new MovimientoDao();
        if (datos.get("accion").toString().equals("nuevo")){
            //todos los detalles son nuevos
            for (int i=0; i < detalles.size(); i++){
                Detalle det = detalles.get(i);
                det.setCabecera(cab);
                if (cab.getTipomov().getId()==25){
                    det.setEstatus(1);
                    det.setSucursal(cab.getSucursal());
                }
                movDao.guardarDetalle(det);
                //actualiza el costo ultimo
                if (cab.getTipomov().getId()==6)
                    ActualizarCostoUltimo(det);
            }
        } else {
            //borrar los detalles borrados
            List<Detalle> detborrados = datos.get("detborrados")!=null?(List<Detalle>)datos.get("detborrados"):new ArrayList<Detalle>();
            for (int i=0; i < detborrados.size(); i++){
                movDao.eliminarDetalle(detborrados.get(i));
            }
            
            for (int i=0; i < detalles.size(); i++){
                Detalle det = detalles.get(i);
                det.setCabecera(cab);
                if (det.getId()==0)
                    movDao.guardarDetalle(det);
                else
                    movDao.actualizarDetalle(det);
                if (cab.getTipomov().getId()==6)
                    ActualizarCostoUltimo(det);
            }
        }
        return datos;
    }

    private HashMap RespaldaMovimiento(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        datos.put("tipomovactual", cab.getTipomov());
        return datos;
    }
    
    private HashMap CargarSiguientesCab(HashMap datos) {
        int fin = Integer.parseInt(datos.get("final").toString());
        datos.put("inicial", Integer.toString(fin+1));
        datos = ObtenerGrupoCab(datos);
        return datos;
    }

    private HashMap CargarAnterioresCab(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicial").toString())-grupos;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupoCab(datos);
        return datos;
    }

    private HashMap CargarPrincipioCab(HashMap datos) {
        datos.put("inicial", "1");
        datos = ObtenerGrupoCab(datos);        
        return datos;
    }

    private HashMap CargarFinalCab(HashMap datos) {
        List<Cabecera> listacom = (List<Cabecera>)datos.get("listacompleta");
        int total = listacom.size();
        int ini = total-grupos;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupoCab(datos);
        return datos;
    }

    private HashMap CargaContratosDeCliente(HashMap datos) {
        datos.remove("contratos");
        datos.remove("centros");
        datos = CargaDatosDeCabecera(datos);
        Cabecera cab = (Cabecera)datos.get("cabecera");
        Cliente cli = cab.getCliente();
        ContratoDao conDao = new ContratoDao();
        datos.put("contratos", conDao.obtenerContratosDeCliente(cli.getId()));
        datos.put("bancon", "1");
        return datos;
    }

    private HashMap CargaCentrosDelContrato(HashMap datos) {
        datos = CargaDatosDeCabecera(datos);
        Cabecera cab = (Cabecera)datos.get("cabecera");
        CentroTrabDao ctDao = new CentroTrabDao();
        datos.put("centros", ctDao.obtenerCentroDeTrabajosDeContrato(cab.getContrato().getId()));
        datos.put("bancon", "2");
        return datos;
    }

    private HashMap AplicarFiltros(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        String consulta = "";
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        String feci = formato.format((Date)datos.get("fechai"));
        String fecf = formato.format((Date)datos.get("fechaf"));        
        if (tmovSel.getId()==7 || tmovSel.getId()==8){
            String cat = "1";
            if (tmovSel.getId() == 7)
                cat = "2";//otras salidas
            consulta = "from Cabecera where estatus=1 and tipomov in (select id from TipoMov where estatus=2 and categoria=" + cat + ")"+
                    " and sucursal="+Integer.toString(sucSel.getId())+" and fechaCaptura>='"+feci+"' and fechaCaptura<='"+fecf+"'";
        } else if (tmovSel.getId()==20 || tmovSel.getId()==21){
            consulta = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(tmovSel.getId()) +
                    " and sucursal="+Integer.toString(sucSel.getId())+" and contrato.fechaFin>=date(now()) and contrato.estatus=1"+
                    " and cliente.estatus=1 and centrotrabajo.estatus=1 and fechaCaptura>='"+feci+"' and fechaCaptura<='"+fecf+"'";           
        } else if (tmovSel.getCategoria()==1){
            consulta = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(tmovSel.getId()) +
                    " and sucursal="+Integer.toString(sucSel.getId())+" and proveedor.estatus=1"+
                    " and fechaCaptura>='"+feci+"' and fechaCaptura<='"+fecf+"'";
        } else if (tmovSel.getCategoria()==2){
            consulta = "from Cabecera where estatus=1 and tipomov="+ Integer.toString(tmovSel.getId()) +
                    " and sucursal="+Integer.toString(sucSel.getId())+" and cliente.estatus=1"+
                    " and fechaCaptura>='"+feci+"' and fechaCaptura<='"+fecf+"'";
        }

        HashMap filtros = (HashMap) datos.get("filtros");
        String condiciones = "";
        String sfolio = filtros.get("folio").toString();
        if (!sfolio.equals(""))
            condiciones += " and folio="+sfolio;
        
        int coincidencia = Integer.parseInt(filtros.get("coincidencia").toString());
        int opccliente = Integer.parseInt(filtros.get("opccliente")!=null?filtros.get("opccliente").toString():"0");
        String scliente = filtros.get("cliente").toString();
        if (!scliente.equals("")){
            if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
                if (tmovSel.getCategoria()==1){
                    if (coincidencia == 0){
                        if (opccliente == 0)
                            condiciones += " and proveedor.datosfiscales.razonsocial like '%"+scliente+"%'";
                        else
                            condiciones += " and concat(proveedor.datosfiscales.persona.nombre,' ',proveedor.datosfiscales.persona.paterno,' ',proveedor.datosfiscales.persona.materno)"
                                    + " like '%"+scliente+"%'";
                    } else {
                        if (opccliente == 0)
                            condiciones += " and proveedor.datosfiscales.razonsocial = '"+scliente+"'";
                        else
                            condiciones += " and concat(proveedor.datosfiscales.persona.nombre,' ',proveedor.datosfiscales.persona.paterno,' ',proveedor.datosfiscales.persona.materno)"
                                    + " = '"+scliente+"'";
                    }
                } else {
                    if (coincidencia == 0){
                        if (opccliente == 0)
                            condiciones += " and cliente.datosFiscales.razonsocial like '%"+scliente+"%'";
                        else
                            condiciones += " and concat(cliente.datosFiscales.persona.nombre,' ',cliente.datosFiscales.persona.paterno,' ',cliente.datosFiscales.persona.materno)"
                                    + " like '%"+scliente+"%'";
                    } else {
                        if (opccliente == 0)
                            condiciones += " and cliente.datosFiscales.razonsocial = '"+scliente+"'";
                        else
                            condiciones += " and concat(cliente.datosFiscales.persona.nombre,' ',cliente.datosFiscales.persona.paterno,' ',cliente.datosFiscales.persona.materno)"
                                    + " = '"+scliente+"'";
                    }
                }
            } else {
                if (coincidencia == 0){
                    condiciones += " and tipomov.descripcion like '%"+scliente+"%'";
                } else {
                    condiciones += " and tipomov.descripcion = '"+scliente+"'";
                }
            }
        }
        
        /*String fechaini = filtros.get("fechaini").toString();
        String fechafin = filtros.get("fechafin").toString();
        if (!fechaini.equals("") && !fechafin.equals(""))
            condiciones += " and fechaCaptura>='"+fechaini+"' and fechaCaptura<='"+fechafin+"'";
        else if (!fechaini.equals("") && fechafin.equals(""))
            condiciones += " and fechaCaptura='"+fechaini+"'";
        else if (fechaini.equals("") && !fechafin.equals(""))
            condiciones += " and fechaCaptura='"+fechafin+"'";*/
        
        if (tmovSel.getId()==20 || tmovSel.getId()==21){
            String contrato = filtros.get("contrato").toString();
            if (!contrato.equals("")){
                if (coincidencia == 0){
                    condiciones += " and contrato.contrato like '%"+contrato+"%'";
                } else {
                    condiciones += " and contrato.contrato = '"+contrato+"'";
                }
            }
            
            String ct = filtros.get("ct").toString();
            if (!ct.equals("")){
                if (coincidencia == 0){
                    condiciones += " and centrotrabajo.nombre like '%"+ct+"%'";
                } else {
                    condiciones += " and centrotrabajo.nombre = '"+ct+"'";
                }
            }
            String ruta = filtros.get("ruta").toString();
            if (!ruta.equals("")){
                condiciones += " and centrotrabajo.ruta.id="+ruta;
            }
        }
        consulta += condiciones+ " order by fechaCaptura";
        datos.put("consultafiltro", consulta);
        
        MovimientoDao movDao = new MovimientoDao();
        datos.put("listadoFil", movDao.obtenerMovimientosFiltrado(consulta));
        
        return datos;
    }

    private HashMap ObtenerRutas(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        if (tmovSel.getId()==20 || tmovSel.getId()==21){
            RutaDao rutDao = new RutaDao();
            datos.put("rutas", rutDao.obtenerRutasDeSucursal(sucSel.getId()));
        }
        return datos;
    }

    private HashMap FiltrarTiposMov(HashMap datos) {
        String matriz = datos.get("matriz").toString();
        List<TipoMov> tiposmov = (List<TipoMov>)datos.get("tiposmovs");
        if (matriz.equals("0")){
            List<TipoMov> tiposfil = new ArrayList<TipoMov>();
            for (int i=0; i < tiposmov.size(); i++){
                TipoMov tm = tiposmov.get(i);
                if (tm.getId()==20 || tm.getId()==21)
                    tiposfil.add(tm);
            }
            datos.put("tiposmovs", tiposfil);
        }
        return datos;
    }

    private void ActualizarCostoUltimo(Detalle det) {
        ProductoDao prodDao = new ProductoDao();
        Producto prod = det.getProducto();
        prod = prodDao.obtener(prod.getId());
        //obtener unidad producto detalle
        UnidadProductoDao updao = new UnidadProductoDao();
        UnidadProducto updet = updao.obtener(det.getUnidad().getId(), prod.getId());
        Float costo = det.getCosto();
        if (det.getUnidad().getId()!=prod.getUnidad().getId())
            costo = det.getCosto()/updet.getValor();
        
        CostoProductoDao cpdao = new CostoProductoDao();
        if (prod.getAplicarcosto()==1){
            //Aplicar costo en todas las sucursales
            List<CostoProducto> costos = cpdao.obtenerCostosDeProducto(prod.getId());
            for (int i=0; i<costos.size(); i++){
                CostoProducto cp = costos.get(i);
                if (cp.getCosto()!=costo){
                    cp.setCosto(costo);
                    cpdao.actualizar(cp);
                }
            }
        } else {
            //aplicar costo sólo en la sucursal actual
            CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(prod.getId(), det.getSucursal().getId());
            if (cp.getCosto()!=costo){
                cp.setCosto(costo);
                cpdao.actualizar(cp);
            }
        }
        
        //prodDao.actualizar(prod);
    }

    private boolean ValidaSerieyFolioOriginal(Cabecera cab) {
        MovimientoDao movDao = new MovimientoDao();
        String consulta = "from Cabecera where proveedor="+cab.getProveedor().getId()+
                " and folioOriginal="+cab.getFolioOriginal();
        if (!cab.getSerieOriginal().equals(""))
            consulta += " and serieOriginal='"+cab.getSerieOriginal()+"'";
        
        List<Cabecera> lista = movDao.obtenerMovimientosFiltrado(consulta);
        if (lista!=null && !lista.isEmpty())
            return false;
        return true;
    }

    private HashMap ValidaSerieFolioOriginal(HashMap datos) {
        Cabecera cab = (Cabecera)datos.get("cabecera");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        if (tmov.getId()==6){
            if (!ValidaSerieyFolioOriginal(cab)){
                datos.put("error", "La Serie y el Folio Original del Proveedor ya existen");
            }
        }
        return datos;
    }

    private HashMap ImprimirXls(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("reportexls", util.generarXLS(datos.get("reporte").toString(), (Map)datos.get("parametros"), datos.get("temp").toString()));
        return datos;
    }

    private HashMap AgregarDetalles(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoMov tmov = (TipoMov)datos.get("tipomovSel");
        Cabecera cab = (Cabecera)datos.get("cabecera");
        List<Detalle> detalles = datos.get("detalles")!=null?(List<Detalle>)datos.get("detalles"):new ArrayList<Detalle>();
        float cant = Float.parseFloat(datos.get("detcant").toString());
        int tipo = Integer.parseInt(datos.get("dettipo").toString());
        int unidsel = Integer.parseInt(datos.get("unidadsel").toString());
        Almacen alma = new Almacen();
        alma.setId(Integer.parseInt(datos.get("almacensel").toString()));
        Ubicacion ubi = new Ubicacion();
        ubi.setId(Integer.parseInt(datos.get("ubicacionsel").toString()));
        float total = Float.parseFloat(datos.get("totalmov")!=null?datos.get("totalmov").toString():"0");
        String prodssel = datos.get("prodssel").toString();
        String simpr = datos.get("imprimirsel").toString();
        StringTokenizer toks = new StringTokenizer(prodssel,",");
        CostoProductoDao cpdao = new CostoProductoDao();
        PrecioProductoDao ppdao = new PrecioProductoDao();
        while(toks.hasMoreTokens()){
            int idprod = Integer.parseInt(toks.nextToken());
            List<Producto> productos = (List<Producto>)datos.get("productos");
            for (int i=0; i < productos.size(); i++){
                Producto pr = productos.get(i);
                if (pr.getId()==idprod){
                    Detalle nvodet = new Detalle();
                    nvodet.setProducto(pr);
                    nvodet.setCategoria(pr.getCategoria());
                    nvodet.setSubcategoria(pr.getSubcategoria());
                    nvodet.setDescripcion(pr.getDescripcion());
                    //obtener el costo del producto
                    CostoProducto costo = cpdao.obtenerCostoDeProductoYSucursal(idprod, sucSel.getId());
                    nvodet.setCostoActual(costo.getCosto());
                    nvodet.setCostoPromedio(costo.getCosto());
                    nvodet.setCostoUltimo(costo.getCosto());
                    /*nvodet.setCostoUltimo(pr.getCostoUltimo());
                    nvodet.setCostoPromedio(pr.getCostoPromedio());
                    nvodet.setCostoActual(pr.getCostoActual());*/
                    nvodet.setDescuento1(pr.getDescuento1());
                    nvodet.setDescuento2(pr.getDescuento2());
                    nvodet.setDescuento3(pr.getDescuento3());
                    nvodet.setDescuento4(pr.getDescuento4());
                    nvodet.setDescuento5(pr.getDescuento5());
                    nvodet.setIva(pr.getIvaNacional());
                    nvodet.setIvaExtranjero(pr.getIvaExtranjero());
                    nvodet.setIeps(pr.getIep());
                    nvodet.setAlmacen(alma);
                    nvodet.setAuto(0);
                    nvodet.setCambio(tipo);
                    nvodet.setCantidad(cant);
                    nvodet.setEstatus(1);
                    nvodet.setSucursal(sucSel);
                    nvodet.setUbicacion(ubi);
                    nvodet.setDescuento(0);
                    UnidadProductoDao updao = new UnidadProductoDao();
                    UnidadProducto up = new UnidadProducto();
                    if (unidsel==0){//unidad minima
                        up = updao.obtenerUnidadMinimaDeProducto(pr.getId());
                    } else {//obtener empaque
                        up = updao.obtenerUnidadEmpaqueDeProducto(pr.getId());
                    }
                    nvodet.setUnidad(up.getUnidad());
                    //definir costo|precio, descuento, importe
                    if (tmov.getCategoria()==1){
                        //nvodet.setCosto(up.getValor()*pr.getCostoUltimo());
                        nvodet.setCosto(up.getValor()*costo.getCosto());
                        nvodet.setImporte(cant*nvodet.getCosto());
                    } else if (tmov.getCategoria()==2 && tmov.getId()==7){
                        //nvodet.setPrecio(up.getValor()*pr.getCostoUltimo());
                        nvodet.setPrecio(up.getValor()*costo.getCosto());
                        nvodet.setImporte(cant*nvodet.getPrecio());
                    } else if (tmov.getCategoria()==2){
                        Cliente cli = cab.getCliente();
                        PrecioProducto facpre = new PrecioProducto();
                        //nvodet.setPrecio(up.getValor()*pr.getPrecio1()*pr.getCostoUltimo());
                        switch (cli.getListaPrecios()){
                            case 1: //nvodet.setPrecio(up.getValor()*pr.getPrecio1()*pr.getCostoUltimo());
                                facpre = ppdao.obtenerPrecioNDeProductoYSucursal(1, idprod, sucSel.getId());
                                break;
                            case 2: //nvodet.setPrecio(up.getValor()*pr.getPrecio2()*pr.getCostoUltimo());
                                facpre = ppdao.obtenerPrecioNDeProductoYSucursal(2, idprod, sucSel.getId());
                                break;
                            case 3: //nvodet.setPrecio(up.getValor()*pr.getPrecio3()*pr.getCostoUltimo());
                                facpre = ppdao.obtenerPrecioNDeProductoYSucursal(3, idprod, sucSel.getId());
                                break;
                            case 4: //nvodet.setPrecio(up.getValor()*pr.getPrecio4()*pr.getCostoUltimo());
                                facpre = ppdao.obtenerPrecioNDeProductoYSucursal(4, idprod, sucSel.getId());
                                break;
                            case 5: //nvodet.setPrecio(up.getValor()*pr.getPrecio5()*pr.getCostoUltimo());
                                facpre = ppdao.obtenerPrecioNDeProductoYSucursal(5, idprod, sucSel.getId());
                                break;
                            default:
                                facpre = ppdao.obtenerPrecioNDeProductoYSucursal(1, idprod, sucSel.getId());
                                break;
                        }
                        nvodet.setPrecio(up.getValor()*facpre.getFactor()*costo.getCosto());
                        nvodet.setImporte(cant*nvodet.getPrecio());
                    }
                    total += nvodet.getImporte();
                    if (tmov.getId()==20 || tmov.getId()==21){
                        //validar el tope de insumos del ct
                        float topei = cab.getCentrotrabajo().getTopeInsumos();
                        if (total>topei){
                            datos.put("error", "El Tope de Insumos del CT actual ha sido excedido");
                            return datos;
                        }
                    }
                    
                    nvodet.setImprimir(0);
                    if (simpr.equals("on"))
                        nvodet.setImprimir(1);
                    
                    detalles.add(nvodet);
                    break;
                }
            }
        }
        datos.put("detalles", detalles);
        datos = QuitarCatalogosDetalle(datos);
        datos.put("bandet", "1");
        datos.remove("dettipo");
        datos.remove("detcant");
        datos.remove("prodssel");
        datos.remove("unidadsel");
        datos.remove("almacensel");
        datos.remove("ubicacionsel");
        datos = ObtenerTotalDelMovimientoTemp(datos);
        //validar que el total no exceda el tope de insumos
        //si excede
        return datos;
    }

    private HashMap CalcularTotalesDeDetalles(HashMap datos) {
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        float totalmov = 0, totaldesc = 0;
        for (int i=0; i < detalles.size(); i++){
            Detalle d = detalles.get(i);
            totalmov += d.getImporte();
            totaldesc += d.getDescuento();
        }
        datos.put("totalmov", Float.toString(totalmov));
        datos.put("totaldesc", Float.toString(totaldesc));
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

    
    private HashMap ObtenerAlmacenesDeSucursal(HashMap datos) {
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        AlmacenDao almDao = new AlmacenDao();
        datos.put("almacenes", almDao.obtenerListaActivosDeSucursal(sucsel.getId()));
        return datos;
    }
}
