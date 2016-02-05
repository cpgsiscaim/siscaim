<%-- 
    Document   : subirPdf
    Created on : Sep 23, 2013, 12:41:48 PM
    Author     : marba
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
  HashMap datosS = sesion.getDatos();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
    </head>
    <body>
        <table>	
          <tr>
              <td><img src="/siscaim/Imagenes/Empresa/cheque.png" width="140"></td>
              <td>
                <div class="titulo" align="left">Subir comprobante digital
                </div>
              </td>
          </tr>
        </table>
        <hr>
        <form method="POST" enctype="multipart/form-data" action="<%=CONTROLLER%>/Gestionar/Uploadfile">
            <h2>Por favor, seleccione el fichero a cargar</h2>
            <br><input type="file" name="fichero">
            <br><br>
            <input type="submit" value="Subir PDF">
        </form>
            <hr>
            <h5>Recuerda que el documento debe estar en formato PDF y no superar los 10 Mb</h5>
    </body>
</html>
