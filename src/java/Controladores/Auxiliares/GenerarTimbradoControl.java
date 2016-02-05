/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelos.TimbradoMod;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import static javax.servlet.SessionTrackingMode.URL;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GenerarTimbradoControl extends Action{
    
    private Sesion sesion = new Sesion();
    private HashMap datos = new HashMap();
    private String paso = "0";
    

    @Override
    public void run() throws ServletException, IOException {
        //validar usuario logueado
        HttpSession sesionHttp = request.getSession(true);

        //validar si la sesion es valida
        sesion = (Sesion) sesionHttp.getAttribute("sesion");
        if (sesion == null || sesion.getUsuario() == null) {
            throw new ServletException("No existe una sesión válida");
        }
        datos = sesion.getDatos();
        //obtener parámetros
        this.asignaParametros();
        sesion.setDatos(datos);

        //instanciar modelo y método de operación
        TimbradoMod timmod = new TimbradoMod();
        sesion = timmod.GenerarTimbrado(sesion);
        
        if (paso.equals("1")){
            
            //imprimir xls
            datos = sesion.getDatos();
            File f = (File)datos.get("timbrado");
            /*URLConnection  conn = new URL(f.getAbsolutePath()).openConnection();
            conn.connect();*/          
            //byte[] bytes = (byte[])datos.get("bytes");
            response.setHeader("Content-Length", String.valueOf(f.length())); 
            response.setHeader("Content-Disposition", "attachment;filename=" + f.getName()); 
            response.setContentType("application/vnd.openxml");
            //response.setHeader("Content-Disposition", "attachment;filename=\""+);
            //response.setContentLength(bytes.length);
            InputStream in = new FileInputStream(f);
            ServletOutputStream oustrm;
            int bit = 256;
            try
            {
                oustrm = response.getOutputStream();
                while(bit>=0){
                    bit = in.read();
                    oustrm.write(bit);
                }
                oustrm.flush();
                oustrm.close();
                in.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }            
        }//imprimir xls
        
        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);

        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());

        if (rd == null) {
            throw new ServletException("No se pudo encontrar " + sesion.getPaginaSiguiente());
        }

        rd.forward(request, response);
    }

    @Override
    public void asignaParametros() {
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig") != null ? request.getParameter("pasoSig") : "0";
        String vista = "";
        String paginaSig = "";
        HashMap param = new HashMap();
        switch (Integer.parseInt(paso)) {
            case 0:
                //paso inicial: obtener los parámetros de la pagina a cargar
                vista = request.getParameter("vista") != null ? request.getParameter("vista") : "";
                String idoperacion = request.getParameter("operacion") != null ? request.getParameter("operacion") : "";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case -1:
                datos.put("rpsel", request.getParameter("sucursal"));
                datos.put("aniosel", request.getParameter("aniosel"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 1:
                datos.put("rpsel", request.getParameter("sucursal"));
                datos.put("aniosel", request.getParameter("aniosel"));
                datos.put("quincenas", request.getParameter("quincenas"));
                datos.put("plantilla", application.getRealPath("Nomina/Timbrado/timbrado.xlsx"));
                datos.put("ruta", application.getRealPath("Nomina/Timbrado"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2:
                //timbrado de aguinaldos
                datos.put("rpsel", request.getParameter("sucursal"));
                datos.put("aniosel", request.getParameter("aniosel"));
                datos.put("plantilla", application.getRealPath("Nomina/Timbrado/aguinaldos.xlsx"));
                datos.put("ruta", application.getRealPath("Nomina/Timbrado"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 99:
                //salir de generar timbrado
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
        }
        datos.put("paso", paso);
    }
    
}
