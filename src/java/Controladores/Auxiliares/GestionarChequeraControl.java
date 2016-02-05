package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Chequera;
import Modelo.Entidades.Cargo;
import Modelo.Entidades.Abono;
import Modelo.Entidades.Sucursal;
import Modelo.Entidades.Movimientos;
import Modelos.ChequeraMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
/* @author germain */

public class GestionarChequeraControl extends Action {
  private Sesion sesion = new Sesion();
  private HashMap datos = new HashMap();
  private String paso = "0";
    
    @Override
  public void run() throws ServletException, IOException  {
      System.err.println("Entro al controlador GestionarChequeraControl.java");
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
    ChequeraMod chemod = new ChequeraMod();
    sesion = chemod.GestionarChequeras(sesion);
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
    switch (Integer.parseInt(paso)){
            case   0:         //paso inicial: obtener la vista de los parametros
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.clear();
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case 1: //cargar movimientos de sucursal seleccionada 
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 98:
                //redirije a la pagina que guarda un nuevo movimiento                
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5:    //carga nuevo movimiento, el 5 es de la edicion
                CargaNuevoMovimiento();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4:
                //guardar almacen editado                
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                              
            case 6:
                //ir a inactivos
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                
            case 7:
                //activar 
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                
        }    
    datos.put("paso", paso);
  }
    
  private void CargaNuevoMovimiento() {      
    Movimientos movi = new Movimientos();
    movi.setId_ab(new Abono());
    movi.setId_ca(new Cargo());
    movi.setId_ch(new Chequera());
    if(paso.equals("2")) {      
      datos.put("nuevoMovimiento", movi);  // *s
      try {
        movi.getId_ca().setId(1);   // Agregamos el cargo de $ 0.00
        movi.getId_ch().setId(new Integer(request.getParameter("chequera")));   // Se agrega la chequera seleccionada 
        movi.getId_ab().setBanco(new String(request.getParameter("banco").getBytes("ISO-8859-1"),"UTF-8"));
        movi.getId_ab().setCantidad(new Integer(request.getParameter("abono")));
        movi.getId_ab().setComprobante(new String(request.getParameter("comprueba").getBytes("ISO-8859-1"),"UTF-8"));
        movi.getId_ab().setTarjeta(new String(request.getParameter("nt").getBytes("ISO-8859-1"),"UTF-8"));
        movi.getId_ab().setConcepto(new String(request.getParameter("concepto").getBytes("ISO-8859-1"),"UTF-8"));
        
        movi.setFecha(new Date());
        movi.setSaldo(0);
      }catch (UnsupportedEncodingException ex)  {
        Logger.getLogger(GestionarChequeraControl.class.getName()).log(Level.SEVERE, null, ex);
      }      
    }
    else
      datos.put("editarAbono",movi);
  }
  
  
}
