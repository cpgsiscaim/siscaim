/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.EstadoDao;
import Modelo.Daos.Catalogos.TipoMedioDao;
import Modelo.Daos.Catalogos.TituloDao;
import Modelo.Daos.EmpresaDao;
import Modelo.Daos.MedioDao;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.Municipio;
import Modelo.Entidades.Catalogos.TipoMedio;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class EmpresaMod {
    
    public EmpresaMod(){
        
    }
    
    public Sesion ConfigurarEmpresa(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener los catalogos
                //Estados
                EstadoDao estDao = new EstadoDao();
                datos.put("estados", estDao.obtenerListaPorPrioridad());
                //obtener los datos actuales de la empresa
                Usuario usu = sesion.getUsuario();
                if (usu.getEmpleado().getPersona().getSucursal()!=null){
                    Empresa emp = usu.getEmpleado().getPersona().getSucursal().getEmpresa();
                    List<Sucursal> sucursales = emp.getSucursales();
                    for (int i=0; i < sucursales.size(); i++){
                        Sucursal suc = sucursales.get(i);
                        if (suc.getTipo()==0){
                            datos.put("matriz", suc);
                            break;
                        }
                    }
                }
                if (!datos.containsKey("matriz"))
                    datos.put("accion", "guardar");
                else
                    datos.put("accion", "actualizar");
                datos.put("idNuevoMedio","100");
                datos.put("idNuevoCon", "100");
                break;
            case 2:
                //guardar datos
                EmpresaDao empr = new EmpresaDao();
                Sucursal matriz = (Sucursal) datos.get("matriz");
                Empresa empresa = matriz.getEmpresa();
                if (datos.get("accion").toString().equals("guardar"))
                    empr.guardar(empresa);
                else
                    empr.actualizar(empresa);
                /*sesion.setExito(true);
                sesion.setMensaje("Los datos fueron guardados con éxito");*/
                //sesion.setPaginaSiguiente("/Empresa/ConfigurarEmpresa/configurarempresa.jsp");                
                break;
            case 10:
                //obtener los tipos de medios
                TipoMedioDao timDao = new TipoMedioDao();
                datos.put("tiposmedios", timDao.obtenerListaActivos());
                break;
            case 11:
                //agregar el nuevo medio
                Medio nuevo = (Medio)datos.get("nuevoMedio");
                List<TipoMedio> tiposMedios = (List<TipoMedio>)datos.get("tiposmedios");
                for (int i=0; i < tiposMedios.size(); i++){
                    TipoMedio tm = tiposMedios.get(i);
                    if (tm.getIdtipomedio()==nuevo.getTipo().getIdtipomedio()){
                        nuevo.setTipo(tm);
                        break;
                    }
                }
                int idMed = Integer.parseInt(datos.get("idNuevoMedio").toString());
                nuevo.setId(idMed);
                datos.put("idNuevoMedio", Integer.toString(idMed+1));
                //meterlo a la lista de mediosNuevos
                List<Medio> mediosNuevos = datos.get("mediosNuevos")!=null?(List<Medio>)datos.get("mediosNuevos"):new ArrayList<Medio>();
                mediosNuevos.add(nuevo);
                datos.put("mediosNuevos", mediosNuevos);                
                break;
            case 12:
                //obtener los tipos de medios
                TipoMedioDao tmDao = new TipoMedioDao();
                datos.put("tiposmedios", tmDao.obtenerListaActivos());
                //editar medio
                Medio editar = (Medio)datos.get("editarMedio");
                if (editar.getId()>=100){
                    //buscar en mediosNuevos
                    List<Medio> mnEdit = (List<Medio>)datos.get("mediosNuevos");
                    for (int i=0; i < mnEdit.size(); i++){
                        Medio med = mnEdit.get(i);
                        if (med.getId()==editar.getId()){
                            editar = med;
                            break;
                        }
                    }
                }
                else {
                    //buscar en los editados
                    boolean listo = false;
                    if (datos.containsKey("mediosEditados")){
                        List<Medio> editados = (List<Medio>)datos.get("mediosEditados");
                        for (int i=0; i < editados.size(); i++){
                            Medio ed = editados.get(i);
                            if (ed.getId()==editar.getId()){
                                editar = ed;
                                listo = true;
                                break;
                            }
                        }
                    }
                    //buscar en los actuales
                    if (!listo){
                        Sucursal msuc = (Sucursal)datos.get("matriz");
                        if (msuc.getMedios().size()>0){
                            List<Medio> medios = msuc.getMedios();
                            for (int i=0; i < medios.size(); i++){
                                Medio actual = medios.get(i);
                                if (actual.getId()==editar.getId()){
                                    editar = actual;
                                    break;
                                }
                            }
                        }
                    }
                }
                datos.put("editarMedio", editar);
                break;
            case 13:
                //agregar medio editado
                Medio edMed = (Medio) datos.get("editarMedio");
                //cargar el tipo de medio
                List<TipoMedio> tmEdit = (List<TipoMedio>)datos.get("tiposmedios");
                for (int i=0; i < tmEdit.size(); i++){
                    TipoMedio tm = tmEdit.get(i);
                    if (tm.getIdtipomedio()==edMed.getTipo().getIdtipomedio()){
                        edMed.setTipo(tm);
                        break;
                    }
                }
                //checar si es un medio nuevo
                if (edMed.getId()>=100){
                    List<Medio> nuevos = (List<Medio>)datos.get("mediosNuevos");
                    for (int i=0; i < nuevos.size(); i++){
                        Medio nvo = nuevos.get(i);
                        if (nvo.getId()==edMed.getId()){
                            nuevos.set(i, edMed);
                            datos.put("mediosNuevos", nuevos);
                            break;
                        }
                    }
                }
                else {
                    //checar si ya esta en medios editados
                    if (datos.containsKey("mediosEditados")){
                        boolean ok = false;
                        List<Medio> editados = (List<Medio>)datos.get("mediosEditados");
                        for (int i=0; i < editados.size(); i++){
                            Medio ed = editados.get(i);
                            if (ed.getId()==edMed.getId()){
                                editados.set(i, edMed);
                                datos.put("mediosEditados", editados);
                                ok = true;
                                break;
                            }
                        }
                        if (!ok){
                            editados.add(edMed);
                            datos.put("mediosEditados", editados);
                        }
                    }
                    else{
                        List<Medio> editados = new ArrayList<Medio>();
                        editados.add(edMed);
                        datos.put("mediosEditados", editados);
                    }
                }
                break;
            case 14:
                //borrar medio
                Medio borrar = (Medio)datos.get("borrarMedio");
                if (borrar.getId()>=100){
                    List<Medio> nuevos = (List<Medio>)datos.get("mediosNuevos");
                    for (int i=0; i < nuevos.size(); i++){
                        Medio nvo = nuevos.get(i);
                        if (nvo.getId()==borrar.getId()){
                            nuevos.remove(i);
                            datos.put("mediosNuevos", nuevos);
                            break;
                        }
                    }
                }
                else {
                    if (datos.containsKey("mediosEditados")){
                        List<Medio> editados = (List<Medio>)datos.get("mediosEditados");
                        for (int i=0; i < editados.size(); i++){
                            Medio edit = editados.get(i);
                            if (edit.getId()==borrar.getId()){
                                editados.remove(i);
                                datos.put("mediosEditados", editados);
                                break;
                            }
                        }
                    }
                    List<Medio> borrados = new ArrayList<Medio>();
                    if (datos.containsKey("mediosBorrados"))
                        borrados = (List<Medio>)datos.get("mediosBorrados");
                    borrados.add(borrar);
                    datos.put("mediosBorrados", borrados);
                }
                break;
            case 21:
                //agregar el nuevo contacto
                Persona conNvo = (Persona) datos.get("nuevoContacto");
                int idCon = Integer.parseInt(datos.get("idNuevoCon").toString());
                conNvo.setIdpersona(idCon);
                datos.put("idNuevoCon", Integer.toString(idCon+1));
                List<Persona> contactosNuevos = datos.get("contactosNuevos")!=null?(List<Persona>)datos.get("contactosNuevos"):new ArrayList<Persona>();
                contactosNuevos.add(conNvo);
                datos.put("contactosNuevos", contactosNuevos);
                break;
            case 22:
                //editar contacto
                Persona editarCon = (Persona)datos.get("editarContacto");
                if (editarCon.getIdpersona()>=100){
                    //buscar en mediosNuevos
                    List<Persona> conEdit = (List<Persona>)datos.get("contactosNuevos");
                    for (int i=0; i < conEdit.size(); i++){
                        Persona con = conEdit.get(i);
                        if (con.getIdpersona()==editarCon.getIdpersona()){
                            editarCon = con;
                            break;
                        }
                    }
                }
                else {
                    //buscar en los editados
                    boolean listo = false;
                    if (datos.containsKey("contactosEditados")){
                        List<Persona> editados = (List<Persona>)datos.get("contactosEditados");
                        for (int i=0; i < editados.size(); i++){
                            Persona ed = editados.get(i);
                            if (ed.getIdpersona()==editarCon.getIdpersona()){
                                editarCon = ed;
                                listo = true;
                                break;
                            }
                        }
                    }
                    //buscar en los actuales
                    if (!listo){
                        Sucursal msuc = (Sucursal)datos.get("matriz");
                        if (msuc.getContactos().size()>0){
                            List<Persona> conts = msuc.getContactos();
                            for (int i=0; i < conts.size(); i++){
                                Persona actual = conts.get(i);
                                if (actual.getIdpersona()==editarCon.getIdpersona()){
                                    editarCon = actual;
                                    break;
                                }
                            }
                        }
                    }
                }
                datos.put("editarContacto", editarCon);
                break;
            case 23:
                //agregar contacto editado
                Persona edCon = (Persona) datos.get("editarContacto");
                //checar si es un contacto nuevo
                if (edCon.getIdpersona()>=100){
                    List<Persona> nuevos = (List<Persona>)datos.get("contactosNuevos");
                    for (int i=0; i < nuevos.size(); i++){
                        Persona nvo = nuevos.get(i);
                        if (nvo.getIdpersona()==edCon.getIdpersona()){
                            nuevos.set(i, edCon);
                            datos.put("contactosNuevos", nuevos);
                            break;
                        }
                    }
                }
                else {
                    //checar si ya esta en contactos editados
                    if (datos.containsKey("contactosEditados")){
                        boolean ok = false;
                        List<Persona> editados = (List<Persona>)datos.get("contactosEditados");
                        for (int i=0; i < editados.size(); i++){
                            Persona ed = editados.get(i);
                            if (ed.getIdpersona()==edCon.getIdpersona()){
                                editados.set(i, edCon);
                                datos.put("contactosEditados", editados);
                                ok = true;
                                break;
                            }
                        }
                        if (!ok){
                            editados.add(edCon);
                            datos.put("contactosEditados", editados);
                        }
                    }
                    else{
                        List<Persona> editados = new ArrayList<Persona>();
                        editados.add(edCon);
                        datos.put("contactosEditados", editados);
                    }
                }
                break;
            case 24:
                //borrar contacto
                Persona borrarCon = (Persona)datos.get("borrarContacto");
                if (borrarCon.getIdpersona()>=100){
                    List<Persona> nuevos = (List<Persona>)datos.get("contactosNuevos");
                    for (int i=0; i < nuevos.size(); i++){
                        Persona nvo = nuevos.get(i);
                        if (nvo.getIdpersona()==borrarCon.getIdpersona()){
                            nuevos.remove(i);
                            datos.put("contactosNuevos", nuevos);
                            break;
                        }
                    }
                }
                else {
                    if (datos.containsKey("contactosEditados")){
                        List<Persona> editados = (List<Persona>)datos.get("contactosEditados");
                        for (int i=0; i < editados.size(); i++){
                            Persona edit = editados.get(i);
                            if (edit.getIdpersona()==borrarCon.getIdpersona()){
                                editados.remove(i);
                                datos.put("contactosEditados", editados);
                                break;
                            }
                        }
                    }
                    List<Persona> borrados = new ArrayList<Persona>();
                    if (datos.containsKey("contactosBorrados"))
                        borrados = (List<Persona>)datos.get("contactosBorrados");
                    borrados.add(borrarCon);
                    datos.put("contactosBorrados", borrados);
                }
                break;                
            case 99:
                //cancelar proceso
                datos = new HashMap();
                break;
        }
        
        sesion.setDatos(datos);
        
        return sesion;
    }    
}
