/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.*;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.*;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author TEMOC
 */
public class ContratoMod {
    public ContratoMod(){
        
    }

    public Sesion GestionarContratos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                int idop = Integer.parseInt(datos.get("idoperacion").toString());
                if (idop==13)
                    datos.put("sucursales", ObtenerSucursales());
                datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                datos = ObtenerLogotipo(datos);
                break;
            case -1:
                datos = ObtenerClientesDeSucursal(datos);
                break;
            case 1:
                //ir a nuevo contrato
                datos.put("accion", "nuevo");
                datos.put("hoy", new Date());
                datos = ObtenerCatalogos(datos);
                break;
            case 2: case 4:
                //guardar el contrato nuevo(2) || guarda el contrato editado (4)
                datos = GuardarContrato(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp");
                    datos.remove("error");
                } else {
                    sesion.setExito(true);
                    sesion.setMensaje("El Contrato fue guardado con éxito");
                }
                break;
            case 3:
                //ir a editar contrato
                datos = CargaContratoSel(datos);
                datos.put("accion", "editar");                
                datos.put("hoy", new Date());
                datos = ObtenerContactos(datos);
                datos = ObtenerCatalogos(datos);
                break;
            case 5:
                //baja de contrato
                datos = BajaDeContrato(datos);
                break;
            case 6:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                //activar contrato
                datos = ActivaContrato(datos);
                break;
            case 8:
                //ir a centros de trabajo
                datos = CargarCentros(datos);
                break;
            case 9:
                //ir productos del contrato
                datos = ObtenerProductosDelContrato(datos);
                break;
            case 10:
                datos = CargaContratoSel(datos);
                //generar salidas programadas
                //datos = GenerarSalidasProgramadas(datos);
                datos = ValidaCentros(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp");
                    datos.remove("error");
                } /*else {
                    sesion.setExito(true);
                    sesion.setMensaje("Las Salidas Programadas fueron generadas con éxito");
                }*/
                break;
            case 11:
                //datos = ObtenerCatalogos(datos);
                /*datos = CargaContratoSel(datos);
                //generar salidas programadas
                datos = ValidaCentros(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp");
                    datos.remove("error");
                }*/
                break;
            case 12:
                //generar las salidas programadas de cambios
                //datos = GenerarSalidasProgsCambios(datos);
                datos = GenerarSalidasProgramadas(datos);
                sesion.setExito(true);
                sesion.setMensaje("Las Salidas Programadas fueron generadas con éxito");
                break;
            case 13:
                //ir a importar datos
                datos = CargaContratoSel(datos);
                datos = ObtenerTodosLosContratos(datos);
                break;
            case 14:
                //importar datos seleccionados
                datos = ImportarDatos(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarClientes/Contratos/importardatos.jsp");
                    datos.remove("error");
                } else {
                    datos.remove("contratoimp");
                    datos.remove("datosimp");
                    datos.remove("editarContrato");
                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron importados con éxito");
                }
                break;
            case 15:
                datos = MostrarConcluidos(datos);
                break;
            case 16:
                datos = MostrarVigentes(datos);
                break;
            case 17:
                datos = ObtenerCatalogos(datos);
                datos = ObtenerContactos(datos);
                break;
            case 18:
                //borrar documento de contrato
                datos = BorrarDocumentoDeContrato(datos);
                break;
            case 19:
                //borrar documento de contrato
                datos = BorrarDocumentoDeFianza(datos);
                break;
            case 21:
                datos = GuardaContacto(datos);
                break;
            case 22:
                datos = EditarContacto(datos);
                break;
            case 23:
                datos = BorrarContacto(datos);
                break;
            case 24:
                datos = ImprimirReporte(datos);
                break;
            case 25:
                datos = ConsultarContratos(datos);
                break;
            case 92:
                //salir de reporte de fianzas vencidas
                datos.remove("fechaini");
                datos.remove("fechafin");
                datos.remove("sucursalSel");
                datos.remove("sucursales");
                break;
            case 93:
                //salir de reporte de fianzas vencidas
                datos.remove("fechaini");
                datos.remove("fechafin");
                break;
            case 94:
                //cancelar nuevo contacto
                datos.remove("contacto");
                datos.remove("accionContacto");
                datos.put("pestaña","3");
                break;
            case 95:
                datos.remove("editarContrato");
                datos.remove("todosloscontratos");
                break;
            case 96:
                datos.remove("editarContrato");
                //datos.remove("listaCentros");
                break;
            case 97:
                //cancelar inactivos
                datos.remove("inactivos");
                break;
            case 98:
                int banhis = Integer.parseInt(datos.get("banhis")!=null?datos.get("banhis").toString():"0");
                if (banhis==0)
                    datos = ObtenerListado(datos);
                else
                    datos = MostrarConcluidos(datos);
                datos.remove("accion");
                break;
            case 99:
                datos.remove("listaContratos");
                datos.remove("banhis");
                datos.remove("clienteSel");
                datos.remove("accion");
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

    private HashMap ObtenerListado(HashMap datos){
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        ContratoDao conDao = new ContratoDao();
        datos.put("listaContratos", conDao.obtenerContratosDeClienteYSucursal(cli.getId(), sucSel.getId()));
        return datos;
    }
    
