/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Serie;
import Modelo.Entidades.TipoMov;
import Modelos.TipoMovMod;
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
public class GestionarTiposMovControl extends Action{
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
        TipoMovMod tmovMod = new TipoMovMod();
        sesion = tmovMod.GestionarTipoMov(sesion);
        
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
                //ir a nuevo tipomov (1) || ir a inactivos (6) || salir inactivos (97) || cancelar nuevo | editar tipomov (98) || salir de gestionar tiposmov (99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar tipomov nuevo (2) || guardar tipomov editado (4)
                CargarTipoMov();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7:
                //ir a editar tipomov (3) || baja de tipomov (5) || activar tipomov (7)
                TipoMov tmov = new TipoMov();
                tmov.setId(Integer.parseInt(request.getParameter("idMov")));
                datos.put("tipomov", tmov);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarTipoMov() {
        TipoMov tmov = new TipoMov();
        if (datos.get("accion").toString().equals("editar"))
            tmov = (TipoMov)datos.get("tipomov");
        try {
            tmov.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarUnidadesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        tmov.setValor(Integer.parseInt(request.getParameter("categoria")));
        Serie ser = new Serie();
        ser.setId(Integer.parseInt(request.getParameter("serie")));
        if (ser.getId()==0)
            ser = null;
        tmov.setSerie(ser);
        tmov.setCategoria(Integer.parseInt(request.getParameter("categoria")));
        
        datos.put("tipomov", tmov);
    }
    
}
