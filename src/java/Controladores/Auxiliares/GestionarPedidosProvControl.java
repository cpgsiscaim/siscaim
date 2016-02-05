/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelos.InventarioMod;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

/**
 *
 * @author usuario
 */
public class GestionarPedidosProvControl extends Action{

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
        InventarioMod invMod = new InventarioMod();
        sesion = invMod.GenerarPedidos(sesion);
        /*if (paso.equals("3")){
            //imprimir
            datos = sesion.getDatos();
            byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            //response.sendRedirect(application.getRealPath("/Utilerias/imprimeReporte.jsp"));
            ServletOutputStream oustrm;
            try
            {
                oustrm = response.getOutputStream();
                oustrm.write(bytes, 0, bytes.length);
                oustrm.flush();
                oustrm.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }*/
        
        
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
            case -1:
                //obtener la rutas de la sucursal seleccionada
                Sucursal sucsel = new Sucursal();
                sucsel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucsel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 1:
                //calcular acumulado de productos
                Ruta ruta = new Ruta();
                ruta.setId(Integer.parseInt(request.getParameter("ruta")));
                datos.put("ruta", ruta);
                datos.put("fechaini", request.getParameter("fechaini"));
                datos.put("fechafin", request.getParameter("fechafin"));
                datos.put("tipopedido", request.getParameter("tipopedido")!=null?request.getParameter("tipopedido"):"1");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2:
                //generar pedidos
                List<Almacen> alms = (List<Almacen>)datos.get("almacenes");
                List<Ubicacion> ubis = (List<Ubicacion>)datos.get("ubicaciones");
                if (alms.size()>1 || ubis.size()>1){
                    Almacen alm = new Almacen();
                    alm.setId(Integer.parseInt(request.getParameter("almacen")));
                    Ubicacion ubi = new Ubicacion();
                    ubi.setId(Integer.parseInt(request.getParameter("ubicacion")));
                    datos.put("almacen", alm);
                    datos.put("ubicacion", ubi);
                }
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3:
                //imprimir pedido
                Cabecera cab = new Cabecera();
                cab.setId(Integer.parseInt(request.getParameter("idMov")));
                datos.put("cabecera", cab);
                sesion.setPaginaAnterior("/Inventario/Reportes/pedidosgenerados.jsp");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 98: case 99:
                //salir de acumulado de productos(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
        }
        datos.put("paso", paso);
    }
    
}
