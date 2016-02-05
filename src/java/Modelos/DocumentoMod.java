/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.CategoriaDocDao;
import Modelo.Daos.Catalogos.TipoDocumentoDao;
import Modelo.Daos.DocumentoDao;
import Modelo.Daos.EmpleadoDao;
import Modelo.Daos.SucursalDao;
import Modelo.Entidades.Catalogos.CategoriaDoc;
import Modelo.Entidades.Catalogos.TipoDocumento;
import Modelo.Entidades.Documento;
import Modelo.Entidades.Empleado;
import Modelo.Entidades.Sucursal;
import java.util.*;

/**
 *
 * @author usuario
 */
public class DocumentoMod {
    int grupos = 0;
    public DocumentoMod(){
    }
    
    public Sesion GestionarDocumentos(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 1:
                //nuevo documentos
                datos.put("accion", "nuevo");
                datos = ObtenerCatalogos(datos);
                break;
            case 3:
                //editar doc
                datos = ObtenerDocumento(datos);
                datos.put("accion", "editar");
                datos = ObtenerCatalogos(datos);
                datos = RespaldaCategoria(datos);
                break;
            case 4:
                //guardar el documento
                datos = GuardarDocumento(datos);
                break;
            case 5:
                //baja de documentos
                datos = BajaDeDocumentos(datos);
                break;
            case 6:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 7:
                datos = ActivarDocumento(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    datos.remove("error");
                }
                break;
            case 8:
                //imprimir documento
                datos = ImprimirReporte(datos);
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
            case 97:
                //quitar catalogos
                datos = QuitarCatalogos(datos);
                break;
            case 98:
                //cancelar inactivos
                datos.remove("inactivos");
                break;
            case 99:
                datos.remove("documentos");
                datos.remove("empleado");
                datos.remove("gruposdoc");
                datos.remove("inicialdoc");
                datos.remove("finaldoc");
                datos.remove("anterioresdoc");
                datos.remove("siguientesdoc");
                datos.remove("listacompletadoc");
                //datos = ObtenerEstatusDocumentacion(datos);
            break;
        }
        
