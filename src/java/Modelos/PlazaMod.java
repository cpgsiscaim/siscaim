/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.CatNominaDao;
import Modelo.Daos.Catalogos.QuincenaDao;
import Modelo.Daos.Catalogos.TipoCambioDao;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Catalogos.TipoCambio;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author TEMOC
 */
public class PlazaMod {
    public PlazaMod(){
    }

    public Sesion GestionarPlazas(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de sucursales activas
                datos.put("sucursales", ObtenerSucursales());
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                datos = ObtenerClientes(datos);
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                break;
            case -1:
                //obtener clientes de sucursal
                datos = ObtenerClientes(datos);
                break;
            case -2: case -4:
                //obtener contratos de cliente
                datos = ObtenerContratos(datos);
                break;
            case -3:
                //obtener centros de contrato
                datos = ObtenerCentros(datos);
                break;
            case 1:
                //cargar plazas
                datos = ObtenerPlazas(datos);
                break;
            case 2: case 4:
                //ir a nueva plaza (2) || editar plaza (4)
                datos = ObtenerCatalogos(datos);
                if (paso==2)
                    datos.put("accion", "nueva");
                else {
                    datos = ObtenerPlaza(datos);
                    datos.put("accion", "editar");
                }
                break;
            case 3: case 5:
                //guardar plaza nueva (2) | editada(4)
                datos = GuardarPlaza(datos);
                break;
            case 6:
                //baja de plaza
                datos = BajaDePlaza(datos);
                break;
            case 7:
                datos = ObtenerInactivas(datos);
                break;
            case 8:
                //activar plaza
                datos = ActivarPlaza(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    //sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp");
                    datos.remove("error");
                }
                break;
            case 9:
                //ir a movimientos extras de la plaza
                datos = CargarMovsExtras(datos);
                break;
            case 10:
                datos = CargaDatosSustituir(datos);
                break;
            case 11:
                datos = AplicarSustitucion(datos);
                break;
            case 12: case 18: case 19:
                datos = ImprimirReporte(datos);
                break;
            case 13:
                datos = ImprimirXls(datos);
                break;
            case 14:
                datos = AplicarBaja(datos);
                break;
            case 15:
                datos = ObtenerPlazasExternas(datos);
                break;
            case 16:
                datos = ObtenerClientes(datos);
                datos.put("externas", "0");
                datos.put("paso", "-1");
                break;
            case 17:
                datos = RecalcularMovsExtras(datos);
                break;
            case 20:
                datos = IrAVacacionesDePlaza(datos);
                break;
            case 95:
                datos.remove("plaza");
                datos.remove("fechasquin");
                break;
            case 96:
                datos.remove("plaza");
                datos.remove("empleados");
                break;
            case 97:
                //cancelar inactivas
                datos.remove("plazasinactivas");
                break;
            case 98:
                //cancelar nueva plaza
                datos.remove("accion");
                datos.remove("plaza");
                break;
            case 99:
                //salir de gestionar plazas
                /*int irpagant = Integer.parseInt(datos.get("irpagant")!=null?datos.get("irpagant").toString():"0");
                if (irpagant==1){
                    sesion.setPaginaSiguiente(sesion.getPaginaAnterior());
                    sesion.setPaginaAnterior("");
                }*/
                datos = Salir(datos);
                //datos = new HashMap();
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
    
    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }
    
    private HashMap ObtenerPlazas(HashMap datos) {
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        if (ct.getId()!=0){
            CentroTrabDao ctDao = new CentroTrabDao();
            ct = ctDao.obtener(ct.getId());
            datos.put("centro", ct);
            PlazaDao plzDao = new PlazaDao();
            List<Plaza> plas = plzDao.obtenerListaActivasDeCT(ct.getId());
            datos.put("plazas", plas);
            //calcular acumulado de sueldos
            float acum = 0.0f;
            for (int i=0; i < plas.size(); i++){
                Plaza p = plas.get(i);
                acum+=p.getSueldo()+p.getSueldocotiza();
            }
            datos.put("acumsueldos", new Float(acum));
        } else {
            datos.remove("plazas");
            datos.remove("acumsueldos");
            datos.put("paso", "-3");
        }
        /*PlazaDao plzDao = new PlazaDao();
        datos.put("plazas", plzDao.obtenerListaActivasDeCT(ct.getId()));*/
        return datos;
    }