    private HashMap GuardarContrato(HashMap datos) {
        Contrato con = (Contrato)datos.get("contrato");
        Cliente cli = (Cliente)datos.get("clienteSel");
        con.setCliente(cli);
        ContratoDao conDao = new ContratoDao();
        if (datos.get("accion").toString().equals("nuevo") && conDao.ValidaContrato(con)){
            datos.put("error", "El Número de Contrato ya existe");
            return datos;
        } else if (datos.get("accion").toString().equals("editar")){
            String conact = datos.get("conact").toString();
            if (!conact.equals(con.getContrato()) && conDao.ValidaContrato(con)){
                datos.put("error", "El Número de Contrato ya existe");
                return datos;
            }
        }
        
        if (datos.get("accion").toString().equals("nuevo")){
            con.setEstatus(1);
            conDao.guardar(con);
        } else {
            conDao.actualizar(con);
        }
        
        FechasEntregaDao fedao = new FechasEntregaDao();
        //si la configuracion de fechas es por fechas especificas
        if (con.getTipoentrega()==1){
            if (datos.get("accion").toString().equals("editar")){
                fedao.eliminarFechasDeEntidad(1, con.getId());
            }
            String fechas = datos.get("fechasent").toString();
            StringTokenizer tokens=new StringTokenizer(fechas, ",");
            while(tokens.hasMoreTokens()){
                //System.out.println(tokens.nextToken());
                FechasEntrega fent = new FechasEntrega();
                fent.setEntidad(1);
                fent.setIdentidad(con.getId());
                SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
                //String strFecha = “2007-12-25″;
                Date fecha = null;
                try {
                    fecha = formatoDelTexto.parse(tokens.nextToken());
                } catch (ParseException ex) {
                    ex.printStackTrace();
                }
                fent.setFecha(fecha);
                fedao.guardar(fent);
            }
        } else if (con.getTipoentrega()==0){
            //checar si el contrato tiene fechas de entrega registradas, las elimina
            fedao.eliminarFechasDeEntidad(1, con.getId());
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
        
        
        List<ContactoContrato> conactuales = datos.get("contactos")!=null?(List<ContactoContrato>)datos.get("contactos"): new ArrayList<ContactoContrato>();
        ContactoContratoDao ccdao = new ContactoContratoDao();
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
                ContactoContrato nuevocon = new ContactoContrato();
                nuevocon.setContrato(con);
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
                ContactoContrato conexi = ccdao.obtener(idcon);
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
                ccdao.actualizar(conexi);*
                
                //obtener los medios del contacto editado
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
            ContactoContrato conexi = ccdao.obtener(idbaja);
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
        */
        
        datos.remove("contrato");
        //datos.remove("datoscontactos");
        datos.remove("contactos");
        datos.remove("medioscon");
        datos.remove("accion");
        datos.remove("fechasent");

        datos = ObtenerListado(datos);
        
        return datos;
    }

    private HashMap CargaContratoSel(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        ContratoDao conDao = new ContratoDao();
        con = conDao.obtener(con.getId());
        datos.put("editarContrato", con);
        if (con.getTipoentrega()==1){
            //obtener las fechas del contrato
            FechasEntregaDao fedao = new FechasEntregaDao();
            datos.put("fechasent", fedao.obtenerFechasDeEntidad(1, con.getId()));
        }
        return datos;
    }

    private HashMap BajaDeContrato(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        ContratoDao conDao = new ContratoDao();
        conDao.actualizarEstatus(0, con.getId());
        int banhis = datos.get("banhis")!=null?Integer.parseInt(datos.get("banhis").toString()):0;
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        if (banhis==1)
            datos.put("listaContratos", conDao.obtenerContratosDeClienteYSucursalConcluidos(cli.getId(), sucSel.getId()));
        else
            datos = ObtenerListado(datos);
        datos.remove("editarContrato");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        ContratoDao conDao = new ContratoDao();
        datos.put("inactivos", conDao.obtenerContratosInactivosDeClienteYSucursal(cli.getId(), sucSel.getId()));
        return datos;
    }

    private HashMap ActivaContrato(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        ContratoDao conDao = new ContratoDao();
        conDao.actualizarEstatus(1, con.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerListado(datos);
        datos.remove("editarContrato");
        return datos;
    }

    private HashMap CargarCentros(HashMap datos) {
        datos = CargaContratoSel(datos);
        Contrato con = (Contrato)datos.get("editarContrato");
        if (con.getTipoentrega()==1){
            FechasEntregaDao fedao = new FechasEntregaDao();
            datos.put("fechasent", fedao.obtenerFechasDeEntidad(1, con.getId()));
        }
            
        CentroTrabDao ctDao = new CentroTrabDao();
        datos.put("listaCentros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        return datos;
    }

    private HashMap ObtenerProductosDelContrato(HashMap datos) {
        datos.put("categoria", "0");
        datos = CargaContratoSel(datos);
        Contrato con = (Contrato)datos.get("editarContrato");
        ProductosCtDao pctDao = new ProductosCtDao();
        List<ProductosCt> pcts = pctDao.obtenerListaActivosDeContrato(con.getId());
        //Actualizar precios de productos del contrato
        CostoProductoDao cpdao = new CostoProductoDao();
        PrecioProductoDao ppdao = new PrecioProductoDao();
        UnidadProductoDao updao = new UnidadProductoDao();
        //boolean actualizacion = false;
        for (int i=0; i < pcts.size(); i++){
            ProductosCt pct = pcts.get(i);
            //calcular el precio del producto con el costo y factor actuales
            CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(pct.getProducto().getId(), con.getSucursal().getId());
            PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(pct.getListaprecios(), pct.getProducto().getId(), con.getSucursal().getId());
            UnidadProducto up = updao.obtener(pct.getUnidad().getId(), pct.getProducto().getId());
            if (up==null)
                up = updao.obtenerUnidadInactivaDeProducto(pct.getUnidad().getId(), pct.getProducto().getId());
            float prenvo = cp.getCosto()*pp.getFactor()*up.getValor();
            if (prenvo!=pct.getPrecio()){
                //actualizacion = true;
                pct.setPrecio(prenvo);
                pctDao.actualizar(pct);
                pcts.set(i, pct);
            }
        }
        /*if (actualizacion)
            pcts = pctDao.obtenerListaActivosDeContrato(con.getId());*/
        datos.put("productosct", pcts);
        return datos;
    }

    private HashMap GenerarSalidasProgramadas(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        Contrato con = (Contrato)datos.get("editarContrato");
        //obtener centros
        //CentroTrabDao ctDao = new CentroTrabDao();
        List<CentroDeTrabajo> centros = new ArrayList<CentroDeTrabajo>();
        List<CentroDeTrabajo> listacts = (List<CentroDeTrabajo>)datos.get("listaCentros");
        String ctssel = datos.get("ctssel").toString();
        StringTokenizer toks = new StringTokenizer(ctssel,",");
        while(toks.hasMoreTokens()){
            int idct = Integer.parseInt(toks.nextToken());
            for (int i=0; i < listacts.size(); i++){
                CentroDeTrabajo ct = listacts.get(i);
                if (ct.getId()==idct){
                    centros.add(ct);
                    break;
                }
            }
        }
        
        SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaIni = null;
        try {
            fechaIni = form.parse(datos.get("fechasp").toString());
        } catch (ParseException ex) {
        }        

        //eliminar las salidas programadas existentes del contrato
        MovimientoDao movDao = new MovimientoDao();
        //movDao.eliminaSalidasProgsDeContrato(cli.getId(),con.getId());//cambiar por eliminarSPsDeCTs(cli,con,cts);
        movDao.eliminaSPsDeCTs(cli.getId(), con.getId(), ctssel);
        
        //obtener el tipo de movimiento
        TipoMovDao tmovDao = new TipoMovDao();
        TipoMov tmov = tmovDao.obtener(20);
        //obtener la  lista de precios del cliente
        int lpcli = cli.getListaPrecios();//los precios ahora se jalarán de los prods registrados
        
        //Date fechaIni = con.getFechaIni();
        Date fechaFin = con.getFechaFin();
        Date fechasp = new Date();
        for (int i=0; i < centros.size(); i++){
            CentroDeTrabajo ct = centros.get(i);
            if (ct.getConfigentrega()==2 || (ct.getConfigentrega()==0 && ct.getContrato().getTipoentrega()==0)
                    || (ct.getConfigentrega()==1 && ct.getTipoentrega()==0)){ //si es por dias
                int dias = ct.getDiasEntrega();
                if (ct.getConfigentrega()==0 && ct.getContrato().getTipoentrega()==0)
                    dias = ct.getContrato().getDiasentrega();
                fechasp = fechaIni;
                int mul = 0;
                while (fechasp.before(fechaFin)){
                    Almacen almalt = new Almacen();
                    Ubicacion ubialt = new Ubicacion();
                    Cabecera cab = new Cabecera();
                    cab.setCliente(con.getCliente());
                    cab.setContrato(con);
                    cab.setCentrotrabajo(ct);
                    cab.setFechaCaptura(fechasp);
                    cab.setSucursal(sucSel);
                    if (ct.getSurtidoexterno()==1){
                        cab.setSucursal(ct.getSucalterna());
                        //Obtener almacen y ubicacion de la sucursal alterna
                        AlmacenDao almdao = new AlmacenDao();
                        List<Almacen> almsalt = almdao.obtenerListaActivosDeSucursal(ct.getSucalterna().getId());
                        almalt = almsalt.get(0);
                        UbicacionDao ubidao = new UbicacionDao();
                        List<Ubicacion> ubisalt = ubidao.obtenerListaActivasDeAlmacen(almalt.getId());
                        ubialt = ubisalt.get(0);
                    }
                    cab.setTipomov(tmov);
                    cab.setSerie(tmov.getSerie());
                    cab.setFolio(tmov.getSerie().getFolio().intValue());
                    cab.setEstatus(1);
                    movDao.guardarCabecera(cab);
                    //actualizar folio de la serie
                    Serie ser = cab.getSerie();
                    ser.setFolio(ser.getFolio()+1);
                    SerieDao serDao = new SerieDao();
                    serDao.actualizar(ser);

                    //generar detalle
                    int res = movDao.generaDetalleDeSalidaProgramada(cab.getId(), ct.getId(), con.getId(), cli.getId(), sucSel.getId(), mul);
                    mul++;
                    
                    if (fechasp.before(fechaFin)){
                        //siguiente fecha
                        Calendar cal = Calendar.getInstance(); 
                        cal.setTime(fechasp);
                        if (dias==30)
                            cal.add(Calendar.MONTH, 1);
                        else
                            cal.add(Calendar.DATE, dias);
                        
                        if (cal.get(Calendar.DAY_OF_WEEK)==Calendar.SATURDAY){
                            cal.add(Calendar.DAY_OF_MONTH, 2);
                        }
                        if (cal.get(Calendar.DAY_OF_WEEK)==Calendar.SUNDAY){
                            cal.add(Calendar.DAY_OF_MONTH, 1);
                        }
                        fechasp = cal.getTime();
                    }
                }//while fechas
            } else if ((ct.getConfigentrega()==0 && ct.getContrato().getTipoentrega()==1) ||
                    (ct.getConfigentrega()==1 && ct.getTipoentrega()==1)){//si es por fechas
                //obtener las fechas
                List<FechasEntrega> fechasent = new ArrayList<FechasEntrega>();
                FechasEntregaDao fedao = new FechasEntregaDao();
                if (ct.getConfigentrega()==0 && ct.getContrato().getTipoentrega()==1)
                    fechasent = fedao.obtenerFechasDeEntidad(1, ct.getContrato().getId());
                else
                    fechasent = fedao.obtenerFechasDeEntidad(2, ct.getId());
                
                for (int f=0; f < fechasent.size(); f++){
                    FechasEntrega fec = fechasent.get(f);

                    Almacen almalt = new Almacen();
                    Ubicacion ubialt = new Ubicacion();
                    Cabecera cab = new Cabecera();
                    cab.setCliente(con.getCliente());
                    cab.setContrato(con);
                    cab.setCentrotrabajo(ct);
                    cab.setFechaCaptura(fec.getFecha());
                    cab.setSucursal(sucSel);
                    if (ct.getSurtidoexterno()==1){
                        cab.setSucursal(ct.getSucalterna());
                        //Obtener almacen y ubicacion de la sucursal alterna
                        AlmacenDao almdao = new AlmacenDao();
                        List<Almacen> almsalt = almdao.obtenerListaActivosDeSucursal(ct.getSucalterna().getId());
                        almalt = almsalt.get(0);
                        UbicacionDao ubidao = new UbicacionDao();
                        List<Ubicacion> ubisalt = ubidao.obtenerListaActivasDeAlmacen(almalt.getId());
                        ubialt = ubisalt.get(0);
                    }
                    cab.setTipomov(tmov);
                    cab.setSerie(tmov.getSerie());
                    cab.setFolio(tmov.getSerie().getFolio().intValue());
                    cab.setEstatus(1);
                    movDao.guardarCabecera(cab);
                    //actualizar folio de la serie
                    Serie ser = cab.getSerie();
                    ser.setFolio(ser.getFolio()+1);
                    SerieDao serDao = new SerieDao();
                    serDao.actualizar(ser);

                    //generar detalle
                    int res = movDao.generaDetalleDeSalidaProgramada(cab.getId(), ct.getId(), con.getId(), cli.getId(), sucSel.getId(), f);
                }
            }
        }
        datos.remove("listaCentros");
        datos.remove("fechasp");
        return datos;
    }

    private HashMap ValidaCentros(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        //obtener centros
        CentroTrabDao ctDao = new CentroTrabDao();
        List<CentroDeTrabajo> centros = ctDao.obtenerCentroDeTrabajosDeContrato(con.getId());
        if (centros.isEmpty()){
            datos.put("error", "El Contrato seleccionado no tiene Centros de Trabajo registrados");
            return datos;
        }
        
        //obtener los cts que tienen prods registrados, los que no tienen se omiten
        List<CentroDeTrabajo> centrosconprods = new ArrayList<CentroDeTrabajo>();
        boolean prodsxctban = false;
        for (int i=0; i < centros.size(); i++){
            CentroDeTrabajo ct = centros.get(i);
            ProductosCtDao pctDao = new ProductosCtDao();
            boolean hayprods = pctDao.TieneProdsCT(ct.getId());//obtenerListaActivosDeCT(ct.getId());
            if (hayprods){
                prodsxctban = true;
                centrosconprods.add(ct);
            }
        }
        
        //si ningun centro de trabajo tiene productos registrados error
        if (!prodsxctban){
            datos.put("error", "Los Centros de Trabajo del contrato no tienen productos registrados");
            return datos;            
        }
             
        //validar los productos del contrato que no esten en baja
        ProductosCtDao pctDao = new ProductosCtDao();
        List<ProductosCt> prdsct = pctDao.obtenerListaActivosDeContrato(con.getId());
        for (int i=0; i < prdsct.size(); i++){
            ProductosCt pct = prdsct.get(i);
            if (pct.getProducto().getEstatus()==0){
                datos.put("error", "El Producto del contrato "+ pct.getProducto().getClave() +" - "+pct.getProducto().getDescripcion()+" está dado de baja. "
                        + "Por favor verifique y genere los productos de los centros de trabajo nuevamente");
                return datos;
            }
        }

        //checar si hay centros con surtido externo
        boolean surtext = false;
        List<Sucursal> sucsext = new ArrayList<Sucursal>();
        for (int i=0; i < centros.size(); i++){
            CentroDeTrabajo ct = centros.get(i);
            if (ct.getSurtidoexterno()==1){
                if (sucsext.isEmpty())
                    sucsext.add(ct.getSucalterna());
                else if (!sucsext.contains(ct.getSucalterna()))
                    sucsext.add(ct.getSucalterna());
                surtext = true;
            }
        }
        
        /*if (surtext){
            //checar si los productos del contrato tienen equivalente en las sucursales alternas
            ProductoDao proDao = new ProductoDao();
            for (int s=0; s < sucsext.size(); s++){
                Sucursal suc = sucsext.get(s);
                for (int p=0; p < prdsct.size(); p++){
                    ProductosCt pct = prdsct.get(p);
                    String clave = pct.getProducto().getClave().substring(2);
                    if (pct.getProducto().getSucursal().getTipo()==0)
                        clave = pct.getProducto().getClave();
                    List<Producto> equiv = proDao.obtenerProductoEquivalenteDeSucursal(clave, suc.getId(), suc.getTipo());
                    if (equiv == null || equiv.isEmpty()){
                        /*datos.put("error", "El Producto "+pct.getProducto().getDescripcion()+" con clave "+pct.getProducto().getClave()+
                                " no tiene equivalencia en la sucursal "+suc.getDatosfis().getRazonsocial());
                        return datos;*
                        //si no hay prod equiv registrarlo con los datos del producto origen
                        GuardaProductoEquivalenteNuevo(pct.getProducto(), suc, clave);
                    } else if (equiv.size()>1){
                        String equivs = "";
                        for (int e=0; e < equiv.size(); e++){
                            Producto pe = equiv.get(e);
                            if (equivs.equals("")){
                                equivs += pe.getClave()+"-"+pe.getDescripcion();
                            } else {
                                equivs += "; "+pe.getClave()+"-"+pe.getDescripcion();
                            }
                        }
                        datos.put("error", "El Producto "+pct.getDescripcion()+" con clave "+pct.getProducto().getClave()+
                                " tiene más de una equivalencia en la sucursal "+suc.getDatosfis().getRazonsocial()+". "+
                                "Clave usada para buscar:"+clave+". "+
                                "Equivalentes: "+equivs);
                        return datos;
                    }
                }
            }
        }*/
        datos.put("listaCentros", centrosconprods);
        
        return datos;
    }

    private HashMap GenerarSalidasProgsCambios(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        //obtener centros
        CentroTrabDao ctDao = new CentroTrabDao();
        List<CentroDeTrabajo> centros = new ArrayList<CentroDeTrabajo>();
        String ctssel = datos.get("ctssel").toString();
        String[] tkscts = ctssel.split(",");
        for (int i=0; i < tkscts.length; i++){
            centros.add(ctDao.obtener(Integer.parseInt(tkscts[i])));
        }
        
        String fecha = datos.get("fechaspc").toString();
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
        Date fechasp = null;
        try {
            fechasp = form.parse(fecha);
        } catch (ParseException ex) {
        }
        
        for (int i=0; i < centros.size(); i++){
            CentroDeTrabajo ct = centros.get(i);
            //while (fechasp.before(fechaFin) || fechasp.equals(fechaFin)){
                //obtener el tipo de movimiento
                TipoMovDao tmovDao = new TipoMovDao();
                TipoMov tmov = tmovDao.obtener(21);
                //verificar si el mov existe
                MovimientoDao movDao = new MovimientoDao();
                Cabecera cab = movDao.obtenerCabeceraSalidaProgramada(con.getCliente().getId(), con.getId(), ct.getId(), form.format(fechasp), tmov.getId());
                if (cab != null){
                    //obtener detalle y borrarlo
                    List<Detalle> detalles = movDao.obtenerDetalleDeMov(cab.getId());
                    for (int d=0; d < detalles.size(); d++){
                        Detalle det = detalles.get(d);
                        movDao.eliminarDetalle(det);
                    }
                } else {
                    //crear cabecera nueva y guardar
                    cab = new Cabecera();
                    cab.setCliente(con.getCliente());
                    cab.setContrato(con);
                    cab.setCentrotrabajo(ct);
                    cab.setFechaCaptura(fechasp);
                    cab.setSucursal(con.getCliente().getSucursal());
                    cab.setTipomov(tmov);
                    cab.setSerie(tmov.getSerie());
                    cab.setFolio(tmov.getSerie().getFolio().intValue());
                    cab.setEstatus(1);
                    movDao.guardarCabecera(cab);
                    //actualizar folio de la serie
                    Serie ser = cab.getSerie();
                    ser.setFolio(ser.getFolio()+1);
                    SerieDao serDao = new SerieDao();
                    serDao.actualizar(ser);
                }
                
                //generar detalle
                ProductosCtDao pctDao = new ProductosCtDao();
                List<ProductosCt> prdsct = pctDao.obtenerCambiosActivosDeCT(ct.getId());
                for (int p=0; p < prdsct.size(); p++){
                    ProductosCt prod = prdsct.get(p);
                    //if (prod.getTipo()==0){//basico
                    Detalle det = new Detalle();
                    det.setCabecera(cab);
                    det.setAlmacen(prod.getAlmacen());
                    //obtener la primer ubicacion del almacen
                    UbicacionDao ubiDao = new UbicacionDao();
                    List<Ubicacion> ubis = ubiDao.obtenerListaActivasDeAlmacen(prod.getAlmacen().getId());
                    if (!ubis.isEmpty())
                        det.setUbicacion(ubis.get(0));
                    det.setSucursal(prod.getContrato().getCliente().getSucursal());
                    det.setCategoria(prod.getProducto().getCategoria());
                    det.setSubcategoria(prod.getProducto().getSubcategoria());
                    det.setProducto(prod.getProducto());
                    det.setUnidad(prod.getUnidad());
                    det.setDescripcion(prod.getDescripcion());
                    det.setCantidad(prod.getCantidad());
                    //obtener el precio segun la lista de precios del cliente
                    UnidadProductoDao upDao = new UnidadProductoDao();
                    UnidadProducto up = upDao.obtener(prod.getUnidad().getId(), prod.getProducto().getId());
                    int lpcli = con.getCliente().getListaPrecios();
                    /*if (lpcli == 0 || lpcli == 1)
                        det.setPrecio(prod.getProducto().getPrecio1()*prod.getProducto().getCostoUltimo()*up.getValor());
                    else {
                        switch (lpcli){
                            case 2: det.setPrecio(prod.getProducto().getPrecio2()*prod.getProducto().getCostoUltimo()*up.getValor()); break;
                            case 3: det.setPrecio(prod.getProducto().getPrecio3()*prod.getProducto().getCostoUltimo()*up.getValor()); break;
                            case 4: det.setPrecio(prod.getProducto().getPrecio4()*prod.getProducto().getCostoUltimo()*up.getValor()); break;
                            case 5: det.setPrecio(prod.getProducto().getPrecio5()*prod.getProducto().getCostoUltimo()*up.getValor()); break;
                        }
                    }*/
                    det.setDescuento(con.getCliente().getDescuento1());
                    float subimp = det.getPrecio()*det.getCantidad();
                    float cantdesc = subimp *(det.getDescuento()/100);
                    det.setImporte(subimp - cantdesc);
                    det.setIva(prod.getProducto().getIvaNacional());
                    det.setEstatus(1);
                    movDao.guardarDetalle(det);
                    //}
                }
                
                /*if (fechasp.before(fechaFin)){
                //siguiente fecha
                    Calendar cal = Calendar.getInstance(); 
                    cal.setTime(fechasp); 
                    cal.add(Calendar.DATE, dias); 
                    fechasp = cal.getTime();
                    /*if (fechasp.after(fechaFin)){
                        fechasp = fechaFin;
                    }
                } /*else {
                    Calendar cal = Calendar.getInstance(); 
                    cal.setTime(fechasp); 
                    cal.add(Calendar.DATE, dias); 
                    fechasp = cal.getTime();                    
                }*/
            //}
        }
        return datos;
    }

    private HashMap ImportarDatos(HashMap datos) {
        int dat = Integer.parseInt(datos.get("datosimp").toString());
        switch (dat){
            case 1:
                //importar cts
                datos = ImportarCentros(datos);
                break;
            case 2:
                //importar productos
                datos = ImportarProductos(datos);
                break;
            case 3:
                //importar todo
                datos.put("chkplazas", "on");
                datos.put("chkprodcts", "on");
                datos = ImportarCentros(datos);
                datos = ImportarProductos(datos);
                datos = ImportarContactos(datos);
                break;
            case 4:
                //importar contactos
                datos = ImportarContactos(datos);
                break;
        }
        return datos;
    }
    
    private void GenerarMovsExtras(Plaza plz) {
        //Obtener quincena actual
        QuincenaDao quinDao = new QuincenaDao();
        Quincena quinact = quinDao.obtenerQuincenaActual();
        //año actual
        UtilDao uDao = new UtilDao();
        int anio = uDao.AñoActual();
        Calendar quinini = Calendar.getInstance();
        Calendar quinfin = Calendar.getInstance();
        quinini.set(anio,quinact.getNummes()-1,quinact.getInicio(),0,0,0);
        quinfin.set(anio,quinact.getNummes()-1,quinact.getFin(),0,0,0);
        Date fechaIni = quinini.getTime();
        Date fechaFin = quinfin.getTime();
        
        UtilMod util = new UtilMod();
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
            
            if (plz.getFechaalta().before(fechaIni)){
                //mov extra salario nominal dias
                move.setPerded(cnomDao.obtenerPeryDed(1));
            } else if (plz.getFechaalta().after(fechaIni)){
                //mov extra faltas en dias
                move.setPerded(cnomDao.obtenerPeryDed(16));
                dias++;
            }
            move.setImporte((float)dias);
            move.setNumero(1);
            move.setTotal(move.getImporte()*move.getNumero());

            MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();
            meDao.guardar(move);
        }
    }

    private HashMap ImportarCentros(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        Contrato consel = new Contrato();
        consel.setId(Integer.parseInt(datos.get("contratoimp").toString()));
        String chkeliminar = datos.get("chkeliminar").toString();
        CentroTrabDao ctDao = new CentroTrabDao();
        PlazaDao plzDao = new PlazaDao();
        MovimientoExtraordinarioDao meDao = new MovimientoExtraordinarioDao();

        //verificar que el contrato seleccionado tiene cts registrados
        List<CentroDeTrabajo> ctsimp = ctDao.obtenerCentroDeTrabajosDeContrato(consel.getId());
        if (ctsimp == null || ctsimp.isEmpty()){
            datos.put("error", "El contrato seleccionado no tiene Centros de Trabajo registrados");
            return datos;
        }

        if (chkeliminar.equals("on")){
            //poner en baja los cts actuales del contrato
            List<CentroDeTrabajo> ctsact = ctDao.obtenerCentroDeTrabajosDeContrato(con.getId());
            for (int i=0; i < ctsact.size(); i++){
                CentroDeTrabajo cta = ctsact.get(i);
                ctDao.actualizarEstatus(0, cta.getId());
                //poner en baja las plazas actuales
                List<Plaza> plzsact = plzDao.obtenerListaActivasDeCT(cta.getId());
                for (int p=0; p < plzsact.size(); p++){
                    Plaza pact = plzsact.get(p);
                    plzDao.actualizarEstatus(0, pact.getId());
                    //poner en baja los movsextra de las plazas
                    List<MovimientoExtraordinario> mvextact = meDao.obtenerListaActivosDePlaza(pact.getId());
                    for (int m=0; m < mvextact.size(); m++){
                        MovimientoExtraordinario mea = mvextact.get(m);
                        meDao.actualizarEstatus(0, mea.getId());
                    }
                }
                //eliminar los contactos de cts actuales
                ContactoCTDao cctdao = new ContactoCTDao();
                List<ContactoCT> concts = cctdao.obtenerContactosDeCT(cta.getId());
                for (int ic=0; ic < concts.size(); ic++){
                    ContactoCT ccta = concts.get(ic);
                    cctdao.eliminar(ccta);
                }                
            }
        }

        String chkplazas = datos.get("chkplazas").toString();
        String chkprodcts = datos.get("chkprodcts").toString();
        for (int i=0; i < ctsimp.size(); i++){
            CentroDeTrabajo cti = ctsimp.get(i);
            CentroDeTrabajo ctnvo = new CentroDeTrabajo();
            if (con.getFacturarCT()==1 && consel.getFacturarCT()==1)
                ctnvo.setDatosfiscales(cti.getDatosfiscales());
            else
                ctnvo.setDatosfiscales(null);
            ctnvo.setCliente(con.getCliente());
            ctnvo.setContrato(con);
            ctnvo.setDiasEntrega(cti.getDiasEntrega());
            ctnvo.setEstatus(1);
            ctnvo.setNombre(cti.getNombre());
            ctnvo.setObservaciones(cti.getObservaciones());
            ctnvo.setPersonal(cti.getPersonal());
            ctnvo.setTopeInsumos(cti.getTopeInsumos());
            ctnvo.setTopeSueldos(cti.getTopeSueldos());
            ctnvo.setRuta(cti.getRuta());
            ctnvo.setSurtidoexterno(cti.getSurtidoexterno());
            ctnvo.setSucalterna(cti.getSucalterna());
            ctDao.guardar(ctnvo);
            
            //importar los contactos del ct
            ContactoCTDao cctdao = new ContactoCTDao();
            List<ContactoCT> concts = cctdao.obtenerContactosDeCT(cti.getId());
            for (int ic=0; ic < concts.size(); ic++){
                ContactoCT ccti = concts.get(ic);
                ContactoCT cctnvo = new ContactoCT();
                cctnvo.setContacto(ccti.getContacto());
                cctnvo.setCt(ctnvo);
                cctdao.guardar(cctnvo);
            }
            
            //importar las plazas
            if (chkplazas.equals("on")){
                //obtener las plazas del ct importado actual
                List<Plaza> plzsimp = plzDao.obtenerListaActivasDeCT(cti.getId());
                for (int p=0; p < plzsimp.size(); p++){
                    Plaza plzimp = plzsimp.get(p);
                    Plaza plznva = new Plaza();
                    plznva.setCliente(con.getCliente());
                    plznva.setCompensacion(plzimp.getCompensacion());
                    plznva.setContrato(con);
                    plznva.setCtrabajo(ctnvo);
                    plznva.setEmpleado(plzimp.getEmpleado());
                    plznva.setEstatus(1);
                    plznva.setFechaalta(con.getFechaIni());
                    plznva.setFormapago(plzimp.getFormapago());
                    plznva.setNivel(plzimp.getNivel());
                    plznva.setPeriodopago(plzimp.getPeriodopago());
                    plznva.setPuesto(plzimp.getPuesto());
                    plznva.setSucursal(plzimp.getSucursal());
                    plznva.setSueldo(plzimp.getSueldo());
                    plzDao.guardar(plznva);
                    GenerarMovsExtras(plznva);
                    CargarMovsExtrasPermanentesDePlazaImportada(plznva, plzimp);
                }
            }
            
            //importar los productos de ct
            if (chkprodcts.equals("on")){
                //obtener los productos registrados del ct actual
                ProductosCtDao pctdao = new ProductosCtDao();
                List<ProductosCt> prodsct = pctdao.obtenerListaActivosDeCT(cti.getId());
                float tope = 0.0f;
                for (int ipct=0; ipct < prodsct.size(); ipct++){
                    ProductosCt pcti = prodsct.get(ipct);
                    ProductosCt pctnvo = new ProductosCt();
                    pctnvo.setAlmacen(pcti.getAlmacen());
                    pctnvo.setCantidad(pcti.getCantidad());
                    pctnvo.setCategoria(pcti.getCategoria());
                    pctnvo.setCentrotrab(ctnvo);
                    pctnvo.setCliente(ctnvo.getCliente());
                    pctnvo.setConfigentrega(ctnvo.getConfigentrega());
                    pctnvo.setContrato(ctnvo.getContrato());
                    pctnvo.setDescripcion(pcti.getDescripcion());
                    pctnvo.setDiasentrega(pcti.getDiasentrega());
                    pctnvo.setEstatus(1);
                    pctnvo.setImprimir(pcti.getImprimir());
                    pctnvo.setListaprecios(pcti.getListaprecios());
                    pctnvo.setPrecio(pcti.getPrecio());
                    pctnvo.setProducto(pcti.getProducto());
                    pctnvo.setTipo(pcti.getTipo());
                    pctnvo.setTipoentrega(pcti.getTipoentrega());
                    pctnvo.setUnidad(pcti.getUnidad());
                    
                    pctdao.guardar(pctnvo);
                    
                    tope+=pctnvo.getCantidad()*pctnvo.getPrecio();
                }//end for
                
                CentroTrabDao ctdao = new CentroTrabDao();
                ctnvo.setTopeInsumos(tope);
                ctdao.actualizar(ctnvo);
            }
        }
        return datos;
    }

    private HashMap ImportarProductos(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        ContratoDao condao = new ContratoDao();
        con = condao.obtener(con.getId());
        Contrato consel = new Contrato();
        consel.setId(Integer.parseInt(datos.get("contratoimp").toString()));
        String chkeliminar = datos.get("chkeliminar").toString();
        //verficar que el contrato fuente tenga productos
        ProductosCtDao pctDao = new ProductosCtDao();
        List<ProductosCt> pctimp = pctDao.obtenerListaActivosDeContrato(consel.getId());
        if (pctimp==null || pctimp.isEmpty()){
            datos.put("error", "El contrato seleccionado no tiene Productos registrados");
            return datos;
        }

        if (chkeliminar.equals("on")){
            //poner en baja los productos actuales del contrato
            List<ProductosCt> pctact = pctDao.obtenerListaActivosDeContrato(con.getId());
            for (int i=0; i < pctact.size(); i++){
                ProductosCt pact = pctact.get(i);
                pctDao.actualizarEstatus(0, pact.getId());
            }
        }

        for (int i=0; i < pctimp.size(); i++){
            ProductosCt pimp = pctimp.get(i);
            if (pimp.getProducto().getEstatus()==1){
                ProductosCt pnvo = new ProductosCt();
                pnvo.setAlmacen(pimp.getAlmacen());
                pnvo.setCantidad(pimp.getCantidad());
                pnvo.setCategoria(pimp.getCategoria());
                pnvo.setCentrotrab(null);
                pnvo.setCliente(con.getCliente());
                pnvo.setContrato(con);
                pnvo.setDescripcion(pimp.getDescripcion());
                pnvo.setEstatus(1);
                pnvo.setListaprecios(pimp.getListaprecios());
                pnvo.setProducto(pimp.getProducto());
                pnvo.setTipo(pimp.getTipo());
                pnvo.setImprimir(pimp.getImprimir());
                //obtener la unidad actual
                UnidadProductoDao updao = new UnidadProductoDao();
                UnidadProducto up = updao.obtener(pimp.getUnidad().getId(), pimp.getProducto().getId());
                if (up==null){
                    up = updao.obtenerUnidadInactivaDeProducto(pimp.getUnidad().getId(), pimp.getProducto().getId());
                    if (up.getMinima()==1)
                        up = updao.obtenerUnidadMinimaDeProducto(pimp.getProducto().getId());
                    else
                        up = updao.obtenerUnidadEmpaqueDeProducto(pimp.getProducto().getId());
                    pnvo.setUnidad(up.getUnidad());
                } else {
                    pnvo.setUnidad(pimp.getUnidad());
                }
                
                
                //obtener el precio actualizado del producto
                CostoProductoDao cpdao = new CostoProductoDao();
                CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(pimp.getProducto().getId(), con.getSucursal().getId());
                PrecioProductoDao ppdao = new PrecioProductoDao();
                PrecioProducto facpre = ppdao.obtenerPrecioNDeProductoYSucursal(pimp.getListaprecios(), pimp.getProducto().getId(), con.getSucursal().getId());
                UtilMod utmod = new UtilMod();
                pnvo.setPrecio(new Double(utmod.Redondear(facpre.getFactor()*cp.getCosto()*up.getValor(),2)).floatValue());
                
                pctDao.guardar(pnvo);
            }
        }
        return datos;
    }

    private HashMap MostrarConcluidos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        ContratoDao conDao = new ContratoDao();
        datos.put("listaContratos", conDao.obtenerContratosDeClienteYSucursalConcluidos(cli.getId(), sucSel.getId()));
        datos.put("banhis", "1");
        return datos;
    }

    private HashMap MostrarVigentes(HashMap datos) {
        datos.remove("banhis");
        datos = ObtenerListado(datos);
        return datos;
    }

    private HashMap ObtenerTodosLosContratos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Cliente cli = (Cliente)datos.get("clienteSel");
        ContratoDao conDao = new ContratoDao();
        datos.put("todosloscontratos", conDao.obtenerContratosDeClienteYSucursalTodos(cli.getId(), sucSel.getId()));
        return datos;
    }

