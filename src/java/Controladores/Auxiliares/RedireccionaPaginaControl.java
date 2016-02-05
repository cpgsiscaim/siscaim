/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class RedireccionaPaginaControl extends Action {
    private Sesion sesion = new Sesion();
    
    @Override
    public void run() throws ServletException, IOException {
        //Cargar la sesión
        HttpSession sesionHttp = request.getSession(true);
        //si la sesion ya esta en sesionHttp se baja
        if (sesionHttp.getAttribute("sesion")!=null)
            sesion = (Sesion)sesionHttp.getAttribute("sesion");
        
        //se obtienen los datos de logueo
        this.asignaParametros();
        
        //en este caso este controlador solo carga la pagina que recibe como parametro
        
        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);
        
        //ir a la página siguiente correspondiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar bienvenida.jsp");
        
        rd.forward(request, response);
    }

    @Override
    public void asignaParametros() {
        String pagina = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
        sesion.setPaginaSiguiente(pagina);
    }
    
}