    private HashMap GuardarPlaza(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        Contrato con = (Contrato)datos.get("editarContrato");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        Plaza plz = (Plaza)datos.get("plaza");
        PlazaDao plzDao = new PlazaDao();
        if (datos.get("accion").toString().equals("nueva")){
            plz.setSucursal(suc);
            plz.setCliente(cli);
            plz.setContrato(con);
            plz.setCtrabajo(ct);
            plz.setEstatus(1);
            plzDao.guardar(plz);
            //generar movs extras
            GenerarMovsExtras(plz);
        } else
            plzDao.actualizar(plz);
        datos = ObtenerPlazas(datos);
        datos.remove("accion");
        datos.remove("plaza");
        return datos;
    }

    private HashMap ObtenerPlaza(HashMap datos) {
        Plaza plz = (Plaza)datos.get("plaza");
        PlazaDao plzDao = new PlazaDao();
        plz = plzDao.obtener(plz.getId());
        datos.put("plaza", plz);
        return datos;
    }

    private HashMap BajaDePlaza(HashMap datos) {
        datos = ObtenerPlaza(datos);
        Plaza plz = (Plaza)datos.get("plaza");
        QuincenaDao quindao = new QuincenaDao();
        Quincena quinact = quindao.obtenerQuincenaActiva();
        UtilDao uDao = new UtilDao();
        int anio = uDao.AñoActual();
        List<HashMap> fechas = new ArrayList<HashMap>();
        for (int i=quinact.getInicio(); i <= quinact.getFin(); i++){
            HashMap fecha = new HashMap();
            String dia = "", mes = "";
            dia = Integer.toString(i);
            if (i<10)
                dia = "0"+dia;
            mes = Integer.toString(quinact.getNummes());
            if (quinact.getNummes()<10)
                mes = "0"+mes;
            String normal = dia+"-"+mes+"-"+Integer.toString(anio);
            String sql = Integer.toString(anio)+"-"+mes+"-"+dia;
            fecha.put("normal", normal);
            fecha.put("sql", sql);
            fechas.add(fecha);
        }
        datos.put("fechasquin", fechas);
        /*UtilDao utilDao = new UtilDao();
        plz.setFechabaja(utilDao.hoy());
        plz.setEstatus(0);
        PlazaDao plzDao = new PlazaDao();
        plzDao.actualizar(plz);
        GenerarMovExtraBaja(plz);
        datos = ObtenerPlazas(datos);
        datos.remove("plaza");*/
        return datos;
    }

    private HashMap ObtenerInactivas(HashMap datos) {
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        PlazaDao plzDao = new PlazaDao();
        datos.put("plazasinactivas", plzDao.obtenerListaInactivasDeCT(ct.getId()));
        return datos;
    }

    private HashMap ActivarPlaza(HashMap datos) {
        Plaza plz = (Plaza)datos.get("plaza");
        PlazaDao plzDao = new PlazaDao();
        plz = plzDao.obtener(plz.getId());
        //validar empleado de plaza en plazas activas
        if (plzDao.EmpleadoEstaEnPlazaActiva(plz)){
            datos.put("error", "El Empleado ya tiene una plaza activa");
            return datos;
        }
        
        plzDao.actualizarEstatus(1, plz.getId());
        datos = ObtenerPlazas(datos);
        datos = ObtenerInactivas(datos);
        datos.remove("plaza");        
        return datos;
    }

    private HashMap Salir(HashMap datos) {
        int irpagant = Integer.parseInt(datos.get("origenplazas")!=null?"1":"0");
        if (irpagant==0){
            datos = new HashMap();
        } else {
            datos.remove("centros");
            datos.remove("contratos");
            datos.remove("clientes");
            datos.remove("origenplazas");
            datos.remove("plazas");
            datos.remove("plaza");
            datos.remove("accion");
            datos.put("paso", "1");
        }
        return datos;
    }

