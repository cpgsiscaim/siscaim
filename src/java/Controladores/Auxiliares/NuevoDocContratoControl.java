/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Daos.ContratoDao;
import Modelo.Daos.UtilDao;
import Modelo.Entidades.Contrato;
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
 * @author TEMOC
 */
public class NuevoDocContratoControl extends Action{
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
        //String rutaDoc = application.getRealPath("/Imagenes/Personal/Documentos/"+empl.getNumempleado());
        String rutaDoc = application.getRealPath("/Imagenes/Contratos");
        Contrato con = (Contrato)datos.get("editarContrato");
        String name = Integer.toString(con.getId());
        UploadBean upbean = new UploadBean();

        try{
            MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
            paso = mrequest.getParameter("pasoSig")!=null?mrequest.getParameter("pasoSig"):"0";
            sesion.setPaginaSiguiente(mrequest.getParameter("paginaSig"));
            if (paso.equals("1")){
                File f = new File(rutaDoc);
                if (!f.exists())
                    f.mkdirs();
                upbean.setFolderstore(rutaDoc);
                upbean.setOverwrite(true);
                upbean.store(mrequest,"uploadfile");
                
                String docnvo = mrequest.getParameter("archivoCargo");
                File orig = new File(rutaDoc+"/"+docnvo);
                File dest = new File(rutaDoc+"/"+name+".pdf");
                if (dest.exists())
                    dest.delete();
                FileUtils.moveFile(orig, dest);
                con.setDocumento(1);
                ContratoDao condao = new ContratoDao();
                condao.actualizar(con);
                datos.put("editarContrato", con);
                //datos.put("archivoCargo", mrequest.getParameter("archivoCargo"));
                /*UtilDao utdao = new UtilDao();
                datos.put("hoy", utdao.hoy());*/
            }
            sesion.setDatos(datos);
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
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
