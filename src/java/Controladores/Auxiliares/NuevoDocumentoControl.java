/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Daos.Catalogos.CategoriaDocDao;
import Modelo.Daos.Catalogos.TipoDocumentoDao;
import Modelo.Entidades.Catalogos.CategoriaDoc;
import Modelo.Entidades.Catalogos.TipoDocumento;
import Modelo.Entidades.Documento;
import Modelo.Entidades.Empleado;
import Modelos.DocumentoMod;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import javazoom.upload.MultipartFormDataRequest;
import javazoom.upload.UploadBean;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author usuario
 */
public class NuevoDocumentoControl extends Action{
    private Sesion sesion = new Sesion();
    private HashMap datos = new HashMap();
    private String paso = "0";

    @Override
    public void run() throws ServletException, IOException {
        //validar usuario logueado
        HttpSession sesionHttp = request.getSession(true);
        
        //validar si la sesion es valida
        sesion = (Sesion) sesionHttp.getAttribute("sesion");
        if (sesion==null || sesion.getUsuario()==null)
            throw new ServletException ("No existe una sesión válida");
        
        datos = sesion.getDatos();
        Empleado empl = (Empleado)datos.get("empleado");
        //String rutaDoc = application.getRealPath("/Imagenes/Personal/Documentos/"+empl.getNumempleado());
        String rutaDoc = application.getRealPath("/Imagenes/Personal/Documentos");
        String rutaTemp = application.getRealPath("/Imagenes/Personal/Documentos/Temp");
        UploadBean upbean = new UploadBean();
        TipoDocumentoDao tddao = new TipoDocumentoDao();

        try{
            MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
            paso = mrequest.getParameter("pasoSig")!=null?mrequest.getParameter("pasoSig"):"0";
            //datos.put("docSel", mrequest.getParameter("docNuevo"));
            int idcat = Integer.parseInt(!mrequest.getParameter("categoria").equals("")?mrequest.getParameter("categoria"):"0");
            CategoriaDocDao cddao = new CategoriaDocDao();
            CategoriaDoc cat = cddao.obtener(idcat);
            datos.put("categoria", cat);
            int idtipod = Integer.parseInt(mrequest.getParameter("tipodoc"));
            TipoDocumento tipod = tddao.obtener(idtipod);
            datos.put("tipodoc", tipod);
            String banotro = mrequest.getParameter("banotro");
            datos.put("banotro", banotro);
            if (banotro.equals("1")){
                datos.put("desccorta", mrequest.getParameter("descripcorta"));
                datos.put("desclarga", mrequest.getParameter("descriplarga"));
            }
            datos.put("paso", paso);
            sesion.setDatos(datos);
            sesion.setPaginaSiguiente(mrequest.getParameter("paginaSig"));
            if (paso.equals("2")){
                File f = new File(rutaTemp);
                if (!f.exists())
                    f.mkdirs();
                upbean.setFolderstore(rutaTemp);
                upbean.setOverwrite(true);
                upbean.store(mrequest,"docFile");
                
                String docnvo = mrequest.getParameter("docNuevo");
                File orig = new File(rutaTemp+"/"+docnvo);
                File dest = new File(rutaTemp+"/doctemp.jpg");
                if (dest.exists())
                    dest.delete();
                FileUtils.moveFile(orig, dest);
                
                
                datos.put("docSel", dest.getName());
                datos.put("mrequest", mrequest);
            } else if (paso.equals("4")){
                MultipartFormDataRequest mreq = (MultipartFormDataRequest)datos.get("mrequest");
                if (mreq != null){
                    /*rutaDoc += "\\"+cat.getDescripcion();
                    File f = new File(rutaDoc);
                    if (!f.exists())
                        f.mkdirs();
                    upbean.setFolderstore(rutaDoc);
                    upbean.setOverwrite(true);
                    upbean.store(mreq,"docFile");*/
                    CargaDocumento();
                    Documento doc = (Documento)datos.get("documento");
                    String ardes = empl.getNumempleado()+"_"+cat.getId()+"_"+tipod.getId();
                    File dest = new File(rutaDoc+"/"+ardes+".jpg");
                    if (doc.getTipodoc().getEstatus()==2){
                        int i=1;
                        while (dest.exists()){
                            dest = new File(rutaDoc+"/"+ardes+"_"+i+".jpg");
                            i++;
                        }
                    }
                    File orig = new File(rutaTemp+"/doctemp.jpg");
                    if (dest.exists())
                        dest.delete();
                    FileUtils.moveFile(orig, dest);
                    
                    datos.put("docSel", dest.getName());
                    datos.remove("mrequest");
                } else {
                    //mrequest = new MultipartFormDataRequest(request);
                    CargaDocumento();
                    Documento doc = (Documento)datos.get("documento");
                    CategoriaDoc catact = (CategoriaDoc)datos.get("catact");
                    TipoDocumento tdact = (TipoDocumento)datos.get("tipoact");
                    String imgact = datos.get("imagenact").toString();
                    if (doc.getTipodoc().getCategoria().getId()!=catact.getId()
                            || doc.getTipodoc().getId()!=tdact.getId()){
                        //mover la imagen actual a la carpeta correspondiente
                        //rutaDoc += "\\"+cat.getDescripcion();
                        doc.setTipodoc(tddao.obtener(doc.getTipodoc().getId()));
                        String ardes = empl.getNumempleado()+"_"+cat.getId()+"_"+tipod.getId();
                        File dest = new File(rutaDoc+"/"+ardes+".jpg");
                        if (doc.getTipodoc().getEstatus()==2){
                            int i=1;
                            while (dest.exists()){
                                dest = new File(rutaDoc+"/"+ardes+"_"+i+".jpg");
                                i++;
                            }
                        }
                        File orig = new File(rutaDoc+"/"+imgact);
                        if (dest.exists())
                            dest.delete();
                        FileUtils.moveFile(orig, dest);
                        datos.put("docSel", dest.getName());
                    }
                }
                //guardar el doc en la base de datos
                sesion.setDatos(datos);
                DocumentoMod movMod = new DocumentoMod();
                sesion = movMod.GestionarDocumentos(sesion);
            }

        }catch(Exception e){
            String excep = e.getMessage();
        }
        
        
        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);
        
        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+sesion.getPaginaSiguiente());
        
        rd.forward(request, response);        
    }

    @Override
    public void asignaParametros() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    private void CargaDocumento() {
        Documento doc = new Documento();
        doc.setTipodoc(new TipoDocumento());
        doc.getTipodoc().setCategoria(new CategoriaDoc());
        if (datos.get("accion").toString().equals("editar")){
            doc = (Documento)datos.get("documento");
        }
        
        //doc.getTipodoc().getCategoria().setId(Integer.parseInt(mrequest.getParameter("categoria")));
        //doc.getTipodoc().setId(Integer.parseInt(mrequest.getParameter("tipodoc")));
        doc.setTipodoc((TipoDocumento)datos.get("tipodoc"));
        doc.setDescri_corta(datos.get("desccorta")!=null?datos.get("desccorta").toString():"");
        doc.setDescri_larga(datos.get("desclarga")!=null?datos.get("desclarga").toString():"");
        //doc.setImagen(request.getParameter("docNuevo"));
        
        datos.put("documento", doc);

    }
    
}