    private void GuardaProductoEquivalenteNuevo(Producto producto, Sucursal suc, String clave) {
        String cvenva = clave;
        switch(suc.getId()){
            case 14:
                cvenva = "C-"+clave;
                break;
            case 15:
                cvenva = "V-"+clave;
                break;
            case 16:
                cvenva = "T-"+clave;
                break;
        }
        Producto nvo = new Producto();
        nvo.setCategoria(producto.getCategoria());
        nvo.setClave(cvenva);
        nvo.setCodigoAlterno(producto.getCodigoAlterno());
        /*nvo.setCostoActual(producto.getCostoActual());
        nvo.setCostoPromedio(producto.getCostoPromedio());
        nvo.setCostoUltimo(producto.getCostoUltimo());*/
        nvo.setDescripcion(producto.getDescripcion());
        nvo.setDescuento1(producto.getDescuento1());
        nvo.setDescuento2(producto.getDescuento2());
        nvo.setDescuento3(producto.getDescuento3());
        nvo.setDescuento4(producto.getDescuento4());
        nvo.setDescuento5(producto.getDescuento5());
        nvo.setDescuentoMaximo(producto.getDescuentoMaximo());
        nvo.setEstatus(1);
        nvo.setFechaUltCompra(producto.getFechaUltCompra());
        nvo.setFechaUltVenta(producto.getFechaUltVenta());
        nvo.setIep(producto.getIep());
        nvo.setIvaExtranjero(producto.getIvaExtranjero());
        nvo.setMarca(producto.getMarca());
        /*nvo.setPeso(producto.getPeso());
        nvo.setPrecio1(producto.getPrecio1());
        nvo.setPrecio2(producto.getPrecio2());
        nvo.setPrecio3(producto.getPrecio3());
        nvo.setPrecio4(producto.getPrecio4());
        nvo.setPrecio5(producto.getPrecio5());*/
        nvo.setProveedor(producto.getProveedor());
        nvo.setServicio(producto.getServicio());
        nvo.setStockMaximo(producto.getStockMaximo());
        nvo.setStockMinimo(producto.getStockMinimo());
        nvo.setSubcategoria(producto.getSubcategoria());
        //nvo.setSucursal(suc);
        nvo.setTipo(producto.getTipo());
        nvo.setUnidad(producto.getUnidad());
        ProductoDao prodao = new ProductoDao();
        prodao.guardar(nvo);
        //guardar su unidad minima y su unidad de empaque
        UnidadProductoDao updao = new UnidadProductoDao();
        UnidadProducto emp = updao.obtenerUnidadEmpaqueDeProducto(producto.getId());
        UnidadProducto nvoemp = new UnidadProducto();
        UnidadProducto nvomin = new UnidadProducto();
        nvoemp.setEmpaque(1);
        nvoemp.setEstatus(1);
        nvoemp.setMinima(0);
        nvoemp.setProducto(nvo);
        nvoemp.setUnidad(emp.getUnidad());
        nvoemp.setValor(emp.getValor());
        nvomin.setEmpaque(0);
        nvomin.setEstatus(1);
        nvomin.setMinima(1);
        nvomin.setProducto(nvo);
        nvomin.setUnidad(nvo.getUnidad());
        nvomin.setValor(1);
        updao.guardar(nvomin);
        updao.guardar(nvoemp);
    }

