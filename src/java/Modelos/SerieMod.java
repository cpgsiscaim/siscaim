/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.SerieDao;
import Modelo.Entidades.Serie;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class SerieMod {
    public SerieMod(){
    }

    public Sesion GestionarSeries(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerSeries(datos);
                break;
            case 1:
                //ir a nueva serie
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar serie nueva(2) | editada (4)
                datos = GuardarSerie(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Series/nuevaserie.jsp");
                    datos.remove("error");
                }
                break;
            case 3:
                //ir a editar serie
                datos = ObtenerSerie(datos);
                break;
            case 5:
                //baja de serie
                datos = BajaDeSerie(datos);
                break;
            case 6:
                //ir a inactivas
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                //activar serie
                datos = ActivarSerie(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar nueva | editar
                datos.remove("serie");
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

    private HashMap ObtenerSeries(HashMap datos) {
        SerieDao serDao = new SerieDao();
        datos.put("listado", serDao.obtenerListaActivas());
        return datos;
    }

    private HashMap GuardarSerie(HashMap datos) {
        Serie ser = (Serie)datos.get("serie");
        SerieDao serDao = new SerieDao();
        if (datos.get("accion").toString().equals("nuevo") && serDao.ValidaSerie(ser)){
            datos.put("error", "La Clave de la Serie ya existe");
            return datos;
        } else if (datos.get("accion").toString().equals("editar")){
            String claveact = datos.get("claveact").toString();
            if (!claveact.equals(ser.getSerie()) && serDao.ValidaSerie(ser)){
                datos.put("error", "La Clave de la Serie ya existe");
                return datos;
            }
        }
        
        if (datos.get("accion").toString().equals("nueva")){
            ser.setEstatus(1);
            serDao.guardar(ser);
        } else {
            serDao.actualizar(ser);
        }
        datos = ObtenerSeries(datos);
        datos.remove("serie");
        datos.remove("accion");
        
        return datos;
    }

    private HashMap ObtenerSerie(HashMap datos) {
        Serie ser = (Serie)datos.get("serie");
        SerieDao serDao = new SerieDao();
        ser = serDao.obtener(ser.getId());
        datos.put("serie", ser);
        datos.put("claveact", ser.getSerie());
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeSerie(HashMap datos) {
        Serie ser = (Serie)datos.get("serie");
        SerieDao serDao = new SerieDao();
        serDao.actualizarEstatus(0, ser.getId());
        datos = ObtenerSeries(datos);
        datos.remove("serie");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        SerieDao serDao = new SerieDao();
        datos.put("inactivas", serDao.obtenerListaInactivas());
        return datos;
    }

    private HashMap ActivarSerie(HashMap datos) {
        Serie ser = (Serie)datos.get("serie");
        SerieDao serDao = new SerieDao();
        serDao.actualizarEstatus(1, ser.getId());
        datos = ObtenerSeries(datos);
        datos = ObtenerInactivas(datos);
        datos.remove("serie");
        return datos;
    }
    
}
