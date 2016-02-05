/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.ServicioDao;
import Modelo.Entidades.Equipo;
import Modelo.Entidades.Servicio;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class ServicioMod {
    public ServicioMod(){
    }

    public Sesion GestionarServicios(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 1:
                //ir a nuevo servicio
                datos.put("accion", "nuevo");
                break;
            case 2: case 4:
                //guardar servicio
                datos = GuardaServicio(datos);
                break;
            case 3:
                //ir a editar servicio
                datos = ObtenerServicio(datos);
                datos.put("accion", "editar");                
                break;
            case 5:
                //baja de servicio
                datos = BajaDeServicio(datos);
                break;
            case 6:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar servicio
                datos = ActivarServicio(datos);
                break;
            case 97:
                //cancelar inactivos
                datos.remove("servinactivos");
                break;
            case 98:
                datos.remove("accion");
                break;
            case 99:
                datos.remove("servicios");
                datos.remove("activo");
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }

    private HashMap ObtenerServicios(HashMap datos) {
        Equipo act = (Equipo)datos.get("activo");
        ServicioDao serDao = new ServicioDao();
        datos.put("servicios", serDao.obtenerListaServiciosDeActivo(act.getId()));
        return datos;
    }
    
    private HashMap GuardaServicio(HashMap datos) {
        ServicioDao servDao = new ServicioDao();
        Equipo activo = (Equipo)datos.get("activo");
        Servicio serv = (Servicio)datos.get("servicio");
        if (datos.get("accion").toString().equals("nuevo")){
            serv.setEquipo(activo);
            serv.setEstatus(1);
            servDao.guardar(serv);
        } else {
            servDao.actualizar(serv);
        }
        datos = ObtenerServicios(datos);
        datos.remove("servicio");
        datos.remove("accion");
        return datos;
    }

    private HashMap ObtenerServicio(HashMap datos) {
        Servicio serv = (Servicio)datos.get("servicio");
        ServicioDao servDao = new ServicioDao();
        serv = servDao.obtener(serv.getId());
        datos.put("servicio", serv);
        return datos;
    }

    private HashMap BajaDeServicio(HashMap datos) {
        Servicio serv = (Servicio)datos.get("servicio");
        ServicioDao servDao = new ServicioDao();
        servDao.actualizarEstatus(0, serv.getId());
        datos = ObtenerServicios(datos);
        datos.remove("servicio");
        return datos;
    }
    
    private HashMap ObtenerInactivos(HashMap datos) {
        Equipo act = (Equipo)datos.get("activo");
        List<Servicio> listado = new ArrayList<Servicio>();
        ServicioDao servDao = new ServicioDao();
        listado = servDao.obtenerInactivosDeActivo(act.getId());
        datos.put("servinactivos", listado);
        return datos;
    }
    
    private HashMap ActivarServicio(HashMap datos) {
        Servicio serv = (Servicio)datos.get("servicio");
        ServicioDao servDao = new ServicioDao();
        servDao.actualizarEstatus(1, serv.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerServicios(datos);
        datos.remove("servicio");
        return datos;
    }
    
}
