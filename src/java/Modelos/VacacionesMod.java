/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.QuincenaDao;
import Modelo.Daos.PlazaDao;
import Modelo.Daos.UtilDao;
import Modelo.Daos.VacacionesDao;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Empleado;
import Modelo.Entidades.Plaza;
import Modelo.Entidades.Vacaciones;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class VacacionesMod {
    private int grupos = 0;
    
    public VacacionesMod(){}
    
    public Sesion GestionarVacaciones(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 1:
                //nuevo registro de vacaciones
                datos = NuevaVacacion(datos);
                break;
            case 2:
                datos = GuardaVacaciones(datos);
                break;
            case 3:
                datos = BorrarVacaciones(datos);
                break;
            case 98:
                datos.remove("banvac");
                datos.remove("aniosanti");
                datos.remove("quincenas");
                datos.remove("vacaciones");
                datos.remove("anios");
                datos.remove("sueldodiario");
                break;
            case 99:
                datos.remove("empleado");
                datos.remove("listacompletavacs");
                datos.remove("vacacionesemp");
                datos.remove("anterioresvac");
                datos.remove("siguientesvac");
                datos.remove("inicialvac");
                datos.remove("finalvac");
                datos.remove("gruposvac");
                datos.remove("plaza");
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private HashMap NuevaVacacion(HashMap datos) {
        //obtener el número de días correspondiente según antiguedad del empleado
        Empleado emp = (Empleado)datos.get("empleado");
        UtilMod utmod = new UtilMod();
        UtilDao utdao = new UtilDao();
        Date hoy = utdao.hoy();
        int diasant = utmod.DiasEntreFechas(emp.getFecha(), hoy);
        int aniosant = diasant / 365;
        if (aniosant==0){
            datos.put("banvac", "0");
        } else if (aniosant>=1){
            VacacionesDao vacdao = new VacacionesDao();
            List<String> aniosanti = new ArrayList<String>();
            String aniosregistrados = "";
            for (int i=1; i <= aniosant; i++){
                Vacaciones vac = vacdao.obtenerVacacionesDeEmpleadoYAntiguedadPagadasPorPagarGozadas(emp.getNumempleado(), i);
                if (vac==null){
                    aniosanti.add(Integer.toString(i));
                } else {
                    if (aniosregistrados.equals(""))
                        aniosregistrados = Integer.toString(vac.getAnio());
                    else
                        aniosregistrados += ","+Integer.toString(vac.getAnio());
                }
            }
            if (aniosanti.isEmpty()){
                datos.put("banvac", "0");
            } else {
                datos.put("banvac", "1");
                datos.put("aniosanti", aniosanti);
                //obtener las quincenas
                QuincenaDao quindao = new QuincenaDao();
                List<Quincena> quins = quindao.obtenerLista();
                datos.put("quincenas", quins);
                datos.put("vacaciones", new Vacaciones());
                Calendar cal = Calendar.getInstance();
                cal.setTime(emp.getFecha());
                int anioalta = cal.get(Calendar.YEAR);
                List<String> anios = new ArrayList<String>();
                int anio = anioalta;
                for (int y=1; y <= aniosant; y++){
                    anio++;
                    if (!aniosregistrados.contains(Integer.toString(anio)))
                        anios.add(Integer.toString(anio));
                }
                datos.put("anios", anios);
                PlazaDao plzdao = new PlazaDao();
                Plaza plz = plzdao.obtenerUltimaPlazaDeEmpleado(emp.getNumempleado());
                float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                datos.put("sueldodiario", new Float(sueldodiario));
            }
        }
        
        return datos;
    }

    private HashMap GuardaVacaciones(HashMap datos) {
        Vacaciones vac = (Vacaciones)datos.get("vacaciones");
        int idquin = Integer.parseInt(datos.get("idquin").toString());
        QuincenaDao quindao = new QuincenaDao();
        Quincena quin = quindao.obtener(idquin);
        vac.setQuincena(quin);
        vac.setEmpleado((Empleado)datos.get("empleado"));
        vac.setEstatus(5);
        VacacionesDao vacdao = new VacacionesDao();
        vacdao.guardar(vac);
        datos = ObtenerVacacionesDeEmpleado(datos);
        return datos;
    }

    private HashMap ObtenerVacacionesDeEmpleado(HashMap datos) {
        Empleado emp = (Empleado)datos.get("empleado");
        VacacionesDao vacdao = new VacacionesDao();
        List<Vacaciones> vacs = vacdao.obtenerVacacionesDeEmpleado(emp.getNumempleado());
        datos.put("listacompletavacs", vacs);
        if (vacs.size()>grupos){
            datos.put("gruposvac", "1");
            datos.put("inicialvac", "1");
            datos = ObtenerGrupoVacs(datos);
        } else {
            datos.put("gruposvac", "0");
            datos.put("vacacionesemp", vacs);
        }
        return datos;
    }
    
    private HashMap ObtenerGrupoVacs(HashMap datos) {
        List<Vacaciones> docs = (List<Vacaciones>)datos.get("listacompletavacs");
        datos.put("anterioresvac", "0");
        int inicial = Integer.parseInt(datos.get("inicialvac").toString());
        if (inicial>1)
            datos.put("anterioresvac", "1");
        List<Vacaciones> grupo = new ArrayList<Vacaciones>();
        int fin = grupos +(inicial-1);
        datos.put("siguientesvac", "1");
        if (fin > docs.size()){
            fin = docs.size();
            datos.put("siguientesvac", "0");
        }
        datos.put("finalvac", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(docs.get(i));
        }
        datos.put("vacacionesemp", grupo);
        return datos;
    }

    private HashMap BorrarVacaciones(HashMap datos) {
        Vacaciones vacas = (Vacaciones)datos.get("vacaciones");
        VacacionesDao vacdao = new VacacionesDao();
        vacdao.eliminar(vacas);
        
        datos = ObtenerVacacionesDeEmpleado(datos);
        return datos;
    }
}
