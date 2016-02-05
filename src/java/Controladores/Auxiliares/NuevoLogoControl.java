/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import javazoom.upload.MultipartFormDataRequest;
import javazoom.upload.UploadBean;

/**
 *
 * @author TEMOC
 */
public class NuevoLogoControl extends Action {
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
        
        String rutaLogo = application.getRealPath("/Imagenes/Empresa/Logotipo");
        UploadBean upbean = new UploadBean();

        try{
            MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
            datos.put("logoSel", mrequest.getParameter("logoNuevo"));
            upbean.setFolderstore(rutaLogo);
            upbean.setOverwrite(true);
            upbean.store(mrequest,"logoFile");
            sesion.setPaginaSiguiente(mrequest.getParameter("paginaSig"));

        }catch(Exception e){
        }
        
        sesion.setDatos(datos);
        
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
    }
    
}
