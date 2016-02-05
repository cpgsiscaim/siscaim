/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import Modelos.PersonaMod;
import Modelos.EmpleadoMod;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.Banco;
import Modelo.Entidades.Catalogos.Estado;
import Modelos.SucursalMod;
import Modelo.Entidades.Catalogos.Municipio;
import java.io.*;
import java.util.Calendar;
import javax.servlet.ServletOutputStream;


/**
 *
 * @author roman
 */
public class GestionarPersonalControl extends Action{
    
    private Sesion sesion = new Sesion();
    private HashMap datos = new HashMap();
    private String paso = "0";
    
    public GestionarPersonalControl(){
        
    }

    @Override
    public void run() throws ServletException, IOException {
        //validar usuario logueado
        HttpSession sesionHttp = request.getSession(true);

        //validar si la sesion es valida
        sesion = (Sesion) sesionHttp.getAttribute("sesion");
        if (sesion == null || sesion.getUsuario() == null) {
            throw new ServletException("No existe una sesión válida");
        }
        datos = sesion.getDatos();
        //obtener parámetros
        this.asignaParametros();
        sesion.setDatos(datos);

        //instanciar modelo y método de operación
        EmpleadoMod empmod = new EmpleadoMod();
        sesion = empmod.GestionarEmpleado(sesion);
        
        if (paso.equals("10") || paso.equals("12") || paso.equals("15") || paso.equals("17") || paso.equals("19")
                || paso.equals("32") || paso.equals("42") || paso.equals("39") || paso.equals("44")){
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
        if (paso.equals("25") || paso.equals("43")){
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
        
        if (paso.equals("28")){
            if (datos.get("finiquito")!=null){
                sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/imprimirfiniquito.jsp");
            }
        }
        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);

        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());

        if (rd == null) {
            throw new ServletException("No se pudo encontrar " + sesion.getPaginaSiguiente());
        }

        rd.forward(request, response);
    }

