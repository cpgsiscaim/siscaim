/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Aguinaldo;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Catalogos.TipoNomina;
import Modelo.Entidades.Nomina;
import Modelo.Entidades.Plaza;
import Modelo.Entidades.Sucursal;
import Modelos.NominaMod;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarNominasControl extends Action{
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
        NominaMod nomMod = new NominaMod();
        sesion = nomMod.GestionarNominas(sesion);
        if (paso.equals("32") || paso.equals("7") || paso.equals("25") || paso.equals("37")
                || paso.equals("41")){
            //imprimir
            datos = sesion.getDatos();
            byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            //response.sendRedirect(application.getRealPath("/Utilerias/imprimeReporte.jsp"));
            ServletOutputStream oustrm;
            try
            {
                oustrm = response.getOutputStream();
                oustrm.write(bytes, 0, bytes.length);
                oustrm.flush();
                oustrm.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            datos.remove("bytes");
        }
        if (paso.equals("33") || paso.equals("8") || paso.equals("26") || paso.equals("13") || paso.equals("14")
                || paso.equals("38") || paso.equals("42") || paso.equals("64")){
            //imprimir xls
            datos = sesion.getDatos();
            File f = (File)datos.get("reportexls");
            //byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/vnd.ms-excel");
            if (paso.equals("64"))
                response.setHeader("Content-Disposition", "attachment;filename=nominabanorte.xls");
            //response.setContentLength(bytes.length);
            InputStream in = new FileInputStream(f);
            ServletOutputStream oustrm;
            int bit = 256;
            try
            {
                oustrm = response.getOutputStream();
                while(bit>=0){
                    bit = in.read();
                    oustrm.write(bit);
                }
                oustrm.flush();
                oustrm.close();
                in.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }            
        }
        /*/bajar dispersión de pagos banorte
        if (paso.equals("64")){
            //bajar txt
            datos = sesion.getDatos();
            File f = (File)datos.get("dispersionpagos");
            String scon = datos.get("consecutivo").toString();
            String emisora = datos.get("emisora").toString();
            //byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=NI"+emisora+scon+".PAG;"); 
            //response.setHeader("Content-Disposition", "attachment;filename=\""+);
            //response.setContentLength(bytes.length);
            InputStream in = new FileInputStream(f);
            ServletOutputStream oustrm;
            int bit = 256;
            try
            {
                oustrm = response.getOutputStream();
                while(bit>=0){
                    bit = in.read();
                    oustrm.write(bit);
                }
                oustrm.flush();
                oustrm.close();
                in.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }            
        }//bajar txt*/

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
                //paso inicial: obtener la vista de los parametros
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case 1: case 6: case 9: case 15: case 16:
            case 46:
            case 50: case 51: case 52: case 53:
            case 60: case 61: case 62: case 63:
            case 90:
            case 91: case 92: case 93: case 94: case 95: case 96: case 97: case 98: case 99:
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 3: case 4: case 5: case 18: case 36: case 39: case 43:
                //editar nomina(2) ||recalcular nomina (3) || cerrar nomina (4)
                //generar formatos de pago (5) || editar nomina aguinaldos (18)
                //formatos de pago aguinaldos (39)
                Nomina nom = new Nomina();
                nom.setId(Integer.parseInt(request.getParameter("idNom")));
                datos.put("nomina", nom);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 7: case 8: case 25: case 26:
                //imprimir listado general de nomina
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/nomina.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("NOMINA", new Integer(request.getParameter("dato1")));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 10: case 17:
                Sucursal suc = new Sucursal();
                suc.setId(Integer.parseInt(request.getParameter("sucursal")));
                datos.put("sucursalsel", suc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 11:
                datos.put("aniohissel", request.getParameter("aniosel"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 12:
                datos.put("aniohissel", request.getParameter("aniosel"));
                Quincena quinhissel = new Quincena();
                quinhissel.setId(Integer.parseInt(request.getParameter("quinsel")));
                datos.put("quinhissel", quinhissel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 13:
                //imprimir reporte de salarios pagados
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/salariospagados.jasper"));
                //parametros
                param = new HashMap();
                param.put("NOMINA", new Integer(request.getParameter("dato1")));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 14:
                //imprimir layout de empleados
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/layoutempleados.jasper"));
                //parametros
                param = new HashMap();
                param.put("NOMINA", new Integer(request.getParameter("dato1")));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 19: case 20: case 21: case 22: case 23: case 24: case 29: case 34: case 35: case 44:
                //editar detalle nomina aguinaldo(19) || ir a movs extras de plaza(20) || pagar plaza (21) || recalcular plaza(22) || baja de plaza(23)
                //quitar pago de plaza (24) || pagar aguinaldos (29) || quitar pagos aguinaldos (34)
                //baja de registro de aguinaldo (35) || registrar goze de vacaciones (44)
                datos.put("varios", request.getParameter("varios"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                if (Integer.parseInt(paso)!=19)
                    sesion.setPaginaAnterior("/Nomina/Nomina/detallenomina.jsp");
                break;
            case 27: case 30:
                datos.put("estatus", request.getParameter("estatuspago"));
                datos.put("bcotiza", request.getParameter("cotiza"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 28:
                //guarda detalle aguinaldo editado
                Aguinaldo agui = (Aguinaldo)datos.get("aguinaldo");
                agui.setDiastrabajadosbrutos(Integer.parseInt(request.getParameter("diastrab")));
                agui.setFaltas(Integer.parseInt(request.getParameter("faltas")));
                agui.setDiasaguinaldo(Float.parseFloat(request.getParameter("diasagui").replace(",", "")));
                agui.setSueldodiario(Float.parseFloat(request.getParameter("sueldodia").replace(",", "")));
                agui.setMontoaguinaldo(Float.parseFloat(request.getParameter("montoaguinaldo").replace(",", "")));
                datos.put("aguinaldo", agui);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 31: case 40:
                //obtener listado para formatos de pago
                HashMap criterios = new HashMap();
                criterios.put("nivel", request.getParameter("nivel"));
                String pago = request.getParameter("pago");
                criterios.put("formapago", pago);
                criterios.put("cuenta", request.getParameter("cuenta"));
                if (pago.equals("1")){
                    criterios.put("cotiza", "0");
                    String cotiza = request.getParameter("cotiza");
                    if (cotiza!=null && cotiza.equals("on"))
                        criterios.put("cotiza", "1");
                }
                datos.put("criterios", criterios);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 32: case 33:
                HashMap crit = (HashMap)datos.get("criterios");
                Nomina nomi = (Nomina)datos.get("nomina");
                int fpago = Integer.parseInt(crit.get("formapago").toString());
                int cuenta = Integer.parseInt(crit.get("cuenta").toString());
                datos.put("varios", request.getParameter("dato1"));
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago")); 
                if (fpago==1) {
                    if (cuenta!=2)
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fpdeposito.jasper"));
                    else
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fpdepbanorte.jasper"));
                } else if (fpago==2)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fpefectivo.jasper"));
                else if (fpago==3)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fptelecomm.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago"));
                param.put("IDSPLAZAS", request.getParameter("dato1"));
                param.put("NOMINA", new Integer(nomi.getId()));
                param.put("QUINCENA", new Integer(nomi.getQuincena().getId()));
                if (fpago==1){
                    param.put("COTIZA", crit.get("cotiza"));
                    param.put("BANCO", new Integer(crit.get("cuenta").toString()));
                }else
                    param.put("COTIZA", crit.get("cuenta"));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 37: case 38:
                //imprimir nomina de aguinaldos listado general
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina"));
                if (Integer.parseInt(paso)==37)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/nominaagui.jasper"));
                else
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/nominaaguixls.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("NOMINA", new Integer(request.getParameter("dato1")));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 41: case 42:
                HashMap crita = (HashMap)datos.get("criterios");
                Nomina nomia = (Nomina)datos.get("nominaagui");
                int fpagoa = Integer.parseInt(crita.get("formapago").toString());
                int cuentaa = Integer.parseInt(crita.get("cuenta").toString());
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago"));
                if (fpagoa==1) {
                    if (cuentaa!=2)
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fpdepositoagui.jasper"));
                    else
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fpdepbanorteagui.jasper"));
                } else if (fpagoa==2)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fpefectivoagui.jasper"));
                else if (fpagoa==3)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/fptelecommagui.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago"));
                param.put("IDSPLAZAS", request.getParameter("dato1"));
                param.put("NOMINA", new Integer(nomia.getId()));
                if (fpagoa==1){
                    param.put("COTIZA", crita.get("cotiza"));
                    param.put("BANCO", new Integer(crita.get("cuenta").toString()));
                }else
                    param.put("COTIZA", crita.get("cuenta"));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 45:
                String fechaini = request.getParameter("fechaini");
                String fechafin = request.getParameter("fechafin");
                SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
                Date dfechaini = null, dfechafin = null;
                try {
                    dfechaini = formatoDelTexto.parse(fechaini);
                    dfechafin = formatoDelTexto.parse(fechafin);
                } catch (ParseException ex) {
                }
                datos.put("vfechaini", dfechaini);
                datos.put("vfechafin", dfechafin);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 64:
                Nomina no = (Nomina)datos.get("nomina");
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago/dispersionbanorte.jasper"));
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina/FormatosPago"));
                datos.put("varios", request.getParameter("dato1"));
                param = new HashMap();
                param.put("PLAZAS", request.getParameter("dato1"));
                param.put("NOMINA", new Integer(no.getId()));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarNomina() {
        Nomina nom = new Nomina();
        if (datos.get("accion").toString().equals("editar"))
            nom = (Nomina)datos.get("nomina");

        datos.put("nomina", nom);
    }

}
