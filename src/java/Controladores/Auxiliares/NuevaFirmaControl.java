/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import javax.imageio.ImageIO;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;
import javazoom.upload.MultipartFormDataRequest;
import javazoom.upload.UploadBean;

public class NuevaFirmaControl extends Action{
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
        
        String rutaLogo = application.getRealPath("/Imagenes/Personal/Firmas");
        UploadBean upbean = new UploadBean();

        try{
            MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
            datos.put("firma", mrequest.getParameter("firmaNueva"));
            datos.put("paso", "1");
            upbean.setFolderstore(rutaLogo);
            upbean.setOverwrite(true);
            upbean.store(mrequest,"firmaFile");
            
            //reducir la foto
            this.reducirFoto(application.getRealPath("/Imagenes/Personal/Firmas/"+mrequest.getParameter("firmaNueva")));

            sesion.setPaginaSiguiente(mrequest.getParameter("paginaSig"));

        }catch(Exception e){
        }
        
        
        sesion.setDatos(datos);
        
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
    
    private void reducirFoto(String foto)
    {
        int width = 300, height = 350;
        BufferedImage bsrc = null;
        try {
            bsrc = ImageIO.read(new File(foto));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        BufferedImage bdest = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bdest.createGraphics();
        AffineTransform at = AffineTransform.getScaleInstance((double)width/bsrc.getWidth(), (double)height/bsrc.getHeight());
        g.drawRenderedImage(bsrc,at);
        try {
            ImageIO.write(bdest,"JPG",new File(foto));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    
    
}
