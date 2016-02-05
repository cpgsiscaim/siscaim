/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.CuentasTelecommDao;
import Modelo.Entidades.Catalogos.CuentasTelecomm;
import java.util.HashMap;

/**
 *
 * @author usuario
 */
public class CuentasTelecommMod {
    public CuentasTelecommMod(){
    }

    public Sesion GestionarCuentasTelecomm(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        switch (paso){
            case 0:
                datos = ObtenerCuentas(datos);
                break;
            case 1:
                datos.put("accion", "nuevo");
                break;
            case 2:
                datos = ObtenerCuenta(datos);
                datos.put("accion", "editar");
                break;
            case 3:
                datos = GuardarCuenta(datos);
                break;
            case 4:
                datos = BajaDeCuenta(datos);
                break;
            case 5:
                datos = ObtenerInactivas(datos);
                break;
            case 6:
                datos = ActivarCuenta(datos);
                break;
            case 98:
                datos = ObtenerCuentas(datos);
                datos.remove("inactivas");
                break;
            case 99:
                //salir de gestionar cuentas
                datos = new HashMap();
                break;                
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerCuentas(HashMap datos) {
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        datos.put("cuentas", ctadao.obtenerListaActivas());
        return datos;
    }

    private HashMap GuardarCuenta(HashMap datos) {
        CuentasTelecomm cuenta = (CuentasTelecomm)datos.get("cuenta");
        cuenta.setEstatus(1);
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        if (datos.get("accion").toString().equals("nuevo"))
            ctadao.guardar(cuenta);
        else
            ctadao.actualizar(cuenta);
        
        datos = ObtenerCuentas(datos);
        datos.remove("cuenta");
        datos.remove("accion");
        return datos;
    }

    private HashMap ObtenerCuenta(HashMap datos) {
        CuentasTelecomm cuenta = (CuentasTelecomm)datos.get("cuenta");
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        cuenta = ctadao.obtener(cuenta.getId());
        datos.put("cuenta", cuenta);
        return datos;
    }

    private HashMap BajaDeCuenta(HashMap datos) {
        CuentasTelecomm cuenta = (CuentasTelecomm)datos.get("cuenta");
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        cuenta = ctadao.obtener(cuenta.getId());
        cuenta.setEstatus(0);
        ctadao.actualizar(cuenta);
        datos = ObtenerCuentas(datos);
        datos.remove("cuenta");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        datos.put("inactivas", ctadao.obtenerListaInactivas());
        return datos;
    }

    private HashMap ActivarCuenta(HashMap datos) {
        CuentasTelecomm cuenta = (CuentasTelecomm)datos.get("cuenta");
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        cuenta = ctadao.obtener(cuenta.getId());
        cuenta.setEstatus(1);
        ctadao.actualizar(cuenta);
        datos = ObtenerInactivas(datos);
        datos.remove("cuenta");
        return datos;
    }
    
}
