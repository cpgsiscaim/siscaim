/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.CatNominaDao;
import Modelo.Daos.Catalogos.QuincenaDao;
import Modelo.Daos.Catalogos.TipoCambioPyDDao;
import Modelo.Daos.MovimientoExtraordinarioDao;
import Modelo.Daos.VacacionesDao;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.MovimientoExtraordinario;
import Modelo.Entidades.Plaza;
import Modelo.Entidades.Vacaciones;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class MovimientoExtraordinarioMod {
    public MovimientoExtraordinarioMod(){
    }

    public Sesion GestionarMovExtra(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 1:
                //cargar movs extras
                datos = ObtenerMovsExtras(datos);
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");                
                break;
            case 2: case 4:
                //ir a nuevo mov extra (2) || editar mov extra (4)
                datos = ObtenerCatalogos(datos);
                datos.put("accion", "nuevo");
                if (paso==4){
                    datos.put("accion", "editar");
                    datos = ObtenerMovExtra(datos);
                }
                break;
            case 3: case 5:
                //guardar nuevo mov extra (3) | mov extra editado(5)
                datos = GuardarMovExtra(datos);
                break;
            case 6:
                //baja de plaza
                datos = BajaDeMovExtra(datos);
                break;
            case 7:
                datos = ObtenerInactivos(datos);
                break;
            case 8:
                //activar plaza
                datos = ActivarMovExtra(datos);
                break;
            case 97:
                //cancelar inactivas
                datos.remove("meinactivos");
                datos.remove("meinactivosfijos");
                break;
            case 98:
                //cancelar nuevo mov extra
                datos.remove("accion");
                datos.remove("movextra");
                datos = QuitarCatalogos(datos);
                break;
            case 99:
                //salir de gestionar movs extras
                /*int irpagant = Integer.parseInt(datos.get("irpagant")!=null?datos.get("irpagant").toString():"0");
                if (irpagant==2){
                    sesion.setPaginaSiguiente("/Nomina/Nomina/detallenomina.jsp");
                    //sesion.setPaginaAnterior("");
                }*/
                datos.remove("movsextras");
                datos.remove("movsextrasfijos");
                datos.remove("origenmovext");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }
    
    private HashMap ObtenerMovsExtras(HashMap datos) {
        Quincena qact = (Quincena)datos.get("quincenasel");
        QuincenaDao quinDao = new QuincenaDao();
        qact = quinDao.obtener(qact.getId());
        datos.put("quincenasel", qact);
        int anio = Integer.parseInt(datos.get("aniosel").toString());
        Plaza plz = (Plaza)datos.get("plaza");
        if (qact.getId()!=0){
            MovimientoExtraordinarioDao mextDao = new MovimientoExtraordinarioDao();
            datos.put("movsextras", mextDao.obtenerListaActivosDePlazayQuincena(plz.getId(), qact.getId(), anio));
            datos.put("movsextrasfijos", mextDao.obtenerListaActivosFijosDePlaza(plz.getId()));
        }
        
        return datos;
    }

    private HashMap GuardarMovExtra(HashMap datos) {
        Plaza plzsel = (Plaza)datos.get("plaza");
        Quincena qact = (Quincena)datos.get("quincenasel");
        String anioact = datos.get("aniosel").toString();
        MovimientoExtraordinario movext = (MovimientoExtraordinario)datos.get("movext");
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
        if (datos.get("accion").toString().equals("nuevo")){
            movext.setPlaza(plzsel);
            movext.setQuincena(qact);
            movext.setAnio(Integer.parseInt(anioact));
            movext.setEstatus(1);
            movext.setPeriodo("");
            meDao.guardar(movext);
        } else
            meDao.actualizar(movext);
        datos = ObtenerMovsExtras(datos);
        datos.remove("accion");
        datos.remove("movext");
        datos = QuitarCatalogos(datos);
        return datos;
    }

    private HashMap ObtenerMovExtra(HashMap datos) {
        MovimientoExtraordinario movext = (MovimientoExtraordinario)datos.get("movext");
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
        movext = meDao.obtener(movext.getId());
        datos.put("movext", movext);
        return datos;
    }

    private HashMap BajaDeMovExtra(HashMap datos) {
        MovimientoExtraordinario mext = (MovimientoExtraordinario)datos.get("movext");
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
        meDao.actualizarEstatus(0, mext.getId());
        //Checar si el mov extra es de vacaciones o de prima
        /*if (mext.getPerded().getIdPeryded()==6 || mext.getPerded().getIdPeryded()==7){
            VacacionesDao vacdao = new VacacionesDao();
            List<Vacaciones> vacas = vacdao.obtenerVacacionesDeEmpleadoNoPagadas(mext.getPlaza().getEmpleado().getNumempleado());
            if (vacas!=null && !vacas.isEmpty()){
                for (int v=0; v < vacas.size(); v++){
                    Vacaciones vac = vacas.get(v);
                    if (vac.getNomina().getQuincena().getId()==mext.getQuincena().getId() &&
                            vac.getNomina().getAnio()==mext.getAnio()){
                        vac.setEstatus(0);
                        vacdao.actualizar(vac);
                    }
                }
            }
        }*/
        
        datos = ObtenerMovsExtras(datos);
        datos.remove("movext");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Quincena qact = (Quincena)datos.get("quincenasel");
        int anio = Integer.parseInt(datos.get("aniosel").toString());
        Plaza plz = (Plaza)datos.get("plaza");
        MovimientoExtraordinarioDao mextDao = new MovimientoExtraordinarioDao();
        datos.put("meinactivos", mextDao.obtenerListaInactivosDePlazayQuincena(plz.getId(), qact.getId(), anio));
        datos.put("meinactivosfijos", mextDao.obtenerListaInactivosFijosDePlaza(plz.getId()));
        
        return datos;
    }

    private HashMap ActivarMovExtra(HashMap datos) {
        MovimientoExtraordinario mext = (MovimientoExtraordinario)datos.get("movext");
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
        meDao.actualizarEstatus(1, mext.getId());
        datos = ObtenerMovsExtras(datos);
        datos = ObtenerInactivos(datos);
        datos.remove("movext");
        return datos;
    }

    private HashMap ObtenerCatalogos(HashMap datos) {
        int matriz = Integer.parseInt(datos.get("matriz").toString());
        CatNominaDao catDao = new CatNominaDao();
        if (matriz==1)
            datos.put("movimientos", catDao.obtenerListaPeryDed());
        else
            datos.put("movimientos", catDao.obtenerListaDed());
        datos.put("tiposnomina", catDao.obtenerListaTipoNomina());
        TipoCambioPyDDao tcpydDao = new TipoCambioPyDDao();
        datos.put("tiposcambios", tcpydDao.obtenerListaActivosGeneral());
        return datos;
    }

    private HashMap QuitarCatalogos(HashMap datos) {
        datos.remove("movimientos");
        datos.remove("tiposnomina");
        datos.remove("tiposcambios");
        return datos;
    }
}
