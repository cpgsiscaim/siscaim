/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Catalogos.Municipio;
import Modelo.Entidades.Catalogos.TipoFamiliar;
import Modelo.Entidades.Direccion;
import Modelo.Entidades.Empleado;
import Modelo.Entidades.Familiar;
import Modelo.Entidades.Persona;
import Modelos.FamiliarMod;
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
public class GestionarFamiliarControl extends Action{
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
        FamiliarMod famMod = new FamiliarMod();
        sesion = famMod.GestionarFamiliares(sesion);

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
                //ir a nuevo fam (1) || ir a inactivos (6) || cancelar inactivos (97) || cancelar nuevo fam(98) || salir de gestionar familiares(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar fam nuevo (2) | editada (4)
                CargarFamiliar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7:
                //ir a editar familiar (3) || baja de familiar(5) || activar familiar (7)
                Familiar fam = new Familiar();
                fam.setId(Integer.parseInt(request.getParameter("idFam")));
                datos.put("familiar", fam);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarFamiliar() {
        Familiar fam = new Familiar();
        fam.setTipofamiliar(new TipoFamiliar());
        fam.setEmpleado(new Empleado());
        fam.setPersona(new Persona());
        fam.getPersona().setDireccion(new Direccion());
        fam.getPersona().getDireccion().setPoblacion(new Municipio());
        if (datos.get("accion").toString().equals("editar"))
            fam = (Familiar)datos.get("familiar");
        
        fam.getTipofamiliar().setId(Integer.parseInt(request.getParameter("tipofam")));
        try {
            fam.getPersona().setNombre(new String(request.getParameter("nombre").getBytes("ISO-8859-1"), "UTF-8"));
            fam.getPersona().setPaterno(new String(request.getParameter("paterno").getBytes("ISO-8859-1"), "UTF-8"));
            fam.getPersona().setMaterno(new String(request.getParameter("materno").getBytes("ISO-8859-1"), "UTF-8"));
            
            fam.getPersona().getDireccion().setCalle(new String(request.getParameter("callenum").getBytes("ISO-8859-1"), "UTF-8"));
            fam.getPersona().getDireccion().setColonia(new String(request.getParameter("colonia").getBytes("ISO-8859-1"), "UTF-8"));
            fam.getPersona().getDireccion().setTelefono(new String(request.getParameter("telefono").getBytes("ISO-8859-1"), "UTF-8"));
            
            fam.setObservacion(new String(request.getParameter("observaciones").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarFamiliarControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        String scp = request.getParameter("codigop")!=""?request.getParameter("codigop"):"0";
        fam.getPersona().getDireccion().setCp(Integer.parseInt(scp));
        if (!request.getParameter("poblacion").equals(""))
            fam.getPersona().getDireccion().getPoblacion().setIdmunicipio(Integer.parseInt(request.getParameter("poblacion")));
        String fechaN = request.getParameter("fechaNac");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaNac = null;
        try {
            fechaNac = formatoDelTexto.parse(fechaN);
        } catch (ParseException ex) {
        }
        fam.getPersona().setFnaci(fechaNac);
        datos.put("familiar", fam);
    }
    
}
