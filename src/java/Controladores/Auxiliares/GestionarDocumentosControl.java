/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Catalogos.CategoriaDoc;
import Modelo.Entidades.Catalogos.TipoDocumento;
import Modelo.Entidades.Documento;
import Modelo.Entidades.Empleado;
import Modelos.DocumentoMod;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

/**
 *
 * @author usuario
 */
public class GestionarDocumentosControl extends Action{
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
        //obtener parámetros
        this.asignaParametros();
        sesion.setDatos(datos);
        
        //instanciar modelo y método de operación
        DocumentoMod movMod = new DocumentoMod();
        sesion = movMod.GestionarDocumentos(sesion);
        if (paso.equals("8")){
            //imprimir
            datos = sesion.getDatos();
            byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            //response.sendRedirect(application.getRealPath("/Utilerias/imprimeReporte.jsp"));
            ServletOutputStream oustrm;
            try
            {
                oustrm = response.getOutputStream();
                oustrm.write(bytes, 0, bytes.length);
                oustrm.flush();
                oustrm.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
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
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig")!=null?request.getParameter("pasoSig"):"0";
        String paginaSig = "";
        HashMap param = new HashMap();
        Documento doc = new Documento();
        switch (Integer.parseInt(paso)){
            case 0:
                //paso inicial: obtener la vista de los parametros
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case 1: case 6: case 50: case 51: case 52: case 53: case 97: case 98: case 99:
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 3: case 5: case 7:
                //editar documento(3) || baja de documentos(5) || activar documento(7)
                doc.setId(Integer.parseInt(request.getParameter("idDoc")));
                datos.put("documento", doc);
                datos.put("varios", request.getParameter("varios"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 8:
                //imprimir los docs seleccionados
                datos.put("reporte", application.getRealPath("WEB-INF/Reportes/Nomina/Personal/documentosemple.jasper"));
                //parametros
                param = new HashMap();
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                param.put("RUTAIMGS", application.getRealPath("/Imagenes/Personal/Documentos"));
                Empleado empl = (Empleado)datos.get("empleado");
                param.put("EMPLEADO", new Integer(empl.getNumempleado()));
                param.put("DOCS", request.getParameter("dato1"));
                datos.put("parametros", param);
                break;
        }
        datos.put("paso", paso);
    }

    private void CargaDocumento() {
        Documento doc = new Documento();
        doc.setTipodoc(new TipoDocumento());
        doc.getTipodoc().setCategoria(new CategoriaDoc());
        if (datos.get("accion").toString().equals("editar")){
            doc = (Documento)datos.get("documento");
        }
        
        doc.getTipodoc().getCategoria().setId(Integer.parseInt(request.getParameter("categoria")));
        doc.getTipodoc().setId(Integer.parseInt(request.getParameter("tipodoc")));
        doc.setDescri_corta(request.getParameter("descripcorta")!=null?request.getParameter("descripcorta"):"");
        doc.setDescri_larga(request.getParameter("descriplarga")!=null?request.getParameter("descriplarga"):"");
        //doc.setImagen(request.getParameter("docNuevo"));
        
        datos.put("documento", doc);

    }
    
}
