<%-- 
    Document   : mensaje
    Created on : 14-abr-2012, 22:30:53
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.lang.String, javax.servlet.http.HttpSession" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%
String mensaje = request.getParameter("mensaje")!=null?new String(request.getParameter("mensaje").getBytes("ISO-8859-1"), "UTF-8"):"";

HttpSession sesionHttp = request.getSession();
if (sesion.isError())
    sesion.setError(false);
if (sesion.isExito())
    sesion.setExito(false);

sesionHttp.setAttribute("sesion", sesion);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <title></title>
    </head>
    <body bgcolor="peachpuff">
            <br><br><br>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="error" align="center">
                            <%=mensaje%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <input id="pagina" name="pagina" type="hidden" value=""/>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <div align="center">
                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                <tr>
                                    <td style="padding-right:0px" title ="Aceptar">
                                        <a href="javascript: AceptarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aceptar.png);width:150px;height:30px;display:block;"><br/></a>
                                    </td>
                                </tr>
                            </table>                        
                        </div>
                    </td>
                </tr>
            </table>
    </body>
    <script language="javascript">
        function AceptarClick(){
            window.close();
        }
    </script>
</html>
