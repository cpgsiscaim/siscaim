/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.*;
import Modelo.Entidades.*;
import Modelo.Entidades.Catalogos.Estado;
import Modelo.Entidades.Catalogos.FechasEntrega;
import Modelo.Entidades.Catalogos.TipoMedio;
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
public class CentrosMod {
    public CentrosMod(){
    }

    public Sesion GestionarCentros(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
            case 0:
                //obtener la lista de sucursales activas
                //datos.put("sucursales", ObtenerSucursales());
                break;
            case 1:
                //ir a nuevo centro
                datos.put("accion", "nuevo");
                datos = ObtenerRutas(datos);
                datos = CargarEstados(datos);
                datos = ObtenerRutasDeSucursales(datos);
                datos = CargaConfigEntregaContrato(datos);
                datos = ObtenerCatalogosContactos(datos);
                break;
            case 2: case 4:
                //guardar nuevo centro(2) || guardar editado(4)
                datos = GuardarCentro(datos);
                break;
            case 3:
                //ir a editar centro
                datos = ObtenerCentro(datos);
                datos = CargarEstados(datos);
                datos = ObtenerRutas(datos);
                datos = ObtenerRutasDeSucursales(datos);
                datos = ObtenerContactos(datos);
                datos = ObtenerCatalogosContactos(datos);
                break;
            case 5:
                //baja de centro de trabajo
                datos = BajaDeCentro(datos);
                break;
            case 6:
                //ir a  inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                datos = ActivarCentro(datos);
                break;
            case 8:
                datos = CargaProductosCt(datos);
                datos.put("categoria", "1");
                break;
            case 9:
                datos = CargaPlazasCt(datos);
                //sesion.setPaginaAnterior("/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp");
                break;
            case 11:
                datos = GuardaContacto(datos);
                break;
            case 12:
                datos = EditarContacto(datos);
                break;
            case 13:
                datos = BorrarContacto(datos);
                break;
            case 96:
                //cancelar nuevo contacto
                datos.remove("contacto");
                datos.remove("accionContacto");
                datos.put("pestaña","2");
                break;
            case 97:
                //salir de inactivos
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo centro
                datos.remove("centroTrab");
                datos.remove("accion");
                datos.remove("fechasentct");
                break;
            case 99:
                //salir de centros de trabajo
                datos.remove("listaCentros");
                datos.remove("editarContrato");
                datos.remove("fechasent");
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }

