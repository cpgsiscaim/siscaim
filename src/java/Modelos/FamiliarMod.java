/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.EstadoDao;
import Modelo.Daos.Catalogos.MunicipioDao;
import Modelo.Daos.Catalogos.TipoFamiliarDao;
import Modelo.Daos.FamiliarDao;
import Modelo.Entidades.Familiar;
import Modelo.Entidades.Empleado;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class FamiliarMod {
    public FamiliarMod(){
    }

    public Sesion GestionarFamiliares(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                break;
            case 1: case 3:
                //nuevo fam | editar
                datos = CapturarFamiliar(datos);
                break;
            case 2: case 4:
                //guardar familiar
                datos = GuardarFamiliar(datos);
                break;
            case 5:
                //baja de familiar
                datos = BajaDeFamiliar(datos);
                break;
            case 6:
                datos = VerInactivos(datos);
                break;
            case 7:
                datos = ActivarFamiliar(datos);
                break;
            case 97:
                datos.remove("inactivosfam");
                break;
            case 98:
                datos.remove("tiposfam");
                datos.remove("familiar");
                datos.remove("accion");
                break;
            case 99:
                datos.remove("familiares");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap CapturarFamiliar(HashMap datos) {
        TipoFamiliarDao tfamDao = new TipoFamiliarDao();
        datos.put("tiposfam", tfamDao.obtenerListaActivos());
        //obtener lista de estados
        EstadoDao estDao = new EstadoDao();
        datos.put("estados", estDao.obtenerListaPorPrioridad());
        int paso = Integer.parseInt(datos.get("paso").toString());
        if (paso == 1)
            datos.put("accion", "nuevo");
        else {
            datos.put("accion", "editar");
            datos = ObtenerFamiliar(datos);
        }
        return datos;
    }

    private HashMap ObtenerFamiliar(HashMap datos) {
        Familiar fam = (Familiar)datos.get("familiar");
        FamiliarDao famDao = new FamiliarDao();
        fam = famDao.obtener(fam.getId());
        datos.put("familiar", fam);
        return datos;
    }

    private HashMap GuardarFamiliar(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        Familiar fam = (Familiar)datos.get("familiar");
        MunicipioDao munDao = new MunicipioDao();
        if (fam.getPersona().getDireccion().getPoblacion()!=null)
            fam.getPersona().getDireccion().setPoblacion(munDao.obtener(fam.getPersona().getDireccion().getPoblacion().getIdmunicipio()));
        FamiliarDao famDao = new FamiliarDao();
        if (datos.get("accion").toString().equals("nuevo")){
            fam.setEmpleado(empl);
            fam.setEstatus(1);
            famDao.guardar(fam);
        } else {
            famDao.actualizar(fam);
        }
        datos = ObtenerFamiliaresDeEmpleado(datos);
        datos.remove("accion");
        datos.remove("familiar");
        datos.remove("tiposfam");
        datos.remove("estados");
        return datos;
    }

    private HashMap ObtenerFamiliaresDeEmpleado(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        FamiliarDao famDao = new FamiliarDao();
        datos.put("familiares", famDao.obtenerActivosDeEmpleado(empl.getNumempleado()));
        return datos;
    }

    private HashMap BajaDeFamiliar(HashMap datos) {
        Familiar fam = (Familiar)datos.get("familiar");
        FamiliarDao famDao = new FamiliarDao();
        famDao.actualizarEstatus(0, fam.getId());
        datos = ObtenerFamiliaresDeEmpleado(datos);
        datos.remove("familiar");
        return datos;
    }

    private HashMap VerInactivos(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        FamiliarDao famDao = new FamiliarDao();
        datos.put("inactivosfam", famDao.obtenerInactivosDeEmpleado(empl.getNumempleado()));
        return datos;
    }

    private HashMap ActivarFamiliar(HashMap datos) {
        Familiar fam = (Familiar)datos.get("familiar");
        FamiliarDao famDao = new FamiliarDao();
        famDao.actualizarEstatus(1, fam.getId());
        datos = ObtenerFamiliaresDeEmpleado(datos);
        datos = VerInactivos(datos);
        return datos;
    }

}
