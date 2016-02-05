<%-- 
    Document   : calcularSaldo
    Created on : 27/08/2013, 10:05:47 AM
    Author     : germain
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
  HashMap datosS = sesion.getDatos();
%>
<html>
  <head>    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Consulta de saldos</title>
    <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
    <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
  </head>
  <body onload="CargaPagina()">
    <table width="100%">
      <tr>
        <td width="100%" class="tablaMenu">
          <div align="left">
              <%@include file="/Generales/IniciarSesion/menu.jsp" %>
          </div>
        </td>
      </tr>
    </table>
    <table width="100%">
        <tr>
            <td width="10%">
              <img src="/siscaim/Imagenes/Empresa/Configuracion01.png" width="80">
            </td>  
            <td width="90%">
                <div class="titulo" align="left">
                    Calcular saldos
                </div>
            </td>
        </tr>
    </table>
    <hr>
    
  </body>
</html>
