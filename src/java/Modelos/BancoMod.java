/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.BancoDao;
import Modelo.Entidades.Catalogos.Banco;
import java.util.HashMap;

/**
 *
 * @author usuario
 */
public class BancoMod {
    public BancoMod(){
    }

    public Sesion GestionarBancos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        switch (paso){
            case 0:
                datos = ObtenerBancos(datos);
                break;
            case 1:
                datos.put("accion", "nuevo");
                break;
            case 2:
                datos = ObtenerBanco(datos);
                datos.put("accion", "editar");
                break;
            case 3:
                datos = GuardarBanco(datos);
                break;
            case 4:
                datos = BajaDeBanco(datos);
                break;
            case 5:
                datos = ObtenerInactivos(datos);
                break;
            case 6:
                datos = ActivarBanco(datos);
                break;
            case 98:
                datos = ObtenerBancos(datos);
                datos.remove("inactivos");
                break;
            case 99:
                //salir de gestionar bancos
                datos = new HashMap();
                break;                
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerBancos(HashMap datos) {
        BancoDao bandao = new BancoDao();
        datos.put("bancos", bandao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarBanco(HashMap datos) {
        Banco ban = (Banco)datos.get("banco");
        BancoDao bandao = new BancoDao();
        if (datos.get("accion").toString().equals("nuevo")){
            ban.setEstatus(1);
            bandao.guardar(ban);
        }
        else
            bandao.actualizar(ban);
        datos = ObtenerBancos(datos);
        datos.remove("banco");
        datos.remove("accion");
        return datos;
    }

    private HashMap ObtenerBanco(HashMap datos) {
        Banco ban = (Banco)datos.get("banco");
        BancoDao bandao = new BancoDao();
        ban = bandao.obtener(ban.getId());
        datos.put("banco", ban);
        return datos;
    }

    private HashMap BajaDeBanco(HashMap datos) {
        datos = ObtenerBanco(datos);
        Banco ban = (Banco)datos.get("banco");
        BancoDao bandao = new BancoDao();
        ban.setEstatus(0);
        bandao.actualizar(ban);
        datos = ObtenerBancos(datos);
        datos.remove("banco");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        BancoDao bandao = new BancoDao();
        datos.put("inactivos", bandao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarBanco(HashMap datos) {
        datos = ObtenerBanco(datos);
        Banco ban = (Banco)datos.get("banco");
        BancoDao bandao = new BancoDao();
        ban.setEstatus(1);
        bandao.actualizar(ban);
        datos = ObtenerInactivos(datos);
        datos.remove("banco");
        return datos;
    }
}
