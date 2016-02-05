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
public class CerrarSesionControl extends Action{
    
    private Sesion sesion = new Sesion();

    public CerrarSesionControl(){
        
    }

    @Override
    public void run() throws ServletException, IOException {
        //validar usuario logueado
        HttpSession sesionHttp = request.getSession(true);
        
        //validar si la sesion es valida
        sesion = (Sesion) sesionHttp.getAttribute("sesion");
        if (sesion==null || sesion.getUsuario()==null)
            throw new ServletException ("No existe una sesión válida");
        //obtener los parametros
        this.asignaParametros();
        //obtener la pagina siguiente
        String pagina = sesion.getPaginaSiguiente();
        
        //inhabilitar la sesion
        sesion.Limpiar();
        sesionHttp.invalidate();
        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(pagina);
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+pagina);
        
        rd.forward(request, response);
    }

    @Override
    public void asignaParametros() {
        String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
        sesion.setPaginaSiguiente(vista);
    }
    
}
