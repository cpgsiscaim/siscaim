/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Equipo;
import Modelo.Entidades.Servicio;
import Modelos.ServicioMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
public class GestionarServiciosControl extends Action{
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
        ServicioMod servMod = new ServicioMod();
        sesion = servMod.GestionarServicios(sesion);
        /*if (paso.equals("12"))
            MuestraReporte((byte[])sesion.getDatos().get("pdf"));*/
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
            case 1: case 6: case 9: case 11: case 96: case 97: case 98: case 99:
                // ir a nuevo activo(1) || ir a inactivos(6) || ir a filtrar lista(9) || quitar filtros (11)
                //cancelar inactivos(97) || cancelar nuevo servicio (98) || salir de gestionar servicios(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 4:
                //guardar nuevo servicio(2) || guardar servicio editado (4)
                CargaServicio();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5: case 7: case 13:
                //ir a editar servicio(4) || baja de servicio (5) || activar servicio(7) || ir a contratos (13)
                Servicio serv = new Servicio();
                serv.setId(Integer.parseInt(request.getParameter("idServ")));
                datos.put("servicio", serv);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            /*case 10:
                //aplicar filtros
                CargaFiltros();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 12:
                //imprimir lista
                CargaDatosReporte();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;*/
        }
        datos.put("paso", paso);
    }

    private void CargaServicio(){
        Servicio serv = new Servicio();
        if (datos.get("accion").toString().equals("editar"))
            serv = (Servicio)datos.get("servicio");
        try {
            serv.setFactura(new String(request.getParameter("factura").getBytes("ISO-8859-1"), "UTF-8"));
            serv.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        String sfecha = request.getParameter("fecha");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
        Date fecha = null;
        try {
            fecha = formatoDelTexto.parse(sfecha);
        } catch (ParseException ex) {
        }        
        serv.setFecha(fecha);
        serv.setMonto(Float.parseFloat(request.getParameter("monto")));
        Equipo activo = (Equipo)datos.get("activo");
        if (activo.getTipoactivo().getId()==2)
            serv.setKilometraje(Float.parseFloat(request.getParameter("kilometraje")));
        
        datos.put("servicio", serv);
    }

}
