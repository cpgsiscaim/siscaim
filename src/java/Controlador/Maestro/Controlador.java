/*
 * Controlador.java
 *
 * Created on 25 de septiembre de 2010
 *
 */
package Controlador.Maestro;

import java.io.*;
import java.sql.*;
import java.net.*;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import javax.naming.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Controlador extends HttpServlet
{

    public void init    (ServletConfig config) throws ServletException {
          super.init(config);
        
          try{
                  Context init = new InitialContext();
                  Context ctx = (Context) init.lookup("java:comp/env");                 
          }catch(NamingException e){
                  throw new ServletException("no se recibi� el contexto ", e);
          }
    }
    
    /**
     * @J2EE_METHOD  --  destroy
     * Called by the servlet container to indicate to a servlet that the servlet is being
     * taken out of service.
     * @roseuid 448864880037
     */
    public void destroy    ()  
    { 

    }
    
    /**
     * Processes requests para los metodos POST y GET.
     * 
     * @param request servlet request
     * @param response servlet response
     * @J2EE_METHOD  --  processRequest
     * @roseuid 448864880040
     */
    protected void processRequest (HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
          HttpSession sesion = request.getSession();
        Map actionMap = (Map) sesion.getAttribute("actionMap");
        if(actionMap == null)
        {
            actionMap = new HashMap();
            sesion.setAttribute("actionMap", actionMap);
        }
        
        //Se verifica que el pool de conexiones existe en la sesi�n.  En caso de no existir
        //se toma el pool creado en el metodo init para subirlo a la sesi�n.
        
        
        ServletContext contexto = getServletContext();
        try
        {
           //Obtiene el estado y el evento de la informacion de la ruta
            
            String pathInfo = request.getPathInfo();
            if (pathInfo == null)
                throw new ServletException ("Estado interno invalido - no hay informacion de ruta");
            
            //Carga el objeto accion (action) que gestiona
            // el estado y el evento
            
            Action action = (Action) actionMap.get(pathInfo);
            
            if (action == null)
            {
                //Es la primera vez que el servlet ve esta accion
                //Obtiene el nombre dek estado y el evento
                // de pathInfo (Informacion de la ruta)
                
                StringTokenizer st = new StringTokenizer(pathInfo, "/");
                
                if (st.countTokens()!=2)
                        throw new ServletException ("Estado interno invalido - no hay informacion de ruta ["
                                +pathInfo+"]");
                String estado = st.nextToken();
                String evento = st.nextToken();
                
                // Forma el nombre de la clase a partir del estado y del evento
                
                String className = "Controladores.Auxiliares."
                        + estado + evento + "Control";
                
                //Carga la clase y crea la instancia
                
                try
                {
                    Class actionClass = Class.forName(className);
                    action = (Action) actionClass.newInstance();                                       
                }
                catch (ClassNotFoundException e)
                {
                    /*className = "mx.uabjo.escolares.presentacion.Controlador."
                            + estado + evento + "Action";
                    try
                    {
                         Class actionClass = Class.forName(className);
                         action = (Action) actionClass.newInstance();                                       
                     }
                     catch (ClassNotFoundException e2)
                     {*/
                            throw new ServletException ("No se pudo cargar la clase " 
                                  + className + ": " + e.getMessage());                    
                     /*}
                     catch (InstantiationException e2)
                     {
                            throw new ServletException ("No se pudo crear un ejemplar de " 
                            + className + ": " + e.getMessage());          
                     }
                     catch (IllegalAccessException e2)
                     {
                          throw new ServletException (className + ": " + e.getMessage());          
                     }*/
                    
                }
                catch (InstantiationException e)
                {
                    throw new ServletException ("No se pudo crear un ejemplar de " 
                            + className + ": " + e.getMessage());          
                }
                catch (IllegalAccessException e)
                {
                    throw new ServletException (className + ": " + e.getMessage());          
                }                
                
                //Guarda en memoria cach� el ejemplar en una plan de accion
                actionMap.put(pathInfo,  action);                
            }
            
            
            //Ejecuta la accion. La accion deberia ejecuta a RequestDispatcher.forward()
            //cuando termine.
            
            action.setRequest(request);
            action.setResponse(response);
            action.setApplication(contexto);
            //action.setModel(modelo);
            action.run();
        }
        catch (ServletException e)
        {
            //Usa la pagina JSP de error para todos los errores de servlet(javax.servlet.jsp.jspException)
            request.setAttribute("excepcion", e);
            
            RequestDispatcher dispatcher = 
                contexto.getRequestDispatcher("/Utilerias/PaginaError.jsp");
            
            if (response.isCommitted())
                dispatcher.include(request, response);
            else
                try{
                dispatcher.forward(request,response);
                }catch(NullPointerException n){
                    sesion.invalidate();
                }
                
        }                          
    }
    
    /**
     * metodo GET
     * 
     * @param request servlet request
     * @param response servlet response
     * @J2EE_METHOD  --  doGet
     * Called by the server (via the service method) to allow a servlet to handle a GET request.
     * The servlet container must write the headers before committing the response, because
     * in HTTP the headers must be sent before the response body. The GET method should
     * be safe and idempotent. If the request is incorrectly formatted, doGet returns an
     * HTTP 'Bad Request' message.
     * @roseuid 4488648800AF
     */
    protected void doGet    (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
          processRequest(request, response);
    }
    
    /**
     * metodo POST
     * 
     * @param request servlet request
     * @param response servlet response
     * @J2EE_METHOD  --  doPost
     * Called by the server (via the service method) to allow a servlet to handle a POST
     * request. The HTTP POST method allows the client to send data of unlimited length
     * to the Web server a single time and is useful when posting information such as credit
     * card numbers. If the HTTP POST request is incorrectly formatted, doPost returns
     * an HTTP 'Bad Request' message.
     * @roseuid 448864880127
     */
    protected void doPost    (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
          processRequest(request, response);
    }
    
    /**
     * Returns a short description of the servlet.
     * 
     * @J2EE_METHOD  --  getServletInfo
     * Returns information about the servlet, such as author, version, and copyright. By
     * default, this method returns an empty string. Override this method to have it return
     * a meaningful value.
     * @roseuid 4488648801A0
     */
    public java.lang.String getServletInfo    ()  
    {
        return "";
    
    }
}