    private HashMap ActualizarSalidasProgramadas(HashMap datos) {
        //obtener la fecha actual
        //obtener las salidas programadas del contrato posteriores a la fecha actual
        //para cada una de las salidas programadas regenerar el detalle correspondiente
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
        Contrato con = (Contrato)datos.get("editarContrato");
        ContactoContratoDao ccdao = new ContactoContratoDao();
        List<ContactoContrato> contactos = ccdao.obtenerContactosDeContrato(con.getId());
        List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
        datos.put("contactos", contactos);
        if (contactos.size()>0)
            medioscon = ccdao.obtenerMediosDeContactosDeContrato(con.getId());
        datos.put("medioscon", medioscon);
        return datos;
    }

    private HashMap ImportarContactos(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        ContratoDao condao = new ContratoDao();
        con = condao.obtener(con.getId());
        Contrato consel = new Contrato();
        consel.setId(Integer.parseInt(datos.get("contratoimp").toString()));
        
        String chkeliminar = datos.get("chkeliminar").toString();
        if (chkeliminar.equals("on")){
            //eliminar contactos del contrato actual
            ContactoContratoDao ccdao = new ContactoContratoDao();
            List<ContactoContrato> ccons = ccdao.obtenerContactosDeContrato(con.getId());
            for (int ic=0; ic < ccons.size(); ic++){
                ContactoContrato cc = ccons.get(ic);
                ccdao.eliminar(cc);
            }
        }
        
        //obtener contactos del contrato a importar
        ContactoContratoDao ccdao = new ContactoContratoDao();
        List<ContactoContrato> ccons = ccdao.obtenerContactosDeContrato(consel.getId());
        for (int i=0; i < ccons.size(); i++){
            ContactoContrato cc = ccons.get(i);
            ContactoContrato ccnvo = new ContactoContrato();
            ccnvo.setContacto(cc.getContacto());
            ccnvo.setContrato(con);
            ccdao.guardar(ccnvo);
        }
        
        return datos;
    }

