/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoFamiliarDao;
import Modelo.Entidades.Catalogos.TipoFamiliar;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class TipoFamiliarMod {
    public TipoFamiliarMod(){
    }

    public Sesion GestionarTiposFamiliares(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerTiposFamiliares(datos);
                break;
            case 1:
                //ir a nuevo producto
                //datos = CargarCatalogosProducto(datos);
                datos.put("accion", "nuevo");
                break;
            case 2: case 4:
                //guardar tipo activo (2) | editado(4)
                datos = GuardarTipoFamiliar(datos);
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
                datos = ActivarTipoFamiliar(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo tipo activo
                datos.remove("accion");
                datos.remove("tipofam");
                break;
            case 99:
                //salir de gestionar productos
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerTiposFamiliares(HashMap datos) {
        TipoFamiliarDao tfamDao = new TipoFamiliarDao();
        datos.put("listado", tfamDao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarTipoFamiliar(HashMap datos) {
        TipoFamiliar tipo = (TipoFamiliar)datos.get("tipofam");
        TipoFamiliarDao tipoDao = new TipoFamiliarDao();
        if (datos.get("accion").toString().equals("nuevo")){
            tipo.setEstatus(1);
            tipoDao.guardar(tipo);
        } else
            tipoDao.actualizar(tipo);
        
        datos = ObtenerTiposFamiliares(datos);
        datos.remove("accion");
        datos.remove("tipofam");
        return datos;
    }

    private HashMap ObtenerTipo(HashMap datos) {
        TipoFamiliar tipo = (TipoFamiliar)datos.get("tipofam");
        TipoFamiliarDao tipoDao = new TipoFamiliarDao();
        tipo = tipoDao.obtener(tipo.getId());
        datos.put("tipofam", tipo);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeTipo(HashMap datos) {
        TipoFamiliar tipo = (TipoFamiliar)datos.get("tipofam");
        TipoFamiliarDao tipoDao = new TipoFamiliarDao();
        tipoDao.actualizarEstatus(0, tipo.getId());
        datos = ObtenerTiposFamiliares(datos);
        datos.remove("tipofam");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        TipoFamiliarDao tipoDao = new TipoFamiliarDao();
        datos.put("inactivos", tipoDao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarTipoFamiliar(HashMap datos) {
        TipoFamiliar tipo = (TipoFamiliar)datos.get("tipofam");
        TipoFamiliarDao tipoDao = new TipoFamiliarDao();
        tipoDao.actualizarEstatus(1, tipo.getId());
        datos = ObtenerTiposFamiliares(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("tipofam");
        return datos;
    }
}
