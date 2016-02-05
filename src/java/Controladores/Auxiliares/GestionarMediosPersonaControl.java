/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Catalogos.TipoMedio;
import Modelo.Entidades.Medio;
import Modelo.Entidades.PersonaMedio;
import Modelo.Entidades.Persona;
import Modelos.PersonaMedioMod;
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
public class GestionarMediosPersonaControl extends Action{
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
        PersonaMedioMod pmMod = new PersonaMedioMod();
        sesion = pmMod.GestionarMediosPersona(sesion);

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
                break;
            case 1: case 6: case 97: case 98: case 99:
                //ir a nuevo pmedio (1) || ir a inactivos (6) || cancelar inactivos (97) || cancelar nuevo pmedio(98) || salir de gestionar familiares(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar pmedio nuevo (2) | editada (4)
                CargarMedioPer();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7:
                //ir a editar pmedio (3) || baja de pmedio(5) || activar pmedio (7)
                PersonaMedio pmedio = new PersonaMedio();
                pmedio.setId(Integer.parseInt(request.getParameter("idMp")));
                datos.put("pmedio", pmedio);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarMedioPer() {
        PersonaMedio pmedio = new PersonaMedio();
        pmedio.setMedio(new Medio());
        pmedio.setPersona(new Persona());
        pmedio.getMedio().setTipo(new TipoMedio());
        if (datos.get("accion").toString().equals("editar"))
            pmedio = (PersonaMedio)datos.get("pmedio");
        
        pmedio.getMedio().getTipo().setIdtipomedio(Integer.parseInt(request.getParameter("tipomedio")));
        try {
            pmedio.getMedio().setMedio(new String(request.getParameter("medio").getBytes("ISO-8859-1"), "UTF-8"));
            pmedio.setObservaciones(new String(request.getParameter("observacion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarMediosPersonaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        datos.put("pmedio", pmedio);
    }
}
