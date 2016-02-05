/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.AlmacenDao;
import Modelo.Daos.SucursalDao;
import Modelo.Daos.UbicacionDao;
import Modelo.Entidades.Almacen;
import Modelo.Entidades.Sucursal;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class AlmacenMod {
    
    public AlmacenMod(){
    }

    public Sesion GestionarAlmacenes(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos.put("listado", ObtenerAlmacenes());
                break;
            case 1: case 3:
                //preparar catalogos nuevo almacen | editar almacen
                datos.put("sucursales", ObtenerSucursales());
                if (paso == 1)
                    datos.put("accion", "nuevo");
                else {
                    datos.put("accion", "editar");
                    datos.put("editarAlma", ObtenerAlmacenAEditar(datos));
                }
                break;
            case 2: case 4:
                //guardar el nuevo almacen
                datos = GuardarAlmacenNuevo(datos);
                break;
            case 5:
                //baja de almacen
                datos = BajaDeAlmacen(datos);
                break;
            case 6:
                //baja de almacen
                datos.put("inactivos", ObtenerAlmacenesInactivos());
                break;
            case 7:
                //activar almacen
                datos = ActivarAlmacen(datos);
                break;
            case 8:
                //ir a ubicaciones
                datos = ObtenerUbicaciones(datos);
                break;
            case 96:
                //cancelar inactivos
                datos.put("listado", ObtenerAlmacenes());
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo | editar almacen
                datos.remove("sucursales");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    public List<Almacen> ObtenerAlmacenes() {
        AlmacenDao almaDao = new AlmacenDao();
        List<Almacen> lista = almaDao.obtenerListaActivos();
        return lista;
    }

    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }

    private HashMap GuardarAlmacenNuevo(HashMap datos) {
        Almacen nuevo = (Almacen)datos.get("nuevoAlmacen");
        if (datos.get("accion").toString().equals("editar"))
            nuevo = (Almacen)datos.get("editarAlma");
        /*/obtener la sucursal
        List<Sucursal> sucursales = (List<Sucursal>)datos.get("sucursales");
        for (int i=0; i < sucursales.size(); i++){
            Sucursal suc = sucursales.get(i);
            if (nuevo.getSucursal().getId()==suc.getId()){
                nuevo.setSucursal(suc);
                break;
            }
        }*/
        
        AlmacenDao almDao = new AlmacenDao();
        if (datos.get("accion").toString().equals("nuevo"))
            almDao.guardar(nuevo);
        else
            almDao.actualizar(nuevo);
        //actualizar la lista
        datos.put("listado", almDao.obtenerListaActivos());
        datos.remove("nuevoAlmacen");
        datos.remove("editarAlma");
        datos.remove("sucursales");
        return datos;
    }

    private Almacen ObtenerAlmacenAEditar(HashMap datos) {
        Almacen editAlma = (Almacen) datos.get("editarAlma");
        AlmacenDao almaDao = new AlmacenDao();
        return almaDao.obtener(editAlma.getId());
    }

    private HashMap BajaDeAlmacen(HashMap datos) {
        Almacen baja = (Almacen)datos.get("bajaAlma");
        AlmacenDao almaDao = new AlmacenDao();
        almaDao.actualizarEstatus(0, baja.getId());
        datos.put("listado", almaDao.obtenerListaActivos());
        datos.remove("bajaAlma");
        return datos;
    }

    private Object ObtenerAlmacenesInactivos() {
        AlmacenDao almaDao = new AlmacenDao();
        return almaDao.obtenerListaInactivos();
    }

    private HashMap ActivarAlmacen(HashMap datos) {
        Almacen activar = (Almacen)datos.get("activarAlma");
        AlmacenDao almaDao = new AlmacenDao();
        almaDao.actualizarEstatus(1, activar.getId());
        datos.put("inactivos", ObtenerAlmacenesInactivos());
        datos.remove("activarAlma");
        return datos;
    }

    private HashMap ObtenerUbicaciones(HashMap datos) {
        Almacen alma = (Almacen) datos.get("editarAlma");
        alma = ObtenerAlmacenAEditar(datos);
        UbicacionDao ubiDao = new UbicacionDao();
        datos.put("ubicaciones", ubiDao.obtenerListaActivasDeAlmacen(alma.getId()));
        datos.put("almacen", alma);
        return datos;
    }
    
}
