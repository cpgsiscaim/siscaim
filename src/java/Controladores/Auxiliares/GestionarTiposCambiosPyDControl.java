/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.TipoCambio;
import Modelo.Entidades.Catalogos.TipoCambioPyD;
import Modelos.TipoCambioPyDMod;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarTiposCambiosPyDControl extends Action {
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
        TipoCambioPyDMod tcamMod = new TipoCambioPyDMod();
        sesion = tcamMod.GestionarTiposCambiosPyD(sesion);

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
            case 1: case 6: case 97: case 98: case 99:
                //ir a nuevo tipo cambio (1) || ir a inactivos (6)
                // cancelar inactivos (97) || cancelar nuevo tipo cambio(98) || salir de gestionar tipos cambios(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar tipo cambio nuevo (2) | editado (4)
                CargarTipoCambio();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7:
                //ir a editar tipo cambio (3) || baja de tipo de cambio(5) || activar tipo de cambio (7)
                TipoCambioPyD tipo = new TipoCambioPyD();
                tipo.setId(Integer.parseInt(request.getParameter("idTcPyD")));
                datos.put("tcpyd", tipo);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
                
        }
        datos.put("paso", paso);
    }

    private void CargarTipoCambio() {
        TipoCambioPyD tipo = new TipoCambioPyD();
        //tipo.setPerded(new PeryDed());
        tipo.setTipocambio(new TipoCambio());
        if (datos.get("accion").toString().equals("editar"))
            tipo = (TipoCambioPyD)datos.get("tcpyd");
        //tipo.getPerded().setIdPeryded(Integer.parseInt(request.getParameter("perded")));
        tipo.getTipocambio().setId(Integer.parseInt(request.getParameter("tipocambio")));
        datos.put("tcpyd", tipo);
    }

}
