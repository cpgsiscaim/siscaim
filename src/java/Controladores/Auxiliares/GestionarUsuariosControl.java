/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelos.UsuariosMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarUsuariosControl extends Action{
    
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
        UsuariosMod usuMod = new UsuariosMod();
        sesion = usuMod.GestionarUsuarios(sesion);
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
            case 1:
                //cargar usuarios de sucursal
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 7: case 11: case 50: case 51: case 52: case 53: case 97: case 98: case 99:
                // ir a nuevo usuario(2) || ir a inactivos(7) || 
                //ir al principio de la lista (50) || mostrar anteriores (51) || mostrar siguiente grupo(52) || ir al final de la lista(53)
                //cancelar inactivos(97) || cancelar nuevo usuario (98) || salir de gestionar usuarios(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5:
                //guardar nuevo usuario(3) || guardar usuario editado (5)
                CargaUsuario();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8: case 9:
                //ir a editar usuario(4) || baja de usuario (6) || activar usuario(8)
                //ir a permisos(9)
                Usuario usuario = new Usuario();
                usuario.setIdusuario(Integer.parseInt(request.getParameter("idUsu")));
                datos.put("usuario", usuario);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaUsuario() {
        Usuario usu = new Usuario();
        usu.setEmpleado(new Empleado());
        if (datos.get("accion").toString().equals("editar")){
            usu = (Usuario) datos.get("usuario");
            datos.put("usuact", usu.getUsuario());
        }
        usu.getEmpleado().setNumempleado(Integer.parseInt(request.getParameter("empleado")));
        try {
            usu.setUsuario(new String(request.getParameter("usuario").getBytes("ISO-8859-1"), "UTF-8"));
            usu.setPass(new String(request.getParameter("pass").getBytes("ISO-8859-1"), "UTF-8"));
            usu.setMailrecuperacion(new String(request.getParameter("mail").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        datos.put("usuario", usu);
    }

}