        sesion.setDatos(datos);        
        return sesion;
      }
    
    private HashMap CargarSiguientes(HashMap datos) {
        int fin = Integer.parseInt(datos.get("finaldoc").toString());
        datos.put("inicialdoc", Integer.toString(fin+1));
        datos = ObtenerGrupoDocs(datos);
        return datos;
    }

    private HashMap CargarAnteriores(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicialdoc").toString())-grupos;
        datos.put("inicialdoc", Integer.toString(ini));
        datos = ObtenerGrupoDocs(datos);
        return datos;
    }

    private HashMap CargarPrincipio(HashMap datos) {
        datos.put("inicialdoc", "1");
        datos = ObtenerGrupoDocs(datos);        
        return datos;
    }

    private HashMap CargarFinal(HashMap datos) {
        List<Documento> listacom = (List<Documento>)datos.get("listacompletadoc");
        int total = listacom.size();
        int ini = total-grupos;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicialdoc", Integer.toString(ini));
        datos = ObtenerGrupoDocs(datos);
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

    private HashMap ObtenerCatalogos(HashMap datos) {
        //obtener los tipos de documentos
        TipoDocumentoDao tddao = new TipoDocumentoDao();
        List<TipoDocumento> tipos = tddao.obtenerListaActivosYOtros();
        //quitar los tipos que el empleado ya tenga registrados
        List<TipoDocumento> tiposdisp = new ArrayList<TipoDocumento>();
        
        if (datos.get("accion").toString().equals("editar")){
            //agrega el tipo del documento seleccionado si no es OTRO
            datos.put("banotro", "1");
            Documento doc = (Documento)datos.get("documento");
            if (doc.getTipodoc().getEstatus()!=2){
                tiposdisp.add(doc.getTipodoc());
                datos.put("banotro", "0");
            } else {
                datos.put("desccorta", doc.getDescri_corta());
                datos.put("desclarga", doc.getDescri_larga());
            }
            datos.put("tipodoc", doc.getTipodoc());
            datos.put("categoria", doc.getTipodoc().getCategoria());
            datos.put("docSel", doc.getImagen());
        }
        
        List<Documento> docs = (List<Documento>)datos.get("listacompletadoc");
        for (int i=0; i < tipos.size(); i++){
            TipoDocumento tipo = tipos.get(i);
            if (tipo.getEstatus()!=2){
                boolean esta = false;
                for (int d=0; d < docs.size(); d++){
                    Documento doc = docs.get(d);
                    if (doc.getTipodoc().getId()==tipo.getId()){
                        esta = true;
                        break;
                    }
                }
                if (!esta){
                    tiposdisp.add(tipo);
                }
            } else {
                tiposdisp.add(tipo);
            }
                
        }
        datos.put("tiposdocs", tiposdisp);
                
        //obtener las categorías de documentos
        CategoriaDocDao cddao = new CategoriaDocDao();
        List<CategoriaDoc> cats = cddao.obtenerListaActivos();
        List<CategoriaDoc> catsdisp = new ArrayList<CategoriaDoc>();
        //dejar las categorias que tengan tipos disponibles
        for (int c=0; c < cats.size(); c++){
            CategoriaDoc cat = cats.get(c);
            boolean esta = false;
            for (int t=0; t < tiposdisp.size(); t++){
                TipoDocumento td = tiposdisp.get(t);
                if (td.getCategoria().getId()==cat.getId()){
                    esta = true;
                    break;
                }
            }
            if (esta){
                catsdisp.add(cat);
            }
        }
        datos.put("categorias", catsdisp);
        
        return datos;
    }

    private HashMap GuardarDocumento(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        Documento doc = (Documento)datos.get("documento");
        /*CategoriaDoc catdoc = (CategoriaDoc)datos.get("categoria");
        TipoDocumento tipodoc = (TipoDocumento)datos.get("tipodoc");
        String banotro = datos.get("banotro").toString();
        String desccorta = "", desclarga = "", imagen = "";*/
        String imagen = datos.get("docSel").toString();
        /*if (banotro.equals("1")){
            desccorta = datos.get("desccorta").toString();
            desclarga = datos.get("desclarga").toString();
        }
        doc.setDescri_corta(desccorta);
        doc.setDescri_larga(desclarga);*/
        doc.setEmpleado(empl);
        doc.setEstatus(1);
        doc.setImagen(imagen);
        //doc.setTipodoc(tipodoc);
        
        DocumentoDao docdao = new DocumentoDao();
        if (datos.get("accion").toString().equals("editar"))
            docdao.actualizar(doc);
        else
            docdao.guardar(doc);
        
        datos = QuitarCatalogos(datos);
        datos = ObtenerDocumentos(datos);
        
        return datos;
    }

    private HashMap QuitarCatalogos(HashMap datos) {
        datos.remove("categorias");
        datos.remove("tiposdocs");
        datos.remove("docSel");
        datos.remove("categoria");
        datos.remove("tipodoc");
        datos.remove("banotro");
        datos.remove("desccorta");
        datos.remove("desclarga");
        datos.remove("mrequest");
        datos.remove("catact");
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

    private HashMap ObtenerDocumento(HashMap datos) {
        Documento doc = (Documento)datos.get("documento");
        DocumentoDao docdao = new DocumentoDao();
        doc = docdao.obtener(doc.getId());
        datos.put("documento", doc);
        return datos;
    }

    private HashMap RespaldaCategoria(HashMap datos) {
        Documento doc = (Documento)datos.get("documento");
        CategoriaDoc catact = new CategoriaDoc();
        catact.setId(doc.getTipodoc().getCategoria().getId());
        CategoriaDocDao cddao = new CategoriaDocDao();
        catact = cddao.obtener(catact.getId());
        datos.put("catact", catact);
        
        
        datos.put("imagenact", doc.getImagen());
        TipoDocumento td = new TipoDocumento();
        td.setId(doc.getTipodoc().getId());
        datos.put("tipoact", td);
        return datos;
    }

    private HashMap BajaDeDocumentos(HashMap datos) {
        String varios = datos.get("varios").toString();
        DocumentoDao docDao = new DocumentoDao();
        if (varios.equals("0")){
            Documento doc = (Documento) datos.get("documento");
            docDao.actualizarEstatusDeDocumento(0, doc.getId());
        } else {
            //dar de baja los documentos seleccionados
            StringTokenizer tokens=new StringTokenizer(varios, ",");
            while(tokens.hasMoreTokens()){
                docDao.actualizarEstatusDeDocumento(0, Integer.parseInt(tokens.nextToken()));
            }
        }
        datos = ObtenerDocumentos(datos);
        datos.remove("documento");
        datos.remove("varios");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        DocumentoDao docdao = new DocumentoDao();
        List<Documento> docs = docdao.obtenerInactivosDeEmpleado(empl.getNumempleado());
        datos.put("inactivos", docs);
        return datos;
    }

    private HashMap ActivarDocumento(HashMap datos) {
        Empleado empl = (Empleado)datos.get("empleado");
        Documento doc = (Documento) datos.get("documento");
        DocumentoDao docdao = new DocumentoDao();
        doc = docdao.obtener(doc.getId());
        if (doc.getTipodoc().getEstatus()!=2){
            //si el tipo de doc ya está activo y no es OTRO mandar error
            List<Documento> docs = (List<Documento>)datos.get("listacompletadoc");
            for (int i=0; i < docs.size(); i++){
                Documento d = docs.get(i);
                if (d.getTipodoc().getId()==doc.getTipodoc().getId()){
                    datos.put("error", "El Documento "+doc.getTipodoc().getCategoria().getDescripcion()+" - "+doc.getTipodoc().getDescripcion()+" ya está activo");
                    return datos;
                }
            }
        }
        docdao.actualizarEstatusDeDocumento(1, doc.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerDocumentos(datos);
        return datos;
    }
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
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
            datos = ObtenerEstatusDocumentacion(datos);
            
        }
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
}
