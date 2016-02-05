/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Catalogos.TipoActivo;
import Modelo.Entidades.Equipo;
import Modelo.Entidades.Sucursal;
import Modelos.EquipoMod;
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
public class GestionarActivosControl extends Action{
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
        EquipoMod equiMod = new EquipoMod();
        sesion = equiMod.GestionarEquipos(sesion);
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
            case 1:
                //cargar activos de sucursal y de tipo de activo
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucSel);
                TipoActivo tipoSel = new TipoActivo();
                tipoSel.setId(Integer.parseInt(request.getParameter("tipoactsel")));
                datos.put("tipoactSel", tipoSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 7: case 96: case 97: case 98: case 99:
                // ir a nuevo activo(2) || ir a inactivos(7)
                //cancelar inactivos(97) || cancelar nuevo activo (98) || salir de gestionar activos(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5:
                //guardar nuevo cliente(3) || guardar cliente editado (5)
                CargaNuevoActivo();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8: case 9:
                //ir a editar activo(4) || baja de activo (6) || activar activo(8) || ir a servicios (9)
                Equipo activo = new Equipo();
                activo.setId(Integer.parseInt(request.getParameter("idAct")));
                datos.put("activo", activo);
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
    
    private void CargaNuevoActivo(){
        Equipo activo = new Equipo();
        if (datos.get("accion").toString().equals("editar"))
            activo = (Equipo)datos.get("activo");
        try {
            activo.setCodigo(new String(request.getParameter("codigo").getBytes("ISO-8859-1"), "UTF-8"));
            activo.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
            activo.setSerie(new String(request.getParameter("serie").getBytes("ISO-8859-1"), "UTF-8"));
            activo.setModelo(new String(request.getParameter("modelo").getBytes("ISO-8859-1"), "UTF-8"));
            TipoActivo tactSel = (TipoActivo)datos.get("tipoactSel");
            if (tactSel.getId()==2){
                activo.setPlaca(new String(request.getParameter("placa").getBytes("ISO-8859-1"), "UTF-8"));
                activo.setMotor(new String(request.getParameter("motor").getBytes("ISO-8859-1"), "UTF-8"));
            } else {
                activo.setPlaca("");
                activo.setMotor("");
            }
            activo.setFactura(new String(request.getParameter("factura").getBytes("ISO-8859-1"), "UTF-8"));
            activo.setPrecio(Float.parseFloat(new String(request.getParameter("precio").getBytes("ISO-8859-1"), "UTF-8")));            
            activo.setCaracteristicas(new String(request.getParameter("caracteristicas").getBytes("ISO-8859-1"), "UTF-8"));            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        datos.put("activo", activo);
    }
}
