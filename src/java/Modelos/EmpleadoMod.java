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
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.*;
import java.util.HashMap;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.TipoDocumento;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmpleadoMod {
    int grupos = 0;
    public EmpleadoMod(){
        
    }
    
    public Sesion GestionarEmpleado(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
                /*case 0: 
                    EmpleadoDao empDao = new EmpleadoDao();
                    datos.put("lista", empDao.obtenerListaActivos());
                break;*/
                case 0:
                    //cargar sucursales
                    datos = ObtenerSucursales(datos);
                    //cargar datos de sucursal del usuario
                    datos.put("sucursal", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                    if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                        datos.put("matriz", "1");
                    else
                        datos.put("matriz", "0");
                    
                    UtilDao utdao = new UtilDao();
                    datos.put("hoy", utdao.hoy());
                    datos = ObtenerEmpleadosDeSucursal(datos);
                    datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                    datos = ObtenerLogotipo(datos);
                    /*EmpleadoDao empDao = new EmpleadoDao();
                    datos.put("lista", empDao.obtenerListaActivos());*/
                break;
                case 100:
                    datos = ObtenerEmpleadosDeSucursal(datos);
                    datos.remove("banfiltro");
                    break;
                case 1: // CARGAR DATOS PARA NUEVO CLIENTE
                    datos = CargaDatosNuvEmp(datos);                    
                break;
                case 2: case 5:// GuardarDatos
                    datos.put("paginasig", sesion.getPaginaSiguiente());
                    datos = GuardarEmpleado(datos);
                    if (datos.get("error")!=null){
                        sesion.setError(true);
                        sesion.setMensaje(datos.get("error").toString());
                        sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp");
                        datos.remove("error");
                    } else {
                        sesion.setExito(true);
                        sesion.setMensaje("Los datos fueron guardados con éxito");
                        datos.remove("pestaña");
                        datos.remove("min");
                        datos.remove("max");
                        datos.remove("banalta");
                    }
                    //sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp");                
                break;
                
                case 4: case 45:// CARGAR DATOS PARA EDITAR PERSONAL
                    datos = CargaDatosNuvEmp(datos);                    
                    datos = CargarEmpAEditar(datos);
                    datos = ObtenerHistorialIMSS(datos);
                break;
                case 6:
                        Empleado empBaja = (Empleado) datos.get("bajaEmpleado");
                        EmpleadoDao empbajaDao = new EmpleadoDao();
                        empBaja = empbajaDao.obtener(empBaja.getNumempleado());
                        empBaja.setEstatus(0);
                        empBaja.setFechabaja((Date)datos.get("fechabaja"));
                        empbajaDao.actualizar(empBaja);
                        //empbajaDao.actualizarEstatus(0, empBaja.getNumempleado());
                        
                        //actualizar estatus de vacaciones del empleado
                        VacacionesDao vacdao = new VacacionesDao();
                        List<Vacaciones> vacas = vacdao.obtenerVacacionesPagadasOGozadasDeEmpleado(empBaja.getNumempleado());
                        if (vacas!=null && !vacas.isEmpty()){
                            for (int v=0; v < vacas.size(); v++){
                                Vacaciones vac = vacas.get(v);
                                vac.setEstatus(3);
                                vacdao.actualizar(vac);
                            }
                        }
                        
                        datos.remove("bajaEmpleado");
                        datos.remove("fechabaja");
                        datos = ObtenerEmpleadosDeSucursal(datos);
                break;
                case 7:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
                case 8:
                    //activar empleado
                    datos = ActivarEmpleado(datos);
                    break;
                case 9: case 36:
                    datos = CargarEmpAEditar(datos);
                    break;
                case 10: case 12:
                    datos = ImprimirGafetes(datos);
                    break;
                case 11:
                    datos = CargarImprimirGafetes(datos);
                    break;
                case 13:
                    datos = ObtenerFamiliares(datos);
                    break;
                case 14:
                    datos = ObtenerMedios(datos);
                    break;
                case 15: case 17: case 19: case 32: case 42: case 44:
                    datos = ImprimirReporte(datos);
                    break;
                case 16:
                    datos = Formatos(datos);
                    break;
                case 18: case 30: case 31:
                    datos = ObtenerPlazas(datos);
                    break;
                case 20:
                    //obtener docs del empleado
                    datos = ObtenerDocumentos(datos);
                    break;
                case 21:
                    //aplicar filtros
                    datos = AplicarFiltros(datos);
                    break;
                case 22:
                    //quitar filtros aplicados
                    datos = ObtenerEmpleadosDeSucursal(datos);
                    datos.remove("banfiltro");
                    break;
                case 23:
                    //cambiar de sucursal el empleado, obtener datos
                    datos = ObtenerEmpleado(datos);
                    datos = CargarSucursalesDistintasDelEmpleado(datos);
                    break;
                case 24:
                    //aplicar cambio de sucursal
                    datos = CambiarSucursalDeEmpleado(datos);
                    break;
                case 25: case 43:
                    datos = ImprimirXls(datos);
                    break;
                case 26:
                    //alta imss empleado
                    datos = AltaImss(datos);
                    break;
                case 27:
                    datos = BajaImss(datos);
                    break;
                case 28:
                    //ir a finiquito
                    datos = IrAFiniquito(datos);
                    if (datos.get("error")!=null){
                        sesion.setError(true);
                        sesion.setMensaje(datos.get("error").toString());
                        sesion.setPaginaSiguiente("/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp");
                        datos.remove("error");
                    }
                    break;
                case 29:
                    //guarda finiquito
                    datos = GuardaFiniquito(datos);
                    break;
                case 33:
                    //borrar registros del historial
                    datos = BorrarRegistroIMSS(datos);
                    break;
                case 34:
                    //actualiza registro imss editado
                    datos = ActualizarRegistroIMSS(datos);
                    break;
                case 35:
                    //gestionar vacaciones
                    datos = IrAVacaciones(datos);
                    break;
                case 37:
                    datos = GuardaFirma(datos);
                    datos = ObtenerEmpleadosDeSucursal(datos);
                    break;
                case 38:
                    datos = GeneraContratoTrabajo(datos);
                    break;
                case 39:
                    datos = GuardaDatosContratoTrabajoEImprime(datos);
                    break;
                case 40:
                    datos = ConsultarPagos(datos);
                    break;
                case 41:
                    datos = GuardaFoto(datos);
                    datos = ObtenerEmpleadosDeSucursal(datos);
                    break;
                case 50:
                    //ir al principio
                    datos = CargarPrincipio(datos);
                    //datos = ObtenerEstatusDocumentacion(datos);
                    break;
                case 51:
                    //mostrar anteriores
                    datos = CargarAnteriores(datos);
                    //datos = ObtenerEstatusDocumentacion(datos);
                    break;
                case 52:
                    //mostrar siguientes
                    datos = CargarSiguientes(datos);
                    //datos = ObtenerEstatusDocumentacion(datos);
                    break;
                case 53:
                    //mostrar siguientes
                    datos = CargarFinal(datos);
                    //datos = ObtenerEstatusDocumentacion(datos);
                    break;
                case 88:
                    //salir de consultar pagos
                    datos.remove("empleado");
                    datos.remove("pagos");
                    break;
                case 89:
                    datos.remove("empleado");
                    datos.remove("nuevo");
                    datos.remove("contrato");
                    break;
                case 90:
                    //cancelar editar firma
                    datos.remove("firma");
                    datos.remove("editarEmpleado");
                    break;
                    
                case 92:
                    //cancelar finiquito
                    datos.remove("empleado");
                    datos.remove("finiciovacaciones");
                    datos.remove("faguinaldo");
                    datos.remove("diasantiguedad");
                    datos.remove("aniosantiguedad");
                    datos.remove("ultimaplaza");
                    datos.remove("sueldodiario");
                    datos.remove("ultimohistorialimss");
                    datos.remove("diasagui");
                    datos.remove("diasvac");
                    break;
                case 93:
                    //cancelar cambio de sucursal
                    datos.remove("empleado");
                    datos.remove("sucscambio");
                    break;
                case 94:
                    datos.remove("empleado");
                    datos.remove("plazas");
                    break;
                case 95:
                    datos.remove("empleado");
                    break;
                case 96:
                    datos.remove("listagafetes");
                    break;
                case 97:
                    //cancelar nueva foto
                    datos.remove("fotoSel");
                    datos.remove("editarEmpleado");
                    break;
                case 98:
                    //cancelar nuevo empleado
                    datos.remove("accion");
                    datos.remove("nuevoEmpleado");
                    datos.remove("editarEmpleado");
                    datos.remove("pestaña");
                    datos.remove("min");
                    datos.remove("max");
                    datos.remove("banalta");
                    break;

                case 91: case 99:
                          datos = new HashMap();
                    break;
           }
        
        sesion.setDatos(datos);        
        return sesion;
        
      }
      private HashMap CargaDatosNuvEmp(HashMap datos) 
      {
          int paso = Integer.parseInt(datos.get("paso").toString());
          datos.put("accion", "nuevo");
          if (paso == 4 || paso == 45)
              datos.put("accion", "editar");
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
                    datos.put("sucursales", sucDao.obtenerListaSucYMatriz());
                    //obetner lista titulos
                    TituloDao tituDao = new TituloDao();
                    datos.put("titulos", tituDao.obtenerListaActivos());
                    BancoDao bandao = new BancoDao();
                    datos.put("bancos", bandao.obtenerListaActivos());
                    
                    //obtener registros patronales
                    List<String> rps = new ArrayList<String>();
                    List<Sucursal> sucus = (List<Sucursal>)datos.get("sucursales");
                    for (int i=0; i < sucus.size(); i++){
                        Sucursal suc = sucus.get(i);
                        if (!suc.getRegistropatronal().equals("")){
                            rps.add(suc.getRegistropatronal());
                        }
                    }
                    datos.put("regispatrs", rps);
                    
                    return datos;
      }
      
      private HashMap CargarEmpAEditar(HashMap datos) {
        EmpleadoDao empDao = new EmpleadoDao();
        Empleado editar = (Empleado) datos.get("editarEmpleado");
        editar = empDao.obtener(editar.getNumempleado());
        datos.put("editarEmpleado", editar);
        datos.put("clvact", editar.getClave());
        return datos;
       }
      
    private HashMap ObtenerInactivos(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursal");
        List<Empleado> listado = new ArrayList<Empleado>();
        EmpleadoDao empDao = new EmpleadoDao();
        listado = empDao.obtenerListaInactivosDeSucursal(suc.getId());
        datos.put("inactivos", listado);
        return datos;     
    }

    private HashMap ActivarEmpleado(HashMap datos) {
        Empleado emp = (Empleado) datos.get("activarEmpleado");
        EmpleadoDao empDao = new EmpleadoDao();
        emp = empDao.obtener(emp.getNumempleado());
        UtilDao utdao = new UtilDao();
        emp.setEstatus(1);
        emp.setFecha(utdao.hoy()); // se actualiza la fecha de alta con la fecha en que se reactiva.
        emp.setFechabaja(null);
        //validar campo registro patronal
        if (emp.getRegistropatronal()==null || emp.getRegistropatronal().isEmpty()){
            Sucursal suc = (Sucursal)datos.get("sucursal");
            emp.setRegistropatronal(suc.getRegistropatronal());
        }
        empDao.actualizar(emp);
        //empDao.actualizarEstatus(1, emp.getNumempleado());
        datos.remove("activarEmpleado");
        datos = ObtenerInactivos(datos);
        datos.put("lista", empDao.obtenerListaActivos());
        datos = ObtenerEmpleadosDeSucursal(datos);
        return datos;
    }

    private HashMap ObtenerSucursales(HashMap datos) {
        SucursalDao sucDao = new SucursalDao();
        datos.put("sucursales", sucDao.obtenerListaSucYMatriz());
        return datos;
    }

    private HashMap ObtenerEmpleadosDeSucursal(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursal");
        List<Empleado> listado = new ArrayList<Empleado>();
        if (suc.getId()!=0){
            SucursalDao sucDao = new SucursalDao();
            suc = sucDao.obtener(suc.getId());
            datos.put("sucursal", suc);

            EmpleadoDao empDao = new EmpleadoDao();
            listado = empDao.obtenerListaActivosDeSucursal(suc.getId());
            datos.put("listacompleta", listado);
            if (listado.size()>grupos){
                datos.put("grupos", "1");
                datos.put("inicial", "1");
                datos = ObtenerGrupo(datos);
            } else {
                datos.put("grupos", "0");
                datos.put("listado", listado);
            }
            //datos = ObtenerEstatusDocumentacion(datos);
            
        }
        return datos;
    }

    private HashMap GuardarEmpleado(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursal");
        EmpleadoDao empDao = new EmpleadoDao();
        Empleado empLoad = new Empleado();
        UtilDao utDao = new UtilDao();
        datos.put("hoy", utDao.hoy());
        
        if (datos.get("accion").toString().equals("nuevo")){
            empLoad = (Empleado) datos.get("nuevoEmpleado");
            empLoad.getPersona().setSucursal(sucSel);
            //empLoad.setFecha(utDao.hoy());
            empLoad.setEstatus(1);
            empLoad.getPersona().getDireccion().setTipo('1');
        } else {
            empLoad = (Empleado) datos.get("editarEmpleado");
        }
        
        MunicipioDao munDao = new MunicipioDao();
        empLoad.getPersona().getDireccion().setPoblacion(munDao.obtener(empLoad.getPersona().getDireccion().getPoblacion().getIdmunicipio()));

        if (datos.get("accion").toString().equals("nuevo") && empDao.ValidaClaveEmpleado(empLoad)){
            datos.put("error", "La Clave del Empleado ya existe");
            return datos;
        } else if (datos.get("accion").toString().equals("editar")){
            String clvact = datos.get("clvact").toString();
            if (!clvact.equals(empLoad.getClave()) && empDao.ValidaClaveEmpleado(empLoad)){
                datos.put("error", "La Clave del Empleado ya existe");
                return datos;
            }
        }
        
        
        if (datos.get("accion").toString().equals("nuevo")){
            empDao.guardar(empLoad);
            datos.remove("nuevoEmpleado");
        } else {
            empDao.actualizar(empLoad);
            datos.remove("editarEmpleado");
            datos.remove("historial");
        }
        
        datos.remove("accion");
        if (datos.get("paginasig").toString().equals("/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp"))
            datos = ObtenerInactivos(datos);
        else
            datos = ObtenerEmpleadosDeSucursal(datos);
        
        return datos;
    }

    private HashMap GuardaFoto(HashMap datos) {
        Empleado empl = (Empleado) datos.get("editarEmpleado");
        String foto = datos.get("nuevaFoto").toString();
        empl.setImagen(foto);
        EmpleadoDao empDao = new EmpleadoDao();
        empDao.actualizar(empl);
        UtilMod utMod = new UtilMod();
        String ruta = datos.get("rutaFoto").toString();
        utMod.reducirFoto(ruta);
        datos.remove("fotoSel");
        datos.remove("nuevaFoto");
        datos.remove("editarEmpleado");
        return datos;
    }
    
    private HashMap ImprimirGafetes(HashMap datos) {
        //obtener el dia, mes y año
        HashMap param = (HashMap)datos.get("parametros");
        UtilDao utDao = new UtilDao();
        Date hoy = utDao.hoy();
        Calendar cal = Calendar.getInstance();
        cal.setTime(hoy);
        String dia = Integer.toString(cal.get(Calendar.DAY_OF_MONTH));
        int nmes = cal.get(Calendar.MONTH)+1;
        String smes = "";
        switch (nmes){
            case 1: smes = "Enero";break;
            case 2: smes = "Febrero";break;
            case 3: smes = "Marzo";break;
            case 4: smes = "Abril";break;
            case 5: smes = "Mayo";break;
            case 6: smes = "Junio";break;
            case 7: smes = "Julio";break;
            case 8: smes = "Agosto";break;
            case 9: smes = "Septiembre";break;
            case 10: smes = "Octubre";break;
            case 11: smes = "Noviembre";break;
            case 12: smes = "Diciembre";break;                
        }
        String anio = Integer.toString(cal.get(Calendar.YEAR));
        param.put("DIA", dia);
        param.put("MES", smes);
        param.put("ANIO", anio);
        datos.put("parametros", param);
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }
    
    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }

    private HashMap CargarImprimirGafetes(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursal");
        EmpleadoDao empDao = new EmpleadoDao();
        datos.put("listagafetes", empDao.obtenerListaFullDeSucursalPorClave(suc.getId()));
        return datos;
    }
    
    private HashMap ObtenerGrupo(HashMap datos) {
        List<Empleado> empleados = (List<Empleado>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Empleado> grupo = new ArrayList<Empleado>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin > empleados.size()){
            fin = empleados.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(empleados.get(i));
        }
        datos.put("listado", grupo);
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
        List<Empleado> listacom = (List<Empleado>)datos.get("listacompleta");
        int total = listacom.size();
        int ini = total-grupos;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap ObtenerFamiliares(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        FamiliarDao famDao = new FamiliarDao();
        datos.put("familiares", famDao.obtenerActivosDeEmpleado(empl.getNumempleado()));
        return datos;
    }

    private HashMap ObtenerMedios(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        PersonaMedioDao pmDao = new PersonaMedioDao();
        datos.put("medios", pmDao.obtenerActivosDePersona(empl.getPersona().getIdpersona()));
        return datos;
    }

    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }

    private HashMap Formatos(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        return datos;
    }

    private HashMap ObtenerPlazas(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        PlazaDao plzDao = new PlazaDao();
        UtilDao utdao = new UtilDao();
        int paso = Integer.parseInt(datos.get("paso").toString());
        datos.put("titulo", "VIGENTES");
        if (paso == 18 || paso == 31)
            datos.put("plazas", plzDao.obtenerPlazasVigentesDeEmpleado(empl.getNumempleado(), utdao.hoy()));//obtenerListaActivasDeEmpleado(empl.getNumempleado()));
        else{
            datos.put("plazas", plzDao.obtenerPlazasNoVigentesDeEmpleado(empl.getNumempleado(), utdao.hoy()));
            datos.put("titulo", "NO VIGENTES");
        }
        return datos;
    }

    private HashMap ObtenerDocumentos(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        DocumentoDao docdao = new DocumentoDao();
        List<Documento> docs = docdao.obtenerActivosDeEmpleado(empl.getNumempleado());
        datos.put("listacompletadoc", docs);
        if (docs.size()>grupos){
            datos.put("gruposdoc", "1");
            datos.put("inicialdoc", "1");
            datos = ObtenerGrupoDocs(datos);
        } else {
            datos.put("gruposdoc", "0");
            datos.put("documentos", docs);
        }
        return datos;
    }

    private HashMap ObtenerGrupoDocs(HashMap datos) {
        List<Documento> docs = (List<Documento>)datos.get("listacompletadoc");
        datos.put("anterioresdoc", "0");
        int inicial = Integer.parseInt(datos.get("inicialdoc").toString());
        if (inicial>1)
            datos.put("anterioresdoc", "1");
        List<Documento> grupo = new ArrayList<Documento>();
        int fin = grupos +(inicial-1);
        datos.put("siguientesdoc", "1");
        if (fin > docs.size()){
            fin = docs.size();
            datos.put("siguientesdoc", "0");
        }
        datos.put("finaldoc", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(docs.get(i));
        }
        datos.put("documentos", grupo);
        return datos;
    }

    private HashMap AplicarFiltros(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursal");
        HashMap filtros = (HashMap)datos.get("filtros");
        
        String consulta = "from Empleado where estatus=1 and persona.sucursal="+Integer.toString(suc.getId());
        
        String sfiltros = "";
        if (!filtros.get("clave").toString().equals(""))
            sfiltros += " and clave like '%"+filtros.get("clave").toString()+"%'";
        if (!filtros.get("nombre").toString().equals(""))
            sfiltros += " and persona.nombre like '%"+filtros.get("nombre").toString()+"%'";
        if (!filtros.get("paterno").toString().equals(""))
            sfiltros += " and persona.paterno like '%"+filtros.get("paterno").toString()+"%'";
        if (!filtros.get("materno").toString().equals(""))
            sfiltros += " and persona.materno like '%"+filtros.get("materno").toString()+"%'";

        consulta += sfiltros;
        consulta +=" order by persona.paterno, persona.materno, persona.nombre, clave, "+
                    " persona.direccion.poblacion.estado, persona.direccion.poblacion";
        
        List<Empleado> listado = new ArrayList<Empleado>();
        EmpleadoDao empDao = new EmpleadoDao();
        listado = empDao.obtenerListaConsulta(consulta);
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompleta", listado);
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("listado", listado);
        }
        
        datos.put("banfiltro", "1");        
        return datos;
    }

    private HashMap ObtenerEmpleado(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        return datos;
    }

    private HashMap CargarSucursalesDistintasDelEmpleado(HashMap datos) {
        List<Sucursal> sucursales = (List<Sucursal>)datos.get("sucursales");
        Sucursal sucsel = (Sucursal)datos.get("sucursal");
        List<Sucursal> sucscambio = new ArrayList<Sucursal>();
        for (int i=0; i < sucursales.size(); i++){
            Sucursal suc = sucursales.get(i);
            if (suc.getId()!=sucsel.getId()){
                sucscambio.add(suc);
            }
        }
        datos.put("sucscambio", sucscambio);
        return datos;
    }

    private HashMap CambiarSucursalDeEmpleado(HashMap datos) {
        Sucursal nueva = (Sucursal)datos.get("nuevasuc");
        Empleado emp = (Empleado)datos.get("empleado");
        emp.getPersona().setSucursal(nueva);
        EmpleadoDao empDao = new EmpleadoDao();
        empDao.actualizar(emp);
        datos = ObtenerEmpleadosDeSucursal(datos);
        return datos;
    }
    
    private HashMap ImprimirXls(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("reportexls", util.generarXLS(datos.get("reporte").toString(), (Map)datos.get("parametros"), datos.get("temp").toString()));
        return datos;
    }

    private HashMap ObtenerEstatusDocumentacion(HashMap datos) {
        //todos los personales y al menos uno de estudios = completos
        //faltan personales = personales pendientes
        //ningun comprobante de estudios = estudios pendientes
        
        //obtener total docs personales posibles
        TipoDocumentoDao tddao = new TipoDocumentoDao();
        List<TipoDocumento> lstd = tddao.obtenerListaActivosDeCategoria(1);
        int totdp = lstd.size();
        List<Empleado> emples = (List<Empleado>)datos.get("listado");
        List<String> docus = new ArrayList<String>();
        DocumentoDao docdao = new DocumentoDao();
        for (int i=0; i < emples.size(); i++){
            Empleado emp = emples.get(i);
            //obtener total docs personales del empleado
            List<Documento> tdper = docdao.obtenerDocumentosDeEmpleadoDeCategoria(emp.getNumempleado(), 1);
            //obtener total docs estudios del empleado
            List<Documento> tdest = docdao.obtenerDocumentosDeEmpleadoDeCategoria(emp.getNumempleado(), 2);
            if (tdper.size()<totdp)
                docus.add("PERSONALES PENDIENTES");
            else if (tdest.size()==0)
                docus.add("ESTUDIOS PENDIENTES");
            else if (tdper.size()>=totdp && tdest.size()>0)
                docus.add("SIN PENDIENTES");
        }
        
        datos.put("estatusdocs", docus);
        return datos;
    }

    private HashMap ObtenerHistorialIMSS(HashMap datos) {
        HistorialIMSSDao hist = new HistorialIMSSDao();
        Empleado empl = (Empleado)datos.get("editarEmpleado");
        List<HistorialIMSS> historial = hist.obtenerHistorialDeEmpleado(empl.getNumempleado());
        datos.put("historial", historial);
        UtilDao utdao = new UtilDao();
        Date hoy = utdao.hoy();
        SimpleDateFormat ffech = new SimpleDateFormat("dd-MM-yyyy");
        String min = "", max = "", banalta = "";
        if (historial!=null && historial.size()>0){
            HistorialIMSS hiemp = historial.get(0);
            
            //String dbaja = hiemp.getFechabaja()!=null?ffech.format(hiemp.getFechabaja()):"";
            Calendar cal = new GregorianCalendar();
            cal.setLenient(false);
            if (hiemp.getFechabaja()!=null){
                cal.setTime(hiemp.getFechabaja());
                cal.add(Calendar.DAY_OF_MONTH, 1);
                String dbaja = ffech.format(cal.getTime());            
                min = dbaja;
                max = ffech.format(hoy);
                banalta = "1";
            } else {
                cal.setTime(hiemp.getFechaalta());
                cal.add(Calendar.DAY_OF_MONTH, 1);
                String dalta = ffech.format(cal.getTime());
                min = dalta;
                max = ffech.format(hoy);
                banalta = "0";
            }
        } else {
            max = ffech.format(hoy);
            banalta = "1";
        }
        datos.put("min", min);
        datos.put("max", max);
        datos.put("banalta", banalta);
        return datos;
    }

    private HashMap AltaImss(HashMap datos) {
        Empleado empl = (Empleado)datos.get("editarEmpleado");
        HistorialIMSS hist = new HistorialIMSS();
        HistorialIMSSDao histdao = new HistorialIMSSDao();
        hist.setEmpleado(empl);
        hist.setFechaalta((Date)datos.get("fechamov"));
        hist.setRegistropatronal(datos.get("regpat").toString());
        hist.setSalariobase(((Float)datos.get("sbc")).floatValue());
        histdao.guardar(hist);
        
        datos.put("pestaña", "3");
        EmpleadoDao empdao = new EmpleadoDao();
        empl.setNss(datos.get("nss").toString());
        empl.setCotiza(1);
        empdao.actualizar(empl);
        datos.put("editarEmpleado", empl);
        datos = ObtenerHistorialIMSS(datos);
        datos.remove("fechamov");
        datos.remove("nss");
        datos.remove("regpat");
        return datos;
    }

    private HashMap BajaImss(HashMap datos) {
        HistorialIMSSDao histdao = new HistorialIMSSDao();
        Empleado empl = (Empleado)datos.get("editarEmpleado");
        HistorialIMSS hist = histdao.obtenerHistorialActivoDeEmpleado(empl.getNumempleado());
        hist.setFechabaja((Date)datos.get("fechamov"));
        histdao.actualizar(hist);
        EmpleadoDao empdao = new EmpleadoDao();
        empl.setCotiza(0);
        empdao.actualizar(empl);
        //desactivar los movs extras registrados y marcados como prestación IMSS
        UtilDao utdao = new UtilDao();
        PlazaDao plzdao = new PlazaDao();
        List<Plaza> plazas = plzdao.obtenerPlazasVigentesDeEmpleado(empl.getNumempleado(), utdao.hoy());
        for (int p=0; p < plazas.size(); p++){
            Plaza pl = plazas.get(p);
            MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
            medao.desactivaPrestacionesImssDePlaza(pl.getId());
        }
        // fin desactivar movs extras prestacion imss
        datos.put("editarEmpleado", empl);
        datos = ObtenerHistorialIMSS(datos);
        datos.remove("fechamov");
        datos.remove("nss");
        datos.remove("regpat");
        datos.put("pestaña", "3");
        return datos;
    }

    private HashMap IrAFiniquito(HashMap datos) {
        //obtener datos del empleado
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        
        //obtener el historial imss del empleado
        HistorialIMSSDao hssdao = new HistorialIMSSDao();
        List<HistorialIMSS> hss = hssdao.obtenerHistorialDeEmpleado(empl.getNumempleado());
        HistorialIMSS ulthss = null;
        if (!hss.isEmpty())
            ulthss = hss.get(0);
        datos.put("ultimohistorialimss", ulthss);
        
        
        if (empl.getFiniquito()==0){        
            //calcular la antiguedad en dias y en años
            UtilMod utmod = new UtilMod();
            int diasant = utmod.DiasEntreFechas(empl.getFecha(), empl.getFechabaja())+1;
            datos.put("diasantiguedad", Integer.toString(diasant));
            double aniosant = diasant/365.25;
            aniosant = utmod.Redondear(aniosant, 2);
            datos.put("aniosantiguedad", new Double(aniosant));
            
            //calcular fecha inicial del periodo pendiente de vacaciones
            Calendar faltaempr = Calendar.getInstance();
            faltaempr.setTime(empl.getFecha());
            int mesalta = faltaempr.get(Calendar.MONTH)+1;
            int diaalta = faltaempr.get(Calendar.DAY_OF_MONTH);
            Calendar fbajaempr = Calendar.getInstance();
            fbajaempr.setTime(empl.getFechabaja());
            int aniobaja = fbajaempr.get(Calendar.YEAR);
            int mesbaja = fbajaempr.get(Calendar.MONTH)+1;
            int diabaja = fbajaempr.get(Calendar.DAY_OF_MONTH);
            Calendar fref1 = Calendar.getInstance();
            fref1.set(aniobaja-1, mesalta-1, diaalta);
            Calendar fref2 = Calendar.getInstance();
            fref2.set(aniobaja-1, mesbaja-1, diabaja);
            Date finivac = new Date();
            Calendar fresul = Calendar.getInstance();
            if (fref1.before(fref2)){
                fresul.set(aniobaja, mesalta-1, diaalta,0,0,0);
            } else {
                fresul.set(aniobaja-1, mesalta-1, diaalta,0,0,0);
            }
            finivac = fresul.getTime();
            datos.put("finiciovacaciones", finivac);
            
            //calcular los dias de vacaciones correspondientes a la antiguedad
            int diasvacanti = 6;
            if (aniosant>1.00f && aniosant<=2.00f)
                diasvacanti = 8;
            else if (aniosant>2.00f && aniosant<=3.00f)
                diasvacanti = 10;
            else if (aniosant>3.00f && aniosant<=4.00f)
                diasvacanti = 12;
            else if (aniosant>4.00f && aniosant<10.00f)
                diasvacanti = 14;
            else if (aniosant>=10.00f && aniosant<15.00f)
                diasvacanti = 16;
            else if (aniosant>=15.00f && aniosant<20.00f)
                diasvacanti = 18;
            else if (aniosant>=20.00f && aniosant<25.00f)
                diasvacanti = 20;
            else if (aniosant>=25.00f && aniosant<30.00f)
                diasvacanti = 22;
            datos.put("diasvacanti", Integer.toString(diasvacanti));
            
            //calcular fecha computo aguinaldo
            fref1.set(aniobaja, 0, 1);
            Date faguinaldo = new Date();
            if (fref1.before(faltaempr))
                faguinaldo = faltaempr.getTime();
            else
                faguinaldo = fref1.getTime();
            datos.put("faguinaldo", faguinaldo);
            //obtener la plaza más reciente
            PlazaDao plzdao = new PlazaDao();
            Plaza ultPlaza = plzdao.obtenerUltimaPlazaDeEmpleado(empl.getNumempleado());
            if (ultPlaza==null){
                datos.put("error", "El empleado seleccionado no tiene ninguna plaza registrada");
                return datos;
            }
            
            datos.put("ultimaplaza", ultPlaza);
            //calcular el sueldo diario de su ultima plaza
            double sueldodia = ultPlaza.getSueldo()/15;
            if (ultPlaza.getPeriodopago().getIdPerPagos()==3)
                sueldodia = ultPlaza.getSueldo()/30;
            sueldodia = utmod.Redondear(sueldodia, 2);
            datos.put("sueldodiario", new Double(sueldodia));

            //calcular dias aguinaldo
            Date fiv = new Date();
            String sfiv = "";
            SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
            sfiv = ffecha.format(finivac);
            try {
                fiv = ffecha.parse(sfiv);
            } catch (ParseException ex) {
                Logger.getLogger(EmpleadoMod.class.getName()).log(Level.SEVERE, null, ex);
            }
            int diasvac = utmod.DiasEntreFechas(fiv,empl.getFechabaja())+1;
            int diasagui = utmod.DiasEntreFechas(faguinaldo,empl.getFechabaja())+1;
            datos.put("diasagui", new Integer(diasagui));
            utmod = new UtilMod();
            datos.put("diasvac", new Integer(diasvac));
        } else {
            FiniquitoDao findao = new FiniquitoDao();
            Finiquito fini = findao.obtenerFiniquitoDeEmpleado(empl.getNumempleado());
            datos.put("finiquito", fini);
        }
        return datos;
    }

    private HashMap IrAFiniquitoNuevo(HashMap datos) {
        //obtener datos del empleado
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        
        //obtener el historial imss del empleado
        HistorialIMSSDao hssdao = new HistorialIMSSDao();
        List<HistorialIMSS> hss = hssdao.obtenerHistorialDeEmpleado(empl.getNumempleado());
        HistorialIMSS ulthss = null;
        if (!hss.isEmpty())
            ulthss = hss.get(0);
        datos.put("ultimohistorialimss", ulthss);
        
        if (empl.getFiniquito()==0){        
            //calcular fecha inicial del periodo pendiente de vacaciones
            Calendar faltaempr = Calendar.getInstance();
            faltaempr.setTime(empl.getFecha());
            int mesalta = faltaempr.get(Calendar.MONTH)+1;
            int diaalta = faltaempr.get(Calendar.DAY_OF_MONTH);
            Calendar fbajaempr = Calendar.getInstance();
            fbajaempr.setTime(empl.getFechabaja());
            int aniobaja = fbajaempr.get(Calendar.YEAR);
            int mesbaja = fbajaempr.get(Calendar.MONTH)+1;
            int diabaja = fbajaempr.get(Calendar.DAY_OF_MONTH);
            Calendar fref1 = Calendar.getInstance();
            fref1.set(aniobaja-1, mesalta-1, diaalta);
            Calendar fref2 = Calendar.getInstance();
            fref2.set(aniobaja-1, mesbaja-1, diabaja);
            Date finivac = new Date();
            Calendar fresul = Calendar.getInstance();
            if (fref1.before(fref2)){
                fresul.set(aniobaja, mesalta-1, diaalta,0,0,0);
            } else {
                fresul.set(aniobaja-1, mesalta-1, diaalta,0,0,0);
            }
            finivac = fresul.getTime();
            datos.put("finiciovacaciones", finivac);
            //calcular fecha computo aguinaldo
            fref1.set(aniobaja, 0, 1);
            Date faguinaldo = new Date();
            if (fref1.before(faltaempr))
                faguinaldo = faltaempr.getTime();
            else
                faguinaldo = fref1.getTime();
            datos.put("faguinaldo", faguinaldo);
            //calcular la antiguedad en dias y en años
            UtilMod utmod = new UtilMod();
            int diasant = utmod.DiasEntreFechas(empl.getFecha(), empl.getFechabaja())+1;
            datos.put("diasantiguedad", Integer.toString(diasant));
            double aniosant = diasant/365.25;
            aniosant = utmod.Redondear(aniosant, 2);
            datos.put("aniosantiguedad", new Double(aniosant));
            //obtener la plaza más reciente
            PlazaDao plzdao = new PlazaDao();
            Plaza ultPlaza = plzdao.obtenerUltimaPlazaDeEmpleado(empl.getNumempleado());
            if (ultPlaza==null){
                datos.put("error", "El empleado seleccionado no tiene ninguna plaza registrada");
                return datos;
            }
            
            datos.put("ultimaplaza", ultPlaza);
            //calcular el sueldo diario de su ultima plaza
            double sueldodia = ultPlaza.getSueldo()/15;
            if (ultPlaza.getPeriodopago().getIdPerPagos()==3)
                sueldodia = ultPlaza.getSueldo()/30;
            sueldodia = utmod.Redondear(sueldodia, 2);
            datos.put("sueldodiario", new Double(sueldodia));

            //calcular dias aguinaldo
            Date fiv = new Date();
            String sfiv = "";
            SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
            sfiv = ffecha.format(finivac);
            try {
                fiv = ffecha.parse(sfiv);
            } catch (ParseException ex) {
                Logger.getLogger(EmpleadoMod.class.getName()).log(Level.SEVERE, null, ex);
            }
            int diasvac = utmod.DiasEntreFechas(fiv,empl.getFechabaja())+1;
            int diasagui = utmod.DiasEntreFechas(faguinaldo,empl.getFechabaja())+1;
            datos.put("diasagui", new Integer(diasagui));
            utmod = new UtilMod();
            datos.put("diasvac", new Integer(diasvac));
        } else {
            FiniquitoDao findao = new FiniquitoDao();
            Finiquito fini = findao.obtenerFiniquitoDeEmpleado(empl.getNumempleado());
            datos.put("finiquito", fini);
        }
        return datos;
    }
    
    private HashMap GuardaFiniquito(HashMap datos) {
        Finiquito finiquito = (Finiquito)datos.get("finiquito");
        
        Empleado emp = (Empleado)datos.get("empleado");
        EmpleadoDao empdao = new EmpleadoDao();
        emp.setFiniquito(1);
        empdao.actualizar(emp);
        
        
        finiquito.setEmpleado(emp);
        finiquito.setAntanios(((Double)datos.get("aniosantiguedad")).floatValue());
        finiquito.setAntdias(Integer.parseInt(datos.get("diasantiguedad").toString()));
        finiquito.setFaguinaldo((Date)datos.get("faguinaldo"));
        finiquito.setFvacaciones((Date)datos.get("finiciovacaciones"));
        finiquito.setSueldodia(((Double)datos.get("sueldodiario")).floatValue());
        UtilDao utdao = new UtilDao();
        finiquito.setFecharegistro(utdao.hoy());

        FiniquitoDao findao = new FiniquitoDao();
        Finiquito fini = findao.obtenerFiniquitoDeEmpleado(emp.getNumempleado());
        if (fini!=null){
            finiquito.setId(fini.getId());
            findao.actualizar(finiquito);
        } else 
            findao.guardar(finiquito);
        
        return datos;
    }

    private HashMap BorrarRegistroIMSS(HashMap datos) {
        HistorialIMSS hist = new HistorialIMSS();
        HistorialIMSSDao histdao = new HistorialIMSSDao();
        
        String ids = datos.get("ids").toString();
        StringTokenizer tokens=new StringTokenizer(ids, ",");
        while(tokens.hasMoreTokens()){
            int i = Integer.parseInt(tokens.nextToken());
            hist = histdao.obtener(i);
            histdao.eliminar(hist);
        }
        datos = ObtenerHistorialIMSS(datos);
        datos.remove("ids");
        datos.put("pestaña", "3");
        
        return datos;
    }

    private HashMap ActualizarRegistroIMSS(HashMap datos) {
        HistorialIMSS hist = new HistorialIMSS();
        HistorialIMSSDao histdao = new HistorialIMSSDao();
        
        String ids = datos.get("id").toString();
        int i = Integer.parseInt(ids);
        hist = histdao.obtener(i);
        hist.setFechaalta((Date)datos.get("fechamovalta"));
        if (datos.get("fechamovbaja")!=null)
            hist.setFechabaja((Date)datos.get("fechamovbaja"));
        hist.setRegistropatronal(datos.get("regpat").toString());
        hist.setSalariobase(((Float)datos.get("sbc")).floatValue());
        histdao.actualizar(hist);
        
        Empleado empl = (Empleado)datos.get("editarEmpleado");
        EmpleadoDao empdao = new EmpleadoDao();
        empl.setNss(datos.get("nss").toString());
        empl.setCotiza(1);
        if (datos.get("fechamovbaja")!=null)
            empl.setCotiza(0);
        empdao.actualizar(empl);
        
        
        datos = ObtenerHistorialIMSS(datos);
        datos.remove("ids");
        datos.remove("fechamovalta");
        datos.remove("fechamovbaja");
        datos.remove("nss");
        datos.remove("regpat");
        datos.put("pestaña", "3");
        
        return datos;
    }

    private HashMap IrAVacaciones(HashMap datos) {
        Empleado emp = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        emp = empDao.obtener(emp.getNumempleado());
        datos.put("empleado", emp);
        
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

    private HashMap GuardaFirma(HashMap datos) {
        Empleado empl = (Empleado) datos.get("editarEmpleado");
        String firma = datos.get("nuevaFirma").toString();
        empl.setFirma(firma);
        EmpleadoDao empDao = new EmpleadoDao();
        empDao.actualizar(empl);
        datos.remove("firma");
        datos.remove("nuevaFirma");
        datos.remove("editarEmpleado");
        return datos;
    }

    private HashMap GeneraContratoTrabajo(HashMap datos) {
        //obtener datos del empleado
        Empleado empl = (Empleado)datos.get("empleado");
        EmpleadoDao empDao = new EmpleadoDao();
        empl = empDao.obtener(empl.getNumempleado());
        datos.put("empleado", empl);
        
        //obtener datos registrados del contrato
        ContratoTrabajoDao ctdao = new ContratoTrabajoDao();
        ContratoTrabajo ct = ctdao.obtenerContratoTrabajoDeEmpleado(empl.getNumempleado());
        datos.put("nuevo", "0");
        if (ct==null){
            ct = new ContratoTrabajo();
            datos.put("nuevo", "1");
        }
        datos.put("contratotrabajo", ct);
        
        return datos;
    }

    private HashMap GuardaDatosContratoTrabajoEImprime(HashMap datos) {
        UtilMod utmod = new UtilMod();
        UtilDao utdao = new UtilDao();
        Empleado emp = (Empleado)datos.get("empleado");
        ContratoTrabajoDao ctdao = new ContratoTrabajoDao();
        ContratoTrabajo ct = (ContratoTrabajo)datos.get("contratotrabajo");
        ct.setEmpleado(emp);
        ct.setFecha(utdao.hoy());
        if (datos.get("nuevo").toString().equals("1"))
            ctdao.guardar(ct);
        else
            ctdao.actualizar(ct);
        
        //Calcula sueldo en letra
        PlazaDao plzdao = new PlazaDao();
        Plaza plz = plzdao.obtenerUltimaPlazaDeEmpleado(emp.getNumempleado());
        String sueldoaux = new Float(plz.getSueldo()).toString();
        StringTokenizer tokens=new StringTokenizer(sueldoaux, ".");
        int sueldo1 = Integer.parseInt(tokens.nextToken());
        String sueldo2 = String.format("%2s", tokens.nextToken()).replace(' ', '0');;
        
        String ssueldo1 = utmod.convertirLetras(sueldo1).toUpperCase();
        String sueldoletra = ssueldo1+" PESOS "+sueldo2+"/100 M.N.";
        
        HashMap param = (HashMap) datos.get("parametros");
        param.put("PLAZA", plz.getId());
        param.put("SUELDOLETRA", sueldoletra);
        
        datos.put("parametros", param);
        datos = ImprimirReporte(datos);
        return datos;
    }

    private HashMap ConsultarPagos(HashMap datos) {
        Empleado emp = (Empleado)datos.get("empleado");
        EmpleadoDao empdao = new EmpleadoDao();
        emp = empdao.obtener(emp.getNumempleado());
        DetalleNominaDao dndao = new DetalleNominaDao();
        List<Nomina> nominas = dndao.obtenerNominasDeEmpleado(emp.getNumempleado());
        List<HashMap> pagos = new ArrayList<HashMap>();
        for (int n=0; n < nominas.size(); n++){
            Nomina nom = nominas.get(n);
            HashMap regpago = new HashMap();
            regpago.put("nomina", nom);
            //obtener percepciones y deducciones
            List<DetalleNomina> percepciones = dndao.obtenerPercepcionesDeEmpleadoEnNomina(emp.getNumempleado(), nom.getId());
            regpago.put("percepciones", percepciones);
            List<DetalleNomina> deducciones = dndao.obtenerDeduccionesDeEmpleadoEnNomina(emp.getNumempleado(), nom.getId());
            regpago.put("deducciones", deducciones);
            //calcular totales
            float tper = 0.0f, tded = 0.0f, tnet = 0.0f;
            for (int p=0; p < percepciones.size(); p++){
                tper += percepciones.get(p).getMonto();
            }
            for (int d=0; d < deducciones.size(); d++){
                tded += deducciones.get(d).getMonto();
            }
            tnet = tper - tded;
            regpago.put("totalpercep", new Float(tper));
            regpago.put("totaldeduc", new Float(tded));
            regpago.put("neto", new Float(tnet));
            regpago.put("estatus", new Integer(percepciones.get(0).getEstatus()));
            SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
            regpago.put("fechapago", "");
            if (percepciones.get(0).getEstatus()==2 && percepciones.get(0).getFechaaplicacion()!=null)
                regpago.put("fechapago", ffecha.format(percepciones.get(0).getFechaaplicacion()));
            
            pagos.add(regpago);
        }
        datos.put("pagos", pagos);
        datos.put("empleado", emp);
        return datos;
    }
}
