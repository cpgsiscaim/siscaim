<%-- 
    Document   : bienvenida
    Created on : 14-abr-2012, 22:59:53
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, javax.servlet.http.HttpSession, Modelo.Entidades.Persona, Modelo.Entidades.Empleado, Modelo.Entidades.Usuario"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <title></title>
    <!-- Jquery UI -->
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-custom.css" />
        <script src="/siscaim/Estilos/jqui/jquery-1.9.1.js"></script>
        <script src="/siscaim/Estilos/jqui/jquery-ui.js"></script>
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/tooltip.css" />
        <script>
        //DIALOGO MENSAJE
        $(function() {
        $( "#dialog-message" ).dialog({
            modal: true,
            autoOpen: false,
            width:500,
            height:200,            
            show: {
                effect: "blind",
                duration: 500
            },
            hide: {
                effect: "explode",
                duration: 500
            },            
            buttons: {
            "Aceptar": function() {
                $( this ).dialog( "close" );
            }
            }
        });
        });

        </script>
    <!-- Jquery UI -->
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        
        <table width="100%">
            <tr>
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        <%
                        Usuario us = sesion.getUsuario();
                        Empleado emp = us.getEmpleado();
                        Persona persona = emp.getPersona();
                        if (persona.getSexo().equals("M"))
                        {
                        %>
                            BIENVENIDO
                        <%
                        } else {
                        %>
                            BIENVENIDA
                        <%
                        }
                        %>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100%">
                    <div class="subtitulo" align="center">
                        <%=persona.getNombreCompleto()%><br>
                    </div>
                </td>
            </tr>
        </table>
    </body>
    <script language="javascript">
        function MostrarMensaje(mensaje){
            var mens = document.getElementById('alerta');
            mens.textContent = mensaje;
            $( "#dialog-message" ).dialog( "open" );
        }
        function CargaPagina(){
            <%
            if (sesion!=null && sesion.isError()){
            %>
                MostrarMensaje('<%=sesion.getMensaje()%>')
            <%
            }
            if (sesion!=null && sesion.isExito()){
            %>
                MostrarMensaje('<%=sesion.getMensaje()%>');
                //llamar a la funcion que redirija a la pagina siguiente
            <%
            }
            HttpSession sesionHttp = request.getSession();
            if (sesion.isError())
                sesion.setError(false);
            if (sesion.isExito())
                sesion.setExito(false);
            sesionHttp.setAttribute("sesion", sesion);
            %>
        }
    </script>                                 
    
</html>
