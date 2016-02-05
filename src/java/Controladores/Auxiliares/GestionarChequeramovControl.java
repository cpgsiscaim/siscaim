package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Movimientos;
import Modelo.Entidades.Abono;
import Modelo.Entidades.Cargo;
import Modelo.Entidades.Chequera;
import Modelo.Entidades.Sucursal;
import Modelo.Entidades.Usuario;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.*;
import java.util.*;
import java.util.HashMap;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import javax.servlet.http.*;
import Modelos.MovimientoChequeraMod;
import java.text.ParseException;
import java.util.*;
import javax.servlet.ServletOutputStream;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class GestionarChequeramovControl extends Action {
  private Sesion sesion = new Sesion();
  private HashMap datos = new HashMap();
  private String paso = "0";
  
  
    @Override
  public void run() throws ServletException, IOException  {
    //validar usuario logueado
    HttpSession sesionHttp = request.getSession(true);
    //validar si la sesion es valida
    sesion = (Sesion) sesionHttp.getAttribute("sesion");
    if (sesion==null || sesion.getUsuario()==null)
        throw new ServletException ("No existe una sesión válida");

    datos = sesion.getDatos(); //Obtenemos los datos de la sesion
    this.asignaParametros(); //asignamos los parametros de la sesion
    sesion.setDatos(datos);
    
    //instanciamos el modelo y metodo de operacion
    MovimientoChequeraMod chemod = new MovimientoChequeraMod();
    sesion = chemod.GestionarMovimientos(sesion);
    if (paso.equals("17")){
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
    
    // cargamos los datos en la sesion
    sesionHttp.setAttribute("sesion", sesion);
    //mandamos a la pagina siguiente :p
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
      case   0:         //paso inicial: obtener la vista de los parametros
          datos.clear();
          String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
          String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
          datos.put("idoperacion", idoperacion);
          sesion.setPaginaSiguiente(vista);
          break;
      case 1: //cargar movimientos de sucursal seleccionada                
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);
          break;
      case 2: case 20: case 96: case 97: case 98: case 99:
          //redirije a la pagina que guarda un nuevo movimiento                
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);
          break;
      case 3: 
          CargaNuevoMovimiento();
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);
          break;
      case 4:
          CargaNuevaChequera();
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);
          break;
      case 5: //editar movimientos
          Movimientos edita = new Movimientos();        
          edita.setId(Integer.parseInt(request.getParameter("idMovi")));
          //int idC = Integer.parseInt(request.getParameter("idCargo"));
          //datos.put("edtaCargo", idC);
          datos.put("editarMovimiento", edita);
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);
          break;
      case 6: //Agrega el nuevo cargo
        /*Chequera nue = new Chequera();
        datos.put("tarjetaSel", nue);*/
        CargaNuevoCargo();        
        paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
        sesion.setPaginaSiguiente(paginaSig);
        break;
      case 7: case 18: case 19: case 21: case 22:
          Chequera editar = new Chequera();
          editar.setId(Integer.parseInt(request.getParameter("idTar")));
          //if (Integer.parseInt(paso)==7)
            datos.put("tarjetaSel", editar);
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);                
          break;
      case 8:   //esto se va al nuevo cargo
          Chequera actualiza = new Chequera();
          datos.put("tarjetaSel", actualiza);
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);
          break;
      case 9: //eliminar movimiento seleccionado
          Movimientos borra = new Movimientos();
          //Recibimos los parametros del JSP
          borra.setId(Integer.parseInt(request.getParameter("idMovi")));
          /*int tipo = Integer.parseInt(request.getParameter("tipo"));
          int idc = Integer.parseInt(request.getParameter("idCargo"));
          int ida = Integer.parseInt(request.getParameter("idAlma"));   //arrastramos lo q le llegara a gestionarMovimientos
          //Insertamos los parametros al HashMap
          datos.put("tipoMovimiento", tipo);*/
          datos.put("borrarMovimiento", borra);
          /*datos.put("temporalCargo", idc);
          datos.put("temporalAlma", ida);*/         
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);   
          break;
      case 10: //Actualiza la informacion del movimiento                     
          Chequera edital = new Chequera();
          edital.setId(Integer.parseInt(request.getParameter("idAlma")));
          int idMovimien = Integer.parseInt(request.getParameter("idMovi"));
          int modifica = Integer.parseInt(request.getParameter("idUpdate"));          
          String campo1 = request.getParameter("tarjeta");          
          String campo2 = request.getParameter("fecha");            
          String campo3 = request.getParameter("concepto");
          float campo4 = Float.parseFloat(request.getParameter("monto"));
          datos.put("elMovimiento", idMovimien);
          datos.put("tarjetaSel", edital);
          datos.put("idActualiza", modifica);
          datos.put("cFecha", campo2);
          datos.put("cConcepto", campo3);
          datos.put("cMonto", campo4);
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);   
          break;
      case 11: //elimina el cargo, una vez que ya se borro el movimiento
          Cargo modi = new Cargo();
          modi.setId(Integer.parseInt(request.getParameter("id_cargo")));
          datos.put("borrarCargo", modi);
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);   
          break;
      case 12:  // actualiza el listado de cargos, abonos y saldos
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);   
          break;
      case 13: //regresa de gestionarMovimientos a las chequeras y actualiza saldos
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);   
          break;
      case 14: //borra los abonos
        Abono abn = new Abono();
        abn.setId(Integer.parseInt(request.getParameter("id_cargo")));
        datos.put("borrarAbono", abn);
        paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
        sesion.setPaginaSiguiente(paginaSig);   
        break;
      case 15:
          Chequera editCh = new Chequera();
          editCh.setId(Integer.parseInt(request.getParameter("idAlma")));
          int id_Movimien = Integer.parseInt(request.getParameter("idMovi"));
          int modifica_ = Integer.parseInt(request.getParameter("idUpdate"));          
          String campo1_ = request.getParameter("tarjeta");          
          String campo2_ = request.getParameter("fecha");            
          String campo3_ = request.getParameter("concepto");
          float campo4_ = Float.parseFloat(request.getParameter("monto"));
          datos.put("elMovimiento", id_Movimien);
          datos.put("tarjetaSel", editCh);
          datos.put("idActualiza", modifica_);
          datos.put("cFecha", campo2_);
          datos.put("cConcepto", campo3_);
          datos.put("cMonto", campo4_);
          paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
          sesion.setPaginaSiguiente(paginaSig);   
          break;
        case 16:
            datos.put("fechaini", request.getParameter("fechai"));
            datos.put("fechafin", request.getParameter("fechaf"));
            datos.put("tipo", request.getParameter("tipo"));
            paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
            sesion.setPaginaSiguiente(paginaSig);   
            break;
        case 17:
            //imprimir movimiento (27)
            datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Empresa/edocuenta.jasper"));
            //parametros
            param = new HashMap();
            param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
            param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
            param.put("TIPO", new Integer(datos.get("tipo").toString()));
            Chequera tarjeta = (Chequera)datos.get("tarjetaSel");
            param.put("TARJETA", new Integer(tarjeta.getId()));
            SimpleDateFormat forfecha = new SimpleDateFormat("yyyy-MM-dd");
            String feci = forfecha.format((Date)datos.get("fechai"));
            String fecf = forfecha.format((Date)datos.get("fechaf"));            
            param.put("FECHAINI", feci);
            param.put("FECHAFIN", fecf);
            datos.put("parametros", param);
            //sesion.setPaginaSiguiente("/Inventario/Movimientos/gestionarmovimientos.jsp");
            break;
    }
    datos.put("paso", paso);
  }
  
    private void CargaNuevoMovimiento() {
        String sfecha = request.getParameter("fecha");
        String stipo = request.getParameter("tipo");
        Date fecha = new Date();
        SimpleDateFormat forma = new SimpleDateFormat("dd-MM-yyyy");    
            try {
                fecha = forma.parse(sfecha);
            } catch (ParseException ex) {
                //Logger.getLogger(GestionarChequeramovControl.class.getName()).log(Level.SEVERE, null, ex);
            }
        Movimientos mov = new Movimientos();
        if (datos.get("accion").toString().equals("editar")){
            mov = (Movimientos)datos.get("editarMovimiento");
        } else {
            Abono abono = new Abono();
            mov.setId_ab(new Abono());
        }
            //ingresamos los datos al objeto Abono
            mov.getId_ab().setBanco("Santander");
            mov.getId_ab().setTarjeta("No aplica");
            mov.getId_ab().setComprobante(new String(request.getParameter("comprueba")));
            mov.getId_ab().setCantidad(Float.parseFloat(request.getParameter("abono").replace(",", "")));
        try {
            mov.getId_ab().setConcepto(new String(request.getParameter("concepto").getBytes("ISO-8859-1"), "UTF-8"));
            mov.setReferencia(new String(request.getParameter("referencia").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarChequeramovControl.class.getName()).log(Level.SEVERE, null, ex);
        }
            mov.getId_ab().setChe(Integer.parseInt(request.getParameter("nt")));
            mov.getId_ab().setTipo(Integer.parseInt(stipo));

        mov.setId_ca(new Cargo());
        mov.setId_ch(new Chequera());
        mov.setFecha(fecha);

        mov.getId_ca().setId(1);
        mov.getId_ch().setId(Integer.parseInt(request.getParameter("nt")));
        mov.setTipo(Integer.parseInt(stipo));
        datos.put("nuevoMov", mov); 
        //System.out.println("Se ha llegado hasta CargaNuevoMovimiento del controlador");
    } 
  private void CargaNuevaChequera() {
    Chequera tarjeta = new Chequera();
    //Sucursal suc = new Sucursal();
    //tarjeta.setAlmacen(Integer.parseInt(request.getParameter("sucursal")));
    // tarjeta.setResponsable(Integer.parseInt(request.getParameter("adminTarjeta")));
    tarjeta.setResponsable(new Usuario());
    tarjeta.setUstitular(new Usuario());
    tarjeta.setAlmacen(new Sucursal());
    if (datos.get("accion").toString().equals("editar")){
        tarjeta = (Chequera)datos.get("tarjetaSel");
        if (tarjeta.getUstitular()==null)
            tarjeta.setUstitular(new Usuario());
    }
    tarjeta.getResponsable().setIdusuario(Integer.parseInt(request.getParameter("adminTarjeta")));
    tarjeta.getUstitular().setIdusuario((Integer.parseInt(request.getParameter("ustitular"))));
    tarjeta.getAlmacen().setId(Integer.parseInt(request.getParameter("sucursal")));
        try {
            tarjeta.setTitular(new String(request.getParameter("titular").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarChequeramovControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    tarjeta.setCuenta(new String(request.getParameter("cuenta")));
    tarjeta.setClabe(new String(request.getParameter("clabe")));
    tarjeta.setSaldo(0);
    datos.put("nuevaChequera", tarjeta);
  }
  
    private void CargaNuevoCargo(){
        Chequera tar = (Chequera)datos.get("tarjetaSel");
        Date fecha = new Date();
        SimpleDateFormat forma = new SimpleDateFormat("dd-MM-yyyy");    
            try {
                fecha = forma.parse(request.getParameter("fecha"));
            } catch (ParseException ex) {
                //Logger.getLogger(GestionarChequeramovControl.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        Movimientos mov = new Movimientos();
        if (datos.get("accion").toString().equals("editar")){
            mov = (Movimientos)datos.get("editarMovimiento");
        } else {
            Cargo gasto = new Cargo();
            mov.setId_ca(new Cargo());
        }
        
        try {
            mov.getId_ca().setCantidad(Float.parseFloat(request.getParameter("cantidad").replace(",", "")));
            mov.getId_ca().setConcepto(new String(request.getParameter("concepto").getBytes("ISO-8859-1"), "UTF-8"));
            mov.getId_ca().setT_pago(Integer.parseInt(request.getParameter("tipoP")));
            mov.getId_ca().setProveedor(new String(request.getParameter("proveedor").getBytes("ISO-8859-1"), "UTF-8"));              
            mov.getId_ca().setComprobante("no aplica");
            mov.getId_ca().setRutaComprobante(request.getParameter("rutaArchivo"));
            mov.getId_ca().setChe(tar.getId());
            mov.setReferencia(new String(request.getParameter("referencia").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            //Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        mov.setId_ab(new Abono());
        mov.setId_ch(tar);
        mov.setFecha(fecha);
        mov.getId_ab().setId(1);
        mov.setTipo(Integer.parseInt(request.getParameter("tipoP")));
        
        //mov.getId_ch().setId(Integer.parseInt(request.getParameter("chequera")));
        datos.put("nuevoCargo", mov); 
    }
}
