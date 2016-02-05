/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Unidad;
import Modelo.Entidades.UnidadProducto;
import Modelos.UnidadProductoMod;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarUnidadesProductoControl extends Action{
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
        UnidadProductoMod upMod = new UnidadProductoMod();
        sesion = upMod.GestionarUnidadesDeProductos(sesion);

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
            /*case 0:
                //paso inicial: obtener la vista de los parametros
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;*/
            case 1: case 6: case 97: case 98: case 99:
                //ir a nuevo unidad de salida (1) || ir a inactivos (6)
                //cancelar inactivos (97) || cancelar nuevo producto(98)
                //salir de gestionar unidades de salida(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar unidad de salida nueva (2) | editada (4)
                CargarUnidadProducto();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7:
                //ir a editar unidad de salida (3) || baja de unidad de salida(5) || activar unidad de salida (7)
                UnidadProducto up = new UnidadProducto();
                up.setId(Integer.parseInt(request.getParameter("idUp")));
                datos.put("uniprod", up);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            /*case 9:
                //aplicar filtros
                CargaFiltros();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;*/
                
        }
        datos.put("paso", paso);
    }

    private void CargarUnidadProducto() {
        UnidadProducto up = new UnidadProducto();
        up.setUnidad(new Unidad());
        if (datos.get("accion").toString().equals("editar"))
            up = (UnidadProducto)datos.get("uniprod");
        up.getUnidad().setId(Integer.parseInt(request.getParameter("unidad")));
        up.setValor(Float.parseFloat(request.getParameter("valor")));
        datos.put("uniprod", up);
    }


}
