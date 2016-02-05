/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Serie;
import Modelos.SerieMod;
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
public class GestionarSeriesControl extends Action{
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
        SerieMod serMod = new SerieMod();
        sesion = serMod.GestionarSeries(sesion);
        
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
                //ir a nueva unidad (1) || ir a inactivas (6) || salir inactivas (97) || cancelar nueva | editar unidad (98) || salir de gestionar unidades (99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar unidad nueva (2) || guardar unidad editada (4)
                CargarSerie();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7:
                //ir a editar unidad (3) || baja de unidad (5) || activar unidad (7)
                Serie ser = new Serie();
                ser.setId(Integer.parseInt(request.getParameter("idSer")));
                datos.put("serie", ser);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarSerie() {
        Serie ser = new Serie();
        if (datos.get("accion").toString().equals("editar"))
            ser = (Serie)datos.get("serie");
        try {
            ser.setSerie(new String(request.getParameter("clave").getBytes("ISO-8859-1"), "UTF-8"));
            ser.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
            String form = request.getParameter("formato")!=null?request.getParameter("formato"):"";
            String puer = request.getParameter("puerto")!=null?request.getParameter("puerto"):"";
            ser.setFormato(new String(form.getBytes("ISO-8859-1"), "UTF-8"));
            ser.setPuerto(new String(puer.getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarUnidadesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        ser.setFolio(Float.parseFloat(request.getParameter("folio")));
        datos.put("serie", ser);
    }
    
}

