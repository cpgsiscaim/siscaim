/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Entidades.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author TEMOC
 */
public class ProductoMod {
    private int grupos = 0;
    
    public ProductoMod(){
    }

    public Sesion GestionarProductos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //obtener la lista de sucursales activas
                datos.put("sucursales", ObtenerSucursales());
                //cargar datos de sucursal del usuario
                datos.put("sucusuario", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                //datos = ObtenerClientes(datos);
                datos = ObtenerProductos(datos);
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                datos = CargarCatalogosFiltros(datos);
                break;
            case -1:
                //cargar sucursal
                datos = CargaSucursalSel(datos);
                //cargar productos de la sucursal seleccionada
                datos = ObtenerProductos(datos);
                break;
            case 1:
                //ir a nuevo producto
                datos = CargarCatalogosProducto(datos);
                datos.put("accion", "nuevo");
                break;
            case 2: case 4:
                //guardar producto nuevo (2) | editado(4)
                datos = GuardarProducto(datos);
                /*if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Productos/nuevoproducto.jsp");
                    datos.remove("error");
                }*/
                break;
            case 3: case 12:
                //obtener producto
                datos = ObtenerProducto(datos);
                break;
            case 5:
                //baja de producto
                datos = BajaDeProducto(datos);
                break;
            case 6:
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar producto
                datos = ActivarProducto(datos);
                break;
            case 8:
                //ir a filtrar
                datos = CargarCatalogosProducto(datos);
                break;
            case 9:
                //aplicar filtros
                datos = FiltrarListado(datos);
                List<Producto> lista = (List<Producto>)datos.get("listadoFil");
                if (lista.size()>0){
                    if (lista.size()>grupos){
                        datos.put("grupos", "1");
                        datos.put("inicial", "1");
                        datos.put("listacompleta", lista);
                        datos = ObtenerGrupo(datos);
                    } else {
                        datos.put("grupos", "0");
                        datos.put("listado", lista);
                    }
                    datos.put("sinresultados", "0");
                    datos.put("filtro", "1");
                }
                else {
                    datos.put("sinresultados", "1");
                    //sesion.setPaginaSiguiente("/Inventario/Catalogos/Productos/filtrarproductos.jsp");
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
            case 11:
                //ir a unidades de venta
                datos = ObtenerUnidadesDeSalida(datos);
                break;
            case 13:
                //obtener el kardex
                datos = GenerarKardex(datos);
                break;
            case 14: case 15:
                datos = ImprimirListado(datos);
                break;
            case 16:
                datos = ImprimirXls(datos);
                break;
            case 50:
                //ir al principio
                datos = CargarPrincipio(datos);
                break;
            case 51:
                //mostrar anteriores
                datos = CargarAnteriores(datos);
                break;
            case 52:
                //mostrar siguientes
                datos = CargarSiguientes(datos);
                break;
            case 53:
                //mostrar siguientes
                datos = CargarFinal(datos);
                break;            
            case 96:
                //cancelar filtrar
                datos = RemoverCatalogos(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivos");
                break;
            case 95: case 98:
                //cancelar nueva producto
                datos.remove("accion");
                datos.remove("producto");
                break;
            case 99:
                //salir de gestionar productos
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }
    
    private HashMap ObtenerProductos(HashMap datos) {
        //Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Producto> listado = new ArrayList<Producto>();
        //if (sucSel.getId() != 0){
            ProductoDao prodDao = new ProductoDao();
            listado  = prodDao.obtenerListaActivos();//prodDao.obtenerActivosDeSucursal(sucSel.getId());
        //}
        
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompleta", listado);
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("listado", listado);
        }
        //datos = CargarCatalogosFiltros(datos);
        return datos;
    }
    
    private HashMap CargaSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        if (sucSel.getId() != 0){
            SucursalDao sucDao = new SucursalDao();
            datos.put("sucursalSel", sucDao.obtener(sucSel.getId()));
        }
        return datos;
    }