    private HashMap BorrarDocumentoDeContrato(HashMap datos) {
        String rutaDoc = datos.get("rutadoc").toString();
        Contrato con = (Contrato)datos.get("editarContrato");
        String name = Integer.toString(con.getId());
        File dest = new File(rutaDoc+"/"+name+".pdf");
        if (dest.exists())
            dest.delete();
        
        con.setDocumento(0);
        ContratoDao condao = new ContratoDao();
        condao.actualizar(con);
        datos.put("editarContrato", con);
        return datos;
    }
    
    private HashMap BorrarDocumentoDeFianza(HashMap datos) {
        String rutaDoc = datos.get("rutadoc").toString();
        Contrato con = (Contrato)datos.get("editarContrato");
        String name = Integer.toString(con.getId());
        File dest = new File(rutaDoc+"/"+name+".pdf");
        if (dest.exists())
            dest.delete();
        
        con.setDocfianza(0);
        ContratoDao condao = new ContratoDao();
        condao.actualizar(con);
        datos.put("editarContrato", con);
        return datos;
    }

    private HashMap GuardaContacto(HashMap datos) {
        ContactoContrato contac = (ContactoContrato)datos.get("contacto");
        Contrato con = (Contrato)datos.get("editarContrato");
        String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
        ContactoContratoDao ccdao = new ContactoContratoDao();
        PersonaDao perdao = new PersonaDao();
        TipoMedioDao tmdao = new TipoMedioDao();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        MedioDao meddao = new MedioDao();
        if (accion.equals("nuevo")){
            contac.setContrato(con);
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
        ContactoContrato cc = (ContactoContrato)datos.get("contacto");
        ContactoContratoDao ccdao = new ContactoContratoDao();
        cc = ccdao.obtener(cc.getId());
        datos.put("contacto", cc);
        PersonaMedioDao pmdao = new PersonaMedioDao();
        datos.put("medioscontacto", pmdao.obtenerActivosDePersona(cc.getContacto().getIdpersona()));
        return datos;
    }

    private HashMap BorrarContacto(HashMap datos) {
        ContactoContrato cc = (ContactoContrato)datos.get("contacto");
        ContactoContratoDao ccdao = new ContactoContratoDao();
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
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }
    
    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }

