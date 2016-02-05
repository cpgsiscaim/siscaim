<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nueva Sucursal";
    String imagen = "sucursales02.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Sucursal";
        imagen = "editarSucursal01.png";
    }
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
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
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
                    <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR SUCURSALES - <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaSuc" name="frmNuevaSuc" action="<%=CONTROLLER%>/Gestionar/Sucursales" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Datos Generales</a></li>
                                                <li><a href="#tabs-2">Medios</a></li>
                                                <li><a href="#tabs-3">Contactos</a></li>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestdatosgensuc.jsp" %>
                                            </div>
                                            <div id="tabs-2">
                                                <%@include file="pestmediossuc.jsp" %>
                                            </div>
                                            <div id="tabs-3">
                                                <%@include file="pestcontactossuc.jsp" %>
                                            </div>
                                        </div>                                        
                                        
                                        
                                        <%--<div class="cajamenu2">
                                            <ul id="pest">
                                                <%
                                                %>
                                                <li><a id="pest1" href="javascript: ClickPestana(1,3)" class="<%if (pestaña.equals("1")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Datos Generales</span></a>
                                                </li>
                                                <li><a id="pest2" href="javascript: ClickPestana(2,3)" class="<%if (pestaña.equals("2")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Medios</span></a>
                                                </li>
                                                <li><a id="pest3" href="javascript: ClickPestana(3,3)" class="<%if (pestaña.equals("3")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Contactos</span></a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div id="cajahoja2">
                                            <div style="height: 20px"></div>
                                            <div id="pest1cont" style="display: <%if (pestaña.equals("1")){%>''<%}else{%>none<%}%>" align="center">
                                                <%@include file="pestdatosgensuc.jsp" %>
                                            </div>
                                            <div id="pest2cont" style="display: <%if (pestaña.equals("2")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestmediossuc.jsp" %>
                                            </div>                                
                                            <div id="pest3cont" style="display: <%if (pestaña.equals("3")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestcontactossuc.jsp" %>
                                            </div>
                                        </div><!--cajahoja2-->--%>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
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
                var nomSuc = document.getElementById('nombreSuc');
                nomSuc.focus();

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
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevaSuc');
                frm.paginaSig.value = '/Empresa/GestionarSucursales/gestionarsucursales.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaSuc');
                    frm.paginaSig.value = '/Empresa/GestionarSucursales/gestionarsucursales.jsp';
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
                if (ValidaDatosGenerales())
                    if (ValidaMedios())
                        if (ValidaContactos())
                            return true;

                return false;
            }
        
            function ValidaDatosGenerales(){
                var nombreSuc = document.getElementById('nombreSuc');
                if (nombreSuc.value == ''){
                    Mensaje('El campo Nombre de la Sucursal está vacío');
                    ClickPestana(1,3);
                    nombreSuc.focus();
                    return false;
                }
                
                var rfcSuc = document.getElementById('rfcSuc');
                if (rfcSuc.value == ''){
                    Mensaje('El campo RFC de la Sucursal está vacío');
                    ClickPestana(1,3);
                    rfcSuc.focus();
                    return false;
                }
        
                var calleSuc = document.getElementById('calleSuc');
                if (calleSuc.value == ''){
                    Mensaje('El campo Calle y Número de la Sucursal está vacío');
                    ClickPestana(1,3);
                    calleSuc.focus();
                    return false;
                }
                
                var colSuc = document.getElementById('coloniaSuc');
                if (colSuc.value == ''){
                    Mensaje('El campo Colonia de la Sucursal está vacío');
                    ClickPestana(1,3);
                    colSuc.focus();
                    return false;
                }
                
                var edoSuc = document.getElementById('estadoSuc');
                if (edoSuc.value == '0'){
                    Mensaje('El campo Estado de la Sucursal no ha sido establecido');
                    ClickPestana(1,3);
                    edoSuc.focus();
                    return false;
                }
                
                var pobSuc = document.getElementById('poblacionSuc');
                if (pobSuc.value == '0'){
                    Mensaje('El campo Población de la Sucursal no ha sido establecido');
                    ClickPestana(1,3);
                    pobSuc.focus();
                    return false;
                }
                
                var nombreRep = document.getElementById('nombreRepr');
                if (nombreRep.value == ''){
                    Mensaje('El campo Nombre del Representante de la Sucursal está vacío');
                    ClickPestana(1,3);
                    nombreRep.focus();
                    return false;
                }
                
                var paternoRep = document.getElementById('paternoRepr');
                if (paternoRep.value == ''){
                    Mensaje('El campo Ap. Paterno del Representante de la Sucursal está vacío');
                    ClickPestana(1,3);
                    paternoRep.focus();
                    return false;
                }
                
                var maternoRep = document.getElementById('maternoRepr');
                if (maternoRep.value == ''){
                    Mensaje('El campo Ap. Materno del Representante de la Sucursal está vacío');
                    ClickPestana(1,3);
                    maternoRep.focus();
                    return false;
                }
                
                return true;
            }
            
            function ValidaMedios(){
                var medios = document.getElementById('mediosSuc');
                if (medios.length==0){
                    Mensaje('Debe especificar al menos un Medio de la Sucursal');
                    ClickPestana(2,3);
                    medios.focus();
                    return false;
                }
                
                return true;
            }

            function ValidaContactos(){
                var cont = document.getElementById('contactosSuc');
                if (cont.length==0){
                    Mensaje('Debe especificar al menos un Contacto de la Sucursal');
                    ClickPestana(3,3);
                    cont.focus();
                    return false;
                }
                
                return true;
            }
        </script>
    </body>
</html>