    private HashMap GuardarProducto(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        ProductoDao prodDao = new ProductoDao();
        /*if (datos.get("accion").toString().equals("nuevo") && prodDao.ValidaProducto(prod)){
            datos.put("error", "La Clave de Producto ya existe");
            return datos;
        } else if (datos.get("accion").toString().equals("editar")){
            String clvact = datos.get("claveact").toString();
            if (!clvact.equals(prod.getClave()) && prodDao.ValidaProducto(prod)){
                datos.put("error", "La Clave de Producto ya existe");
                return datos;
            }
        }*/
        
        if (datos.get("accion").toString().equals("nuevo")){
            prod.setEstatus(1);
            //campos inutilizados 04-oct-13
            prod.setIep(0);
            prod.setIvaNacional(16);
            prod.setIvaExtranjero(11);
            prod.setStockMaximo(100);
            prod.setStockMinimo(20);
            //fin campos inutilizados
            prodDao.guardar(prod);
            datos.put("producto", prod);
            GuardarUnidadDeProducto(datos);
            GuardarUnidadDeEmpaque(datos);
            GuardarCostosYPrecios(datos);
        } else {
            prodDao.actualizar(prod);
            ActualizaUnidades(datos);
            ActualizaCostosYPrecios(datos);
        }
        int filtro = Integer.parseInt(datos.get("filtro")!=null?datos.get("filtro").toString():"0");
        if (filtro==0)
            datos = ObtenerProductos(datos);
        datos.remove("accion");
        datos.remove("producto");
        datos.remove("unidadempaque");
        datos.remove("factor");
        datos.remove("costos");
        datos.remove("precios");
        datos = RemoverCatalogos(datos);

        return datos;
    }

    private HashMap ObtenerProducto(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        ProductoDao prodDao = new ProductoDao();
        prod = prodDao.obtener(prod.getId());
        datos.put("producto", prod);
        datos.put("claveact", prod.getClave());
        Unidad uniminact = new Unidad();
        uniminact.setId(prod.getUnidad().getId());
        UnidadDao uniDao = new UnidadDao();
        uniminact = uniDao.obtener(uniminact.getId());
        datos.put("uniminact", uniminact);
        datos = CargarCatalogosProducto(datos);
        //obtener la UnidadProducto empaque
        UnidadProductoDao upDao = new UnidadProductoDao();
        datos.put("unidadempaque", upDao.obtenerUnidadEmpaqueDeProducto(prod.getId()));
        datos.put("uniempact", datos.get("unidadempaque"));
        datos.put("accion", "editar");
        
        //obtener los costos
        CostoProductoDao cpdao = new CostoProductoDao();
        datos.put("costosact", cpdao.obtenerCostosDeProducto(prod.getId()));
        
        //obtener los precios
        PrecioProductoDao ppdao = new PrecioProductoDao();
        datos.put("preciosact", ppdao.obtenerPreciosDeProducto(prod.getId()));
        
        return datos;
    }

    private HashMap BajaDeProducto(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        ProductoDao prodDao = new ProductoDao();
        prodDao.actualizarEstatus(0, prod.getId());
        datos = ObtenerProductos(datos);
        datos.remove("producto");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        //Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        ProductoDao prodDao = new ProductoDao();
        datos.put("inactivos", prodDao.obtenerListaInactivos());//obtenerInactivosDeSucursal(sucSel.getId()));
        return datos;
    }

