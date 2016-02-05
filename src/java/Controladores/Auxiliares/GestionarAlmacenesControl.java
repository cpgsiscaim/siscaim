/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Almacen;
import Modelo.Entidades.Sucursal;
import Modelos.AlmacenMod;
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
public class GestionarAlmacenesControl extends Action {
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
        AlmacenMod sucmod = new AlmacenMod();
        sesion = sucmod.GestionarAlmacenes(sesion);
        
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
                datos.clear();
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case 1: case 96: case 98: case 99:
                //ir a nuevo almacen (1) || cancelar nuevo|editar almacen (98) || salir de gestionar almacenes(99)
                //cancelar inactivos (96)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2:
                //guardar la nueva sucursal
                CargaNuevoAlmacen();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 8:
                //editar almacen(3) || gestionar ubicaciones (8)
                Almacen edAlma = new Almacen();
                edAlma.setId(Integer.parseInt(request.getParameter("idAlma")));
                datos.put("editarAlma", edAlma);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4:
                //guardar almacen editado
                CargaNuevoAlmacen();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                
            case 5:
                //baja de almacen
                Almacen bajaAlma = new Almacen();
                bajaAlma.setId(Integer.parseInt(request.getParameter("idAlma")));
                datos.put("bajaAlma", bajaAlma);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                
            case 6:
                //ir a inactivos
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                
            case 7:
                //activar almacen
                Almacen actAlma = new Almacen();
                actAlma.setId(Integer.parseInt(request.getParameter("idAlma")));
                datos.put("activarAlma", actAlma);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;                
        }
        datos.put("paso", paso);
    }

    private void CargaNuevoAlmacen() {
        Almacen nuevo = new Almacen();
        if (paso.equals("4"))
            nuevo = (Almacen) datos.get("editarAlma");
        try {
            nuevo.setDescripcion(new String(request.getParameter("nombreAlma").getBytes("ISO-8859-1"), "UTF-8"));
            nuevo.setSucursal(new Sucursal());
            nuevo.getSucursal().setId(Integer.parseInt(request.getParameter("sucursal")));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarAlmacenesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (paso.equals("2")){
            datos.put("nuevoAlmacen", nuevo);
            nuevo.setEstatus(1);
            nuevo.setId(0);            
        }
        else
            datos.put("editarAlma", nuevo);
    }
    
}
