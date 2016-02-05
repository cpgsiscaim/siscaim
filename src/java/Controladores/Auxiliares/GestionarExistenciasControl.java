/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Almacen;
import Modelo.Entidades.Existencia;
import Modelo.Entidades.Sucursal;
import Modelos.ExistenciaMod;
import java.io.*;
import java.text.ParseException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

/**
 *
 * @author temoc
 */
public class GestionarExistenciasControl extends Action{
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
        ExistenciaMod exMod = new ExistenciaMod();
        sesion = exMod.GestionarExistencias(sesion);
        if (paso.equals("3")){
            int bxls = Integer.parseInt(datos.get("banxls").toString());
            if (bxls==0){
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
            } else {
                //imprimir xls
                datos = sesion.getDatos();
                File f = (File)datos.get("reportexls");
                //byte[] bytes = (byte[])datos.get("bytes");
                response.setContentType("application/vnd.ms-excel");
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
            case 1:
                //obtener almacenes de sucursal
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursal")));
                datos.put("sucursalSel", sucSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2:
                //obtener las existencias del almacen y sucursal
                Almacen alm = new Almacen();
                alm.setId(Integer.parseInt(request.getParameter("almacen")));
                datos.put("almacenSel", alm);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 50: case 51: case 52: case 53: case 99:
                //ir al principio de la lista (50) || mostrar anteriores (51) || mostrar siguiente grupo(52) || ir al final de la lista(53)
                //salir de gestionar clientes(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3:
                //imprimir lista
                datos.put("banxls", request.getParameter("dato1"));
                Sucursal suc = (Sucursal) datos.get("sucursalSel");
                Almacen alma = (Almacen) datos.get("almacenSel");
                datos.put("reporte", application.getRealPath("/WEB-INF/Reportes/Inventario/existencias.jasper"));
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Inventario"));
                //parametros
                HashMap param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUCURSAL", new Integer(suc.getId()));
                param.put("ALMACEN", new Integer(alma.getId()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                datos.put("parametros", param);
                sesion.setPaginaSiguiente("/Inventario/Existencias/gestionarexistencias.jsp");
                break;
        }
        datos.put("paso", paso);
    }
/*
    private void CargaNuevoCliente() {
        Cliente nuevo = new Cliente();
        if (datos.get("accion").toString().equals("editar"))
            nuevo = (Cliente) datos.get("editarCliente");
        String tipoCli = request.getParameter("rdTipoCli");
        nuevo.setDatosFiscales(new DatosFiscales());
        nuevo.getDatosFiscales().setPersona(new Persona());
        if (tipoCli.equals("moral")){
            nuevo.setTipo(0);
            try {
                nuevo.getDatosFiscales().setRazonsocial(new String(request.getParameter("razonCli").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().setRfc(new String(request.getParameter("rfcCli").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().setTipo("0");
                nuevo.getDatosFiscales().getPersona().setNombre(new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().getPersona().setPaterno(new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
                nuevo.getDatosFiscales().getPersona().setMaterno(new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
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
        nuevo.getDatosFiscales().getPersona().setSucursal(sucSel);
        nuevo.setSucursal(sucSel);
        
        nuevo.getDatosFiscales().setDireccion(new Direccion());
        try {
            nuevo.getDatosFiscales().getDireccion().setCalle(new String(request.getParameter("calleCli").getBytes("ISO-8859-1"), "UTF-8"));
            nuevo.getDatosFiscales().getDireccion().setColonia(new String(request.getParameter("coloniaCli").getBytes("ISO-8859-1"), "UTF-8"));
            String cp = request.getParameter("cpCli");
            if (cp.equals(""))
                nuevo.getDatosFiscales().getDireccion().setCp(0);
            else
                nuevo.getDatosFiscales().getDireccion().setCp(Integer.parseInt(cp));
            nuevo.getDatosFiscales().getDireccion().setPoblacion(new Municipio());
            nuevo.getDatosFiscales().getDireccion().getPoblacion().setEstado(new Estado());
            nuevo.getDatosFiscales().getDireccion().getPoblacion().getEstado().setIdestado(Integer.parseInt(request.getParameter("estadoCli")));
            nuevo.getDatosFiscales().getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacionCli")));            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        nuevo.getDatosFiscales().getDireccion().setTipo('0');
        
        nuevo.setAgente(new Agente());
        nuevo.getAgente().setId(Integer.parseInt(request.getParameter("agente")));
        nuevo.setRuta(new Ruta());
        nuevo.getRuta().setId(Integer.parseInt(request.getParameter("ruta")));
        nuevo.setEstatus(1);
        nuevo.setListaPrecios(Integer.parseInt(request.getParameter("listap")));
        String fecha = request.getParameter("fechaAlta");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
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
*/
}
