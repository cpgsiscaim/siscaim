<%-- 
    Document   : confirmar
    Created on : 17-may-2012, 22:30:53
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.lang.String, java.util.HashMap" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%
HashMap datosS = (HashMap) sesion.getDatos();
HashMap confirmar = (HashMap) datosS.get("datosConfirmar");
String mensaje = (String)confirmar.get("mensaje");
String controlSi = (String)confirmar.get("controlSi");
String controlNo = (String)confirmar.get("controlNo");
String vistaSi = (String)confirmar.get("vistaSi");
String vistaNo = (String)confirmar.get("vistaNo");
String pasoSi = (String)confirmar.get("pasoSi");
String pasoNo = (String)confirmar.get("pasoNo");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <title></title>
    </head>
    <body bgcolor="peachpuff">
        <form id="frmConfirmar" name="frmConfirmar" action="" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <br><br><br>
            <table width="100%">
                <tr>
                    <td width="100%" colspan="2">
                        <div class="error" align="center">
                            <%=mensaje%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="100%" colspan="2">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="right">
                        <div align="right">
                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                <tr>
                                    <td style="padding-right:0px" title ="Aceptar">
                                        <a href="javascript: SiClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/si.png);width:150px;height:30px;display:block;"><br/></a>
                                    </td>
                                </tr>
                            </table>                        
                        </div>
                    </td>
                    <td width="50%" align="left">
                        <div align="left">
                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                <tr>
                                    <td style="padding-right:0px" title ="Aceptar">
                                        <a href="javascript: NoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/no.png);width:150px;height:30px;display:block;"><br/></a>
                                    </td>
                                </tr>
                            </table>                        
                        </div>
                    </td>
                </tr>
            </table>
        </form>
    </body>
    <script language="javascript">        
        function SiClick(){
            var frm = document.getElementById('frmConfirmar');
            frm.action = '<%=CONTROLLER%>/<%=controlSi%>';
            alert(frm.action);
            var paginaSig = document.getElementById('paginaSig');
            paginaSig.value = '<%=vistaSi%>';
            var pasoSig = document.getElementById('pasoSig');
            pasoSig.value = '<%=pasoSi%>';
            frm.submit();
        }
        
        function NoClick(){
            var frm = document.getElementById('frmConfirmar');
            frm.action = '<%=CONTROLLER%>/<%=controlNo%>';
            var paginaSig = document.getElementById('paginaSig');
            paginaSig.value = '<%=vistaNo%>';
            var pasoSig = document.getElementById('pasoSig');
            pasoSig.value = '<%=pasoNo%>';
            frm.submit();
        }
    </script>
</html>
