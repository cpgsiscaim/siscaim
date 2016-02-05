/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;
/**
 *
 * @author roman
 */
import Generales.Sesion;
import Modelo.Daos.PersonaDao;
import Modelo.Daos.EmpleadoDao;
import Modelo.Daos.SucursalDao;
import Modelo.Daos.Catalogos.EdoCivilDao;
import Modelo.Daos.Catalogos.GpoSanguineoDao;
import Modelo.Daos.Catalogos.EstadoDao;
import Modelo.Daos.Catalogos.TituloDao;
import java.util.HashMap;
import Modelo.Entidades.*;


public class PersonaMod {
    
    public PersonaMod(){
        
    }
    
    public Sesion GestionarPersona(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0: PersonaDao perDao = new PersonaDao();
                    datos.put("lista", perDao.obtenerLista());
                break;
            case 1: 
                    //obtener lista de Edo. Civil                    
                    EdoCivilDao edocivil = new EdoCivilDao();
                    datos.put("civiles", edocivil.obtenerLista());
                    //obtener lista de Gpo. Sanguineo           
                    GpoSanguineoDao gposang = new GpoSanguineoDao();
                    datos.put("sanguineo", gposang.obtenerLista());
                    //obtener lista de estados
                    EstadoDao estDao = new EstadoDao();
                    datos.put("estados", estDao.obtenerListaPorPrioridad());
                    //obetener lista sucursales
                    SucursalDao sucDao = new SucursalDao();
                    datos.put("sucursales", sucDao.obtenerListaSuc());
                    //obetner lista titulos
                    TituloDao tituDao = new TituloDao();
                    datos.put("titulos", tituDao.obtenerListaActivos());
                break;
                case 2: // GuardarDatos                      
                      Persona personaLoad = (Persona) datos.get("personal");      
                      PersonaDao perSave = new PersonaDao();
                      perSave.guardar(personaLoad);
                      // empleado
                      Empleado empLoad = (Empleado) datos.get("empleadoper");
                      EmpleadoDao empSave = new EmpleadoDao();
                      empSave.guardar(empLoad);
                      sesion.setExito(true);
                      sesion.setMensaje("Los datos fueron guardados con éxito");
                      sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp");                
                break;
                
                }
        
        sesion.setDatos(datos);        
        return sesion;
        /*
        HashMap datos = sesion.getDatos();
        //obtener la lista de pedidos
        PersonaDao perDao = new PersonaDao();
        datos.put("lista", perDao.obtenerLista());
        sesion.setDatos(datos);
        return sesion;*/
    }   
}
