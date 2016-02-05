/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Catalogos.CuentasTelecomm;
import Modelos.CuentasTelecommMod;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author usuario
 */
public class GestionarCuentasTelecommControl extends Action{
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
        CuentasTelecommMod ctamod = new CuentasTelecommMod();
        sesion = ctamod.GestionarCuentasTelecomm(sesion);

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
            case 1: case 5: case 98: case 99:
                //nuevo cuenta(1) || ir a inactivos(5) || cancelar inactivos (98) || salir de gestionar cuentas(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4: case 6:
                //editar cuenta(2) || baja de cuenta(4) || activar cuenta (6)
                CuentasTelecomm ctaed = new CuentasTelecomm();
                ctaed.setId(Integer.parseInt(request.getParameter("idCta")));
                datos.put("cuenta", ctaed);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3:
                //guardar cuenta
                CuentasTelecomm cta = new CuentasTelecomm();
                if (datos.get("accion").toString().equals("editar"))
                    cta = (CuentasTelecomm)datos.get("cuenta");
                cta.setNombre(request.getParameter("nombre"));
                cta.setCotiza(0);
                String scot = request.getParameter("cotiza");
                if (scot!=null && scot.equals("on"))
                    cta.setCotiza(1);
                datos.put("cuenta", cta);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }
    
}