    private HashMap ObtenerClientesDeSucursal(HashMap datos) {
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        ClienteDao clidao = new ClienteDao();
        datos.put("clientes", clidao.obtenerClientesDeSucursal(suc.getId()));
        return datos;
    }

    private HashMap ConsultarContratos(HashMap datos) {
        ContratoDao condao = new ContratoDao();
        String sql = "from Contrato where id>0";
        Sucursal suc = (Sucursal)datos.get("sucursalSel");
        if (suc.getId()>0)
            sql += " and sucursal.id="+Integer.toString(suc.getId());
        Cliente cli = (Cliente)datos.get("clienteSel");
        if (cli.getId()>0)
            sql += " and cliente.id="+Integer.toString(cli.getId());
        String sespec = datos.get("especialidad").toString();
        if (!sespec.equals("0"))
            sql += " and especialidad="+sespec;
        String stotper = datos.get("totper").toString();
        if (!stotper.equals("0"))
            sql += " and totalpersonal="+stotper;
        String fini = datos.get("fechaini").toString();
        if (!fini.equals("")){
            String sfechaini = fini.substring(6,10)+"-"+fini.substring(3,5)+"-"+fini.substring(0,2);
            sql += " and fechaIni>='"+sfechaini+"'";            
        }
            
        String ffin = datos.get("fechafin").toString();
        if (!ffin.equals("")){
            String sfechafin = ffin.substring(6,10)+"-"+ffin.substring(3,5)+"-"+ffin.substring(0,2);
            sql += " and fechaFin<='"+sfechafin+"'"; 
        }
        
        List<Contrato> contratos = condao.obtenerContratosDeConsulta(sql);
        datos.put("contratos", contratos);
        return datos;
    }

