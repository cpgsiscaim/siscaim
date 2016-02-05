<%-- 
    Document   : nuevo tipo incidencia
    Created on : Jun 21, 2012, 9:17:03 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Catalogos.TipoIncidencia"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo ";    
    TipoIncidencia tincidencia = new TipoIncidencia();
    int calcula=0;
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar ";        
        tincidencia = (TipoIncidencia) datosS.get("editarTincidencia"); 
        calcula = tincidencia.getCalcula();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        <%=titulo%> Tipo de Incidencia
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoTincidncia" name="frmNuevoTincidncia" action="<%=CONTROLLER%>/Gestionar/Catalogos" method="post">
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
                                        <img src="/siscaim/Imagenes/Catalogos/INCIDENCIAS.jpg" align="center" width="280" height="200">
                                    </td>
                                    <td width="70%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descTincidencia" name="descTincidencia" type="text" 
                                                           style="width: 300px" onkeypress="return ValidaRazonSocial(event, this.value)" value="<%=tincidencia.getDescripcion() != null ? tincidencia.getDescripcion() : ""%>"
                                                           onblur="Mayusculas(this)" maxlength="50"/>
                                                </td>
                                            </tr> 
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Calcula:</span><br>                                                        
                                                    <select id="calcTincidencia" name="calcTincidencia" class="combo" style="width: 146px">
                                                        <%
                                                            if (calcula == 0) {
                                                        %>
                                                        <option value="0" selected>CALCULA...</option>
                                                        <option value="1">SI</option>
                                                        <option value="2" >NO</option>
                                                        <%                                }
                                                        %>
                                                        <%
                                                            if (calcula == 1) {
                                                        %>
                                                        <option value="0">CALCULA...</option>
                                                        <option value="1" selected>SI</option>
                                                        <option value="2" >NO</option>
                                                        <%                                }
                                                        %>
                                                        <%
                                                            if (calcula == 2) {
                                                        %>
                                                        <option value="0">CALCULA...</option>
                                                        <option value="1">SI</option>
                                                        <option value="2" selected>NO</option>
                                                        <%                                }
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
                var desc = document.getElementById('descTincidencia');
                desc.focus();

            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoTincidncia');
                frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/tipoincidencia.jsp';
                frm.pasoSig.value = '94';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoTincidncia');
                    frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/tipoincidencia.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '27';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '26';
                <%
                    }
                %>
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                var desc = document.getElementById('descTincidencia');                
                
                if (desc.value == ''){
                    Mensaje('El campo Descripción está vacío');
                    desc.focus();
                    return false;
                }                                
       
                var calc = document.getElementById('calcTincidencia');                
                
                if (calc.value == '0'){
                    Mensaje('Debe establecer valor de Campo CALCULA');
                    calc.focus();
                    return false;
                }                                
       
                return true;
            }
        
        </script>
    </body>
</html>