    private HashMap ActivarProducto(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        ProductoDao prodDao = new ProductoDao();
        prodDao.actualizarEstatus(1, prod.getId());
        datos = ObtenerProductos(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("producto");        
        return datos;
    }

    private HashMap CargarCatalogosProducto(HashMap datos) {
        datos.put("sucursales", ObtenerSucursales());
        MarcaDao marDao = new MarcaDao();
        datos.put("marcas", marDao.obtenerListaActivas());
        UnidadDao uniDao = new UnidadDao();
        datos.put("unidades", uniDao.obtenerListaActivas());
        CategoriaDao catDao = new CategoriaDao();
        datos.put("categorias", catDao.obtenerListaActivas());
        SubcategoriaDao scatDao = new SubcategoriaDao();
        datos.put("subcategorias", scatDao.obtenerListaActivas());
        ProveedorDao provDao = new ProveedorDao();
        datos.put("proveedores", provDao.obtenerListaActivos());
        ProductoDao prodDao = new ProductoDao();
        datos.put("prodsfull", prodDao.obtenerLista());
        UtilDao utDao = new UtilDao();
        datos.put("hoy", utDao.hoy());
        return datos;
    }
    
    private HashMap RemoverCatalogos(HashMap datos){
        //datos.remove("marcas");
        datos.remove("unidades");
        //datos.remove("categorias");
        datos.remove("subcategorias");
        //datos.remove("proveedores");
        datos.remove("prodsfull");
        return datos;
    }

    private HashMap FiltrarListado(HashMap datos) {
        //Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        HashMap filtros = (HashMap) datos.get("filtros");
        //crear la consulta
        String consulta = "from Producto where estatus=1";//+Integer.toString(sucSel.getId());
        String parametros = "";
        /*String fil1 = filtros.get("filtro1").toString();
        String fil2 = filtros.get("filtro2").toString();
        String fil3 = filtros.get("filtro3").toString();
        String fil4 = filtros.get("filtro4").toString();
        if (fil1.equals("on")){*/
            String param1 = filtros.get("descripcion").toString();
            if (!param1.equals(""))
                parametros += " and descripcion like '%"+param1+"%'";
        /*}
        if (fil2.equals("on")){*/
            Proveedor prov = (Proveedor)filtros.get("proveedor");
            if (prov.getId()!=0)
                parametros += " and proveedor="+prov.getId();
        /*}
        if (fil3.equals("on")){*/
            Categoria cat = (Categoria)filtros.get("categoria");
            if (cat.getId()!=0)
                parametros += " and categoria="+cat.getId();
        /*}
        if (fil4.equals("on")){*/
            Marca mar = (Marca)filtros.get("marca");
            if (mar.getId()!=0)
                parametros += " and marca="+mar.getId();
        //}
        
        consulta += parametros + " order by descripcion";
        
        ProductoDao proDao = new ProductoDao();
        datos.put("listadoFil", proDao.obtenerProductosFiltrado(consulta));
        datos.put("condiciones", parametros);
        return datos;
    }

    private HashMap ObtenerUnidadesDeSalida(HashMap datos) {
        datos = ObtenerProducto(datos);
        Producto prod = (Producto)datos.get("producto");
        UnidadProductoDao upDao = new UnidadProductoDao();
        datos.put("unidadesproducto", upDao.obtenerListaActivasDeProductoNoMinNoEmp(prod.getId()));
        return datos;
    }

    private void GuardarUnidadDeProducto(HashMap datos) {
        //guarda la unidad minima del producto
        UnidadProductoDao upDao = new UnidadProductoDao();
        UnidadProducto up = new UnidadProducto();
        Producto prod = (Producto)datos.get("producto");
        up.setProducto(prod);
        up.setUnidad(prod.getUnidad());
        up.setValor(1);
        up.setEstatus(1);
        up.setEmpaque(0);
        up.setMinima(1);
        upDao.guardar(up);
    }

    private HashMap GenerarKardex(HashMap datos) {
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();
        String inisql = fechaini.substring(6,10)+"-"+fechaini.substring(3,5)+"-"+fechaini.substring(0,2);
        String finsql = fechafin.substring(6,10)+"-"+fechafin.substring(3,5)+"-"+fechafin.substring(0,2);
        Producto prod = (Producto)datos.get("producto");
        MovimientoDao movDao = new MovimientoDao();
        datos.put("saldoinicial", Float.toString(movDao.obtenerSaldoInicialProducto(prod.getId(), inisql)));
        datos.put("kardex", movDao.obtenerKardexProducto(prod.getId(), inisql, finsql));
        return datos;
    }

    private HashMap CargarSiguientes(HashMap datos) {
        int fin = Integer.parseInt(datos.get("final").toString());
        datos.put("inicial", Integer.toString(fin+1));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap CargarAnteriores(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicial").toString())-grupos;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap CargarPrincipio(HashMap datos) {
        datos.put("inicial", "1");
        datos = ObtenerGrupo(datos);        
        return datos;
    }

    private HashMap CargarFinal(HashMap datos) {
        List<Producto> listacom = (List<Producto>)datos.get("listacompleta");
        int total = listacom.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap ObtenerGrupo(HashMap datos) {
        List<Producto> productos = (List<Producto>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Producto> grupo = new ArrayList<Producto>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin >= productos.size()){
            fin = productos.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(productos.get(i));
        }
        datos.put("listado", grupo);
        return datos;
    }
    
    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }
    
    private HashMap ImprimirListado(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }

    private void GuardarUnidadDeEmpaque(HashMap datos) {
        //guarda la unidad de empaque del producto
        UnidadProductoDao upDao = new UnidadProductoDao();
        UnidadProducto up = new UnidadProducto();
        Producto prod = (Producto)datos.get("producto");
        up.setProducto(prod);
        Unidad uni = new Unidad();
        uni.setId(Integer.parseInt(datos.get("unidadempaque").toString()));
        UnidadDao unDao = new UnidadDao();
        uni = unDao.obtener(uni.getId());
        up.setUnidad(uni);
        up.setValor(Float.parseFloat(datos.get("factor").toString()));
        up.setEstatus(1);
        up.setEmpaque(1);
        up.setMinima(0);
        upDao.guardar(up);
    }

    private void ActualizaUnidades(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        UnidadProductoDao upDao = new UnidadProductoDao();
        UnidadDao unDao = new UnidadDao();
        //UNIDAD MINIMA
        Unidad uniminact = (Unidad)datos.get("uniminact");
        if (prod.getUnidad().getId()!=uniminact.getId()){
            //actualizar la unidad minima en unidadesxprod
            //poner en baja la unidad minima actual
            UnidadProducto upminact = upDao.obtenerUnidadMinimaDeProducto(prod.getId());
            upminact.setEstatus(0);
            upDao.actualizar(upminact);
            prod.setUnidad(unDao.obtener(prod.getUnidad().getId()));
            UnidadProducto upminnva = new UnidadProducto();
            upminnva.setProducto(prod);
            upminnva.setUnidad(prod.getUnidad());
            upminnva.setValor(1);
            upminnva.setEstatus(1);
            upminnva.setMinima(1);
            upminnva.setEmpaque(0);
            upDao.guardar(upminnva);
        }
        
        //UNIDAD EMPAQUE
        UnidadProducto uniempact = (UnidadProducto)datos.get("uniempact");
        Unidad uniempsel = new Unidad();
        uniempsel.setId(Integer.parseInt(datos.get("unidadempaque").toString()));
        uniempsel = unDao.obtener(uniempsel.getId());
        
        UnidadProducto uniempnva = new UnidadProducto();
        uniempnva.setProducto(prod);
        uniempnva.setUnidad(uniempsel);
        uniempnva.setEstatus(1);
        uniempnva.setEmpaque(1);
        uniempnva.setValor(Float.parseFloat(datos.get("factor").toString()));
        uniempnva.setMinima(0);
        if (uniempact==null){
            upDao.guardar(uniempnva);
        } else if (uniempact.getUnidad().getId()!=uniempsel.getId()){
            //dar de baja la uni emp actual
            uniempact.setEstatus(0);
            upDao.actualizar(uniempact);
            upDao.guardar(uniempnva);
        } else if (uniempact.getValor()!=uniempnva.getValor()){
            uniempact.setValor(uniempnva.getValor());
            upDao.actualizar(uniempact);
        }
    }
    
    private HashMap ImprimirXls(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("reportexls", util.generarXLS(datos.get("reporte").toString(), (Map)datos.get("parametros"), datos.get("temp").toString()));
        return datos;
    }

    private void GuardarCostosYPrecios(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        List<CostoProducto> costos = (List<CostoProducto>)datos.get("costos");
        List<PrecioProducto> precios = (List<PrecioProducto>)datos.get("precios");
        CostoProductoDao cpdao = new CostoProductoDao();
        for (int i=0; i < costos.size(); i++){
            CostoProducto cp = costos.get(i);
            cp.setProducto(prod);
            cpdao.guardar(cp);
        }
        
        PrecioProductoDao ppdao = new PrecioProductoDao();
        for (int i=0; i < precios.size(); i++){
            PrecioProducto pp = precios.get(i);
            pp.setProducto(prod);
            ppdao.guardar(pp);
        }
    }

    private void ActualizaCostosYPrecios(HashMap datos) {
        List<CostoProducto> costos = (List<CostoProducto>)datos.get("costos");
        List<PrecioProducto> precios = (List<PrecioProducto>)datos.get("precios");
        Producto prod = (Producto)datos.get("producto");
        CostoProductoDao cpdao = new CostoProductoDao();
        MovimientoDao movdao = new MovimientoDao();
        for (int i=0; i < costos.size(); i++){
            CostoProducto cp = costos.get(i);
            CostoProducto cpact = cpdao.obtenerCostoDeProductoYSucursal(prod.getId(), cp.getSucursal().getId());
            if (cpact!=null){
                if (cpact.getCosto()!=cp.getCosto()){
                    cpact.setCosto(cp.getCosto());
                    cpdao.actualizar(cpact);
                    //actualizar las salidas programadas con fecha actual o posterior
                    //ActualizaSalidasProgramadasConProductoEnSucursal(prod.getId(), cp.getSucursal().getId());
                    //actualiza el tope de los cts donde esté el producto
                    //ActualizaTopeDeCts(prod.getId(), cp.getSucursal().getId());
                }
            } else {
                cp.setProducto(prod);
                cpdao.guardar(cp);
            }
        }
        
        PrecioProductoDao ppdao = new PrecioProductoDao();
        for (int i=0; i < precios.size(); i++){
            PrecioProducto pp = precios.get(i);
            PrecioProducto ppact = ppdao.obtenerPrecioNDeProductoYSucursal(pp.getNum(), prod.getId(), pp.getSucursal().getId());
            if (ppact!=null){
                if (ppact.getFactor()!=pp.getFactor()){
                    ppact.setFactor(pp.getFactor());
                    ppdao.actualizar(ppact);
                    //actualizar las salidas programadas con fecha actual o posterior
                    //ActualizaSalidasProgramadasConProductoEnSucursal(prod.getId(), pp.getSucursal().getId());
                    //actualiza el tope de los cts donde esté el producto
                    //ActualizaTopeDeCts(prod.getId(), pp.getSucursal().getId());
                }
            } else {
                pp.setProducto(prod);
                ppdao.guardar(pp);
            }
        }        
    }
    
    private HashMap CargarCatalogosFiltros(HashMap datos) {
        MarcaDao marDao = new MarcaDao();
        datos.put("marcas", marDao.obtenerListaActivas());
        CategoriaDao catDao = new CategoriaDao();
        datos.put("categorias", catDao.obtenerListaActivas());
        ProveedorDao provDao = new ProveedorDao();
        datos.put("proveedores", provDao.obtenerListaActivos());
        return datos;
    }

    private void ActualizaSalidasProgramadasConProductoEnSucursal(int idprod, int idsuc) {
        //obtener los registros de las salidas programadas que serán actualizados
        MovimientoDao movdao = new MovimientoDao();
        String sql = "from Detalle where cabecera in (select id from Cabecera "+
                "where fechaCaptura>=date(now()) and tipomov in (20,21) and sucursal="+Integer.toString(idsuc)+
                ") and producto="+Integer.toString(idprod);
        List<Detalle> detalles = movdao.obtenerDetallesDeSql(sql);
        PrecioProductoDao ppdao = new PrecioProductoDao();
        CostoProductoDao cpdao = new CostoProductoDao();
        UnidadProductoDao updao = new UnidadProductoDao();
        for (int i=0; i < detalles.size(); i++){
            Detalle det = detalles.get(i);
            PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(det.getListaPrecios(), idprod, idsuc);
            CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(idprod, idsuc);
            UnidadProducto up = updao.obtener(det.getUnidad().getId(), idprod);
            if (up == null)
                up = updao.obtenerUnidadInactivaDeProducto(det.getUnidad().getId(), idprod);
            float prenvo = up.getValor()*pp.getFactor()*cp.getCosto();
            det.setPrecio(prenvo);
            det.setImporte(det.getCantidad()*prenvo);
            movdao.actualizarDetalle(det);
        }
    }

    private void ActualizaTopeDeCts(int idprod, int idsuc) {
        //ProductoDao prodao = new ProductoDao();
        //Producto prod = prodao.obtener(idprod);
        //Actualiza el precio en el producto del ct y el tope del ct
        ProductosCtDao pctdao = new ProductosCtDao();
        CentroTrabDao ctdao = new CentroTrabDao();
        String sql = "from CentroDeTrabajo where id in (select distinct centrotrab"
                + " from ProductosCt where contrato.sucursal="+Integer.toString(idsuc)+
                " and producto="+Integer.toString(idprod)+")";
        List<CentroDeTrabajo> cts = ctdao.obtenerCtsDeSql(sql);
        PrecioProductoDao ppdao = new PrecioProductoDao();
        CostoProductoDao cpdao = new CostoProductoDao();
        UnidadProductoDao updao = new UnidadProductoDao();
        for (int i=0; i < cts.size(); i++){
            CentroDeTrabajo ct = cts.get(i);
            //obtener producto de ct para actualizar el precio
            ProductosCt pct = pctdao.obtenerProductoCtDeProdYCt(idprod, ct.getId());
            float impant = pct.getCantidad()*pct.getPrecio();
            ProductosCt prcon = pctdao.obtenerPctDeContratoDeProdYCon(idprod, ct.getContrato().getId());
            PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(pct.getListaprecios(), idprod, idsuc);
            CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(idprod, idsuc);
            UnidadProducto up = updao.obtener(pct.getUnidad().getId(), idprod);
            if (up == null)
                up = updao.obtenerUnidadInactivaDeProducto(pct.getUnidad().getId(), idprod);
            float prenvo = up.getValor()*pp.getFactor()*cp.getCosto();
            pct.setPrecio(prenvo);
            pctdao.actualizar(pct);
            if (prcon!=null){
                prcon.setPrecio(prenvo);
                pctdao.actualizar(prcon);
            }
            float impnue = pct.getCantidad()*pct.getPrecio();
            
            float topeact = ct.getTopeInsumos();
            float topenvo = topeact-impant+impnue;
            /*/obtener la lista de productos para calcular el tope
            List<ProductosCt> lista = pctdao.obtenerListaActivosDeCT(ct.getId());
            float tope = 0.0f;
            for (int p=0; p < lista.size(); p++){
                ProductosCt pc = lista.get(p);
                tope+=pc.getCantidad()*pc.getPrecio();
            }*/
            ct.setTopeInsumos(topenvo);
            ctdao.actualizar(ct);
        }
    }
}
