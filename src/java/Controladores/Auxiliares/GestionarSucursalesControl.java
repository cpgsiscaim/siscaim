/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.Municipio;
import Modelo.Entidades.Catalogos.TipoMedio;
import Modelos.SucursalMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarSucursalesControl extends Action {
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
        SucursalMod sucmod = new SucursalMod();
        sesion = sucmod.GestionarSucursales(sesion);
        
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
            case 1:
                //ir a nueva sucursal
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2:
                //guardar la nueva sucursal
                CargaSucursalTemp();
                datos.put("empresa", sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa());
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3:
                //editar sucursal
                Sucursal editSuc = new Sucursal();
                editSuc.setId(Integer.parseInt(request.getParameter("idSuc")));
                datos.put("editarSuc", editSuc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 4:
                //guardar sucursal editada
                Sucursal edSuc = (Sucursal) datos.get("editarSuc");
                edSuc = CargaSucursalEditada(edSuc);
                datos.put("editarSuc", edSuc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 5: case 7:
                //baja de sucursal
                Sucursal suc = new Sucursal();
                suc.setId(Integer.parseInt(request.getParameter("idSuc")));
                if (Integer.parseInt(paso)==5)
                    datos.put("bajaSuc", suc);
                else
                    datos.put("altaSuc", suc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            /*case 50: case 51:
                //confirmar la baja de la sucursal | No confirma baja
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;*/
            case 6:
                //ver inactivas
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 10: case 12:
                //ir a nuevo medio | ir a editar medio
                CargaSucursalTemp();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                if (Integer.parseInt(paso)==12){
                    int idmedio = Integer.parseInt(request.getParameter("mediosSuc"));
                    Medio editar = new Medio();
                    editar.setId(idmedio);
                    datos.put("editarMedio", editar);
                }
                break;
            case 11: case 13:
                //guardar nuevo medio | guardar medio editado
                Medio med = new Medio();
                if (Integer.parseInt(paso)==13)
                    med = (Medio)datos.get("editarMedio");
                med.setTipo(new TipoMedio());
                med.getTipo().setIdtipomedio(Integer.parseInt(request.getParameter("tipomedio")));
                med.setMedio(request.getParameter("medio"));
                if (Integer.parseInt(paso)==11)
                    datos.put("nuevoMedio", med);
                else
                    datos.put("editarMedio", med);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 14:
                //borrar medio
                Medio borrar = new Medio();
                borrar.setId(Integer.parseInt(request.getParameter("mediosSuc")));
                datos.put("borrarMedio", borrar);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 20: case 22:
                //ir a nuevo contacto
                CargaSucursalTemp();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                if (Integer.parseInt(paso)==22){
                    int idcon = Integer.parseInt(request.getParameter("contactosSuc"));
                    Persona editCon = new Persona();
                    editCon.setIdpersona(idcon);
                    datos.put("editarCon", editCon);
                }
                break;
            case 21: case 23:
                //guardar nuevo contacto | guardar contacto editado
                Persona con = new Persona();
                if (Integer.parseInt(paso)==23)
                    con = (Persona)datos.get("editarCon");
                try {
                    con.setTitulo(new String(request.getParameter("tituloCon").getBytes("ISO-8859-1"), "UTF-8"));
                    con.setNombre(new String(request.getParameter("nombreCon").getBytes("ISO-8859-1"), "UTF-8"));
                    con.setPaterno(new String(request.getParameter("paternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    con.setMaterno(new String(request.getParameter("maternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    con.setCargo(new String(request.getParameter("cargoCon").getBytes("ISO-8859-1"), "UTF-8"));
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(GestionarSucursalesControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (Integer.parseInt(paso)==21)
                    datos.put("nuevoCon", con);
                else
                    datos.put("editarCon", con);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 24:
                //borrar contacto
                int idcon = Integer.parseInt(request.getParameter("contactosSuc"));
                Persona borrarCon = new Persona();
                borrarCon.setIdpersona(idcon);
                datos.put("borrarCon", borrarCon);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 96: case 97:
                //cancelar nuevo medio-contacto | cancelar inactivas
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 98:
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 99:
                //salir
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
        }
        datos.put("paso", paso);
    }
    
    private void CargaSucursalTemp(){
        try {
            Sucursal suc = new Sucursal();
            suc.setEmpresa(new Empresa());
            suc.setDatosfis(new DatosFiscales());
            //datos generales
            suc.getDatosfis().setRazonsocial(new String(request.getParameter("nombreSuc").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().setRfc(request.getParameter("rfcSuc"));
            suc.getDatosfis().setDireccion(new Direccion());
            suc.getDatosfis().setPersona(new Persona());
            suc.getDatosfis().getDireccion().setCalle(new String(request.getParameter("calleSuc").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getDireccion().setColonia(new String(request.getParameter("coloniaSuc").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getDireccion().setCp(Integer.parseInt(request.getParameter("cpSuc")!=""?request.getParameter("cpSuc"):"0"));
            int idmun = Integer.parseInt(request.getParameter("poblacionSuc"));
            int idedo = Integer.parseInt(request.getParameter("estadoSuc"));
            suc.getDatosfis().getDireccion().setPoblacion(new Municipio());
            suc.getDatosfis().getDireccion().getPoblacion().setEstado(new Estado());
            suc.getDatosfis().getDireccion().getPoblacion().setIdmunicipio(idmun);
            suc.getDatosfis().getDireccion().getPoblacion().getEstado().setIdestado(idedo);
            suc.getDatosfis().getPersona().setNombre(new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getPersona().setPaterno(new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getPersona().setMaterno(new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            suc.setRegistropatronal(new String(request.getParameter("registropatronal").getBytes("ISO-8859-1"), "UTF-8"));
            datos.put("sucTempo", suc);
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }        
    }

    private Sucursal CargaSucursalEditada(Sucursal suc){
        try {
            //datos generales
            suc.getDatosfis().setRazonsocial(new String(request.getParameter("nombreSuc").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().setRfc(request.getParameter("rfcSuc"));
            //suc.getDatosfis().setDireccion(new Direccion());
            //suc.getDatosfis().setPersona(new Persona());
            suc.getDatosfis().getDireccion().setCalle(new String(request.getParameter("calleSuc").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getDireccion().setColonia(new String(request.getParameter("coloniaSuc").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getDireccion().setCp(Integer.parseInt(request.getParameter("cpSuc")!=""?request.getParameter("cpSuc"):"0"));
            int idmun = Integer.parseInt(request.getParameter("poblacionSuc"));
            int idedo = Integer.parseInt(request.getParameter("estadoSuc"));
            suc.getDatosfis().getDireccion().setPoblacion(new Municipio());
            suc.getDatosfis().getDireccion().getPoblacion().setEstado(new Estado());
            suc.getDatosfis().getDireccion().getPoblacion().setIdmunicipio(idmun);
            suc.getDatosfis().getDireccion().getPoblacion().getEstado().setIdestado(idedo);
            suc.getDatosfis().getPersona().setNombre(new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getPersona().setPaterno(new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            suc.getDatosfis().getPersona().setMaterno(new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            suc.setRegistropatronal(new String(request.getParameter("registropatronal").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }        
        return suc;
    }
    
}
