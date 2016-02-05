/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.MarcaDao;
import Modelo.Entidades.Marca;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class MarcaMod {
    public MarcaMod(){
    }

    public Sesion GestionarMarcas(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerMarcas(datos);
                break;
            case 1:
                //ir a nueva marca
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar marca nueva (2) | editada(4)
                datos = GuardarMarca(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Marcas/nuevamarca.jsp");
                    datos.remove("error");
                }
                break;
            case 3:
                //obtener marcar
                datos = ObtenerMarca(datos);
                break;
            case 5:
                //baja de marca
                datos = BajaDeMarca(datos);
                break;
            case 6:
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                //activar marca
                datos = ActivarMarca(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar nueva marca
                datos.remove("accion");
                datos.remove("marca");
                break;
            case 99:
                //salir de gestionar marcas
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerMarcas(HashMap datos) {
        MarcaDao marDao = new MarcaDao();
        datos.put("listado", marDao.obtenerListaActivas());
        return datos;
    }

    private HashMap GuardarMarca(HashMap datos) {
        Marca mar = (Marca)datos.get("marca");
        MarcaDao marDao = new MarcaDao();
        if (!marDao.ValidaMarca(mar)){
            if (datos.get("accion").toString().equals("nueva")){
                mar.setEstatus(1);
                marDao.guardar(mar);
            } else
                marDao.actualizar(mar);
            datos = ObtenerMarcas(datos);
            datos.remove("accion");
            datos.remove("marca");
        } else {
            datos.put("error", "La Clave de Marca ya existe");
        }
        return datos;
    }

    private HashMap ObtenerMarca(HashMap datos) {
        Marca mar = (Marca)datos.get("marca");
        MarcaDao marDao = new MarcaDao();
        mar = marDao.obtener(mar.getId());
        datos.put("marca", mar);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeMarca(HashMap datos) {
        Marca mar = (Marca)datos.get("marca");
        MarcaDao marDao = new MarcaDao();
        marDao.actualizarEstatus(0, mar.getId());
        datos = ObtenerMarcas(datos);
        datos.remove("marca");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        MarcaDao marDao = new MarcaDao();
        datos.put("inactivas", marDao.obtenerListaInactivas());
        return datos;
    }

    private HashMap ActivarMarca(HashMap datos) {
        Marca mar = (Marca)datos.get("marca");
        MarcaDao marDao = new MarcaDao();
        marDao.actualizarEstatus(1, mar.getId());
        datos = ObtenerMarcas(datos);
        datos = ObtenerInactivas(datos);
        datos.remove("marca");        
        return datos;
    }

}
