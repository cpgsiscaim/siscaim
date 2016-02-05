/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.UnidadDao;
import Modelo.Entidades.Unidad;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class UnidadMod {
    public UnidadMod(){
    }

    public Sesion GestionarUnidades(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerUnidades(datos);
                break;
            case 1:
                //ir a nueva unidad
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar unidad nueva(2) | editada (4)
                datos = GuardarUnidad(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Unidades/nuevaunidad.jsp");
                    datos.remove("error");
                }
                break;
            case 3:
                //ir a editar unidad
                datos = ObtenerUnidad(datos);
                break;
            case 5:
                //baja de unidad
                datos = BajaDeUnidad(datos);
                break;
            case 6:
                //ir a inactivas
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                //activar unidad
                datos = ActivarUnidad(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar nueva | editar
                datos.remove("unidad");
                datos.remove("accion");
                break;
            case 99:
                //salir de gestionar unidades
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerUnidades(HashMap datos) {
        UnidadDao uniDao = new UnidadDao();
        datos.put("listado", uniDao.obtenerListaActivas());
        return datos;
    }

    private HashMap GuardarUnidad(HashMap datos) {
        Unidad uni = (Unidad)datos.get("unidad");
        UnidadDao uniDao = new UnidadDao();
        if (datos.get("accion").toString().equals("nueva") && uniDao.ValidaUnidad(uni)){
            datos.put("error", "La Clave de Unidad ya existe");
            return datos;
        } else if (datos.get("accion").toString().equals("editar")){
            String uniact = datos.get("uniact").toString();
            if (!uniact.equals(uni.getClave()) && uniDao.ValidaUnidad(uni)){
                datos.put("error", "La Clave de Unidad ya existe");
                return datos;
            }
        }
               
        if (datos.get("accion").toString().equals("nueva")){
            uni.setEstatus(1);
            uniDao.guardar(uni);
        } else {
            uniDao.actualizar(uni);
        }
        datos = ObtenerUnidades(datos);
        datos.remove("unidad");
        datos.remove("accion");
        
        return datos;
    }

    private HashMap ObtenerUnidad(HashMap datos) {
        Unidad uni = (Unidad)datos.get("unidad");
        UnidadDao uniDao = new UnidadDao();
        uni = uniDao.obtener(uni.getId());
        datos.put("unidad", uni);
        datos.put("accion", "editar");
        datos.put("uniact", uni.getClave());
        return datos;
    }

    private HashMap BajaDeUnidad(HashMap datos) {
        Unidad uni = (Unidad)datos.get("unidad");
        UnidadDao uniDao = new UnidadDao();
        uniDao.actualizarEstatus(0, uni.getId());
        datos = ObtenerUnidades(datos);
        datos.remove("unidad");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        UnidadDao uniDao = new UnidadDao();
        datos.put("inactivas", uniDao.obtenerListaInactivas());
        return datos;
    }

    private HashMap ActivarUnidad(HashMap datos) {
        Unidad uni = (Unidad)datos.get("unidad");
        UnidadDao uniDao = new UnidadDao();
        uniDao.actualizarEstatus(1, uni.getId());
        datos = ObtenerUnidades(datos);
        datos = ObtenerInactivas(datos);
        datos.remove("unidad");
        return datos;
    }

}
