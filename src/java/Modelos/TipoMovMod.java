/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.SerieDao;
import Modelo.Daos.TipoMovDao;
import Modelo.Entidades.TipoMov;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class TipoMovMod {
    public TipoMovMod(){
    }

    public Sesion GestionarTipoMov(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerTiposMov(datos);
                break;
            case 1:
                //ir a nuevo tipomov
                datos.put("accion", "nuevo");
                datos = ObtenerSeries(datos);
                break;
            case 2: case 4:
                //guardar tipomov nuevo(2) | editado (4)
                datos = GuardarTipoMov(datos);
                break;
            case 3:
                //ir a editar tipomov
                datos = ObtenerTipoMov(datos);
                break;
            case 5:
                //baja de tipomov
                datos = BajaDeTipoMov(datos);
                break;
            case 6:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar tipomov
                datos = ActivarTipoMov(datos);
                break;
            case 97:
                //cancelar inactivos
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo | editar
                datos.remove("tipomov");
                datos.remove("accion");
                break;
            case 99:
                //salir de gestionar tiposmov
                datos = new HashMap();
                break;            
            }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerTiposMov(HashMap datos) {
        TipoMovDao tmovDao = new TipoMovDao();
        datos.put("listado", tmovDao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarTipoMov(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomov");
        TipoMovDao tmovDao = new TipoMovDao();
        if (datos.get("accion").toString().equals("nuevo")){
            tmov.setEstatus(1);
            tmovDao.guardar(tmov);
        } else {
            tmovDao.actualizar(tmov);
        }
        datos = ObtenerTiposMov(datos);
        datos.remove("tipomov");
        datos.remove("accion");
        return datos;
    }

    private HashMap ObtenerTipoMov(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomov");
        TipoMovDao tmovDao = new TipoMovDao();
        tmov = tmovDao.obtener(tmov.getId());
        datos.put("tipomov", tmov);
        datos.put("accion", "editar");
        datos = ObtenerSeries(datos);
        return datos;
    }

    private HashMap BajaDeTipoMov(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomov");
        TipoMovDao tmovDao = new TipoMovDao();
        tmovDao.actualizarEstatus(0, tmov.getId());
        datos = ObtenerTiposMov(datos);
        datos.remove("tipomov");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        TipoMovDao tmovDao = new TipoMovDao();
        datos.put("inactivos", tmovDao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarTipoMov(HashMap datos) {
        TipoMov tmov = (TipoMov)datos.get("tipomov");
        TipoMovDao tmovDao = new TipoMovDao();
        tmovDao.actualizarEstatus(1, tmov.getId());
        datos = ObtenerTiposMov(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("tipomov");
        return datos;
    }

    private HashMap ObtenerSeries(HashMap datos) {
        SerieDao serDao = new SerieDao();
        datos.put("series", serDao.obtenerListaActivas());
        return datos;
    }
    
}
