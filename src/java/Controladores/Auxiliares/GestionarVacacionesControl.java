/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Vacaciones;
import Modelos.VacacionesMod;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarVacacionesControl extends Action{
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
        VacacionesMod vacmod = new VacacionesMod();
        sesion = vacmod.GestionarVacaciones(sesion);
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
        HashMap param = new HashMap();
        switch (Integer.parseInt(paso)){
            case 0:
                //obtener listado de vacaciones pagadas del empleado
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case 1: case 98: case 99:
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                if (paso.equals("99") && sesion.getPaginaAnterior()!=null && !sesion.getPaginaAnterior().equals("")){
                    sesion.setPaginaSiguiente(sesion.getPaginaAnterior());
                    sesion.setPaginaAnterior("");
                }
                break;
            case 2:
                CargaVacaciones();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3:
                //borrar vacaciones (3)
                Vacaciones vacas = new Vacaciones();
                vacas.setId(Integer.parseInt(request.getParameter("idVac")));
                datos.put("vacaciones", vacas);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaVacaciones() {
        Vacaciones vac = (Vacaciones)datos.get("vacaciones");
        vac.setAntiguedad(Integer.parseInt(request.getParameter("antiguedad")));
        vac.setAnio(Integer.parseInt(request.getParameter("anio")));
        vac.setDias(Integer.parseInt(request.getParameter("dias")));
        vac.setDiasacuenta(Integer.parseInt(request.getParameter("diasacuenta")));
        vac.setMontoprima(Float.parseFloat(request.getParameter("prima").replace(",", "")));
        vac.setMontovacaciones(Float.parseFloat(request.getParameter("vacaciones").replace(",", "")));
        String chkgoce = request.getParameter("chkgoce")!=null?request.getParameter("chkgoce"):"";
        if (chkgoce.equals("0")){
            vac.setMontovacaciones(0.0f);
            String sfini = request.getParameter("fechaini");
            String sffin = request.getParameter("fechafin");
            SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
            Date fechaini = null, fechafin = null;
            try {
                fechaini = formato.parse(sfini);
                fechafin = formato.parse(sffin);
            } catch (ParseException ex) {
            }        
            vac.setFechainicial(fechaini);
            vac.setFechafinal(fechafin);
        }

        datos.put("vacaciones", vac);
        datos.put("idquin", request.getParameter("quincena"));
    }
    
}
