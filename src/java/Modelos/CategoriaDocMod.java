/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.CategoriaDocDao;
import Modelo.Entidades.Catalogos.CategoriaDoc;
import java.util.HashMap;

/**
 *
 * @author usuario
 */
public class CategoriaDocMod {
    public CategoriaDocMod(){
    }

    public Sesion GestionarCategorias(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de categorias
                datos = ObtenerListado(datos);
                break;
            case 1:
                //nueva categoria
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar categoria
                datos = GuardarCategoria(datos);
                break;
            case 3:
                //editar categoria
                datos = ObtenerCategoria(datos);
                datos.put("accion", "editar");
                break;
            case 5:
                //baja de categoria
                datos = BajaDeCategoria(datos);
                break;
            case 6:
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                datos = ActivarCategoria(datos);
                break;
            case 97:
                datos.remove("inactivas");
                datos.remove("categoriadoc");
                break;
            case 98:
                //cancelar nueva-editar categoria
                datos.remove("categoriadoc");
                datos.remove("accion");
                break;
            case 99:
                //salir de gestionar categorias
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap ObtenerListado(HashMap datos) {
        CategoriaDocDao cddao = new CategoriaDocDao();
        datos.put("listado", cddao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarCategoria(HashMap datos) {
        String accion = datos.get("accion").toString();
        CategoriaDoc catdoc = (CategoriaDoc) datos.get("categoriadoc");
        CategoriaDocDao cddao = new CategoriaDocDao();
        if (accion.equals("nueva")){
            catdoc.setEstatus(1);
            cddao.guardar(catdoc);
        } else {
            cddao.actualizar(catdoc);
        }
        datos = ObtenerListado(datos);
        datos.remove("accion");
        
        return datos;
    }

    private HashMap ObtenerCategoria(HashMap datos) {
        CategoriaDocDao cddao = new CategoriaDocDao();
        CategoriaDoc cd = (CategoriaDoc)datos.get("categoriadoc");
        cd = cddao.obtener(cd.getId());
        datos.put("categoriadoc", cd);
        return datos;
    }

    private HashMap BajaDeCategoria(HashMap datos) {
        datos = ObtenerCategoria(datos);
        CategoriaDoc catdoc = (CategoriaDoc)datos.get("categoriadoc");
        catdoc.setEstatus(0);
        CategoriaDocDao cddao = new CategoriaDocDao();
        cddao.actualizar(catdoc);
        datos = ObtenerListado(datos);
        datos.remove("categoriadoc");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        CategoriaDocDao cddao = new CategoriaDocDao();
        datos.put("inactivas", cddao.obtenerListaInactivos());
        return datos;
    }

    private HashMap ActivarCategoria(HashMap datos) {
        datos = ObtenerCategoria(datos);
        CategoriaDoc catdoc = (CategoriaDoc)datos.get("categoriadoc");
        catdoc.setEstatus(1);
        CategoriaDocDao cddao = new CategoriaDocDao();
        cddao.actualizar(catdoc);
        datos = ObtenerInactivas(datos);
        datos = ObtenerListado(datos);
        datos.remove("categoriadoc");
        return datos;
    }
}
