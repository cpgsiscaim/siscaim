/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.PerPagos;
import Modelo.Entidades.Catalogos.Puestos;
import Modelos.PlazaMod;
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
public class GestionarPlazasControl extends Action{
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
        PlazaMod plzMod = new PlazaMod();
        sesion = plzMod.GestionarPlazas(sesion);
        if (paso.equals("12") || paso.equals("18") || paso.equals("19")){
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
        if (paso.equals("13")){
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
        //if (!datos.get("paso").toString().equals("-10")){
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+sesion.getPaginaSiguiente());
        
        rd.forward(request, response);
        //}
    }

    @Override
    public void asignaParametros() {
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig")!=null?request.getParameter("pasoSig"):"0";
        String paginaSig = "";
        HashMap param = new HashMap();
        SimpleDateFormat ff = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat ff2 = new SimpleDateFormat("yyyy-MM-dd");        
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
                //obtener clientes de sucursal
                Sucursal suc = new Sucursal();
                suc.setId(Integer.parseInt(request.getParameter("sucursal")));
                datos.put("sucursalSel", suc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case -2: case -4:
                //obtener contratos de cliente
                Cliente cli = new Cliente();
                cli.setId(Integer.parseInt(request.getParameter("cliente")));
                datos.put("clienteSel", cli);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case -3:
                //obtener cts de contrato
                Contrato con = new Contrato();
                con.setId(Integer.parseInt(request.getParameter("contrato")));
                datos.put("editarContrato", con);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 1:
                //obtener plazas de ct
                CentroDeTrabajo ct = new CentroDeTrabajo();
                ct.setId(Integer.parseInt(request.getParameter("ctrab")));
                datos.put("centro", ct);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 7: case 15: case 16: case 17: case 95: case 96: case 97: case 98: case 99:
                //ir a nueva plaza (2) || ir a inactivas (7) || cancelar inactivas (97) || cancelar nueva plaza(98) || salir de gestionar plazas(99)
                //recalcular movs extras de todas las plazas(17)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5:
                //guardar plaza nueva (3) | editada (5)
                CargarPlaza();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 4: case 6: case 8: case 9: case 10: case 20:
                //ir a editar plaza (4) || baja de plaza(6) || activar plaza (8)
                //sustituir plaza (10)
                Plaza plz = new Plaza();
                plz.setId(Integer.parseInt(request.getParameter("idPlz")));
                datos.put("plaza", plz);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                sesion.setPaginaAnterior("/Nomina/Plazas/gestionarplazas.jsp");
                break;
            case 11:
                Plaza plzalta = new Plaza();
                plzalta.setEmpleado(new Empleado());
                plzalta.getEmpleado().setNumempleado(Integer.parseInt(request.getParameter("empleado")));
                String sfechaAlta = request.getParameter("fechaAlta");
                String sfechaBaja = request.getParameter("fechaBaja");
                SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
                Date fechaA = null, fechaB = null;
                try {
                    fechaA = formatoDelTexto.parse(sfechaAlta);
                    fechaB = formatoDelTexto.parse(sfechaBaja);
                } catch (ParseException ex) {
                }        
                plzalta.setFechaalta(fechaA);
                Plaza plzbaja = (Plaza)datos.get("plaza");
                plzbaja.setFechabaja(fechaB);
                datos.put("plazaAlta", plzalta);
                datos.put("plazaBaja", plzbaja);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 12: case 13:
                //imprimir listado general de nomina
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina/Personal"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/datosempactivossuc.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUCURSAL", new Integer(request.getParameter("dato1")));
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 14:
                //aplicar la baja
                String fechabaja = request.getParameter("fechabaja");
                datos.put("fechabaja", fechabaja);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 18:
                String idsuc = request.getParameter("dato1");
                String idcli = request.getParameter("dato2");
                String idcon = request.getParameter("dato3");
                String idct = request.getParameter("dato4");
                String cotiza = request.getParameter("dato5");
                if (cotiza.equals("-1"))
                    cotiza = "0,1";
                String estatus = request.getParameter("dato6");
                if (estatus.equals("-1"))
                    estatus = "0,1";
                Date fechaini = null, fechafin = null;
                try {
                    fechaini = ff.parse(request.getParameter("dato7"));
                    fechafin = ff.parse(request.getParameter("dato8"));
                } catch (ParseException ex) {
                }
                
                String sfechini = ff2.format(fechaini);
                String sfechfin = ff2.format(fechafin);
                
                String reporte = "plazasdesucursal.jasper";
                if (!idcli.equals("0") && idcon.equals("0"))
                    reporte = "plazasdesucycli.jasper";
                else if (!idcli.equals("0") && !idcon.equals("0") && idct.equals("0"))
                    reporte = "plazasdesuccliycon.jasper";
                else if (!idcli.equals("0") && !idcon.equals("0") && !idct.equals("0"))
                    reporte = "plazasdesuccliconyct.jasper";
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Plazas/"+reporte));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUCURSAL", new Integer(idsuc));
                param.put("COTIZA", cotiza);
                param.put("ESTATUS", estatus);
                param.put("FECHAINI", sfechini);
                param.put("FECHAFIN", sfechfin);
                if (!idcli.equals("0") && idcon.equals("0"))
                    param.put("CLIENTE", new Integer(idcli));
                else if (!idcli.equals("0") && !idcon.equals("0") && idct.equals("0")){
                    param.put("CLIENTE", new Integer(idcli));
                    param.put("CONTRATO", new Integer(idcon));
                }else{
                    param.put("CLIENTE", new Integer(idcli));
                    param.put("CONTRATO", new Integer(idcon));
                    param.put("CT", new Integer(idct));
                }
                datos.put("parametros", param);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 19:
                String sucsat = request.getParameter("dato1");
                Date fechainisat = null, fechafinsat = null;
                try {
                    fechainisat = ff.parse(request.getParameter("dato2"));
                    fechafinsat = ff.parse(request.getParameter("dato3"));
                } catch (ParseException ex) {
                }
                
