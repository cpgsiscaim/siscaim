/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelos.ProductosCtMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarProductosDeCTControl extends Action{
    private Sesion sesion = new Sesion();
    private HashMap datos = new HashMap();
    private String paso = "0";

    @Override
    public void run() throws ServletException, IOException {
        //validar usuario logueado
        HttpSession sesionHttp = request.getSession(true);
        
        //validar si la sesion es valida
        sesion = (Sesion) sesionHttp.getAttribute("sesion");
        if (sesion==null || sesion.getUsuario()==null)
            throw new ServletException ("No existe una sesión válida");
        datos = sesion.getDatos();
        //obtener parámetros
        this.asignaParametros();
        sesion.setDatos(datos);
        
        //instanciar modelo y método de operación
        ProductosCtMod pctMod = new ProductosCtMod();
        sesion = pctMod.GestionarProductosCt(sesion);

        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);
        
        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+sesion.getPaginaSiguiente());
        
        rd.forward(request, response);        
    }

    @Override
    public void asignaParametros() {
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig")!=null?request.getParameter("pasoSig"):"0";
        String paginaSig = "";
        switch (Integer.parseInt(paso)){
            case 0:
                //paso inicial: obtener la vista de los parametros
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case 1: case 2: case 7: case 9: case 97: case 98: case 99:
                // ir a nuevo centro (2) || ir a inactivos (7) || salir de inactivos (97) || 
                //cancelar nuevo|editar centro(98) || cancelar de gestionar productos de ct(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3:
                datos.put("dettipo", request.getParameter("tipo"));
                datos.put("detcant", request.getParameter("cantidad"));
                datos.put("prodssel", request.getParameter("prodssel"));
                datos.put("unidadsel", request.getParameter("unidad"));
                datos.put("almacensel", request.getParameter("almacen"));
                datos.put("ubicacionsel", request.getParameter("ubicacion"));
                datos.put("imprimirsel", request.getParameter("imprimir")!=null?request.getParameter("imprimir"):"");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 5:
                //guardar centro (3) || guardar editado (5)
                CargaProdCT();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8:
                //ir a editar centro (4) || baja de centro (6) || activar centro (7)
                ProductosCt pct = new ProductosCt();
                pct.setId(Integer.parseInt(request.getParameter("idPct")));
                datos.put("prodct", pct);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 10:
                //guardar cantidades
                CargaDatosEditadosEnListado();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 50:
                //obtener unidades de producto
                Producto prod = new Producto();
                prod.setId(Integer.parseInt(request.getParameter("producto")));
                datos.put("productosel", prod);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            
        }
        datos.put("paso", paso);
    }

    private void CargaProdCT() {
        ProductosCt prod = new ProductosCt();
        prod.setProducto(new Producto());
        prod.setUnidad(new Unidad());
        prod.setAlmacen(new Almacen());
        if (datos.get("accion").toString().equals("editar"))
            prod = (ProductosCt)datos.get("prodct");
        /*try {
            prod.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarCentrosTrabControl.class.getName()).log(Level.SEVERE, null, ex);
        }*/
        prod.getProducto().setId(Integer.parseInt(request.getParameter("producto")));
        prod.getUnidad().setId(Integer.parseInt(request.getParameter("unidad")));
        prod.setCantidad(Float.parseFloat(request.getParameter("cantidad").replace(",", "")));
        prod.getAlmacen().setId(Integer.parseInt(request.getParameter("almacen")));
        prod.setPrecio(Float.parseFloat(request.getParameter("precio").replace(",", "")));
        //verificar configuracion de entregas
        prod.setConfigentrega(0);
        prod.setTipoentrega(0);
        prod.setDiasentrega(0);
        int cat = Integer.parseInt(datos.get("categoria").toString());
        if (cat == 1){//&& prod.getTipo()==0
            CentroDeTrabajo ctrab = (CentroDeTrabajo)datos.get("centro");
            if (ctrab.getConfigentrega()!=2){
                int confent = Integer.parseInt(request.getParameter("opcconfig"));
                if (confent==1){
                    prod.setConfigentrega(1);
                    if ((ctrab.getConfigentrega()==0 && ctrab.getContrato().getTipoentrega()==0)
                            || (ctrab.getConfigentrega()==1 && ctrab.getTipoentrega()==0)){
                        //obtener los dias de entrega
                        prod.setTipoentrega(0);
                        prod.setDiasentrega(Integer.parseInt(request.getParameter("numdias")));
                    } else if ((ctrab.getConfigentrega()==0 && ctrab.getContrato().getTipoentrega()==1)
                            || (ctrab.getConfigentrega()==1 && ctrab.getTipoentrega()==1)){
                        //obtener la lista de fechas
                        prod.setTipoentrega(1);
                        prod.setDiasentrega(0);
                        datos.put("listafechas", request.getParameter("lstfechas"));
                    }
                }
            }
        }
        prod.setTipo(Integer.parseInt(request.getParameter("tipo")));
        
        prod.setImprimir(0);
        String impr = request.getParameter("imprimir")!=null?request.getParameter("imprimir"):"";
        if (impr.equals("on"))
            prod.setImprimir(1);
        
        datos.put("prodct", prod);
    }

    private void CargaDatosEditadosEnListado() {
        //List<Float> cants = new ArrayList<Float>();
        List<ProductosCt> prods = (List<ProductosCt>)datos.get("productosct");
        for (int i=0; i < prods.size(); i++){
            ProductosCt pct = prods.get(i);
            pct.setCantidad(Float.parseFloat(request.getParameter("cant"+i).replace(",", "")));
            pct.setTipo(Integer.parseInt(request.getParameter("tipo"+i)));
            pct.setImprimir(0);
            String impr = request.getParameter("imprimir"+i)!=null?request.getParameter("imprimir"+i):"";
            if (impr.equals("on"))
                pct.setImprimir(1);
        }
        datos.put("productosct", prods);
    }
}
