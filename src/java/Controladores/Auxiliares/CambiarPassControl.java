/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelos.UsuariosMod;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class CambiarPassControl extends Action{
    
    private Sesion sesion = new Sesion();
    private HashMap datos = new HashMap();
    private String paso = "0";
    
    public CambiarPassControl(){
        
    }

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
        if (Integer.parseInt(paso)!=0){
            UsuariosMod usmod = new UsuariosMod();
            sesion = usmod.CambiarPass(sesion);
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
            case 1:
                //obtener los datos para realizar el cambio del pass
                String passAct = request.getParameter("passAct")!=null?request.getParameter("passAct"):"";
                String passNva = request.getParameter("passNva")!=null?request.getParameter("passNva"):"";
                //String passConfirm = request.getParameter("passConfirm")!=null?request.getParameter("passConfirm"):"";
                
                datos.put("passAct", passAct);
                datos.put("passNva", passNva);
                //datos.put("passConfirm", passConfirm);                
        }
        
    }
    
}
