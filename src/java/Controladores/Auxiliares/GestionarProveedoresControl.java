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
import Modelos.ProveedorMod;
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
public class GestionarProveedoresControl extends Action{
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
        ProveedorMod provMod = new ProveedorMod();
        sesion = provMod.GestionarProveedores(sesion);

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
            case 1: case 17:
                //cargar proveedores de sucursal
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                if (Integer.parseInt(paso)==1)
                    datos.put("sucursalSel", sucSel);
                else
                    datos.put("sucursalNueva", sucSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 7: case 9: case 11: case 12: case 94: case 95: case 96: case 97: case 98: case 99:
                // ir a nuevo proveedor(2) || ir a inactivos(7) || ir a filtrar lista(9) || quitar filtros (11)
                //cancelar filtrar(96) || cancelar inactivos(97) || cancelar nuevo proveedor (98) || salir de gestionar proveedores(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5:
                //guardar nuevo proveedor(3) || guardar proveedor editado (5)
                CargarProveedor();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8: case 16://case 13:
                //ir a editar proveedor(4) || baja de proveedor (6) || activar proveedor(8) || ir a contratos (13)
                Proveedor editar = new Proveedor();
                editar.setId(Integer.parseInt(request.getParameter("idPro")));
                datos.put("proveedor", editar);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 10:
                //aplicar filtros
                CargaFiltros();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 13:
                //guarda contacto
                ContactoProveedor contacto = new ContactoProveedor();
                contacto.setContacto(new Persona());
                String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
                if (accion.equals("editar")){
                    contacto = (ContactoProveedor)datos.get("contacto");
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
            case 14: case 15:
                ContactoProveedor concli = new ContactoProveedor();
                concli.setId(Integer.parseInt(request.getParameter("lstContactos")));
                datos.put("contacto", concli);
                datos.put("accionContacto", "editar");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }
    
    private void CargarProveedor() {
        Proveedor nuevo = new Proveedor();
        if (datos.get("accion").toString().equals("editar"))
            nuevo = (Proveedor) datos.get("proveedor");
        String tipoPro = request.getParameter("rdTipoPro");
        nuevo.setDatosfiscales(new DatosFiscales());
        nuevo.getDatosfiscales().setPersona(new Persona());
        if (tipoPro.equals("moral")){
            nuevo.setTipo("0");
            try {
                nuevo.getDatosfiscales().setRazonsocial(new String(request.getParameter("razonProv").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().setRfc(new String(request.getParameter("rfcPro").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().setTipo("0");
                nuevo.getDatosfiscales().getPersona().setNombre(new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().getPersona().setPaterno(new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().getPersona().setMaterno(new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(GestionarProveedoresControl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else {
            nuevo.setTipo("1");
            try {
                nuevo.getDatosfiscales().setRazonsocial("");
                nuevo.getDatosfiscales().setRfc(new String(request.getParameter("rfcProFis").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().setTipo("0");
                nuevo.getDatosfiscales().getPersona().setNombre(new String(request.getParameter("nombreReprFis").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().getPersona().setPaterno(new String(request.getParameter("paternoReprFis").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosfiscales().getPersona().setMaterno(new String(request.getParameter("maternoReprFis").getBytes("ISO-8859-1"), "UTF-8"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(GestionarProveedoresControl.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        nuevo.getDatosfiscales().getPersona().setSucursal(sucSel);
        nuevo.setSucursal(sucSel);
        
        nuevo.getDatosfiscales().setDireccion(new Direccion());
        try {
            nuevo.getDatosfiscales().getDireccion().setCalle(new String(request.getParameter("callePro").getBytes("ISO-8859-1"), "UTF-8"));
            nuevo.getDatosfiscales().getDireccion().setColonia(new String(request.getParameter("coloniaPro").getBytes("ISO-8859-1"), "UTF-8"));
            String cp = request.getParameter("cpPro");
            if (cp.equals(""))
                nuevo.getDatosfiscales().getDireccion().setCp(0);
            else
                nuevo.getDatosfiscales().getDireccion().setCp(Integer.parseInt(cp));
            nuevo.getDatosfiscales().getDireccion().setPoblacion(new Municipio());
            nuevo.getDatosfiscales().getDireccion().getPoblacion().setEstado(new Estado());
            nuevo.getDatosfiscales().getDireccion().getPoblacion().getEstado().setIdestado(Integer.parseInt(request.getParameter("estadoPro")));
            nuevo.getDatosfiscales().getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacionPro")));            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarProveedoresControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        nuevo.getDatosfiscales().getDireccion().setTipo('0');
        
        //nuevo.setEstatus(1);
        nuevo.setBanco(request.getParameter("banco"));
        nuevo.setCuentaBanco(request.getParameter("cuentaDep"));
        nuevo.setSucursalBanco(request.getParameter("sucbanco"));
        nuevo.setDescuento1(!request.getParameter("descto1").equals("")?Float.parseFloat(request.getParameter("descto1")):0);
        nuevo.setDescuento2(!request.getParameter("descto2").equals("")?Float.parseFloat(request.getParameter("descto2")):0);
        nuevo.setDescuento3(!request.getParameter("descto3").equals("")?Float.parseFloat(request.getParameter("descto3")):0);
        nuevo.setPlazo(!request.getParameter("plazo").equals("")?Integer.parseInt(request.getParameter("plazo")):0);
        nuevo.setIva(!request.getParameter("iva").equals("")?Integer.parseInt(request.getParameter("iva")):0);
        nuevo.setListaPrecio(!request.getParameter("lista").equals("")?Integer.parseInt(request.getParameter("lista")):0);
        String fecha = request.getParameter("fechaAlta");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaAlta = null;
        try {
            fechaAlta = formatoDelTexto.parse(fecha);
        } catch (ParseException ex) {
        }        
        nuevo.setFechaAlta(fechaAlta);
        nuevo.setObservaciones(request.getParameter("observacion"));
        
        nuevo.setNacional(0);
        String nac = request.getParameter("nacional")!=null?request.getParameter("nacional"):"";
        if (nac.equals("on"))
            nuevo.setNacional(1);
        
        datos.put("proveedor", nuevo);
    }
    
    private void CargaFiltros() {
        HashMap filtros = new HashMap();
        String filtro1 = request.getParameter("filtro1")!=null?request.getParameter("filtro1"):"";
        String filtro2 = request.getParameter("filtro2")!=null?request.getParameter("filtro2"):"";
        filtros.put("filtro1", filtro1);
        filtros.put("filtro2", filtro2);
        try {
            if (!filtro1.equals("")){
                    filtros.put("razonSocial", new String(request.getParameter("razonSoc").getBytes("ISO-8859-1"), "UTF-8"));
            }
            if (!filtro2.equals("")){
                filtros.put("nombre", new String(request.getParameter("nombre").getBytes("ISO-8859-1"), "UTF-8"));
                filtros.put("paterno", new String(request.getParameter("paterno").getBytes("ISO-8859-1"), "UTF-8"));
                filtros.put("materno", new String(request.getParameter("materno").getBytes("ISO-8859-1"), "UTF-8"));
            }
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        datos.put("filtros", filtros);
    }

}
