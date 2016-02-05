<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
    HashMap datosS = sesion.getDatos();
    Sucursal matriz;
    if (datosS.get("matrizTemp")==null)
        matriz = (Sucursal)datosS.get("matriz");
    else
        matriz = (Sucursal)datosS.get("matrizTemp");
    
    String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
    <!-- Jquery UI -->
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-custom.css" />
        <script src="/siscaim/Estilos/jqui/jquery-1.9.1.js"></script>
        <script src="/siscaim/Estilos/jqui/jquery-ui.js"></script>
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/tooltip.css" />
        <script>
        //TOOLTIP
        $(function() {
        $( document ).tooltip({
            position: {
            my: "center bottom-20",
            at: "center top",
            using: function( position, feedback ) {
                $( this ).css( position );
                $( "<div>" )
                .addClass( "arrow" )
                .addClass( feedback.vertical )
                .addClass( feedback.horizontal )
                .appendTo( this );
            }
            }
        });
        });
        
        //DIALOGO MENSAJE
        $(function() {
        $( "#dialog-message" ).dialog({
            modal: true,
            autoOpen: false,
            width:500,
            height:200,            
            show: {
                effect: "blind",
                duration: 500
            },
            hide: {
                effect: "explode",
                duration: 500
            },            
            buttons: {
            "Aceptar": function() {
                $( this ).dialog( "close" );
            }
            }
        });
        });
                
        //TABS
        $(function() {
            $( "#tabs" ).tabs();
            //inicializar los tabs
            <%switch (Integer.parseInt(pestaña)){
                case 1:%>$( "#tabs" ).tabs({ active: 0 });<%break;
                case 2:%>$( "#tabs" ).tabs({ active: 1 });<%break;
                case 3:%>$( "#tabs" ).tabs({ active: 2 });<%break;
                case 4:%>$( "#tabs" ).tabs({ active: 3 });<%break;
            }%>
        });
                
        //BOTONES
        $(function() {
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
        });
        </script>
    <!-- Jquery UI -->
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
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Empresa/Configuracion04.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        CONFIGURAR EMPRESA
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <!--enctype="multipart/form-data"-->
        <!--<input name="foto" class="cajita"  type="file" id="foto" onChange="document.formAlu.firma.disabled = false" accept="images/*.jpg" >-->
        <form id="frmConfigurarEmpr" name="frmConfigurarEmpr" action="<%=CONTROLLER%>/Configurar/Empresa" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%" align="center">
                            <tr>
                                <td width="100%" valign="top" align="center">
                                    <div align="left">
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Datos Generales</a></li>
                                                <li><a href="#tabs-2">Medios</a></li>
                                                <li><a href="#tabs-3">Contactos</a></li>
                                                <li><a href="#tabs-4">Logotipo</a></li>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestdatosgenempr.jsp" %>
                                            </div>
                                            <div id="tabs-2">
                                                <%@include file="pestmediosempr.jsp" %>
                                            </div>
                                            <div id="tabs-3">
                                                <%@include file="pestcontactosempr.jsp" %>
                                            </div>
                                            <div id="tabs-4">
                                                <%@include file="pestlogoempr.jsp" %>
                                            </div>
                                        </div>                                        
                                        
                                        
                                        <%--<div class="cajamenu2">
                                            <ul id="pest">
                                                <%
                                                
                                                %>
                                                <li><a id="pest1" href="javascript: ClickPestana(1,4)" class="<%if (pestaña.equals("1")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Datos Generales</span></a>
                                                </li>
                                                <li><a id="pest2" href="javascript: ClickPestana(2,4)" class="<%if (pestaña.equals("2")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Medios</span></a>
                                                </li>
                                                <li><a id="pest3" href="javascript: ClickPestana(3,4)" class="<%if (pestaña.equals("3")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Contactos</span></a>
                                                </li>
                                                <li><a id="pest4" href="javascript: ClickPestana(4,4)" class="<%if (pestaña.equals("4")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Logotipo</span></a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div id="cajahoja2">
                                            <div style="height: 20px"></div>
                                            <div id="pest1cont" style="display: <%if (pestaña.equals("1")){%>''<%}else{%>none<%}%>" align="center">
                                                <%@include file="pestdatosgenempr.jsp" %>
                                            </div>
                                            <div id="pest2cont" style="display: <%if (pestaña.equals("2")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestmediosempr.jsp" %>
                                            </div>                                
                                            <div id="pest3cont" style="display: <%if (pestaña.equals("3")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestcontactosempr.jsp" %>
                                            </div>
                                            <div id="pest4cont" style="display: <%if (pestaña.equals("4")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestlogoempr.jsp" %>
                                            </div>
                                        </div><!--cajahoja2-->--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <br><br>
                        <table width="100%">
                            <tr>
                                <td width="80%" align="right">
                                    <a id="btnGuardar" href="javascript: GuardarClick()"
                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
                                        Guardar
                                    </a>
                                    <%--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                        <tr>
                                            <td style="padding-right:0px" title ="Guardar">
                                                <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                            </td>
                                        </tr>
                                    </table>--%>
                                </td>
                                <td width="20%">
                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                        background: indianred 50% bottom repeat-x;" title="Cancelar">
                                        Cancelar
                                    </a>
                                    <%--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                        <tr>
                                            <td style="padding-right:0px" title ="Cancelar">
                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                            </td>
                                        </tr>
                                    </table>--%>
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
                    var pagina = document.getElementById('paginaSig');
                    pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
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