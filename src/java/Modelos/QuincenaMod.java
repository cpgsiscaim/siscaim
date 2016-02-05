/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.QuincenaDao;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class QuincenaMod {
    public QuincenaMod(){
    }

    public Sesion GestionarQuincenas(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de tipos de cambio activos
                datos = ObtenerQuincenas(datos);
                break;
            /*case 1:
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
                break;*/
            case 99:
                //salir de gestionar tipos de cambios
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerQuincenas(HashMap datos) {
        QuincenaDao quinDao = new QuincenaDao();
        datos.put("quincenas", quinDao.obtenerLista());
        return datos;
    }

}
