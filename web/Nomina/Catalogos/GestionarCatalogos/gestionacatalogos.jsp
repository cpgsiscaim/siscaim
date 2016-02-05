<%-- 
    Document   : gestionacatalogos
    Created on : Jun 14, 2012, 9:57:09 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
    HashMap datosS = sesion.getDatos();

/*       Sucursal matriz;
    if (datosS.get("matrizTemp")==null)
        matriz = (Sucursal)datosS.get("matriz");
    else
        matriz = (Sucursal)datosS.get("matrizTemp");
 */ 
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
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Catalogos Nomina
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <!--enctype="multipart/form-data"-->
        <!--<input name="foto" class="cajita"  type="file" id="foto" onChange="document.formAlu.firma.disabled = false" accept="images/*.jpg" >-->
        <form id="frmGesCatalogo" name="frmGesCatalogo" action="<%=CONTROLLER%>/Gestionar/Catalogos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="30%" align="center" valign="top">
                                    <img src="/siscaim/Imagenes/Personal/configuracion.jpg" align="center" width="300" height="250">
                                </td>
                                <td width="70%" valign="top">
                                    <div align="left">
                                        <div class="cajamenu2">
                                            <ul id="pest">
                                                <%
                                                String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
                                                %>
                                                <li><a id="pest1" href="javascript: ClickPestana(1,5)" class="<%if (pestaña.equals("1")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Periodos de Pago</span></a>
                                                </li>
                                                <li><a id="pest2" href="javascript: ClickPestana(2,5)" class="<%if (pestaña.equals("2")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Puestos</span></a>
                                                </li>
                                                <li><a id="pest3" href="javascript: ClickPestana(3,5)" class="<%if (pestaña.equals("3")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Percep. y Deduc.</span></a>
                                                </li>
                                                <li><a id="pest4" href="javascript: ClickPestana(4,5)" class="<%if (pestaña.equals("4")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Tipos de Nomina</span></a>
                                                </li>
                                                <li><a id="pest5" href="javascript: ClickPestana(5,5)" class="<%if (pestaña.equals("5")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Tipos de Incidencias</span></a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div id="cajahoja2">
                                            <div style="height: 20px"></div>
                                            <div id="pest1cont" style="display: <%if (pestaña.equals("1")){%>''<%}else{%>none<%}%>" align="center">
                                                <%@include file="pestppago.jsp" %>
                                            </div>
                                            <div id="pest2cont" style="display: <%if (pestaña.equals("2")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestpuestos.jsp" %>
                                            </div>                                
                                            <div id="pest3cont" style="display: <%if (pestaña.equals("3")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestperyded.jsp" %>
                                            </div>
                                            <div id="pest4cont" style="display: <%if (pestaña.equals("4")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pesttiponomina.jsp" %>
                                            </div>
                                                  <div id="pest5cont" style="display: <%if (pestaña.equals("5")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pesttipoinc.jsp" %>
                                            </div>
                                      
                                        </div><!--cajahoja2-->
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <br><br>
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
                    CancelarClick();
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
                var nomEmpr = document.getElementById('nombreEmpr');
                nomEmpr.focus();
            }
            
            function PonerInactivo(total){
                for (i=1; i<=total; i++){
                    var pest = document.getElementById('pest'+i);
                    if (pest.className=='activo'){
                        pest.className='inactivo';
                        var cont = document.getElementById('pest'+i+'cont');
                        cont.style.display = 'none';
                    }
                }
            }
        
            function ClickPestana(numpest, total){
                PonerInactivo(total);                
                var pest = document.getElementById('pest'+numpest);
                pest.className = 'activo';
                var cont = document.getElementById('pest'+numpest+'cont');
                cont.style.display = '';
                if (numpest==1){
                    var nomEmpr = document.getElementById('nombreEmpr');
                    nomEmpr.focus();
                }
                    
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmConfigurarEmpr');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                //frm.action = '<%=CONTROLLER%>/Redirecciona/Pagina';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmConfigurarEmpr');
                    var paso = document.getElementById('pasoSig');
                    paso.value = '2';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                return true;
            }
        </script>
    </body>
</html>