    private HashMap ObtenerClientes(HashMap datos) {
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        SucursalDao sucdao = new SucursalDao();
        sucsel = sucdao.obtener(sucsel.getId());
        datos.put("sucursalSel", sucsel);
        ClienteDao cliDao = new ClienteDao();
        datos.put("clientes", cliDao.obtenerClientesDeSucursal(sucsel.getId()));
        datos.put("banhis", "0");
        datos.remove("contratos");
        datos.remove("centros");
        datos.remove("plazas");
        return datos;
    }

    private HashMap ObtenerCatalogos(HashMap datos) {
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        PlazaDao plzDao = new PlazaDao();
        if (ct.getSurtidoexterno()==0)
            datos.put("empleados", plzDao.obtenerEmpleadosDeSucursalSinAsignarEnCT(sucsel.getId(), ct.getId()));
        else
            datos.put("empleados", plzDao.obtenerEmpleadosDeSucursalSinAsignarEnCT(ct.getSucalterna().getId(), ct.getId()));
        
        CatNominaDao nomDao = new CatNominaDao();
        datos.put("puestos", nomDao.obtenerListaPuestos());
        datos.put("periodos", nomDao.obtenerListaPerPagos());
        return datos;
    }

    private HashMap ObtenerContratos(HashMap datos) {
        int exter = Integer.parseInt(datos.get("externas")!=null?datos.get("externas").toString():"0");
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        datos.put("banhis", "0");
        if (cli.getId()!=0){
            ClienteDao cliDao = new ClienteDao();
            cli = cliDao.obtener(cli.getId());
            datos.put("clienteSel", cli);
        }
        ContratoDao conDao = new ContratoDao();
        if (exter==0){
            if (datos.get("paso").equals("-2")){
                datos.put("contratos", conDao.obtenerContratosDeClienteYSucursal(cli.getId(), sucsel.getId()));//.obtenerContratosDeCliente(cli.getId()));
                datos.put("vigentes","1");
            } else {
                datos.put("contratos", conDao.obtenerContratosDeClienteYSucursalConcluidos(cli.getId(), sucsel.getId()));
                datos.put("vigentes","0");
            }
            //datos.put("contratos", conDao.obtenerContratosDeClienteYSucursalTodos(cli.getId(), sucsel.getId()));//.obtenerContratosDeCliente(cli.getId()));
        }else{
            CentroTrabDao ctdao = new CentroTrabDao();
            datos.put("contratos", ctdao.obtenerContratosExternosDeClienteYSucursalTodos(cli.getId(), sucsel.getId()));
        }
        datos.remove("centros");
        datos.remove("plazas");
        return datos;
    }

    private HashMap ObtenerCentros(HashMap datos) {
        int exter = Integer.parseInt(datos.get("externas")!=null?datos.get("externas").toString():"0");
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        Contrato con = (Contrato)datos.get("editarContrato");
        datos.put("banhis", "0");
        if (con.getId()!=0){
            ContratoDao conDao = new ContratoDao();
            con = conDao.obtener(con.getId());
            datos.put("editarContrato", con);
            UtilDao utdao = new UtilDao();
            Date hoy = utdao.hoy();
            if (hoy.after(con.getFechaFin())){
                datos.put("banhis", "1");
            }
        }
        CentroTrabDao ctDao = new CentroTrabDao();
        if (exter==0)
            datos.put("centros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        else{
            datos.put("centros", ctDao.obtenerCentroDeTrabajosExternosDeContratoYSucursal(con.getId(), sucsel.getId()));
        }
        datos.remove("plazas");
        return datos;
    }

    private HashMap CargarMovsExtras(HashMap datos) {
        datos = ObtenerPlaza(datos);
        Plaza plz = (Plaza)datos.get("plaza");
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
        return datos;
    }

