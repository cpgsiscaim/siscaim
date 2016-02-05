/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.UnidadProductoDao;
import Modelo.Entidades.Producto;
import Modelo.Entidades.UnidadProducto;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class UnidadProductoMod {
    public UnidadProductoMod(){
    }

    public Sesion GestionarUnidadesDeProductos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            /*case 0:
                //obtener la lista de unidades de salida activos
                datos = ObtenerUnidadesDeSalida(datos);
                break;*/
            case 1:
                //ir a nueva unidad de salida
                datos = ObtenerUnidadesDisponibles(datos);
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar unidad nueva(2) | editada (4)
                datos = GuardarUnidadProducto(datos);
                break;
            case 3:
                //ir a editar unidad
                datos = ObtenerUnidadProducto(datos);
                datos.put("accion", "editar");
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
                datos.remove("upinactivas");
                break;
            case 98:
                //cancelar nueva | editar
                datos.remove("uniprod");
                datos.remove("accion");
                break;
            case 99:
                //salir de gestionar unidades de salida
                datos.remove("unidadesproducto");
                datos.remove("producto");
                datos.remove("accion");
                datos.remove("uniprod");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerUnidadesDeSalida(HashMap datos) {
        UnidadProductoDao upDao = new UnidadProductoDao();
        Producto prod = (Producto)datos.get("producto");
        datos.put("unidadesproducto", upDao.obtenerListaActivasDeProductoNoMinNoEmp(prod.getId()));
        return datos;
    }

    private HashMap ObtenerUnidadesDisponibles(HashMap datos) {
        UnidadProductoDao upDao = new UnidadProductoDao();
        Producto prod = (Producto)datos.get("producto");
        datos.put("unidades", upDao.obtenerUnidadesDisponiblesDeProducto(prod.getId()));
        return datos;
    }

    private HashMap GuardarUnidadProducto(HashMap datos) {
        UnidadProducto uni = (UnidadProducto)datos.get("uniprod");
        Producto prod = (Producto)datos.get("producto");
        UnidadProductoDao uniDao = new UnidadProductoDao();
        if (datos.get("accion").toString().equals("nueva")){
            uni.setProducto(prod);
            uni.setEstatus(1);
            uni.setEmpaque(0);
            uni.setMinima(0);
            uniDao.guardar(uni);
        } else {
            uniDao.actualizar(uni);
        }
        datos = ObtenerUnidadesDeSalida(datos);
        datos.remove("uniprod");
        datos.remove("unidades");
        datos.remove("accion");
        return datos;
    }

    private HashMap ObtenerUnidadProducto(HashMap datos) {
        UnidadProducto uni = (UnidadProducto)datos.get("uniprod");
        UnidadProductoDao uniDao = new UnidadProductoDao();
        uni = uniDao.obtener(uni.getId());
        datos.put("uniprod", uni);
        return datos;
    }

    private HashMap BajaDeUnidad(HashMap datos) {
        UnidadProducto uni = (UnidadProducto)datos.get("uniprod");
        UnidadProductoDao uniDao = new UnidadProductoDao();
        uniDao.actualizarEstatus(0, uni.getId());
        datos = ObtenerUnidadesDeSalida(datos);
        datos.remove("uniprod");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        Producto prod = (Producto)datos.get("producto");
        UnidadProductoDao uniDao = new UnidadProductoDao();
        datos.put("upinactivas", uniDao.obtenerListaInactivasDeProductoNoMinNoEmp(prod.getId()));
        return datos;
    }

    private HashMap ActivarUnidad(HashMap datos) {
        UnidadProducto uni = (UnidadProducto)datos.get("uniprod");
        UnidadProductoDao uniDao = new UnidadProductoDao();
        uniDao.actualizarEstatus(1, uni.getId());
        datos = ObtenerUnidadesDeSalida(datos);
        datos = ObtenerInactivas(datos);
        datos.remove("uniprod");
        return datos;
    }

}
