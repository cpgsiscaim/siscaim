/*
 * Action.java
 *
 * Created on 25 de septiembre de 2010
 *
 */

package Controlador.Maestro;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
//import Uabjo.Escolares.Vista.VUsuarioSesion;
//import Uabjo.Escolares.Modelo.Utilerias.UtileriasSesion;


public abstract class Action 
{
   protected HttpServletRequest request;
   protected HttpServletResponse response;
   protected ServletContext application;
   
   /**
   Creates a new instance of Action
   @roseuid 44871DF60187
    */
   public Action() 
   {
    
   }
   
   /**
   Metodo que ejecuta la accion. Las subclases 
   deberian sobreescribir este metodo y hacer que reenvie la peticion 
   al siguiente componente de la vista cuando termine de procesar
   @throws javax.servlet.ServletException
   @throws java.io.IOException
   @roseuid 44871DF60188
    */
   public abstract void run() throws javax.servlet.ServletException, java.io.IOException;
   
   /**
   Metodo que configura la peticion 
   @parametro request la peticion
   @param request
   @roseuid 44871DF60200
    */
   public void setRequest(HttpServletRequest request) 
   {
         this.request=request;
   }
   
   /**
   Metodo que configura la respuesta
   @parametro response la respuesta
   @param response
   @roseuid 44871DF6021E
    */
   public void setResponse(HttpServletResponse response) 
   {
         this.response= response;
   }
   
   /**
   Metodo que configura el contexto del servlet
   @param app
   @roseuid 44871DF6023C
    */
   public void setApplication(ServletContext app) 
   {
         this.application=app;
   }
   
   /**
    *  Este procedimiento recibe los parametros que vienen de una JSP para cada uno de los Actions   
    */
   public abstract void asignaParametros();
}