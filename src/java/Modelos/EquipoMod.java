/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoActivoDao;
import Modelo.Daos.EquipoDao;
import Modelo.Daos.ServicioDao;
import Modelo.Daos.SucursalDao;
import Modelo.Entidades.Catalogos.TipoActivo;
import Modelo.Entidades.Equipo;
import Modelo.Entidades.Sucursal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class EquipoMod {
    public EquipoMod(){
    }

    public Sesion GestionarEquipos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener sucursales y tipos de mov
                datos = CargarSucursalesYTiposActivos(datos);
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                break;
            case 1:
                //cargar sucursal
                datos = CargaSucursalSel(datos);
                //cargar tipo movimiento
                datos = CargaTipoActivoSel(datos);
                //cargar clientes de la sucursal seleccionada
                datos = ObtenerActivos(datos);
                break;
            case 2:
                //ir a nuevo activo
                datos.put("accion", "nuevo");
                break;
            case 3: case 5:
                //guardar activo
                datos = GuardaActivo(datos);
                break;
            case 4:
                //ir a editar activo
                datos = ObtenerActivo(datos);
                break;
            case 6:
                //baja del cliente
                datos = BajaDeActivo(datos);
                break;
            case 7:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 8:
                //activar cliente
                datos = ActivarActivo(datos);
                break;
            case 9: case 17:
                //ir a servicios(9) || aplicar mov (17)
                datos = ObtenerServicios(datos);
                //datos = ObtenerDetalles(datos);
                break;
            /*case 10:
                //ir a nuevo detalle
                datos = CargarCatalogosDetalle(datos);
                datos.put("accion", "nuevoDet");
                break;
            case 11: case 13:
                //guardar detalle
                datos = GuardarDetalle(datos);
                break;
            case 12:
                //ir a editar detalle
                datos = CargarCatalogosDetalle(datos);
                datos.put("accion", "editarDet");
                datos = ObtenerDetalle(datos);
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
            /*case 11:
                //quitar filtros
                datos = ObtenerClientes(datos);
                datos.remove("listadoFil");
                datos.remove("filtro");
                break;
            case 12:
                //imprimir listado
                Connection con = HibernateUtil.getSessionFactory().openSession().connection();
                datos.put("conexion", con);
                datos = ImprimirListado(datos);
                try {
                    con.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClienteMod.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
            case 13:
                //ir a contratos de cliente
                datos = CargarContratos(datos);
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
            case 94:
                //cancelar inactivos det
                datos.remove("inactivosDet");
                break;
            case 95:
                //cancelar nuevo detalle
                datos = QuitarCatalogosDetalle(datos);
                break;*/
            case 96: case 93:
                //cancelar servicios(96) || cancelar aplicar mov (93)
                datos.remove("servicios");
                break;
            case 97:
                //cancelar inactivos cab
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo mov cab
                datos.remove("accion");
                datos.remove("activo");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap CargarSucursalesYTiposActivos(HashMap datos) {
        datos.put("sucursales", ObtenerSucursales());
        datos.put("tiposactivos", ObtenerTiposActivos());
        return datos;
    }
    
    
    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }
    
    private List<TipoActivo> ObtenerTiposActivos() {
        TipoActivoDao tipoDao = new TipoActivoDao();
        return tipoDao.obtenerListaActivos();
    }
    
    private HashMap CargaSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        if (sucSel.getId() != 0){
            SucursalDao sucDao = new SucursalDao();
            datos.put("sucursalSel", sucDao.obtener(sucSel.getId()));
        }
        return datos;
    }
    
    private HashMap CargaTipoActivoSel(HashMap datos) {
        TipoActivo tactSel = (TipoActivo) datos.get("tipoactSel");
        if (tactSel.getId() != 0){
            TipoActivoDao tactDao = new TipoActivoDao();
            datos.put("tipoactSel", tactDao.obtener(tactSel.getId()));
        }
        return datos;
    }
    
    private HashMap ObtenerActivos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoActivo tactSel = (TipoActivo) datos.get("tipoactSel");
        List<Equipo> listado = new ArrayList<Equipo>();
        if (sucSel.getId() != 0){
            EquipoDao equiDao = new EquipoDao();
            listado = equiDao.obtenerActivosDeSucursalYTipo(sucSel.getId(), tactSel.getId());
        }
        datos.put("listado", listado);
        return datos;
    }

    private HashMap ObtenerActivo(HashMap datos){
        Equipo act = (Equipo)datos.get("activo");
        EquipoDao equiDao = new EquipoDao();
        act = equiDao.obtener(act.getId());
        datos.put("activo", act);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeActivo(HashMap datos) {
        Equipo act = (Equipo)datos.get("activo");
        EquipoDao equiDao = new EquipoDao();
        equiDao.actualizarEstatus(0, act.getId());
        datos = ObtenerActivos(datos);
        datos.remove("activo");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoActivo tactSel = (TipoActivo)datos.get("tipoactSel");
        List<Equipo> listado = new ArrayList<Equipo>();
        EquipoDao equiDao = new EquipoDao();
        listado = equiDao.obtenerInactivosDeSucursalYTipo(sucSel.getId(), tactSel.getId());
        datos.put("inactivos", listado);
        return datos;
    }
    
    private HashMap ActivarActivo(HashMap datos) {
        Equipo act = (Equipo)datos.get("activo");
        EquipoDao equiDao = new EquipoDao();
        equiDao.actualizarEstatus(1, act.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerActivos(datos);
        datos.remove("activo");
        return datos;
    }

    private HashMap GuardaActivo(HashMap datos) {
        EquipoDao equiDao = new EquipoDao();
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        TipoActivo tact = (TipoActivo)datos.get("tipoactSel");
        Equipo activo = (Equipo)datos.get("activo");
        if (datos.get("accion").toString().equals("nuevo")){
            activo.setSucursal(sucSel);
            activo.setTipoactivo(tact);
            activo.setEstatus(1);
            equiDao.guardar(activo);
        } else {
            equiDao.actualizar(activo);
        }
        datos = ObtenerActivos(datos);
        datos.remove("activo");
        datos.remove("accion");
        return datos;
    }

    private HashMap ObtenerServicios(HashMap datos) {
        datos = ObtenerActivo(datos);
        Equipo act = (Equipo)datos.get("activo");
        ServicioDao serDao = new ServicioDao();
        datos.put("servicios", serDao.obtenerListaServiciosDeActivo(act.getId()));
        return datos;
    }
/*
    private HashMap GuardarDetalle(HashMap datos) {
        Detalle det = (Detalle)datos.get("detalle");
        //obtener el producto completo
        Producto prod = det.getProducto();
        ProductoDao proDao = new ProductoDao();
        prod = proDao.obtener(prod.getId());
        det.setProducto(prod);
        MovimientoDao movDao = new MovimientoDao();
        if (datos.get("accion").toString().equals("nuevoDet")){
            Cabecera cab = (Cabecera) datos.get("cabecera");
            Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
            TipoMov tmov = (TipoMov)datos.get("tipomovSel");
            det.setCabecera(cab);
            det.setSucursal(sucSel);
            det.setCategoria(det.getProducto().getCategoria());
            det.setDescripcion(det.getProducto().getDescripcion());
            det.setCostoUltimo(det.getProducto().getCostoUltimo());
            det.setCostoPromedio(det.getProducto().getCostoPromedio());
            det.setCostoActual(det.getProducto().getCostoActual());
            det.setDescuento1(det.getProducto().getDescuento1());
            det.setDescuento2(det.getProducto().getDescuento2());
            det.setDescuento3(det.getProducto().getDescuento3());
            det.setDescuento4(det.getProducto().getDescuento4());
            det.setDescuento5(det.getProducto().getDescuento5());
            det.setIva(det.getProducto().getIvaNacional());
            det.setIvaExtranjero(det.getProducto().getIvaExtranjero());
            det.setIeps(det.getProducto().getIep());
            det.setEstatus(1);
            
            movDao.guardarDetalle(det);
        } else {
            movDao.actualizarDetalle(det);
        }
        datos = ObtenerDetalles(datos);
        datos = QuitarCatalogosDetalle(datos);
        return datos;
    }

    private HashMap ObtenerDetalle(HashMap datos) {
        Detalle det = (Detalle)datos.get("detalle");
        MovimientoDao movDao = new MovimientoDao();
        det = movDao.obtenerDetalle(det.getId());
        datos.put("detalle", det);
        return datos;
    }

    private HashMap BajaDeDetalle(HashMap datos) {
        Detalle det = (Detalle)datos.get("detalle");
        MovimientoDao movDao = new MovimientoDao();
        movDao.actualizarEstatusDetalle(0, det.getId());
        datos = ObtenerDetalles(datos);
        datos.remove("detalle");
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
        for (int i=0; i < detalles.size(); i++){
            Detalle det = detalles.get(i);
            
            Existencia exAct = movDao.obtenerExistenciaActual(det.getAlmacen().getId(), det.getProducto().getId());
            if (exAct==null){
                //guarda la nueva registro
                Existencia exNva = new Existencia();
                exNva.setAlmacen(det.getAlmacen());
                exNva.setProducto(det.getProducto());
                exNva.setExistencia(det.getCantidad());
                movDao.guardaExistencia(exNva);
            }
            else {
                float nvaEx = 0;
                if (cab.getTipomov().getCategoria()==1){
                    nvaEx = exAct.getExistencia() + det.getCantidad();
                } else {
                    nvaEx = exAct.getExistencia() - det.getCantidad();
                }
                exAct.setExistencia(nvaEx);
                movDao.actualizarExistencia(exAct);
            }
        }
        datos.remove("cabecera");
        datos.remove("detalles");
        datos = ObtenerMovimientos(datos);
        return datos;
    }
    */
}
