/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoCambioDao;
import Modelo.Entidades.Catalogos.TipoCambio;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class TipoCambioMod {
    public TipoCambioMod(){
    }

    public Sesion GestionarTiposCambios(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de tipos de cambio activos
                datos = ObtenerTiposCambios(datos);
                break;
            case 1:
                //ir a nuevo tipo de cambio
                datos.put("accion", "nuevo");
                break;
            case 2: case 4:
                //guardar tipo cambio (2) | editado(4)
                datos = GuardarTipoCambio(datos);
                break;
            case 3:
                //obtener tipo de cambio
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
                datos.remove("tcinactivos");
                break;
            case 98:
                //cancelar nuevo tipo cambio
                datos.remove("accion");
                datos.remove("tipocambio");
                break;
            case 99:
                //salir de gestionar tipos de cambios
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerTiposCambios(HashMap datos) {
        TipoCambioDao tcamDao = new TipoCambioDao();
        datos.put("tiposcambios", tcamDao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarTipoCambio(HashMap datos) {
        TipoCambio tipo = (TipoCambio)datos.get("tipocambio");
        TipoCambioDao tipoDao = new TipoCambioDao();
        if (datos.get("accion").toString().equals("nuevo")){
            tipo.setEstatus(1);
            tipoDao.guardar(tipo);
        } else
            tipoDao.actualizar(tipo);
        
        datos = ObtenerTiposCambios(datos);
        datos.remove("accion");
        datos.remove("tipocambio");
        return datos;
    }

    private HashMap ObtenerTipo(HashMap datos) {
        TipoCambio tipo = (TipoCambio)datos.get("tipocambio");
        TipoCambioDao tipoDao = new TipoCambioDao();
        tipo = tipoDao.obtener(tipo.getId());
        datos.put("tipocambio", tipo);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeTipo(HashMap datos) {
        TipoCambio tipo = (TipoCambio)datos.get("tipocambio");
        TipoCambioDao tipoDao = new TipoCambioDao();
        tipoDao.actualizarEstatus(0, tipo.getId());
        datos = ObtenerTiposCambios(datos);
        datos.remove("tipocambio");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        TipoCambioDao tipoDao = new TipoCambioDao();
        datos.put("tcinactivos", tipoDao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarTipoCambio(HashMap datos) {
        TipoCambio tipo = (TipoCambio)datos.get("tipocambio");
        TipoCambioDao tipoDao = new TipoCambioDao();
        tipoDao.actualizarEstatus(1, tipo.getId());
        datos = ObtenerTiposCambios(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("tipocambio");
        return datos;
    }

}