    private void GenerarMovsExtras(Plaza plz) {
        //Obtener quincena activa ---
        QuincenaDao quinDao = new QuincenaDao();
        Quincena quinact = quinDao.obtenerQuincenaActiva();//.obtenerQuincenaActual();
        //año actual
        UtilDao uDao = new UtilDao();
        int anio = uDao.AñoActual();
        Calendar quinini = Calendar.getInstance();
        Calendar quinfin = Calendar.getInstance();
        quinini.set(anio,quinact.getNummes()-1,quinact.getInicio(),0,0,0);
        quinfin.set(anio,quinact.getNummes()-1,quinact.getFin(),0,0,0);
        Date fechaIni = quinini.getTime();
        Date fechaFin = quinfin.getTime();
        
        Quincena quinant = new Quincena();
        int anioant = anio;
        //determinar quincena anterior
        if (quinact.getId()==1){
            quinant.setId(24);
            anioant--;
        } else
            quinant.setId(quinact.getId()-1);
        //checar nomina anterior
        NominaDao nomdao = new NominaDao();
        Nomina nomant = nomdao.obtenerNominaNormalDeQuincenaYSucursal(quinant.getId(), anioant, plz.getSucursal().getId());
        
        long dias = Math.abs(plz.getFechaalta().getTime() - fechaIni.getTime())/(1000 * 60 * 60 * 24);
        if (dias!=0 && (plz.getFechaalta().before(fechaFin) || plz.getFechaalta().equals(fechaFin))){
            MovimientoExtraordinario move = new MovimientoExtraordinario();
            move.setPerded(new PeryDed());
            move.setPlaza(plz);
            move.setQuincena(quinact);
            TipoCambioDao tcDao = new TipoCambioDao();
            move.setTipocambio(tcDao.obtener(2));//tipo de cambio = DIAS
            CatNominaDao cnomDao = new CatNominaDao();
            move.setTiponomina(cnomDao.obtenerTnomina(1));
            move.setAnio(anio);
            move.setEstatus(1);
            move.setPeriodo("");
            //UtilMod util = new UtilMod();
            //move.setImporte((float)util.Redondear(plz.getSueldo()/15, 2));
            if (plz.getFechaalta().before(fechaIni)){
                if (nomant==null || (nomant!=null && nomant.getEstatus()==2))
                    return;
                //mov extra salario nominal dias
                move.setPerded(cnomDao.obtenerPeryDed(1));
            } else if (plz.getFechaalta().after(fechaIni)){
                //mov extra faltas en dias
                move.setPerded(cnomDao.obtenerPeryDed(20));
                dias++;
            }
            move.setImporte((float)dias);
            move.setNumero(1);
            move.setTotal(move.getImporte()*move.getNumero());

            MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
            meDao.guardar(move);
        }
    }

    private HashMap CargaDatosSustituir(HashMap datos) {
        datos = ObtenerPlaza(datos);
        Sucursal sucsel = (Sucursal)datos.get("sucursalSel");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        PlazaDao plzDao = new PlazaDao();
        if (ct.getSurtidoexterno()==0)
            datos.put("empleados", plzDao.obtenerEmpleadosDeSucursalSinAsignarEnCT(sucsel.getId(), ct.getId()));
        else
            datos.put("empleados", plzDao.obtenerEmpleadosDeSucursalSinAsignarEnCT(ct.getSucalterna().getId(), ct.getId()));
        //datos.put("empleados", plzDao.obtenerEmpleadosDeSucursalSinAsignarEnCT(sucsel.getId(), ct.getId()));
        return datos;
    }

    private HashMap AplicarSustitucion(HashMap datos) {
        //baja de la plaza
        Plaza plz = (Plaza)datos.get("plazaBaja");
        plz.setEstatus(0);
        PlazaDao plzDao = new PlazaDao();
        plzDao.actualizar(plz);
        GenerarMovExtraBaja(plz);

        //alta de la plaza
        Plaza plzNva = (Plaza)datos.get("plazaAlta");
        plzNva.setCliente(plz.getCliente());
        plzNva.setCompensacion(plz.getCompensacion());
        plzNva.setContrato(plz.getContrato());
        plzNva.setCtrabajo(plz.getCtrabajo());
        plzNva.setEstatus(1);
        plzNva.setFormapago(plz.getFormapago());
        plzNva.setNivel(plz.getNivel());
        plzNva.setPeriodopago(plz.getPeriodopago());
        plzNva.setPuesto(plz.getPuesto());
        plzNva.setSucursal(plz.getSucursal());
        plzNva.setSueldo(plz.getSueldo());
        plzDao.guardar(plzNva);
        GenerarMovsExtras(plzNva);
        
        datos = ObtenerPlazas(datos);
        datos.remove("plazaAlta");
        datos.remove("plazaBaja");
        datos.remove("plaza");
        datos.remove("empleados");
        return datos;
    }

