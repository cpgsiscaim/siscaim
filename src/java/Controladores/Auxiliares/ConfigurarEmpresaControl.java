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
import Modelos.EmpresaMod;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
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
public class ConfigurarEmpresaControl extends Action {

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
        EmpresaMod emprmod = new EmpresaMod();
        sesion = emprmod.ConfigurarEmpresa(sesion);
        
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
            case 1:
                //se cancelo y se regresa a la pantalla inicial de configurar empresa
                //con la ultima pestaña que estaba activa
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 2:
                //guardar cambios
                CargaEmpresaAGuardar();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 10: case 20:
                //obtener valores establecidos de la empresa
                CargaEmpresaTemp();
                //nuevo medio (10), nuevo contacto (11)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                if (Integer.parseInt(paso)==10)
                    datos.put("pestaña", "2");
                else if (Integer.parseInt(paso)==20)
                    datos.put("pestaña", "3");
                //obtener
                break;
            case 11:
                //obtener el nuevo medio
                Medio nuevoMedio = new Medio();
                nuevoMedio.setMedio(request.getParameter("medio"));
                int tipom = Integer.parseInt(request.getParameter("tipomedio"));
                nuevoMedio.setTipo(new TipoMedio());
                nuevoMedio.getTipo().setIdtipomedio(tipom);
                datos.put("nuevoMedio", nuevoMedio);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 12: case 14:
                //editar - borrar medio
                int idmedio = Integer.parseInt(request.getParameter("mediosEmpr"));
                Medio med = new Medio();
                med.setId(idmedio);
                datos.put("pestaña", "2");
                if (Integer.parseInt(paso)==12){
                    datos.put("editarMedio", med);
                    paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                }
                else {
                    datos.put("borrarMedio", med);
                    paginaSig = "/Empresa/ConfigurarEmpresa/configurarempresa.jsp";
                }
                
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 13:
                Medio edMed = (Medio)datos.get("editarMedio");
                edMed.setMedio(request.getParameter("medio"));
                int tmEdit = Integer.parseInt(request.getParameter("tipomedio"));
                edMed.setTipo(new TipoMedio());
                edMed.getTipo().setIdtipomedio(tmEdit);
                datos.put("editarMedio", edMed);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 21:
                //obtener el nuevo contacto
                Persona nuevoCon = new Persona();
                try {
                    nuevoCon.setTitulo(new String(request.getParameter("tituloCon").getBytes("ISO-8859-1"), "UTF-8"));
                    nuevoCon.setNombre(new String(request.getParameter("nombreCon").getBytes("ISO-8859-1"), "UTF-8"));
                    nuevoCon.setPaterno(new String(request.getParameter("paternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    nuevoCon.setMaterno(new String(request.getParameter("maternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    nuevoCon.setCargo(new String(request.getParameter("cargoCon").getBytes("ISO-8859-1"), "UTF-8"));
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                datos.put("nuevoContacto", nuevoCon);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 22: case 24:
                //editar - borrar medio
                int idcon = Integer.parseInt(request.getParameter("contactosEmpr"));
                Persona conEdit = new Persona();
                conEdit.setIdpersona(idcon);
                datos.put("pestaña", "3");
                if (Integer.parseInt(paso)==22){
                    datos.put("editarContacto", conEdit);
                    paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                }
                else {
                    datos.put("borrarContacto", conEdit);
                    paginaSig = "/Empresa/ConfigurarEmpresa/configurarempresa.jsp";
                }
                
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 23:
                Persona edCon = (Persona)datos.get("editarContacto");
                try {
                    edCon.setTitulo(new String(request.getParameter("tituloCon").getBytes("ISO-8859-1"), "UTF-8"));
                    edCon.setNombre(new String(request.getParameter("nombreCon").getBytes("ISO-8859-1"), "UTF-8"));
                    edCon.setPaterno(new String(request.getParameter("paternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    edCon.setMaterno(new String(request.getParameter("maternoCon").getBytes("ISO-8859-1"), "UTF-8"));
                    edCon.setCargo(new String(request.getParameter("cargoCon").getBytes("ISO-8859-1"), "UTF-8"));
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
                }
                datos.put("editarContacto", edCon);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 40:
                //nuevo logo
                datos.put("pestaña", "4");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 41:
                //nuevo logo
                datos.put("nuevoLogo", request.getParameter("logoNuevo"));
                datos.put("pestaña", "4");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 42:
                //borrar logo
                datos.remove("nuevoLogo");
                datos.put("pestaña", "4");
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 99:
                //cancelar proceso
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
        }
        datos.put("paso", paso);
    }
    
    private void CargaEmpresaAGuardar(){
        try {
            String accion = datos.get("accion").toString();
            Sucursal matriz = new Sucursal();
            if (accion.equals("guardar")){
                matriz.setTipo(0);
                matriz.setEstatus(1);
                DatosFiscales df = new DatosFiscales();
                df.setTipo("0");
                df.setRazonsocial("MATRIZ");
                df.setPersona(new Persona());
                df.setDireccion(new Direccion());
                matriz.setDatosfis(df);
                Empresa empr = new Empresa();
                empr.setClave("1");
                empr.setNosuc(3);
                empr.setSerie("1");
                matriz.setEmpresa(empr);
                empr.addSucursal(matriz);
            } else {
                matriz = (Sucursal) datos.get("matriz");
            }
            //new String(request.getParameter("comentario").getBytes("ISO-8859-1"), "UTF-8");
            matriz.getEmpresa().setNombre(new String(request.getParameter("nombreEmpr").getBytes("ISO-8859-1"), "UTF-8"));
            matriz.getDatosfis().setRfc(request.getParameter("rfcEmpr"));
            matriz.getDatosfis().getDireccion().setCalle(new String(request.getParameter("calleEmpr").getBytes("ISO-8859-1"), "UTF-8"));
            matriz.getDatosfis().getDireccion().setColonia(new String(request.getParameter("coloniaEmpr").getBytes("ISO-8859-1"), "UTF-8"));
            matriz.getDatosfis().getDireccion().setCp(Integer.parseInt(request.getParameter("cpEmpr")));
            int idedo = Integer.parseInt(request.getParameter("estadoEmpr"));
            int idmun = Integer.parseInt(request.getParameter("poblacionEmpr"));
            if (idedo==0 || idmun==0){
                matriz.getDatosfis().getDireccion().setPoblacion(null);
            }
            else{
                List<Estado> estados = (List<Estado>)datos.get("estados");
                for (int i=0; i < estados.size(); i++){
                    Estado edo = estados.get(i);
                    if (edo.getIdestado()==idedo){
                        List<Municipio> munis = edo.getMunicipios();
                        for (int j=0; j < munis.size(); j++){
                            Municipio mun = munis.get(j);
                            if (mun.getIdmunicipio()==idmun){
                                matriz.getDatosfis().getDireccion().setPoblacion(mun);
                                break;
                            }
                        }
                    }//if edo == idedo
                }//for i
            }//else idedo idmun = 0
            matriz.getDatosfis().getPersona().setNombre(new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8"));
            matriz.getDatosfis().getPersona().setPaterno(new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            matriz.getDatosfis().getPersona().setMaterno(new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            matriz.setRegistropatronal(new String(request.getParameter("registropatronal").getBytes("ISO-8859-1"), "UTF-8"));
            //medios
            if (datos.containsKey("mediosNuevos")){
                List<Medio> mediosNuevos = (List<Medio>)datos.get("mediosNuevos");
                for (int i=0; i < mediosNuevos.size(); i++){
                    Medio m = mediosNuevos.get(i);
                    m.setId(0);
                    matriz.addMedio(m);
                }
            }
            List<Medio> actuales = new ArrayList<Medio>();
            List<Medio> actMatriz = matriz.getMedios();
            for (int a=0; a < actMatriz.size(); a++){
                actuales.add(actMatriz.get(a));
            }
            if (datos.containsKey("mediosBorrados")){
                List<Medio> mediosBorrados = (List<Medio>)datos.get("mediosBorrados");
                for (int i=0; i < mediosBorrados.size(); i++){
                    Medio borrar = mediosBorrados.get(i);
                    for (int a=0; a < actuales.size(); a++){
                        Medio act = actuales.get(a);
                        if (act.getId()==borrar.getId()){
                            actuales.remove(a);
                            break;
                        }
                    }
                }
            }
            if (datos.containsKey("mediosEditados")){
                List<Medio> mediosEditados = (List<Medio>)datos.get("mediosEditados");
                for (int e=0; e < mediosEditados.size(); e++){
                    Medio medEdit = mediosEditados.get(e);
                    for (int a=0; a < actuales.size(); a++){
                        Medio medAct = actuales.get(a);
                        if (medAct.getId()==medEdit.getId()){
                            actuales.set(a, medEdit);
                        }
                    }
                }
            }
            //actualizar medios en matriz
            matriz.getMedios().clear();
            for (int a=0; a < actuales.size();a++){
                matriz.addMedio(actuales.get(a));
            }
            //contactos
            if (datos.containsKey("contactosNuevos")){
                List<Persona> contactosNuevos = (List<Persona>)datos.get("contactosNuevos");
                for (int i=0; i < contactosNuevos.size(); i++){
                    Persona con = contactosNuevos.get(i);
                    con.setIdpersona(0);
                    matriz.addContacto(con);
                }
            }
            List<Persona> actualesCon = new ArrayList<Persona>();
            List<Persona> actConMatriz = matriz.getContactos();
            for (int a=0; a < actConMatriz.size(); a++){
                actualesCon.add(actConMatriz.get(a));
            }
            if (datos.containsKey("contactosBorrados")){
                List<Persona> contactosBorrados = (List<Persona>)datos.get("contactosBorrados");
                for (int i=0; i < contactosBorrados.size(); i++){
                    Persona borrar = contactosBorrados.get(i);
                    for (int a=0; a < actualesCon.size(); a++){
                        Persona act = actualesCon.get(a);
                        if (act.getIdpersona()==borrar.getIdpersona()){
                            actualesCon.remove(a);
                            break;
                        }
                    }
                }
            }
            if (datos.containsKey("contactosEditados")){
                List<Persona> contactosEditados = (List<Persona>)datos.get("contactosEditados");
                for (int e=0; e < contactosEditados.size(); e++){
                    Persona conEdit = contactosEditados.get(e);
                    for (int a=0; a < actualesCon.size(); a++){
                        Persona conAct = actualesCon.get(a);
                        if (conAct.getIdpersona()==conEdit.getIdpersona()){
                            actualesCon.set(a, conEdit);
                        }
                    }
                }
            }
            //actualizar contactos en matriz
            matriz.getContactos().clear();
            for (int a=0; a < actualesCon.size();a++){
                matriz.addContacto(actualesCon.get(a));
            }
            //logo
            matriz.getEmpresa().setLogo(request.getParameter("logoEmpr"));
            datos.put("matriz", matriz);
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private void CargaEmpresaTemp(){
        try {
            Sucursal matrizNva = new Sucursal();
            matrizNva.setEmpresa(new Empresa());
            matrizNva.setDatosfis(new DatosFiscales());
            //datos generales
            matrizNva.getEmpresa().setNombre(new String(request.getParameter("nombreEmpr").getBytes("ISO-8859-1"), "UTF-8"));
            matrizNva.getDatosfis().setRfc(request.getParameter("rfcEmpr"));
            matrizNva.getDatosfis().setDireccion(new Direccion());
            matrizNva.getDatosfis().setPersona(new Persona());
            matrizNva.getDatosfis().getDireccion().setCalle(new String(request.getParameter("calleEmpr").getBytes("ISO-8859-1"), "UTF-8"));
            matrizNva.getDatosfis().getDireccion().setColonia(new String(request.getParameter("coloniaEmpr").getBytes("ISO-8859-1"), "UTF-8"));
            matrizNva.getDatosfis().getDireccion().setCp(Integer.parseInt(request.getParameter("cpEmpr")!=""?request.getParameter("cpEmpr"):"0"));
            int idmun = Integer.parseInt(request.getParameter("poblacionEmpr"));
            int idedo = Integer.parseInt(request.getParameter("estadoEmpr"));
            List<Estado> estados = (List<Estado>)datos.get("estados");
            List<Municipio> munis = new ArrayList<Municipio>();
            for (int i=0; i < estados.size(); i++){
                Estado edo = estados.get(i);
                if (edo.getIdestado()==idedo){
                    munis = edo.getMunicipios();
                    break;
                }
            }
            if (munis.isEmpty() || idmun==0){
                matrizNva.getDatosfis().getDireccion().setPoblacion(null);
            }
            else if (idmun!=0){
                for (int i=0; i < munis.size(); i++){
                    Municipio mun = munis.get(i);
                    if (mun.getIdmunicipio()==idmun){
                        matrizNva.getDatosfis().getDireccion().setPoblacion(mun);
                        break;
                    }
                }
            }
            matrizNva.getDatosfis().getPersona().setNombre(new String(request.getParameter("nombreRepr").getBytes("ISO-8859-1"), "UTF-8"));
            matrizNva.getDatosfis().getPersona().setPaterno(new String(request.getParameter("paternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            matrizNva.getDatosfis().getPersona().setMaterno(new String(request.getParameter("maternoRepr").getBytes("ISO-8859-1"), "UTF-8"));
            matrizNva.setRegistropatronal(new String(request.getParameter("registropatronal").getBytes("ISO-8859-1"), "UTF-8"));
            //medios y contacto
            Sucursal matriz = (Sucursal)datos.get("matriz");
            List<Medio> medios = matriz!=null?matriz.getMedios():new ArrayList<Medio>();
            for (int i=0; i < medios.size(); i++){
                matrizNva.addMedio(medios.get(i));
            }            
            matrizNva.setContactos(matriz!=null?matriz.getContactos():new ArrayList<Persona>());
            //logo
            matrizNva.getEmpresa().setLogo(request.getParameter("logoEmpr"));
            datos.put("matrizTemp", matrizNva);
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(ConfigurarEmpresaControl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
