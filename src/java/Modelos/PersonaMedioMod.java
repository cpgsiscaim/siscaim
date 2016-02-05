/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.TipoMedioDao;
import Modelo.Daos.MedioDao;
import Modelo.Daos.PersonaMedioDao;
import Modelo.Entidades.Empleado;
import Modelo.Entidades.Medio;
import Modelo.Entidades.PersonaMedio;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class PersonaMedioMod {
    
    public PersonaMedioMod(){
        
    }
    
    public Sesion GestionarMediosPersona(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                break;
            case 1: case 3:
                datos = CapturarMedio(datos);
                break;
            case 2: case 4:
                datos = GuardarMedio(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/Medios/nuevomedio.jsp");
                    datos.remove("error");
                }
                break;
            case 5:
                datos = BajaDeMedio(datos);
                break;
            case 6:
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                datos = ActivarDeMedio(datos);
                break;
            case 97:
                datos.remove("mediosinactivos");
                break;
            case 98:
                datos.remove("tiposmedios");
                datos.remove("pmedio");
                datos.remove("accion");
                break;
            case 99:
                //salir de gestionar medios de persona
                datos.remove("empleado");
                datos.remove("medios");
                break;
        }
        sesion.setDatos(datos);        
        return sesion;
    }

    private HashMap CapturarMedio(HashMap datos) {
        int paso = Integer.parseInt(datos.get("paso").toString());
        TipoMedioDao tmDao = new TipoMedioDao();
        datos.put("tiposmedios", tmDao.obtenerListaActivos());
        if (paso == 1){
            datos.put("accion", "nuevo");
        } else {
            datos.put("accion", "editar");
            datos = ObtenerMedioPer(datos);
        }
        return datos;
    }

    private HashMap ObtenerMedioPer(HashMap datos) {
        PersonaMedioDao pmDao = new PersonaMedioDao();
        PersonaMedio pmedio = (PersonaMedio)datos.get("pmedio");
        pmedio = pmDao.obtener(pmedio.getId());
        datos.put("pmedio", pmedio);
        return datos;
    }

    private HashMap GuardarMedio(HashMap datos) {
        PersonaMedio pmedio = (PersonaMedio)datos.get("pmedio");
        Empleado emp = (Empleado)datos.get("empleado");
        pmedio.setPersona(emp.getPersona());

        PersonaMedioDao pmDao = new PersonaMedioDao();
        //validar si el medio ya esta registrado
        PersonaMedio pmedx = pmDao.obtenerMedioPersonaPorMedio(pmedio.getMedio().getMedio(), pmedio.getPersona().getIdpersona());
        if (pmedx != null){
            datos.put("error", "El Medio ya está asignado al Empleado");
            return datos;
        }

        //validar el medio
        MedioDao medDao = new MedioDao();
        Medio medx = medDao.obtenerMedioPorValorYTipo(pmedio.getMedio().getMedio(), pmedio.getMedio().getTipo().getIdtipomedio());
        if (medx == null){
            //el medio no existe y se guarda
            medDao.guardar(pmedio.getMedio());
        } else {
            //el medio ya existe
            pmedio.setMedio(medx);
        }
        
        if (datos.get("accion").toString().equals("nuevo")){
            pmedio.setEstatus(1);
            pmDao.guardar(pmedio);
        } else {
            pmDao.actualizar(pmedio);
        }
        datos = ObtenerMediosDeEmpleado(datos);
        datos.remove("accion");
        datos.remove("pmedio");
        datos.remove("tiposmedios");
        return datos;
    }

    private HashMap ObtenerMediosDeEmpleado(HashMap datos) {
        Empleado emp = (Empleado)datos.get("empleado");
        PersonaMedioDao pmDao = new PersonaMedioDao();
        datos.put("medios", pmDao.obtenerActivosDePersona(emp.getPersona().getIdpersona()));
        return datos;
    }

    private HashMap BajaDeMedio(HashMap datos) {
        PersonaMedio pmedio = (PersonaMedio)datos.get("pmedio");
        PersonaMedioDao pmDao = new PersonaMedioDao();
        pmDao.actualizarEstatus(0, pmedio.getId());
        datos = ObtenerMediosDeEmpleado(datos);
        datos.remove("pmedio");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Empleado emp = (Empleado)datos.get("empleado");
        PersonaMedioDao pmDao = new PersonaMedioDao();
        datos.put("mediosinactivos", pmDao.obtenerInactivosDePersona(emp.getPersona().getIdpersona()));
        return datos;
    }

    private HashMap ActivarDeMedio(HashMap datos) {
        PersonaMedio pmedio = (PersonaMedio)datos.get("pmedio");
        PersonaMedioDao pmDao = new PersonaMedioDao();
        pmDao.actualizarEstatus(1, pmedio.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerMediosDeEmpleado(datos);
        datos.remove("pmedio");
        return datos;
    }
}
