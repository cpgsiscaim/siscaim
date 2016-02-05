<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Catalogos.Banco"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Banco> listado = (List<Banco>)datosS.get("inactivos");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/bancos.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR BANCOS
                    </div>
                    <div class="subtitulo" align="left">
                        INACTIVOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarBan" name="frmGestionarBan" action="<%=CONTROLLER%>/Gestionar/Bancos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idBan" name="idBan" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <div id="acciones">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnActivar a{display:block;color:transparent;} #btnActivar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnActivar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Activar">
                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    </div>
                                    <!--listado-->
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <table class="tablaLista" width="40%" align="center">
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No hay Bancos inactivos
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    <%
                                    } else {
                                    %>
                                        <table class="tablaLista" width="40%" align="center">
                                            <thead>
                                                <tr>
                                                    <td align="center" width="100%" colspan="3">
                                                        <span>Banco</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                            for (int i=0; i < listado.size(); i++){
                                                Banco ban = listado.get(i);
                                            %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioBan" name="radioBan" type="radio" value="<%=ban.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="95%">
                                                        <span class="etiqueta"><%=ban.getNombre()%></span>
                                                    </td>
                                                </tr>
                                            <%
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                    <%  
                                    }//if listado=0
                                    %>
                                    <!--fin listado-->
                                </td><!--fin del contenido-->
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
        <script language="javascript">
            function CargaPagina(){
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%}%>
            }
            
            function Activa(fila){
                var idBan = document.getElementById('idBan');
                var activar = document.getElementById('btnActivar');
                activar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarBan.radioBan.checked = true;
                    idBan.value = document.frmGestionarBan.radioBan.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarBan.radioBan[fila];
                    radio.checked = true;
                    idBan.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancos.jsp';
                paso.value = '98';
                frm.submit();                
            }
            
            function ActivarClick(){
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancosinactivos.jsp';
                paso.value = '6';
                frm.submit();                
            }
            
        </script>
    </body>
</html>
