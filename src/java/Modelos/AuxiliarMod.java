/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.ProductoDao;
import Modelo.Daos.ProductosCtDao;
import Modelo.Entidades.Producto;
import Modelo.Entidades.ProductosCt;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author usuario
 */
public class AuxiliarMod {

    public Sesion ProcesosAuxiliares(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        switch (paso){
            case 0:
                break;
            case 1:
                datos = ActualizarProductosCTs(datos);
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        
        return sesion;
    }

    private HashMap ActualizarProductosCTs(HashMap datos) {
        //obtener el listado de los prodscts a actualizar
        ProductosCtDao pctDao = new ProductosCtDao();
        String consulta = "from ProductosCt where cliente.sucursal<>3 and producto.clave not like '%-%'order by cliente.sucursal, descripcion";
        List<ProductosCt> lista = pctDao.obtenerDeConsulta(consulta);
        for (int i=0; i < lista.size(); i++){
            ProductosCt pct = lista.get(i);
            ProductoDao pddao = new ProductoDao();
            consulta = "from Producto where sucursal="+pct.getCliente().getSucursal().getId()+
                    " and clave like '%-"+pct.getProducto().getClave()+"'";
            List<Producto> prods = pddao.obtenerProductosFiltrado(consulta);
            if (!prods.isEmpty()){
                Producto p = prods.get(0);
                pct.setProducto(p);
                pct.setDescripcion(p.getDescripcion());
                pctDao.actualizar(pct);
            }
        }
        return datos;
    }
    
}
