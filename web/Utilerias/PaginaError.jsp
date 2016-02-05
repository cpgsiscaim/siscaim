<%-- 
    Document   : PaginaError
    Created on : 16-abr-2012, 1:31:33
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="javax.servlet.ServletException"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <title></title>
    </head>
    <%
    ServletException excep = (ServletException)request.getAttribute("excepcion");
    %>
    <body bgcolor="peachpuff">
        <div align="center" class="error">
            <%=excep.toString()%>
        </div>
    </body>
</html>