    @Override
    public void asignaParametros() {
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig") != null ? request.getParameter("pasoSig") : "0";
        String vista = "";
        String paginaSig = "";
        HashMap param = new HashMap();
        Calendar choy = Calendar.getInstance();
        choy.setTime(new Date());
        String mes = "";
        switch (Integer.parseInt(paso)) {
            case 0:
                //paso inicial: obtener los parámetros de la pagina a cargar
//<<<el paso 0 es antes de iniciar el proceso que se quiere ejecutar>>>
                vista = request.getParameter("vista") != null ? request.getParameter("vista") : "";
                String idoperacion = request.getParameter("operacion") != null ? request.getParameter("operacion") : "";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
//<<<aquí se deben agregar los otros pasos que se requieran para realizar el proceso>>>
            case 100:
                Sucursal suc = new Sucursal();
                suc.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursal", suc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 1: case 7: case 11: case 22: case 30: case 31: case 50: case 51: case 52: case 53: 
            case 99: case 98: case 97: case 96: case 95: case 94: case 93: case 91: case 90: case 89:
            case 88:
                //obtener los datos de la jsp nueva persona
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 5: 
                // guardar nueva persona
                CargaPersonaAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4: case 6: case 8: case 9: case 13: case 14: case 16: case 18: case 20: case 23: case 28: case 35:
            case 36: case 38: case 40: case 45:
                //ir a editar empleado(4) || baja de empleado (6) || activar empleado(8) || foto(9)
                //ir a familiares del empleado(13) || ir a medios del empleado (14)
                //ir a formatos (16) || listar plazas del empleado (18) || ir a finiquito (28)
                //consultar pagos del empleado(40) || ver ficha de datos del empleado (45)
                Empleado editar = new Empleado();
                editar.setNumempleado(Integer.parseInt(request.getParameter("idEmp")));// editar.setId(Integer.parseInt(request.getParameter("idCli")));
                if (Integer.parseInt(paso) == 4 ||  Integer.parseInt(paso) == 9 || Integer.parseInt(paso) == 36
                        || Integer.parseInt(paso) == 45) {
                    datos.put("editarEmpleado", editar);
                } 
                else if (Integer.parseInt(paso) == 6) {
                    datos.put("bajaEmpleado", editar);
                    String sfechab = request.getParameter("fechab");
                    SimpleDateFormat ff = new SimpleDateFormat("dd-MM-yyyy");
                    Date fechabaja = null;
                    try {
                        fechabaja = ff.parse(sfechab);
                    } catch (ParseException ex) {
                    }
                    datos.put("fechabaja", fechabaja);
                } else if (Integer.parseInt(paso) == 8) {
                    datos.put("activarEmpleado", editar);
                } else {
                    datos.put("empleado", editar);
                }
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 10:
                //imprimir gafete de empleado (10)
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/gafete.jasper"));
                //datos.put("reporte", "/home/valoressuelomunicipio.jasper");
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("EMPLEADO", new Integer(Integer.parseInt(request.getParameter("dato1"))));
                param.put("RUTAFOTO", application.getRealPath("/Imagenes/Personal/Fotos"));
                param.put("RUTAFIRMA", application.getRealPath("/Imagenes/Personal/Firmas"));
                param.put("DIA", Integer.toString(choy.get(Calendar.DAY_OF_MONTH)));
                switch (Calendar.MONTH){
                    case 0: mes = "ENERO"; break;
                    case 1: mes = "FEBRERO"; break;
                    case 2: mes = "MARZO"; break;
                    case 3: mes = "ABRIL"; break;
                    case 4: mes = "MAYO"; break;
                    case 5: mes = "JUNIO"; break;
                    case 6: mes = "JULIO"; break;
                    case 7: mes = "AGOSTO"; break;
                    case 8: mes = "SEPTIEMBRE"; break;
                    case 9: mes = "OCTUBRE"; break;
                    case 10: mes = "NOVIEMBRE"; break;
                    case 11: mes = "DICIEMBRE"; break;
                }
                param.put("MES", mes);
                param.put("ANIO", Integer.toString(choy.get(Calendar.YEAR)));
                param.put("FIRMA", application.getRealPath("Imagenes/firmaOk.png"));
                datos.put("parametros", param);
                //paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                //sesion.setPaginaSiguiente("/Administrar/Suelos/valoresdesuelo.jsp");                
                break;
            case 12:
                //imprimir gafete de empleado (10)
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/gafetes.jasper"));
                //datos.put("reporte", "/home/valoressuelomunicipio.jasper");
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("EMPLEADOS", request.getParameter("dato1"));
                param.put("RUTAFOTO", application.getRealPath("/Imagenes/Personal/Fotos"));
                param.put("RUTAFIRMA", application.getRealPath("/Imagenes/Personal/Firmas"));
                param.put("DIA", Integer.toString(choy.get(Calendar.DAY_OF_MONTH)));
                switch (Calendar.MONTH){
                    case 0: mes = "ENERO"; break;
                    case 1: mes = "FEBRERO"; break;
                    case 2: mes = "MARZO"; break;
                    case 3: mes = "ABRIL"; break;
                    case 4: mes = "MAYO"; break;
                    case 5: mes = "JUNIO"; break;
                    case 6: mes = "JULIO"; break;
                    case 7: mes = "AGOSTO"; break;
                    case 8: mes = "SEPTIEMBRE"; break;
                    case 9: mes = "OCTUBRE"; break;
                    case 10: mes = "NOVIEMBRE"; break;
                    case 11: mes = "DICIEMBRE"; break;
                }
                param.put("MES", mes);
                param.put("ANIO", Integer.toString(choy.get(Calendar.YEAR)));
                param.put("FIRMA", application.getRealPath("Imagenes/firmaOk.png"));
                datos.put("parametros", param);
                //paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                //sesion.setPaginaSiguiente("/Administrar/Suelos/valoresdesuelo.jsp");                
                break;
            case 15: case 25:
                //imprimir listado de personal
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina/Personal"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/empleadosdesuc.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUCURSAL", new Integer(request.getParameter("dato1")));
                datos.put("parametros", param);
                break;
            case 17:
                //imprimir formatos del empleado
                int formato = Integer.parseInt(request.getParameter("dato1"));
                switch (formato){
                    case 1:
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/solingresoord.jasper"));
                        break;
                    case 2:
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/acuerdoingreso.jasper"));
                        break;
                    case 3:
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/certificadoaportacion.jasper"));
                        break;
                    case 5:
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/renuncia.jasper"));
                        break;
                    case 6:
                        datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/acuerdorenuncia.jasper"));
                        break;
                }
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                Empleado empl = (Empleado)datos.get("empleado");
                param.put("EMPLEADO", new Integer(empl.getNumempleado()));
                datos.put("parametros", param);
                break;
            case 19:
                //imprimir listado de plazas del empleado
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/plazasemp2.jasper"));
                //datos.put("reporte", "/home/valoressuelomunicipio.jasper");
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("/WEB-INF/Reportes/Empresa"));
                Empleado emp = (Empleado)datos.get("empleado");
                param.put("EMPLEADO", new Integer(emp.getNumempleado()));
                String titulo = datos.get("titulo")!=null?datos.get("titulo").toString():"VIGENTES";
                param.put("TITULO", titulo);
                //obtener las plazas a imprimir
                List<Plaza> listado = (List<Plaza>)datos.get("plazas");
                String plazas = "";
                for (int i=0; i < listado.size(); i++){
                    Plaza p = listado.get(i);
                    if (plazas.equals(""))
                        plazas += Integer.toString(p.getId());
                    else
                        plazas += ","+Integer.toString(p.getId());
                }
                param.put("PLAZAS", plazas);
                datos.put("parametros", param);
                break;
            case 21:
                //aplicar los filtros establecidos
                HashMap filtros = new HashMap();
                filtros.put("clave", request.getParameter("filclave"));
                filtros.put("nombre", request.getParameter("filnombre"));
                filtros.put("paterno", request.getParameter("filpaterno"));
                filtros.put("materno", request.getParameter("filmaterno"));
                datos.put("filtros", filtros);
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 24:
                //cambiar de sucursal
                Sucursal nvasuc = new Sucursal();
                nvasuc.setId(Integer.parseInt(request.getParameter("nuevasucursal")));
                datos.put("nuevasuc", nvasuc);
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 26: case 27:
                //alta-baja imss de empleado
                String sfechamov = request.getParameter("fechaimss");
                SimpleDateFormat frm = new SimpleDateFormat("dd-MM-yyyy");
                Date fechamov = null;
                try {
                    fechamov = frm.parse(sfechamov);
                } catch (ParseException ex) {
                }
                datos.put("fechamov", fechamov);
                try {
                    datos.put("nss", request.getParameter("nssEmpPer")!=null?new String(request.getParameter("nssEmpPer").getBytes("ISO-8859-1"), "UTF-8"):"");
                    datos.put("regpat", request.getParameter("rpimss")!=null?new String(request.getParameter("rpimss").getBytes("ISO-8859-1"), "UTF-8"):"");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(GestionarPersonalControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (paso.equals("26"))
                    datos.put("sbc", new Float(Float.parseFloat(request.getParameter("sbcimss").replace(",", ""))));
                break;
            case 34:
                //alta-baja imss de empleado
                String sfechamova = request.getParameter("fechaimss");
                String sfechamovb = request.getParameter("fechaimssbaja");
                String idhis = request.getParameter("idssel");
                SimpleDateFormat frme = new SimpleDateFormat("dd-MM-yyyy");
                Date fechamova = null, fechamovb = null;
                try {
                    fechamova = frme.parse(sfechamova);
                    if (sfechamovb!=null && !sfechamovb.equals(""))
                        fechamovb = frme.parse(sfechamovb);
                } catch (ParseException ex) {
                }
                datos.put("fechamovalta", fechamova);
                if (sfechamovb!=null && !sfechamovb.equals(""))
                    datos.put("fechamovbaja", fechamovb);
                datos.put("id", idhis);
                try {
                    datos.put("nss", request.getParameter("nssEmpPer")!=null?new String(request.getParameter("nssEmpPer").getBytes("ISO-8859-1"), "UTF-8"):"");
                    datos.put("regpat", request.getParameter("rpimss")!=null?new String(request.getParameter("rpimss").getBytes("ISO-8859-1"), "UTF-8"):"");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(GestionarPersonalControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                datos.put("sbc", new Float(Float.parseFloat(request.getParameter("sbcimss").replace(",", ""))));
                break;
            case 29:
                //guardar finiquito
                Finiquito fini = new Finiquito();
                fini.setDiasaguianio(Integer.parseInt(request.getParameter("diasaguianio")));
                fini.setPorcprimavac(Float.parseFloat(request.getParameter("porcprimavac").replace(",","")));
                fini.setDiasvacpend(Integer.parseInt(request.getParameter("diasvacpend")));
                fini.setDiasvactomadas(Integer.parseInt(request.getParameter("diasvactomadas")));
                fini.setDiasvacanteriores(Integer.parseInt(request.getParameter("diasvacant")));
                fini.setDiasagui(Float.parseFloat(request.getParameter("diasagui").replace(",", "")));
                fini.setDiasvac(Float.parseFloat(request.getParameter("diasvac").replace(",", "")));
                fini.setDiasprimavac(Float.parseFloat(request.getParameter("diaspv").replace(",", "")));
                fini.setImpagui(Float.parseFloat(request.getParameter("impagui").replace(",", "")));
                fini.setImpvac(Float.parseFloat(request.getParameter("impvac").replace(",", "")));
                fini.setImpprimavac(Float.parseFloat(request.getParameter("imppv").replace(",", "")));
                datos.put("finiquito", fini);
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 33:
                //borrar registros del historial
                datos.put("ids", request.getParameter("idssel"));
                paginaSig = request.getParameter("paginaSig") != null ? request.getParameter("paginaSig") : "";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 32:
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/finiquito.jasper"));
                param = new HashMap();
                Empleado em = (Empleado)datos.get("empleado");
                param.put("EMPLEADO", new Integer(em.getNumempleado()));
                datos.put("parametros", param);
                break;
            case 37:
                //nueva firma
                String firma = request.getParameter("firmaNueva");
                datos.put("nuevaFirma", firma);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 39:
                //guardar datos contrato
                ContratoTrabajo cntr = (ContratoTrabajo) datos.get("contratotrabajo");
                cntr.setJornada(Integer.parseInt(request.getParameter("dato1")));
                cntr.setEntrada(request.getParameter("dato2"));
                cntr.setSalida(request.getParameter("dato3"));
                cntr.setDiainicio(request.getParameter("dato4"));
                cntr.setDiafin(request.getParameter("dato5"));
                //cntr.setDiasdescanso(request.getParameter("sdiasdesc"));
                datos.put("contratotrabajo", cntr);
                
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/contrato.jasper"));
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                Empleado empct = (Empleado)datos.get("empleado");
                param.put("EMPLEADO", new Integer(empct.getNumempleado()));
                datos.put("parametros", param);
                break;
            case 41:
                //nueva foto
                String foto = request.getParameter("fotoNueva");
                datos.put("nuevaFoto", foto);
                datos.put("rutaFoto", application.getRealPath("/Imagenes/Personal/Fotos/"+foto));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 42:
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/porcentajeasegurados.jasper"));
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Nomina/Personal"));
                datos.put("parametros", param);
                break;
            case 43:
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Nomina/Personal"));
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/solicitudtarjetas.jasper"));
                param = new HashMap();
                datos.put("parametros", param);
                break;
            case 44:
                //imprimir recibo de pago
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/recibopago.jasper"));
                //parametros
                param = new HashMap();
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("SUBREPORTES", application.getRealPath("WEB-INF/Reportes/Nomina"));
                param.put("NOMINA", new Integer(Integer.parseInt(request.getParameter("dato1"))));
                Empleado remp = (Empleado)datos.get("empleado");
                param.put("EMPLEADO", new Integer(remp.getNumempleado()));
                datos.put("parametros", param);
                break;
                
        }
        datos.put("paso", paso);
    }
    //
    private void CargaPersonaAGuardar(){
        try {            
            Empleado empPer = new Empleado();                        
            empPer.setPersona(new Persona());
            empPer.getPersona().setDireccion(new Direccion());
            empPer.getPersona().getDireccion().setPoblacion(new Municipio());
            empPer.setBanco(new Banco());
            //empPer.getPersona().getDireccion().getPoblacion().setEstado(new Estado());
            if (datos.get("accion").toString().equals("editar")) {
                empPer = (Empleado) datos.get("editarEmpleado");
                if (empPer.getBanco()==null)
                    empPer.setBanco(new Banco());
            }
            
            //datos básicos
            empPer.setClave(new String(request.getParameter("clave").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setNombre(new String(request.getParameter("nombrePer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setPaterno(new String(request.getParameter("paternoPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setMaterno(new String(request.getParameter("maternoPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setCurp(new String(request.getParameter("curpPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setSexo(request.getParameter("sexoPer"));
            empPer.getPersona().setLugarn(Integer.parseInt(request.getParameter("estadoNac")));
            String fechaA = request.getParameter("fechaAlta");
            String fechaN = request.getParameter("fechaNac");
            SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
            Date fechaAlta = null, fechaNac = null;
            try {
                fechaAlta = formatoDelTexto.parse(fechaA);
                fechaNac = formatoDelTexto.parse(fechaN);
            } catch (ParseException ex) {
            }
            empPer.getPersona().setFnaci(fechaNac);
            empPer.setFecha(fechaAlta);
            empPer.getPersona().getDireccion().setCalle(new String(request.getParameter("callenumPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().getDireccion().setNumero(new String(request.getParameter("numero").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().getDireccion().setColonia(new String(request.getParameter("coloniaPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().getDireccion().setCp(Integer.parseInt(!request.getParameter("codigopPer").equals("")?request.getParameter("codigopPer"):"0"));
            empPer.getPersona().getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacionPer")));
            
            //otros datos
            empPer.getPersona().setGposang(Integer.parseInt(request.getParameter("gposangPer")));            
            empPer.getPersona().setCivil(Integer.parseInt(request.getParameter("edocivilPer")));            
            empPer.getPersona().setRfc(new String(request.getParameter("rfcPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setTitulo(new String(request.getParameter("tituloPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.setEstudios(new String(request.getParameter("estudiosEmpPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.setCuenta(new String(request.getParameter("cuentaEmpPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.setPadecimiento(Integer.parseInt(request.getParameter("padecimiento")));
            empPer.setDescripadecimiento("");
            if (empPer.getPadecimiento()==1)
                empPer.setDescripadecimiento(new String(request.getParameter("descripadecimiento").getBytes("ISO-8859-1"), "UTF-8"));
            /*empPer.setCotiza(0);
            String cotiza = request.getParameter("cotizaEmpPer");
            if (cotiza!=null && cotiza.equals("on"))
                empPer.setCotiza(1);*/
            empPer.setNss(request.getParameter("nssEmpPer")!=null?new String(request.getParameter("nssEmpPer").getBytes("ISO-8859-1"), "UTF-8"):"");
            empPer.setRegistropatronal("");
            empPer.getPersona().setCargo(new String(request.getParameter("cargoPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.getPersona().setObservacion(new String(request.getParameter("observacionDirPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.setDocestatus(Integer.parseInt(request.getParameter("docestatus")));
            
            if (datos.get("accion").toString().equals("nuevo")) {
                datos.put("nuevoEmpleado", empPer);
            } else {
                datos.put("editarEmpleado", empPer);
            }
            
            String idbanco = request.getParameter("banco");
            empPer.setConsecutivo(0);
            if (idbanco.equals(""))
                empPer.setBanco(null);
            else {
                empPer.getBanco().setId(Integer.parseInt(idbanco));
                if (empPer.getBanco().getId()==2)
                    empPer.setConsecutivo(Integer.parseInt(request.getParameter("consecutivo")));
            }
            
            
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
/*
    private void CargaEmpleadoAGuardar(){
        try {
            Empleado empPer = new Empleado();
            //obtener persona
            Persona personal = (Persona)datos.get("personal");                                                    
            
            empPer.setPersona(personal);
            empPer.setEstatus(1);
            //cotiza nss cuenta estudios
            int idsexo = Integer.parseInt(request.getParameter("cotizaEmpPer"));
            if (idsexo==0){                
                
                empPer.setCotiza(' ');
            }
            else if (idsexo==1){
                empPer.setCotiza('S');
            }
            else if (idsexo==2){
                empPer.setCotiza('N');
            }            
            empPer.setCuenta(new String(request.getParameter("cuentaEmpPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.setNss(new String(request.getParameter("nssEmpPer").getBytes("ISO-8859-1"), "UTF-8"));
            empPer.setEstudios(new String(request.getParameter("estudiosEmpPer").getBytes("ISO-8859-1"), "UTF-8"));
            
            datos.put("empleadoper", empPer);
                        
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }      
     */
}
