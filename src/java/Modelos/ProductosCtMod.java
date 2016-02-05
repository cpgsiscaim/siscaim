/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.FechasEntregaDao;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.FechasEntrega;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author TEMOC
 */
public class ProductosCtMod {
    public ProductosCtMod(){
    }

    public Sesion GestionarProductosCt(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 1:
                //obtener la lista de productos de ct seleccionado
                datos = ObtenerProductosCt(datos);
                break;
            case 2:
                //ir a nuevo producto
                datos.put("accion", "nuevo");
                datos = CargarCatalogos(datos);
                break;
            case 3: 
                //agregar detalles
                datos = AgregarDetalles(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/agregardetalle.jsp");
                    datos.remove("error");
                }
                break;
            case 5:
                //guardar producto nuevo (3) | editado(5)
                datos = GuardarProductoCt(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/nuevoprodct.jsp");
                    datos.remove("error");
                }
                break;
            case 4:
                //obtener producto ct
                datos = ObtenerProductoCt(datos);
                break;
            case 6:
                //baja de producto ct
                datos = BajaDeProductoCt(datos);
                break;
            case 7:
                datos = ObtenerInactivos(datos);
                break;
            case 8:
                //activar producto
                datos = ActivarProducto(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/prodctinactivos.jsp");
                    datos.remove("error");
                }
                break;
            case 9:
                datos = GenerarProductosPorCT(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                } else if (datos.get("exito")!=null){
                    sesion.setExito(true);
                    sesion.setMensaje(datos.get("exito").toString());
                }
                datos.remove("error");
                datos.remove("exito");
                break;
            case 10:
                datos = ActualizaDatosEditadosEnListado(datos);
                break;
            case 50:
                datos = ObtenerUnidades(datos);
                datos = CargarPrecios(datos);
                break;
            /*case 8:
                //ir a filtrar
                datos = CargarCatalogosProducto(datos);
                break;
            case 9:
                //aplicar filtros
                datos = FiltrarListado(datos);
                List<Producto> lista = (List<Producto>)datos.get("listadoFil");
                if (lista.size()>0){
                    datos.put("listado", lista);
                    datos.put("sinresultados", "0");
                    datos.put("filtro", "1");
                }
                else {
                    datos.put("sinresultados", "1");
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Productos/filtrarproductos.jsp");
                    datos.remove("listadoFil");
                    datos.put("condiciones", "");
                }
                break;
            case 10:
                //quitar filtros
                datos = ObtenerProductos(datos);
                datos.remove("listadoFil");
                datos.remove("filtro");
                break;
            case 96:
                //cancelar filtrar
                datos = RemoverCatalogos(datos);
                break;*/
            case 97:
                //cancelar inactivos
                datos.remove("pctinactivos");
                break;
            case 98:
                //cancelar nueva producto
                datos.remove("accion");
                datos.remove("prodct");
                datos.remove("productosel");
                datos.remove("unidades");
                datos.remove("almacenes");
                datos.remove("ubicaciones");
                datos.remove("diasdis");
                datos.remove("fechascon");
                datos.remove("fechasprod");
                datos.remove("fechasdiscon");
                datos.remove("fechasct");
                datos.remove("fechasdisct");
                break;
            case 99:
                //cancelar gestionar productos de ct
                datos = ActualizaListaCTs(datos);
                datos.remove("productosct");
                datos.remove("centro");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerProductosCt(HashMap datos) {
        int cat = Integer.parseInt(datos.get("categoria").toString());
        ProductosCtDao prodDao = new ProductosCtDao();
        if (cat==1){
            CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
            datos.put("productosct", prodDao.obtenerListaActivosDeCT(ct.getId()));
        } else {
            Contrato con = (Contrato)datos.get("editarContrato");
            datos.put("productosct", prodDao.obtenerListaActivosDeContrato(con.getId()));
        }
        return datos;
    }

    private HashMap GuardarProductoCt(HashMap datos) {
        Cliente cliSel = (Cliente)datos.get("clienteSel");
        Contrato conSel = (Contrato)datos.get("editarContrato");
        int cat = Integer.parseInt(datos.get("categoria").toString());
        ProductosCt prod = (ProductosCt)datos.get("prodct");
        //obtener el producto
        ProductoDao prDao = new ProductoDao();
        prod.setProducto(prDao.obtener(prod.getProducto().getId()));
        //obtener la unidad
        UnidadDao uniDao = new UnidadDao();
        prod.setUnidad(uniDao.obtener(prod.getUnidad().getId()));
        //obtener el almacen
        AlmacenDao almDao = new AlmacenDao();
        prod.setAlmacen(almDao.obtener(prod.getAlmacen().getId()));
        
        prod.setCategoria(cat);
        prod.setEstatus(1);
        prod.setDescripcion(prod.getProducto().getDescripcion());
        ProductosCtDao prodDao = new ProductosCtDao();
        CentroDeTrabajo ctrab = null;        
        if (cat==1){
            ctrab = (CentroDeTrabajo)datos.get("centro");
        }
        if (datos.get("accion").toString().equals("nuevo")){
            prod.setContrato(conSel);
            prod.setCliente(cliSel);
            prod.setCentrotrab(ctrab);
            prod.setListaprecios(cliSel.getListaPrecios());
            prodDao.guardar(prod);
        }else{
            prodDao.actualizar(prod);
            //si tipoentrega es fechas registrar las fechas
            FechasEntregaDao fedao = new FechasEntregaDao();
            fedao.eliminarFechasDeEntidad(3, prod.getId());
            if (prod.getConfigentrega()==1 && prod.getTipoentrega()==1){
                String fechas = datos.get("listafechas").toString();
                StringTokenizer tokens=new StringTokenizer(fechas, ",");
                while(tokens.hasMoreTokens()){
                    //System.out.println(tokens.nextToken());
                    FechasEntrega fent = new FechasEntrega();
                    fent.setEntidad(3);
                    fent.setIdentidad(prod.getId());
                    SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
                    //String strFecha = “2007-12-25″;
                    Date fecha = null;
                    try {
                        fecha = formatoDelTexto.parse(tokens.nextToken());
                    } catch (ParseException ex) {
                        ex.printStackTrace();
                    }
                    fent.setFecha(fecha);
                    fedao.guardar(fent);
                }
            }
        }
        datos = ObtenerProductosCt(datos);
        
        //Actualizar tope de insumos del ct y salidas programadas
        if (prod.getCategoria()==1){
            float tope = 0.0f;
            List<ProductosCt> listado = (List<ProductosCt>)datos.get("productosct");
            for (int i=0; i < listado.size(); i++){
                ProductosCt pct = listado.get(i);
                tope+=pct.getCantidad()*pct.getPrecio();
            }
            CentroTrabDao ctdao = new CentroTrabDao();
            ctrab.setTopeInsumos(tope);
            ctdao.actualizar(ctrab);
            
            ActualizaSalidasProgramadasDeCT(ctrab);
        }
        
        datos.remove("accion");
        datos.remove("prodct");
        datos.remove("productos");
        datos.remove("productosel");
        datos.remove("unidades");
        datos.remove("listafechas");
        datos.remove("diasdis");
        datos.remove("fechascon");
        datos.remove("fechasprod");
        datos.remove("fechasdiscon");
        datos.remove("fechasct");
        datos.remove("fechasdisct");
        return datos;
    }

    private HashMap ObtenerProductoCt(HashMap datos) {
        //ct,cliente,contrato
        datos.put("accion", "editar");
        ProductosCt prodct = (ProductosCt)datos.get("prodct");
        ProductosCtDao prodDao = new ProductosCtDao();
        prodct = prodDao.obtener(prodct.getId());
        datos.put("prodct", prodct);
        datos.put("productosel", prodct.getProducto());
        datos = CargarCatalogos(datos);
        datos = ObtenerUnidades(datos);
        datos = CargarPrecios(datos);
        int cat = Integer.parseInt(datos.get("categoria").toString());
        if (cat==1 ){//&& prodct.getTipo()==0
            //calcular dias u obtener fechas
            CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
            if (ct.getConfigentrega()==0){                
                if (ct.getContrato().getTipoentrega()==0){
                    List<String> diasdis = new ArrayList<String>();
                    UtilMod utmod = new UtilMod();
                    int totdiascon = utmod.DiasEntreFechas(ct.getContrato().getFechaIni(), ct.getContrato().getFechaFin());
                    int totsps = totdiascon / ct.getContrato().getDiasentrega();
                    for (int i=1; i <= totsps; i++){
                        diasdis.add(Integer.toString(ct.getContrato().getDiasentrega()*i));
                    }
                    datos.put("diasdis", diasdis);
                } else if (ct.getContrato().getTipoentrega()==1){
                    //obtener las fechas del contrato
                    FechasEntregaDao fedao = new FechasEntregaDao();
                    List<FechasEntrega> fechascon = fedao.obtenerFechasDeEntidad(1, ct.getContrato().getId());
                    datos.put("fechascon", fechascon);
                    //si el producto ya tiene fechas registradas obtenerlas
                    List<FechasEntrega> fechasprod = fedao.obtenerFechasDeEntidad(3, prodct.getId());
                    datos.put("fechasprod", fechasprod);
                    List<FechasEntrega> fechasdiscon = new ArrayList<FechasEntrega>();
                    fechasdiscon.addAll(fechascon);
                    for (int i=0; i < fechasprod.size(); i++){
                        FechasEntrega fepr = fechasprod.get(i);
                        for (int j=0; j < fechasdiscon.size(); j++){
                            FechasEntrega fedcon = fechasdiscon.get(j);
                            if (fedcon.getFecha().equals(fepr.getFecha())){
                                fechasdiscon.remove(j);
                                break;
                            }
                        }
                    }
                    datos.put("fechasdiscon", fechasdiscon);
                }
            } else if (ct.getConfigentrega()==1){
                if (ct.getTipoentrega()==0){
                    List<String> diasdis = new ArrayList<String>();
                    UtilMod utmod = new UtilMod();
                    int totdiascon = utmod.DiasEntreFechas(ct.getContrato().getFechaIni(), ct.getContrato().getFechaFin());
                    int totsps = totdiascon / ct.getDiasEntrega();
                    for (int i=1; i <= totsps; i++){
                        diasdis.add(Integer.toString(ct.getDiasEntrega()*i));
                    }
                    datos.put("diasdis", diasdis);
                } else if (ct.getTipoentrega()==1){
                    //obtener las fechas del contrato
                    FechasEntregaDao fedao = new FechasEntregaDao();
                    List<FechasEntrega> fechasct = fedao.obtenerFechasDeEntidad(2, ct.getId());
                    datos.put("fechasct", fechasct);
                    //si el producto ya tiene fechas registradas obtenerlas
                    List<FechasEntrega> fechasprod = fedao.obtenerFechasDeEntidad(3, prodct.getId());
                    datos.put("fechasprod", fechasprod);
                    List<FechasEntrega> fechasdisct = new ArrayList<FechasEntrega>();
                    fechasdisct.addAll(fechasct);
                    for (int i=0; i < fechasprod.size(); i++){
                        FechasEntrega fepr = fechasprod.get(i);
                        for (int j=0; j < fechasdisct.size(); j++){
                            FechasEntrega fedcon = fechasdisct.get(j);
                            if (fedcon.getFecha().equals(fepr.getFecha())){
                                fechasdisct.remove(j);
                                break;
                            }
                        }
                    }
                    datos.put("fechasdisct", fechasdisct);
                }
            }
        }
        return datos;
    }

    private HashMap BajaDeProductoCt(HashMap datos) {
        ProductosCt prodct = (ProductosCt)datos.get("prodct");
        ProductosCtDao prodDao = new ProductosCtDao();
        prodct = prodDao.obtener(prodct.getId());
        prodDao.actualizarEstatus(0, prodct.getId());
        datos = ObtenerProductosCt(datos);
        
        //Actualizar tope de insumos del ct y salidas programadas
        int cat = Integer.parseInt(datos.get("categoria").toString());
        CentroDeTrabajo ctrab = (CentroDeTrabajo)datos.get("centro");
        if (cat==1){
            float tope = 0.0f;
            List<ProductosCt> listado = (List<ProductosCt>)datos.get("productosct");
            for (int i=0; i < listado.size(); i++){
                ProductosCt pct = listado.get(i);
                tope+=pct.getCantidad()*pct.getPrecio();
            }
            CentroTrabDao ctdao = new CentroTrabDao();
            ctrab.setTopeInsumos(tope);
            ctdao.actualizar(ctrab);
            
            ActualizaSalidasProgramadasDeCT(ctrab);
        }
        
        datos.remove("prodct");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        int cat = Integer.parseInt(datos.get("categoria").toString());
        ProductosCtDao prodDao = new ProductosCtDao();
        if (cat==1){
            CentroDeTrabajo ctrab = (CentroDeTrabajo)datos.get("centro");
            datos.put("pctinactivos", prodDao.obtenerListaInactivosDeCT(ctrab.getId()));
        } else {
            Contrato con = (Contrato)datos.get("editarContrato");
            datos.put("pctinactivos", prodDao.obtenerListaInactivosDeContrato(con.getId()));
        }
        return datos;
    }

    private HashMap ActivarProducto(HashMap datos) {
        ProductosCt prodct = (ProductosCt)datos.get("prodct");
        ProductosCtDao prodDao = new ProductosCtDao();
        prodct = prodDao.obtener(prodct.getId());
        //validar el producto que se quiere activar: que no esté ya en el listado activo y que el prod no esté dado de baja
        Producto pr = prodct.getProducto();
        List<ProductosCt> listado = (List<ProductosCt>)datos.get("productosct");
        boolean esta = false;
        for (int i=0; i < listado.size(); i++){
            ProductosCt pct = listado.get(i);
            if (pct.getProducto().getId()==pr.getId()){
                esta = true;
                break;
            }
        }
        if (esta){
            datos.put("error", "El producto ya está registrado, no se puede duplicar");
            return datos;
        }
        
        //obtener datos actuales del producto
        ProductoDao prdao = new ProductoDao();
        pr = prdao.obtener(pr.getId());
        if (pr.getEstatus()==0){
            datos.put("error", "El producto está dado de baja del catálogo");
            return datos;
        }
        //si cumple, actualizar los datos de las unidades vigentes
        //obtener unidad de empaque del producto
        UnidadProductoDao updao = new UnidadProductoDao();
        UnidadProducto unemp = updao.obtenerUnidadEmpaqueDeProducto(pr.getId());
        UnidadProducto unmin = updao.obtenerUnidadMinimaDeProducto(pr.getId());
        
        UnidadProducto unact = updao.obtener(prodct.getUnidad().getId(), pr.getId());
        if (unact.getEstatus()==0){
            if (unact.getMinima()==1)
                prodct.setUnidad(unmin.getUnidad());
            else
                prodct.setUnidad(unemp.getUnidad());
            prodDao.actualizar(prodct);
        }
        prodDao.actualizarEstatus(1, prodct.getId());
        
        datos = ObtenerProductosCt(datos);
        //Actualizar tope de insumos del ct y actualizar salidas programadas
        listado = (List<ProductosCt>)datos.get("productosct");
        int cat = Integer.parseInt(datos.get("categoria").toString());
        CentroDeTrabajo ctrab = (CentroDeTrabajo)datos.get("centro");
        if (cat==1){
            float tope = 0.0f;
            for (int i=0; i < listado.size(); i++){
                ProductosCt pct = listado.get(i);
                tope+=pct.getCantidad()*pct.getPrecio();
            }
            CentroTrabDao ctdao = new CentroTrabDao();
            ctrab.setTopeInsumos(tope);
            ctdao.actualizar(ctrab);
            
            ActualizaSalidasProgramadasDeCT(ctrab);
        }
        
        datos = ObtenerInactivos(datos);
        datos.remove("prodct");        
        return datos;
    }

    private HashMap CargarCatalogos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Contrato conSel = (Contrato)datos.get("editarContrato");
        ProductosCtDao prodDao = new ProductosCtDao();
        List<Producto> productos = new ArrayList<Producto>();
        List<Producto> disp = prodDao.obtenerProductosDisponiblesDeContrato(conSel.getId());
        if (datos.get("accion").toString().equals("editar")){
            ProductosCt prodct = (ProductosCt)datos.get("prodct");
            productos.add(prodct.getProducto());
            productos.addAll(disp);
        } else {
            productos.addAll(disp);
        }
        datos.put("productos", productos);
        //obtener almacenes de la sucursal
        //Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        AlmacenDao almDao = new AlmacenDao();
        List<Almacen> almacenes = almDao.obtenerListaActivosDeSucursal(sucSel.getId());
        datos.put("almacenes", almacenes);
        //datos.put("almacenes", almDao.obtenerListaActivosDeSucursal(sucSel.getId()));
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

    private HashMap ObtenerUnidades(HashMap datos) {
        Producto pr = (Producto)datos.get("productosel");
        ProductoDao prDao = new ProductoDao();
        pr = prDao.obtener(pr.getId());
        datos.put("productosel", pr);
        UnidadProductoDao unpDao = new UnidadProductoDao();
        datos.put("unidades", unpDao.obtenerListaActivasDeProducto(pr.getId()));
        return datos;
    }

    private HashMap GenerarProductosPorCT(HashMap datos) {
        Cliente cli = (Cliente)datos.get("clienteSel");
        Contrato con = (Contrato)datos.get("editarContrato");
        ContratoDao condao = new ContratoDao();
        boolean tienects = condao.VerificaSiTieneCTS(con.getId());
        /*CentroTrabDao ctDao = new CentroTrabDao();
        List<CentroDeTrabajo> centros = ctDao.obtenerCentroDeTrabajosDeContrato(con.getId());*/
        if (!tienects){
            datos.put("error", "El Contrato no tiene Centros de Trabajo registrados");
        } else {
            int r = condao.EliminaProdsDeCts(con.getId());
            CentroTrabDao ctDao = new CentroTrabDao();
            List<Integer> centros = ctDao.obtenerIdsDeCTSDeContrato(con.getId());
            double suma = 0;
            for (int i=0; i < centros.size(); i++){
                Integer idct = centros.get(i);
                suma = condao.GenerarProdsDeCt(con.getId(), idct.intValue());
                if (suma<0){
                    datos.put("error", "Hubo un error al generar los productos de CT's");
                    break;
                }
                //actualizar el tope de insumos del ct actual
                CentroDeTrabajo ct = ctDao.obtener(idct.intValue());
                ct.setTopeInsumos(Float.parseFloat(Double.toString(suma)));
                ctDao.actualizar(ct);
                
                //actualizar las salidas programadas
                ActualizaSalidasProgramadasDeCT(ct);
            }
            if (datos.get("error")==null)
                datos.put("exito", "Los Productos por CT se generaron correctamente");
        }
        return datos;
    }

    private void BorraProductosActuales(CentroDeTrabajo ct) {
        ProductosCtDao prodDao = new ProductosCtDao();
        List<ProductosCt> prodsct = prodDao.obtenerListaActivosDeCT(ct.getId());
        if (prodsct!=null && prodsct.size()>0){
            for (int i=0; i < prodsct.size(); i++){
                ProductosCt pr = prodsct.get(i);
                prodDao.eliminar(pr);
            }
        }
    }
    
    private HashMap AgregarDetalles(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cliSel = (Cliente)datos.get("clienteSel");
        Contrato conSel = (Contrato)datos.get("editarContrato");
        int cat = Integer.parseInt(datos.get("categoria").toString());
        float cant = Float.parseFloat(datos.get("detcant").toString());
        int tipo = Integer.parseInt(datos.get("dettipo").toString());
        int unidsel = Integer.parseInt(datos.get("unidadsel").toString());
        Almacen alma = new Almacen();
        alma.setId(Integer.parseInt(datos.get("almacensel").toString()));
        Ubicacion ubi = new Ubicacion();
        ubi.setId(Integer.parseInt(datos.get("ubicacionsel").toString()));
        String simpr = datos.get("imprimirsel").toString();
        String prodssel = datos.get("prodssel").toString();
        StringTokenizer toks = new StringTokenizer(prodssel,",");
        ProductosCtDao prodDao = new ProductosCtDao();
        CostoProductoDao cpdao = new CostoProductoDao();
        PrecioProductoDao ppdao = new PrecioProductoDao();
        CentroDeTrabajo ctrab = null;
        while(toks.hasMoreTokens()){
            int idprod = Integer.parseInt(toks.nextToken());
            List<Producto> productos = (List<Producto>)datos.get("productos");
            for (int i=0; i < productos.size(); i++){
                Producto pr = productos.get(i);
                if (pr.getId()==idprod){
                    ProductosCt prod = new ProductosCt();
                    prod.setProducto(pr);
                    prod.setAlmacen(alma);
                    UnidadProductoDao updao = new UnidadProductoDao();
                    UnidadProducto up = new UnidadProducto();
                    if (unidsel==0){//unidad minima
                        up = updao.obtenerUnidadMinimaDeProducto(pr.getId());
                    } else {//obtener empaque
                        up = updao.obtenerUnidadEmpaqueDeProducto(pr.getId());
                    }
                    prod.setUnidad(up.getUnidad());
                    prod.setTipo(tipo);
                    prod.setCantidad(cant);
                    prod.setCategoria(cat);
                    prod.setEstatus(1);
                    prod.setDescripcion(prod.getProducto().getDescripcion());
                    prod.setListaprecios(cliSel.getListaPrecios());
                    ctrab = null;
                    if (cat==1){
                        ctrab = (CentroDeTrabajo)datos.get("centro");
                    }
                    prod.setContrato(conSel);
                    prod.setCliente(cliSel);
                    prod.setCentrotrab(ctrab);
                    CostoProducto costo = cpdao.obtenerCostoDeProductoYSucursal(idprod, sucSel.getId());
                    PrecioProducto precio = ppdao.obtenerPrecioNDeProductoYSucursal(1, idprod, sucSel.getId());
                    switch (cliSel.getListaPrecios()){
                        case 1: //prod.setPrecio(up.getValor()*pr.getPrecio1()*pr.getCostoUltimo());
                            precio = ppdao.obtenerPrecioNDeProductoYSucursal(1, idprod, sucSel.getId());
                            break;
                        case 2: //prod.setPrecio(up.getValor()*pr.getPrecio2()*pr.getCostoUltimo());
                            precio = ppdao.obtenerPrecioNDeProductoYSucursal(2, idprod, sucSel.getId());
                            break;
                        case 3: //prod.setPrecio(up.getValor()*pr.getPrecio3()*pr.getCostoUltimo());
                            precio = ppdao.obtenerPrecioNDeProductoYSucursal(3, idprod, sucSel.getId());
                            break;
                        case 4: //prod.setPrecio(up.getValor()*pr.getPrecio4()*pr.getCostoUltimo());
                            precio = ppdao.obtenerPrecioNDeProductoYSucursal(4, idprod, sucSel.getId());
                            break;
                        case 5: //prod.setPrecio(up.getValor()*pr.getPrecio5()*pr.getCostoUltimo());
                            precio = ppdao.obtenerPrecioNDeProductoYSucursal(5, idprod, sucSel.getId());
                            break;
                    }
                    prod.setPrecio(up.getValor()*precio.getFactor()*costo.getCosto());
                    prod.setImprimir(0);
                    if (simpr.equals("on"))
                        prod.setImprimir(1);
                    prodDao.guardar(prod);
                }
            }
        }
                
        datos = ObtenerProductosCt(datos);
        //Actualizar tope de insumos del ct y salidas programadas
        if (cat==1){
            float tope = 0.0f;
            List<ProductosCt> listado = (List<ProductosCt>)datos.get("productosct");
            for (int i=0; i < listado.size(); i++){
                ProductosCt pct = listado.get(i);
                tope+=pct.getCantidad()*pct.getPrecio();
            }
            CentroTrabDao ctdao = new CentroTrabDao();
            ctrab.setTopeInsumos(tope);
            ctdao.actualizar(ctrab);
            
            ActualizaSalidasProgramadasDeCT(ctrab);
        }
        
        
        datos.remove("accion");
        datos.remove("productos");
        datos.remove("unidades");
        datos.remove("almacenes");
        datos.remove("ubicaciones");
        datos.remove("detcant");
        datos.remove("dettipo");
        datos.remove("unidadsel");
        datos.remove("almacensel");
        datos.remove("ubicacionsel");
        datos.remove("prodssel");
        return datos;
    }

    private HashMap CargarPrecios(HashMap datos) {
        //Cliente cliSel = (Cliente)datos.get("clienteSel");
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        //ProductosCt prodct = (ProductosCt)datos.get("prodct");
        Producto prod = (Producto)datos.get("productosel");
        List<String> precios = new ArrayList<String>();
        UtilMod utmod = new UtilMod();
         
        CostoProductoDao cpdao = new CostoProductoDao();
        PrecioProductoDao ppdao = new PrecioProductoDao();
        CostoProducto costo = cpdao.obtenerCostoDeProductoYSucursal(prod.getId(), sucSel.getId());
        List<PrecioProducto> preciosProd = ppdao.obtenerPreciosDeProductoYSucursal(prod.getId(), sucSel.getId());
        for (int i=0; i < preciosProd.size(); i++){
            PrecioProducto pp = preciosProd.get(i);
            precios.add(Float.toString(new Double(utmod.Redondear(pp.getFactor()*costo.getCosto(),2)).floatValue()));
        }
        /*precios.add(Float.toString(new Double(utmod.Redondear(prodct.getProducto().getPrecio1()*prodct.getProducto().getCostoUltimo(),2)).floatValue()));
        precios.add(Float.toString(new Double(utmod.Redondear(prodct.getProducto().getPrecio2()*prodct.getProducto().getCostoUltimo(),2)).floatValue()));
        precios.add(Float.toString(new Double(utmod.Redondear(prodct.getProducto().getPrecio3()*prodct.getProducto().getCostoUltimo(),2)).floatValue()));
        precios.add(Float.toString(new Double(utmod.Redondear(prodct.getProducto().getPrecio4()*prodct.getProducto().getCostoUltimo(),2)).floatValue()));
        precios.add(Float.toString(new Double(utmod.Redondear(prodct.getProducto().getPrecio5()*prodct.getProducto().getCostoUltimo(),2)).floatValue()));*/
        datos.put("precios", precios);
        return datos;
    }

    private void ActualizaSalidasProgramadasDeCT(CentroDeTrabajo ct) {
        //obtener la fecha actual
        UtilDao utdao = new UtilDao();
        Date hoy = utdao.hoy();
        //verificar que el ct tenga salidas programadas
        MovimientoDao movdao = new MovimientoDao();
        List<Cabecera> salidas = movdao.obtenerSalidasProgramadasDeCT(ct.getId());
        for (int i=0; i < salidas.size(); i++){
            Cabecera cab = salidas.get(i);
            if ((cab.getFechaCaptura().equals(hoy) || cab.getFechaCaptura().after(hoy))
                    && cab.getEstatus()==1){
                //elimina el detalle del mov
                movdao.eliminaDetalleDeMov(cab.getId());
                //genera el detalle del movimiento
                int res = movdao.generaDetalleDeSalidaProgramada(cab.getId(), ct.getId(), ct.getContrato().getId(), ct.getCliente().getId(), ct.getCliente().getSucursal().getId(), i);
            }
        }
        /*/actualiza tope de insumos del ct
        CentroTrabDao ctdao = new CentroTrabDao();
        double suma = ctdao.obtenerTotalDeCT(ct.getId());
        ct = ctdao.obtener(ct.getId());
        ct.setTopeInsumos(Float.parseFloat(Double.toString(suma)));
        ctdao.actualizar(ct);*/
    }

    private void RegeneraProductosPorCT(ProductosCt prod) {
        Cliente cli = prod.getCliente();
        Contrato con = prod.getContrato();
        ContratoDao condao = new ContratoDao();
        boolean tienects = condao.VerificaSiTieneCTS(con.getId());
        /*CentroTrabDao ctDao = new CentroTrabDao();
        List<CentroDeTrabajo> centros = ctDao.obtenerCentroDeTrabajosDeContrato(con.getId());*/
        if (tienects){
            int r = condao.EliminaProdsDeCts(con.getId());
            CentroTrabDao ctDao = new CentroTrabDao();
            List<Integer> centros = ctDao.obtenerIdsDeCTSDeContrato(con.getId());
            double suma = 0;
            for (int i=0; i < centros.size(); i++){
                Integer idct = centros.get(i);
                suma = condao.GenerarProdsDeCt(con.getId(), idct.intValue());
                //actualizar el tope de insumos del ct actual
                CentroDeTrabajo ct = ctDao.obtener(idct.intValue());
                ct.setTopeInsumos(Float.parseFloat(Double.toString(suma)));
                ctDao.actualizar(ct);
                //actualizar las salidas programadas del ct
                ActualizaSalidasProgramadasDeCT(ct);
            }
        }
    }

    private HashMap ActualizaListaCTs(HashMap datos) {
        int cat = Integer.parseInt(datos.get("categoria").toString());
        if (cat==1){
            Contrato con = (Contrato)datos.get("editarContrato");
            CentroTrabDao ctDao = new CentroTrabDao();
            datos.put("listaCentros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        }
        return datos;
    }

    private HashMap ActualizaDatosEditadosEnListado(HashMap datos) {
        List<ProductosCt> prods = (List<ProductosCt>)datos.get("productosct");
        ProductosCtDao prodDao = new ProductosCtDao();
        for (int i=0; i < prods.size(); i++){
            ProductosCt pct = prods.get(i);
            prodDao.actualizar(pct);
        }
        datos = ObtenerProductosCt(datos);
        
        //Actualizar tope de insumos del ct y salidas programadas
        int cat = Integer.parseInt(datos.get("categoria").toString());
        CentroDeTrabajo ctrab = (CentroDeTrabajo)datos.get("centro");
        if (cat==1){
            float tope = 0.0f;
            List<ProductosCt> listado = (List<ProductosCt>)datos.get("productosct");
            for (int i=0; i < listado.size(); i++){
                ProductosCt pct = listado.get(i);
                tope+=pct.getCantidad()*pct.getPrecio();
            }
            CentroTrabDao ctdao = new CentroTrabDao();
            ctrab.setTopeInsumos(tope);
            ctdao.actualizar(ctrab);
            
            ActualizaSalidasProgramadasDeCT(ctrab);
        }
        
        return datos;
    }
}
