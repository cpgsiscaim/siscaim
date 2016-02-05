/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.RutaDao;
import Modelo.Daos.SucursalDao;
import Modelo.Entidades.Ruta;
import Modelo.Entidades.Sucursal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class RutaMod {
    public RutaMod(){
    }

    public Sesion GestionarRutas(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de sucursales activas
                datos.put("sucursales", ObtenerSucursales());
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                datos = ObtenerRutas(datos);
                break;
            case 1:
                //cargar rutas de la sucursal seleccionada
                datos = ObtenerRutas(datos);
                break;
            case 2:
                //ir a nueva ruta
                datos.put("accion", "nueva");
                datos = CargarSucursalSel(datos);
                break;
            case 3: case 5:
                //guardar nueva ruta || guardar ruta editada
                datos = GuardarNuevaRuta(datos);
                break;
            case 4:
                //ir a editar ruta
                datos.put("accion", "editar");
                datos = CargarSucursalSel(datos);
                datos = ObtenerRuta(datos);
                break;
            case 6:
                //baja de ruta
                datos = BajaDeRuta(datos);
                break;
            case 7:
                datos.put("inactivas", ObtenerInactivas(datos));
                break;
            case 8:
                //activar ruta
                datos = ActivaRuta(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivas");
                datos = ObtenerRutas(datos);
                break;
            case 98:
                //cancelar nuevo cliente
                datos.remove("accion");
                //datos.remove("")
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }
    
    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }
    
    private HashMap ObtenerRutas(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Ruta> listado = new ArrayList<Ruta>();
        if (sucSel.getId() != 0){
            RutaDao rutaDao = new RutaDao();
            listado = rutaDao.obtenerRutasDeSucursal(sucSel.getId());
        }
        datos.put("listado", listado);
        return datos;
    }

    private HashMap GuardarNuevaRuta(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Ruta nueva = new Ruta();
        if (datos.get("accion").toString().equals("nueva")){
            nueva = (Ruta) datos.get("nuevaRuta");            
            nueva.setEstatus(1);
            nueva.setSucursal(sucSel);
        }
        else {
            nueva = (Ruta)datos.get("editarRuta");
        }
        
        RutaDao rutaDao = new RutaDao();
        if (datos.get("accion").toString().equals("nueva"))
            rutaDao.guardar(nueva);
        else
            rutaDao.actualizar(nueva);
        
        datos = ObtenerRutas(datos);
        datos.remove("accion");
        datos.remove("nuevaRuta");
        datos.remove("editarRuta");
        
        return datos;
    }

    private HashMap CargarSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        SucursalDao sucDao = new SucursalDao();
        sucSel = sucDao.obtener(sucSel.getId());
        datos.put("sucursalSel", sucSel);
        return datos;
    }

    private HashMap ObtenerRuta(HashMap datos) {
        Ruta editar = (Ruta)datos.get("editarRuta");
        RutaDao rutaDao = new RutaDao();
        editar = rutaDao.obtener(editar.getId());
        datos.put("editarRuta", editar);
        return datos;
    }

    private HashMap BajaDeRuta(HashMap datos) {
        Ruta baja = (Ruta) datos.get("bajaRuta");
        RutaDao rutaDao = new RutaDao();
        rutaDao.actualizarEstatus(0, baja.getId());

        datos = ObtenerRutas(datos);
        datos.remove("bajaRuta");        
        
        return datos;
    }

    private List<Ruta> ObtenerInactivas(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        RutaDao rutaDao = new RutaDao();
        return rutaDao.obtenerRutasInactivasDeSucursal(sucSel.getId());
    }

    private HashMap ActivaRuta(HashMap datos) {
        Ruta ruta = (Ruta)datos.get("activarRuta");
        RutaDao rutaDao = new RutaDao();
        rutaDao.actualizarEstatus(1, ruta.getId());
        
        datos.put("inactivas", ObtenerInactivas(datos));
        return datos;
    }
    
}
