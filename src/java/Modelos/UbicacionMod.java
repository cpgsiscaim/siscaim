/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.UbicacionDao;
import Modelo.Daos.SucursalDao;
import Modelo.Entidades.Almacen;
import Modelo.Entidades.Ubicacion;
import Modelo.Entidades.Sucursal;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class UbicacionMod {
    public UbicacionMod(){
    }

    public Sesion GestionarUbicaciones(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            /*case 0:
                //obtener la lista de almacenes activos
                datos.put("listado", ObtenerAlmacenes());
                break;*/
            case 1:
                //ir a nueva ubicacion
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar ubicacion nuevo (2) | editado(4)
                datos = GuardarUbicacion(datos);
                break;
            case 3:
                //obtener ubicacion
                datos = ObtenerUbicacion(datos);
                break;
            case 5:
                //baja de ubicacion
                datos = BajaDeUbicacion(datos);
                break;
            case 6:
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                //activar ubicacion
                datos = ActivarUbicacion(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar nueva ubicacion
                datos.remove("accion");
                datos.remove("ubicacion");
                break;
            case 99:
                //salir de gestionar productos
                datos.remove("ubicaciones");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerUbicaciones(HashMap datos) {
        Almacen alm = (Almacen)datos.get("almacen");
        UbicacionDao ubiDao = new UbicacionDao();
        datos.put("ubicaciones", ubiDao.obtenerListaActivasDeAlmacen(alm.getId()));
        return datos;
    }

    private HashMap GuardarUbicacion(HashMap datos) {
        Ubicacion ubi = (Ubicacion)datos.get("ubicacion");
        Almacen alm = (Almacen)datos.get("almacen");
        UbicacionDao ubiDao = new UbicacionDao();
        if (datos.get("accion").toString().equals("nueva")){
            ubi.setEstatus(1);
            ubi.setAlmacen(alm);
            ubiDao.guardar(ubi);
        } else
            ubiDao.actualizar(ubi);
        datos = ObtenerUbicaciones(datos);
        datos.remove("accion");
        datos.remove("ubicacion");
        return datos;
    }

    private HashMap ObtenerUbicacion(HashMap datos) {
        Ubicacion ubi = (Ubicacion)datos.get("ubicacion");
        UbicacionDao ubiDao = new UbicacionDao();
        ubi = ubiDao.obtener(ubi.getId());
        datos.put("ubicacion", ubi);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeUbicacion(HashMap datos) {
        Ubicacion ubi = (Ubicacion)datos.get("ubicacion");
        UbicacionDao prodDao = new UbicacionDao();
        prodDao.actualizarEstatus(0, ubi.getId());
        datos = ObtenerUbicaciones(datos);
        datos.remove("ubicacion");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        Almacen alm = (Almacen)datos.get("almacen");
        UbicacionDao ubiDao = new UbicacionDao();
        datos.put("inactivas", ubiDao.obtenerListaInactivasDeAlmacen(alm.getId()));
        return datos;
    }

    private HashMap ActivarUbicacion(HashMap datos) {
        Ubicacion ubi = (Ubicacion)datos.get("ubicacion");
        UbicacionDao ubiDao = new UbicacionDao();
        ubiDao.actualizarEstatus(1, ubi.getId());
        datos = ObtenerUbicaciones(datos);
        datos = ObtenerInactivas(datos);
        datos.remove("ubicacion");        
        return datos;
    }
}
