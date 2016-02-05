/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoDocumentoDao;
import Modelo.Daos.Catalogos.CategoriaDocDao;
import Modelo.Entidades.Catalogos.TipoDocumento;
import java.util.HashMap;

/**
 *
 * @author usuario
 */
public class TipoDocumentoMod {
    public TipoDocumentoMod(){
    }

    public Sesion GestionarTiposDocumentos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de tipos de cambio activos
                datos = ObtenerTiposDocumentos(datos);
                break;
            case 1:
                //ir a nuevo tipodoc de cambio
                datos.put("accion", "nuevo");
                datos = CargarCategorias(datos);
                break;
            case 2: case 4:
                //guardar tipodoc cambio (2) | editado(4)
                datos = GuardarTipoDocumento(datos);
                break;
            case 3:
                //obtener tipodoc de cambio
                datos = ObtenerTipo(datos);
                datos = CargarCategorias(datos);
                break;
            case 5:
                //baja de tipodoc de cambio
                datos = BajaDeTipo(datos);
                break;
            case 6:
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar tipodoc de cambio
                datos = ActivarTipoDocumento(datos);
                break;
            case 97:
                //cancelar inactivos
                datos.remove("tcinactivos");
                break;
            case 98:
                //cancelar nuevo tipodoc cambio
                datos.remove("accion");
                datos.remove("tipodoc");
                break;
            case 99:
                //salir de gestionar tipos de cambios
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerTiposDocumentos(HashMap datos) {
        TipoDocumentoDao tdDao = new TipoDocumentoDao();
        datos.put("listado", tdDao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarTipoDocumento(HashMap datos) {
        TipoDocumento tipodoc = (TipoDocumento)datos.get("tipodoc");
        TipoDocumentoDao tdDao = new TipoDocumentoDao();
        if (datos.get("accion").toString().equals("nuevo")){
            CategoriaDocDao cddao = new CategoriaDocDao();
            tipodoc.setCategoria(cddao.obtener(tipodoc.getCategoria().getId()));
            tipodoc.setEstatus(1);
            tdDao.guardar(tipodoc);
        } else
            tdDao.actualizar(tipodoc);
        
        datos = ObtenerTiposDocumentos(datos);
        datos.remove("accion");
        datos.remove("tipodoc");
        return datos;
    }

    private HashMap ObtenerTipo(HashMap datos) {
        TipoDocumento tipodoc = (TipoDocumento)datos.get("tipodoc");
        TipoDocumentoDao tdDao = new TipoDocumentoDao();
        tipodoc = tdDao.obtener(tipodoc.getId());
        datos.put("tipodoc", tipodoc);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeTipo(HashMap datos) {
        TipoDocumento tipodoc = (TipoDocumento)datos.get("tipodoc");
        TipoDocumentoDao tdDao = new TipoDocumentoDao();
        tdDao.actualizarEstatus(0, tipodoc.getId());
        datos = ObtenerTiposDocumentos(datos);
        datos.remove("tipodoc");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        TipoDocumentoDao tdDao = new TipoDocumentoDao();
        datos.put("tcinactivos", tdDao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarTipoDocumento(HashMap datos) {
        TipoDocumento tipodoc = (TipoDocumento)datos.get("tipodoc");
        TipoDocumentoDao tdDao = new TipoDocumentoDao();
        tdDao.actualizarEstatus(1, tipodoc.getId());
        datos = ObtenerTiposDocumentos(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("tipodoc");
        return datos;
    }

    private HashMap CargarCategorias(HashMap datos) {
        CategoriaDocDao cddao = new CategoriaDocDao();
        datos.put("categorias", cddao.obtenerListaActivos());
        return datos;
    }
}
