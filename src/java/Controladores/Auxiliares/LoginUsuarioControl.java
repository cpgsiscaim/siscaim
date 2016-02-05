/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Encriptar;
import Generales.Sesion;
import Modelo.Entidades.Usuario;
import Modelos.UsuariosMod;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class LoginUsuarioControl extends Action{
    
    private Sesion sesion = new Sesion();
    
    public LoginUsuarioControl(){
        
    }

    @Override
    public void run() throws ServletException, IOException {
        //Cargar la sesión
        HttpSession sesionHttp = request.getSession(true);
        //borra todas las variables de sesion
        Enumeration atributos = sesionHttp.getAttributeNames();
        while (atributos.hasMoreElements())
        {
            String sAtrib = atributos.nextElement().toString();
            sesionHttp.removeAttribute(sAtrib);
        }

        //se obtienen los datos de logueo
        this.asignaParametros();
        
        //instanciar el modelo de logueo
        
        UsuariosMod usMod = new UsuariosMod();
        sesion = usMod.LogueaUsuario(sesion);
        
        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);
        
        //ir a la página siguiente correspondiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+sesion.getPaginaSiguiente());
        
        rd.forward(request, response);
    }

    @Override
    public void asignaParametros() {
        //obtener los parametros de la pagina
        String sUsuario = request.getParameter("usuario")!=null?request.getParameter("usuario"):"";
        String sPass = request.getParameter("pass")!=null?request.getParameter("pass"):"";
        
        Usuario usuario = new Usuario(sUsuario, sPass);
        sesion.setUsuario(usuario);
    }
    
}
