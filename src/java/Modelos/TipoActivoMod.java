/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoActivoDao;
import Modelo.Entidades.Catalogos.TipoActivo;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class TipoActivoMod {
    public TipoActivoMod(){
    }

    public Sesion GestionarTiposActivos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerTiposActivos(datos);
                break;
            case 1:
                //ir a nuevo producto
                //datos = CargarCatalogosProducto(datos);
                datos.put("accion", "nuevo");
                break;
            case 2: case 4:
                //guardar tipo activo (2) | editado(4)
                datos = GuardarTipoActivo(datos);
                break;
            case 3:
                //obtener producto
                datos = ObtenerTipo(datos);
                break;
            case 5:
                //baja de producto
                datos = BajaDeTipo(datos);
                break;
            case 6:
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar producto
                datos = ActivarTipoActivo(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo tipo activo
                datos.remove("accion");
                datos.remove("tipoactivo");
                break;
            case 99:
                //salir de gestionar productos
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerTiposActivos(HashMap datos) {
        TipoActivoDao tactDao = new TipoActivoDao();
        datos.put("listado", tactDao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarTipoActivo(HashMap datos) {
        TipoActivo tipo = (TipoActivo)datos.get("tipoactivo");
        TipoActivoDao tipoDao = new TipoActivoDao();
        if (datos.get("accion").toString().equals("nuevo")){
            tipo.setEstatus(1);
            tipoDao.guardar(tipo);
        } else
            tipoDao.actualizar(tipo);
        
        datos = ObtenerTiposActivos(datos);
        datos.remove("accion");
        datos.remove("tipoactivo");
        return datos;
    }

    private HashMap ObtenerTipo(HashMap datos) {
        TipoActivo tipo = (TipoActivo)datos.get("tipoactivo");
        TipoActivoDao tipoDao = new TipoActivoDao();
        tipo = tipoDao.obtener(tipo.getId());
        datos.put("tipoactivo", tipo);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeTipo(HashMap datos) {
        TipoActivo tipo = (TipoActivo)datos.get("tipoactivo");
        TipoActivoDao tipoDao = new TipoActivoDao();
        tipoDao.actualizarEstatus(0, tipo.getId());
        datos = ObtenerTiposActivos(datos);
        datos.remove("tipoactivo");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        TipoActivoDao tipoDao = new TipoActivoDao();
        datos.put("inactivos", tipoDao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarTipoActivo(HashMap datos) {
        TipoActivo tipo = (TipoActivo)datos.get("tipoactivo");
        TipoActivoDao tipoDao = new TipoActivoDao();
        tipoDao.actualizarEstatus(1, tipo.getId());
        datos = ObtenerTiposActivos(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("tipoactivo");
        return datos;
    }
}