    private void CargarMovsExtrasPermanentesDePlazaImportada(Plaza plznva, Plaza plzimp) {
        MovimientoExtraordinarioDao medao = new MovimientoExtraordinarioDao();
        List<MovimientoExtraordinario> movsperma = medao.obtenerListaActivosFijosDePlaza(plzimp.getId());
        for (int i=0; i < movsperma.size(); i++){
            MovimientoExtraordinario me = movsperma.get(i);
            MovimientoExtraordinario menvo = new MovimientoExtraordinario();
            menvo.setAnio(me.getAnio());
            menvo.setCotiza(me.getCotiza());
            menvo.setEstatus(1);
            menvo.setFijo(1);
            menvo.setImporte(me.getImporte());
            menvo.setNumero(me.getNumero());
            menvo.setObservaciones(me.getObservaciones());
            menvo.setPerded(me.getPerded());
            menvo.setPeriodo(me.getPeriodo());
            menvo.setPlaza(plznva);
            menvo.setPrestacionimss(me.getPrestacionimss());
            menvo.setQuincena(me.getQuincena());
            menvo.setTipocambio(me.getTipocambio());
            menvo.setTiponomina(me.getTiponomina());
            menvo.setTotal(me.getTotal());
            medao.guardar(menvo);
        }
    }
    
}
