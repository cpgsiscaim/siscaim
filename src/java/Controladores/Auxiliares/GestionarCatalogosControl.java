/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Modelos.CatnominaMod;
import Modelo.Entidades.Catalogos.*;
import Generales.Sesion;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;




/**
 *
 * @author roman
 */
public class GestionarCatalogosControl extends Action {
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
         CatnominaMod nomMod = new CatnominaMod();
        sesion = nomMod.GestionarCatalogos(sesion);
        
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
            case 1: case 98: case 99: case 7:  case 13: case 97:  case 96: case 19: case 95: case 94: case 25:
                //obtener los datos de la jsp 
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 3:
                // [2] guardar nueva pago [3] guardar pago editado
                CargaPagoAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 5: case 6:
                //ir a editar pago(4) || baja de pago (5) || activar pago(6)
                PerPagos editar = new PerPagos();
                editar.setIdPerPagos(Integer.parseInt(request.getParameter("idPerPago")));//.setNumempleado(Integer.parseInt(request.getParameter("idEmp")));// editar.setId(Integer.parseInt(request.getParameter("idCli")));
                if (Integer.parseInt(paso) == 4) {
                    datos.put("editarPagos", editar);
                } 
                else if (Integer.parseInt(paso) == 5) {
                    datos.put("bajaPagos", editar);
                }  else {
                    datos.put("activarPagos", editar);
                }
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig);                                            
                break;
            case 8: case 9:
                // [8] guardar nueva puesto [9] guardar puesto editado
                CargaPuestoAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
           case 10: case 11: case 12:
                //ir a editar puesto(10) || baja de puesto (11) || activar puesto(12)
                Puestos editaP = new Puestos();
                editaP.setIdPuestos(Integer.parseInt(request.getParameter("idPuestos")));
                if (Integer.parseInt(paso) == 10) {
                    datos.put("editarPuesto", editaP);
                } 
                else if (Integer.parseInt(paso) == 11) {
                    datos.put("bajaPuesto", editaP);
                }  else {
                    datos.put("activarPuesto", editaP);
                }
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig); 
                break;
           case 14: case 15:
                // [14] guardar nuevo tiponomina [15] guardar puesto editado
                CargaTnominaAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
           case 16: case 17: case 18:
                //ir a editar Tnomina(16) || baja de Tnomina (17) || activar Tnomina(18)
                TipoNomina editaNom = new TipoNomina();
                editaNom.setIdTnomina(Integer.parseInt(request.getParameter("idTipoNomina")));
                if (Integer.parseInt(paso) == 16) {
                    datos.put("editarTnomina", editaNom);
                } 
                else if (Integer.parseInt(paso) == 17) {
                    datos.put("bajaTnomina", editaNom);
                }  else {
                    datos.put("activarTnomina", editaNom);
                }
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig); 
                break;
         case 20: case 21:
                // [20] guardar nuevo peryded [21] guardar pweryded editado
                CargaPeryDedAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
         case 22: case 23: case 24: case 40:
                //ir a editar PeryDed(22) || baja de PeryDed (23) || activar PeryDed(24)
                PeryDed editaPeryDed = new PeryDed();
                editaPeryDed.setIdPeryded(Integer.parseInt(request.getParameter("idPeryDed")));//.setIdTnomina(Integer.parseInt(request.getParameter("idTipoNomina")));
                if (Integer.parseInt(paso) == 22) {
                    datos.put("editarPeryDed", editaPeryDed);
                } 
                else if (Integer.parseInt(paso) == 23) {
                    datos.put("bajaPeryDed", editaPeryDed);
                }  else {
                    datos.put("perded", editaPeryDed);
                }
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig); 
                break;
             case 26: case 27:
                // [26] guardar nuevo tincidncia [27] guardar tincidencia editado
                CargaTincidenciaAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 28: case 29: case 30:             
                //ir a editar PeryDed(22) || baja de PeryDed (23) || activar PeryDed(24)
                TipoIncidencia editaTinc = new TipoIncidencia();
                editaTinc.setIdTipoincidencia(Integer.parseInt(request.getParameter("idTipoIncidencia")));
                if (Integer.parseInt(paso) == 28) {
                    datos.put("editarTincidencia", editaTinc);
                } 
                else if (Integer.parseInt(paso) == 29) {
                    datos.put("bajaTincidencia", editaTinc);
                }  else {
                    datos.put("activarTincidencia", editaTinc);
                }
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig); 
                break;     

        }
        datos.put("paso", paso);
    }

    private void CargaPagoAGuardar(){
        try {            
            
            PerPagos pPago = new PerPagos();                        
            if (datos.get("accion").toString().equals("editar")) {
                pPago = (PerPagos) datos.get("editarPagos");
            }
            
            pPago.setDescripcion(new String(request.getParameter("descPago").getBytes("ISO-8859-1"), "UTF-8"));
            pPago.setDias(new String(request.getParameter("diasPago").getBytes("ISO-8859-1"), "UTF-8"));                        
            pPago.setEstatus(1);
            
            if (datos.get("accion").toString().equals("nuevo")) {
                datos.put("nuevoPagos", pPago);
            } else {
                datos.put("editarPagos", pPago);
            }
            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    private void CargaPuestoAGuardar(){
        try {            
            
            Puestos puesto = new Puestos();                        
            if (datos.get("accion").toString().equals("editar")) {
                puesto = (Puestos) datos.get("editarPuesto");
            }
            
            puesto.setDescripcion(new String(request.getParameter("descPuesto").getBytes("ISO-8859-1"), "UTF-8"));
            String str = new String(request.getParameter("salPuesto").getBytes("ISO-8859-1"), "UTF-8");
            double sal = Double.parseDouble(str);
            puesto.setSalario(sal);                        
            puesto.setEstatus(1);
            
            if (datos.get("accion").toString().equals("nuevo")) {
                datos.put("nuevoPuesto", puesto);
            } else {
                datos.put("editarPuesto", puesto);
            }
            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    private void CargaTnominaAGuardar(){
        try {            
            
            TipoNomina nomina = new TipoNomina();                        
            if (datos.get("accion").toString().equals("editar")) {
                nomina = (TipoNomina) datos.get("editarTnomina");
            }
            
            nomina.setDescripcion(new String(request.getParameter("descTnomina").getBytes("ISO-8859-1"), "UTF-8"));            
            nomina.setEstatus(1);
            
            if (datos.get("accion").toString().equals("nuevo")) {
                datos.put("nuevoTnomina", nomina);
            } else {
                datos.put("editarTnomina", nomina);
            }
            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    private void CargaPeryDedAGuardar(){
        try {            
            
            PeryDed peryded = new PeryDed();                        
            if (datos.get("accion").toString().equals("editar")) {
                peryded = (PeryDed) datos.get("editarPeryDed");
            }
            
            peryded.setDescripcion(new String(request.getParameter("descPeryDed").getBytes("ISO-8859-1"), "UTF-8"));            
            //graoexePeryDed
            int graoexe = Integer.parseInt(request.getParameter("graoexePeryDed"));
            peryded.setGraoExe(graoexe);
            //ordenPeryDed
            peryded.setOrden(new String(request.getParameter("ordenPeryDed").getBytes("ISO-8859-1"), "UTF-8") );
            //perodedPeryDed
            int peroded = Integer.parseInt(request.getParameter("perodedPeryDed"));
            peryded.setPeroDed(peroded);
            
            peryded.setFactor(Float.parseFloat(request.getParameter("factor")));
            peryded.setEstatus(1);
            
            
            if (datos.get("accion").toString().equals("nuevo")) {
                datos.put("nuevoPeryDed", peryded);
            } else {
                datos.put("editarPeryDed", peryded);
            }
            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    private void CargaTincidenciaAGuardar(){
        try {            
            
            TipoIncidencia tinc = new TipoIncidencia();                        
            if (datos.get("accion").toString().equals("editar")) {
                tinc = (TipoIncidencia) datos.get("editarTincidencia");
            }
            
            tinc.setDescripcion(new String(request.getParameter("descTincidencia").getBytes("ISO-8859-1"), "UTF-8"));            
            //graoexePeryDed
            int calc = Integer.parseInt(request.getParameter("calcTincidencia"));
            tinc.setCalcula(calc);
            //peryded.setGraoExe(calc);            
            tinc.setIdPery(1);
            tinc.setEstatus(1);
            
            if (datos.get("accion").toString().equals("nuevo")) {
                datos.put("nuevoTincidencia", tinc);
            } else {
                datos.put("editarTincidencia", tinc);
            }
            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

