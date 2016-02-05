/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelos.MovimientoMod;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
public class GestionarMovimientosControl extends Action{
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
        MovimientoMod movMod = new MovimientoMod();
        sesion = movMod.GestionarMovimientos(sesion);
        if (paso.equals("27") || paso.equals("41")){
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
        if (paso.equals("31")){
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
        }//imprimir xls
        
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
            case -1:
                //obtener datos del producto seleccionado
                Detalle detp = new Detalle();
                detp.setProducto(new Producto());
                detp.getProducto().setId(Integer.parseInt(request.getParameter("producto")));
                datos.put("detallep", detp);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 1:
                //cargar movimientos de sucursal y de tipo de movimiento
                Sucursal sucSel = new Sucursal();
                if (request.getParameter("sucursalsel")!=null){
                    sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                    datos.put("sucursalSel", sucSel);
                }
                TipoMov tmov = new TipoMov();
                tmov.setId(Integer.parseInt(request.getParameter("tipomovsel")));
                datos.put("tipomovSel", tmov);
                datos.put("fechaini", request.getParameter("fechai"));
                datos.put("fechafin", request.getParameter("fechaf"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 7: case 15: case 20: case 24: case 25: case 29: case 89: 
            case 90: case 91: case 92: case 93: case 94: case 95: case 96: 
            case 97: case 98: case 99:
                // ir a nuevo movimiento(2) || ir a inactivos cab(7) || ir a inactivos det (15)
                //ir a importar pedido(20) || ir a importar cotizacion (24) || cancelar importar cotizacion (91) || cancelar importar pedido (92)
                //quitar filtros(29)
                //cancelar aplicar mov (93) || cancelar inactivos det (94) || cancelar nuevo detalle (95)
                //cancelar detalle(96) || cancelar inactivos cab(97) || cancelar nuevo movimiento cab (98) || salir de gestionar clientes(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaAnterior("");
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case -2: case -3: case 3: case 5: case 10: case 51:
                //guardar nuevo mov cab(3) || guardar mov cab editado (5) || ir a nuevo detalle (10) || solo guardar mov editado(21)
                CargaCabecera();
                if (Integer.parseInt(paso)==3){
                    TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
                    //cargar cantidades del detalle
                    if (tmovSel.getId()!=25)
                        CargaCantidades();
                    String aplicar = request.getParameter("aplicarinv")!=null?request.getParameter("aplicarinv"):"";
                    if (aplicar.equals("on")){
                        CargarFechaAplicacion();
                    }
                    datos.put("aplicarinv", aplicar);
                    if (tmovSel.getCategoria()==1 && tmovSel.getId()!=8){
                        CargaCostos();
                    }
                    if (tmovSel.getId()==25){
                        CargaExistenciasFisicas();
                    }
                }
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8: case 9: case 17: case 23: case 26:
                //ir a editar mov cab(4) || baja de movimiento cab (6) || activar movimiento cab(8) || ir a detalle (9)
                //importar cotizacion sel (25) || imprimir movimiento (26) || aplicar movimiento al inventario(17) || importar pedido seleccionado (23)
                Cabecera cab = new Cabecera();
                cab.setId(Integer.parseInt(request.getParameter("idMov")));
                datos.put("varios", request.getParameter("varios"));
                datos.put("cabecera", cab);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 11:
                datos.put("dettipo", request.getParameter("tipo"));
                datos.put("detcant", request.getParameter("cantidad"));
                datos.put("prodssel", request.getParameter("prodssel"));
                datos.put("unidadsel", request.getParameter("unidad"));
                datos.put("almacensel", request.getParameter("almacen"));
                datos.put("ubicacionsel", request.getParameter("ubicacion"));
                datos.put("imprimirsel", request.getParameter("imprimir")!=null?request.getParameter("imprimir"):"");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 13:
                //guardar detalle editado (13)
                CargaDetalle();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 12: case 14: case 16:
                //ir a editar mov det (12) || baja de detalle (14) || activar detalle (16)
                /*Detalle det = new Detalle();
                det.setId(Integer.parseInt(request.getParameter("idDet")));
                datos.put("detalle", det);*/
                CargaCabecera();
                datos.put("variosdet", request.getParameter("variosdet"));
                datos.put("indicedet",request.getParameter("idDet"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 18:
                CargarFechaAplicacion();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 27: case 31:
                //imprimir movimiento (27)
                TipoMov tmsel = (TipoMov)datos.get("tipomovSel");
                if (tmsel.getId()!=20 && tmsel.getId()!=21 && tmsel.getId()!=25)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/movimiento.jasper"));
                else if (tmsel.getId()==20 || tmsel.getId()==21)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/movimientosp.jasper"));
                else if (tmsel.getId()==25)
                    datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/movimientolf.jasper"));
                /*if (Integer.parseInt(paso)==31){
                    if (tmsel.getId()!=20 && tmsel.getId()!=21)
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/movimientoxls.jasper"));
                    else
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Inventario/movimientospxls.jasper"));
                }*/
                //datos.put("reporte", "/home/valoressuelomunicipio.jasper");
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Inventario"));                
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                param.put("IDMOV", new Integer(request.getParameter("dato1")));
                param.put("OBS1", request.getParameter("dato2"));
                param.put("OBS2", request.getParameter("dato3"));
                param.put("OBS3", request.getParameter("dato4"));
                datos.put("parametros", param);
                //sesion.setPaginaSiguiente("/Inventario/Movimientos/gestionarmovimientos.jsp");
                break;
            case 28:
                //carga los filtros
                CargaFiltros();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 40:
                //formato de levantamiento físico- cargar almacenes de sucursal
                Sucursal sucSellf = new Sucursal();
                sucSellf.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucSellf);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 41:
                String suc = request.getParameter("dato1");
                Integer almid = Integer.parseInt(request.getParameter("dato2"));
                datos.put("reporte", application.getRealPath("/WEB-INF/Reportes/Inventario/formatolevfisico.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUCURSAL", suc);
                param.put("ALMACEN", almid);
                //param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                datos.put("parametros", param);
                sesion.setPaginaSiguiente("/Inventario/Reportes/levantamientofisico.jsp");
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaCabecera() {
        Cabecera cab = new Cabecera();
        //cab.setSerie(new Serie());
        if (datos.get("accion").toString().equals("editar"))
            cab = (Cabecera) datos.get("cabecera");
        
        String sFechaCap = request.getParameter("fecha");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaCap = null;
        try {
            fechaCap = formatoDelTexto.parse(sFechaCap);
        } catch (ParseException ex) {
        }        
        cab.setFechaCaptura(fechaCap);
        //segun el tipo de movimiento carga datos de la cabecera
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        switch(tmovSel.getId()){
            case 5: case 6://pedido(5) | compra(6)
                if (datos.get("accion").toString().equals("nuevo"))
                    cab.setProveedor(new Proveedor());
                //cab.setSerie((Serie)datos.get("seriedelmov"));
                //cab.setFolio(Integer.parseInt(request.getParameter("folio")));
                cab.getProveedor().setId(Integer.parseInt(request.getParameter("proveedor")));
                if (tmovSel.getId()==6){
                    cab.setSerieOriginal(request.getParameter("serieorig"));
                    cab.setFolioOriginal(Integer.parseInt(request.getParameter("folioorig")));
                    cab.setFlete(Float.parseFloat(request.getParameter("flete")));
                }
                cab.setTipomov(tmovSel);
                break;
            case 7: case 8:
                if (datos.get("accion").toString().equals("nuevo"))
                    cab.setTipomov(new TipoMov());
                cab.getTipomov().setId(Integer.parseInt(request.getParameter("movimiento")));
                break;
            case 9: case 10: case 20: case 21://cotizacion(9) | facturacion (10) | salida progr ct
                if (datos.get("accion").toString().equals("nuevo"))
                    cab.setCliente(new Cliente());
                //cab.setSerie((Serie)datos.get("seriedelmov"));
                //cab.setFolio(Integer.parseInt(request.getParameter("folio")));
                cab.getCliente().setId(Integer.parseInt(request.getParameter("cliente")));
                if (tmovSel.getId()==20 || tmovSel.getId()==21){
                    if (datos.get("accion").toString().equals("nuevo")){
                        cab.setContrato(new Contrato());
                        cab.setCentrotrabajo(new CentroDeTrabajo());
                    }
                    if (Integer.parseInt(paso) == -3 || (Integer.parseInt(paso) > 0)){
                        cab.getContrato().setId(Integer.parseInt(request.getParameter("contrato")));
                        if (Integer.parseInt(paso) > 0)
                            cab.getCentrotrabajo().setId(Integer.parseInt(request.getParameter("ct")));
                    }
                }
                cab.setTipomov(tmovSel);
                break;
            case 25:
                try {
                    cab.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(GestionarMovimientosControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
        }
        datos.put("cabecera", cab);        
    }

    private void CargaDetalle() {
        Detalle det = new Detalle();
        if (datos.get("acciondet").toString().equals("editarDet")){
            Detalle detx = (Detalle) datos.get("detalle");
            det = (Detalle)detx.clone();
        }
        det.setProducto(new Producto());
        det.getProducto().setId(Integer.parseInt(request.getParameter("producto")));
        det.setUnidad(new Unidad());
        det.getUnidad().setId(Integer.parseInt(request.getParameter("unidad")));
        det.setCantidad(Float.parseFloat(request.getParameter("cantidad").replace(",", "")));
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
            if (tmovSel.getCategoria()==1)
                det.setCosto(Float.parseFloat(request.getParameter("precos").replace(",", "")));
            else
                det.setPrecio(Float.parseFloat(request.getParameter("precos").replace(",", "")));
            det.setDescuento(Float.parseFloat(request.getParameter("descuento").replace(",", "")));
            det.setImporte(Float.parseFloat(request.getParameter("importe").replace(",", "")));
        }
        if (tmovSel.getId()==20)
            det.setCambio(Integer.parseInt(request.getParameter("tipo")));
        det.setAlmacen(new Almacen());
        det.getAlmacen().setId(Integer.parseInt(request.getParameter("almacen")));
        det.setUbicacion(new Ubicacion());
        det.getUbicacion().setId(Integer.parseInt(request.getParameter("ubicacion")));
        det.setAuto(0);//detalle agregado manualmente por el usuario

        det.setImprimir(0);
        String impr = request.getParameter("imprimir")!=null?request.getParameter("imprimir"):"";
        if (impr.equals("on"))
            det.setImprimir(1);
        
        datos.put("detalle", det);
    }

    private void CargarFechaAplicacion() {
        Cabecera cab = (Cabecera) datos.get("cabecera");
        String sFechaInv = request.getParameter("fechaInv");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaInv = null;
        try {
            fechaInv = formatoDelTexto.parse(sFechaInv);
        } catch (ParseException ex) {
        }        
        cab.setFechaInventario(fechaInv);
        datos.put("cabecera", cab);
    }

    private void CargaFiltros() {
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        HashMap filtros = new HashMap();
        filtros.put("folio", request.getParameter("filfolio"));
        try {
            filtros.put("cliente", new String(request.getParameter("filcliente").getBytes("ISO-8859-1"), "UTF-8"));
            if (tmovSel.getId()==20 || tmovSel.getId()==21){
                filtros.put("contrato", new String(request.getParameter("filcontrato").getBytes("ISO-8859-1"), "UTF-8"));
                filtros.put("ct", new String(request.getParameter("filct").getBytes("ISO-8859-1"), "UTF-8"));
                filtros.put("ruta", request.getParameter("ruta"));
            }
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarMovimientosControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        /*String sfechaini = request.getParameter("fechaini");
        String sfechafin = request.getParameter("fechafin");
        filtros.put("fechaini", sfechaini);
        filtros.put("fechafin", sfechafin);*/
        
        if (tmovSel.getId()!=7 && tmovSel.getId()!=8)
            filtros.put("opccliente", request.getParameter("opccliente"));
        
        String coincidencia = request.getParameter("chkExacto")!=null?request.getParameter("chkExacto"):"";
        filtros.put("coincidencia", "0");
        if (coincidencia.equals("on"))
            filtros.put("coincidencia", "1");
        
        datos.put("filtros", filtros);
    }

    private void CargaCantidades() {
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        for (int i=0; i < detalles.size(); i++){
            Detalle dt = detalles.get(i);
            float cant = Float.parseFloat(request.getParameter("cantidad"+Integer.toString(i)).replace(",", ""));
            float imp = 0;
            if (tmovSel.getId()!=7 && tmovSel.getId()!=8)
                imp = Float.parseFloat(request.getParameter("txtimporte"+Integer.toString(i)).replace(",", ""));
            dt.setCantidad(cant);
            dt.setImporte(imp);
        }
        datos.put("detalles", detalles);
    }
    
    private void CargaCostos() {
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        TipoMov tmovSel = (TipoMov)datos.get("tipomovSel");
        for (int i=0; i < detalles.size(); i++){
            Detalle dt = detalles.get(i);
            float costo = Float.parseFloat(request.getParameter("costo"+Integer.toString(i)).replace(",", ""));
            float imp = 0;
            if (tmovSel.getId()!=7 && tmovSel.getId()!=8)
                imp = Float.parseFloat(request.getParameter("txtimporte"+Integer.toString(i)).replace(",", ""));
            dt.setCosto(costo);
            dt.setImporte(imp);
        }
        datos.put("detalles", detalles);
    }

    private void CargaExistenciasFisicas() {
        List<Detalle> detalles = (List<Detalle>)datos.get("detalles");
        for (int i=0; i < detalles.size(); i++){
            Detalle dt = detalles.get(i);
            dt.setImporte(Float.parseFloat(request.getParameter("exfisica"+Integer.toString(i)).replace(",", "")));
        }
        datos.put("detalles", detalles);
    }
    
}