    private void GenerarMovExtraBaja(Plaza plz) {
        //Obtener quincena actual
        QuincenaDao quinDao = new QuincenaDao();
        Quincena quinact = quinDao.obtenerQuincenaActiva();
        //año actual
        UtilDao uDao = new UtilDao();
        int anio = uDao.AñoActual();
        Calendar quinini = Calendar.getInstance();
        quinini.set(anio,quinact.getNummes()-1,quinact.getFin(),0,0,0);
        Date fechaFin = quinini.getTime();
        
        MovimientoExtraordinario move = new MovimientoExtraordinario();
        move.setPerded(new PeryDed());
        move.setPlaza(plz);
        move.setQuincena(quinact);
        TipoCambioDao tcDao = new TipoCambioDao();
        move.setTipocambio(tcDao.obtener(2));//tipo de cambio = DIAS
        CatNominaDao cnomDao = new CatNominaDao();
        move.setTiponomina(cnomDao.obtenerTnomina(1));
        move.setAnio(anio);
        move.setEstatus(1);
        move.setPeriodo("");
        UtilMod util = new UtilMod();
        move.setImporte((float)util.Redondear(plz.getSueldo()/15, 2));
        long dias = Math.abs(plz.getFechabaja().getTime() - fechaFin.getTime())/(1000 * 60 * 60 * 24);
        if (plz.getFechabaja().before(fechaFin)){
            //mov extra faltas en dias
            move.setPerded(cnomDao.obtenerPeryDed(20));
            dias++;
        } else {
            return;
        }
        
        move.setImporte((float)dias);
        move.setNumero(1);
        move.setTotal(move.getImporte()*move.getNumero());
        
        /*
        move.setNumero((int)dias);
        move.setTotal(move.getImporte()*move.getNumero());
        */
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
        meDao.guardar(move);
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

    private HashMap AplicarBaja(HashMap datos) {
        String fechabaja = datos.get("fechabaja").toString();
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaB = null;
        try {
            fechaB = formatoDelTexto.parse(fechabaja);
        } catch (ParseException ex) {
        }        
        
        Plaza plz = (Plaza)datos.get("plaza");
        plz.setFechabaja(fechaB);
        plz.setEstatus(0);
        PlazaDao plzDao = new PlazaDao();
        plzDao.actualizar(plz); 
        GenerarMovExtraBaja(plz);
        datos = ObtenerPlazas(datos);
        datos.remove("plaza");
        datos.remove("fechasquin");
        datos.remove("fechabaja");
        return datos;
    }

    private HashMap ObtenerPlazasExternas(HashMap datos) {
        //obtener los clientes de cts con surtido externo en la sucursal actual
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        CentroTrabDao ctdao = new CentroTrabDao();
        datos.put("clientes", ctdao.obtenerClientesDeCtsExternos(suc.getId()));
        datos.put("paso", "-1");
        datos.put("externas", "1");
        return datos;
    }

    private HashMap RecalcularMovsExtras(HashMap datos) {
        //Obtener quincena activa ---
        QuincenaDao quinDao = new QuincenaDao();
        Quincena quinact = quinDao.obtenerQuincenaActiva();//.obtenerQuincenaActual();
        //año actual
        UtilDao uDao = new UtilDao();
        int anio = uDao.AñoActual();
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
        
        List<Plaza> plazas = (List<Plaza>)datos.get("plazas");
        for (int i=0; i < plazas.size(); i++){
            Plaza pl = plazas.get(i);
            //eliminar los movs extras registrados de la quincena actual
            meDao.eliminarMovsDePlazaAnioQuincena(pl.getId(), quinact.getId(), anio);
            //regenerar los movs extras de la plaza
            GenerarMovsExtras(pl);
        }
        
        return datos;
    }
    
    private HashMap IrAVacacionesDePlaza(HashMap datos) {
        datos = ObtenerPlaza(datos);
        Plaza plz = (Plaza)datos.get("plaza");
        
        Empleado emp = plz.getEmpleado();
        datos.put("empleado", emp);
        
        VacacionesDao vacdao = new VacacionesDao();
        List<Vacaciones> vacs = vacdao.obtenerVacacionesDeEmpleado(emp.getNumempleado());
        datos.put("gruposvac", "0");
        datos.put("vacacionesemp", vacs);
        
        return datos;
    }
}