                String sfechinisat = ff2.format(fechainisat);
                String sfechfinsat = ff2.format(fechafinsat);
                
                datos.put("reporte", application.getRealPath("/WEB-INF/Reportes/Nomina/Plazas/sat.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUCURSAL", new Integer(sucsat));
                param.put("FECHAINI", sfechinisat);
                param.put("FECHAFIN", sfechfinsat);
                datos.put("parametros", param);
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarPlaza() {
        Plaza plz = new Plaza();
        plz.setEmpleado(new Empleado());
        plz.setPuesto(new Puestos());
        plz.setPeriodopago(new PerPagos());
        if (datos.get("accion").toString().equals("editar"))
            plz = (Plaza)datos.get("plaza");
        plz.getEmpleado().setNumempleado(Integer.parseInt(request.getParameter("empleado")));
        plz.getPuesto().setIdPuestos(Integer.parseInt(request.getParameter("puesto")));
        plz.setNivel(Integer.parseInt(request.getParameter("nivel")));
        String sfecha = request.getParameter("fechaAlta");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fecha = null;
        try {
            fecha = formatoDelTexto.parse(sfecha);
        } catch (ParseException ex) {
        }        
        plz.setFechaalta(fecha);
        plz.setSueldo(Float.parseFloat(request.getParameter("sueldo").replace(",", "")));
        /*plz.setCompensacion(Float.parseFloat(request.getParameter("compensacion").replace(",", "")));
        plz.setSueldocotiza(Float.parseFloat(request.getParameter("sueldocotiza").replace(",", "")));
        plz.setCompensacioncotiza(Float.parseFloat(request.getParameter("compensacioncotiza").replace(",", "")));*/
        plz.setFormapago(Integer.parseInt(request.getParameter("formapago")));
        plz.getPeriodopago().setIdPerPagos(Integer.parseInt(request.getParameter("periodo")));
        datos.put("plaza", plz);
    }
    
}
