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
import Modelos.ClienteMod;
import Modelos.UsuariosMod;
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
public class GestionarClientesControl extends Action {
    
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
        ClienteMod cliMod = new ClienteMod();
        sesion = cliMod.GestionarClientes(sesion);
        if (paso.equals("12")){
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
                //obtener centros de trabajo del contrato seleccionado - consumo de cliente
                Contrato con = new Contrato();
                con.setId(Integer.parseInt(request.getParameter("contrato")));
                datos.put("contrato", con);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case -2:
                //obtener los movimientos del ct seleccionado
                CentroDeTrabajo ct = new CentroDeTrabajo();
                ct.setId(Integer.parseInt(request.getParameter("ct")));
                datos.put("ct", ct);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 1:
                //cargar clientes de sucursal
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 7: case 9: case 11: case 15: case 17:
            case 50: case 51: case 52: case 53: 
            case 60: case 61: case 62: case 63:
            case 70: case 71: case 72: case 73:
            case 93:
            case 94: case 95: case 96: case 97: case 98: case 99:
                // ir a nuevo cliente(2) || ir a inactivos(7) || ir a filtrar lista(9) || quitar filtros (11)
                //ir a acumulado mensual (15)
                //ir al principio de la lista (50) || mostrar anteriores (51) || mostrar siguiente grupo(52) || ir al final de la lista(53)
                //ir al principio de la lista consumo (60) || mostrar anteriores consumo(61) || mostrar siguiente grupo consumo(62) || ir al final de la lista consumo(63)
                //cancelar resumen consumo (94) || cancelar consumo (95)
                //cancelar filtrar(96) || cancelar inactivos(97) || cancelar nuevo cliente (98) || salir de gestionar clientes(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5:
                //guardar nuevo cliente(3) || guardar cliente editado (5)
                CargaNuevoCliente();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8: case 13: case 14:
                //ir a editar cliente(4) || baja de cliente (6) || activar cliente(8) || ir a contratos (13)
                //ir a consumo del cliente (14)
                Cliente editar = new Cliente();
                editar.setId(Integer.parseInt(request.getParameter("idCli")));
                if (Integer.parseInt(paso)==4)
                    datos.put("editarCliente", editar);
                else if (Integer.parseInt(paso)==6)
                    datos.put("bajaCliente", editar);
                else if (Integer.parseInt(paso)==8)
                    datos.put("activarCliente", editar);
                else if (Integer.parseInt(paso)==13)
                    datos.put("clienteSel", editar);
                else
                    datos.put("cliente", editar);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 10:
                //aplicar filtros
                CargaFiltros();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 12:
                //imprimir lista
                Sucursal suc = (Sucursal) datos.get("sucursalSel");
                datos.put("reporte", application.getRealPath("/WEB-INF/Reportes/Empresa/Clientes/clientes.jasper"));
                //parametros
                HashMap param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUCURSAL", new Integer(suc.getId()));
                datos.put("parametros", param);
                //paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente("/Empresa/GestionarClientes/gestionarclientes.jsp");                
                break;
            case 16:
                //filtrar resumen del año
                datos.put("aniores", request.getParameter("aniores"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 18:
                //guarda contacto
                ContactoCliente contacto = new ContactoCliente();
                contacto.setContacto(new Persona());
                String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
                if (accion.equals("editar")){
                    contacto = (ContactoCliente)datos.get("contacto");
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
            case 19: case 20:
                ContactoCliente concli = new ContactoCliente();
                concli.setId(Integer.parseInt(request.getParameter("lstContactos")));
                datos.put("contacto", concli);
                datos.put("accionContacto", "editar");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaNuevoCliente() {
        Cliente nuevo = new Cliente();
        nuevo.setDatosFiscales(new DatosFiscales());
        nuevo.getDatosFiscales().setPersona(new Persona());
        nuevo.getDatosFiscales().setDireccion(new Direccion());
        nuevo.getDatosFiscales().getDireccion().setPoblacion(new Municipio());
        nuevo.getDatosFiscales().getDireccion().getPoblacion().setEstado(new Estado());
        nuevo.setAgente(new Agente());
        if (datos.get("accion").toString().equals("editar")){
            nuevo = (Cliente) datos.get("editarCliente");
            if (nuevo.getDatosFiscales().getPersona()==null)
                nuevo.getDatosFiscales().setPersona(new Persona());
        }
        String tipoCli = request.getParameter("rdTipoCli");
        if (tipoCli.equals("moral")){
            nuevo.setTipo(0);
            try {
                nuevo.getDatosFiscales().setRazonsocial(new String(request.getParameter("razonCli").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().setRfc(new String(request.getParameter("rfcCli").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().setTipo("0");
                String nombre = new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8");
                String paterno = new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8");
                String materno = new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8");
                if (nombre.equals("") && paterno.equals("") && materno.equals("")){
                    nuevo.getDatosFiscales().setPersona(null);
                } else {
                    nuevo.getDatosFiscales().getPersona().setNombre(nombre);
                    nuevo.getDatosFiscales().getPersona().setPaterno(paterno);
                    nuevo.getDatosFiscales().getPersona().setMaterno(materno);
                }
                nuevo.setPrefijo(new String(request.getParameter("prefijo").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.setNombrecompleto(new String(request.getParameter("completo").getBytes("ISO-8859-1"), "UTF-8"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else {
            nuevo.setTipo(1);
            try {
                nuevo.getDatosFiscales().setRazonsocial("");
                nuevo.getDatosFiscales().setRfc(new String(request.getParameter("rfcCliFis").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().setTipo("0");
                nuevo.getDatosFiscales().getPersona().setNombre(new String(request.getParameter("nombreReprFis").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().getPersona().setPaterno(new String(request.getParameter("paternoReprFis").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().getPersona().setMaterno(new String(request.getParameter("maternoReprFis").getBytes("ISO-8859-1"), "UTF-8"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        if (nuevo.getDatosFiscales().getPersona()!=null)
            nuevo.getDatosFiscales().getPersona().setSucursal(sucSel);
        nuevo.setSucursal(sucSel);
        
        try {
            nuevo.getDatosFiscales().getDireccion().setCalle(new String(request.getParameter("calleCli").getBytes("ISO-8859-1"), "UTF-8"));
            nuevo.getDatosFiscales().getDireccion().setColonia(new String(request.getParameter("coloniaCli").getBytes("ISO-8859-1"), "UTF-8"));
            String cp = request.getParameter("cpCli");
            if (cp.equals(""))
                nuevo.getDatosFiscales().getDireccion().setCp(0);
            else
                nuevo.getDatosFiscales().getDireccion().setCp(Integer.parseInt(cp));
            nuevo.getDatosFiscales().getDireccion().getPoblacion().getEstado().setIdestado(Integer.parseInt(request.getParameter("estadoCli")));
            nuevo.getDatosFiscales().getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacionCli")));            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        nuevo.getDatosFiscales().getDireccion().setTipo('0');
        
        nuevo.getAgente().setId(Integer.parseInt(request.getParameter("agente")));
        /*nuevo.setRuta(new Ruta());
        nuevo.getRuta().setId(Integer.parseInt(request.getParameter("ruta")));*/
        nuevo.setEstatus(1);
        nuevo.setListaPrecios(Integer.parseInt(request.getParameter("listap")));
        String fecha = request.getParameter("fechaAlta");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaAlta = null;
        try {
            fechaAlta = formatoDelTexto.parse(fecha);
        } catch (ParseException ex) {
        }        
        nuevo.setFechaAlta(fechaAlta);
        nuevo.setDescuento1(Float.parseFloat(request.getParameter("descto1")));
        nuevo.setDescuento2(Float.parseFloat(request.getParameter("descto2")));
        nuevo.setDescuento3(Float.parseFloat(request.getParameter("descto3")));
        nuevo.setPlazo(Integer.parseInt(request.getParameter("plazo")));
        String sLim = request.getParameter("limite");
        nuevo.setLimite(0);
        if (!sLim.equals(""))
            nuevo.setLimite(Float.parseFloat(sLim));
        nuevo.setCglobal(0);
        String cglobal = request.getParameter("global")!=null?request.getParameter("global"):"";
        if (cglobal.equals("on"))
            nuevo.setCglobal(1);
        
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
        datos.put("datoscontactos", contactos);*/
        
        if (datos.get("accion").toString().equals("nuevo"))
            datos.put("nuevoCliente", nuevo);
        else
            datos.put("editarCliente", nuevo);
    }

    private void CargaFiltros() {
        HashMap filtros = new HashMap();
        String filtro1 = request.getParameter("filtro1")!=null?request.getParameter("filtro1"):"";
        String filtro2 = request.getParameter("filtro2")!=null?request.getParameter("filtro2"):"";
        String filtro3 = request.getParameter("filtro3")!=null?request.getParameter("filtro3"):"";
        filtros.put("filtro1", filtro1);
        filtros.put("filtro2", filtro2);
        filtros.put("filtro3", filtro3);
        try {
            if (!filtro1.equals("")){
                    filtros.put("razonSocial", new String(request.getParameter("razonSoc").getBytes("ISO-8859-1"), "UTF-8"));
            }
            if (!filtro2.equals("")){
                filtros.put("nombreCli", new String(request.getParameter("nombreCli").getBytes("ISO-8859-1"), "UTF-8"));
                filtros.put("paternoCli", new String(request.getParameter("paternoCli").getBytes("ISO-8859-1"), "UTF-8"));
                filtros.put("maternoCli", new String(request.getParameter("maternoCli").getBytes("ISO-8859-1"), "UTF-8"));
            }
            if (!filtro3.equals("")){
                Ruta ruta = new Ruta();
                ruta.setId(Integer.parseInt(request.getParameter("rutaCli")));
                filtros.put("rutaCli", ruta);
            }
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        datos.put("filtros", filtros);
    }

    private void CargaDatosReporte() {
        HashMap datosReporte = new HashMap();
        HashMap parametros = new HashMap();
        String reporte = application.getRealPath("/WEB-INF/Reportes/Empresa/Clientes/prueba.jasper");
        String logo = application.getRealPath("/Imagenes/Empresa/Logotipo/marba02A.png");
        parametros.put("IMAGEN", logo);
        parametros.put("ESTATUS", "1");
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        parametros.put("SUCURSAL", suc.getId());
        parametros.put("CONDICIONES", datos.get("condiciones")!=null?datos.get("condiciones").toString():"");
        datosReporte.put("reporte", reporte);
        datosReporte.put("parametros", parametros);
        datosReporte.put("origen", request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"");
        datos.put("datosReporte", datosReporte);
    }
 
    private void MuestraReporte(byte[] bytes) 
    {
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
    }    
}