    private HashMap GuardarCentro(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        Cliente cli = (Cliente)datos.get("clienteSel");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        //RutaDao rutDao = new RutaDao();
        //ct.setRuta(rutDao.obtener(ct.getRuta().getId()));
        CentroTrabDao ctDao = new CentroTrabDao();
        if (datos.get("accion").toString().equals("nuevo")){
            ct.setCliente(cli);
            ct.setContrato(con);
            ct.setEstatus(1);
            if (con.getFacturarCT()==1)
                ct.getDatosfiscales().setTipo("0");
            else
                ct.setDatosfiscales(null);
            ctDao.guardar(ct);
        }
        else
            ctDao.actualizar(ct);
        
        FechasEntregaDao fedao = new FechasEntregaDao();
        //si la configuracion de fechas es por fechas especificas
        if (ct.getConfigentrega()==1 && ct.getTipoentrega()==1){
            if (datos.get("accion").toString().equals("editar")){
                fedao.eliminarFechasDeEntidad(2, ct.getId());
            }
            String fechas = datos.get("fechasentct").toString();
            StringTokenizer tokens=new StringTokenizer(fechas, ",");
            while(tokens.hasMoreTokens()){
                //System.out.println(tokens.nextToken());
                FechasEntrega fent = new FechasEntrega();
                fent.setEntidad(2);
                fent.setIdentidad(ct.getId());
                SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
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
        } else if (ct.getTipoentrega()==0){
            //checar si el contrato tiene fechas de entrega registradas, las elimina
            fedao.eliminarFechasDeEntidad(2, ct.getId());
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
        
        
        List<ContactoCT> conactuales = datos.get("contactos")!=null?(List<ContactoCT>)datos.get("contactos"): new ArrayList<ContactoCT>();
        ContactoCTDao ccdao = new ContactoCTDao();
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
                ContactoCT nuevocon = new ContactoCT();
                nuevocon.setCt(ct);
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
                ContactoCT conexi = ccdao.obtener(idcon);
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
            ContactoCT conexi = ccdao.obtener(idbaja);
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
        
        datos.put("listaCentros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        datos.remove("centro");
        datos.remove("accion");
        datos.remove("fechasentct");
        return datos;
    }

    private HashMap ObtenerCentro(HashMap datos) {
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        CentroTrabDao ctDao = new CentroTrabDao();
        ct = ctDao.obtener(ct.getId());
        datos.put("centro", ct);
        datos.put("accion", "editar");
        //si la config de las entregas es personalizada por fechas especificas obtener las fechas
        if (ct.getContrato().getTipoentrega()==1){
            List<FechasEntrega> fechasent = (List<FechasEntrega>)datos.get("fechasent");
            List<FechasEntrega> fechascon = new ArrayList<FechasEntrega>();
            fechascon.addAll(fechasent);
            FechasEntregaDao fedao = new FechasEntregaDao();
            List<FechasEntrega> fechasct = fedao.obtenerFechasDeEntidad(2, ct.getId());
            datos.put("fechasentct", fechasct);
            for (int i=0; i < fechasct.size(); i++){
                FechasEntrega fect = fechasct.get(i);
                for (int j=0; j < fechascon.size(); j++){
                    FechasEntrega fecon = fechascon.get(j);
                    if (fecon.getFecha().equals(fect.getFecha())){
                        fechascon.remove(j);
                        break;
                    }
                }
            }
            datos.put("fechascon", fechascon);
        }
        
        if (ct.getTipoentrega()==1){
            FechasEntregaDao fedao = new FechasEntregaDao();
            List<FechasEntrega> fechasct = fedao.obtenerFechasDeEntidad(2, ct.getId());
            datos.put("fechasentct", fechasct);
        }

        return datos;
    }

    private HashMap BajaDeCentro(HashMap datos) {
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        CentroTrabDao ctDao = new CentroTrabDao();
        ctDao.actualizarEstatus(0, ct.getId());
        Contrato con = (Contrato)datos.get("editarContrato");
        datos.put("listaCentros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        datos.remove("centro");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        CentroTrabDao ctDao = new CentroTrabDao();
        datos.put("inactivos", ctDao.obtenerCentroDeTrabajosInactivosDeContrato(con.getId()));
        return datos;
    }

    private HashMap ActivarCentro(HashMap datos) {
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        CentroTrabDao ctDao = new CentroTrabDao();
        ctDao.actualizarEstatus(1, ct.getId());
        Contrato con = (Contrato)datos.get("editarContrato");
        datos.put("listaCentros", ctDao.obtenerCentroDeTrabajosDeContrato(con.getId()));
        datos.put("inactivos", ctDao.obtenerCentroDeTrabajosInactivosDeContrato(con.getId()));
        datos.remove("centro");
        return datos;
    }

    private HashMap CargarEstados(HashMap datos) {
        //cargar estados
        EstadoDao edoDao = new EstadoDao();
        MunicipioDao munDao = new MunicipioDao();
        List<Estado> estados = edoDao.obtenerListaPorPrioridad();
        for (int i=0; i < estados.size(); i++){
            Estado edo = estados.get(i);
            edo.setMunicipios(munDao.obtenerMunisDeEdoAlfabetico(edo.getIdestado()));
        }
        datos.put("estados", estados);
        return datos;
    }

    private HashMap CargaProductosCt(HashMap datos) {
        datos = ObtenerCentro(datos);
        datos.remove("accion");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        ProductosCtDao pctDao = new ProductosCtDao();
        List<ProductosCt> pcts = pctDao.obtenerListaActivosDeCT(ct.getId());
        //Actualizar precios de productos del ct
        CostoProductoDao cpdao = new CostoProductoDao();
        PrecioProductoDao ppdao = new PrecioProductoDao();
        UnidadProductoDao updao = new UnidadProductoDao();
        //boolean actualizacion = false;
        float tope = 0.0f;
        for (int i=0; i < pcts.size(); i++){
            ProductosCt pct = pcts.get(i);
            //calcular el precio del producto con el costo y factor actuales
            CostoProducto cp = cpdao.obtenerCostoDeProductoYSucursal(pct.getProducto().getId(), ct.getContrato().getSucursal().getId());
            PrecioProducto pp = ppdao.obtenerPrecioNDeProductoYSucursal(pct.getListaprecios(), pct.getProducto().getId(), ct.getContrato().getSucursal().getId());
            UnidadProducto up = updao.obtener(pct.getUnidad().getId(), pct.getProducto().getId());
            if (up==null)
                up = updao.obtenerUnidadInactivaDeProducto(pct.getUnidad().getId(), pct.getProducto().getId());
            float prenvo = cp.getCosto()*pp.getFactor()*up.getValor();
            tope+=prenvo*pct.getCantidad();
            if (prenvo!=pct.getPrecio()){
                //actualizacion = true;
                pct.setPrecio(prenvo);
                pctDao.actualizar(pct);
                pcts.set(i, pct);
            }
        }
        //actualizar el tope del ct si cambio
        if (tope!=ct.getTopeInsumos()){
            CentroTrabDao ctdao = new CentroTrabDao();
            ct.setTopeInsumos(tope);
            ctdao.actualizar(ct);
        }
        /*if (actualizacion)
            pcts = pctDao.obtenerListaActivosDeCT(ct.getId());*/
        
        datos.put("productosct", pcts);
        return datos;
    }

    private HashMap CargaPlazasCt(HashMap datos) {
        datos = ObtenerCentro(datos);
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        PlazaDao plzDao = new PlazaDao();
        //datos.put("plazas", plzDao.obtenerListaActivasDeCT(ct.getId()));
        List<Plaza> plas = plzDao.obtenerListaActivasDeCT(ct.getId());
        datos.put("plazas", plas);
        //calcular acumulado de sueldos
        float acum = 0.0f;
        for (int i=0; i < plas.size(); i++){
            Plaza p = plas.get(i);
            //verificar si el tope de sueldo incluye la compensacion de las plazas
            acum+=p.getSueldo();
        }
        datos.put("acumsueldos", new Float(acum));
        
        
        datos.put("origenplazas", "/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp");
        datos.put("paso", "1");
        datos.put("clientes", datos.get("listado"));
        datos.put("contratos", datos.get("listaContratos"));
        datos.put("centros", datos.get("listaCentros"));
        return datos;
    }

    private HashMap ObtenerRutas(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        RutaDao rutDao = new RutaDao();
        datos.put("rutas", rutDao.obtenerRutasDeSucursal(sucSel.getId()));
        return datos;
    }

    private HashMap ObtenerRutasDeSucursales(HashMap datos) {
        List<Sucursal> sucs = (List<Sucursal>)datos.get("sucursales");
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        RutaDao rutDao = new RutaDao();
        List<Ruta> rutasfull = new ArrayList<Ruta>();
        for (int i=0; i < sucs.size(); i++){
            Sucursal suc = sucs.get(i);
            if (suc.getId()!=sucSel.getId()){
                List<Ruta> rutassuc = rutDao.obtenerRutasDeSucursal(suc.getId());
                rutasfull.addAll(rutassuc);
            }
        }
        datos.put("rutassucs", rutasfull);
        return datos;
    }

    private HashMap CargaConfigEntregaContrato(HashMap datos) {
        Contrato con = (Contrato)datos.get("editarContrato");
        if (con.getTipoentrega()==1){
            FechasEntregaDao fedao = new FechasEntregaDao();
            List<FechasEntrega> fechasct = fedao.obtenerFechasDeEntidad(1, con.getId());
            datos.put("fechascon", fechasct);
        }
        return datos;
    }
    
    private HashMap ObtenerCatalogosContactos(HashMap datos) {
        TituloDao titdao = new TituloDao();
        datos.put("titulos", titdao.obtenerListaActivos());
        TipoMedioDao tmdao = new TipoMedioDao();
        datos.put("tiposmedios", tmdao.obtenerListaActivos());
        return datos;
    }
    
    private HashMap ObtenerContactos(HashMap datos) {
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        ContactoCTDao ccdao = new ContactoCTDao();
        List<ContactoCT> contactos = ccdao.obtenerContactosDeCT(ct.getId());
        List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
        datos.put("contactos", contactos);
        if (contactos.size()>0)
            medioscon = ccdao.obtenerMediosDeContactosDeCT(ct.getId());
        datos.put("medioscon", medioscon);
        return datos;
    }
    
    private HashMap GuardaContacto(HashMap datos) {
        ContactoCT contac = (ContactoCT)datos.get("contacto");
        CentroDeTrabajo ct = (CentroDeTrabajo)datos.get("centro");
        String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
        ContactoCTDao ccdao = new ContactoCTDao();
        PersonaDao perdao = new PersonaDao();
        TipoMedioDao tmdao = new TipoMedioDao();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        MedioDao meddao = new MedioDao();
        if (accion.equals("nuevo")){
            contac.setCt(ct);
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
            List<PersonaMedio> mediosactuales = (List<PersonaMedio>)datos.get("medioscon");
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
        datos.put("pestaña","2");
        datos.remove("contacto");
        datos.remove("medioscontacto");
        datos.remove("accionContacto");
        return datos;
    }

    private HashMap EditarContacto(HashMap datos) {
        ContactoCT cc = (ContactoCT)datos.get("contacto");
        ContactoCTDao ccdao = new ContactoCTDao();
        cc = ccdao.obtener(cc.getId());
        datos.put("contacto", cc);
        PersonaMedioDao pmdao = new PersonaMedioDao();
        datos.put("medioscon", pmdao.obtenerActivosDePersona(cc.getContacto().getIdpersona()));
        return datos;
    }

    private HashMap BorrarContacto(HashMap datos) {
        ContactoCT cc = (ContactoCT)datos.get("contacto");
        ContactoCTDao ccdao = new ContactoCTDao();
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
        datos.put("pestaña","2");
        datos.remove("contacto");
        datos.remove("accionContacto");
        
        return datos;
    }
    
}
