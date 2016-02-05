<%-- 
    Document   : nuevo peryded
    Created on : Jun 21, 2012, 9:17:03 AM
    Author     : roman

    Modificado  : Jul 29, 2015
    Autor       : Temoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Catalogos.PeryDed"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "NUEVA";    
    String imagen = "pydB.png";
    PeryDed peryded = new PeryDed();
    int GraoExe=0, PeroDed=0;
    float pdfactor = 1.0f;
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR";        
        peryded = (PeryDed) datosS.get("editarPeryDed"); 
        GraoExe = peryded.getGraoExe();
        PeroDed = peryded.getPeroDed();
        pdfactor = peryded.getFactor();
        imagen = "pydC.png";
    }
    NumberFormat formato = new DecimalFormat("#,##0.00");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
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

        //DIALOGO CONFIRMACION
        $(function() {
            $( "#dialog-confirm" ).dialog({
            resizable: false,
            width:500,
            height:200,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                $( this ).dialog( "close" );
                EjecutarProceso();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                }
            }
            });
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
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        <%=titulo%> PERCEPCI&Oacute;N / DEDUCCI&Oacute;N
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoPeryDed" name="frmNuevoPeryDed" action="<%=CONTROLLER%>/Gestionar/Catalogos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="60%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descPeryDed" name="descPeryDed" type="text" class="text"
                                                           style="width: 300px" onkeypress="return ValidaRazonSocial(event, this.value)" value="<%=peryded.getDescripcion() != null ? peryded.getDescripcion() : ""%>"
                                                           onblur="Mayusculas(this)" maxlength="50"/>
                                                </td>
                                            </tr> 
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Gra. o Exe.:</span><br>                                                        
                                                    <select id="graoexePeryDed" name="graoexePeryDed" class="combo" style="width: 146px">
                                                        <%
                                                            if (GraoExe == 0) {
                                                        %>
                                                        <option value="0" selected>GRA o EXE...</option>
                                                        <option value="1">GRA</option>
                                                        <option value="2" >EXE</option>
                                                        <%                                }
                                                        %>
                                                        <%
                                                            if (GraoExe == 1) {
                                                        %>
                                                        <option value="0">GRA o EXE...</option>
                                                        <option value="1" selected>GRA</option>
                                                        <option value="2" >EXE</option>
                                                        <%                                }
                                                        %>
                                                        <%
                                                            if (GraoExe == 2) {
                                                        %>
                                                        <option value="0">GRA o EXE...</option>
                                                        <option value="1">GRA</option>
                                                        <option value="2" selected>EXE</option>
                                                        <%                                }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>  
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Orden:</span><br>
                                                    <input id="ordenPeryDed" name="ordenPeryDed" type="text" class="text"
                                                           style="width: 300px" onkeypress="return ValidaNums(event)" value="<%=peryded.getOrden() != null ? peryded.getOrden() : "0"%>"
                                                           onblur="Mayusculas(this)" maxlength="10"/>
                                                </td>
                                            </tr> 
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Per. o Ded..:</span><br>                                                        
                                                    <select id="perodedPeryDed" name="perodedPeryDed" class="combo" style="width: 146px">
                                                        <%
                                                            if (PeroDed == 0) {
                                                        %>
                                                        <option value="0" selected>PER o DED...</option>
                                                        <option value="1">PERCEPCIÓN</option>
                                                        <option value="2" >DEDUCCIÓN</option>
                                                        <%                                }
                                                        %>
                                                        <%
                                                            if (PeroDed == 1) {
                                                        %>
                                                        <option value="0">PER o DED...</option>
                                                        <option value="1" selected>PERCEPCIÓN</option>
                                                        <option value="2" >DEDUCCIÓN</option>
                                                        <%                                }
                                                        %>
                                                        <%
                                                            if (PeroDed == 2) {
                                                        %>
                                                        <option value="0">PER o DED...</option>
                                                        <option value="1">PERCEPCIÓN</option>
                                                        <option value="2" selected>DEDUCCIÓN</option>
                                                        <%                                }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>  
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Factor:</span><br>
                                                    <input id="factor" name="factor" class="text" type="text"
                                                        style="width: 100px; text-align: right;" value="<%=formato.format(pdfactor)%>"
                                                        maxlength="10" onkeypress="return ValidaCantidad2(event, this)"
                                                        onblur="Formatea(this)"/>
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
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
            <div id="procesando" style="display: none">
                <table id="tbprocesando" align="center" width="100%">
                    <tr>
                        <td width="100%" align="center">
                            <img src="/siscaim/Imagenes/procesando02.gif" align="center" width="100" height="100">
                        </td>
                    </tr>
                    <tr>
                        <td width="100%" align="center">
                            <span class="subtitulo">
                                Espere por favor, se está realizando la acción solicitada
                            </span>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
        <script language="javascript">
            function MostrarMensaje(mensaje){
                var mens = document.getElementById('alerta');
                mens.textContent = mensaje;
                $( "#dialog-message" ).dialog( "open" );
            }

            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function Formatea(obj){
                obj.value = formato_numero(obj.value, 2, '.', ',');
            }
            
            function CargaPagina(){
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
                var desc = document.getElementById('descPeryDed');
                desc.focus();

            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoPeryDed');
                frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoPeryDed');
                    frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '21';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '20';
                <%
                    }
                %>
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var desc = document.getElementById('descPeryDed');                
                
                if (desc.value == ''){
                    desc.focus();
                    MostrarMensaje('El campo Descripción está vacío');
                    return false;
                }                
                var orden = document.getElementById('ordenPeryDed');                
                
                if (orden.value == ''){
                    orden.focus();
                    MostrarMensaje('El campo Orden está vacío');
                    return false;
                }
       
                var factor = document.getElementById('factor');                
                
                if (factor.value == ''){
                    factor.focus();
                    MostrarMensaje('El campo Factor está vacío');
                    return false;
                }
                
                var graoexe = document.getElementById('graoexePeryDed');                
                
                if (graoexe.value == '0'){
                    graoexe.focus();
                    MostrarMensaje('Debe establecer GRA. o EXE.');
                    return false;
                }
                
                var peroded = document.getElementById('perodedPeryDed');                
                
                if (peroded.value == '0'){
                    peroded.focus();
                    MostrarMensaje('Debe establecer PER. o DED.');
                    return false;
                }
       
                return true;
            }
        
        </script>
    </body>
</html>