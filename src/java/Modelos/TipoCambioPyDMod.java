/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoCambioPyDDao;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.TipoCambioPyD;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class TipoCambioPyDMod {
    public TipoCambioPyDMod(){
    }

    public Sesion GestionarTiposCambiosPyD(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de tipos de cambio activos
                datos = ObtenerTiposCambios(datos);
                break;
            case 1:
                //ir a nuevo tipo de cambio
                datos = ObtenerCatalogos(datos);
                datos.put("accion", "nuevo");
                break;
            case 2: case 4:
                //guardar tipo cambio (2) | editado(4)
                datos = GuardarTipoCambio(datos);
                break;
            case 3:
                //obtener tipo de cambio
                datos = ObtenerCatalogos(datos);
                datos = ObtenerTipo(datos);
                break;
            case 5:
                //baja de tipo de cambio
                datos = BajaDeTipo(datos);
                break;
            case 6:
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar tipo de cambio
                datos = ActivarTipoCambio(datos);
                break;
            case 97:
                //cancelar inactivos
                datos.remove("tcpydinactivos");
                break;
            case 98:
                //cancelar nuevo tipo cambio
                datos.remove("accion");
                datos.remove("tcpyd");
                break;
            case 99:
                //salir de gestionar tipos de cambios
                datos.remove("tcpyds");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerTiposCambios(HashMap datos) {
        PeryDed pyd = (PeryDed)datos.get("perded");
        TipoCambioPyDDao tcamDao = new TipoCambioPyDDao();
        datos.put("listatcpyd", tcamDao.obtenerListaActivos(pyd.getIdPeryded()));
        return datos;
    }

    private HashMap GuardarTipoCambio(HashMap datos) {
        PeryDed pyd = (PeryDed)datos.get("perded");
        TipoCambioPyD tipo = (TipoCambioPyD)datos.get("tcpyd");
        TipoCambioPyDDao tipoDao = new TipoCambioPyDDao();
        if (datos.get("accion").toString().equals("nuevo")){
            tipo.setPerded(pyd);
            tipo.setEstatus(1);
            tipoDao.guardar(tipo);
        } else
            tipoDao.actualizar(tipo);
        
        datos = ObtenerTiposCambios(datos);
        datos.remove("accion");
        datos.remove("tcpyd");
        return datos;
    }

    private HashMap ObtenerTipo(HashMap datos) {
        TipoCambioPyD tipo = (TipoCambioPyD)datos.get("tcpyd");
        TipoCambioPyDDao tipoDao = new TipoCambioPyDDao();
        tipo = tipoDao.obtener(tipo.getId());
        datos.put("tcpyd", tipo);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeTipo(HashMap datos) {
        TipoCambioPyD tipo = (TipoCambioPyD)datos.get("tcpyd");
        TipoCambioPyDDao tipoDao = new TipoCambioPyDDao();
        tipoDao.actualizarEstatus(0, tipo.getId());
        datos = ObtenerTiposCambios(datos);
        datos.remove("tcpyd");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        PeryDed pyd = (PeryDed)datos.get("perded");
        TipoCambioPyDDao tipoDao = new TipoCambioPyDDao();
        datos.put("tcpydinactivos", tipoDao.obtenerListaInactivos(pyd.getIdPeryded()));
        return datos;
    }

    private HashMap ActivarTipoCambio(HashMap datos) {
        TipoCambioPyD tipo = (TipoCambioPyD)datos.get("tcpyd");
        TipoCambioPyDDao tipoDao = new TipoCambioPyDDao();
        tipoDao.actualizarEstatus(1, tipo.getId());
        datos = ObtenerTiposCambios(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("tcpyd");
        return datos;
    }

    private HashMap ObtenerCatalogos(HashMap datos) {
        PeryDed pyd = (PeryDed)datos.get("perded");
        TipoCambioPyDDao tcpydDao = new TipoCambioPyDDao();
        datos.put("tiposc", tcpydDao.obtenerTiposCambiosDisponibles(pyd.getIdPeryded()));
        return datos;
    }

}
