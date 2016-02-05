/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.BancoDao;
import Modelo.Daos.Catalogos.CatNominaDao;
import Modelo.Daos.Catalogos.CuentasTelecommDao;
import Modelo.Daos.Catalogos.QuincenaDao;
import Modelo.Daos.Catalogos.TipoCambioDao;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.CuentasTelecomm;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Catalogos.TipoNomina;
import java.io.*;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author TEMOC
 */
public class NominaMod {
    int grupos = 0;
    public NominaMod(){
    }

    public Sesion GestionarNominas(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //obtener año actual, quincenas, quincena activa y nomina
                datos = ObtenerQuincenaActiva(datos);
                //datos = ObtenerAnioActual(datos);
                //datos = ObtenerAnioAntiguo(datos);
                datos = ObtenerSucursales(datos);
                datos = ObtenerNominas(datos);
                datos = ValidarNuevaNomina(datos);
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                break;
            case 1:
                //ir a nueva nomina
                datos = ObtenerSucursalesSinNomina(datos);
                break;
            case 10:
                //nueva nomina
                //generar la nomina de la quincena activa y año actual de tipo normal
                datos = GenerarNominaNuevo(datos);
                //datos = GenerarNomina(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Nomina/Nomina/gestionarnominas.jsp");
                    datos.remove("error");
                }
                break;
            case 2: case 27:
                //editar nomina
                datos = ObtenerNomina(datos);
                break;
            case 3:
                //recalcular nomina
                datos = RecalcularNominaNuevo(datos);
                //datos = RecalcularNomina(datos);
                break;
            case 4:
                //cerrar la nomina
                datos = CerrarNomina(datos);
                break;
            case 5:
                //ir a generar formatos de pago
                datos = ObtenerSoloNomina(datos);
                //datos = ObtenerCuentasTelecomm(datos);
                datos = ObtenerBancos(datos);
                break;
            case 6:
                //cerrar la quincena
                datos = CerrarQuincena(datos);
                break;
            case 7: case 25: case 32: case 37: case 41:
                if (paso==32){
                    datos = PagarPlazasFormatosPago(datos);
                }
                datos = ImprimirReporte(datos);
                break;
            case 8: case 13: case 14: case 26: case 33: case 38: case 42:
                if (paso==33){
                    datos = PagarPlazasFormatosPago(datos);
                }
                datos = ImprimirXls(datos);
                break;
            case 9: //consultar nominas anteriores a la activa
                datos = IrAConsultarNominas(datos);
                break;
            case 11: //obtener quincenas de año, consultar nóminas históricas
                datos = ObtenerQuincenasDeAnioSel(datos);
                break;
            case 12://obtener nominas de año y quincena seleccionada, consultar nóminas históricas
                datos = ObtenerNominasDeAnioYQuinSel(datos);
                break;
            case 15:
                //gestionar nóminas de aguinaldos
                datos = IrANominasDeAguinaldos(datos);
                break;
            case 16:
                datos = ObtenerSucursalesSinNominaAguinaldos(datos);
                break;
            case 17:
                //generar nómina de aguinaldos
                datos = GenerarNominaAguinaldos(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Nomina/Nomina/Aguinaldos/nominasaguinaldos.jsp");
                    datos.remove("error");
                }                
                break;
            case 18: case 30:
                //editar nomina aguinaldos
                datos = ObtenerNominaAguinaldos(datos);
                break;
            case 19:
                //editar detalle de nomina de aguinaldos
                datos = ObtenerDetalleAEditarNominaAguinaldos(datos);
                break;
            case 20:
                //ir a movs extras
                datos = CargarMovsExtras(datos);
                break;
            case 21:
                //ir a movs extras
                datos = PagarPlaza(datos);
                break;
            case 22:
                //recalcular plaza
                datos = RecalcularPlazaNuevo(datos);
                //datos = RecalcularPlaza(datos);
                break;
            case 23:
                //baja de plaza
                datos = BajaDePlaza(datos);
                break;
            case 24:
                //quitar pago de plaza
                datos = QuitarPagoDePlaza(datos);
                break;
            case 28:
                //guardar detalle nomina aguinaldo editado
                datos = GuardarDetalleAguinaldoEditado(datos);
                break;
            case 29:
                //pagar aguinaldos
                datos = PagarAguinaldos(datos);
                break;
            case 31:
                //obtener listado formatos de pago
                datos = ObtenerDetalleFormatosPago(datos);
                break;
            case 34:
                //quitar pago de aguinaldo
                datos = QuitarPagoAguinaldo(datos);
                break;
            case 35:
                //eliminar detalle de nomina de aguinaldos
                datos = EliminarDetallesNominaAguinaldos(datos);
                break;
            case 36:
                datos = RecalcularNominaAguinaldos(datos);
                break;
            case 39:
                //formatos de pago aguinaldos
                datos = ObtenerSoloNominaAguinaldos(datos);
                datos = ObtenerBancos(datos);
                break;
            case 40:
                //obtener listado formatos de pago aguinaldos
                datos = ObtenerDetalleFormatosPagoAguinaldos(datos);
                break;
            case 43:
                //cerrar la nomina de aguinaldos
                datos = CerrarNominaAguinaldos(datos);
                break;
            case 44:
                //registrar vacaciones gozadas
                datos = RegistrarGozeVacaciones(datos);
                break;
            case 45:
                //guardar goce de vacaciones
                datos = GuardarGoceDeVacaciones(datos);
                break;
            case 46:
                //guardar goce de vacaciones
                datos = QuitarGoceDeVacaciones(datos);
                break;
            case 50:
                //ir al principio
                datos = CargarPrincipio(datos);
                break;
            case 51:
                //mostrar anteriores
                datos = CargarAnteriores(datos);
                break;
            case 52:
                //mostrar siguientes
                datos = CargarSiguientes(datos);
                break;
            case 53:
                //mostrar siguientes
                datos = CargarFinal(datos);
                break;
            case 60:
                //ir al principio
                datos = CargarPrincipioAgui(datos);
                break;
            case 61:
                //mostrar anteriores
                datos = CargarAnterioresAgui(datos);
                break;
            case 62:
                //mostrar siguientes
                datos = CargarSiguientesAgui(datos);
                break;
            case 63:
                //mostrar siguientes
                datos = CargarFinalAgui(datos);
                break;
            case 64:
                datos = GenerarDispersionPagosBanorte(datos);
                break;
            case 90:
                datos.remove("vacaciones");
                datos.remove("plaza");
                break;
            case 91:
                //cancelar editar detalle nomina aguinaldo
                datos.remove("detnomedit");
                datos.remove("varios");
                datos.remove("aguinaldo");
                break;
            case 92:
                //salir del detalle de nomina de aguinaldos
                datos.remove("detallenominaagui");
                datos.remove("nominaagui");
                datos.remove("estatus");
                datos.remove("bcotiza");
                datos.remove("criterios");
                datos.remove("detallenominafp");
                datos = IrANominasDeAguinaldos(datos);
                break;
            case 93:
                //cancelar nueva nómina de aguinaldos
                datos.remove("sucursalesdispagui");
                break;
            case 94:
                //salir de nomina de aguinaldos
                datos.remove("nominasagui");
                datos.remove("totalesnomagui");
                datos.remove("bannominaactagui");
                datos.remove("totalesgenagui");
                break;
            case 95:
                datos.remove("nominashis");
                datos.remove("anioshis");
                datos.remove("quinhis");
                datos.remove("totalesnomhis");
                datos.remove("aniohissel");
                datos.remove("quinhissel");
                break;
            case 96:
                datos.remove("sucursalesdisp");
                datos.remove("sucursalsel");
                break;
            case 97: case 98:
                //cancelar detalle nomina
                datos = ObtenerNominas(datos);
                datos.remove("detallenomina");
                datos.remove("nomina");
                datos.remove("estatus");
                datos.remove("bcotiza");
                datos.remove("criterios");
                datos.remove("detallenominafp");
                break;
            case 99:
                //salir de gestionar nominas
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }
    
    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }

    private HashMap ObtenerNominas(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        NominaDao nomDao = new NominaDao();
        DetalleNominaDao detnomDao = new DetalleNominaDao();
        List<Nomina> nominas = nomDao.obtenerListaActivasNormalesDeQuinYAnio(anioact, quinact.getId());
        datos.put("nominas", nominas);
        //checar si ya hay nómina generada en la quincena activa y año actual
        //para cada nomina obtener el total, total pagado, y por pagar
        //String nomactiva = "0";
        List<HashMap> totales = new ArrayList<HashMap>();
        HashMap totalesgen = new HashMap();
        float totnomgen = 0, totpaggen = 0, totporpaggen = 0;
        UtilMod utmod = new UtilMod();
        for (int i=0; i < nominas.size(); i++){
            Nomina nom = nominas.get(i);
            /*if (nom.getAnio()==anioact && nom.getQuincena().getId()==quinact.getId()){
                nomactiva = "1";
            }*/
            float totnomina = detnomDao.obtenerTotalDeNomina(nom.getId());
            float pagado = detnomDao.obtenerTotalPagadoDeNomina(nom.getId());
            float porpagar = totnomina - pagado;
            
            totnomgen+=totnomina;
            totpaggen+=pagado;
            totporpaggen+=porpagar;
            
            HashMap tots = new HashMap();
            tots.put("totalnomina", Float.toString((float)utmod.Redondear(totnomina,2)));
            tots.put("pagado", Float.toString((float)utmod.Redondear(pagado,2)));
            tots.put("porpagar", Float.toString((float)utmod.Redondear(porpagar,2)));
            totales.add(tots);
        }
        totalesgen.put("totnomgen", Float.toString(totnomgen));
        totalesgen.put("totpaggen", Float.toString(totpaggen));
        totalesgen.put("totporpaggen", Float.toString(totporpaggen));
        datos.put("totalesnom", totales);
        datos.put("totalesgen", totalesgen);
        //datos.put("bannominaact", nomactiva);
        return datos;
    }
    
    private HashMap CargarMovsExtras(HashMap datos) {
        datos.put("matriz", "1");
        //datos = ObtenerPlaza(datos);
        String varios = datos.get("varios").toString();
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        //PlazaDao plzdao = new PlazaDao();
        int i = Integer.parseInt(varios);
        HashMap detalle = listado.get(i);
        Plaza plz = (Plaza)detalle.get("plaza");
        
        /*Plaza plz = (Plaza)datos.get("plaza");
        plz = plzdao.obtener(plz.getId());*/
        datos.put("plaza", plz);
        //obtener quincenas
        QuincenaDao quinDao = new QuincenaDao();
        datos.put("quincenas", quinDao.obtenerLista());
        //obtener quincena actual
        Quincena quinact = quinDao.obtenerQuincenaActiva();//.obtenerQuincenaActual();
        datos.put("quincenaactual", quinact);
        datos.put("quincenasel", quinact);
        UtilDao uDao = new UtilDao();
        int anio = uDao.AñoActual();
        datos.put("anioactual", Integer.toString(anio));
        datos.put("aniosel", Integer.toString(anio));
        MovimientoExtraordinarioDao movextDao = new MovimientoExtraordinarioDao();
        datos.put("movsextras", movextDao.obtenerListaActivosDePlazayQuincena(plz.getId(), quinact.getId(), anio));
        datos.put("movsextrasfijos", movextDao.obtenerListaActivosFijosDePlaza(plz.getId()));
        datos.put("paso", "1");
        datos.put("origenmovext","/Nomina/Nomina/detallenomina.jsp");
        datos.remove("varios");
        return datos;
    }
    
    private HashMap ObtenerNomina(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        NominaDao nomDao = new NominaDao();
        nom = nomDao.obtener(nom.getId());
        datos.put("nomina", nom);
        //List<HashMap> detnomina = new ArrayList<HashMap>();
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        
        int pago = Integer.parseInt(datos.get("estatus")!=null?datos.get("estatus").toString():"0");
        int bcotiza = Integer.parseInt(datos.get("bcotiza")!=null?datos.get("bcotiza").toString():"-1");
        datos.put("estatus", Integer.toString(pago));
        datos.put("bcotiza", Integer.toString(bcotiza));
        //NUEVA ESTRUCTURA DEL DETALLE DE NOMINA
        List<HashMap> detallenomina = new ArrayList<HashMap>();
        List<Plaza> plazasdet = detnomdao.obtenerPlazasDeNomina(nom.getId());
        for (int p=0; p < plazasdet.size(); p++){
            Plaza plz = plazasdet.get(p);
            HashMap detalle = new HashMap();
            detalle.put("plaza", plz);
            detalle.put("vacaciones", "0");
            float percep = 0;
            float deduc = 0;
            //obtener detalle cotiza de la plaza
            List<DetalleNomina> detcotplz = detnomdao.obtenerDetallesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
            if (detcotplz!=null && !detcotplz.isEmpty()){
                detalle.put("cotiza", new Integer(1));
                String estatus = "POR PAGAR";
                int ipago = 0;
                for (int d=0; d < detcotplz.size(); d++){
                    DetalleNomina dn = detcotplz.get(d);
                        if (dn.getMovimiento().getPeroDed()==1)
                            percep+=dn.getMonto();
                        else
                            deduc+=dn.getMonto();
                        if (dn.getEstatus()==2){
                            estatus = "PAGADO";
                            ipago = 1;
                        }
                        if (dn.getMovimiento().getIdPeryded()==6 || dn.getMovimiento().getIdPeryded()==7){
                            detalle.put("vacaciones", "1");
                        }
                }
                detalle.put("percepciones", new Float(percep));
                detalle.put("deducciones", new Float(deduc));
                detalle.put("neto", new Float(percep-deduc));
                detalle.put("estatus", estatus);
                if (pago==ipago && (bcotiza==-1 || bcotiza==1)){
                    detallenomina.add(detalle);
                }
            }
            
            //obtener detalle no cotiza de la plaza
            detalle = new HashMap();
            detalle.put("plaza", plz);
            detalle.put("vacaciones", "0");
            percep = 0;
            deduc = 0;
            List<DetalleNomina> detnocotplz = detnomdao.obtenerDetallesDeNominaNoCotizaDePlaza(nom.getId(), plz.getId());
            if (detnocotplz!=null && !detnocotplz.isEmpty()){
                detalle.put("cotiza", new Integer(0));
                String estatus = "POR PAGAR";
                int ipago = 0;
                for (int d=0; d < detnocotplz.size(); d++){
                    DetalleNomina dn = detnocotplz.get(d);
                        if (dn.getMovimiento().getPeroDed()==1)
                            percep+=dn.getMonto();
                        else
                            deduc+=dn.getMonto();
                        if (dn.getEstatus()==2){
                            estatus = "PAGADO";
                            ipago = 1;
                        }
                        if (dn.getMovimiento().getIdPeryded()==6 || dn.getMovimiento().getIdPeryded()==7){
                            detalle.put("vacaciones", "1");
                        }
                }
                detalle.put("percepciones", new Float(percep));
                detalle.put("deducciones", new Float(deduc));
                detalle.put("neto", new Float(percep-deduc));
                detalle.put("estatus", estatus);
                if (pago==ipago && (bcotiza==-1 || bcotiza==0)){
                    detallenomina.add(detalle);
                }
            }
            
        }
        datos.put("listacompleta", detallenomina);
        if (detallenomina.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("detallenomina", detallenomina);
        }            
        //FIN DE LA NUEVA ESTRUCTURA DEL DETALLE DE NOMINA
        
        /*/obtener plazas
        int pago = Integer.parseInt(datos.get("estatus")!=null?datos.get("estatus").toString():"0");
        List<Plaza> plazas = null;
        if (pago==0)
            plazas = detnomdao.obtenerPlazasNoPagadasDeNomina(nom.getId()); //.obtenerPlazasDeNomina(nom.getId());
        else
            plazas = detnomdao.obtenerPlazasPagadasDeNomina(nom.getId());
        for (int i=0; i < plazas.size(); i++){
            Plaza pl = plazas.get(i);
            float totpercep = detnomdao.obtenerTotalPercepcionesDePlazaEnNomina(pl.getId(), nom.getId());
            float totdeduc = detnomdao.obtenerTotalDeduccionesDePlazaEnNomina(pl.getId(), nom.getId());
            float neto=totpercep-totdeduc;
            int estatus = detnomdao.obtenerEstatusDePlazaEnNomina(pl.getId(), nom.getId());
            HashMap fila = new HashMap();
            fila.put("totpercep", new Float(totpercep));
            fila.put("totdeduc", new Float(totdeduc));
            fila.put("neto", new Float(neto));
            fila.put("plaza", pl);
            if (estatus==1)
                fila.put("estatus", "POR PAGAR");
            else
                fila.put("estatus", "PAGADO");
            
            detnomina.add(fila);
        }
        datos.put("nomina", nom);
        
        datos.put("listacompleta", detnomina);
        if (detnomina.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("detallenomina", detnomina);
        }*/
        
        return datos;
    }
    
    private HashMap GenerarNomina(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalsel");
        SucursalDao sucdao = new SucursalDao();
        suc = sucdao.obtener(suc.getId());
        int anio = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        String finiquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        int niniquinant = 1;
        int mesant = quinact.getNummes();
        if (quinact.getInicio()==1){
            niniquinant = 16;
            mesant = quinact.getNummes()-1;
        }
        String finiquinant = Integer.toString(anio)+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
        
        List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(finiquin, ffinquin, suc.getId());
        if (plazas.isEmpty()){
            datos.put("error", "No hay plazas activas en la Sucursal seleccionada");
            return datos;
        }
        
        TipoNomina tiponom = new TipoNomina();
        tiponom.setIdTnomina(1);
        Nomina nom = new Nomina();
        nom.setAnio(anio);
        nom.setEstatus(1);
        nom.setSucursal(suc);
        UtilDao utdao = new UtilDao();
        nom.setFecha(utdao.hoy());
        nom.setQuincena(quinact);
        nom.setTiponomina(tiponom);
        NominaDao nomdao = new NominaDao();
        nomdao.guardar(nom);
        datos.put("nomina", nom);
        //generar el detalle de la nomina
        float totnomina = 0;
        //obtener las plazas activas
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        CatNominaDao cnomDao = new CatNominaDao();
        UtilMod utmod = new UtilMod();
        //List<HashMap> totsplaza = new ArrayList<HashMap>();
        
        //Definir el listado del detalle de nomina
        List<HashMap> detalle = new ArrayList<HashMap>();
        
        for (int i=0; i < plazas.size(); i++){
            float totpercep = 0;
            float totdeduc = 0;
            float neto = 0;
            Plaza plz = plazas.get(i);
            boolean aplica = false;
            //validar periodo de pago de la plaza
            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                //pago mensual
                int quinnumpago = 1;
                Calendar fechalta = Calendar.getInstance();
                fechalta.setTime(plz.getFechaalta());
                if (fechalta.get(Calendar.DAY_OF_MONTH)<=15){
                    quinnumpago = 2;
                }
                if (quinnumpago == quinact.getNumero()){
                    aplica = true;
                }
            } else {
                aplica = true;
            }
            
            if (aplica){
                HashMap detallenom = new HashMap();
                detallenom.put("plaza", plz);
                //genera detalle del salario de la plaza
                DetalleNomina detnom = new DetalleNomina();
                PeryDed mov = cnomDao.obtenerPeryDed(1);
                detnom.setEstatus(1);
                detnom.setExento(mov.getGraoExe());
                float sueldodiario = 0;
                
                //CONSIDERAR LAS FECHAS DE ALTA Y BAJA DEL IMSS DEL EMPLEADO
                    //definir las fechas inicial y final de la quincena
                    SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
                    Date iniquin = null, finquin = null, iniquinant = null;
                    try {
                        iniquin = ffecha.parse(finiquin);
                        finquin = ffecha.parse(ffinquin);
                        iniquinant = ffecha.parse(finiquinant);
                    } catch (ParseException ex) {
                        Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    //Obtener el historial imss del empleado de la plaza
                    HistorialIMSSDao hidao = new HistorialIMSSDao();
                    List<HistorialIMSS> hisimss = hidao.obtenerHistorialDeEmpleado(plz.getEmpleado().getNumempleado());
                    if (hisimss!=null && hisimss.size()>0){
                        HistorialIMSS hiemp = hisimss.get(0);
                        //Date altaimss = hiemp.getFechaalta();
                        if (hiemp.getFechabaja()==null){
                            //En este caso el empleado si esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechaalta().after(iniquinant))
                                    && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            if ((hiemp.getFechaalta().after(iniquin))
                                    && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin)) || mensual){
                                //el alta esta entre la quincena, calcular pago diferido
                                //calcular dias cotiza y dias no cotiza
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                long diascot = 1;
                                if (hiemp.getFechaalta().before(finquin))
                                    diascot = (( finquin.getTime() - hiemp.getFechaalta().getTime() )/MILLSECS_PER_DAY)+1;
                                long diasnocot = 15 - diascot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diasnocot = diasquin - diascot;
                                
                                if (mensual){
                                    diasnocot = 30 - diascot;
                                }
                                
                                //guardar detalle sí cotiza
                                detnom.setCotiza(1);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacioncotiza() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }
                                    
                                    //si el empleado no tiene sueldo no cotiza y tiene movs extras
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            if (detnom.getMovimiento().getPeroDed()==1)
                                                totpercep+=detnom.getMonto();
                                            else
                                                totdeduc+=detnom.getMonto();
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(totpercep-totdeduc));
                                    detallenom.put("cotiza", new Integer(1));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=(totpercep-totdeduc);                                    
                                }
                                
                                //guarda detalle no cotiza
                                detnom = new DetalleNomina();
                                detallenom = new HashMap();
                                detallenom.put("plaza", plz);
                                totpercep = 0;
                                totdeduc = 0;
                                detnom.setEstatus(1);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setCotiza(0);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacion() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }

                                    //genera detalle de los movs extras, usando el sueldo de no cotiza
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        if (detnom.getMovimiento().getPeroDed()==1)
                                            totpercep+=detnom.getMonto();
                                        else
                                            totdeduc+=detnom.getMonto();
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                    neto=totpercep-totdeduc;
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(neto));
                                    detallenom.put("cotiza", new Integer(0));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }
                            } else {
                                //calcular su pago normalmente
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                    //pago por dia
                                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                    if (diasquin!=15){
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                    } else {
                                        detnom.setMonto(plz.getSueldocotiza());
                                    }
                                } else
                                    detnom.setMonto(plz.getSueldocotiza());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(1);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    if (plz.getCompensacioncotiza() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }
                                    
                                    //si el sueldo no cotiza de la plaza es cero, checar los movs extra y ponerlos como sí cotiza
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            if (detnom.getMovimiento().getPeroDed()==1)
                                                totpercep+=detnom.getMonto();
                                            else
                                                totdeduc+=detnom.getMonto();
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }                                     
                                    
                                    neto=totpercep-totdeduc;
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(neto));
                                    detallenom.put("cotiza", new Integer(1));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }
                                
                                if (plz.getSueldo()>0){
                                    //guarda el detalle de no cotiza
                                    mov = cnomDao.obtenerPeryDed(1);
                                    detnom = new DetalleNomina();
                                    detallenom = new HashMap();
                                    detallenom.put("plaza", plz);
                                    totpercep = 0;
                                    totdeduc = 0;
                                    detnom.setEstatus(1);
                                    detnom.setExento(mov.getGraoExe());
                                    detnom.setCotiza(0);
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                        //pago por dia
                                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                        if (diasquin!=15){
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                        } else {
                                            detnom.setMonto(plz.getSueldo());
                                        }
                                    } else
                                        detnom.setMonto(plz.getSueldo());
                                    detnom.setMovimiento(mov);
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }
                                    
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        if (detnom.getMovimiento().getPeroDed()==1)
                                            totpercep+=detnom.getMonto();
                                        else
                                            totdeduc+=detnom.getMonto();
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                
                                    neto=totpercep-totdeduc;
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(neto));
                                    detallenom.put("cotiza", new Integer(0));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }
                            }
                        } else {
                            //En este caso el empleado no esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechabaja().after(iniquinant))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            
                            if ((hiemp.getFechabaja().after(iniquin))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin)) || mensual){
                                //la baja esta entre la quincena, calcular pago diferido
                                //calcular dias cotiza y dias no cotiza
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                long diasnocot = 1;
                                if (hiemp.getFechabaja().before(finquin))
                                    diasnocot = ((finquin.getTime() - hiemp.getFechabaja().getTime())/MILLSECS_PER_DAY)+1;
                                long diascot = 15 - diasnocot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diascot = diasquin - diasnocot;
                                if (mensual)
                                    diascot = 30 - diasnocot;
                                
                                //guardar detalle sí cotiza
                                detnom.setCotiza(1);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacioncotiza() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }
                                    
                                    //si el sueldo no cotiza de la plaza es cero, checar los movs extra y ponerlos como sí cotiza
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            if (detnom.getMovimiento().getPeroDed()==1)
                                                totpercep+=detnom.getMonto();
                                            else
                                                totdeduc+=detnom.getMonto();
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }
                                    
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(totpercep-totdeduc));
                                    detallenom.put("cotiza", new Integer(1));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }
                                //guarda detalle no cotiza
                                totpercep = 0;
                                totdeduc = 0;
                                detnom = new DetalleNomina();
                                detallenom = new HashMap();
                                detallenom.put("plaza", plz);
                                detnom.setEstatus(1);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setCotiza(0);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();                                
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacion() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }

                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        if (detnom.getMovimiento().getPeroDed()==1)
                                            totpercep+=detnom.getMonto();
                                        else
                                            totdeduc+=detnom.getMonto();
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                    neto=totpercep-totdeduc;
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(neto));
                                    detallenom.put("cotiza", new Integer(0));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }
                            } else {
                                //calcular su pago normalmente
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                    //pago por dia
                                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                    if (diasquin!=15){
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                    } else {
                                        detnom.setMonto(plz.getSueldo());
                                    }
                                } else
                                    detnom.setMonto(plz.getSueldo());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(0);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        if (detnom.getMovimiento().getPeroDed()==1)
                                            totpercep+=detnom.getMonto();
                                        else
                                            totdeduc+=detnom.getMonto();
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                    neto=totpercep-totdeduc;
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(neto));
                                    detallenom.put("cotiza", new Integer(0));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }
                                /*/
                                if (plz.getSueldocotiza()>0){
                                    //guarda el detalle de sí cotiza
                                    mov = cnomDao.obtenerPeryDed(1);
                                    detnom = new DetalleNomina();
                                    detallenom = new HashMap();
                                    detallenom.put("plaza", plz);
                                    totpercep = 0;
                                    totdeduc = 0;
                                    detnom.setEstatus(1);
                                    detnom.setExento(mov.getGraoExe());
                                    detnom.setCotiza(1);
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                        //pago por dia
                                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                        if (diasquin!=15){
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                        } else {
                                            detnom.setMonto(plz.getSueldocotiza());
                                        }
                                    } else
                                        detnom.setMonto(plz.getSueldocotiza());
                                    detnom.setMovimiento(mov);
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                    if (plz.getCompensacioncotiza() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                        totpercep+=detnom.getMonto();
                                    }
                                    
                                    //si el sueldo no cotiza de la plaza es cero, checar los movs extra y ponerlos como sí cotiza
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            if (detnom.getMovimiento().getPeroDed()==1)
                                                totpercep+=detnom.getMonto();
                                            else
                                                totdeduc+=detnom.getMonto();
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }
                                    
                                    neto=totpercep-totdeduc;
                                    detallenom.put("percepciones", new Float(totpercep));
                                    detallenom.put("deducciones", new Float(totdeduc));
                                    detallenom.put("neto", new Float(neto));
                                    detallenom.put("cotiza", new Integer(1));
                                    detallenom.put("estatus", "POR PAGAR");
                                    detalle.add(detallenom);
                                    totnomina+=neto;
                                }*/
                                
                            }
                        }
                    } else {
                        //si no tiene historial imss calcular su nomina usando el campo cotiza del empleado
                        float sueldoemp = plz.getSueldo();
                        float compensa = plz.getCompensacion();
                        if (plz.getEmpleado().getCotiza()==1){
                            sueldoemp = plz.getSueldocotiza();
                            compensa = plz.getCompensacioncotiza();
                        }
                        //calcular su pago normalmente
                        //if (plz.getSueldo()>0){
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                //pago por dia
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                if (diasquin!=15){
                                    sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                } else {
                                    detnom.setMonto(sueldoemp);
                                }
                            } else
                                detnom.setMonto(sueldoemp);
                            detnom.setMovimiento(mov);
                            detnom.setNomina(nom);
                            detnom.setPlaza(plz);
                            detnom.setCotiza(plz.getEmpleado().getCotiza());
                            if (detnom.getMonto()>0){
                                detnomdao.guardar(detnom);
                                totpercep+=detnom.getMonto();
                                if (compensa > 0){//si la plaza tiene compensacion
                                    mov = cnomDao.obtenerPeryDed(2);
                                    detnom = new DetalleNomina();
                                    detnom.setMovimiento(mov);
                                    detnom.setMonto(compensa);
                                    detnom.setExento(mov.getGraoExe());
                                    detnom.setEstatus(1);
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnom.setCotiza(plz.getEmpleado().getCotiza());
                                    detnomdao.guardar(detnom);
                                    totpercep+=detnom.getMonto();
                                }
                                //genera detalle de los movs extras
                                List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                for (int m=0; m < movs.size(); m++){
                                    MovimientoExtraordinario mext = movs.get(m);
                                    detnom = new DetalleNomina();
                                    detnom.setEstatus(1);
                                    detnom.setExento(mext.getPerded().getGraoExe());
                                    detnom.setMovimiento(mext.getPerded());
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnom.setCotiza(plz.getEmpleado().getCotiza());

                                    //calculo del monto segun el tipo de cambio del mov
                                    if (mext.getTipocambio().getId()==1){
                                        //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                        detnom.setMonto(mext.getImporte());
                                    } else if (mext.getTipocambio().getId()==2){
                                        //si el tipo cambio es dias
                                        //calcular el sueldo diario segun el periodo de pago de la plaza
                                        //el importe en este caso es el número de días
                                        sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                            sueldodiario = new Double(utmod.Redondear(sueldoemp/30,2)).floatValue();

                                        detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                    } else if (mext.getTipocambio().getId()==3){
                                        //si el tipo cambio es horas
                                        //calcular el sueldo diario segun el periodo de pago de la plaza
                                        //el importe en este caso es el número de días
                                        sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                            sueldodiario = new Double(utmod.Redondear(sueldoemp/30,2)).floatValue();

                                        detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                    }
                                    if (detnom.getMovimiento().getPeroDed()==1)
                                        totpercep+=detnom.getMonto();
                                    else
                                        totdeduc+=detnom.getMonto();
                                    detnomdao.guardar(detnom);
                                    //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                    if (mext.getNumero()>1){
                                        MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                        MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                        mextnvo.setEstatus(1);
                                        mextnvo.setImporte(mext.getImporte());
                                        mextnvo.setNumero(mext.getNumero()-1);
                                        mextnvo.setPerded(mext.getPerded());
                                        mextnvo.setPeriodo(mext.getPeriodo());
                                        mextnvo.setPlaza(mext.getPlaza());
                                        Quincena quin = new Quincena();
                                        if (mext.getQuincena().getId()==24){
                                            quin.setId(1);
                                            mextnvo.setAnio(mext.getAnio()+1);
                                        } else {
                                            quin.setId(mext.getQuincena().getId()+1);
                                            mextnvo.setAnio(mext.getAnio());
                                        }
                                        mextnvo.setQuincena(quin);
                                        mextnvo.setTipocambio(mext.getTipocambio());
                                        mextnvo.setTiponomina(mext.getTiponomina());
                                        mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                        mextnvo.setObservaciones(mext.getObservaciones());
                                        medao.guardar(mextnvo);
                                    }
                                }//for movs
                                neto=totpercep-totdeduc;
                                detallenom.put("percepciones", new Float(totpercep));
                                detallenom.put("deducciones", new Float(totdeduc));
                                detallenom.put("neto", new Float(neto));
                                detallenom.put("cotiza", new Integer(plz.getEmpleado().getCotiza()));
                                detallenom.put("estatus", "POR PAGAR");
                                //detallenom.put("pagodiferido", "0");
                                detalle.add(detallenom);
                                totnomina+=neto;
                            }
                        //}
                        /*/
                        if (plz.getSueldocotiza()>0){
                            detnom = new DetalleNomina();
                            detallenom = new HashMap();
                            detallenom.put("plaza", plz);
                            totpercep = 0;
                            totdeduc = 0;
                            mov = cnomDao.obtenerPeryDed(1);
                            detnom.setEstatus(1);
                            detnom.setExento(mov.getGraoExe());
                            
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                //pago por dia
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                if (diasquin!=15){
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                } else {
                                    detnom.setMonto(plz.getSueldocotiza());
                                }
                            } else
                                detnom.setMonto(plz.getSueldocotiza());
                            detnom.setMovimiento(mov);
                            detnom.setNomina(nom);
                            detnom.setPlaza(plz);
                            detnom.setCotiza(1);
                            detnomdao.guardar(detnom);
                            totpercep+=detnom.getMonto();
                            if (plz.getCompensacioncotiza() > 0){//si la plaza tiene compensacion
                                mov = cnomDao.obtenerPeryDed(2);
                                detnom = new DetalleNomina();
                                detnom.setMovimiento(mov);
                                detnom.setMonto(plz.getCompensacion());
                                detnom.setExento(mov.getGraoExe());
                                detnom.setEstatus(1);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(1);
                                detnomdao.guardar(detnom);
                                totpercep+=detnom.getMonto();
                            }
                            
                            //si el sueldo no cotiza de la plaza es cero, checar los movs extra y ponerlos como sí cotiza
                            if (plz.getSueldo()==0){
                                //genera detalle de los movs extras, usando el sueldo de no cotiza
                                List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                for (int m=0; m < movs.size(); m++){
                                    MovimientoExtraordinario mext = movs.get(m);
                                    detnom = new DetalleNomina();
                                    detnom.setEstatus(1);
                                    detnom.setExento(mext.getPerded().getGraoExe());
                                    detnom.setMovimiento(mext.getPerded());
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnom.setCotiza(1);

                                    //calculo del monto segun el tipo de cambio del mov
                                    if (mext.getTipocambio().getId()==1){
                                        //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                        detnom.setMonto(mext.getImporte());
                                    } else if (mext.getTipocambio().getId()==2){
                                        //si el tipo cambio es dias
                                        //calcular el sueldo diario segun el periodo de pago de la plaza
                                        //el importe en este caso es el número de días
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                        detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                    } else if (mext.getTipocambio().getId()==3){
                                        //si el tipo cambio es horas
                                        //calcular el sueldo diario segun el periodo de pago de la plaza
                                        //el importe en este caso es el número de días
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                        detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                    }
                                    if (detnom.getMovimiento().getPeroDed()==1)
                                        totpercep+=detnom.getMonto();
                                    else
                                        totdeduc+=detnom.getMonto();
                                    detnomdao.guardar(detnom);
                                    //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                    if (mext.getNumero()>1){
                                        MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                        MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                        mextnvo.setEstatus(1);
                                        mextnvo.setImporte(mext.getImporte());
                                        mextnvo.setNumero(mext.getNumero()-1);
                                        mextnvo.setPerded(mext.getPerded());
                                        mextnvo.setPeriodo(mext.getPeriodo());
                                        mextnvo.setPlaza(mext.getPlaza());
                                        Quincena quin = new Quincena();
                                        if (mext.getQuincena().getId()==24){
                                            quin.setId(1);
                                            mextnvo.setAnio(mext.getAnio()+1);
                                        } else {
                                            quin.setId(mext.getQuincena().getId()+1);
                                            mextnvo.setAnio(mext.getAnio());
                                        }
                                        mextnvo.setQuincena(quin);
                                        mextnvo.setTipocambio(mext.getTipocambio());
                                        mextnvo.setTiponomina(mext.getTiponomina());
                                        mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                        mextnvo.setObservaciones(mext.getObservaciones());
                                        medao.guardar(mextnvo);
                                    }
                                }//for movs                                       
                            }                                     

                            neto=totpercep-totdeduc;
                            detallenom.put("percepciones", new Float(totpercep));
                            detallenom.put("deducciones", new Float(totdeduc));
                            detallenom.put("neto", new Float(neto));
                            detallenom.put("cotiza", new Integer(1));
                            detallenom.put("estatus", "POR PAGAR");
                            //detallenom.put("pagodiferido", "0");
                            detalle.add(detallenom);
                            totnomina+=neto;
                        }*/
                    }
                //FIN CONSIDERAR LAS FECHAS DE ALTA Y BAJA DEL IMSS DEL EMPLEADO
                
                /*if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                    //pago por dia
                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                    if (diasquin!=15){
                        float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                    } else {
                        detnom.setMonto(plz.getSueldo());
                    }
                } else
                    detnom.setMonto(plz.getSueldo());
                detnom.setMovimiento(mov);
                detnom.setNomina(nom);
                detnom.setPlaza(plz);
                detnomdao.guardar(detnom);
                totpercep+=detnom.getMonto();
                if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                    mov = cnomDao.obtenerPeryDed(2);
                    detnom = new DetalleNomina();
                    detnom.setMovimiento(mov);
                    detnom.setMonto(plz.getCompensacion());
                    detnom.setExento(mov.getGraoExe());
                    detnom.setEstatus(1);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnomdao.guardar(detnom);
                    totpercep+=detnom.getMonto();
                }*/
                /*/genera detalle de los movs extras
                List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                for (int m=0; m < movs.size(); m++){
                    MovimientoExtraordinario mext = movs.get(m);
                    detnom = new DetalleNomina();
                    detnom.setEstatus(1);
                    detnom.setExento(mext.getPerded().getGraoExe());
                    detnom.setMovimiento(mext.getPerded());
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    if (diferido)
                        detnom.setCotiza(0);
                    else
                        detnom.setCotiza(plz.getEmpleado().getCotiza());
                    //calculo del monto segun el tipo de cambio del mov
                    
                    if (mext.getTipocambio().getId()==1){
                        //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                        detnom.setMonto(mext.getImporte());
                    } else if (mext.getTipocambio().getId()==2){
                        //si el tipo cambio es dias
                        //calcular el sueldo diario segun el periodo de pago de la plaza
                        //el importe en este caso es el número de días
                        float sueldodiario = plz.getSueldo()/15;
                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                            sueldodiario = plz.getSueldo()/30;
                        
                        detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                    } else if (mext.getTipocambio().getId()==3){
                        //si el tipo cambio es horas
                        //calcular el sueldo diario segun el periodo de pago de la plaza
                        //el importe en este caso es el número de días
                        float sueldodiario = plz.getSueldo()/15;
                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                            sueldodiario = plz.getSueldo()/30;
                        
                        detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                    }
                    if (detnom.getMovimiento().getPeroDed()==1)
                        totpercep+=detnom.getMonto();
                    else
                        totdeduc+=detnom.getMonto();
                    detnomdao.guardar(detnom);
                    //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                    if (mext.getNumero()>1){
                        MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                        MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                        mextnvo.setEstatus(1);
                        mextnvo.setImporte(mext.getImporte());
                        mextnvo.setNumero(mext.getNumero()-1);
                        mextnvo.setPerded(mext.getPerded());
                        mextnvo.setPeriodo(mext.getPeriodo());
                        mextnvo.setPlaza(mext.getPlaza());
                        Quincena quin = new Quincena();
                        if (mext.getQuincena().getId()==24){
                            quin.setId(1);
                            mextnvo.setAnio(mext.getAnio()+1);
                        } else {
                            quin.setId(mext.getQuincena().getId()+1);
                            mextnvo.setAnio(mext.getAnio());
                        }
                        mextnvo.setQuincena(quin);
                        mextnvo.setTipocambio(mext.getTipocambio());
                        mextnvo.setTiponomina(mext.getTiponomina());
                        mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                        mextnvo.setObservaciones(mext.getObservaciones());
                        medao.guardar(mextnvo);
                    }
                }//for movs
                neto=totpercep-totdeduc;
                HashMap totales = new HashMap();
                totales.put("totpercep", new Float(totpercep));
                totales.put("totdeduc", new Float(totdeduc));
                totales.put("neto", new Float(neto));
                totales.put("plaza", plz);
                totales.put("estatus", "POR PAGAR");
                totsplaza.add(totales);*/
            }
            //totnomina+=neto;
        }//for plazas
        
        datos.put("listacompleta", detalle);
        if (detalle.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("detallenomina", detalle);
        }
        
        //datos.put("detallenomina", totsplaza);        
        datos.put("totalnomina", totnomina);
        return datos;
    }

    private HashMap ObtenerQuincenaActiva(HashMap datos) {
        QuincenaDao quindao = new QuincenaDao();
        Quincena quinactiva = quindao.obtenerQuincenaActiva();
        //obtener la fecha actual
        UtilDao utdao = new UtilDao();
        Date hoy = utdao.hoy();
        Calendar choy = Calendar.getInstance();
        choy.setTime(hoy);
        int anio = utdao.AñoActual();
        if (quinactiva.getNummes()==12 && quinactiva.getNumero()==2 && choy.get(Calendar.MONTH)==0)
            anio--;
        datos.put("anio", Integer.toString(anio));
        if (quinactiva.getNummes()==2){
            //si el mes es febrero, actualizar el dia final de la quincena si es año bisiesto
            //int anioact = Integer.parseInt(datos.get("anio").toString());
            GregorianCalendar calendar = new GregorianCalendar();
            if (calendar.isLeapYear(anio)){
                quinactiva.setFin(29);
                quindao.actualizar(quinactiva);
            }
        }
        
        datos.put("quinactiva", quinactiva);
        return datos;
    }

    private HashMap ObtenerAnioActual(HashMap datos) {
        UtilDao utdao = new UtilDao();
        datos.put("anio", Integer.toString(utdao.AñoActual()));
        return datos;
    }

    /*private HashMap ObtenerQuincenas(HashMap datos) {
        Quincena quinactiva = (Quincena)datos.get("quinactiva");
        QuincenaDao quindao = new QuincenaDao();
        List<Quincena> quincenas = quindao.obtenerQuincenasHastaActiva();
        datos.put("quincenas", quincenas);
        return datos;
    }*/

    private HashMap ObtenerAnioAntiguo(HashMap datos) {
        NominaDao nomdao = new NominaDao();
        int anioini = nomdao.obtenerAnioInicial();
        int anioact = Integer.parseInt(datos.get("anio").toString());
        if (anioini==0)
            anioini=anioact;
        datos.put("anioini", Integer.toString(anioini));
        return datos;
    }

    private HashMap RecalcularNomina(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        NominaDao nomdao = new NominaDao();
        nom = nomdao.obtener(nom.getId());
        datos.put("nomina", nom);
        DetalleNominaDao detnomdao = new DetalleNominaDao();

        Quincena quinact = nom.getQuincena();
        //float totnomina = 0;
        //obtener las plazas activas
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(nom.getAnio())+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        //List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(ffinquin, nom.getSucursal().getId());*/
        String finiquin = Integer.toString(nom.getAnio())+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(finiquin, ffinquin, nom.getSucursal().getId());
        
        if (plazas.isEmpty()){
            datos.put("error", "No hay plazas activas en la Sucursal seleccionada");
            return datos;
        }
        
        //obtener detalle nomina todos
        List<HashMap> detallenomina = new ArrayList<HashMap>();
        List<Plaza> plazasdet = detnomdao.obtenerPlazasDeNomina(nom.getId());
        for (int p=0; p < plazasdet.size(); p++){
            Plaza plz = plazasdet.get(p);
            HashMap detalle = new HashMap();
            detalle.put("plaza", plz);
            float percep = 0;
            float deduc = 0;
            //obtener detalle cotiza de la plaza
            List<DetalleNomina> detcotplz = detnomdao.obtenerDetallesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
            if (detcotplz!=null && !detcotplz.isEmpty()){
                detalle.put("cotiza", new Integer(1));
                String estatus = "POR PAGAR";
                int ipago = 0;
                for (int d=0; d < detcotplz.size(); d++){
                    DetalleNomina dn = detcotplz.get(d);
                    if (dn.getMovimiento().getPeroDed()==1)
                        percep+=dn.getMonto();
                    else
                        deduc+=dn.getMonto();
                    if (dn.getEstatus()==2){
                        estatus = "PAGADO";
                        ipago = 1;
                    }
                }
                detalle.put("percepciones", new Float(percep));
                detalle.put("deducciones", new Float(deduc));
                detalle.put("neto", new Float(percep-deduc));
                detalle.put("estatus", estatus);
                detallenomina.add(detalle);
            }
            
            //obtener detalle no cotiza de la plaza
            detalle = new HashMap();
            detalle.put("plaza", plz);
            percep = 0;
            deduc = 0;
            List<DetalleNomina> detnocotplz = detnomdao.obtenerDetallesDeNominaNoCotizaDePlaza(nom.getId(), plz.getId());
            if (detnocotplz!=null && !detnocotplz.isEmpty()){
                detalle.put("cotiza", new Integer(0));
                String estatus = "POR PAGAR";
                int ipago = 0;
                for (int d=0; d < detnocotplz.size(); d++){
                    DetalleNomina dn = detnocotplz.get(d);
                    if (dn.getMovimiento().getPeroDed()==1)
                        percep+=dn.getMonto();
                    else
                        deduc+=dn.getMonto();
                    if (dn.getEstatus()==2){
                        estatus = "PAGADO";
                        ipago = 1;
                    }
                }
                detalle.put("percepciones", new Float(percep));
                detalle.put("deducciones", new Float(deduc));
                detalle.put("neto", new Float(percep-deduc));
                detalle.put("estatus", estatus);
                detallenomina.add(detalle);
            }
        }
        
        //recorrer las plazas
        datos.put("detallenomina", detallenomina);
        for (int p=0; p < plazas.size(); p++){
            Plaza plz = plazas.get(p);
            //checa si la plaza esta en el detalle de nomina actual
            boolean recalcular = false, esta = false;
            int pos = 0;
            for (int d=0; d < detallenomina.size(); d++){
                HashMap dt = detallenomina.get(d);
                Plaza pdt = (Plaza)dt.get("plaza");
                String estatus = dt.get("estatus").toString();
                if (pdt.getId()==plz.getId()){
                    esta=true;
                    if (estatus.equals("POR PAGAR")){
                        recalcular = true;
                        pos = d;
                    }
                    break;
                }
            }
            
            if (recalcular){
                datos.put("varios", Integer.toString(pos));
                datos.put("recalculanomina", "1");
                datos = RecalcularPlaza(datos);
                datos.remove("recalculanomina");
            } else if (!esta) {
                
                boolean aplica = false;
                //validar periodo de pago de la plaza
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                    //pago mensual
                    int quinnumpago = 1;
                    Calendar fechalta = Calendar.getInstance();
                    fechalta.setTime(plz.getFechaalta());
                    if (fechalta.get(Calendar.DAY_OF_MONTH)<=15){
                        quinnumpago = 2;
                    }
                    if (quinnumpago == quinact.getNumero()){
                        aplica = true;
                    }
                } else {
                    aplica = true;
                }
                
                if (aplica){
                //es una plaza que no estaba en el detalle actual
                MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
                CatNominaDao cnomDao = new CatNominaDao();
                UtilMod utmod = new UtilMod();
                //genera detalle del salario de la plaza
                DetalleNomina detnom = new DetalleNomina();
                PeryDed mov = cnomDao.obtenerPeryDed(1);
                detnom.setEstatus(1);
                detnom.setExento(mov.getGraoExe());
                float sueldodiario = 0;

                int anio = Integer.parseInt(datos.get("anio").toString()); 
                int niniquinant = 1;
                int mesant = quinact.getNummes();
                if (quinact.getInicio()==1){
                    niniquinant = 16;
                    mesant = quinact.getNummes()-1;
                }
                String finiquinant = Integer.toString(anio)+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
                
                //CONSIDERAR LAS FECHAS DE ALTA Y BAJA DEL IMSS DEL EMPLEADO
                    //definir las fechas inicial y final de la quincena
                    SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
                    Date iniquin = null, finquin = null, iniquinant = null;
                    try {
                        iniquin = ffecha.parse(finiquin);
                        finquin = ffecha.parse(ffinquin);
                        iniquinant = ffecha.parse(finiquinant);
                    } catch (ParseException ex) {
                        Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    //Obtener el historial imss del empleado de la plaza
                    HistorialIMSSDao hidao = new HistorialIMSSDao();
                    List<HistorialIMSS> hisimss = hidao.obtenerHistorialDeEmpleado(plz.getEmpleado().getNumempleado());
                    if (hisimss!=null && hisimss.size()>0){
                        HistorialIMSS hiemp = hisimss.get(0);
                        //Date altaimss = hiemp.getFechaalta();
                        if (hiemp.getFechabaja()==null){
                            //En este caso el empleado si esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechaalta().after(iniquinant))
                                    && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            if ((hiemp.getFechaalta().after(iniquin))
                                    && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin)) || mensual){
                                //el alta esta entre la quincena, calcular pago diferido
                                //calcular dias cotiza y dias no cotiza
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                long diascot = 1;
                                if (hiemp.getFechaalta().before(finquin))
                                    diascot = (( finquin.getTime() - hiemp.getFechaalta().getTime() )/MILLSECS_PER_DAY)+1;
                                long diasnocot = 15 - diascot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diasnocot = diasquin - diascot;
                                
                                if (mensual){
                                    diasnocot = 30 - diascot;
                                }
                                
                                //guardar detalle sí cotiza
                                detnom.setCotiza(1);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);                                    
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacioncotiza() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                    }
                                    //si el empleado no tiene sueldo no cotiza y tiene movs extras
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }
                                }
                                //guarda detalle no cotiza
                                detnom = new DetalleNomina();
                                detnom.setEstatus(1);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setCotiza(0);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacion() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                    }
                                
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        /*if (detnom.getMovimiento().getPeroDed()==1)
                                            totpercep+=detnom.getMonto();
                                        else
                                            totdeduc+=detnom.getMonto();*/
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                            } else {
                                //calcular su pago normalmente
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                    //pago por dia
                                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                    if (diasquin!=15){
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                    } else {
                                        detnom.setMonto(plz.getSueldocotiza());
                                    }
                                } else
                                    detnom.setMonto(plz.getSueldocotiza());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(1);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    if (plz.getCompensacioncotiza() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                        //totpercep+=detnom.getMonto();
                                    }
                                    //si el sueldo no cotiza de la plaza es cero, checar los movs extra y ponerlos como sí cotiza
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs
                                    }
                                }
                                
                                if (plz.getSueldo()>0){
                                    //guarda el detalle de no cotiza
                                    mov = cnomDao.obtenerPeryDed(1);
                                    detnom = new DetalleNomina();
                                    detnom.setEstatus(1);
                                    detnom.setExento(mov.getGraoExe());
                                    detnom.setCotiza(0);
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                        //pago por dia
                                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                        if (diasquin!=15){
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                        } else {
                                            detnom.setMonto(plz.getSueldo());
                                        }
                                    } else
                                        detnom.setMonto(plz.getSueldo());
                                    detnom.setMovimiento(mov);
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnomdao.guardar(detnom);
                                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                    }
                                
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                            } //alta imss interquincenal
                        } else {
                            //En este caso el empleado no esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechabaja().after(iniquinant))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            
                            if ((hiemp.getFechabaja().after(iniquin))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin)) || mensual){
                                //la baja esta entre la quincena, calcular pago diferido
                                //calcular dias cotiza y dias no cotiza
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                long diasnocot = 1;
                                if (hiemp.getFechabaja().before(finquin))
                                    diasnocot = ((finquin.getTime() - hiemp.getFechabaja().getTime())/MILLSECS_PER_DAY)+1;
                                long diascot = 15 - diasnocot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diascot = diasquin - diasnocot;
                                if (mensual)
                                    diascot = 30 - diasnocot;
                                
                                //guardar detalle sí cotiza
                                detnom.setCotiza(1);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacioncotiza() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                    }
                                    
                                    //si el sueldo no cotiza de la plaza es cero, checar los movs extra y ponerlos como sí cotiza
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }
                                }
                                //guarda detalle no cotiza
                                detnom = new DetalleNomina();
                                detnom.setEstatus(1);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setCotiza(0);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();                                
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacion() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                    }
                                
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                            } else {
                                //calcular su pago normalmente
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                    //pago por dia
                                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                    if (diasquin!=15){
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                    } else {
                                        detnom.setMonto(plz.getSueldo());
                                    }
                                } else
                                    detnom.setMonto(plz.getSueldo());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(0);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                    }
                                
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                                
                            }
                        }
                    } else {
                        //si no tiene historial imss calcular su nomina usando el campo cotiza del empleado
                        //calcular su pago normalmente
                        float sueldoemp = plz.getSueldo();
                        float compensa = plz.getCompensacion();
                        if (plz.getEmpleado().getCotiza()==1){
                            sueldoemp = plz.getSueldocotiza();
                            compensa = plz.getCompensacioncotiza();
                        }
                        if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                            //pago por dia
                            int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                            if (diasquin!=15){
                                sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                            } else {
                                detnom.setMonto(sueldoemp);
                            }
                        } else
                            detnom.setMonto(sueldoemp);
                        detnom.setMovimiento(mov);
                        detnom.setNomina(nom);
                        detnom.setPlaza(plz);
                        detnom.setCotiza(plz.getEmpleado().getCotiza());
                        if (detnom.getMonto()>0){
                            detnomdao.guardar(detnom);
                            //totpercep+=detnom.getMonto();
                            if (compensa > 0){//si la plaza tiene compensacion
                                mov = cnomDao.obtenerPeryDed(2);
                                detnom = new DetalleNomina();
                                detnom.setMovimiento(mov);
                                detnom.setMonto(compensa);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setEstatus(1);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(plz.getEmpleado().getCotiza());
                                detnomdao.guardar(detnom);
                            }

                            //genera detalle de los movs extras
                            List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                            for (int m=0; m < movs.size(); m++){
                                MovimientoExtraordinario mext = movs.get(m);
                                detnom = new DetalleNomina();
                                detnom.setEstatus(1);
                                detnom.setExento(mext.getPerded().getGraoExe());
                                detnom.setMovimiento(mext.getPerded());
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(plz.getEmpleado().getCotiza());

                                //calculo del monto segun el tipo de cambio del mov
                                if (mext.getTipocambio().getId()==1){
                                    //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                    detnom.setMonto(mext.getImporte());
                                } else if (mext.getTipocambio().getId()==2){
                                    //si el tipo cambio es dias
                                    //calcular el sueldo diario segun el periodo de pago de la plaza
                                    //el importe en este caso es el número de días
                                    sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                        sueldodiario = new Double(utmod.Redondear(sueldoemp/30,2)).floatValue();

                                    detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                } else if (mext.getTipocambio().getId()==3){
                                    //si el tipo cambio es horas
                                    //calcular el sueldo diario segun el periodo de pago de la plaza
                                    //el importe en este caso es el número de días
                                    sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                        sueldodiario = new Double(utmod.Redondear(sueldoemp/30,2)).floatValue();

                                    detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                }
                                detnomdao.guardar(detnom);
                                //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                if (mext.getNumero()>1){
                                    MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                    MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                    mextnvo.setEstatus(1);
                                    mextnvo.setImporte(mext.getImporte());
                                    mextnvo.setNumero(mext.getNumero()-1);
                                    mextnvo.setPerded(mext.getPerded());
                                    mextnvo.setPeriodo(mext.getPeriodo());
                                    mextnvo.setPlaza(mext.getPlaza());
                                    Quincena quin = new Quincena();
                                    if (mext.getQuincena().getId()==24){
                                        quin.setId(1);
                                        mextnvo.setAnio(mext.getAnio()+1);
                                    } else {
                                        quin.setId(mext.getQuincena().getId()+1);
                                        mextnvo.setAnio(mext.getAnio());
                                    }
                                    mextnvo.setQuincena(quin);
                                    mextnvo.setTipocambio(mext.getTipocambio());
                                    mextnvo.setTiponomina(mext.getTiponomina());
                                    mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                    mextnvo.setObservaciones(mext.getObservaciones());
                                    medao.guardar(mextnvo);
                                }
                            }//for movs
                        }
                    }
                //FIN CONSIDERAR LAS FECHAS DE ALTA Y BAJA DEL IMSS DEL EMPLEADO
                }
            }
        }
        
        /*/borra el detalle actual (excepto las plazas ya pagadas)
        detnomdao.eliminaDetalleDeNomina(nom.getId());
        Quincena quinact = nom.getQuincena();
        //recalcula el detalle de la nomina
        float totnomina = 0;
        //obtener las plazas activas
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(nom.getAnio())+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        //List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(ffinquin, nom.getSucursal().getId());
        String finiquin = Integer.toString(nom.getAnio())+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(finiquin, ffinquin, nom.getSucursal().getId());
        
        if (plazas.isEmpty()){
            datos.put("error", "No hay plazas activas en la Sucursal seleccionada");
            return datos;
        }
        
        int anio = nom.getAnio();
        
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        CatNominaDao cnomDao = new CatNominaDao();
        UtilMod utmod = new UtilMod();
        List<HashMap> totsplaza = new ArrayList<HashMap>();
        List<Plaza> pagadas = detnomdao.obtenerPlazasPagadasDeNomina(nom.getId());
        for (int i=0; i < plazas.size(); i++){
            float totpercep = 0;
            float totdeduc = 0;
            float neto = 0;
            HashMap totales = new HashMap();
            Plaza plz = plazas.get(i);
            //checar si la plaza está en pagadas
            boolean esta = false;
            for (int p=0; p < pagadas.size(); p++){
                Plaza pag = pagadas.get(p);
                if (pag.getId()==plz.getId()){
                    esta = true;
                    break;
                }
            }
            if (esta){
                totpercep = detnomdao.obtenerTotalPercepcionesDePlazaEnNomina(plz.getId(), nom.getId());
                totdeduc = detnomdao.obtenerTotalDeduccionesDePlazaEnNomina(plz.getId(), nom.getId());
                neto = totpercep - totdeduc;
                totales.put("totpercep", new Float(totpercep));
                totales.put("totdeduc", new Float(totdeduc));
                totales.put("neto", new Float(neto));
                totales.put("plaza", plz);
                totales.put("estatus", "PAGADO");
                totsplaza.add(totales);
            } else {
                boolean aplica = false;
                //validar periodo de pago de la plaza
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                    //pago mensual
                    int quinnumpago = 1;
                    Calendar fechalta = Calendar.getInstance();
                    fechalta.setTime(plz.getFechaalta());
                    if (fechalta.get(Calendar.DAY_OF_MONTH)<=15){
                        quinnumpago = 2;
                    }
                    if (quinnumpago == quinact.getNumero()){
                        aplica = true;
                    }
                } else {
                    aplica = true;
                }

                if (aplica){
                    //genera detalle del salario de la plaza
                    DetalleNomina detnom = new DetalleNomina();
                    PeryDed mov = cnomDao.obtenerPeryDed(1);
                    detnom.setEstatus(1);
                    detnom.setExento(mov.getGraoExe());
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                        //pago por dia
                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                        if (diasquin!=15){
                        float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                        } else {
                            detnom.setMonto(plz.getSueldo());
                        }
                    } else
                        detnom.setMonto(plz.getSueldo());
                    detnom.setMovimiento(mov);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnomdao.guardar(detnom);
                    totpercep+=detnom.getMonto();
                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                        mov = cnomDao.obtenerPeryDed(2);
                        detnom = new DetalleNomina();
                        detnom.setMovimiento(mov);
                        detnom.setMonto(plz.getCompensacion());
                        detnom.setExento(mov.getGraoExe());
                        detnom.setEstatus(1);
                        detnom.setNomina(nom);
                        detnom.setPlaza(plz);
                        detnomdao.guardar(detnom);
                        totpercep+=detnom.getMonto();
                    }
                    //eliminar los movs extras de la plaza de la quincena siguiente
                    Quincena quinsig = new Quincena();
                    int aniosig = anio;
                    if (quinact.getId()==24){
                        quinsig.setId(1);
                        aniosig++;
                    }else
                        quinsig.setId(quinact.getId()+1);
                    movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
                    //genera detalle de los movs extras
                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                    for (int m=0; m < movs.size(); m++){
                        MovimientoExtraordinario mext = movs.get(m);
                        detnom = new DetalleNomina();
                        detnom.setEstatus(1);
                        detnom.setExento(mext.getPerded().getGraoExe());
                        detnom.setMovimiento(mext.getPerded());
                        detnom.setNomina(nom);
                        detnom.setPlaza(plz);
                        //calculo del monto segun el tipo de cambio del mov

                        if (mext.getTipocambio().getId()==1){
                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                            detnom.setMonto(mext.getImporte());
                        } else if (mext.getTipocambio().getId()==2){
                            //si el tipo cambio es dias
                            //calcular el sueldo diario segun el periodo de pago de la plaza
                            //el importe en este caso es el número de días
                            float sueldodiario = plz.getSueldo()/15;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                sueldodiario = plz.getSueldo()/30;

                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                        } else if (mext.getTipocambio().getId()==3){
                            //si el tipo cambio es horas
                            //calcular el sueldo diario segun el periodo de pago de la plaza
                            //el importe en este caso es el número de días
                            float sueldodiario = plz.getSueldo()/15;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                sueldodiario = plz.getSueldo()/30;

                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                        }
                        if (detnom.getMovimiento().getPeroDed()==1)
                            totpercep+=detnom.getMonto();
                        else
                            totdeduc+=detnom.getMonto();
                        detnomdao.guardar(detnom);
                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                        if (mext.getNumero()>1){                            
                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                            mextnvo.setEstatus(1);
                            mextnvo.setImporte(mext.getImporte());
                            mextnvo.setNumero(mext.getNumero()-1);
                            mextnvo.setPerded(mext.getPerded());
                            mextnvo.setPeriodo(mext.getPeriodo());
                            mextnvo.setPlaza(mext.getPlaza());
                            Quincena quin = new Quincena();
                            if (mext.getQuincena().getId()==24){
                                quin.setId(1);
                                mextnvo.setAnio(mext.getAnio()+1);
                            } else {
                                quin.setId(mext.getQuincena().getId()+1);
                                mextnvo.setAnio(mext.getAnio());
                            }
                            mextnvo.setQuincena(quin);
                            mextnvo.setTipocambio(mext.getTipocambio());
                            mextnvo.setTiponomina(mext.getTiponomina());
                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                            mextnvo.setObservaciones(mext.getObservaciones());
                            medao.guardar(mextnvo);
                        }
                        
                    }//for movs
                    neto=totpercep-totdeduc;
                    totales.put("totpercep", new Float(totpercep));
                    totales.put("totdeduc", new Float(totdeduc));
                    totales.put("neto", new Float(neto));
                    totales.put("plaza", plz);
                    totales.put("estatus", "POR PAGAR");
                }//if aplica
                totsplaza.add(totales);
            }
            totnomina+=neto;
        }//for plazas
        //datos.put("detallenomina", totsplaza);
        /*datos.put("listacompleta", totsplaza);
        if (totsplaza.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("detallenomina", totsplaza);
        }
        
        datos.put("totalnomina", totnomina);*/
        datos = ObtenerNomina(datos);
        return datos;
    }

    private HashMap PagarPlaza(HashMap datos) {
        String varios = datos.get("varios").toString();
        Nomina nom = (Nomina)datos.get("nomina");
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        /*if (varios.equals("0")){
            Plaza plz = (Plaza)datos.get("plaza");
            detnomdao.cambiaEstatusDePlazaEnNomina(plz.getId(), nom.getId(), 2);
        } else {*/
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        VacacionesDao vacdao = new VacacionesDao();
            StringTokenizer tokens=new StringTokenizer(varios, ",");
            while(tokens.hasMoreTokens()){
                int i = Integer.parseInt(tokens.nextToken());
                HashMap detalle = listado.get(i);
                Plaza plz = (Plaza)detalle.get("plaza");
                int cotiza = ((Integer)detalle.get("cotiza")).intValue();
                detnomdao.cambiaEstatusPagoAPlazaEnNomina(nom.getId(), plz.getId(), cotiza, 2);
                //actualizar estatus de vacaciones del empleado
                Vacaciones vacas = vacdao.obtenerVacacionesDeEmpleadoYNomina(plz.getEmpleado().getNumempleado(), nom.getId());
                if (vacas!=null){
                    vacas.setEstatus(2);
                    vacdao.actualizar(vacas);
                }
                //detnomdao.cambiaEstatusDePlazaEnNomina(Integer.parseInt(tokens.nextToken()), nom.getId(), 2);
            }
        //}
        datos = ObtenerNomina(datos);
        datos.remove("varios");
        return datos;
    }

    private HashMap CerrarNomina(HashMap datos) {
        //obtener el detalle de la nomina
        datos = ObtenerNomina(datos);
        //poner como pagados todas las plazas de la nomina
        Nomina nom = (Nomina)datos.get("nomina");
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompleta");
        VacacionesDao vacdao = new VacacionesDao();
        for (int i=0; i < detnomina.size(); i++){
            HashMap det = detnomina.get(i);
            if (!det.get("estatus").toString().equals("PAGADO")){
                Plaza plz = (Plaza)det.get("plaza");
                DetalleNominaDao detnomdao = new DetalleNominaDao();
                detnomdao.cambiaEstatusDePlazaEnNomina(plz.getId(), nom.getId(), 2);
                //actualizar estatus de vacaciones del empleado
                Vacaciones vacas = vacdao.obtenerVacacionesDeEmpleadoYNomina(plz.getEmpleado().getNumempleado(), nom.getId());
                if (vacas!=null){
                    vacas.setEstatus(2);
                    vacdao.actualizar(vacas);
                }
                
            }
        }
        //cambiar el estatus de la nomina
        NominaDao nomdao = new NominaDao();
        nomdao.actualizarEstatus(2, nom.getId());
        //actualizar la fecha de cierre de la nomina
        nomdao.actualizaFechaCierre(nom.getId());
        //recargar listado de nominas
        datos = ObtenerNominas(datos);
        return datos;
    }
    
    private HashMap ObtenerGrupo(HashMap datos) {
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<HashMap> grupo = new ArrayList<HashMap>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin > detnomina.size()){
            fin = detnomina.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(detnomina.get(i));
        }
        datos.put("detallenomina", grupo);
        return datos;
    }
    
    private HashMap CargarSiguientes(HashMap datos) {
        int fin = Integer.parseInt(datos.get("final").toString());
        datos.put("inicial", Integer.toString(fin+1));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap CargarAnteriores(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicial").toString())-grupos;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap CargarPrincipio(HashMap datos) {
        datos.put("inicial", "1");
        datos = ObtenerGrupo(datos);        
        return datos;
    }

    private HashMap CargarFinal(HashMap datos) {
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompleta");
        int total = detnomina.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap RecalcularPlaza(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        String varios = datos.get("varios").toString();
        PlazaDao plzdao = new PlazaDao();
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        StringTokenizer tokens=new StringTokenizer(varios, ",");
        
        int anio = Integer.parseInt(datos.get("anio").toString());        
        Quincena quinact = (Quincena)datos.get("quinactiva");
        String ffinquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        String finiquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        int niniquinant = 1;
        int mesant = quinact.getNummes();
        if (quinact.getInicio()==1){
            niniquinant = 16;
            mesant = quinact.getNummes()-1;
        }
        String finiquinant = Integer.toString(anio)+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
        
        while(tokens.hasMoreTokens()){
            int i = Integer.parseInt(tokens.nextToken());
            HashMap detalle = listado.get(i);
            Plaza plz = (Plaza)detalle.get("plaza");
            int cotiza = ((Integer)detalle.get("cotiza")).intValue();
            String estatus = detalle.get("estatus").toString();
            
            boolean recalcular = true;
            DetalleNominaDao detnomdao = new DetalleNominaDao();
            //checar si la plaza seleccionada tiene un pago diferido (si cotiza y no cotiza)
            List<DetalleNomina> dndif = new ArrayList<DetalleNomina>();
            if (cotiza==1)
                dndif = detnomdao.obtenerDetallesDeNominaNoCotizaDePlaza(nom.getId(), plz.getId());
            else
                dndif = detnomdao.obtenerDetallesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
            
            if (dndif!=null && !dndif.isEmpty()){
                String est = "NO PAGADO";
                for (int d=0; d < dndif.size(); d++){
                    DetalleNomina dt = dndif.get(d);
                    if (dt.getEstatus()==2)
                        est = "PAGADO";
                }
                if (est.equals("PAGADO"))
                    recalcular = false;
            }
            
            if (recalcular){
                MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
                CatNominaDao cnomDao = new CatNominaDao();
                UtilMod utmod = new UtilMod();
                //borra el detalle actual de la plaza
                detnomdao.eliminaDetalleDePlazaEnNomina(nom.getId(), plz.getId());
                
                //recalcular detalles de nomina de la plaza actual
                /*float totpercep = 0;
                float totdeduc = 0;
                float neto = 0;*/
                
                /*HashMap detallenom = new HashMap();
                detallenom.put("plaza", plz);*/
                //genera detalle del salario de la plaza
                DetalleNomina detnom = new DetalleNomina();
                PeryDed mov = cnomDao.obtenerPeryDed(1);
                detnom.setEstatus(1);
                detnom.setExento(mov.getGraoExe());
                float sueldodiario = 0;
                
                //CONSIDERAR LAS FECHAS DE ALTA Y BAJA DEL IMSS DEL EMPLEADO
                    //definir las fechas inicial y final de la quincena
                    SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
                    Date iniquin = null, finquin = null, iniquinant = null;
                    try {
                        iniquin = ffecha.parse(finiquin);
                        finquin = ffecha.parse(ffinquin);
                        iniquinant = ffecha.parse(finiquinant);
                    } catch (ParseException ex) {
                        Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    //Obtener el historial imss del empleado de la plaza
                    HistorialIMSSDao hidao = new HistorialIMSSDao();
                    List<HistorialIMSS> hisimss = hidao.obtenerHistorialDeEmpleado(plz.getEmpleado().getNumempleado());
                    if (hisimss!=null && hisimss.size()>0){
                        HistorialIMSS hiemp = hisimss.get(0);
                        //Date altaimss = hiemp.getFechaalta();
                        if (hiemp.getFechabaja()==null){
                            //En este caso el empleado si esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechaalta().after(iniquinant))
                                    && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            if ((hiemp.getFechaalta().after(iniquin))
                                    && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin)) || mensual){
                                //el alta esta entre la quincena, calcular pago diferido
                                //calcular dias cotiza y dias no cotiza
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                long diascot = 1;
                                if (hiemp.getFechaalta().before(finquin))
                                    diascot = (( finquin.getTime() - hiemp.getFechaalta().getTime() )/MILLSECS_PER_DAY)+1;
                                long diasnocot = 15 - diascot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diasnocot = diasquin - diascot;
                                
                                if (mensual){
                                    diasnocot = 30 - diascot;
                                }
                                
                                //guardar detalle sí cotiza
                                detnom.setCotiza(1);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacioncotiza() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                    }
                                    //si el empleado no tiene sueldo no cotiza y tiene movs extras
                                    if (plz.getSueldo()==0){
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }
                                }
                                //guarda detalle no cotiza
                                detnom = new DetalleNomina();
                                detnom.setEstatus(1);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setCotiza(0);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacion() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        //totpercep+=detnom.getMonto();
                                    }
                                
                                    //eliminar los movs extras de la plaza de la quincena siguiente
                                    Quincena quinsig = new Quincena();
                                    int aniosig = anio;
                                    if (quinact.getId()==24){
                                        quinsig.setId(1);
                                        aniosig++;
                                    }else
                                        quinsig.setId(quinact.getId()+1);
                                    movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
                                
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                            } else {
                                //calcular su pago normalmente, el empleado sí cotiza
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                    //pago por dia
                                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                    if (diasquin!=15){
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                    } else {
                                        detnom.setMonto(plz.getSueldocotiza());
                                    }
                                } else
                                    detnom.setMonto(plz.getSueldocotiza());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(1);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //totpercep+=detnom.getMonto();
                                    if (plz.getCompensacioncotiza() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                        //totpercep+=detnom.getMonto();
                                    }
                                
                                    
                                    if (plz.getSueldo()==0){
                                        //eliminar los movs extras de la plaza de la quincena siguiente
                                        Quincena quinsig = new Quincena();
                                        int aniosig = anio;
                                        if (quinact.getId()==24){
                                            quinsig.setId(1);
                                            aniosig++;
                                        }else
                                            quinsig.setId(quinact.getId()+1);
                                        movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
                                        
                                        //genera detalle de los movs extras
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs
                                    }
                                }
                                
                                if (plz.getSueldo()>0){
                                    //guarda el detalle de no cotiza
                                    mov = cnomDao.obtenerPeryDed(1);
                                    detnom = new DetalleNomina();
                                    detnom.setEstatus(1);
                                    detnom.setExento(mov.getGraoExe());
                                    detnom.setCotiza(0);
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                        //pago por dia
                                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                        if (diasquin!=15){
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                        } else {
                                            detnom.setMonto(plz.getSueldo());
                                        }
                                    } else
                                        detnom.setMonto(plz.getSueldo());
                                    detnom.setMovimiento(mov);
                                    detnom.setNomina(nom);
                                    detnom.setPlaza(plz);
                                    detnomdao.guardar(detnom);
                                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                    }
                                    
                                    //eliminar los movs extras de la plaza de la quincena siguiente
                                    Quincena quinsig = new Quincena();
                                    int aniosig = anio;
                                    if (quinact.getId()==24){
                                        quinsig.setId(1);
                                        aniosig++;
                                    }else
                                        quinsig.setId(quinact.getId()+1);
                                    movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs                                
                                }
                            }
                        } else {
                            //En este caso el empleado no esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechabaja().after(iniquinant))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            
                            if ((hiemp.getFechabaja().after(iniquin))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin)) || mensual){
                                //la baja esta entre la quincena, calcular pago diferido
                                //calcular dias cotiza y dias no cotiza
                                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                long diasnocot = 1;
                                if (hiemp.getFechabaja().before(finquin))
                                    diasnocot = ((finquin.getTime() - hiemp.getFechabaja().getTime())/MILLSECS_PER_DAY)+1;
                                long diascot = 15 - diasnocot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diascot = diasquin - diasnocot;
                                if (mensual)
                                    diascot = 30 - diasnocot;
                                
                                //guardar detalle sí cotiza
                                detnom.setCotiza(1);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacioncotiza() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacioncotiza());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(1);
                                        detnomdao.guardar(detnom);
                                    }
                                    
                                    if (plz.getSueldo()==0){
                                        //eliminar los movs extras de la plaza de la quincena siguiente
                                        Quincena quinsig = new Quincena();
                                        int aniosig = anio;
                                        if (quinact.getId()==24){
                                            quinsig.setId(1);
                                            aniosig++;
                                        }else
                                            quinsig.setId(quinact.getId()+1);
                                        movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
                                        //genera detalle de los movs extras, usando el sueldo de no cotiza
                                        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                        for (int m=0; m < movs.size(); m++){
                                            MovimientoExtraordinario mext = movs.get(m);
                                            detnom = new DetalleNomina();
                                            detnom.setEstatus(1);
                                            detnom.setExento(mext.getPerded().getGraoExe());
                                            detnom.setMovimiento(mext.getPerded());
                                            detnom.setNomina(nom);
                                            detnom.setPlaza(plz);
                                            detnom.setCotiza(1);

                                            //calculo del monto segun el tipo de cambio del mov
                                            if (mext.getTipocambio().getId()==1){
                                                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                                detnom.setMonto(mext.getImporte());
                                            } else if (mext.getTipocambio().getId()==2){
                                                //si el tipo cambio es dias
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();;
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                            } else if (mext.getTipocambio().getId()==3){
                                                //si el tipo cambio es horas
                                                //calcular el sueldo diario segun el periodo de pago de la plaza
                                                //el importe en este caso es el número de días
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/15,2)).floatValue();
                                                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldocotiza()/30,2)).floatValue();

                                                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                            }
                                            detnomdao.guardar(detnom);
                                            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                            if (mext.getNumero()>1){
                                                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                                mextnvo.setEstatus(1);
                                                mextnvo.setImporte(mext.getImporte());
                                                mextnvo.setNumero(mext.getNumero()-1);
                                                mextnvo.setPerded(mext.getPerded());
                                                mextnvo.setPeriodo(mext.getPeriodo());
                                                mextnvo.setPlaza(mext.getPlaza());
                                                Quincena quin = new Quincena();
                                                if (mext.getQuincena().getId()==24){
                                                    quin.setId(1);
                                                    mextnvo.setAnio(mext.getAnio()+1);
                                                } else {
                                                    quin.setId(mext.getQuincena().getId()+1);
                                                    mextnvo.setAnio(mext.getAnio());
                                                }
                                                mextnvo.setQuincena(quin);
                                                mextnvo.setTipocambio(mext.getTipocambio());
                                                mextnvo.setTiponomina(mext.getTiponomina());
                                                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                                mextnvo.setObservaciones(mext.getObservaciones());
                                                medao.guardar(mextnvo);
                                            }
                                        }//for movs                                       
                                    }                                    
                                }
                                
                                //guarda detalle no cotiza
                                detnom = new DetalleNomina();
                                detnom.setEstatus(1);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setCotiza(0);
                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                if (mensual)
                                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();                                
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    //si la plaza tiene compensacion
                                    if (plz.getCompensacion() > 0){
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        //totpercep+=detnom.getMonto();
                                    }
                                
                                    //eliminar los movs extras de la plaza de la quincena siguiente
                                    Quincena quinsig = new Quincena();
                                    int aniosig = anio;
                                    if (quinact.getId()==24){
                                        quinsig.setId(1);
                                        aniosig++;
                                    }else
                                        quinsig.setId(quinact.getId()+1);
                                    movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);

                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                            } else {
                                //calcular su pago normalmente
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                                    //pago por dia
                                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                                    if (diasquin!=15){
                                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                        detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                                    } else {
                                        detnom.setMonto(plz.getSueldo());
                                    }
                                } else
                                    detnom.setMonto(plz.getSueldo());
                                detnom.setMovimiento(mov);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(0);
                                if (detnom.getMonto()>0){
                                    detnomdao.guardar(detnom);
                                    if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
                                        mov = cnomDao.obtenerPeryDed(2);
                                        detnom = new DetalleNomina();
                                        detnom.setMovimiento(mov);
                                        detnom.setMonto(plz.getCompensacion());
                                        detnom.setExento(mov.getGraoExe());
                                        detnom.setEstatus(1);
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);
                                        detnomdao.guardar(detnom);
                                        //totpercep+=detnom.getMonto();
                                    }

                                    //eliminar los movs extras de la plaza de la quincena siguiente
                                    Quincena quinsig = new Quincena();
                                    int aniosig = anio;
                                    if (quinact.getId()==24){
                                        quinsig.setId(1);
                                        aniosig++;
                                    }else
                                        quinsig.setId(quinact.getId()+1);
                                    movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);

                                    //genera detalle de los movs extras
                                    List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                                    for (int m=0; m < movs.size(); m++){
                                        MovimientoExtraordinario mext = movs.get(m);
                                        detnom = new DetalleNomina();
                                        detnom.setEstatus(1);
                                        detnom.setExento(mext.getPerded().getGraoExe());
                                        detnom.setMovimiento(mext.getPerded());
                                        detnom.setNomina(nom);
                                        detnom.setPlaza(plz);
                                        detnom.setCotiza(0);

                                        //calculo del monto segun el tipo de cambio del mov
                                        if (mext.getTipocambio().getId()==1){
                                            //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                            detnom.setMonto(mext.getImporte());
                                        } else if (mext.getTipocambio().getId()==2){
                                            //si el tipo cambio es dias
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                        } else if (mext.getTipocambio().getId()==3){
                                            //si el tipo cambio es horas
                                            //calcular el sueldo diario segun el periodo de pago de la plaza
                                            //el importe en este caso es el número de días
                                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                                            detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                        }
                                        /*if (detnom.getMovimiento().getPeroDed()==1)
                                            totpercep+=detnom.getMonto();
                                        else
                                            totdeduc+=detnom.getMonto();*/
                                        detnomdao.guardar(detnom);
                                        //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                        if (mext.getNumero()>1){
                                            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                            MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                            mextnvo.setEstatus(1);
                                            mextnvo.setImporte(mext.getImporte());
                                            mextnvo.setNumero(mext.getNumero()-1);
                                            mextnvo.setPerded(mext.getPerded());
                                            mextnvo.setPeriodo(mext.getPeriodo());
                                            mextnvo.setPlaza(mext.getPlaza());
                                            Quincena quin = new Quincena();
                                            if (mext.getQuincena().getId()==24){
                                                quin.setId(1);
                                                mextnvo.setAnio(mext.getAnio()+1);
                                            } else {
                                                quin.setId(mext.getQuincena().getId()+1);
                                                mextnvo.setAnio(mext.getAnio());
                                            }
                                            mextnvo.setQuincena(quin);
                                            mextnvo.setTipocambio(mext.getTipocambio());
                                            mextnvo.setTiponomina(mext.getTiponomina());
                                            mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                            mextnvo.setObservaciones(mext.getObservaciones());
                                            medao.guardar(mextnvo);
                                        }
                                    }//for movs
                                }
                            }
                        }
                    } else {
                        //si no tiene historial imss calcular su nomina usando el campo cotiza del empleado
                        float sueldoemp = plz.getSueldo();
                        float compensa = plz.getCompensacion();
                        if (plz.getEmpleado().getCotiza()==1){
                            sueldoemp = plz.getSueldocotiza();
                            compensa = plz.getCompensacioncotiza();
                        }
                        //calcular su pago normalmente
                        if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                            //pago por dia
                            int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                            if (diasquin!=15){
                                sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                            } else {
                                detnom.setMonto(sueldoemp);
                            }
                        } else
                            detnom.setMonto(sueldoemp);
                        detnom.setMovimiento(mov);
                        detnom.setNomina(nom);
                        detnom.setPlaza(plz);
                        detnom.setCotiza(plz.getEmpleado().getCotiza());
                        if (detnom.getMonto()>0){
                            detnomdao.guardar(detnom);
                            //totpercep+=detnom.getMonto();
                            if (compensa > 0){//si la plaza tiene compensacion
                                mov = cnomDao.obtenerPeryDed(2);
                                detnom = new DetalleNomina();
                                detnom.setMovimiento(mov);
                                detnom.setMonto(compensa);
                                detnom.setExento(mov.getGraoExe());
                                detnom.setEstatus(1);
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(plz.getEmpleado().getCotiza());
                                detnomdao.guardar(detnom);
                            }
                        
                            //eliminar los movs extras de la plaza de la quincena siguiente
                            Quincena quinsig = new Quincena();
                            int aniosig = anio;
                            if (quinact.getId()==24){
                                quinsig.setId(1);
                                aniosig++;
                            }else
                                quinsig.setId(quinact.getId()+1);
                            movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);

                            //genera detalle de los movs extras
                            List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
                            for (int m=0; m < movs.size(); m++){
                                MovimientoExtraordinario mext = movs.get(m);
                                detnom = new DetalleNomina();
                                detnom.setEstatus(1);
                                detnom.setExento(mext.getPerded().getGraoExe());
                                detnom.setMovimiento(mext.getPerded());
                                detnom.setNomina(nom);
                                detnom.setPlaza(plz);
                                detnom.setCotiza(plz.getEmpleado().getCotiza());

                                //calculo del monto segun el tipo de cambio del mov
                                if (mext.getTipocambio().getId()==1){
                                    //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                                    detnom.setMonto(mext.getImporte());
                                } else if (mext.getTipocambio().getId()==2){
                                    //si el tipo cambio es dias
                                    //calcular el sueldo diario segun el periodo de pago de la plaza
                                    //el importe en este caso es el número de días
                                    sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                        sueldodiario = new Double(utmod.Redondear(sueldoemp/30,2)).floatValue();

                                    detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
                                } else if (mext.getTipocambio().getId()==3){
                                    //si el tipo cambio es horas
                                    //calcular el sueldo diario segun el periodo de pago de la plaza
                                    //el importe en este caso es el número de días
                                    sueldodiario = new Double(utmod.Redondear(sueldoemp/15,2)).floatValue();
                                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                                        sueldodiario = new Double(utmod.Redondear(sueldoemp/30,2)).floatValue();

                                    detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
                                }
                                detnomdao.guardar(detnom);
                                //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
                                if (mext.getNumero()>1){
                                    MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                                    MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                                    mextnvo.setEstatus(1);
                                    mextnvo.setImporte(mext.getImporte());
                                    mextnvo.setNumero(mext.getNumero()-1);
                                    mextnvo.setPerded(mext.getPerded());
                                    mextnvo.setPeriodo(mext.getPeriodo());
                                    mextnvo.setPlaza(mext.getPlaza());
                                    Quincena quin = new Quincena();
                                    if (mext.getQuincena().getId()==24){
                                        quin.setId(1);
                                        mextnvo.setAnio(mext.getAnio()+1);
                                    } else {
                                        quin.setId(mext.getQuincena().getId()+1);
                                        mextnvo.setAnio(mext.getAnio());
                                    }
                                    mextnvo.setQuincena(quin);
                                    mextnvo.setTipocambio(mext.getTipocambio());
                                    mextnvo.setTiponomina(mext.getTiponomina());
                                    mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                                    mextnvo.setObservaciones(mext.getObservaciones());
                                    medao.guardar(mextnvo);
                                }
                            }//for movs
                        }
                    }
                //FIN CONSIDERAR LAS FECHAS DE ALTA Y BAJA DEL IMSS DEL EMPLEADO
                
            }
            
        }
        /*int tope = 1;
        StringTokenizer tokens = null;
        if (!varios.equals("0")){
            tokens=new StringTokenizer(varios, ",");
            tope = tokens.countTokens();
        }
        
        
        for (int i = 1; i <= tope; i++){
            plz.setId(Integer.parseInt(tokens.nextToken()));
            
            plz = plzdao.obtener(plz.getId());
            datos.put("plaza", plz);

            DetalleNominaDao detnomdao = new DetalleNominaDao();
        /*int estatus = detnomdao.obtenerEstatusDePlazaEnNomina(plz.getId(), nom.getId());
        if (estatus==1){//no pagado
        //borra el detalle actual (excepto las plazas ya pagadas)
        detnomdao.eliminaDetalleDePlazaEnNomina(nom.getId(), plz.getId());
        
        Quincena quinact = nom.getQuincena();
        int anio = nom.getAnio();
        
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        CatNominaDao cnomDao = new CatNominaDao();
        UtilMod utmod = new UtilMod();
        
        //genera detalle del salario de la plaza
        DetalleNomina detnom = new DetalleNomina();
        PeryDed mov = cnomDao.obtenerPeryDed(1);
        detnom.setEstatus(1);
        detnom.setExento(mov.getGraoExe());
        if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
            //pago por dia
            int diasquin = (quinact.getFin()-quinact.getInicio())+1;
            float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
        } else
            detnom.setMonto(plz.getSueldo());
        detnom.setMovimiento(mov);
        detnom.setNomina(nom);
        detnom.setPlaza(plz);
        detnomdao.guardar(detnom);
        if (plz.getCompensacion() > 0){//si la plaza tiene compensacion
            mov = cnomDao.obtenerPeryDed(2);
            detnom = new DetalleNomina();
            detnom.setMovimiento(mov);
            detnom.setMonto(plz.getCompensacion());
            detnom.setExento(mov.getGraoExe());
            detnom.setEstatus(1);
            detnom.setNomina(nom);
            detnom.setPlaza(plz);
            detnomdao.guardar(detnom);
        }
        //eliminar los movs extras de la plaza de la quincena siguiente
        Quincena quinsig = new Quincena();
        int aniosig = anio;
        if (quinact.getId()==24){
            quinsig.setId(1);
            aniosig++;
        }else
            quinsig.setId(quinact.getId()+1);
        movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
        
        //genera detalle de los movs extras
        List<MovimientoExtraordinario> movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), anio, 1);
        for (int m=0; m < movs.size(); m++){
            MovimientoExtraordinario mext = movs.get(m);
            detnom = new DetalleNomina();
            detnom.setEstatus(1);
            detnom.setExento(mext.getPerded().getGraoExe());
            detnom.setMovimiento(mext.getPerded());
            detnom.setNomina(nom);
            detnom.setPlaza(plz);
            //calculo del monto segun el tipo de cambio del mov

            if (mext.getTipocambio().getId()==1){
                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                detnom.setMonto(mext.getImporte());
            } else if (mext.getTipocambio().getId()==2){
                //si el tipo cambio es dias
                //calcular el sueldo diario segun el periodo de pago de la plaza
                //el importe en este caso es el número de días
                float sueldodiario = plz.getSueldo()/15;
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = plz.getSueldo()/30;

                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte(),2));
            } else if (mext.getTipocambio().getId()==3){
                //si el tipo cambio es horas
                //calcular el sueldo diario segun el periodo de pago de la plaza
                //el importe en este caso es el número de días
                float sueldodiario = plz.getSueldo()/15;
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = plz.getSueldo()/30;

                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte(),2));
            }
            detnomdao.guardar(detnom);
            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
            if (mext.getNumero()>1){                            
                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                mextnvo.setEstatus(1);
                mextnvo.setImporte(mext.getImporte());
                mextnvo.setNumero(mext.getNumero()-1);
                mextnvo.setPerded(mext.getPerded());
                mextnvo.setPeriodo(mext.getPeriodo());
                mextnvo.setPlaza(mext.getPlaza());
                Quincena quin = new Quincena();
                if (mext.getQuincena().getId()==24){
                    quin.setId(1);
                    mextnvo.setAnio(mext.getAnio()+1);
                } else {
                    quin.setId(mext.getQuincena().getId()+1);
                    mextnvo.setAnio(mext.getAnio());
                }
                mextnvo.setQuincena(quin);
                mextnvo.setTipocambio(mext.getTipocambio());
                mextnvo.setTiponomina(mext.getTiponomina());
                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                mextnvo.setObservaciones(mext.getObservaciones());
                medao.guardar(mextnvo);
            }
            
        }//for movs
        }//if no pagado
        }*///for cada plaza
        int recalculanomina = datos.get("recalculanomina")!=null?Integer.parseInt(datos.get("recalculanomina").toString()):0;
        if (recalculanomina==0)
            datos = ObtenerNomina(datos);
        datos.remove("varios");
        
        return datos;
    }

    private HashMap BajaDePlaza(HashMap datos) {
        String varios = datos.get("varios").toString();
        Nomina nom = (Nomina)datos.get("nomina");
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        /*if (varios.equals("0")){
            Plaza plz = (Plaza)datos.get("plaza");
            detnomdao.cambiaEstatusDePlazaEnNomina(plz.getId(), nom.getId(), 0);
        } else {*/
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        VacacionesDao vacdao = new VacacionesDao();
        MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
            StringTokenizer tokens=new StringTokenizer(varios, ",");
            while(tokens.hasMoreTokens()){
                int i = Integer.parseInt(tokens.nextToken());
                HashMap detalle = listado.get(i);
                Plaza plz = (Plaza)detalle.get("plaza");
                int cotiza = ((Integer)detalle.get("cotiza")).intValue();
                detnomdao.cambiaEstatusPagoAPlazaEnNomina(nom.getId(), plz.getId(), cotiza, 0);
                //detnomdao.cambiaEstatusDePlazaEnNomina(Integer.parseInt(tokens.nextToken()), nom.getId(), 0);
                //actualizar estatus de vacaciones del empleado
                Vacaciones vacas = vacdao.obtenerVacacionesDeEmpleadoYNomina(plz.getEmpleado().getNumempleado(), nom.getId());
                if (vacas!=null){
                    vacdao.eliminar(vacas);
                }
                //eliminar los movs extras de las vacaciones y de la prima vacacional
                List<MovimientoExtraordinario> mext = medao.obtenerListaActivosDePlazayQuincena(plz.getId(), nom.getQuincena().getId(), nom.getAnio());
                if (mext!=null){
                    for (int m=0; m < mext.size(); m++){
                        MovimientoExtraordinario me = mext.get(m);
                        if (me.getPerded().getIdPeryded()==6 || me.getPerded().getIdPeryded()==7){
                            medao.eliminar(me);
                        }
                    }
                }
            }
        //}
        datos = ObtenerNomina(datos);
        datos.remove("varios");
        return datos;
    }

    private HashMap ObtenerSoloNomina(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        NominaDao nomDao = new NominaDao();
        nom = nomDao.obtener(nom.getId());
        datos.put("nomina", nom);
        return datos;
    }

    private HashMap ObtenerCuentasTelecomm(HashMap datos) {
        CuentasTelecommDao ctadao = new CuentasTelecommDao();
        datos.put("cuentas", ctadao.obtenerListaActivas());
        return datos;
    }

    private HashMap ObtenerBancos(HashMap datos) {
        BancoDao bandao = new BancoDao();
        datos.put("bancos", bandao.obtenerListaActivos());
        return datos;
    }

    private HashMap ObtenerDetalleFormatosPago(HashMap datos) {
        HashMap criterios = (HashMap)datos.get("criterios");
        int nivel = Integer.parseInt(criterios.get("nivel").toString());
        int pago = Integer.parseInt(criterios.get("formapago").toString());
        int cuenta = Integer.parseInt(criterios.get("cuenta").toString());
        int cotiza = criterios.get("cotiza")!=null?Integer.parseInt(criterios.get("cotiza").toString()):0;
        datos = ObtenerNomina(datos);
        Nomina nom = (Nomina)datos.get("nomina");
        //DetalleNominaDao detnomDao = new DetalleNominaDao();
        //float totnomina = detnomDao.obtenerTotalDeNomina(nom.getId());
        
        //bajar totales de nomina seleccionada
        List<HashMap> tots = (List<HashMap>)datos.get("totalesnom");
        List<Nomina> nominas = (List<Nomina>)datos.get("nominas");
        for (int t=0; t < tots.size(); t++){
            Nomina n = nominas.get(t);
            if (n.getId()==nom.getId()){
                datos.put("totsdenom",(HashMap)tots.get(t));
                break;
            }
        }
        
        float totaplicar = 0;
        UtilMod utmod = new UtilMod();
        //datos.put("totalnomina", Float.toString((float)utmod.Redondear(totnomina,2)));
        List<HashMap> detnomfp = new ArrayList<HashMap>();
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompleta");
        for (int i=0; i < detnomina.size(); i++){
            HashMap det = detnomina.get(i);
            if (!det.get("estatus").toString().equals("PAGADO")){
                Plaza plz = (Plaza) det.get("plaza");
                int dtcot = ((Integer)det.get("cotiza")).intValue();
                if (plz.getFormapago()==pago){
                    if (nivel==0 || plz.getNivel()==nivel){
                        switch (pago){
                            case 1: //deposito
                                if (plz.getEmpleado().getBanco()!=null && plz.getEmpleado().getBanco().getId()==cuenta){
                                    if (dtcot==cotiza){
                                        //if (plz.getEmpleado().getCotiza()==cotiza){
                                        detnomfp.add(det);
                                        totaplicar+=Float.parseFloat(det.get("neto").toString());
                                    }
                                }
                                break;
                            case 2: case 3://efectivo || telecomm
                                if (dtcot==cuenta){
                                    //if (plz.getEmpleado().getCotiza()==cuenta){
                                    detnomfp.add(det);
                                    totaplicar+=Float.parseFloat(det.get("neto").toString());
                                }
                                break;
                        }//sw pago
                    }//if nivel
                }//forma de pago
            }//if no pagado
        }
        datos.put("totalaplicar", Float.toString((float)utmod.Redondear(totaplicar,2)));
        datos.put("detallenominafp", detnomfp);
        datos.put("criterios", criterios);
        return datos;
    }

    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }
    
    private HashMap ImprimirXls(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("reportexls", util.generarXLS(datos.get("reporte").toString(), (Map)datos.get("parametros"), datos.get("temp").toString()));
        return datos;
    }

    private HashMap ObtenerSucursales(HashMap datos) {
        SucursalDao sucdao = new SucursalDao();
        datos.put("sucursales", sucdao.obtenerListaSucYMatriz());
        return datos;
    }

    private HashMap ValidarNuevaNomina(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        
        List<Sucursal> sucursales = (List<Sucursal>)datos.get("sucursales");
        String bannueva = "0";
        NominaDao nomdao = new NominaDao();
        for (int i=0; i < sucursales.size(); i++){
            Sucursal suc = sucursales.get(i);
            if (!nomdao.existeNominaDeSucursalEnQuinYAnio(anioact, quinact.getId(), suc.getId())){
                bannueva = "1";
                break;
            }
        }
        datos.put("bannominaact", bannueva);
        return datos;
    }

    private HashMap ObtenerSucursalesSinNomina(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        
        List<Sucursal> sucursales = (List<Sucursal>)datos.get("sucursales");
        List<Sucursal> sucdisp = new ArrayList<Sucursal>();
        NominaDao nomdao = new NominaDao();
        for (int i=0; i < sucursales.size(); i++){
            Sucursal suc = sucursales.get(i);
            if (!nomdao.existeNominaDeSucursalEnQuinYAnio(anioact, quinact.getId(), suc.getId())){
                sucdisp.add(suc);
            }
        }
        datos.put("sucursalesdisp", sucdisp);
        return datos;
    }

    private HashMap CerrarQuincena(HashMap datos) {
        //cerrar todas las nominas
        List<Nomina> nominas = (List<Nomina>)datos.get("nominas");
        for (int i=0; i < nominas.size(); i++){
            Nomina nom = nominas.get(i);
            datos.put("nomina", nom);
            datos = CerrarNomina(datos);
        }
        
        //actualizar la quincena activa
        Quincena quinact = (Quincena)datos.get("quinactiva");
        QuincenaDao quindao = new QuincenaDao();
        //desactivar la quincena activa actual
        quindao.actualizaEstatusActiva(quinact.getId(), 0);
        //poner como activa la quincena siguiente
        if (quinact.getId()==24)
            quindao.actualizaEstatusActiva(1, 1);
        else
            quindao.actualizaEstatusActiva(quinact.getId()+1, 1);
        datos = ObtenerQuincenaActiva(datos);
        datos = ObtenerNominas(datos);
        datos = ValidarNuevaNomina(datos);
        return datos;
    }

    private HashMap QuitarPagoDePlaza(HashMap datos) {
        String varios = datos.get("varios").toString();        
        /*PlazaDao plzdao = new PlazaDao();
        Plaza plz = (Plaza)datos.get("plaza");
        plz = plzdao.obtener(plz.getId());
        datos.put("plaza", plz);*/
        Nomina nom = (Nomina)datos.get("nomina");
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        //detnomdao.cambiaEstatusDePlazaEnNomina(plz.getId(), nom.getId(), 1);
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        VacacionesDao vacdao = new VacacionesDao();
            StringTokenizer tokens=new StringTokenizer(varios, ",");
            while(tokens.hasMoreTokens()){
                int i = Integer.parseInt(tokens.nextToken());
                HashMap detalle = listado.get(i);
                Plaza plz = (Plaza)detalle.get("plaza");
                int cotiza = ((Integer)detalle.get("cotiza")).intValue();
                detnomdao.cambiaEstatusPagoAPlazaEnNomina(nom.getId(), plz.getId(), cotiza, 1);
                //detnomdao.cambiaEstatusDePlazaEnNomina(Integer.parseInt(tokens.nextToken()), nom.getId(), 2);
                //actualizar estatus de vacaciones del empleado
                Vacaciones vacas = vacdao.obtenerVacacionesDeEmpleadoYNominaPagadas(plz.getEmpleado().getNumempleado(), nom.getId());
                if (vacas!=null){
                    vacas.setEstatus(1);
                    vacdao.actualizar(vacas);
                }
                
            }
        datos = ObtenerNomina(datos);
        datos.remove("varios");
        return datos;
    }

    private HashMap IrAConsultarNominas(HashMap datos) {
        int anio = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        //obtener años registrados en la base de datos
        NominaDao nomdao = new NominaDao();
        List<Integer> anioshis = nomdao.obtenerAniosHistoricos();
        List<Quincena> quinhis = nomdao.obtenerQuincenasHistoricasDeAnio(anio);
        if (quinhis.isEmpty()){
            //ir al año ultimo donde si hay histórico
            //hasta 5 años atrás
            int c=0;
            do{
                anio--;
                quinhis = nomdao.obtenerQuincenasHistoricasDeAnio(anio);
                c++;
            } while (quinhis.isEmpty() || c>5);
        }
        //quitar la quincena activa
        for (int i=0; i < quinhis.size(); i++){
            Quincena quin = quinhis.get(i);
            if (quin.getId()==quinact.getId()){
                quinhis.remove(i);
                break;
            }
        }
        datos.put("anioshis", anioshis);
        datos.put("quinhis", quinhis);
        datos.put("aniohissel", Integer.toString(anio));
        Quincena qsel = new Quincena();
        if (!quinhis.isEmpty())
            qsel = quinhis.get(0);
        datos.put("quinhissel", qsel);
        datos = ObtenerNominasHistoricasDeAnioYQuin(datos);
        return datos;
    }

    private HashMap ObtenerNominasHistoricasDeAnioYQuin(HashMap datos) {
        int aniohissel = Integer.parseInt(datos.get("aniohissel").toString());
        Quincena quinhissel = (Quincena)datos.get("quinhissel");
        NominaDao nomdao = new NominaDao();
        DetalleNominaDao detnomDao = new DetalleNominaDao();
        List<Nomina> nominas =nomdao.obtenerListaActivasNormalesDeQuinYAnio(aniohissel, quinhissel.getId());
        datos.put("nominashis", nominas);
        //obtener los totales
        List<HashMap> totales = new ArrayList<HashMap>();
        HashMap totalesgen = new HashMap();
        float totnomgen = 0;//, totpaggen = 0, totporpaggen = 0;
        UtilMod utmod = new UtilMod();
        for (int i=0; i < nominas.size(); i++){
            Nomina nom = nominas.get(i);
            /*if (nom.getAnio()==anioact && nom.getQuincena().getId()==quinact.getId()){
                nomactiva = "1";
            }*/
            float totnomina = detnomDao.obtenerTotalDeNomina(nom.getId());
            //float pagado = detnomDao.obtenerTotalPagadoDeNomina(nom.getId());
            //float porpagar = totnomina - pagado;
            
            totnomgen+=totnomina;
            //totpaggen+=pagado;
            //totporpaggen+=porpagar;
            
            HashMap tots = new HashMap();
            tots.put("totalnomina", Float.toString((float)utmod.Redondear(totnomina,2)));
            //tots.put("pagado", Float.toString((float)utmod.Redondear(pagado,2)));
            //tots.put("porpagar", Float.toString((float)utmod.Redondear(porpagar,2)));
            totales.add(tots);
        }
        totalesgen.put("totnomgen", Float.toString(totnomgen));
        //totalesgen.put("totpaggen", Float.toString(totpaggen));
        //totalesgen.put("totporpaggen", Float.toString(totporpaggen));
        datos.put("totalesnomhis", totales);
        datos.put("totalesgenhis", totalesgen);
        
        return datos;
    }

    private HashMap ObtenerQuincenasDeAnioSel(HashMap datos) {
        int anio = Integer.parseInt(datos.get("anio").toString());
        int aniosel = Integer.parseInt(datos.get("aniohissel").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        //obtener años registrados en la base de datos
        NominaDao nomdao = new NominaDao();
        List<Quincena> quinhis = nomdao.obtenerQuincenasHistoricasDeAnio(aniosel);
        if (aniosel==anio){
            //quitar la quincena activa
            for (int i=0; i < quinhis.size(); i++){
                Quincena quin = quinhis.get(i);
                if (quin.getId()==quinact.getId()){
                    quinhis.remove(i);
                    break;
                }
            }
        }
        datos.put("quinhis", quinhis);
        datos.put("aniohissel", Integer.toString(aniosel));
        datos.put("quinhissel", quinhis.get(0));
        datos = ObtenerNominasHistoricasDeAnioYQuin(datos);
        return datos;
    }

    private HashMap ObtenerNominasDeAnioYQuinSel(HashMap datos) {
        Quincena quinsel = (Quincena)datos.get("quinhissel");
        QuincenaDao quindao = new QuincenaDao();
        quinsel = quindao.obtener(quinsel.getId());
        datos.put("quinhissel", quinsel);
        datos = ObtenerNominasHistoricasDeAnioYQuin(datos);
        return datos;
    }

    private HashMap IrANominasDeAguinaldos(HashMap datos) {
        datos = ObtenerNominasAguinaldos(datos);
        datos = ValidarNuevaNominaAguinaldos(datos);
        return datos;
    }

    private HashMap ObtenerNominasAguinaldos(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anio").toString());
        NominaDao nomDao = new NominaDao();
        DetalleNominaDao detnomDao = new DetalleNominaDao();
        List<Nomina> nominas = nomDao.obtenerListaActivasAguinaldoDeAnio(anioact);
        datos.put("nominasagui", nominas);
        //checar si ya hay nómina generada en la quincena activa y año actual
        //para cada nomina obtener el total, total pagado, y por pagar
        //String nomactiva = "0";
        List<HashMap> totales = new ArrayList<HashMap>();
        HashMap totalesgen = new HashMap();
        float totnomgen = 0, totpaggen = 0, totporpaggen = 0;
        UtilMod utmod = new UtilMod();
        for (int i=0; i < nominas.size(); i++){
            Nomina nom = nominas.get(i);
            /*if (nom.getAnio()==anioact && nom.getQuincena().getId()==quinact.getId()){
                nomactiva = "1";
            }*/
            float totnomina = detnomDao.obtenerTotalDeNomina(nom.getId());
            float pagado = detnomDao.obtenerTotalPagadoDeNomina(nom.getId());
            float porpagar = totnomina - pagado;
            
            totnomgen+=totnomina;
            totpaggen+=pagado;
            totporpaggen+=porpagar;
            
            HashMap tots = new HashMap();
            tots.put("totalnomina", Float.toString((float)utmod.Redondear(totnomina,2)));
            tots.put("pagado", Float.toString((float)utmod.Redondear(pagado,2)));
            tots.put("porpagar", Float.toString((float)utmod.Redondear(porpagar,2)));
            totales.add(tots);
        }
        totalesgen.put("totnomgen", Float.toString(totnomgen));
        totalesgen.put("totpaggen", Float.toString(totpaggen));
        totalesgen.put("totporpaggen", Float.toString(totporpaggen));
        datos.put("totalesnomagui", totales);
        datos.put("totalesgenagui", totalesgen);
        
        return datos;
    }

    private HashMap ValidarNuevaNominaAguinaldos(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anio").toString());
        
        List<Sucursal> sucursales = (List<Sucursal>)datos.get("sucursales");
        String bannueva = "0";
        NominaDao nomdao = new NominaDao();
        for (int i=0; i < sucursales.size(); i++){
            Sucursal suc = sucursales.get(i);
            if (!nomdao.existeNominaAguinaldoDeSucursalEnAnio(anioact, suc.getId())){
                bannueva = "1";
                break;
            }
        }
        datos.put("bannominaactagui", bannueva);
        return datos;
    }

    private HashMap ObtenerSucursalesSinNominaAguinaldos(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anio").toString());
        //Quincena quinact = (Quincena)datos.get("quinactiva");
        
        List<Sucursal> sucursales = (List<Sucursal>)datos.get("sucursales");
        List<Sucursal> sucdisp = new ArrayList<Sucursal>();
        NominaDao nomdao = new NominaDao();
        for (int i=0; i < sucursales.size(); i++){
            Sucursal suc = sucursales.get(i);
            if (!nomdao.existeNominaAguinaldoDeSucursalEnAnio(anioact, suc.getId())){
                sucdisp.add(suc);
            }
        }
        datos.put("sucursalesdispagui", sucdisp);
        return datos;
    }

    private HashMap GenerarNominaAguinaldos(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalsel");
        SucursalDao sucdao = new SucursalDao();
        suc = sucdao.obtener(suc.getId());
        int anio = Integer.parseInt(datos.get("anio").toString());
        //Quincena quinact = (Quincena)datos.get("quinactiva");
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(anio+1)+"-01-01";
        String finiquin = Integer.toString(anio)+"-01-01";
        String ffinanio = Integer.toString(anio)+"-12-31";
        SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
        Date iniquin = null, finquin = null, finanio = null;
        try {
            iniquin = ffecha.parse(finiquin);
            finquin = ffecha.parse(ffinquin);
            finanio = ffecha.parse(ffinanio);
        } catch (ParseException ex) {
            Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        //crear la nomina
        TipoNomina tiponom = new TipoNomina();
        tiponom.setIdTnomina(4);
        Nomina nom = new Nomina();
        nom.setAnio(anio);
        nom.setEstatus(1);
        nom.setSucursal(suc);
        UtilDao utdao = new UtilDao();
        nom.setFecha(utdao.hoy());
        //nom.setQuincena(null);
        nom.setTiponomina(tiponom);
        NominaDao nomdao = new NominaDao();
        nomdao.guardar(nom);
        datos.put("nominaagui", nom);
        
        //generar el detalle de la nomina
        
        //Definir el listado del detalle de nomina
        List<HashMap> detalle = new ArrayList<HashMap>();

        float totnomina = 0;
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        CatNominaDao cnomDao = new CatNominaDao();
        AguinaldoDao agdao = new AguinaldoDao();
        UtilMod utmod = new UtilMod();
        EmpleadoDao empdao = new EmpleadoDao();
        
        List<Empleado> emples = empdao.obtenerListaActivosDeSucursal(suc.getId());
        PeryDed mov = cnomDao.obtenerPeryDed(10);
        for (int i=0; i < emples.size(); i++){
            //obtener ultima plaza del año actual de cada empleado
            Empleado emp = emples.get(i);
            Plaza pzemp = plzdao.obtenerUltimaPlazaDeEmpleadoEnElAnioEnSucursal(emp.getNumempleado(), finiquin, suc.getId());
            HashMap detallenom = new HashMap();
            
            //checar si el empleado tiene una plaza registrada
            float sueldodiario = 0;
            if (pzemp!=null){
                detallenom.put("plaza", pzemp);
                sueldodiario = new Double(utmod.Redondear(pzemp.getSueldo()/15,2)).floatValue();
                if (Integer.parseInt(pzemp.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(pzemp.getSueldo()/30,2)).floatValue();
                //obtener días trabajados en el año
                List<Plaza> plazas = plzdao.obtenerPlazasDeEmpleadoEnElAnioEnSucursal(emp.getNumempleado(), finiquin, suc.getId());
                int diastrab = 0, faltas = 0, diasnetos = 0;
                float monto = 0.0f, diasagui = 0.0f;
                Date fechaAux = null;
                Date fecha2 = finquin, fecha1 = iniquin;
                for (int p=0; p < plazas.size(); p++){
                    Plaza plz = plazas.get(p);
                    
                    if (plz.getFechaalta().after(iniquin))
                        fecha1 = plz.getFechaalta();
                    
                    if (plz.getFechabaja()==null){
                        if (plz.getContrato().getFechaFin().before(finquin)){
                            fecha2 = plz.getContrato().getFechaFin();
                        } else {
                            fecha2 = finquin;
                        }
                    } else {
                        fecha2 = plz.getFechabaja();
                    }
                    
                    if (fecha2.equals(finanio))
                        fecha2 = finquin;
                    
                    if (p>0){
                        if (fecha1.after(fechaAux) || fecha1.equals(fechaAux)){
                            diastrab += utmod.DiasEntreFechas(fecha1, fecha2);
                            faltas += movdao.obtenerFaltasDePlazaEnElAnio(plz.getId(), anio);
                            fechaAux = fecha2;
                        } else {
                            if (!fechaAux.equals(finquin) && (plz.getFechabaja()==null || plz.getFechabaja().after(fechaAux))){
                                diastrab += utmod.DiasEntreFechas(fechaAux, fecha2);
                                faltas += movdao.obtenerFaltasDePlazaEnElAnio(plz.getId(), anio);
                                fechaAux = fecha2;
                            }
                        }
                    } else {
                        diastrab += utmod.DiasEntreFechas(fecha1, fecha2);
                        faltas += movdao.obtenerFaltasDePlazaEnElAnio(plz.getId(), anio);
                        fechaAux = fecha2;
                    }
                }
                //obtener faltas en el año
                //faltas = movdao.obtenerTotalFaltasEmpleadoEnElAnio(emp.getNumempleado(), anio);
                //calcular dias trabajados netos
                diasnetos = diastrab - faltas;
                //calcular dias de aguinaldo a pagar
                //float fda = (diasnetos*15)/365.0f;
                diasagui = (new Double(utmod.Redondear((diasnetos*15)/365.0f,4))).floatValue();
                if (diasagui>0){
                    //calcular monto de aguinaldo
                    monto = (new Double(utmod.Redondear(sueldodiario*diasagui,0))).floatValue();
                    //calcular cotiza o no cotiza
                    HistorialIMSSDao hidao = new HistorialIMSSDao();
                    List<HistorialIMSS> historial = hidao.obtenerHistorialDeEmpleado(emp.getNumempleado());
                    int cotiza = 0;
                    if (historial!=null && !historial.isEmpty()){
                        HistorialIMSS hiemp = historial.get(0);
                        if (hiemp.getFechabaja()==null)
                            cotiza = 1;
                    }
                    //guardar el detalle
                    DetalleNomina detnom = new DetalleNomina();
                    detnom.setCotiza(cotiza);
                    detnom.setEstatus(1);
                    detnom.setExento(mov.getGraoExe());
                    detnom.setMonto(monto);
                    detnom.setMovimiento(mov);
                    detnom.setNomina(nom);
                    detnom.setPlaza(pzemp);
                    detnomdao.guardar(detnom);
                    //guardar el aguinaldo
                    Aguinaldo agui = new Aguinaldo();
                    agui.setAnio(anio);
                    agui.setDiasaguinaldo(diasagui);
                    agui.setDiastrabajadosbrutos(diastrab);
                    agui.setEmpleado(emp);
                    agui.setFaltas(faltas);
                    agui.setMontoaguinaldo(monto);
                    agui.setSueldodiario(sueldodiario);
                    agdao.guardar(agui);
                    //agregar al hash del detalle
                    detallenom.put("iddet", new Integer(detnom.getId()));
                    detallenom.put("diastrab", new Integer(diastrab));
                    detallenom.put("faltas", new Integer(faltas));
                    detallenom.put("diasnetos", new Integer(diasnetos));
                    detallenom.put("diasaguinaldo", new Float(diasagui));
                    detallenom.put("sueldodia", new Float(sueldodiario));
                    detallenom.put("montoagui", new Float(monto));
                    detallenom.put("cotiza", new Integer(cotiza));
                    detallenom.put("estatus", "POR PAGAR");
                    detalle.add(detallenom);
                    totnomina+=monto;
                }
            }            
        }
        datos.put("listacompletaagui", detalle);
        if (detalle.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos = ObtenerGrupoAguinaldo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("detallenominaagui", detalle);
        }
        datos.put("totalnominaagui", totnomina);
        
        return datos;
    }

    private HashMap ObtenerGrupoAguinaldo(HashMap datos) {
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompletaagui");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<HashMap> grupo = new ArrayList<HashMap>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin > detnomina.size()){
            fin = detnomina.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(detnomina.get(i));
        }
        datos.put("detallenominaagui", grupo);
        return datos;
    }
    
    private HashMap CargarSiguientesAgui(HashMap datos) {
        int fin = Integer.parseInt(datos.get("final").toString());
        datos.put("inicial", Integer.toString(fin+1));
        datos = ObtenerGrupoAguinaldo(datos);
        return datos;
    }
    
    private HashMap CargarAnterioresAgui(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicial").toString())-grupos;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupoAguinaldo(datos);
        return datos;
    }

    private HashMap CargarPrincipioAgui(HashMap datos) {
        datos.put("inicial", "1");
        datos = ObtenerGrupoAguinaldo(datos);        
        return datos;
    }

    private HashMap CargarFinalAgui(HashMap datos) {
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompletaagui");
        int total = detnomina.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupoAguinaldo(datos);
        return datos;
    }
    
    private HashMap ObtenerNominaAguinaldos(HashMap datos) {
        Nomina nom = datos.get("nomina")!=null?(Nomina)datos.get("nomina"):(Nomina)datos.get("nominaagui");
        NominaDao nomDao = new NominaDao();
        nom = nomDao.obtener(nom.getId());
        datos.remove("nomina");
        datos.put("nominaagui", nom);
        //List<HashMap> detnomina = new ArrayList<HashMap>();
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        AguinaldoDao aguidao = new AguinaldoDao();
        
        int pago = Integer.parseInt(datos.get("estatus")!=null?datos.get("estatus").toString():"0");
        int bcotiza = Integer.parseInt(datos.get("bcotiza")!=null?datos.get("bcotiza").toString():"-1");
        datos.put("estatus", Integer.toString(pago));
        datos.put("bcotiza", Integer.toString(bcotiza));
        //NUEVA ESTRUCTURA DEL DETALLE DE NOMINA
        List<HashMap> detallenomina = new ArrayList<HashMap>();
        List<DetalleNomina> detnom = detnomdao.obtenerDetallesDeNominaConEstatusYCotiza(nom.getId(), pago, bcotiza);
        //List<Plaza> plazasdet = detnomdao.obtenerPlazasDeNomina(nom.getId());
        for (int p=0; p < detnom.size(); p++){
            DetalleNomina dn = detnom.get(p);
            HashMap detalle = new HashMap();
            detalle.put("iddet", new Integer(dn.getId()));
            detalle.put("plaza", dn.getPlaza());
            //obtener datos del aguinaldo del empleado
            Aguinaldo agui = aguidao.obtenerAguinaldoDeEmpleadoEnElAnio(dn.getPlaza().getEmpleado().getNumempleado(), nom.getAnio());
            
            detalle.put("diastrab", new Integer(agui.getDiastrabajadosbrutos()));
            detalle.put("faltas", new Integer(agui.getFaltas()));
            detalle.put("diasnetos", new Integer(agui.getDiastrabajadosbrutos()-agui.getFaltas()));
            detalle.put("diasaguinaldo", new Float(agui.getDiasaguinaldo()));
            detalle.put("sueldodia", new Float(agui.getSueldodiario()));
            detalle.put("montoagui", new Float(agui.getMontoaguinaldo()));
            detalle.put("cotiza", new Integer(dn.getCotiza()));
            String estatus = "POR PAGAR";
            int ipago = 0;
            if (dn.getEstatus()==2){
                estatus = "PAGADO";
                ipago = 1;
            }
            detalle.put("estatus", estatus);
            //if (pago==ipago && (bcotiza==-1 || bcotiza==dn.getCotiza())){
            detallenomina.add(detalle);
            //}
        }
        datos.put("listacompletaagui", detallenomina);
        if (detallenomina.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos = ObtenerGrupoAguinaldo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("detallenominaagui", detallenomina);
        }            
        
        return datos;
    }

    private HashMap ObtenerDetalleAEditarNominaAguinaldos(HashMap datos) {
        String indices = datos.get("varios").toString();
        int ind = Integer.parseInt(indices);
        List<HashMap> detnomina =(List<HashMap>)datos.get("detallenominaagui");
        HashMap detsel = detnomina.get(ind);
        
        //obtener el detalle de la base de datos
        DetalleNominaDao dndao = new DetalleNominaDao();
        int idsel = Integer.parseInt(detsel.get("iddet").toString());
        DetalleNomina det = dndao.obtener(idsel);
        
        //obtener el registro de aguinaldo del empleado
        AguinaldoDao agdao = new AguinaldoDao();
        Aguinaldo agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(det.getPlaza().getEmpleado().getNumempleado(), det.getNomina().getAnio());
        
        datos.put("detnomedit", det);
        datos.put("aguinaldo", agui);
        
        return datos;
    }

    private HashMap GuardarDetalleAguinaldoEditado(HashMap datos) {
        AguinaldoDao agdao = new AguinaldoDao();
        Aguinaldo agui = (Aguinaldo)datos.get("aguinaldo");
        agdao.actualizar(agui);
        
        DetalleNominaDao dndao = new DetalleNominaDao();
        
        DetalleNomina det = (DetalleNomina) datos.get("detnomedit");
        det.setMonto(agui.getMontoaguinaldo());
        dndao.actualizar(det);
        
        /*Nomina nom = (Nomina)datos.get("nominaagui");
        datos.put("nomina", nom);*/
        
        datos = ObtenerNominaAguinaldos(datos);
        
        datos.remove("detnomedit");
        datos.remove("varios");
        datos.remove("aguinaldo");
        
        return datos;
    }

    private HashMap PagarAguinaldos(HashMap datos) {
        String varios = datos.get("varios").toString();
        StringTokenizer tokens=new StringTokenizer(varios, ",");
        List<HashMap> detnomina =(List<HashMap>)datos.get("detallenominaagui");
        Nomina nom = (Nomina)datos.get("nominaagui");
        DetalleNominaDao dndao = new DetalleNominaDao();
        AguinaldoDao agdao = new AguinaldoDao();
        
        while(tokens.hasMoreTokens()){
            int i = Integer.parseInt(tokens.nextToken());
            HashMap detalle = detnomina.get(i);
            Plaza plz = (Plaza)detalle.get("plaza");
            int cotiza = ((Integer)detalle.get("cotiza")).intValue();
            dndao.cambiaEstatusPagoAPlazaEnNomina(nom.getId(), plz.getId(), cotiza, 2);
            Aguinaldo agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(plz.getEmpleado().getNumempleado(), nom.getAnio());
            agdao.actualizaFechaPagoDeAguinaldo(agui.getId(), 2);
        }
        
        //datos.put("nomina", nom);        
        datos = ObtenerNominaAguinaldos(datos);
        datos.remove("varios");
        
        return datos;
    }

    private HashMap QuitarPagoAguinaldo(HashMap datos) {
        String varios = datos.get("varios").toString();
        StringTokenizer tokens=new StringTokenizer(varios, ",");
        List<HashMap> detnomina =(List<HashMap>)datos.get("detallenominaagui");
        Nomina nom = (Nomina)datos.get("nominaagui");
        DetalleNominaDao dndao = new DetalleNominaDao();
        AguinaldoDao agdao = new AguinaldoDao();
        
        while(tokens.hasMoreTokens()){
            int i = Integer.parseInt(tokens.nextToken());
            HashMap detalle = detnomina.get(i);
            Plaza plz = (Plaza)detalle.get("plaza");
            dndao.cambiaEstatusPagoAPlazaEnNomina(nom.getId(), plz.getId(), plz.getEmpleado().getCotiza(), 1);
            Aguinaldo agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(plz.getEmpleado().getNumempleado(), nom.getAnio());
            agdao.actualizaFechaPagoDeAguinaldo(agui.getId(), 1);
        }
        
        //datos.put("nomina", nom);        
        datos = ObtenerNominaAguinaldos(datos);
        datos.remove("varios");
        
        return datos;
    }

    private HashMap EliminarDetallesNominaAguinaldos(HashMap datos) {
        String varios = datos.get("varios").toString();
        StringTokenizer tokens=new StringTokenizer(varios, ",");
        List<HashMap> detnomina =(List<HashMap>)datos.get("detallenominaagui");
        Nomina nom = (Nomina)datos.get("nominaagui");
        DetalleNominaDao dndao = new DetalleNominaDao();
        AguinaldoDao agdao = new AguinaldoDao();
        
        while(tokens.hasMoreTokens()){
            int i = Integer.parseInt(tokens.nextToken());
            HashMap detalle = detnomina.get(i);
            int iddet = Integer.parseInt(detalle.get("iddet").toString());
            DetalleNomina detnom = dndao.obtener(iddet);
            Plaza plz = (Plaza)detalle.get("plaza");
            Aguinaldo agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(plz.getEmpleado().getNumempleado(), nom.getAnio());
            agdao.eliminar(agui);
            dndao.eliminar(detnom);
        }
        
        //datos.put("nomina", nom);        
        datos = ObtenerNominaAguinaldos(datos);
        datos.remove("varios");
        
        return datos;
    }

    private HashMap RecalcularNominaAguinaldos(HashMap datos) {
        Nomina nom = datos.get("nomina")!=null?(Nomina)datos.get("nomina"):(Nomina)datos.get("nominaagui");
        NominaDao nomDao = new NominaDao();
        nom = nomDao.obtener(nom.getId());
        datos.remove("nomina");
        datos.put("nominaagui", nom);
        
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(nom.getAnio()+1)+"-01-01";
        String finiquin = Integer.toString(nom.getAnio())+"-01-01";
        String ffinanio = Integer.toString(nom.getAnio())+"-12-31";
        SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
        Date iniquin = null, finquin = null, finanio = null;
        try {
            iniquin = ffecha.parse(finiquin);
            finquin = ffecha.parse(ffinquin);
            finanio = ffecha.parse(ffinanio);
        } catch (ParseException ex) {
            Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        //regenerar el detalle de la nomina
        
        //Definir el listado del detalle de nomina
        List<HashMap> detalle = new ArrayList<HashMap>();

        float totnomina = 0;
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        CatNominaDao cnomDao = new CatNominaDao();
        AguinaldoDao agdao = new AguinaldoDao();
        UtilMod utmod = new UtilMod();
        EmpleadoDao empdao = new EmpleadoDao();
        
        //eliminar el detalle de nomina no pagado
        detnomdao.eliminaDetalleDeNomina(nom.getId());
        Sucursal suc = nom.getSucursal();
        
        List<Empleado> emples = empdao.obtenerListaActivosDeSucursal(nom.getSucursal().getId());
        PeryDed mov = cnomDao.obtenerPeryDed(10);
        for (int i=0; i < emples.size(); i++){
            Empleado emp = emples.get(i);
            //verificar si el empleado ya está en el detalle de la nómina como pagado
            DetalleNomina dnemp = detnomdao.obtenerDetalleNominaAguinaldoPagadoDeEmpleado(nom.getId(), emp.getNumempleado());
            
            if (dnemp==null){
                //obtener ultima plaza del año actual de cada empleado
                Plaza pzemp = plzdao.obtenerUltimaPlazaDeEmpleadoEnElAnioEnSucursal(emp.getNumempleado(), finiquin, suc.getId());
                HashMap detallenom = new HashMap();

                float sueldodiario = 0;
                if (pzemp!=null){
                    detallenom.put("plaza", pzemp);
                    sueldodiario = new Double(utmod.Redondear(pzemp.getSueldo()/15,2)).floatValue();
                    if (Integer.parseInt(pzemp.getPeriodopago().getDias())==30)
                        sueldodiario = new Double(utmod.Redondear(pzemp.getSueldo()/30,2)).floatValue();
                    //obtener días trabajados en el año
                    List<Plaza> plazas = plzdao.obtenerPlazasDeEmpleadoEnElAnioEnSucursal(emp.getNumempleado(), finiquin, suc.getId());
                    int diastrab = 0, faltas = 0, diasnetos = 0;
                    float monto = 0.0f, diasagui = 0.0f;
                    Date fechaAux = null;
                    Date fecha2 = finquin, fecha1 = iniquin;
                    for (int p=0; p < plazas.size(); p++){
                        Plaza plz = plazas.get(p);

                        if (plz.getFechaalta().after(iniquin))
                            fecha1 = plz.getFechaalta();

                        if (plz.getFechabaja()==null){
                            if (plz.getContrato().getFechaFin().before(finquin)){
                                fecha2 = plz.getContrato().getFechaFin();
                            } else {
                                fecha2 = finquin;
                            }
                        } else {
                            fecha2 = plz.getFechabaja();
                        }
                        
                        if (fecha2.equals(finanio))
                            fecha2 = finquin;

                        if (p>0){
                            if (fecha1.after(fechaAux) || fecha1.equals(fechaAux)){
                                diastrab += utmod.DiasEntreFechas(fecha1, fecha2);
                                faltas += movdao.obtenerFaltasDePlazaEnElAnio(plz.getId(), nom.getAnio());
                                fechaAux = fecha2;
                            } else {
                                if (plz.getFechabaja()==null || plz.getFechabaja().after(fechaAux)){
                                    diastrab += utmod.DiasEntreFechas(fechaAux, fecha2);
                                    faltas += movdao.obtenerFaltasDePlazaEnElAnio(plz.getId(), nom.getAnio());
                                    fechaAux = fecha2;
                                }
                            }
                        } else {
                            diastrab += utmod.DiasEntreFechas(fecha1, fecha2);
                            faltas += movdao.obtenerFaltasDePlazaEnElAnio(plz.getId(), nom.getAnio());
                            fechaAux = fecha2;
                        }
                    }
                    //obtener faltas en el año
                    //faltas = movdao.obtenerTotalFaltasEmpleadoEnElAnio(emp.getNumempleado(), nom.getAnio());
                    //calcular dias trabajados netos
                    diasnetos = diastrab - faltas;
                    //calcular dias de aguinaldo a pagar
                    //float fda = (diasnetos*15)/365.0f;
                    diasagui = (new Double(utmod.Redondear((diasnetos*15)/365.0f,4))).floatValue();
                    if (diasagui>0){
                        //calcular monto de aguinaldo
                        monto = (new Double(utmod.Redondear(sueldodiario*diasagui,0))).floatValue();
                        //calcular cotiza o no cotiza
                        HistorialIMSSDao hidao = new HistorialIMSSDao();
                        List<HistorialIMSS> historial = hidao.obtenerHistorialDeEmpleado(emp.getNumempleado());
                        int cotiza = 0;
                        if (historial!=null && !historial.isEmpty()){
                            HistorialIMSS hiemp = historial.get(0);
                            if (hiemp.getFechabaja()==null)
                                cotiza = 1;
                            }
                        //guardar el detalle
                        DetalleNomina detnom = new DetalleNomina();
                        detnom.setCotiza(cotiza);
                        detnom.setEstatus(1);
                        detnom.setExento(mov.getGraoExe());
                        detnom.setMonto(monto);
                        detnom.setMovimiento(mov);
                        detnom.setNomina(nom);
                        detnom.setPlaza(pzemp);
                        detnomdao.guardar(detnom);
                        
                        //antes de guardar el aguinaldo, verificar que no exista
                        Aguinaldo agui = new Aguinaldo();
                        
                        agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(emp.getNumempleado(), nom.getAnio());
                        boolean existe = true;
                        if (agui==null){
                            agui = new Aguinaldo();
                            existe = false;
                        }
                        
                        agui.setAnio(nom.getAnio());
                        agui.setDiasaguinaldo(diasagui);
                        agui.setDiastrabajadosbrutos(diastrab);
                        agui.setEmpleado(emp);
                        agui.setFaltas(faltas);
                        agui.setMontoaguinaldo(monto);
                        agui.setSueldodiario(sueldodiario);
                        if (!existe)
                            agdao.guardar(agui);
                        else
                            agdao.actualizar(agui);
                    }
                }
            }
        }
        
        datos = ObtenerNominaAguinaldos(datos);
        
        return datos;
    }
    
    private HashMap ObtenerSoloNominaAguinaldos(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        NominaDao nomDao = new NominaDao();
        nom = nomDao.obtener(nom.getId());
        datos.put("nominaagui", nom);
        datos.remove("nomina");
        return datos;
    }

    private HashMap ObtenerDetalleFormatosPagoAguinaldos(HashMap datos) {
        HashMap criterios = (HashMap)datos.get("criterios");
        int nivel = Integer.parseInt(criterios.get("nivel").toString());
        int pago = Integer.parseInt(criterios.get("formapago").toString());
        int cuenta = Integer.parseInt(criterios.get("cuenta").toString());
        int cotiza = criterios.get("cotiza")!=null?Integer.parseInt(criterios.get("cotiza").toString()):0;
        datos = ObtenerNominaAguinaldos(datos);
        Nomina nom = (Nomina)datos.get("nominaagui");
        DetalleNominaDao detnomDao = new DetalleNominaDao();
        float totnomina = detnomDao.obtenerTotalDeNomina(nom.getId());
        float totaplicar = 0;
        UtilMod utmod = new UtilMod();
        datos.put("totalnomina", Float.toString((float)utmod.Redondear(totnomina,2)));
        List<HashMap> detnomfp = new ArrayList<HashMap>();
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompletaagui");
        for (int i=0; i < detnomina.size(); i++){
            HashMap det = detnomina.get(i);
            if (!det.get("estatus").toString().equals("PAGADO")){
                Plaza plz = (Plaza) det.get("plaza");
                int dtcot = ((Integer)det.get("cotiza")).intValue();
                if (plz.getFormapago()==pago){
                    if (nivel==0 || plz.getNivel()==nivel){
                        switch (pago){
                            case 1: //deposito
                                if (plz.getEmpleado().getBanco()!=null && plz.getEmpleado().getBanco().getId()==cuenta){
                                    if (dtcot==cotiza){
                                        //if (plz.getEmpleado().getCotiza()==cotiza){
                                        detnomfp.add(det);
                                        totaplicar+=Float.parseFloat(det.get("montoagui").toString());
                                    }
                                }
                                break;
                            case 2: case 3://efectivo || telecomm
                                if (dtcot==cuenta){
                                    //if (plz.getEmpleado().getCotiza()==cuenta){
                                    detnomfp.add(det);
                                    totaplicar+=Float.parseFloat(det.get("montoagui").toString());
                                }
                                break;
                        }//sw pago
                    }//if nivel
                }//forma de pago
            }//if no pagado
        }
        datos.put("totalaplicar", Float.toString((float)utmod.Redondear(totaplicar,2)));
        datos.put("detallenominafp", detnomfp);
        datos.put("criterios", criterios);
        return datos;
    }

    private HashMap CerrarNominaAguinaldos(HashMap datos) {
        //obtener el detalle de la nomina
        datos = ObtenerNominaAguinaldos(datos);
        //poner como pagados todas las plazas de la nomina
        AguinaldoDao agdao = new AguinaldoDao();        
        Nomina nom = (Nomina)datos.get("nominaagui");
        List<HashMap> detnomina = (List<HashMap>)datos.get("listacompletaagui");
        for (int i=0; i < detnomina.size(); i++){
            HashMap det = detnomina.get(i);
            if (!det.get("estatus").toString().equals("PAGADO")){
                Plaza plz = (Plaza)det.get("plaza");
                DetalleNominaDao detnomdao = new DetalleNominaDao();
                detnomdao.cambiaEstatusDePlazaEnNomina(plz.getId(), nom.getId(), 2);
                Aguinaldo agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(plz.getEmpleado().getNumempleado(), nom.getAnio());
                agdao.actualizaFechaPagoDeAguinaldo(agui.getId(), 2);
            }
        }
        //cambiar el estatus de la nomina
        NominaDao nomdao = new NominaDao();
        nomdao.actualizarEstatus(2, nom.getId());
        //actualizar la fecha de cierre de la nomina
        nomdao.actualizaFechaCierre(nom.getId());
        //recargar listado de nominas
        datos = ObtenerNominasAguinaldos(datos);
        return datos;
    }
/*
    private HashMap GenerarNomina2(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalsel");
        SucursalDao sucdao = new SucursalDao();
        suc = sucdao.obtener(suc.getId());
        int anio = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        String finiquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        int niniquinant = 1;
        int mesant = quinact.getNummes();
        if (quinact.getInicio()==1){
            niniquinant = 16;
            mesant = quinact.getNummes()-1;
        }
        String finiquinant = Integer.toString(anio)+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
        
        List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(finiquin, ffinquin, suc.getId());
        if (plazas.isEmpty()){
            datos.put("error", "No hay plazas activas en la Sucursal seleccionada");
            return datos;
        }
        
        TipoNomina tiponom = new TipoNomina();
        tiponom.setIdTnomina(1);
        Nomina nom = new Nomina();
        nom.setAnio(anio);
        nom.setEstatus(1);
        nom.setSucursal(suc);
        UtilDao utdao = new UtilDao();
        nom.setFecha(utdao.hoy());
        nom.setQuincena(quinact);
        nom.setTiponomina(tiponom);
        NominaDao nomdao = new NominaDao();
        nomdao.guardar(nom);
        datos.put("nomina", nom);
        //generar el detalle de la nomina
        float totnomina = 0;
        //obtener las plazas activas
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        CatNominaDao cnomDao = new CatNominaDao();
        UtilMod utmod = new UtilMod();
        //List<HashMap> totsplaza = new ArrayList<HashMap>();
        
        //Definir el listado del detalle de nomina
        List<HashMap> detalle = new ArrayList<HashMap>();
        
        for (int i=0; i < plazas.size(); i++){
            float totpercep = 0;
            float totdeduc = 0;
            float neto = 0;
            Plaza plz = plazas.get(i);
            boolean aplica = false;
            //validar periodo de pago de la plaza
            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                //pago mensual
                int quinnumpago = 1;
                Calendar fechalta = Calendar.getInstance();
                fechalta.setTime(plz.getFechaalta());
                if (fechalta.get(Calendar.DAY_OF_MONTH)<=15){
                    quinnumpago = 2;
                }
                if (quinnumpago == quinact.getNumero()){
                    aplica = true;
                }
            } else {
                aplica = true;
            }
            
            if (aplica){
                
                HashMap detallenom = new HashMap();
                //detallenom.put("plaza", plz);
                //genera detalle del salario de la plaza
                //DetalleNomina detnom = new DetalleNomina();
                PeryDed mov = cnomDao.obtenerPeryDed(1);
                detnom.setEstatus(1);
                detnom.setExento(mov.getGraoExe());
                float sueldodiario = 0;*
                
                //definir las fechas inicial y final de la quincena
                SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
                Date iniquin = null, finquin = null, iniquinant = null;
                try {
                    iniquin = ffecha.parse(finiquin);
                    finquin = ffecha.parse(ffinquin);
                    iniquinant = ffecha.parse(finiquinant);
                } catch (ParseException ex) {
                    Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
                }
                //Obtener el historial imss del empleado de la plaza
                HistorialIMSSDao hidao = new HistorialIMSSDao();
                List<HistorialIMSS> hisimss = hidao.obtenerHistorialDeEmpleado(plz.getEmpleado().getNumempleado());
                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                
                //si no tiene historial imss, calcular pago según campo cotiza del empleado
                if (hisimss==null && hisimss.size()==0){
                    detallenom = CalculaPagoPlaza(new HashMap(), plz, plz.getEmpleado().getCotiza(), diasquin);
                } else {
                    //checar si el historial imss más reciente es interquincenal
                    HistorialIMSS hiemp = hisimss.get(0);
                    
                    if (hiemp.getFechabaja()==null){
                        //En este caso el empleado si esta cotizando en el imss
                        boolean mensual = false;
                        long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                        if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                            if ((hiemp.getFechaalta().after(iniquinant))
                                && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin))){
                                mensual = true;
                            }
                        }
                        if ((hiemp.getFechaalta().after(iniquin))
                                && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin)) || mensual){
                            //calcular dias cotiza y dias no cotiza
                            long diascot = 1;
                            if (hiemp.getFechaalta().before(finquin))
                                diascot = (( finquin.getTime() - hiemp.getFechaalta().getTime() )/MILLSECS_PER_DAY)+1;
                            long diasnocot = 15 - diascot;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                diasnocot = diasquin - diascot;

                            if (mensual){
                                diasnocot = 30 - diascot;
                            }
                            
                            //calcula pago sí cotiza
                            detallenom = CalculaPagoPlaza(new HashMap(), plz, 1, (new Long(diascot)).intValue());
                            //calcula pago no cotiza
                            detallenom = CalculaPagoPlaza(new HashMap(), plz, 0, (new Long(diasnocot)).intValue());
                            
                            //end alta interquincenal
                        } else {
                            //no tiene alta interquincenal, se calcula pago como sí cotiza
                            detallenom = CalculaPagoPlaza(new HashMap(), plz, 1, diasquin);
                        }
                        
                        //end si fecha de baja es null
                    } else { //tiene fecha de baja
                            //En este caso el empleado no esta cotizando en el imss
                            boolean mensual = false;
                            long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                                if ((hiemp.getFechabaja().after(iniquinant))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin))){
                                    mensual = true;
                                }
                            }
                            
                            if ((hiemp.getFechabaja().after(iniquin))
                                    && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin)) || mensual){
                                //calcular dias cotiza y dias no cotiza
                                long diasnocot = 1;
                                if (hiemp.getFechabaja().before(finquin))
                                    diasnocot = ((finquin.getTime() - hiemp.getFechabaja().getTime())/MILLSECS_PER_DAY)+1;
                                long diascot = 15 - diasnocot;
                                if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                                    diascot = diasquin - diasnocot;
                                if (mensual)
                                    diascot = 30 - diasnocot;
                                
                                //calcula pago sí cotiza
                                detallenom = CalculaPagoPlaza(new HashMap(), plz, 1, (new Long(diascot)).intValue());
                                //calcula pago no cotiza
                                detallenom = CalculaPagoPlaza(new HashMap(), plz, 0, (new Long(diasnocot)).intValue());
                                
                                //end baja interquincenal
                            } else {
                                detallenom = CalculaPagoPlaza(new HashMap(), plz, 0, diasquin);
                            }
                    } //end else si fecha baja
                } //end else hay historial imss
            }//end if aplica
        }//end for plazas
        return datos;
    }   
    

    private HashMap CalculaPagoPlaza(HashMap detallenom, Plaza plz, int cotiza, int diasapagar) {
        
        return detallenom;
    }
*/
    private HashMap GenerarNominaNuevo(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalsel");
        SucursalDao sucdao = new SucursalDao();
        suc = sucdao.obtener(suc.getId());
        int anio = Integer.parseInt(datos.get("anio").toString());
        Quincena quinact = (Quincena)datos.get("quinactiva");
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        String finiquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        int niniquinant = 1;
        int mesant = quinact.getNummes();
        if (quinact.getInicio()==1){
            niniquinant = 16;
            mesant = quinact.getNummes()-1;
        }
        String finiquinant = Integer.toString(anio)+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
        
        List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(finiquin, ffinquin, suc.getId());
        if (plazas.isEmpty()){
            datos.put("error", "No hay plazas activas en la Sucursal seleccionada");
            return datos;
        }
        
        TipoNomina tiponom = new TipoNomina();
        tiponom.setIdTnomina(1);
        Nomina nom = new Nomina();
        nom.setAnio(anio);
        nom.setEstatus(1);
        nom.setSucursal(suc);
        UtilDao utdao = new UtilDao();
        nom.setFecha(utdao.hoy());
        nom.setQuincena(quinact);
        nom.setTiponomina(tiponom);
        NominaDao nomdao = new NominaDao();
        nomdao.guardar(nom);
        datos.put("nomina", nom);
       //obtener plazas vigentes de la sucursal
        for (int i=0; i < plazas.size(); i++){
        //para cada plaza
            Plaza plz = plazas.get(i);
            boolean aplica = false;
            //validar periodo de pago de la plaza
            if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                //pago mensual
                int quinnumpago = 1;
                Calendar fechalta = Calendar.getInstance();
                fechalta.setTime(plz.getFechaalta());
                if (fechalta.get(Calendar.DAY_OF_MONTH)<=15){
                    quinnumpago = 2;
                }
                if (quinnumpago == quinact.getNumero()){
                    aplica = true;
                }
            } else {
                aplica = true;
            }
            
            if (aplica){
                CalcularPagoDePlaza(plz, nom, quinact, finiquin, ffinquin, finiquinant);
                //registrar pago de vacaciones
                CalculaVacacionesDePlaza(plz, nom);
            }
        }
        datos = ObtenerNomina(datos);
        return datos;
    }
    
    private void CalcularPagoDePlaza(Plaza plz, Nomina nom, Quincena quinact, String finiquin, String ffinquin, String finiquinant){
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        CatNominaDao cnomDao = new CatNominaDao();
        UtilMod utmod = new UtilMod();
        //definir las fechas inicial y final de la quincena
        SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
        Date iniquin = null, finquin = null, iniquinant = null;
        try {
            iniquin = ffecha.parse(finiquin);
            finquin = ffecha.parse(ffinquin);
            iniquinant = ffecha.parse(finiquinant);
        } catch (ParseException ex) {
            Logger.getLogger(NominaMod.class.getName()).log(Level.SEVERE, null, ex);
        }
        HistorialIMSSDao hidao = new HistorialIMSSDao();
        DetalleNomina detnom = new DetalleNomina();
        List<HistorialIMSS> hisimss = hidao.obtenerHistorialDeEmpleado(plz.getEmpleado().getNumempleado());
        if (hisimss==null || (hisimss!=null && hisimss.size()==0)){
            //la plaza no tiene historial
            //calcula salario nominal
            detnom.setCotiza(plz.getEmpleado().getCotiza());
            PeryDed mov = cnomDao.obtenerPeryDed(1);
            detnom.setMovimiento(mov);
            detnom.setEstatus(1);
            detnom.setExento(mov.getGraoExe());
            if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                //pago por dia
                int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                if (diasquin!=15){
                    float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                } else {
                    detnom.setMonto(plz.getSueldo());
                }
            } else
                detnom.setMonto(plz.getSueldo());
            detnom.setNomina(nom);
            detnom.setPlaza(plz);
            detnomdao.guardar(detnom);
            CalculaDetalleDeMovimientosExtraordinariosDePlazaEnQuincena(plz, quinact, nom, plz.getEmpleado().getCotiza());
        } else {
            float sueldodiario = 0;
            HistorialIMSS hiemp = hisimss.get(0);
            if (hiemp.getFechabaja()==null){
                boolean mensual = false;
                long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                    if ((hiemp.getFechaalta().after(iniquinant))
                        && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin))){
                        mensual = true;
                    }
                }
                if ((hiemp.getFechaalta().after(iniquin))
                        && (hiemp.getFechaalta().before(finquin) || hiemp.getFechaalta().equals(finquin)) || mensual){
                    //el alta esta entre la quincena, calcular pago diferido
                    //calcular dias cotiza y dias no cotiza
                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                    long diascot = 1;
                    if (hiemp.getFechaalta().before(finquin))
                        diascot = (( finquin.getTime() - hiemp.getFechaalta().getTime() )/MILLSECS_PER_DAY)+1;
                    long diasnocot = 15 - diascot;
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                        diasnocot = diasquin - diascot;

                    if (mensual){
                        diasnocot = 30 - diascot;
                    }

                    //salario nominal sí cotiza
                    detnom.setCotiza(1);
                    detnom.setEstatus(1);
                    PeryDed mov = cnomDao.obtenerPeryDed(1);
                    detnom.setExento(mov.getGraoExe());
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                    if (mensual)
                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                    detnom.setMovimiento(mov);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnomdao.guardar(detnom);
                    
                    //salario nominal no cotiza
                    detnom = new DetalleNomina();
                    detnom.setCotiza(0);
                    detnom.setEstatus(1);
                    detnom.setExento(mov.getGraoExe());
                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                    detnom.setMovimiento(mov);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnomdao.guardar(detnom);
                    CalculaDetalleDeMovimientosExtraordinariosDePlazaEnQuincena(plz, quinact, nom, 1);
                } else {
                    detnom = new DetalleNomina();
                    //calcular su pago normalmente sí cotiza
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                        //pago por dia
                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                        if (diasquin!=15){
                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                        } else {
                            detnom.setMonto(plz.getSueldo());
                        }
                    } else
                        detnom.setMonto(plz.getSueldo());
                    PeryDed mov = cnomDao.obtenerPeryDed(1);
                    detnom.setMovimiento(mov);
                    detnom.setExento(mov.getGraoExe());
                    detnom.setEstatus(1);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnom.setCotiza(1);
                    detnomdao.guardar(detnom);
                    CalculaDetalleDeMovimientosExtraordinariosDePlazaEnQuincena(plz, quinact, nom, 1);
                }
            } else {
                //En este caso el empleado no esta cotizando en el imss
                boolean mensual = false;
                long MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                    if ((hiemp.getFechabaja().after(iniquinant))
                        && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin))){
                        mensual = true;
                    }
                }

                if ((hiemp.getFechabaja().after(iniquin))
                        && (hiemp.getFechabaja().before(finquin) || hiemp.getFechabaja().equals(finquin)) || mensual){
                    //la baja esta entre la quincena, calcular pago diferido
                    //calcular dias cotiza y dias no cotiza
                    int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                    long diasnocot = 1;
                    if (hiemp.getFechabaja().before(finquin))
                        diasnocot = ((finquin.getTime() - hiemp.getFechabaja().getTime())/MILLSECS_PER_DAY)+1;
                    long diascot = 15 - diasnocot;
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1)
                        diascot = diasquin - diasnocot;
                    if (mensual)
                        diascot = 30 - diasnocot;
                    
                    //salario nominal sí cotiza
                    detnom = new DetalleNomina();
                    detnom.setCotiza(1);
                    detnom.setEstatus(1);
                    PeryDed mov = cnomDao.obtenerPeryDed(1);
                    detnom.setExento(mov.getGraoExe());
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                    if (mensual)
                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diascot), 2)).floatValue());
                    detnom.setMovimiento(mov);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnomdao.guardar(detnom);
                    
                    //salario nominal no cotiza
                    detnom = new DetalleNomina();
                    detnom.setCotiza(0);
                    detnom.setEstatus(1);
                    detnom.setExento(mov.getGraoExe());
                    detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasnocot), 2)).floatValue());
                    detnom.setMovimiento(mov);
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnomdao.guardar(detnom);
                    CalculaDetalleDeMovimientosExtraordinariosDePlazaEnQuincena(plz, quinact, nom, 1);
                } else {
                    detnom = new DetalleNomina();
                    //calcular su pago normalmente no cotiza
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==1){
                        //pago por dia
                        int diasquin = (quinact.getFin()-quinact.getInicio())+1;
                        if (diasquin!=15){
                            sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                            detnom.setMonto(new Double(utmod.Redondear((sueldodiario*diasquin), 2)).floatValue());
                        } else {
                            detnom.setMonto(plz.getSueldo());
                        }
                    } else
                        detnom.setMonto(plz.getSueldo());
                    PeryDed mov = cnomDao.obtenerPeryDed(1);
                    detnom.setMovimiento(mov);
                    detnom.setEstatus(1);
                    detnom.setExento(mov.getGraoExe());
                    detnom.setNomina(nom);
                    detnom.setPlaza(plz);
                    detnom.setCotiza(0);
                    detnomdao.guardar(detnom);
                    CalculaDetalleDeMovimientosExtraordinariosDePlazaEnQuincena(plz, quinact, nom, 0);
                }
            }
        }
    }
        
    private void CalculaDetalleDeMovimientosExtraordinariosDePlazaEnQuincena(Plaza plz, Quincena quinact, Nomina nom, int cotiza){
        DetalleNominaDao detnomdao = new DetalleNominaDao();
        MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
        UtilMod utmod = new UtilMod();
        float sueldodiario = 0;
        //calcula detalle de movs extras fijos
        List<MovimientoExtraordinario> movs = movdao.obtenerFijosDePlazaTiponom(plz.getId(), 1);
        for (int f=0; f < movs.size(); f++){
            MovimientoExtraordinario mext = movs.get(f);
            DetalleNomina detnom = new DetalleNomina();
            detnom.setEstatus(1);
            detnom.setExento(mext.getPerded().getGraoExe());
            detnom.setMovimiento(mext.getPerded());
            detnom.setNomina(nom);
            detnom.setPlaza(plz);
            if (cotiza==-1)
                detnom.setCotiza(mext.getCotiza());
            else
                detnom.setCotiza(cotiza);

            //calculo del monto segun el tipo de cambio del mov
            if (mext.getTipocambio().getId()==1){
                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                detnom.setMonto(mext.getImporte()*mext.getPerded().getFactor());
            } else if (mext.getTipocambio().getId()==2){
                //si el tipo cambio es dias
                //calcular el sueldo diario segun el periodo de pago de la plaza
                //el importe en este caso es el número de días
                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte()*mext.getPerded().getFactor(),2));
            } else if (mext.getTipocambio().getId()==3){
                //si el tipo cambio es horas
                //calcular el sueldo diario segun el periodo de pago de la plaza
                //el importe en este caso es el número de días
                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte()*mext.getPerded().getFactor(),2));
            }
            detnomdao.guardar(detnom);
        }
        //calcula detalles de movs extras no fijos
        movs = movdao.obtenerActivosDePlazaQuincenaAnioTiponom(plz.getId(), quinact.getId(), nom.getAnio(), 1);
        for (int m=0; m < movs.size(); m++){
            MovimientoExtraordinario mext = movs.get(m);
            if (mext.getPerded().getIdPeryded()!=23){
            DetalleNomina detnom = new DetalleNomina();
            detnom.setEstatus(1);
            detnom.setExento(mext.getPerded().getGraoExe());
            detnom.setMovimiento(mext.getPerded());
            detnom.setNomina(nom);
            detnom.setPlaza(plz);
            if (cotiza==-1)
                detnom.setCotiza(mext.getCotiza());
            else
                detnom.setCotiza(cotiza);

            //calculo del monto segun el tipo de cambio del mov
            if (mext.getTipocambio().getId()==1){
                //si el tipo cambio es importe, se toma el monto tal cual del mov extra
                detnom.setMonto(mext.getImporte()*mext.getPerded().getFactor());
            } else if (mext.getTipocambio().getId()==2){
                //si el tipo cambio es dias
                //calcular el sueldo diario segun el periodo de pago de la plaza
                //el importe en este caso es el número de días
                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();;
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                detnom.setMonto((float) utmod.Redondear(sueldodiario*mext.getImporte()*mext.getPerded().getFactor(),2));
            } else if (mext.getTipocambio().getId()==3){
                //si el tipo cambio es horas
                //calcular el sueldo diario segun el periodo de pago de la plaza
                //el importe en este caso es el número de días
                sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();

                detnom.setMonto((float) utmod.Redondear((sueldodiario/8)*mext.getImporte()*mext.getPerded().getFactor(),2));
            }
            detnomdao.guardar(detnom);
            //si el num de quincenas es mayor de 1 genera el mov extra de la siguiente quincena
            if (mext.getNumero()>1){
                MovimientoExtraordinario mextnvo = new MovimientoExtraordinario();
                mextnvo.setEstatus(1);
                mextnvo.setImporte(mext.getImporte());
                mextnvo.setNumero(mext.getNumero()-1);
                mextnvo.setPerded(mext.getPerded());
                mextnvo.setPeriodo(mext.getPeriodo());
                mextnvo.setPlaza(mext.getPlaza());
                Quincena quin = new Quincena();
                if (mext.getQuincena().getId()==24){
                    quin.setId(1);
                    mextnvo.setAnio(mext.getAnio()+1);
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                        quin.setId(2);
                    }
                } else {
                    quin.setId(mext.getQuincena().getId()+1);
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                        quin.setId(mext.getQuincena().getId()+2);
                    }
                    mextnvo.setAnio(mext.getAnio());
                }
                mextnvo.setQuincena(quin);
                mextnvo.setTipocambio(mext.getTipocambio());
                mextnvo.setTiponomina(mext.getTiponomina());
                mextnvo.setTotal(mextnvo.getImporte()*mextnvo.getNumero());
                mextnvo.setObservaciones(mext.getObservaciones());
                mextnvo.setCotiza(mext.getCotiza());
                mextnvo.setFijo(mext.getFijo());
                movdao.guardar(mextnvo);
            }
            }
        }
    }
    
    private HashMap RecalcularNominaNuevo(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        NominaDao nomdao = new NominaDao();
        nom = nomdao.obtener(nom.getId());
        datos.put("nomina", nom);
        DetalleNominaDao detnomdao = new DetalleNominaDao();

        Quincena quinact = nom.getQuincena();
        //obtener las plazas activas
        PlazaDao plzdao = new PlazaDao();
        String ffinquin = Integer.toString(nom.getAnio())+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        String finiquin = Integer.toString(nom.getAnio())+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        int niniquinant = 1;
        int mesant = quinact.getNummes();
        if (quinact.getInicio()==1){
            niniquinant = 16;
            mesant = quinact.getNummes()-1;
        }
        String finiquinant = Integer.toString(nom.getAnio())+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
        List<Plaza> plazas = plzdao.obtenerListaActivasDeSuc(finiquin, ffinquin, nom.getSucursal().getId());
        
        if (plazas.isEmpty()){
            datos.put("error", "No hay plazas activas en la Sucursal seleccionada");
            return datos;
        }
        
        //obtener detalle nomina todos
        List<HashMap> detallenomina = new ArrayList<HashMap>();
        List<Plaza> plazasdet = detnomdao.obtenerPlazasDeNomina(nom.getId());
        for (int p=0; p < plazasdet.size(); p++){
            Plaza plz = plazasdet.get(p);
            HashMap detalle = new HashMap();
            detalle.put("plaza", plz);
            float percep = 0;
            float deduc = 0;
            //obtener detalle cotiza de la plaza
            List<DetalleNomina> detcotplz = detnomdao.obtenerDetallesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
            if (detcotplz!=null && !detcotplz.isEmpty()){
                detalle.put("cotiza", new Integer(1));
                String estatus = "POR PAGAR";
                int ipago = 0;
                for (int d=0; d < detcotplz.size(); d++){
                    DetalleNomina dn = detcotplz.get(d);
                    if (dn.getMovimiento().getPeroDed()==1)
                        percep+=dn.getMonto();
                    else
                        deduc+=dn.getMonto();
                    if (dn.getEstatus()==2){
                        estatus = "PAGADO";
                        ipago = 1;
                    }
                }
                detalle.put("percepciones", new Float(percep));
                detalle.put("deducciones", new Float(deduc));
                detalle.put("neto", new Float(percep-deduc));
                detalle.put("estatus", estatus);
                detallenomina.add(detalle);
            }
            
            //obtener detalle no cotiza de la plaza
            detalle = new HashMap();
            detalle.put("plaza", plz);
            percep = 0;
            deduc = 0;
            List<DetalleNomina> detnocotplz = detnomdao.obtenerDetallesDeNominaNoCotizaDePlaza(nom.getId(), plz.getId());
            if (detnocotplz!=null && !detnocotplz.isEmpty()){
                detalle.put("cotiza", new Integer(0));
                String estatus = "POR PAGAR";
                int ipago = 0;
                for (int d=0; d < detnocotplz.size(); d++){
                    DetalleNomina dn = detnocotplz.get(d);
                    if (dn.getMovimiento().getPeroDed()==1)
                        percep+=dn.getMonto();
                    else
                        deduc+=dn.getMonto();
                    if (dn.getEstatus()==2){
                        estatus = "PAGADO";
                        ipago = 1;
                    }
                }
                detalle.put("percepciones", new Float(percep));
                detalle.put("deducciones", new Float(deduc));
                detalle.put("neto", new Float(percep-deduc));
                detalle.put("estatus", estatus);
                detallenomina.add(detalle);
            }
        }
        
        //recorrer las plazas
        datos.put("detallenomina", detallenomina);
        for (int p=0; p < plazas.size(); p++){
            Plaza plz = plazas.get(p);
            //checa si la plaza esta en el detalle de nomina actual
            boolean recalcular = false, esta = false;
            int pos = 0;
            for (int d=0; d < detallenomina.size(); d++){
                HashMap dt = detallenomina.get(d);
                Plaza pdt = (Plaza)dt.get("plaza");
                String estatus = dt.get("estatus").toString();
                if (pdt.getId()==plz.getId()){
                    esta=true;
                    if (estatus.equals("POR PAGAR")){
                        recalcular = true;
                        pos = d;
                    }
                    break;
                }
            }
            
            if (recalcular){
                datos.put("varios", Integer.toString(pos));
                datos.put("recalculanomina", "1");
                datos = RecalcularPlazaNuevo(datos);
                datos.remove("recalculanomina");
            } else if (!esta) {
                boolean aplica = false;
                //validar periodo de pago de la plaza
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                    //pago mensual
                    int quinnumpago = 1;
                    Calendar fechalta = Calendar.getInstance();
                    fechalta.setTime(plz.getFechaalta());
                    if (fechalta.get(Calendar.DAY_OF_MONTH)<=15){
                        quinnumpago = 2;
                    }
                    if (quinnumpago == quinact.getNumero()){
                        aplica = true;
                    }
                } else {
                    aplica = true;
                }
                
                if (aplica){
                    CalcularPagoDePlaza(plz, nom, quinact, finiquin, ffinquin, finiquinant);
                    CalculaVacacionesDePlaza(plz, nom);
                }
                
            }
        }
        datos = ObtenerNomina(datos);
        return datos;
    }
    
    private HashMap RecalcularPlazaNuevo(HashMap datos) {
        Nomina nom = (Nomina)datos.get("nomina");
        String varios = datos.get("varios").toString();
        PlazaDao plzdao = new PlazaDao();
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        StringTokenizer tokens=new StringTokenizer(varios, ",");
        
        int anio = Integer.parseInt(datos.get("anio").toString());        
        Quincena quinact = (Quincena)datos.get("quinactiva");
        String ffinquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getFin());
        String finiquin = Integer.toString(anio)+"-"+quinact.getNummes()+"-"+Integer.toString(quinact.getInicio());
        int niniquinant = 1;
        int mesant = quinact.getNummes();
        if (quinact.getInicio()==1){
            niniquinant = 16;
            mesant = quinact.getNummes()-1;
        }
        String finiquinant = Integer.toString(anio)+"-"+Integer.toString(mesant)+"-"+Integer.toString(niniquinant);
        
        while(tokens.hasMoreTokens()){
            int i = Integer.parseInt(tokens.nextToken());
            HashMap detalle = listado.get(i);
            Plaza plz = (Plaza)detalle.get("plaza");
            int cotiza = ((Integer)detalle.get("cotiza")).intValue();
            String estatus = detalle.get("estatus").toString();
            
            boolean recalcular = true;
            DetalleNominaDao detnomdao = new DetalleNominaDao();
            //checar si la plaza seleccionada tiene un pago diferido (si cotiza y no cotiza)
            List<DetalleNomina> dndif = new ArrayList<DetalleNomina>();
            if (cotiza==1)
                dndif = detnomdao.obtenerDetallesDeNominaNoCotizaDePlaza(nom.getId(), plz.getId());
            else
                dndif = detnomdao.obtenerDetallesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
            
            if (dndif!=null && !dndif.isEmpty()){
                String est = "NO PAGADO";
                for (int d=0; d < dndif.size(); d++){
                    DetalleNomina dt = dndif.get(d);
                    if (dt.getEstatus()==2)
                        est = "PAGADO";
                }
                if (est.equals("PAGADO"))
                    recalcular = false;
            }
            
            if (recalcular){
                MovimientoExtraordinarioDao movdao = new MovimientoExtraordinarioDao();
                CatNominaDao cnomDao = new CatNominaDao();
                UtilMod utmod = new UtilMod();
                //borra el detalle actual de la plaza
                detnomdao.eliminaDetalleDePlazaEnNomina(nom.getId(), plz.getId());
                //eliminar los movs extras de la plaza de la quincena siguiente
                Quincena quinsig = new Quincena();
                int aniosig = anio;
                if (quinact.getId()==24){
                    quinsig.setId(1);
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                        quinsig.setId(2);
                    }
                    aniosig++;
                }else{
                    quinsig.setId(quinact.getId()+1);
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30){
                        quinsig.setId(quinact.getId()+2);
                    }
                }
                movdao.eliminarMovsDePlazaAnioQuincena(plz.getId(), quinsig.getId(), aniosig);
                //genera detalle del salario de la plaza
                CalcularPagoDePlaza(plz, nom, quinact, finiquin, ffinquin, finiquinant);
                CalculaVacacionesDePlaza(plz, nom);
            }
        }
        int recalculanomina = datos.get("recalculanomina")!=null?Integer.parseInt(datos.get("recalculanomina").toString()):0;
        if (recalculanomina==0)
            datos = ObtenerNomina(datos);
        datos.remove("varios");
        
        return datos;
    }

    private HashMap GenerarDispersionPagosBanorte(HashMap datos) {
        //poner pagadas las plazas
        datos = PagarPlazasFormatosPago(datos);
        //generar el xls
        datos = ImprimirXls(datos);
        return datos;
        
        /*Nomina nom = (Nomina)datos.get("nomina");
        String ids = datos.get("idsplazas").toString();
        StringTokenizer toks = new StringTokenizer(ids,",");
        String ruta = datos.get("temp").toString();
        File f;
        f = new File(ruta+"/dispersion.txt");
        //Escritura
        try{
        FileWriter w = new FileWriter(f);
        BufferedWriter bw = new BufferedWriter(w);
        PrintWriter wr = new PrintWriter(bw);
        //CREA CABECERA
        String emisora = "78078";
        SimpleDateFormat formato = new SimpleDateFormat("yyyyMMdd");
        NumberFormat fcantidad = new DecimalFormat("###0.00");
        String fecha = formato.format(new Date());
        DispersionBanorteDao disp = new DispersionBanorteDao();
        int icon = disp.obtenerSiguienteConsecutivoDeNomina(nom.getId());
        String consec = String.format("%2s", Integer.toString(icon)).replace(' ', '0');
        int ireg = toks.countTokens();
        String registros = String.format("%6s", Integer.toString(ireg)).replace(' ', '0');
        String totaplicar = datos.get("totalaplicar").toString().replace(".", "").replace(",", "");
        String importe = String.format("%15s", totaplicar).replace(' ', '0');
        String cabecera = "HNE"+emisora+fecha+consec+registros+importe+"0000000000000000000000000000000000000000000000000";
        wr.println(cabecera);
        
        PlazaDao plzdao = new PlazaDao();
        DetalleNominaDao dndao = new DetalleNominaDao();
        UtilMod utmod = new UtilMod();
        //GRABAR DETALLE
        String servicio = String.format("%40s", " ");
        String leyenda = String.format("%40s", " ");
        String banco = "072";
        String tipocuenta = "03";
        while(toks.hasMoreTokens()){
            int i = Integer.parseInt(toks.nextToken());
            Plaza plz = plzdao.obtener(i);
            
            String emple = String.format("%10s", plz.getEmpleado().getClave());
            float percep = dndao.obtenerTotalPercepcionesDePlazaEnNomina(plz.getId(), nom.getId());
            float deduc = dndao.obtenerTotalDeduccionesDePlazaEnNomina(plz.getId(), nom.getId());
            double total = utmod.Redondear((percep-deduc), 2);
            String stot = fcantidad.format(total).replace(".", "");
            String importetrab = String.format("%15s", stot).replace(' ', '0');
            String nocta = String.format("%18s", plz.getEmpleado().getCuenta()).replace(' ', '0');
            String detalle = "D"+fecha+emple+servicio+leyenda+importetrab+banco+tipocuenta+nocta+"0 00000000";
            wr.println(detalle);
        }
        
        wr.close();
        bw.close();
        datos.put("dispersionpagos", f);
        datos.put("consecutivo", consec);
        datos.put("emisora", emisora);
        
        //registra dispersion banorte
        UtilDao utdao = new UtilDao();
        DispersionBanorte dban = new DispersionBanorte();
        dban.setNomina(nom);
        dban.setConsecutivo(icon);
        dban.setFecha(utdao.hoy());
        dban.setRegistros(ireg);
        dban.setTotal(Float.parseFloat(datos.get("totalaplicar").toString().replace(",", "")));
        disp.guardar(dban);
        
        }catch(IOException e){}
        
        */
    }

    private HashMap PagarPlazasFormatosPago(HashMap datos) {
        String varios = datos.get("varios").toString();
        Nomina nom = (Nomina)datos.get("nomina");
        DetalleNominaDao detnomdao = new DetalleNominaDao();

        HashMap criterios = (HashMap)datos.get("criterios");
        int fpag = Integer.parseInt(criterios.get("formapago").toString());
        int cotiza = 0;
        if (fpag==1)
            cotiza = criterios.get("cotiza")!=null?Integer.parseInt(criterios.get("cotiza").toString()):0;
        else
            cotiza = Integer.parseInt(criterios.get("cuenta").toString());
        PlazaDao plzdao = new PlazaDao();
        StringTokenizer tokens=new StringTokenizer(varios, ",");
        VacacionesDao vacdao = new VacacionesDao();
        while(tokens.hasMoreTokens()){
            int idplz = Integer.parseInt(tokens.nextToken());
            Plaza plz = plzdao.obtener(idplz);
            detnomdao.cambiaEstatusPagoAPlazaEnNomina(nom.getId(), plz.getId(), cotiza, 2);
            //actualizar estatus de vacaciones del empleado
            Vacaciones vacas = vacdao.obtenerVacacionesDeEmpleadoYNomina(plz.getEmpleado().getNumempleado(), nom.getId());
            if (vacas!=null){
                vacas.setEstatus(2);
                vacdao.actualizar(vacas);
            }
            
        }
        
        return datos;
    }
    
    /* calcula vacaciones de plaza (nomina, quincena)
    calcular antiguedad en años del empleado
    si la antiguedad es >=1
        checar si el empleado ya tiene registro de vacaciones activa con esa antiguedad
        si no tiene registro
            definir dias respectivo
            calcular monto segun sueldo diario
            calcular prima vacacional
            agregar detalles de nomina correspondientes
            guardar en registro de vacaciones pagadas
        fin si no tiene registro
    fin si anti>=1
    */

    private void CalculaVacacionesDePlaza(Plaza plz, Nomina nom) {
        VacacionesDao vacdao = new VacacionesDao();
        //checar si la plaza tiene vacaciones gozadas en lugar de pagadas
        
        UtilMod utmod = new UtilMod();
        UtilDao utdao = new UtilDao();
        
        Date alta = plz.getEmpleado().getFecha();
        Date hoy = utdao.hoy();
        int diasant = utmod.DiasEntreFechas(alta, hoy);
        int aniosant = diasant / 365;
        if (aniosant>=1){
            //checar si la fecha de alta (dia y mes) está en la quincena correspondiente
            int diaiq = nom.getQuincena().getInicio();
            int diafq = nom.getQuincena().getFin();
            int mesq = nom.getQuincena().getNummes();
            Calendar calalta = Calendar.getInstance();
            calalta.setTime(alta);
            int malta = calalta.get(Calendar.MONTH)+1;
            int dalta = calalta.get(Calendar.DAY_OF_MONTH);
            if (mesq==malta && dalta>=diaiq && dalta<=diafq){
                Vacaciones vacs = vacdao.obtenerVacacionesDeEmpleadoYAntiguedad(plz.getEmpleado().getNumempleado(), aniosant);
                if (vacs==null){
                    //verificar si el empleado tiene vacaciones gozadas (estatus 4)
                    Vacaciones vacgoz = vacdao.obtenerVacacionesDeEmpleadoYAntiguedadGozadas(plz.getEmpleado().getNumempleado(), aniosant);
                    boolean gozadas = false;
                    if (vacgoz!=null)
                        gozadas = true;
                    //obtener los dias de vacaciones a cuenta que se descontarán de las vacaciones
                    
                    DetalleNominaDao detnomdao = new DetalleNominaDao();
                    CatNominaDao cnomDao = new CatNominaDao();
                    int diasvac = 6;
                    switch(aniosant){
                        case 2: diasvac = 8; break;
                        case 3: diasvac = 10; break;
                        case 4: diasvac = 12; break;
                        case 5: case 6: case 7: case 8: case 9: diasvac = 14; break;
                        case 10: case 11: case 12: case 13: case 14: diasvac = 16; break;
                        case 15: case 16: case 17: case 18: case 19: diasvac = 18; break;
                        case 20: case 21: case 22: case 23: case 24: diasvac = 20; break;
                        case 25: case 26: case 27: case 28: case 29: diasvac = 22; break;
                        case 30: case 31: case 32: case 33: case 34: diasvac = 24; break;
                        case 35: case 36: case 37: case 38: case 39: diasvac = 26; break;
                        case 40: case 41: case 42: case 43: case 44: diasvac = 28; break;
                    }// switch aniosant
                    float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                    if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                        sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                    float montovacaciones = new Double(utmod.Redondear(diasvac*sueldodiario,2)).floatValue();
                    float montoprima = new Double(utmod.Redondear(montovacaciones*0.25,2)).floatValue();
                    DetalleNomina dtnom = new DetalleNomina();
                    PeryDed pdvac = cnomDao.obtenerPeryDed(6);
                    PeryDed pdprima = cnomDao.obtenerPeryDed(7);
                    TipoCambioDao tcdao = new TipoCambioDao();
                    MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                    MovimientoExtraordinario mex = new MovimientoExtraordinario();
                    //registra vacaciones en detalle de nomina, si no hay vacaciones gozadas
                    if (!gozadas){
                        dtnom.setCotiza(plz.getEmpleado().getCotiza());
                        dtnom.setEstatus(1);
                        dtnom.setExento(pdvac.getGraoExe());
                        dtnom.setMonto(montovacaciones);
                        dtnom.setMovimiento(pdvac);
                        dtnom.setNomina(nom);
                        dtnom.setPlaza(plz);
                        detnomdao.guardar(dtnom);
                        //guarda el mov extra
                        mex.setAnio(nom.getAnio());
                        mex.setCotiza(plz.getEmpleado().getCotiza());
                        mex.setEstatus(1);
                        mex.setFijo(0);
                        mex.setImporte(montovacaciones);
                        mex.setNumero(1);
                        mex.setPerded(pdvac);
                        mex.setPeriodo("");
                        mex.setPlaza(plz);
                        mex.setPrestacionimss(0);
                        mex.setQuincena(nom.getQuincena());
                        mex.setTipocambio(tcdao.obtener(1));
                        mex.setTiponomina(cnomDao.obtenerTnomina(1));
                        mex.setTotal(montovacaciones);
                        medao.guardar(mex);
                    }
                    //registra prima vacacional en detalle de nomina
                    dtnom = new DetalleNomina();
                    dtnom.setCotiza(plz.getEmpleado().getCotiza());
                    dtnom.setEstatus(1);
                    dtnom.setExento(pdprima.getGraoExe());
                    dtnom.setMonto(montoprima);
                    dtnom.setMovimiento(pdprima);
                    dtnom.setNomina(nom);
                    dtnom.setPlaza(plz);
                    detnomdao.guardar(dtnom);
                    // guarda el mov extra de la prima vacacional
                    mex = new MovimientoExtraordinario();
                    mex.setAnio(nom.getAnio());
                    mex.setCotiza(plz.getEmpleado().getCotiza());
                    mex.setEstatus(1);
                    mex.setFijo(0);
                    mex.setImporte(montoprima);
                    mex.setNumero(1);
                    mex.setPerded(pdprima);
                    mex.setPeriodo("");
                    mex.setPlaza(plz);
                    mex.setPrestacionimss(0);
                    mex.setQuincena(nom.getQuincena());
                    mex.setTipocambio(tcdao.obtener(1));
                    mex.setTiponomina(cnomDao.obtenerTnomina(1));
                    mex.setTotal(montoprima);
                    medao.guardar(mex);
                    //guarda en registro de vacaciones, si no hay gozadas
                    if (!gozadas){
                        Vacaciones vac = new Vacaciones();
                        vac.setAnio(nom.getAnio());
                        vac.setAntiguedad(aniosant);
                        vac.setDias(diasvac);
                        vac.setEmpleado(plz.getEmpleado());
                        vac.setEstatus(1);
                        vac.setNomina(nom);
                        vac.setMontovacaciones(montovacaciones);
                        vac.setMontoprima(montoprima);
                        vac.setDiasacuenta(0);
                        vac.setQuincena(nom.getQuincena());
                        vacdao.guardar(vac);
                    }
                } //if vacs == null
            }//si dia y mes alta corresponde al periodo de la quincena a pagar
        } //if aniosant>=1
    }

    private HashMap RegistrarGozeVacaciones(HashMap datos) {
        String varios = datos.get("varios").toString();
        List<HashMap> listado = (List<HashMap>)datos.get("detallenomina");
        Nomina nom = (Nomina)datos.get("nomina");

        int i = Integer.parseInt(varios);
        HashMap detalle = listado.get(i);
        Plaza plz = (Plaza)detalle.get("plaza");
        VacacionesDao vacdao = new VacacionesDao();
        Vacaciones vac = vacdao.obtenerVacacionesDeEmpleadoYNominaPagadasOGozadas(plz.getEmpleado().getNumempleado(), nom.getId());
        datos.put("vacaciones", vac);
        datos.put("plaza", plz);
        datos.remove("varios");
        
        return datos;
    }

    private HashMap GuardarGoceDeVacaciones(HashMap datos) {
        Vacaciones vac = (Vacaciones)datos.get("vacaciones");
        Date fi = (Date)datos.get("vfechaini");
        Date ff = (Date)datos.get("vfechafin");
        Plaza plz = (Plaza)datos.get("plaza");
        Nomina nom = (Nomina)datos.get("nomina");
        VacacionesDao vacdao = new VacacionesDao();
        vac.setFechainicial(fi);
        vac.setFechafinal(ff);
        vac.setEstatus(4);
        vac.setMontovacaciones(0.0f);
        vacdao.actualizar(vac);
        
        //cancelar registro de detalle de nomina del movimiento de vacaciones (6)
        DetalleNominaDao dndao = new DetalleNominaDao();
        dndao.eliminarDetalleDePerydedDePlazaEnNomina(6, plz.getId(), nom.getId());
        //cancelar mov extraordinario de vacaciones de la plaza en la quincena
        MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
        medao.eliminarMovimientoDePerydedDePlazaEnQuincenaYAnio(6, plz.getId(), nom.getQuincena().getId(), nom.getAnio());
        
        datos = ObtenerNomina(datos);
        return datos;
    }

    private HashMap QuitarGoceDeVacaciones(HashMap datos) {
        Vacaciones vac = (Vacaciones)datos.get("vacaciones");
        Plaza plz = (Plaza)datos.get("plaza");
        Nomina nom = (Nomina)datos.get("nomina");
        VacacionesDao vacdao = new VacacionesDao();
        vac.setFechainicial(null);
        vac.setFechafinal(null);
        vac.setEstatus(1);
        vacdao.actualizar(vac);
        
        //calcular pago de vacaciones de la plaza
        
        UtilMod utmod = new UtilMod();
        UtilDao utdao = new UtilDao();
        
        Date alta = plz.getEmpleado().getFecha();
        Date hoy = utdao.hoy();
        int diasant = utmod.DiasEntreFechas(alta, hoy);
        int aniosant = diasant / 365;
        if (aniosant>=1){
            //checar si la fecha de alta (dia y mes) está en la quincena correspondiente
            int diaiq = nom.getQuincena().getInicio();
            int diafq = nom.getQuincena().getFin();
            int mesq = nom.getQuincena().getNummes();
            Calendar calalta = Calendar.getInstance();
            calalta.setTime(alta);
            int malta = calalta.get(Calendar.MONTH)+1;
            int dalta = calalta.get(Calendar.DAY_OF_MONTH);
            if (mesq==malta && dalta>=diaiq && dalta<=diafq){
                DetalleNominaDao detnomdao = new DetalleNominaDao();
                CatNominaDao cnomDao = new CatNominaDao();
                int diasvac = 6;
                switch(aniosant){
                    case 2: diasvac = 8; break;
                    case 3: diasvac = 10; break;
                    case 4: diasvac = 12; break;
                    case 5: case 6: case 7: case 8: case 9: diasvac = 14; break;
                    case 10: case 11: case 12: case 13: case 14: diasvac = 16; break;
                    case 15: case 16: case 17: case 18: case 19: diasvac = 18; break;
                    case 20: case 21: case 22: case 23: case 24: diasvac = 20; break;
                    case 25: case 26: case 27: case 28: case 29: diasvac = 22; break;
                    case 30: case 31: case 32: case 33: case 34: diasvac = 24; break;
                    case 35: case 36: case 37: case 38: case 39: diasvac = 26; break;
                    case 40: case 41: case 42: case 43: case 44: diasvac = 28; break;
                }// switch aniosant
                float sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/15,2)).floatValue();
                if (Integer.parseInt(plz.getPeriodopago().getDias())==30)
                    sueldodiario = new Double(utmod.Redondear(plz.getSueldo()/30,2)).floatValue();
                float montovacaciones = new Double(utmod.Redondear(diasvac*sueldodiario,2)).floatValue();
                float montoprima = new Double(utmod.Redondear(montovacaciones*0.25,2)).floatValue();
                DetalleNomina dtnom = new DetalleNomina();
                PeryDed pdvac = cnomDao.obtenerPeryDed(6);
                PeryDed pdprima = cnomDao.obtenerPeryDed(7);
                TipoCambioDao tcdao = new TipoCambioDao();
                MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
                MovimientoExtraordinario mex = new MovimientoExtraordinario();
                //registra vacaciones en detalle de nomina, si no hay vacaciones gozadas
                dtnom.setCotiza(plz.getEmpleado().getCotiza());
                dtnom.setEstatus(1);
                dtnom.setExento(pdvac.getGraoExe());
                dtnom.setMonto(montovacaciones);
                dtnom.setMovimiento(pdvac);
                dtnom.setNomina(nom);
                dtnom.setPlaza(plz);
                detnomdao.guardar(dtnom);
                //guarda el mov extra
                mex.setAnio(nom.getAnio());
                mex.setCotiza(plz.getEmpleado().getCotiza());
                mex.setEstatus(1);
                mex.setFijo(0);
                mex.setImporte(montovacaciones);
                mex.setNumero(1);
                mex.setPerded(pdvac);
                mex.setPeriodo("");
                mex.setPlaza(plz);
                mex.setPrestacionimss(0);
                mex.setQuincena(nom.getQuincena());
                mex.setTipocambio(tcdao.obtener(1));
                mex.setTiponomina(cnomDao.obtenerTnomina(1));
                mex.setTotal(montovacaciones);
                medao.guardar(mex);
            }//si dia y mes alta corresponde al periodo de la quincena a pagar
        } //if aniosant>=1
        
        //fin calcular pago de vacaciones de la plaza
        datos = ObtenerNomina(datos);
        return datos;
    }
}