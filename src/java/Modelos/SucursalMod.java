/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.EstadoDao;
import Modelo.Daos.Catalogos.TipoMedioDao;
import Modelo.Daos.EmpresaDao;
import Modelo.Daos.MedioDao;
import Modelo.Daos.PersonaDao;
import Modelo.Daos.SucursalDao;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.Municipio;
import Modelo.Entidades.Catalogos.TipoMedio;
import Modelo.Entidades.Empresa;
import Modelo.Entidades.Medio;
import Modelo.Entidades.Persona;
import Modelo.Entidades.Sucursal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class SucursalMod {
    
    public SucursalMod(){
        
    }
    
/*****************************************************************************************/
//GESTIONAR SUCURSALES

    public Sesion GestionarSucursales(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de sucursales que no sean la matriz
                datos.put("listado", ObtenerSucursales(sesion));
                break;
            case 1: case 3:
                //preparar catalogos nueva sucursal | editar sucursal
                datos.put("estados", ObtenerEstados());
                datos.put("IdNuevoMedio", Integer.toString(ObtenerIdNuevoMedio()));
                datos.put("IdNuevoCon", Integer.toString(ObtenerIdNuevoContacto()));
                if (paso == 1)
                    datos.put("accion", "nueva");
                else {
                    datos.put("accion", "editar");
                    datos.put("editarSuc", ObtenerSucursalAEditar(datos));
                }
                break;
            case 2:
                //guardar la nueva sucursal
                datos = GuardarNuevaSucursal(datos);
                break;
            case 4:
                //guarda sucursal editada
                datos = GuardarSucursalEditada(datos);                
                break;
            /*case 50:
                //prepara confirmacion
                datos = ConfirmarBaja(datos);
                break;*/
            case 5:
                //confirmar baja de sucursal
                datos = BajaDeSucursal(datos);
                break;
            /*case 51:
                //NO confirma baja de sucursal
                datos.remove("bajaSuc");
                datos.remove("datosConfirmar");
                break;*/
            case 6:
                //ver inactivas
                datos.put("inactivas", ObtenerSucursalesInactivas());
                break;
            case 7:
                //activar sucursal
                datos = ReactivarSucursal(datos);
                break;
            case 10: case 20:
                //ir a nuevo medio | ir a nuevo contacto
                Sucursal tempo = (Sucursal)datos.get("sucTempo");
                tempo.getDatosfis().getDireccion().getPoblacion().setEstado(ObtenerEstado((List<Estado>)datos.get("estados"),
                        tempo.getDatosfis().getDireccion().getPoblacion().getEstado().getIdestado()));
                tempo.getDatosfis().getDireccion().setPoblacion(ObtenerMunicipio(tempo.getDatosfis().getDireccion().getPoblacion().getEstado().getMunicipios(),
                        tempo.getDatosfis().getDireccion().getPoblacion().getIdmunicipio()));
                datos.put("sucTempo", tempo);
                if (paso==10){
                    datos.put("tiposmedios", ObtenerTiposDeMedios());
                    datos.put("pestaña", "2");
                }
                else
                    datos.put("pestaña", "3");
                break;
            case 11:
                //guardar nuevo medio
                Medio nvoMedio = (Medio)datos.get("nuevoMedio");
                //cargar el tipo de medio
                List<TipoMedio> tiposMedios = (List<TipoMedio>)datos.get("tiposmedios");
                for (int i=0; i < tiposMedios.size(); i++){
                    TipoMedio tipo = tiposMedios.get(i);
                    if (tipo.getIdtipomedio()==nvoMedio.getTipo().getIdtipomedio()){
                        nvoMedio.setTipo(tipo);
                        break;
                    }
                }
                int idNvoMedio = Integer.parseInt(datos.get("IdNuevoMedio").toString());
                nvoMedio.setId(idNvoMedio);
                idNvoMedio++;
                datos.put("IdNuevoMedio", Integer.toString(idNvoMedio));
                //agregar a la lista de medios nuevos
                List<Medio> mediosNuevos = new ArrayList<Medio>();
                if (datos.containsKey("mediosNuevos")){
                    mediosNuevos = (List<Medio>)datos.get("mediosNuevos");
                }
                mediosNuevos.add(nvoMedio);
                datos.put("mediosNuevos", mediosNuevos);
                break;
            case 12:
                //ir a editar medio
                Sucursal tempoE = (Sucursal)datos.get("sucTempo");
                tempoE.getDatosfis().getDireccion().getPoblacion().setEstado(ObtenerEstado((List<Estado>)datos.get("estados"),
                        tempoE.getDatosfis().getDireccion().getPoblacion().getEstado().getIdestado()));
                tempoE.getDatosfis().getDireccion().setPoblacion(ObtenerMunicipio(tempoE.getDatosfis().getDireccion().getPoblacion().getEstado().getMunicipios(),
                        tempoE.getDatosfis().getDireccion().getPoblacion().getIdmunicipio()));
                datos.put("sucTempo", tempoE);
                Medio editar = ObtenerMedioAEditar(datos);
                datos.put("editarMedio", editar);
                datos.put("tiposmedios", ObtenerTiposDeMedios());
                datos.put("pestaña", "2");                
                break;
            case 13:
                //guardar medio editado
                datos = GuardarMedioAEditar(datos);
                break;
            case 14:
                //borrar medio
                datos = BorrarMedio(datos);
                datos.put("pestaña", "2");
                break;
            case 21:
                //guardar nuevo contacto
                datos = GuardarNuevoContacto(datos);
                break;
            case 22:
                //ir a editar contacto
                Sucursal tempoEC = (Sucursal)datos.get("sucTempo");
                tempoEC.getDatosfis().getDireccion().getPoblacion().setEstado(ObtenerEstado((List<Estado>)datos.get("estados"),
                        tempoEC.getDatosfis().getDireccion().getPoblacion().getEstado().getIdestado()));
                tempoEC.getDatosfis().getDireccion().setPoblacion(ObtenerMunicipio(tempoEC.getDatosfis().getDireccion().getPoblacion().getEstado().getMunicipios(),
                        tempoEC.getDatosfis().getDireccion().getPoblacion().getIdmunicipio()));
                datos.put("sucTempo", tempoEC);                
                datos.put("editarCon", ObtenerContactoAEditar(datos));
                datos.put("pestaña", "3");
                break;
            case 23:
                //guardar medio editado
                datos = GuardarContactoEditado(datos);
                break;
            case 24:
                //borrar contacto
                datos = BorrarContacto(datos);
                datos.put("pestaña", "3");
                break;
            case 96:
                //cancelar inactivas
                datos.remove("inactivas");
                break;
            case 98:
                //cancelar nueva | editar sucursal
                datos.remove("sucTempo");
                datos.remove("editarSuc");
                datos.remove("mediosNuevos");
                datos.remove("mediosEditados");
                datos.remove("mediosBorrados");
                datos.remove("contactosNuevos");
                datos.remove("contactosEditados");
                datos.remove("contactosBorrados");
                datos.remove("IdNuevoMedio");
                datos.remove("IdNuevoCon");
                datos.remove("pestaña");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }
    
//METODOS DE GESTIONAR SUCURSALES SEGUN EL PASO

    public List<Sucursal> ObtenerSucursales(Sesion sesion){
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSuc();
    }
    
    public List<Estado> ObtenerEstados(){
        EstadoDao estDao = new EstadoDao();
        return estDao.obtenerListaPorPrioridad();        
    }
      
    public List<TipoMedio> ObtenerTiposDeMedios(){
        TipoMedioDao timDao = new TipoMedioDao();
        return timDao.obtenerListaActivos();
    }
    
    public int ObtenerIdNuevoMedio(){
        MedioDao medDao = new MedioDao();
        int max = medDao.obtenerMaxId();
        max+=100;
        return max;
    }
    
    public Medio ObtenerMedioAEditar(HashMap dat){
        Medio editar = (Medio) dat.get("editarMedio");
        boolean listo = false;
        //buscar en medios nuevos
        if (dat.containsKey("mediosNuevos")){
            List<Medio> nuevos = (List<Medio>)dat.get("mediosNuevos");
            for (int i=0; i < nuevos.size(); i++){
                Medio n = nuevos.get(i);
                if (n.getId()==editar.getId()){
                    editar = n;
                    listo = true;
                    break;
                }
            }
        }
        //si no esta buscar en medios editados
        if (!listo && dat.containsKey("mediosEditados")){
            List<Medio> editados = (List<Medio>)dat.get("mediosEditados");
            for (int i=0; i < editados.size();i++){
                Medio e = editados.get(i);
                if (e.getId()==editar.getId()){
                    editar = e;
                    listo = true;
                    break;
                }                
            }
        }
        //si no esta buscar en actuales
        if (!listo && dat.get("accion").toString().equals("editar")){
            Sucursal sucEdit = (Sucursal) dat.get("editarSuc");
            List<Medio> actuales = sucEdit.getMedios();
            for (int i=0; i < actuales.size();i++){
                Medio a = actuales.get(i);
                if (a.getId()==editar.getId()){
                    editar = a;
                    break;
                }                
            }
        }
        
        return editar;
    }
    
    public HashMap GuardarMedioAEditar(HashMap datos){
        Medio editar = (Medio)datos.get("editarMedio");
        //obtener el tipo de medio
        List<TipoMedio> tiposm = (List<TipoMedio>)datos.get("tiposmedios");
        for (int i=0; i < tiposm.size(); i++){
            TipoMedio tm = tiposm.get(i);
            if (tm.getIdtipomedio()==editar.getTipo().getIdtipomedio()){
                editar.setTipo(tm);
                break;
            }
        }
        //buscar en medios editados
        boolean listo = false;
        if (datos.containsKey("mediosEditados")){
            List<Medio> editados = (List<Medio>)datos.get("mediosEditados");
            for (int i=0; i < editados.size(); i++){
                Medio ed = editados.get(i);
                if (ed.getId()==editar.getId()){
                    editados.set(i, editar);
                    listo = true;
                    break;
                }
            }
        }
        //buscar en medios nuevos
        if (!listo && datos.containsKey("mediosNuevos")){
            List<Medio> nuevos = (List<Medio>)datos.get("mediosNuevos");
            for (int i=0; i < nuevos.size(); i++){
                Medio nu = nuevos.get(i);
                if (nu.getId()==editar.getId()){
                    nuevos.set(i, nu);
                    listo = true;
                    break;
                }
            }
        }
        //si no esta agregar a editados
        List<Medio> editados = new ArrayList<Medio>();
        if (datos.containsKey("mediosEditados"))
            editados = (List<Medio>)datos.get("mediosEditados");
        editados.add(editar);
        datos.put("mediosEditados", editados);
        
        return datos;
    }
    
    public HashMap BorrarMedio(HashMap datos){
        Medio borrar = (Medio)datos.get("borrarMedio");
        boolean listo = false;
        //buscar en medios nuevos
        if (datos.containsKey("mediosNuevos")){
            List<Medio> nuevos = (List<Medio>)datos.get("mediosNuevos");
            for (int i=0; i < nuevos.size(); i++){
                Medio n = nuevos.get(i);
                if (n.getId()==borrar.getId()){
                    nuevos.remove(i);
                    listo = true;
                    break;
                }
            }
        }
        List<Medio> borrados = new ArrayList<Medio>();
        if (datos.containsKey("mediosBorrados"))
            borrados = (List<Medio>)datos.get("mediosBorrados");
        //si no esta buscar en medios editados
        if (!listo && datos.containsKey("mediosEditados")){
            List<Medio> editados = (List<Medio>)datos.get("mediosEditados");
            for (int i=0; i < editados.size();i++){
                Medio e = editados.get(i);
                if (e.getId()==borrar.getId()){
                    editados.remove(i);
                    borrados.add(e);
                    listo = true;
                    break;
                }                
            }
        }
        //si no esta buscar en actuales
        if (!listo && datos.get("accion").toString().equals("editar")){
            Sucursal sucEdit = (Sucursal) datos.get("editarSuc");
            List<Medio> actuales = (List<Medio>)sucEdit.getMedios();
            for (int i=0; i < actuales.size();i++){
                Medio a = actuales.get(i);
                if (a.getId()==borrar.getId()){
                    borrados.add(a);
                    break;
                }                
            }
        }
        datos.put("mediosBorrados", borrados);
            
        return datos;
    }
    
    public int ObtenerIdNuevoContacto(){
        PersonaDao perDao = new PersonaDao();
        int max = perDao.obtenerMaxId();
        max+=100;
        return max;
    }
    
    public HashMap GuardarNuevoContacto(HashMap datos){
        Persona nvo = (Persona)datos.get("nuevoCon");
        int idNvoCon = Integer.parseInt(datos.get("IdNuevoCon").toString());
        nvo.setIdpersona(idNvoCon);
        idNvoCon++;
        datos.put("IdNuevoCon", Integer.toString(idNvoCon));
        List<Persona> nuevos = new ArrayList<Persona>();
        if (datos.containsKey("contactosNuevos"))
            nuevos = (List<Persona>)datos.get("contactosNuevos");
        nuevos.add(nvo);
        datos.put("contactosNuevos", nuevos);
        return datos;
    }
    
    public Persona ObtenerContactoAEditar(HashMap datos){
        Persona editCon = (Persona)datos.get("editarCon");
        boolean listo = false;
        //buscar en medios nuevos
        if (datos.containsKey("contactosNuevos")){
            List<Persona> nuevos = (List<Persona>)datos.get("contactosNuevos");
            for (int i=0; i < nuevos.size(); i++){
                Persona n = nuevos.get(i);
                if (n.getIdpersona()==editCon.getIdpersona()){
                    editCon=n;
                    listo = true;
                    break;
                }
            }
        }
        //si no esta buscar en editados
        if (!listo && datos.containsKey("contactosEditados")){
            List<Persona> editados = (List<Persona>)datos.get("contactosEditados");
            for (int i=0; i < editados.size(); i++){
                Persona e = editados.get(i);
                if (e.getIdpersona()==editCon.getIdpersona()){
                    editCon = e;
                    listo = true;
                    break;
                }
            }
        }
        //si no esta buscar en actuales
        if (!listo && datos.get("accion").toString().equals("editar")){
            Sucursal sucEdit = (Sucursal) datos.get("editarSuc");
            List<Persona> actuales = sucEdit.getContactos();
            for (int i=0; i < actuales.size(); i++){
                Persona a = actuales.get(i);
                if (a.getIdpersona()==editCon.getIdpersona()){
                    editCon = a;
                    break;
                }
            }
        }
        
        return editCon;
    }
    
    public HashMap GuardarContactoEditado(HashMap datos){
        Persona editCon = (Persona)datos.get("editarCon");
        boolean listo = false;
        //buscar en medios nuevos
        if (datos.containsKey("contactosNuevos")){
            List<Persona> nuevos = (List<Persona>)datos.get("contactosNuevos");
            for (int i=0; i < nuevos.size(); i++){
                Persona n = nuevos.get(i);
                if (n.getIdpersona()==editCon.getIdpersona()){
                    nuevos.set(i, editCon);
                    datos.put("contactosNuevos", nuevos);
                    listo = true;
                    break;
                }
            }
        }
        //si no esta buscar en editados
        if (!listo){
            List<Persona> editados = new ArrayList<Persona>();
            if (datos.containsKey("contactosEditados")){
                editados = (List<Persona>)datos.get("contactosEditados");
                for (int i=0; i < editados.size(); i++){
                    Persona e = editados.get(i);
                    if (e.getIdpersona()==editCon.getIdpersona()){
                        editados.set(i, editCon);
                        listo = true;
                        break;
                    }
                }
            }
            //si no esta agregar a contactos editados
            if (!listo)
                editados.add(editCon);
            datos.put("contactosEditados", editados);
        }
        return datos;
    }
    
    public HashMap BorrarContacto(HashMap datos){
        Persona borrar = (Persona)datos.get("borrarCon");
        boolean listo = false;
        //buscar en medios nuevos
        if (datos.containsKey("contactosNuevos")){
            List<Persona> nuevos = (List<Persona>)datos.get("contactosNuevos");
            for (int i=0; i < nuevos.size(); i++){
                Persona n = nuevos.get(i);
                if (n.getIdpersona()==borrar.getIdpersona()){
                    nuevos.remove(i);
                    datos.put("contactosNuevos", nuevos);
                    listo = true;
                    break;
                }
            }
        }
        List<Persona> borrados = new ArrayList<Persona>();
        if (datos.containsKey("contactosBorrados"))
            borrados = (List<Persona>)datos.get("contactosBorrados");
        //si no esta buscar en editados
        if (!listo && datos.containsKey("contactosEditados")){
            List<Persona> editados = (List<Persona>)datos.get("contactosEditados");
            for (int i=0; i < editados.size(); i++){
                Persona e = editados.get(i);
                if (e.getIdpersona()==borrar.getIdpersona()){
                    editados.remove(i);
                    borrados.add(e);
                    datos.put("contactosEditados", editados);
                    datos.put("contactosBorrados", borrados);
                    listo = true;
                    break;
                }
            }
        }
        //si no esta buscar en actuales
        if (!listo && datos.get("accion").toString().equals("editar")){
            Sucursal sucEdit = (Sucursal) datos.get("editarSuc");
            List<Persona> actuales = sucEdit.getContactos();
            for (int i=0; i < actuales.size(); i++){
                Persona a = actuales.get(i);
                if (a.getIdpersona()==borrar.getIdpersona()){
                    borrados.add(a);
                    datos.put("contactosBorrados", borrados);
                    break;
                }
            }
        }
        
        return datos;
    }
    
    public HashMap GuardarNuevaSucursal(HashMap datos){
        Sucursal nueva = (Sucursal)datos.get("sucTempo");
        //cargar estado y municipio
        nueva.getDatosfis().getDireccion().getPoblacion().setEstado(ObtenerEstado((List<Estado>)datos.get("estados"),
                nueva.getDatosfis().getDireccion().getPoblacion().getEstado().getIdestado()));
        nueva.getDatosfis().getDireccion().setPoblacion(ObtenerMunicipio(nueva.getDatosfis().getDireccion().getPoblacion().getEstado().getMunicipios(),
                nueva.getDatosfis().getDireccion().getPoblacion().getIdmunicipio()));
        //cargar lista de medios
        List<Medio> medios = ObtenerMediosAGuardar(datos);
        for (int i=0; i < medios.size(); i++){
            Medio m = medios.get(i);
            m.setId(0);
            nueva.addMedio(m);
        }
        //cargar lista de contactos
        List<Persona> contactos = ObtenerContactosAGuardar(datos);
        for (int i=0; i < contactos.size(); i++){
            Persona con = contactos.get(i);
            con.setIdpersona(0);
        }
        nueva.setContactos(contactos);
        //asignar constantes
        nueva.setId(0);
        nueva.setTipo(1);
        nueva.setEstatus(1);
        nueva.getDatosfis().setTipo("0");
        Empresa empresa = (Empresa)datos.get("empresa");
        nueva.setEmpresa(new Empresa());
        nueva.getEmpresa().setId(empresa.getId());
        empresa.addSucursal(nueva);
        SucursalDao sucDao = new SucursalDao();
        sucDao.guardar(nueva);
        datos.put("listado", sucDao.obtenerListaSuc());
        datos.remove("sucTempo");
        datos.remove("mediosNuevos");
        datos.remove("mediosEditados");
        datos.remove("mediosBorrados");
        datos.remove("contactosNuevos");
        datos.remove("contactosEditados");
        datos.remove("contactosBorrados");
        datos.remove("IdNuevoMedio");
        datos.remove("IdNuevoCon");
        datos.remove("pestaña");
        return datos;
    }
    
    public Estado ObtenerEstado(List<Estado> estados, int idEdo){
        Estado edo = new Estado();
        for (int i=0; i < estados.size(); i++){
            Estado e = estados.get(i);
            if (e.getIdestado()==idEdo){
                edo = e;
                break;
            }
        }
        return edo;
    }
    
    public Municipio ObtenerMunicipio(List<Municipio> municipios, int idMun){
        Municipio mun = new Municipio();
        for (int i=0; i < municipios.size(); i++){
            Municipio m = municipios.get(i);
            if (m.getIdmunicipio()==idMun){
                mun = m;
            }
        }
        return mun;
    }
    
    public List<Medio> ObtenerMediosAGuardar(HashMap datos){
        List<Medio> listaMedios = new ArrayList<Medio>();
        if (datos.get("accion").toString().equals("nueva")){
             listaMedios = (List<Medio>)datos.get("mediosNuevos");
        }
        else {
            Sucursal editSuc = (Sucursal)datos.get("editarSuc");
            List<Medio> actuales = editSuc.getMedios();
            List<Medio> editados = datos.containsKey("mediosEditados")?(List<Medio>)datos.get("mediosEditados"):new ArrayList<Medio>();
            List<Medio> borrados = datos.containsKey("mediosBorrados")?(List<Medio>)datos.get("mediosBorrados"):new ArrayList<Medio>();
            
            for (int a=0; a < actuales.size(); a++){
                Medio act = actuales.get(a);
                boolean esta = false;
                //checar en editados
                for (int e=0; e < editados.size(); e++){
                    Medio edt = editados.get(e);
                    if (edt.getId()==act.getId()){
                        listaMedios.add(edt);
                        esta = true;
                        break;
                    }
                }
                if (!esta){
                    //checar en borrados
                    for (int b=0; b < borrados.size(); b++){
                        Medio bo = borrados.get(b);
                        if (bo.getId()==act.getId()){
                            esta = true;
                            break;
                        }
                    }
                }
                
                if (!esta){
                    listaMedios.add(act);
                }
            }
            
            List<Medio> nuevos = datos.containsKey("mediosNuevos")?(List<Medio>)datos.get("mediosNuevos"):new ArrayList<Medio>();
            for (int n=0; n < nuevos.size(); n++){
                Medio nvo = nuevos.get(n);
                nvo.setId(0);
                listaMedios.add(nvo);
            }
            
        }
        
        return listaMedios;
    }
    
    public Sucursal ObtenerMediosAGuardarEdit(HashMap datos){
            Sucursal editSuc = (Sucursal)datos.get("editarSuc");
            //List<Medio> actuales = editSuc.getMedios();
            List<Medio> editados = datos.containsKey("mediosEditados")?(List<Medio>)datos.get("mediosEditados"):new ArrayList<Medio>();
            List<Medio> borrados = datos.containsKey("mediosBorrados")?(List<Medio>)datos.get("mediosBorrados"):new ArrayList<Medio>();
            
            for (int a=0; a < editSuc.getMedios().size(); a++){
                Medio act = editSuc.getMedios().get(a);
                boolean esta = false;
                //checar en editados
                for (int e=0; e < editados.size(); e++){
                    Medio edt = editados.get(e);
                    if (edt.getId()==act.getId()){
                        editSuc.getMedios().set(a, edt);
                        esta = true;
                        break;
                    }
                }
                if (!esta){
                    //checar en borrados
                    for (int b=0; b < borrados.size(); b++){
                        Medio bo = borrados.get(b);
                        if (bo.getId()==act.getId()){
                            editSuc.getMedios().remove(a);
                            esta = true;
                            break;
                        }
                    }
                }                
            }
            
            List<Medio> nuevos = datos.containsKey("mediosNuevos")?(List<Medio>)datos.get("mediosNuevos"):new ArrayList<Medio>();
            for (int n=0; n < nuevos.size(); n++){
                Medio nvo = nuevos.get(n);
                nvo.setId(0);
                editSuc.getMedios().add(nvo);
            }
        
        return editSuc;
    }

    public List<Persona> ObtenerContactosAGuardar(HashMap datos){
        List<Persona> contactos = new ArrayList<Persona>();
        if (datos.get("accion").toString().equals("nueva")){
            contactos = (List<Persona>)datos.get("contactosNuevos");
        }
        else {
            Sucursal editSuc = (Sucursal)datos.get("editarSuc");
            List<Persona> actuales = editSuc.getContactos();
            List<Persona> editados = datos.containsKey("contactosEditados")?(List<Persona>)datos.get("contactosEditados"):new ArrayList<Persona>();
            List<Persona> borrados = datos.containsKey("contactosBorrados")?(List<Persona>)datos.get("contactosBorrados"):new ArrayList<Persona>();
            
            for (int a=0; a < actuales.size(); a++){
                Persona act = actuales.get(a);
                boolean esta = false;
                //checar en editados
                for (int e=0; e < editados.size(); e++){
                    Persona edt = editados.get(e);
                    if (edt.getIdpersona()==act.getIdpersona()){
                        contactos.add(edt);
                        esta = true;
                        break;
                    }
                }
                if (!esta){
                    //checar en borrados
                    for (int b=0; b < borrados.size(); b++){
                        Persona bo = borrados.get(b);
                        if (bo.getIdpersona()==act.getIdpersona()){
                            esta = true;
                            break;
                        }
                    }
                }
                
                if (!esta){
                    contactos.add(act);
                }
            }
            
            List<Persona> nuevos = datos.containsKey("contactosNuevos")?(List<Persona>)datos.get("contactosNuevos"):new ArrayList<Persona>();
            for (int n=0; n < nuevos.size(); n++){
                Persona nvo = nuevos.get(n);
                nvo.setIdpersona(0);
                contactos.add(nvo);
            }
            
        }
        
        return contactos;
    }
    
    public Sucursal ObtenerSucursalAEditar(HashMap datos){
        Sucursal editSuc = (Sucursal) datos.get("editarSuc");
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtener(editSuc.getId());
    }

    public HashMap GuardarSucursalEditada(HashMap datos){
        Sucursal editada = (Sucursal)datos.get("editarSuc");
        //cargar estado y municipio
        editada.getDatosfis().getDireccion().getPoblacion().setEstado(ObtenerEstado((List<Estado>)datos.get("estados"),
                editada.getDatosfis().getDireccion().getPoblacion().getEstado().getIdestado()));
        editada.getDatosfis().getDireccion().setPoblacion(ObtenerMunicipio(editada.getDatosfis().getDireccion().getPoblacion().getEstado().getMunicipios(),
                editada.getDatosfis().getDireccion().getPoblacion().getIdmunicipio()));
        //cargar lista de medios
        editada = ObtenerMediosAGuardarEdit(datos);
        //cargar lista de contactos
        List<Persona> contactos = ObtenerContactosAGuardar(datos);
        editada.setContactos(contactos);
        
        //actualizar la sucursal
        SucursalDao sucDao = new SucursalDao();
        sucDao.actualizar(editada);
        datos.put("listado", sucDao.obtenerListaSuc());
        datos.remove("editarSuc");
        datos.remove(("sucTempo"));
        datos.remove("mediosNuevos");
        datos.remove("mediosEditados");
        datos.remove("mediosBorrados");
        datos.remove("contactosNuevos");
        datos.remove("contactosEditados");
        datos.remove("contactosBorrados");
        datos.remove("IdNuevoMedio");
        datos.remove("IdNuevoCon");
        datos.remove("pestaña");
        return datos;
    }
    
    public HashMap BajaDeSucursal(HashMap datos){
        Sucursal bajaSuc = (Sucursal)datos.get("bajaSuc");
        SucursalDao sucDao = new SucursalDao();
        sucDao.actualizarEstatus(0, bajaSuc.getId());
        datos.put("listado", sucDao.obtenerListaSuc());
        datos.remove("bajaSuc");
        //datos.remove("datosConfirmar");
        return datos;
    }
    
    public List<Sucursal> ObtenerSucursalesInactivas(){
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaInactivas();
    }
    
    public HashMap ReactivarSucursal(HashMap datos){
        Sucursal altaSuc = (Sucursal)datos.get("altaSuc");
        SucursalDao sucDao = new SucursalDao();
        sucDao.actualizarEstatus(1, altaSuc.getId());
        datos.put("inactivas", sucDao.obtenerListaInactivas());
        datos.put("listado", sucDao.obtenerListaSuc());
        return datos;
    }

    private HashMap ConfirmarBaja(HashMap datos) {
        HashMap datConfirmar = new HashMap();
        datConfirmar.put("mensaje", "¿Está seguro de dar de baja la Sucursal seleccionada?");
        datConfirmar.put("controlSi", "Gestionar/Sucursales");
        datConfirmar.put("controlNo", "Gestionar/Sucursales");
        datConfirmar.put("vistaSi", "/Empresa/GestionarSucursales/gestionarsucursales.jsp");
        datConfirmar.put("vistaNo", "/Empresa/GestionarSucursales/gestionarsucursales.jsp");
        datConfirmar.put("pasoSi", "50");
        datConfirmar.put("pasoNo", "51");
        datos.put("datosConfirmar", datConfirmar);
        return datos;
    }
    
/***********GESTIONAR SUCURSALES ***********************/
    public Sucursal ObtenerSuc(int suc){
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtener(suc);
    }    
}
