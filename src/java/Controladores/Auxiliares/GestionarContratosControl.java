/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Cliente;
import Modelo.Entidades.ContactoContrato;
import Modelo.Entidades.Contrato;
import Modelo.Entidades.Persona;
import Modelo.Entidades.Sucursal;
import Modelos.ContratoMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
public class GestionarContratosControl extends Action{
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
        ContratoMod conMod = new ContratoMod();
        sesion = conMod.GestionarContratos(sesion);
        if (paso.equals("24")){
            //imprimir
            datos = sesion.getDatos();
            byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
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
            case -1:
                //consultar contratos - obtener clientes de sucursal seleccionada
                Sucursal suc = new Sucursal();
                suc.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", suc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 1: case 6: case 15: case 16: case 20: case 92: case 93: case 94: case 95: case 96: case 97: case 98: case 99:
                //ir a nuevo contrato (1) || ir a inactivos(6) || ver historico (15) || ver vigentes(16)
                //salir de reporte de fianzas vencidas(93) || cancelar importar datos (95) || cancelar generar salidas progs (96)
                //cancelar inactivos (97) || cancelar nuevo | editar contrato(98) || salir de gestionar contratos(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4: case 11:
                //guardar nuevo contrato(2) || guardar contrato editado (4) || baja de contrato (5)
                CargarContrato();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7: case 8: case 9: case 10: case 13: case 17://case 11: 
                //ir a editar contrato(3) || baja de contrato(5) || activar contrato (7) || ir a centros de trabajo (8)
                //ir a prods del contrato (9) || generar salidas programadas(10)
                //generar salidas programadas (cambios) (11) || ir a importar datos (13)
                Contrato con = new Contrato();
                con.setId(Integer.parseInt(request.getParameter("idCon")));
                datos.put("editarContrato", con);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 12:
                //generar las salidas programadas de cambios de los cts seleccionados
                String fecha = request.getParameter("fecha");
                String cts = request.getParameter("ctssel");
                datos.put("fechasp", fecha);
                datos.put("ctssel", cts);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 14:
                //importar datos seleccionados
                datos.put("contratoimp", request.getParameter("contrato"));
                datos.put("datosimp", request.getParameter("datos"));
                datos.put("chkplazas", request.getParameter("chkplazas")!=null?request.getParameter("chkplazas"):"");
                datos.put("chkprodcts", request.getParameter("chkprodcts")!=null?request.getParameter("chkprodcts"):"");
                datos.put("chkeliminar", request.getParameter("chkeliminar")!=null?request.getParameter("chkeliminar"):"");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 18://borrar documento de contrato
                String rutaDoc = application.getRealPath("/Imagenes/Contratos");
                datos.put("rutadoc", rutaDoc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 19://borrar documento de fianza
                String rutaFi = application.getRealPath("/Imagenes/Contratos/Fianzas");
                datos.put("rutadoc", rutaFi);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 21:
                //guarda contacto
                ContactoContrato contacto = new ContactoContrato();
                contacto.setContacto(new Persona());
                String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
                if (accion.equals("editar")){
                    contacto = (ContactoContrato)datos.get("contacto");
                }
                try {
                    contacto.getContacto().setNombre(new String(request.getParameter("nombreCon").getBytes("ISO-8859-1"), "UTF-8"));
                    contacto.getContacto().setPaterno(new String(request.getParameter("paternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    contacto.getContacto().setMaterno(new String(request.getParameter("maternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    contacto.getContacto().setCargo(new String(request.getParameter("cargoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    contacto.getContacto().setSexo(new String(request.getParameter("sexoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    contacto.getContacto().setTitulo(new String(request.getParameter("tituloCon").getBytes("ISO-8859-1"), "UTF-8"));
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                datos.put("contacto", contacto);
                datos.put("tipos", request.getParameterValues("lstipos"));
                datos.put("medios", request.getParameterValues("lstels"));
                datos.put("extensiones", request.getParameterValues("lsexts"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 22: case 23:
                ContactoContrato concli = new ContactoContrato();
                concli.setId(Integer.parseInt(request.getParameter("lstContactos")));
                datos.put("contacto", concli);
                datos.put("accionContacto", "editar");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 24:
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Empresa/fianzasvencidas.jasper"));
                //parametros
                HashMap param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                String sfi = request.getParameter("dato1");
                String sff = request.getParameter("dato2");
                SimpleDateFormat formatfecha = new SimpleDateFormat("dd-MM-yyyy");
                SimpleDateFormat formatparam = new SimpleDateFormat("yyyy-MM-dd");
                Date fini = null, ffin = null;
                try {
                    fini = formatfecha.parse(sfi);
                    ffin = formatfecha.parse(sff);
                    sfi = formatparam.format(fini);
                    sff = formatparam.format(ffin);
                } catch (ParseException ex) {
                }        
                param.put("FECHAINI", sfi);
                param.put("FECHAFIN", sff);
                datos.put("parametros", param);
                break;
            case 25:
                Sucursal sucsel = new Sucursal();
                sucsel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucsel);
                Cliente clisel = new Cliente();
                clisel.setId(Integer.parseInt(request.getParameter("cliente")));
                datos.put("clienteSel", clisel);
                datos.put("especialidad", request.getParameter("especialidad"));
                datos.put("totper", request.getParameter("totalpersonal"));
                datos.put("fechaini", request.getParameter("fechaIni"));
                datos.put("fechafin", request.getParameter("fechaFin"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarContrato() {
        Contrato con = new Contrato();
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        con.setSucursal(sucSel);
        if (datos.get("accion").toString().equals("editar")){
            con = (Contrato)datos.get("editarContrato");
            datos.put("conact", con.getContrato());
            //datos.put("contratoOrig", con);
        }
        
        con.setContrato(request.getParameter("contrato"));
        
        String fechaIni = request.getParameter("fechaIni");
        String fechaFin = request.getParameter("fechaFin");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaDI = null, fechaDF = null;
        try {
            fechaDI = formatoDelTexto.parse(fechaIni);
            fechaDF = formatoDelTexto.parse(fechaFin);
        } catch (ParseException ex) {
        }        
        con.setFechaIni(fechaDI);
        con.setFechaFin(fechaDF);
        try {
            con.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
            con.setObservaciones(new String(request.getParameter("observacion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarContratosControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        con.setNumfianza(request.getParameter("numfianza"));
        con.setImporteFianza(Float.parseFloat(request.getParameter("importe")));
        
        String fechaFia = request.getParameter("fecha");
        formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaFiaD = null;
        try {
            fechaFiaD = formatoDelTexto.parse(fechaFia);
        } catch (ParseException ex) {
        }
        con.setFechaFianza(fechaFiaD);
        con.setEstatusFianza(Integer.parseInt(request.getParameter("radioEstatusF")));
        try {
            con.setObservacionFianza(new String(request.getParameter("obsFianza").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarContratosControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        con.setFacturarCT(0);
        String factxct = request.getParameter("facturarct")!=null?request.getParameter("facturarct"):"";
        if (factxct.equals("on"))
            con.setFacturarCT(1);
        //String totper = 
        con.setTotalpersonal(Integer.parseInt(request.getParameter("totalpersonal")!=""?request.getParameter("totalpersonal"):"0"));
        
        
        //configuracion de la entrega
        int opcconfig = Integer.parseInt(request.getParameter("opcconfig"));
        con.setTipoentrega(opcconfig);
        switch(opcconfig){
            case 0:
                //entregas cada N dias
                con.setDiasentrega(Integer.parseInt(request.getParameter("numdias")));
                break;
            case 1:
                //entregas en las fechas especificadas
                String fechasent = request.getParameter("lstfechas");
                datos.put("fechasent", fechasent);
                con.setDiasentrega(0);
                break;
        }
        
        /*String actuales = "", nombres = "", paternos = "", maternos = "", sexos = "", titulos = "", cargos = "";
        String tels = "", cels = "", mails = "", nuevos = "", edits = "", bajas = "";
        try {
            //pestaña contactos
            actuales = new String(request.getParameter("conactuales").getBytes("ISO-8859-1"), "UTF-8");
            nombres = new String(request.getParameter("connombres").getBytes("ISO-8859-1"), "UTF-8");
            paternos = new String(request.getParameter("conpaternos").getBytes("ISO-8859-1"), "UTF-8");
            maternos = new String(request.getParameter("conmaternos").getBytes("ISO-8859-1"), "UTF-8");
            sexos = new String(request.getParameter("consexos").getBytes("ISO-8859-1"), "UTF-8");
            titulos = new String(request.getParameter("contitulos").getBytes("ISO-8859-1"), "UTF-8");
            cargos = new String(request.getParameter("concargos").getBytes("ISO-8859-1"), "UTF-8");
            tels = new String(request.getParameter("contels").getBytes("ISO-8859-1"), "UTF-8");
            cels = new String(request.getParameter("concels").getBytes("ISO-8859-1"), "UTF-8");
            mails = new String(request.getParameter("conmails").getBytes("ISO-8859-1"), "UTF-8");
            nuevos = new String(request.getParameter("connuevos").getBytes("ISO-8859-1"), "UTF-8");
            edits = new String(request.getParameter("conedits").getBytes("ISO-8859-1"), "UTF-8");
            bajas = new String(request.getParameter("conbajas").getBytes("ISO-8859-1"), "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarContratosControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        HashMap contactos = new HashMap();
        contactos.put("actuales", actuales);
        contactos.put("nombres", nombres);
        contactos.put("paternos", paternos);
        contactos.put("maternos", maternos);
        contactos.put("sexos", sexos);
        contactos.put("titulos", titulos);
        contactos.put("cargos", cargos);
        contactos.put("tels", tels);
        contactos.put("cels", cels);
        contactos.put("mails", mails);
        contactos.put("nuevos", nuevos);
        contactos.put("edits", edits);
        contactos.put("bajas", bajas);
        datos.put("datoscontactos", contactos);
        */
        //carga especialidad
        String chkjardin = request.getParameter("chkjardin")!=null?request.getParameter("chkjardin"):"";
        String chklimpia = request.getParameter("chklimpia")!=null?request.getParameter("chklimpia"):"";
        String chkfumiga = request.getParameter("chkfumiga")!=null?request.getParameter("chkfumiga"):"";
        
        con.setEspecialidad(0);
        if (chkjardin.equals("on") && chklimpia.equals("") && chkfumiga.equals(""))
            con.setEspecialidad(1);
        else if (chkjardin.equals("") && chklimpia.equals("on") && chkfumiga.equals(""))
            con.setEspecialidad(2);
        else if (chkjardin.equals("") && chklimpia.equals("") && chkfumiga.equals("on"))
            con.setEspecialidad(3);
        else if (chkjardin.equals("on") && chklimpia.equals("on") && chkfumiga.equals(""))
            con.setEspecialidad(4);
        else if (chkjardin.equals("on") && chklimpia.equals("") && chkfumiga.equals("on"))
            con.setEspecialidad(5);
        else if (chkjardin.equals("") && chklimpia.equals("on") && chkfumiga.equals("on"))
            con.setEspecialidad(6);
        else if (chkjardin.equals("on") && chklimpia.equals("on") && chkfumiga.equals("on"))
            con.setEspecialidad(7);
        
        datos.put("contrato", con);
    }
    
}
