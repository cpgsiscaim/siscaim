/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.CategoriaDao;
import Modelo.Daos.SubcategoriaDao;
import Modelo.Entidades.Categoria;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class CategoriaMod {
    public CategoriaMod(){
    }

    public Sesion GestionarCategorias(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de almacenes activos
                datos = ObtenerCategorias(datos);
                break;
            case 1:
                //ir a nueva categoria
                datos.put("accion", "nueva");
                break;
            case 2:
                //guardar nueva categoria
                datos = GuardarNuevaCategoria(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Categorias/nuevacategoria.jsp");
                    datos.remove("error");
                }
                break;
            case 3:
                //ir a editar categoria
                datos = ObtenerCategoria(datos);
                break;
            case 4:
                //actualiza categoria editada
                datos = ActualizaCategoria(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Categorias/nuevacategoria.jsp");
                    datos.remove("error");
                }
                break;
            case 5:
                //baja de categoria
                datos = BajaDeCategoria(datos);
                break;
            case 6:
                //obtener inactivas
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                //activar categoria
                datos = ActivarCategoria(datos);
                break;
            case 8:
                //ir a subcategorias
                datos = ObtenerSubcategorias(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar de nueva categoria
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

    private HashMap ObtenerCategorias(HashMap datos) {
        CategoriaDao catDao = new CategoriaDao();
        datos.put("listado", catDao.obtenerListaActivas());
        return datos;
    }

    private HashMap GuardarNuevaCategoria(HashMap datos) {
        Categoria cat = (Categoria)datos.get("categoriaNueva");
        CategoriaDao catDao = new CategoriaDao();
        if (!catDao.ValidaCategoria(cat)){
            catDao.guardar(cat);
            datos = ObtenerCategorias(datos);
            datos.remove("accion");
            datos.remove("categoriaNueva");
        } else {
            datos.put("error", "La Clave de Categoría ya existe");
        }
        return datos;
    }

    private HashMap ObtenerCategoria(HashMap datos) {
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        CategoriaDao catDao = new CategoriaDao();
        cat = catDao.obtener(cat.getId());
        datos.put("categoriaEditar", cat);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap ActualizaCategoria(HashMap datos) {
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        CategoriaDao catDao = new CategoriaDao();
        if (!catDao.ValidaCategoria(cat)){
            catDao.actualizar(cat);
            datos = ObtenerCategorias(datos);
            datos.remove("accion");
            datos.remove("categoriaEditar");
        } else {
            datos.put("error", "La Clave de Categoría ya existe");
        }
        return datos;
    }

    private HashMap BajaDeCategoria(HashMap datos) {
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        CategoriaDao catDao = new CategoriaDao();
        catDao.actualizarEstatus(0, cat.getId());
        datos = ObtenerCategorias(datos);
        datos.remove("categoriaEditar");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        CategoriaDao catDao = new CategoriaDao();
        datos.put("inactivas", catDao.obtenerListaInactivas());
        return datos;
    }

    private HashMap ActivarCategoria(HashMap datos) {
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        CategoriaDao catDao = new CategoriaDao();
        catDao.actualizarEstatus(1, cat.getId());
        datos.put("inactivas", catDao.obtenerListaInactivas());
        datos.remove("categoriaEditar");
        datos = ObtenerCategorias(datos);
        return datos;
    }

    private HashMap ObtenerSubcategorias(HashMap datos) {
        datos = ObtenerCategoria(datos);
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        SubcategoriaDao subDao = new SubcategoriaDao();
        datos.put("listaSubcategorias", subDao.obtenerListaActivasDeCategoria(cat.getId()));
        return datos;
    }
    
}

