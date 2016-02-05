/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Ruta;
import Modelo.Entidades.Sucursal;
import Modelos.InventarioMod;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

/**
 *
 * @author usuario
 */
public class GestionarAcumProdControl extends Action{
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
        sesion = invMod.AcumuladoProductos(sesion);
        if (paso.equals("2") || paso.equals("3") || paso.equals("4") || paso.equals("5")){
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
        }
        
        
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
        String paginaSig = "", cts = "", fechI = "",fechF = "";
        HashMap param = new HashMap();
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
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2:
                //imprimir acumulado
                cts = request.getParameter("dato1");
                //String tipo = request.getParameter("dato2");
                fechI = datos.get("fechaini").toString();
                fechF = datos.get("fechafin").toString();
                fechI = fechI.substring(6,10)+"-"+fechI.substring(3,5)+"-"+fechI.substring(0,2);
                fechF = fechF.substring(6,10)+"-"+fechF.substring(3,5)+"-"+fechF.substring(0,2);
                if (!fechI.equals("") && !fechF.equals("")){
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/acumuladoprodsper.jasper"));
                    param.put("FECHAINI", fechI);
                    param.put("FECHAFIN", fechF);
                } else {
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/acumuladoprods.jasper"));
                    if (!fechI.equals(""))
                        param.put("FECHA", fechI);
                    else
                        param.put("FECHA", fechF);
                }

                //otros parametros
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                Sucursal suc = (Sucursal)datos.get("sucursalSel");
                param.put("SUCURSAL", new Integer(suc.getId()));
                Ruta ru = (Ruta)datos.get("ruta");
                param.put("RUTA", new Integer(ru.getId()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                //param.put("TIPO", new Integer(Integer.parseInt(tipo)));
                param.put("CTS", cts);
                datos.put("parametros", param);
                //sesion.setPaginaSiguiente("/Inventario/Movimientos/gestionarmovimientos.jsp");
                break;
            case 3:
                //imprimir lista de cts
                cts = request.getParameter("dato1");
                fechI = datos.get("fechaini").toString();
                fechF = datos.get("fechafin").toString();
                fechI = fechI.substring(6,10)+"-"+fechI.substring(3,5)+"-"+fechI.substring(0,2);
                fechF = fechF.substring(6,10)+"-"+fechF.substring(3,5)+"-"+fechF.substring(0,2);
                if (!fechI.equals("") && !fechF.equals("")){
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/listactsper.jasper"));
                    param.put("FECHAINI", fechI);
                    param.put("FECHAFIN", fechF);
                } else {
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/listacts.jasper"));
                    if (!fechI.equals(""))
                        param.put("FECHA", fechI);
                    else
                        param.put("FECHA", fechF);
                }

                //otros parametros
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                Sucursal sucu = (Sucursal)datos.get("sucursalSel");
                param.put("SUCURSAL", new Integer(sucu.getId()));
                Ruta rut = (Ruta)datos.get("ruta");
                param.put("RUTA", new Integer(rut.getId()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                param.put("CTS", cts);
                datos.put("parametros", param);
                //sesion.setPaginaSiguiente("/Inventario/Movimientos/gestionarmovimientos.jsp");
                break;
            case 4: case 5:
                //imprimir prods x ct
                datos.put("cts", request.getParameter("dato1"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/salidaprog.jasper"));
                if (Integer.parseInt(paso)==5)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/cambioscts.jasper"));

                //otros parametros
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                datos.put("parametros", param);
                //sesion.setPaginaSiguiente("/Inventario/Movimientos/gestionarmovimientos.jsp");
                break;
            case 99:
                //salir de acumulado de productos(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
        }
        datos.put("paso", paso);
    }
    
}
