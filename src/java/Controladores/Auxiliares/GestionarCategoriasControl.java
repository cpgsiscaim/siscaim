/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Categoria;
import Modelos.CategoriaMod;
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
public class GestionarCategoriasControl extends Action{
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
        CategoriaMod catMod = new CategoriaMod();
        sesion = catMod.GestionarCategorias(sesion);
        
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
            case 1: case 6: case 97: case 98: case 99:
                // ir a nueva categoria(1) || Ir a inactivas(6) || Cancelar nueva | editar categoria (98) || salir de gestionar categorias(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2: case 4:
                //guardar categoria
                CargaCategoriaAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5: case 7: case 8:
                //ir a editar categoria(3) || baja de categoria (5) || activar categoria (7) || ir a subcategorias (8)
                Categoria cat = new Categoria();
                cat.setId(Integer.parseInt(request.getParameter("idCat")));
                datos.put("categoriaEditar", cat);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaCategoriaAGuardar() {
        Categoria cat = new Categoria();
        if (datos.get("accion").toString().equals("editar"))
            cat = (Categoria) datos.get("categoriaEditar");
        try {
            cat.setClave(new String(request.getParameter("clave").getBytes("ISO-8859-1"), "UTF-8"));
            cat.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarCategoriasControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        String fecha = request.getParameter("fechaAlta");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaAlta = null;
        try {
            fechaAlta = formatoDelTexto.parse(fecha);
        } catch (ParseException ex) {
        }        
        cat.setFechaAlta(fechaAlta);
        cat.setEstatus(1);
        if (datos.get("accion").toString().equals("nueva"))
            datos.put("categoriaNueva", cat);
        else
            datos.put("categoriaEditar", cat);
    }
    
}
