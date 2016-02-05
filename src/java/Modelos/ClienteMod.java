/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Configuracion.HibernateUtil;
import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.EstadoDao;
import Modelo.Daos.Catalogos.TipoMedioDao;
import Modelo.Daos.Catalogos.TituloDao;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.Municipio;
import Modelo.Entidades.Catalogos.TipoMedio;
import java.io.UnsupportedEncodingException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author TEMOC
 */
public class ClienteMod {
    private int grupos = 0;
    public ClienteMod(){
    }

    public Sesion GestionarClientes(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
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
                //obtener los centros de trabajo del contrato seleccionado
                datos = ObtenerCentros(datos);
                datos.remove("ct");
                datos.remove("salidas");
                datos.remove("totales");
                break;
            case -2:
                //obtener los movimientos del ct seleccionado
                datos = ObtenerMovimientosDeCT(datos);
                break;
            case 1:
                //cargar sucursal
                datos = CargaSucursalSel(datos);
                //cargar clientes de la sucursal seleccionada
                datos = ObtenerClientes(datos);
                break;
            case 2:
                //ir a nuevo cliente
                datos = CargarCatalogosCliente(datos);
                datos = ObtenerCatalogos(datos);
                break;
            case 3: case 5:
                //guardar cliente
                datos = GuardarCliente(datos);
                break;
            case 4:
                //ir a editar cliente
                datos = CargarCatalogosCliente(datos);
                datos = CargarClienteAEditar(datos);
                datos = ObtenerContactos(datos);
                datos = ObtenerCatalogos(datos);
                break;
            /*case 5:
                //guardar cliente editado
                datos = ActualizaCliente(datos);
                break;*/
            case 6:
                //baja del cliente
                datos = BajaDeCliente(datos);
                break;
            case 7:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 8:
                //activar cliente
                datos = ActivarCliente(datos);
                break;
            case 9:
                //obtener rutas
                datos = ObtenerRutas(datos);
                break;
            case 10:
                //aplicar filtros
                datos = FiltrarListado(datos);
                List<Cliente> lista = (List<Cliente>)datos.get("listadoFil");
                if (lista.size()>0){
                    datos.put("filtro", "1");
                    if (lista.size()>grupos){
                        datos.put("grupos", "1");
                        datos.put("inicial", "1");
                        datos.put("listacompleta", lista);
                        datos = ObtenerGrupo(datos);                        
                    } else {
                        datos.put("grupos", "0");
                        datos.put("listado", lista);
                        datos.put("sinresultados", "0");
                    }
                }
                else {
                    datos.put("sinresultados", "1");
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/filtrarclientes.jsp");
                    datos.remove("listadoFil");
                    datos.put("condiciones", "");
                }
                break;
            case 11:
                //quitar filtros
                datos = ObtenerClientes(datos);
                datos.remove("listadoFil");
                datos.remove("filtro");
                break;
            case 12:
                //imprimir listado
                datos = ImprimirListado(datos);
                break;
            case 13:
                //ir a contratos de cliente
                datos = CargarContratos(datos);
                break;
            case 14:
                //ir a consumo del cliente
                datos = IrAConsumoDeCliente(datos);
                break;
            case 15:
                //mostrar el acumulado
                datos = CalcularResumenPorMes(datos);
                break;
            case 16:
                datos = ObtenerResumenDelAño(datos);
                break;
            case 18:
                datos = GuardaContacto(datos);
                break;
            case 19:
                datos = EditarContacto(datos);
                break;
            case 20:
                datos = BorrarContacto(datos);
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
                datos = CargarPrincipioCon(datos);
                break;
            case 61:
                //mostrar anteriores
                datos = CargarAnterioresCon(datos);
                break;
            case 62:
                //mostrar siguientes
                datos = CargarSiguientesCon(datos);
                break;
            case 63:
                //mostrar siguientes
                datos = CargarFinalCon(datos);
                break;
            case 70:
                //ir al principio
                datos = CargarPrincipioRes(datos);
                break;
            case 71:
                //mostrar anteriores
                datos = CargarAnterioresRes(datos);
                break;
            case 72:
                //mostrar siguientes
                datos = CargarSiguientesRes(datos);
                break;
            case 73:
                //mostrar siguientes
                datos = CargarFinalRes(datos);
                break;
            case 93:
                //cancelar nuevo contacto
                datos.remove("contacto");
                datos.remove("accionContacto");
                datos.put("pestaña","3");
                break;
            case 94:
                datos.remove("anios");
                datos.remove("resumenfull");
                datos.remove("resumen");
                datos.remove("gruposres");
                datos.remove("anterioresres");
                datos.remove("siguientesres");
                datos.remove("inicialres");
                datos.remove("finalres");
                datos.put("paso", "-2");
                break;
            case 95:
                //cancelar consumo cliente
                datos.remove("cliente");
                datos.remove("contratos");
                datos.remove("contrato");
                datos.remove("centros");
                datos.remove("ct");
                datos.remove("salidas");
                datos.remove("totales");
                //datos.remove("detalle");
                break;
            case 96:
                //cancelar filtrar
                datos = ObtenerClientes(datos);
                break;
            case 97:
                //cancelar inactivos
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo cliente
                datos.remove("accion");
                datos.remove("nuevoCliente");
                datos.remove("editarCliente");
                datos.remove("pestaña");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }

    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }

    private HashMap ObtenerClientes(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Cliente> listado = new ArrayList<Cliente>();
        if (sucSel.getId() != 0){
            ClienteDao cliDao = new ClienteDao();
            listado = cliDao.obtenerClientesDeSucursal(sucSel.getId());
        }
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompleta", listado);
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("listado", listado);
        }
        //datos.put("listado", listado);
        datos.put("condiciones", "");
        datos.remove("filtro");
        return datos;
    }

    private HashMap CargarCatalogosCliente(HashMap datos) {
        int paso = Integer.parseInt(datos.get("paso").toString());
        datos.put("accion", "nuevo");
        if (paso == 4)
            datos.put("accion", "editar");
        //cargar estados
        EstadoDao edoDao = new EstadoDao();
        datos.put("estados", edoDao.obtenerListaPorPrioridad());
        /*/cargar rutas
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        RutaDao rutaDao = new RutaDao();
        datos.put("rutas", rutaDao.obtenerRutasDeSucursal(sucSel.getId()));*/
        //cargar agentes
        AgenteDao agDao = new AgenteDao();
        datos.put("agentes", agDao.obtenerListaActivos());
        TipoMedioDao tmdao = new TipoMedioDao();
        datos.put("tiposmedios", tmdao.obtenerListaActivos());
        return datos;
    }

    private HashMap GuardarCliente(HashMap datos) {
        Cliente nuevo = (Cliente)datos.get("nuevoCliente");
        ClienteDao cliDao = new ClienteDao();
        if (datos.get("accion").toString().equals("editar")){
            nuevo = (Cliente)datos.get("editarCliente");
            cliDao.actualizar(nuevo);
            datos.remove("editarCliente");
        } else {
            cliDao.guardar(nuevo);
            datos.remove("nuevoCliente");
        }
        
        /*/guardar contactos
        HashMap contactos = (HashMap)datos.get("datoscontactos");
        String actuales = contactos.get("actuales").toString();
        String nombres = contactos.get("nombres").toString();
        String paternos = contactos.get("paternos").toString();
        String maternos = contactos.get("maternos").toString();
        String sexos = contactos.get("sexos").toString();
        String titulos = contactos.get("titulos").toString();
        String cargos = contactos.get("cargos").toString();
        String tels = contactos.get("tels").toString();
        String cels = contactos.get("cels").toString();
        String mails = contactos.get("mails").toString();
        
        String nuevos = contactos.get("nuevos").toString();
        String edits = contactos.get("edits").toString();
        String bajas = contactos.get("bajas").toString();
        
        StringTokenizer tksNom = new StringTokenizer(nombres,"|");
        StringTokenizer tksPat = new StringTokenizer(paternos,"|");
        StringTokenizer tksMat = new StringTokenizer(maternos,"|");
        StringTokenizer tksSex = new StringTokenizer(sexos,"|");
        StringTokenizer tksTit = new StringTokenizer(titulos,"|");
        StringTokenizer tksCar = new StringTokenizer(cargos,"|");
        StringTokenizer tksTel = new StringTokenizer(tels,"|");
        StringTokenizer tksCel = new StringTokenizer(cels,"|");
        StringTokenizer tksMail = new StringTokenizer(mails,"|");
        
        
        List<ContactoCliente> conactuales = datos.get("contactos")!=null?(List<ContactoCliente>)datos.get("contactos"): new ArrayList<ContactoCliente>();
        ContactoClienteDao ccdao = new ContactoClienteDao();
        PersonaDao perdao = new PersonaDao();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        MedioDao meddao = new MedioDao();

        int pos = 0;
        
        while(tksNom.hasMoreTokens()){
            String nom = tksNom.nextToken();
            String pat = tksPat.nextToken();
            String mat = "";
            if (tksMat.countTokens()>0)
                mat = tksMat.nextToken();
            String sex = tksSex.nextToken();
            String tit = tksTit.nextToken();
            String car = "";
            if (tksCar.countTokens()>0)
                car = tksCar.nextToken();
            String tel = "";
            if (tksTel.countTokens()>0)            
                tel = tksTel.nextToken();
            String cel = "";
            if (tksCel.countTokens()>0)            
                cel = tksCel.nextToken();
            String mail = "";
            if (tksMail.countTokens()>0)            
                mail = tksMail.nextToken();

            StringTokenizer tksAct = new StringTokenizer(actuales,"|");
            StringTokenizer tksNue = new StringTokenizer(nuevos,"|");
            StringTokenizer tksEdi = new StringTokenizer(edits,"|");
            
            
            boolean esnuevo = false, esedit = false, esbaja = false;
            while (tksNue.hasMoreElements()){
                int pnu = Integer.parseInt(tksNue.nextToken());
                if (pnu==pos){
                    esnuevo = true;
                    break;
                }
            }

            int idcon = 0, pp = 0;
            if (!esnuevo){
                //obtener el id de la posicion actual
                while (tksAct.hasMoreElements()){
                    idcon = Integer.parseInt(tksAct.nextToken());
                    if (pos==pp)
                        break;
                    else
                        pp++;
                }
                
                //checar si es editado
                while (tksEdi.hasMoreElements()){
                    int ided = Integer.parseInt(tksEdi.nextToken());
                    if (ided==idcon){
                        esedit = true;
                        break;
                    }
                }                
            }

            if (conactuales.isEmpty() || esnuevo){
                //todos son nuevos o el actual es nuevo
                ContactoCliente nuevocon = new ContactoCliente();
                nuevocon.setCliente(nuevo);
                Persona p = new Persona();
                p.setNombre(nom);
                p.setPaterno(pat);
                if (mat.equals("&"))
                    mat = "";
                p.setMaterno(mat);
                p.setSexo(sex);
                p.setTitulo(tit);
                if (car.equals("&"))
                    car = "";
                p.setCargo(car);
                perdao.guardar(p);
                nuevocon.setContacto(p);
                ccdao.guardar(nuevocon);
                
                //guardar los medios
                if (!tel.equals("&")){
                    PersonaMedio pm = new PersonaMedio();
                    Medio mtel = new Medio();
                    mtel.setTipo(new TipoMedio());
                    mtel.getTipo().setIdtipomedio(1);
                    mtel.setMedio(tel);
                    meddao.guardar(mtel);
                    pm.setMedio(mtel);
                    pm.setPersona(p);
                    pm.setEstatus(1);
                    pm.setObservaciones("");
                    pmdao.guardar(pm);
                }
                
                if (!cel.equals("&")){
                    PersonaMedio pm = new PersonaMedio();
                    Medio mcel = new Medio();
                    mcel.setTipo(new TipoMedio());
                    mcel.getTipo().setIdtipomedio(2);
                    mcel.setMedio(cel);
                    meddao.guardar(mcel);
                    pm.setMedio(mcel);
                    pm.setPersona(p);
                    pm.setEstatus(1);
                    pm.setObservaciones("");
                    pmdao.guardar(pm);
                }
                
                if (!cel.equals("&")){
                    PersonaMedio pm = new PersonaMedio();
                    Medio mmail = new Medio();
                    mmail.setTipo(new TipoMedio());
                    mmail.getTipo().setIdtipomedio(3);
                    mmail.setMedio(mail);
                    meddao.guardar(mmail);
                    pm.setMedio(mmail);
                    pm.setPersona(p);
                    pm.setEstatus(1);
                    pm.setObservaciones("");
                    pmdao.guardar(pm);
                }                
            } else if (esedit){
                ContactoCliente conexi = ccdao.obtener(idcon);
                //nuevocon.setContrato(con);
                Persona p = conexi.getContacto();
                p.setNombre(nom);
                p.setPaterno(pat);
                if (mat.equals("&"))
                    mat = "";
                p.setMaterno(mat);
                p.setSexo(sex);
                p.setTitulo(tit);
                if (car.equals("&"))
                    car = "";
                p.setCargo(car);
                perdao.actualizar(p);
                /*conexi.setContacto(p);
                ccdao.actualizar(conexi);*/
                
                /*/obtener los medios del contacto editado
                List<PersonaMedio> medact = pmdao.obtenerActivosDePersona(conexi.getContacto().getIdpersona());
                //guardar los medios
                if (!tel.equals("&")){
                    //checar si existe el tipo de medio
                    PersonaMedio pm = new PersonaMedio();
                    Medio mtel = new Medio();
                    mtel.setTipo(new TipoMedio());
                    mtel.getTipo().setIdtipomedio(1);
                    int ind = 0;
                    boolean esta = false;
                    for (int i=0; i < medact.size(); i++){
                        PersonaMedio pmact = medact.get(i);
                        if (pmact.getMedio().getTipo().getIdtipomedio()==1){
                            ind = i;
                            esta = true;
                            break;                            
                        }
                    }
                    if (esta){
                        pm = medact.get(ind);
                        mtel = pm.getMedio();
                    }    
                    mtel.setMedio(tel);
                    if (!esta){
                        meddao.guardar(mtel);
                        pm.setMedio(mtel);
                        pm.setPersona(p);
                        pm.setEstatus(1);
                        pm.setObservaciones("");
                        pmdao.guardar(pm);
                    } else {
                        meddao.actualizar(mtel);
                        //pmdao.actualizar(pm);
                    }
                } else {
                    //si el contacto tiene el medio registrado eliminarlo
                    int ind = 0;
                    boolean esta = false;
                    for (int i=0; i < medact.size(); i++){
                        PersonaMedio pmact = medact.get(i);
                        if (pmact.getMedio().getTipo().getIdtipomedio()==1){
                            ind = i;
                            esta = true;
                            break;                            
                        }
                    }
                    if (esta){
                        PersonaMedio pm = medact.get(ind);
                        pmdao.eliminar(pm);
                        meddao.eliminar(pm.getMedio());
                    }                    
                }

                if (!cel.equals("&")){
                    PersonaMedio pm = new PersonaMedio();
                    Medio mcel = new Medio();
                    mcel.setTipo(new TipoMedio());
                    mcel.getTipo().setIdtipomedio(2);
                    
                    int ind = 0;
                    boolean esta = false;
                    for (int i=0; i < medact.size(); i++){
                        PersonaMedio pmact = medact.get(i);
                        if (pmact.getMedio().getTipo().getIdtipomedio()==2){
                            ind = i;
                            esta = true;
                            break;                            
                        }
                    }
                    if (esta){
                        pm = medact.get(ind);
                        mcel = pm.getMedio();
                    }    
                    mcel.setMedio(cel);
                    if (!esta){
                        meddao.guardar(mcel);
                        pm.setMedio(mcel);
                        pm.setPersona(p);
                        pm.setEstatus(1);
                        pm.setObservaciones("");
                        pmdao.guardar(pm);
                    } else {
                        meddao.actualizar(mcel);
                        //pmdao.actualizar(pm);
                    }
                } else {
                    //si el contacto tiene el medio registrado eliminarlo
                    int ind = 0;
                    boolean esta = false;
                    for (int i=0; i < medact.size(); i++){
                        PersonaMedio pmact = medact.get(i);
                        if (pmact.getMedio().getTipo().getIdtipomedio()==2){
                            ind = i;
                            esta = true;
                            break;                            
                        }
                    }
                    if (esta){
                        PersonaMedio pm = medact.get(ind);
                        pmdao.eliminar(pm);
                        meddao.eliminar(pm.getMedio());
                    }                    
                }

                if (!mail.equals("&")){
                    PersonaMedio pm = new PersonaMedio();
                    Medio mmail = new Medio();
                    mmail.setTipo(new TipoMedio());
                    mmail.getTipo().setIdtipomedio(3);
                    int ind = 0;
                    boolean esta = false;
                    for (int i=0; i < medact.size(); i++){
                        PersonaMedio pmact = medact.get(i);
                        if (pmact.getMedio().getTipo().getIdtipomedio()==3){
                            ind = i;
                            esta = true;
                            break;                            
                        }
                    }
                    if (esta){
                        pm = medact.get(ind);
                        mmail = pm.getMedio();
                    }    
                    mmail.setMedio(mail);
                    if (!esta){
                        meddao.guardar(mmail);
                        pm.setMedio(mmail);
                        pm.setPersona(p);
                        pm.setEstatus(1);
                        pm.setObservaciones("");
                        pmdao.guardar(pm);
                    } else {
                        meddao.actualizar(mmail);
                        //pmdao.actualizar(pm);
                    }
                } else {
                    //si el contacto tiene el medio registrado eliminarlo
                    int ind = 0;
                    boolean esta = false;
                    for (int i=0; i < medact.size(); i++){
                        PersonaMedio pmact = medact.get(i);
                        if (pmact.getMedio().getTipo().getIdtipomedio()==3){
                            ind = i;
                            esta = true;
                            break;                            
                        }
                    }
                    if (esta){
                        PersonaMedio pm = medact.get(ind);
                        pmdao.eliminar(pm);
                        meddao.eliminar(pm.getMedio());
                    }                    
                }
            }
            pos++;
        }
        
        //eliminar las bajas
        StringTokenizer tksBaja = new StringTokenizer(bajas,"|");
        while (tksBaja.hasMoreElements()){
            int idbaja = Integer.parseInt(tksBaja.nextToken());
            ContactoCliente conexi = ccdao.obtener(idbaja);
            List<PersonaMedio> medact = pmdao.obtenerActivosDePersona(conexi.getContacto().getIdpersona());
            //borrar los medios
            for (int i=0; i < medact.size(); i++){
                PersonaMedio pm = medact.get(i);
                pmdao.eliminar(pm);
                meddao.eliminar(pm.getMedio());
            }
            ccdao.eliminar(conexi);
            perdao.eliminar(conexi.getContacto());
        }

        datos.remove("datoscontactos");*/
        datos.remove("contactos");
        datos.remove("medioscon");
        datos.remove("accion");
        
        datos = ObtenerClientes(datos);
        
        return datos;
    }

    private HashMap CargarClienteAEditar(HashMap datos) {
        ClienteDao cliDao = new ClienteDao();
        Cliente editar = (Cliente) datos.get("editarCliente");
        datos.put("editarCliente", cliDao.obtener(editar.getId()));
        return datos;
    }

    private HashMap ActualizaCliente(HashMap datos) {
        Cliente nuevo = (Cliente)datos.get("editarCliente");
        ClienteDao cliDao = new ClienteDao();
        cliDao.actualizar(nuevo);
        datos = ObtenerClientes(datos);
        datos.remove("editarCliente");
        return datos;
    }

    private HashMap BajaDeCliente(HashMap datos) {
        Cliente baja = (Cliente) datos.get("bajaCliente");
        ClienteDao cliDao = new ClienteDao();
        cliDao.actualizarEstatus(0, baja.getId());
        datos = ObtenerClientes(datos);
        datos.remove("bajaCliente");
        return datos;
    }

    private HashMap CargaSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        if (sucSel.getId() != 0){
            SucursalDao sucDao = new SucursalDao();
            datos.put("sucursalSel", sucDao.obtener(sucSel.getId()));
        }
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        ClienteDao cliDao = new ClienteDao();
        datos.put("inactivos", cliDao.obtenerInactivosDeSucursal(sucSel.getId()));
        return datos;
    }

    private HashMap ActivarCliente(HashMap datos) {
        Cliente activar = (Cliente)datos.get("activarCliente");
        ClienteDao cliDao = new ClienteDao();
        cliDao.actualizarEstatus(1, activar.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerClientes(datos);
        datos.remove("activarCliente");
        return datos;
    }

    private HashMap ObtenerRutas(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        RutaDao rutaDao = new RutaDao();
        datos.put("rutas", rutaDao.obtenerRutasDeSucursal(sucSel.getId()));
        return datos;
    }

    private HashMap FiltrarListado(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        HashMap filtros = (HashMap) datos.get("filtros");
        //crear la consulta
        String consulta = "from Cliente where estatus=1 and sucursal="+Integer.toString(sucSel.getId());
        String parametros = "";
        String fil1 = filtros.get("filtro1").toString();
        String fil2 = filtros.get("filtro2").toString();
        String fil3 = filtros.get("filtro3").toString();
        if (fil1.equals("on")){
            String param1 = filtros.get("razonSocial").toString();
            parametros += " and datosFiscales.razonsocial like '%"+param1+"%'";
        }
        if (fil2.equals("on")){
            String nom = filtros.get("nombreCli").toString();
            if (!nom.equals(""))
                parametros += " and datosFiscales.persona.nombre like '%"+nom+"%'";
            String pat = filtros.get("paternoCli").toString();
            if (!pat.equals(""))
                parametros += " and datosFiscales.persona.paterno like '%"+pat+"%'";
            String mat = filtros.get("maternoCli").toString();
            if (!mat.equals(""))
                parametros += " and datosFiscales.persona.materno like '%"+mat+"%'";
        }
        if (fil3.equals("on")){
            Ruta rut = (Ruta)filtros.get("rutaCli");
            parametros += " and ruta.id="+rut.getId();
        }
        
        consulta += parametros;
        
        ClienteDao cliDao = new ClienteDao();
        datos.put("listadoFil", cliDao.obtenerClientesDeSucursalFiltrado(consulta));
        datos.put("condiciones", parametros);
        return datos;
    }

    private HashMap ImprimirListado(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }

    private HashMap CargarContratos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        ClienteDao cliDao = new ClienteDao();
        datos.put("clienteSel", cliDao.obtener(cli.getId()));
        ContratoDao conDao = new ContratoDao();
        datos.put("listaContratos", conDao.obtenerContratosDeClienteYSucursal(cli.getId(), sucSel.getId()));
        return datos;
    }

    private HashMap ObtenerGrupo(HashMap datos) {
        List<Cliente> clientes = (List<Cliente>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Cliente> grupo = new ArrayList<Cliente>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin >= clientes.size()){
            fin = clientes.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(clientes.get(i));
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
        List<Cliente> listacom = (List<Cliente>)datos.get("listacompleta");
        int total = listacom.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }

    private HashMap IrAConsumoDeCliente(HashMap datos) {
        ClienteDao cliDao = new ClienteDao();
        Cliente cli = (Cliente)datos.get("cliente");
        cli = cliDao.obtener(cli.getId());
        datos.put("cliente", cli);
        //obtener los contratos del cliente
        ContratoDao conDao = new ContratoDao();
        datos.put("contratos", conDao.obtenerContratosDeCliente(cli.getId()));
        return datos;
    }

    private HashMap ObtenerCentros(HashMap datos) {
        Cliente cli = (Cliente)datos.get("cliente");
        Contrato con = (Contrato)datos.get("contrato");
        CentroTrabDao ctDao = new CentroTrabDao();
        if (con.getId()!=-1)
            datos.put("centros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        else
            datos.put("centros", ctDao.obtenerCTSDeCliente(cli.getId()));
        return datos;
    }

    private HashMap ObtenerMovimientosDeCT(HashMap datos) {
        Cliente cli = (Cliente)datos.get("cliente");
        Contrato con = (Contrato)datos.get("contrato");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("ct");
        MovimientoDao movDao = new MovimientoDao();
        if (ct.getId()!=-1)
            datos.put("salidas", movDao.obtenerMovsSalidasDeCT(ct.getId()));
        else if (con.getId()!=-1)
            datos.put("salidas", movDao.obtenerMovsSalidasDeContrato(con.getId()));
        else
            datos.put("salidas", movDao.obtenerMovsSalidasDeCliente(cli.getId()));
        
        List<Cabecera> sal = (List<Cabecera>)datos.get("salidas");
        List<String> tots = new ArrayList<String>();
        float totcon = 0;
        for (int i=0; i < sal.size(); i++){
            Cabecera cab = sal.get(i);
            float tot = movDao.obtenerTotalDeMovimiento(cab.getId());
            tots.add(Float.toString(tot));
            totcon += tot;
        }
        datos.put("totalesfull", tots);
        datos.put("totalcon", Float.toString(totcon));
        
        //datos = CalcularResumenPorMes(datos);
        datos.put("salidasfull", sal);

        if (sal.size()>grupos){
            datos.put("gruposcon", "1");
            datos.put("inicialcon", "1");
            datos = ObtenerGrupoConsumo(datos);
        } else {
            datos.put("gruposcon", "0");
            datos.put("salidas", sal);
            datos.put("totales", tots);
        }
        
        
        //datos.put("totalsal", tots);
        /*
        if (ct.getId()!=-1)
            datos.put("entradas", movDao.obtenerMovsEntradasDeCT(ct.getId()));
        else if (con.getId()!=-1)
            datos.put("entradas", movDao.obtenerMovsEntradasDeContrato(con.getId()));
        else
            datos.put("entradas", movDao.obtenerMovsEntradasDeCliente(cli.getId()));
        
        List<Cabecera> ent = (List<Cabecera>)datos.get("entradas");
        //List<String> tots = new ArrayList<String>();
        float tote = 0;
        for (int i=0; i < ent.size(); i++){
            Cabecera cab = ent.get(i);
            float tot = movDao.obtenerTotalDeMovimiento(cab.getId());
            tote += tot;
        }
        datos.put("totalent", tote);
        */
        return datos;
    }

    private HashMap ObtenerGrupoConsumo(HashMap datos) {
        List<Cabecera> salidas = (List<Cabecera>)datos.get("salidasfull");
        List<String> totales = (List<String>)datos.get("totalesfull");
        datos.put("anteriorescon", "0");
        int inicial = Integer.parseInt(datos.get("inicialcon").toString());
        if (inicial>1)
            datos.put("anteriorescon", "1");
        List<Cabecera> grupo = new ArrayList<Cabecera>();
        List<String> gpotot = new ArrayList<String>();
        int fin = grupos +(inicial-1);
        //int fintot = grupos + (inicial-1);
        datos.put("siguientescon", "1");
        if (fin >= salidas.size()){
            fin = salidas.size();
            //fintot = salidas.size();
            datos.put("siguientescon", "0");
        }
        datos.put("finalcon", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(salidas.get(i));
            gpotot.add(totales.get(i));
        }
        datos.put("salidas", grupo);
        datos.put("totales", gpotot);
        return datos;
    }

    private HashMap CargarSiguientesCon(HashMap datos) {
        int fin = Integer.parseInt(datos.get("finalcon").toString());
        datos.put("inicialcon", Integer.toString(fin+1));
        datos = ObtenerGrupoConsumo(datos);
        datos.put("paso", "-2");
        return datos;
    }

    private HashMap CargarAnterioresCon(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicialcon").toString())-grupos;
        datos.put("inicialcon", Integer.toString(ini));
        datos = ObtenerGrupoConsumo(datos);
        datos.put("paso", "-2");
        return datos;
    }

    private HashMap CargarPrincipioCon(HashMap datos) {
        datos.put("inicialcon", "1");
        datos = ObtenerGrupoConsumo(datos);
        datos.put("paso", "-2");
        return datos;
    }

    private HashMap CargarFinalCon(HashMap datos) {
        List<Cabecera> listacom = (List<Cabecera>)datos.get("salidasfull");
        int total = listacom.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicialcon", Integer.toString(ini));
        datos = ObtenerGrupoConsumo(datos);
        datos.put("paso", "-2");
        return datos;
    }

    private HashMap CalcularResumenPorMes(HashMap datos) {
        //cargar contrato y ct seleccionados
        ContratoDao conDao = new ContratoDao();
        Contrato con = (Contrato)datos.get("contrato");
        if (con.getId()!=-1){
            con = conDao.obtener(con.getId());
            datos.put("contrato", con);
        }
        CentroTrabDao ctDao = new CentroTrabDao();
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("ct");
        if (ct.getId()!=-1){
            ct = ctDao.obtener(ct.getId());
            datos.put("ct", ct);
        }
        
        List<Cabecera> salidas = (List<Cabecera>)datos.get("salidasfull");
        //obtener los años
        List<String> anios = new ArrayList<String>();
        for (int i=0; i < salidas.size(); i++){
            Cabecera sal = salidas.get(i);
            Calendar fecha = Calendar.getInstance();
            fecha.setTime(sal.getFechaCaptura());
            String anio = Integer.toString(fecha.get(Calendar.YEAR));
            if (anios.isEmpty()){
                anios.add(anio);
            } else {
                boolean esta = false;
                for (int a=0; a < anios.size(); a++){
                    String aax = anios.get(a);
                    if (aax.equals(anio)){
                        esta = true;
                        break;
                    }
                }
                if (!esta)
                    anios.add(anio);
            }
        }
        Collections.sort(anios);
        datos.put("anios", anios);
        //obtener los meses de cada año
        List<HashMap> mesesanio = new ArrayList<HashMap>();
        for (int i=0; i < anios.size(); i++){
            String anio = anios.get(i);
            List<String> meses = new ArrayList<String>();
            for (int s=0; s < salidas.size(); s++){
                Cabecera sal = salidas.get(s);
                Calendar fecha = Calendar.getInstance();
                fecha.setTime(sal.getFechaCaptura());
                String anioact = Integer.toString(fecha.get(Calendar.YEAR));
                if (anioact.equals(anio)){
                    String mes = Integer.toString(fecha.get(Calendar.MONTH));
                    if (meses.isEmpty())
                        meses.add(mes);                        
                    else {
                        boolean esta = false;
                        for (int m=0; m < meses.size(); m++){
                            String mx = meses.get(m);
                            if (mx.equals(mes)){
                                esta = true;
                                break;
                            }
                        }
                        if (!esta)
                            meses.add(mes);
                    }
                }
            }
            HashMap ma = new HashMap();
            ma.put("anio", anio);
            ma.put("meses", meses);
            //obtener el total de cada mes
            List<String> tots = (List<String>)datos.get("totalesfull");
            List<String> totalesmes = new ArrayList<String>();
            for (int m=0; m < meses.size(); m++){
                String mes = meses.get(m);
                float totmes = 0;
                for (int s=0; s < salidas.size(); s++){
                    Cabecera sal = salidas.get(s);
                    String totsal = tots.get(s);
                    Calendar fecha = Calendar.getInstance();
                    fecha.setTime(sal.getFechaCaptura());
                    String aact = Integer.toString(fecha.get(Calendar.YEAR));
                    String mact = Integer.toString(fecha.get(Calendar.MONTH));
                    if (aact.equals(anio) && mact.equals(mes)){
                        totmes+=Float.parseFloat(totsal);
                    }
                }
                totalesmes.add(Float.toString(totmes));
            }
            ma.put("totalesmes", totalesmes);
            mesesanio.add(ma);
        }
        //datos.put("mesesfull", mesesanio);
        List<HashMap> listado = new ArrayList<HashMap>();
        for (int i=0; i < mesesanio.size(); i++){
            HashMap ma = mesesanio.get(i);
            String anio = ma.get("anio").toString();
            List<String> meses = (List<String>)ma.get("meses");
            List<String> totm = (List<String>)ma.get("totalesmes");
            for (int m=0; m < meses.size(); m++){
                String mes = meses.get(m);
                String tot = totm.get(m);
                HashMap item = new HashMap();
                item.put("anio", anio);
                item.put("mes", mes);
                item.put("total", tot);
                listado.add(item);
            }
        }
        
        datos.put("resumenfull", listado);
        if (listado.size()>grupos){
            datos.put("gruposres", "1");
            datos.put("inicialres", "1");
            datos = ObtenerGrupoResumen(datos);
        } else {
            datos.put("gruposres", "0");
            datos.put("resumen", listado);
        }
        
        return datos;
    }
    
    private HashMap ObtenerGrupoResumen(HashMap datos) {
        List<HashMap> meses = (List<HashMap>)datos.get("resumenfull");
        //List<String> totales = (List<String>)datos.get("totalesfull");
        datos.put("anterioresres", "0");
        int inicial = Integer.parseInt(datos.get("inicialres").toString());
        if (inicial>1)
            datos.put("anterioresres", "1");
        List<HashMap> grupo = new ArrayList<HashMap>();
        int fin = grupos +(inicial-1);
        //int fintot = grupos + (inicial-1);
        datos.put("siguientesres", "1");
        if (fin >= meses.size()){
            fin = meses.size();
            //fintot = salidas.size();
            datos.put("siguientesres", "0");
        }
        datos.put("finalres", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(meses.get(i));
            //gpotot.add(totales.get(i));
        }
        datos.put("resumen", grupo);
        //datos.put("totales", gpotot);
        return datos;
    }
    
    private HashMap CargarSiguientesRes(HashMap datos) {
        int fin = Integer.parseInt(datos.get("finalres").toString());
        datos.put("inicialres", Integer.toString(fin+1));
        datos = ObtenerGrupoResumen(datos);
        return datos;
    }

    private HashMap CargarAnterioresRes(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicialres").toString())-grupos;
        datos.put("inicialres", Integer.toString(ini));
        datos = ObtenerGrupoResumen(datos);
        return datos;
    }

    private HashMap CargarPrincipioRes(HashMap datos) {
        datos.put("inicialres", "1");
        datos = ObtenerGrupoResumen(datos);
        return datos;
    }

    private HashMap CargarFinalRes(HashMap datos) {
        List<HashMap> listacom = (List<HashMap>)datos.get("resumenfull");
        int total = listacom.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicialres", Integer.toString(ini));
        datos = ObtenerGrupoResumen(datos);
        return datos;
    }

    private HashMap ObtenerResumenDelAño(HashMap datos) {
        List<HashMap> listacom = (List<HashMap>)datos.get("resumenfull");
        String aniosel = datos.get("aniores").toString();
        if (aniosel.equals("0")){
            if (listacom.size()>grupos){
                datos.put("gruposres", "1");
                datos.put("inicialres", "1");
                datos = ObtenerGrupoResumen(datos);
            } else {
                datos.put("gruposres", "0");
                datos.put("resumen", listacom);
            }
            return datos;
        }
        
        List<HashMap> lsAnio = new ArrayList<HashMap>();
        for (int i=0; i < listacom.size(); i++){
            HashMap it = listacom.get(i);
            if (it.get("anio").toString().equals(aniosel)){
                lsAnio.add(it);
            }
        }
        
        datos.put("gruposres", "0");
        datos.put("resumen", lsAnio);
        
        return datos;
    }
    
    private HashMap ObtenerCatalogos(HashMap datos) {
        TituloDao titdao = new TituloDao();
        datos.put("titulos", titdao.obtenerListaActivos());
        TipoMedioDao tmdao = new TipoMedioDao();
        datos.put("tiposmedios", tmdao.obtenerListaActivos());
        return datos;
    }

    private HashMap ObtenerContactos(HashMap datos) {
        Cliente cli = (Cliente)datos.get("editarCliente");
        ContactoClienteDao ccdao = new ContactoClienteDao();
        List<ContactoCliente> contactos = ccdao.obtenerContactosDeCliente(cli.getId());
        List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
        datos.put("contactos", contactos);
        if (contactos.size()>0)
            medioscon = ccdao.obtenerMediosDeContactosDeCliente(cli.getId());
        datos.put("medioscon", medioscon);
        return datos;
    }

    private HashMap GuardaContacto(HashMap datos) {
        ContactoCliente contac = (ContactoCliente)datos.get("contacto");
        Cliente cli = (Cliente)datos.get("editarCliente");
        String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
        ContactoClienteDao ccdao = new ContactoClienteDao();
        PersonaDao perdao = new PersonaDao();
        TipoMedioDao tmdao = new TipoMedioDao();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        MedioDao meddao = new MedioDao();
        if (accion.equals("nuevo")){
            contac.setCliente(cli);
            Persona per = contac.getContacto();
            perdao.guardar(per);
            ccdao.guardar(contac);
            //guardar los medios del contacto
            String[] tipos = (String[])datos.get("tipos");
            String[] medios = (String[])datos.get("medios");
            String[] extens = (String[])datos.get("extensiones");
            for (int i=0; i < tipos.length; i++){
                int idtipo = Integer.parseInt(tipos[i]);
                TipoMedio tm = tmdao.obtener(idtipo);
                String medio = "", ext = "";
                try {
                    medio = new String(medios[i].getBytes("ISO-8859-1"), "UTF-8");
                    ext = new String(extens[i].getBytes("ISO-8859-1"), "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(ContratoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
                Medio med = new Medio();
                med.setTipo(tm);
                med.setMedio(medio);
                med.setExtension(ext);
                meddao.guardar(med);
                PersonaMedio pm = new PersonaMedio();
                pm.setMedio(med);
                pm.setEstatus(1);
                pm.setPersona(contac.getContacto());
                pmdao.guardar(pm);
            }
        } else {
            Persona per = contac.getContacto();
            perdao.actualizar(per);
            ccdao.actualizar(contac);
            //eliminar los medios actuales
            List<PersonaMedio> mediosactuales = (List<PersonaMedio>)datos.get("medioscontacto");
            for (int i=0;i<mediosactuales.size(); i++){
                PersonaMedio pm = mediosactuales.get(i);
                Medio med = pm.getMedio();
                pmdao.eliminar(pm);
                meddao.eliminar(med);                
            }
            //guardar los medios del contacto
            String[] tipos = (String[])datos.get("tipos");
            String[] medios = (String[])datos.get("medios");
            String[] extens = (String[])datos.get("extensiones");
            for (int i=0; i < tipos.length; i++){
                int idtipo = Integer.parseInt(tipos[i]);
                TipoMedio tm = tmdao.obtener(idtipo);
                String medio = "", ext = "";
                try {
                    medio = new String(medios[i].getBytes("ISO-8859-1"), "UTF-8");
                    ext = new String(extens[i].getBytes("ISO-8859-1"), "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(ContratoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
                Medio med = new Medio();
                med.setTipo(tm);
                med.setMedio(medio);
                med.setExtension(ext);
                meddao.guardar(med);
                PersonaMedio pm = new PersonaMedio();
                pm.setMedio(med);
                pm.setEstatus(1);
                pm.setPersona(contac.getContacto());
                pmdao.guardar(pm);
            }            
        }
        datos = ObtenerContactos(datos);
        datos.put("pestaña","3");
        datos.remove("contacto");
        datos.remove("medioscontacto");
        datos.remove("accionContacto");
        return datos;
    }

    private HashMap EditarContacto(HashMap datos) {
        ContactoCliente cc = (ContactoCliente)datos.get("contacto");
        ContactoClienteDao ccdao = new ContactoClienteDao();
        cc = ccdao.obtener(cc.getId());
        datos.put("contacto", cc);
        PersonaMedioDao pmdao = new PersonaMedioDao();
        datos.put("medioscontacto", pmdao.obtenerActivosDePersona(cc.getContacto().getIdpersona()));
        return datos;
    }

    private HashMap BorrarContacto(HashMap datos) {
        ContactoCliente cc = (ContactoCliente)datos.get("contacto");
        ContactoClienteDao ccdao = new ContactoClienteDao();
        cc = ccdao.obtener(cc.getId());
        Persona per = cc.getContacto();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        PersonaDao perdao = new PersonaDao();
        List<PersonaMedio> medios = pmdao.obtenerActivosDePersona(cc.getContacto().getIdpersona());
        
        //eliminar contacto
        ccdao.eliminar(cc);
        //eliminar medios
        MedioDao meddao = new MedioDao();
        for (int i=0; i < medios.size(); i++){
            PersonaMedio pm = medios.get(i);
            Medio med = pm.getMedio();
            pmdao.eliminar(pm);
            meddao.eliminar(med);                
        }
        //eliminar persona
        perdao.eliminar(per);
        
        datos = ObtenerContactos(datos);
        datos.put("pestaña","3");
        datos.remove("contacto");
        datos.remove("accionContacto");
        
        return datos;
    }
    
}
