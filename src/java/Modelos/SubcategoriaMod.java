/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.SubcategoriaDao;
import Modelo.Entidades.Categoria;
import Modelo.Entidades.Subcategoria;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class SubcategoriaMod {
    public SubcategoriaMod(){
    }
    
    public Sesion GestionarSubcategorias(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                break;
            case 1:
                //ir a nueva subcat
                datos.put("accion", "nueva");
                break;
            case 2: case 4:
                //guardar nueva subcat (2) || guardar subcar editada (4)
                datos = GuardarSubcategoria(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Categorias/Subcategorias/nuevasubcat.jsp");
                    datos.remove("error");
                }
                break;
            case 3:
                //ir a editar subcategoria
                datos = ObtenerSubcategoria(datos);
                break;
            case 5:
                //baja de subcat
                datos = BajaDeSubcategoria(datos);
                break;
            case 6:
                //ir a inactivas
                datos = ObtenerInactivas(datos);
                break;
            case 7:
                //activar subcat
                datos = ActivarSubcategoria(datos);
                break;
            case 97:
                //cancelar de inactivos
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar nueva | editar subcat
                datos.remove("subcat");
                datos.remove("accion");
                break;
            case 99:
                //salir de subcategorias
                datos.remove("listaSubcategorias");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
        
    }

    private HashMap GuardarSubcategoria(HashMap datos) {
        Subcategoria sub = (Subcategoria)datos.get("subcat");
        SubcategoriaDao subDao = new SubcategoriaDao();
        if (!subDao.ValidaMarca(sub)){        
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        if (datos.get("accion").toString().equals("nueva")){
            sub.setCategoria(cat);
            subDao.guardar(sub);
        } else {
            subDao.actualizar(sub);
        }
        datos.put("listaSubcategorias", subDao.obtenerListaActivasDeCategoria(cat.getId()));
        datos.remove("subcat");
        datos.remove("accion");
        } else {
            datos.put("error", "La Clave de Subcategoría ya existe");
        }
        return datos;
    }

    private HashMap ObtenerSubcategoria(HashMap datos) {
        Subcategoria sub = (Subcategoria)datos.get("subcat");
        SubcategoriaDao subDao = new SubcategoriaDao();
        sub = subDao.obtener(sub.getId());
        datos.put("subcat", sub);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeSubcategoria(HashMap datos) {
        Subcategoria sub = (Subcategoria)datos.get("subcat");
        SubcategoriaDao subDao = new SubcategoriaDao();
        subDao.actualizarEstatus(0, sub.getId());
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        datos.put("listaSubcategorias", subDao.obtenerListaActivasDeCategoria(cat.getId()));
        datos.remove("subcat");
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        SubcategoriaDao subDao = new SubcategoriaDao();
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        datos.put("inactivas", subDao.obtenerListaInactivasDeCategoria(cat.getId()));
        return datos;
    }

    private HashMap ActivarSubcategoria(HashMap datos) {
        Subcategoria sub = (Subcategoria)datos.get("subcat");
        SubcategoriaDao subDao = new SubcategoriaDao();
        subDao.actualizarEstatus(1, sub.getId());
        Categoria cat = (Categoria)datos.get("categoriaEditar");
        datos.put("inactivas", subDao.obtenerListaInactivasDeCategoria(cat.getId()));
        datos.put("listaSubcategorias", subDao.obtenerListaActivasDeCategoria(cat.getId()));        
        return datos;
    }
}
