/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.Municipio;
import Modelos.CentrosMod;
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
public class GestionarCentrosTrabControl extends Action{
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
        CentrosMod ctMod = new CentrosMod();
        sesion = ctMod.GestionarCentros(sesion);
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
            case 1: case 6: case 10: case 96: case 97: case 98: case 99:
                // ir a nuevo centro (1) || ir a inactivos (6) || salir de inactivos (97) || 
                //cancelar nuevo|editar centro(98) || salir de gestionar clientes(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 4:
                //guardar centro (2) || guardar editado (4)
                CargaCentro();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5: case 7: case 8: case 9:
                //ir a editar centro (3) || baja de centro (5) || activar centro (7) || productos de ct(8)
                //plazas del ct(9)
                CentroDeTrabajo ct = new CentroDeTrabajo();
                ct.setId(Integer.parseInt(request.getParameter("idCT")));
                datos.put("centro", ct);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 11:
                //guarda contacto
                ContactoCT contacto = new ContactoCT();
                contacto.setContacto(new Persona());
                String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
                if (accion.equals("editar")){
                    contacto = (ContactoCT)datos.get("contacto");
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
            case 12: case 13:
                ContactoCT concli = new ContactoCT();
                concli.setId(Integer.parseInt(request.getParameter("lstContactos")));
                datos.put("contacto", concli);
                datos.put("accionContacto", "editar");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaCentro() {
        CentroDeTrabajo ct = new CentroDeTrabajo();
        ct.setDatosfiscales(new DatosFiscales());
        ct.getDatosfiscales().setDireccion(new Direccion());
        ct.getDatosfiscales().getDireccion().setPoblacion(new Municipio());
        ct.getDatosfiscales().getDireccion().getPoblacion().setEstado(new Estado());
        ct.setRuta(new Ruta());
        ct.setSucalterna(new Sucursal());
        ct.setRutaalterna(new Ruta());
        ct.setDireccion(new Direccion());
        ct.getDireccion().setPoblacion(new Municipio());
        ct.getDireccion().getPoblacion().setEstado(new Estado());
        if (datos.get("accion").toString().equals("editar")){
            ct = (CentroDeTrabajo)datos.get("centro");
            if (ct.getRuta()==null)
                ct.setRuta(new Ruta());
            if (ct.getSucalterna()==null)
                ct.setSucalterna(new Sucursal());
            if (ct.getRutaalterna()==null)
                ct.setRutaalterna(new Ruta());
            if (ct.getDireccion()==null){
                ct.setDireccion(new Direccion());
                ct.getDireccion().setPoblacion(new Municipio());
                ct.getDireccion().getPoblacion().setEstado(new Estado());
            }
        }
        try {
            ct.setNombre(new String(request.getParameter("nombre").getBytes("ISO-8859-1"), "UTF-8"));
            if (!request.getParameter("callect").equals("")){
                ct.getDireccion().setCalle(new String(request.getParameter("callect").getBytes("ISO-8859-1"), "UTF-8"));
                ct.getDireccion().setNumero(new String(request.getParameter("numero").getBytes("ISO-8859-1"), "UTF-8"));
                ct.getDireccion().setColonia(new String(request.getParameter("coloniact").getBytes("ISO-8859-1"), "UTF-8"));
            } else {
                ct.setDireccion(null);
            }
            ct.setObservaciones(new String(request.getParameter("observacion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarCentrosTrabControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (ct.getDireccion()!=null)
            ct.getDireccion().setCp(Integer.parseInt(request.getParameter("cpct").equals("")?"0":request.getParameter("cpct")));
        if (!request.getParameter("poblacionct").equals(""))
            ct.getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacionct")));
        if (!request.getParameter("estadoct").equals(""))
            ct.getDireccion().getPoblacion().getEstado().setIdestado(Integer.parseInt(request.getParameter("estadoct")));
        ct.setPersonal(Float.parseFloat(request.getParameter("personal")));
        ct.setTopeSueldos(Float.parseFloat(request.getParameter("topes")));
        ct.setTopeInsumos(Float.parseFloat(request.getParameter("topei")));
        ct.setSurtidoexterno(0);
        String surext = request.getParameter("surtidoexterno")!=null?request.getParameter("surtidoexterno"):"";
        if (surext.equals("on")){
            ct.setSurtidoexterno(1);
            ct.getSucalterna().setId(Integer.parseInt(request.getParameter("sucursalext")));
            ct.getRutaalterna().setId(Integer.parseInt(request.getParameter("rutaext")));
            ct.setRuta(null);
        } else {
            ct.getRuta().setId(Integer.parseInt(request.getParameter("ruta")));
            ct.setSucalterna(null);
            ct.setRutaalterna(null);
        }
        Contrato conSel = (Contrato)datos.get("editarContrato");
        if (conSel.getFacturarCT()==1){
            try {
                ct.getDatosfiscales().setRfc(new String(request.getParameter("rfc").getBytes("ISO-8859-1"), "UTF-8"));
                ct.getDatosfiscales().setRazonsocial(new String(request.getParameter("razonsoc").getBytes("ISO-8859-1"), "UTF-8"));
                ct.getDatosfiscales().getDireccion().setCalle(new String(request.getParameter("calle").getBytes("ISO-8859-1"), "UTF-8"));
                ct.getDatosfiscales().getDireccion().setColonia(new String(request.getParameter("colonia").getBytes("ISO-8859-1"), "UTF-8"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(GestionarCentrosTrabControl.class.getName()).log(Level.SEVERE, null, ex);
            }
            ct.getDatosfiscales().getDireccion().setCp(Integer.parseInt(request.getParameter("cp").equals("")?"0":request.getParameter("cp")));
            ct.getDatosfiscales().getDireccion().getPoblacion().getEstado().setIdestado(Integer.parseInt(request.getParameter("estado")));
            ct.getDatosfiscales().getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacion")));            
        }
        int confent = Integer.parseInt(request.getParameter("configentrega"));
        ct.setConfigentrega(confent);
        ct.setTipoentrega(0);
        if (confent==1){
            int tipoent = Integer.parseInt(request.getParameter("tipoentrega"));
            ct.setTipoentrega(tipoent);
            if (tipoent == 0){
                ct.setDiasEntrega(Integer.parseInt(request.getParameter("numdias")));
            } else {
                String fechas = request.getParameter("listafechas");
                datos.put("fechasentct", fechas);
            }
        }
        
        /*String actuales = "", nombres = "", paternos = "", maternos = "", sexos = "", titulos = "", cargos = "";
        String tels = "", cels = "", mails = "", nuevos = "", edits = "", bajas = "";
        try {
            //contactos
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
        datos.put("datoscontactos", contactos);*/
        
        datos.put("centro", ct);
    }
    
}
