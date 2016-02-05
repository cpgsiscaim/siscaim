/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.TipoActivoDao;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.TipoActivo;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author temoc
 */
public class ExistenciaMod {
    private int grupos = 0;
    
    public ExistenciaMod(){
    }

    public Sesion GestionarExistencias(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //obtener sucursales y tipos de mov
                datos = CargarSucursales(datos);
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                datos = ObtenerAlmacenesDeSucursal(datos);
                List<Almacen> almacenes = (List<Almacen>)datos.get("almacenes");
                if (almacenes.size()==1){
                    datos.put("almacenSel", almacenes.get(0));
                    datos = ObtenerExistencias(datos);
                }
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                break;
            case 1:
                //obtener almacenes
                datos = CargaSucursalSel(datos);
                datos = ObtenerAlmacenesDeSucursal(datos);
                List<Almacen> almas = (List<Almacen>)datos.get("almacenes");
                if (almas.size()==1){
                    datos.put("almacenSel", almas.get(0));
                    datos = ObtenerExistencias(datos);
                }
                break;
            case 2:
                //obtener el almacen
                datos = CargaAlmacenSel(datos);
                //obtener las existencias
                datos = ObtenerExistencias(datos);
                break;
            case 3:
                int bxls = Integer.parseInt(datos.get("banxls").toString());
                if (bxls==0)
                    datos = ImprimirReporte(datos);
                else
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
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap CargarSucursales(HashMap datos) {
        SucursalDao sucDao = new SucursalDao();
        datos.put("sucursales", sucDao.obtenerListaSucYMatriz());
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
/*    
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
*/

    private HashMap ObtenerAlmacenesDeSucursal(HashMap datos) {
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        AlmacenDao almDao = new AlmacenDao();
        datos.put("almacenes", almDao.obtenerListaActivosDeSucursal(sucsel.getId()));
        return datos;
    }

    private HashMap CargaAlmacenSel(HashMap datos) {
        Almacen alm = (Almacen)datos.get("almacenSel");
        AlmacenDao almDao = new AlmacenDao();
        datos.put("almacenSel", almDao.obtener(alm.getId()));
        return datos;
    }

    private HashMap ObtenerExistencias(HashMap datos) {
        Almacen alm = (Almacen)datos.get("almacenSel");
        List<Existencia> listado = new ArrayList<Existencia>();
        ExistenciaDao exDao = new ExistenciaDao();
        listado  = exDao.obtenerExistenciasDeAlmacen(alm.getId());
        
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompleta", listado);
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("listado", listado);
            List<UnidadProducto> empaques = ObtenerEmpaques(listado);
            datos.put("empaques", empaques);
        }
        
        
        return datos;
    }
    
    private HashMap ObtenerGrupo(HashMap datos) {
        List<Existencia> exis = (List<Existencia>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Existencia> grupo = new ArrayList<Existencia>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin >= exis.size()){
            fin = exis.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(exis.get(i));
        }
        datos.put("listado", grupo);
        List<UnidadProducto> empaques = ObtenerEmpaques(grupo);
        datos.put("empaques", empaques);
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
        List<Existencia> listacom = (List<Existencia>)datos.get("listacompleta");
        int total = listacom.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private List<UnidadProducto> ObtenerEmpaques(List<Existencia> listado) {
        List<UnidadProducto> empaques = new ArrayList<UnidadProducto>();
        UnidadProductoDao updao = new UnidadProductoDao();
        for (int i=0; i < listado.size(); i++){
            Existencia ex = listado.get(i);
            UnidadProducto up = updao.obtenerUnidadEmpaqueDeProducto(ex.getProducto().getId());
            empaques.add(up);
        }
        
        return empaques;
    }
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }
    
    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }
    
    private HashMap ImprimirXls(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("reportexls", util.generarXLS(datos.get("reporte").toString(), (Map)datos.get("parametros"), datos.get("temp").toString()));
        return datos;
    }
}
