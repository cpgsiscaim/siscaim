<%-- 
    Document   : nuevo peryded
    Created on : Jun 21, 2012, 9:17:03 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Catalogos.PeryDed, Modelo.Entidades.Catalogos.TipoCambio, Modelo.Entidades.Catalogos.TipoCambioPyD"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo Tipo de Cambio";
    PeryDed pyd = (PeryDed)datosS.get("perded");
    TipoCambioPyD tcpyd = new TipoCambioPyD();
    TipoCambio tcsel = new TipoCambio();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Tipo de Cambio";        
        tcpyd = (TipoCambioPyD) datosS.get("tcpyd");
        tcsel = tcpyd.getTipocambio();
    }
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
                <td width="100%">
                    <div class="titulo" align="center">
                        <%=titulo%> de <%=pyd.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoTcpyd" name="frmNuevoTcpyd" action="<%=CONTROLLER%>/Gestionar/TiposCambiosPyD" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Catalogos/PerYDed.png" align="center" width="280" height="200">
                                    </td>
                                    <td width="70%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Tipo de Cambio:</span><br>
                                                    <select id="tipocambio" name="tipocambio" class="combo" style="width: 300px">
                                                        <option value="">Elija el Tipo de Cambio...</option>
                                                        <%
                                                        if (datosS.get("accion").toString().equals("editar")){
                                                        %>
                                                        <option value="<%=tcsel.getId()%>" selected>
                                                            <%=tcsel.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        List<TipoCambio> tiposc = (List<TipoCambio>)datosS.get("tiposc");
                                                        for (int i=0; i < tiposc.size(); i++){
                                                            TipoCambio tc = tiposc.get(i);
                                                        %>
                                                        <option value="<%=tc.getId()%>" <%if (tcsel.getId()==tc.getId()){%>selected<%}%>>
                                                            <%=tc.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr> 
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="20%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
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
                <%
                }
                %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoTcpyd');
                frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/tiposcambiospyd.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoTcpyd');
                    frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/tiposcambiospyd.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '4';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '2';
                <%
                    }
                %>
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                var tipoc = document.getElementById('tipocambio');                
                
                if (tipoc.value == ''){
                    Mensaje('El campo Tipo de Cambio está vacío');
                    tipoc.focus();
                    return false;
                }
                
                return true;
            }
        
        </script>
    </body>
</html>