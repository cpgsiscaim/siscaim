<%-- 
    Document   : bienvenida
    Created on : 14-abr-2012, 22:59:53
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, Modelo.Entidades.Persona, Modelo.Entidades.Empleado, Modelo.Entidades.Usuario"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <title></title>
    </head>
    <body onload="CargaMenu()">
        <%--
        <table width="100%">
            <tr>
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>--%>
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
    <script>
        function CargaMenu(){
            document.frames.frmMenu.location = "/siscaim/Generales/IniciarSesion/menu.jsp";
        }
    </script>
</html>
