<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Almacen, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "NUEVO ALMACÉN";
    String imagen = "almacenNvo01.png";
    Almacen alma = new Almacen();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR ALMACÉN";
        imagen = "almacenEd01.png";
        alma = (Almacen) datosS.get("editarAlma"); 
    }
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
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
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
                    <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR ALMACENES
                    </div>
                    <div class="titulo" align="left">
                        <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoAlma" name="frmNuevoAlma" action="<%=CONTROLLER%>/Gestionar/Almacenes" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="50%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Nombre:</span><br>
                                                    <input id="nombreAlma" name="nombreAlma" type="text" value="<%=alma.getDescripcion()!=null?alma.getDescripcion():""%>"
                                                           style="width: 300px" onkeypress="return ValidaRazonSocial(event, this.value)"
                                                           onblur="Mayusculas(this)" maxlength="50"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Sucursal:</span><br>
                                                    <select id="sucursal" name="sucursal" class="combo" style="width: 300px">
                                                        <option value="0">Elija la Sucursal...</option>
                                                    <%
                                                        List<Sucursal> sucs = (List<Sucursal>)datosS.get("sucursales");
                                                        for (int i=0; i < sucs.size(); i++){
                                                            Sucursal suc = sucs.get(i);
                                                    %>
                                                            <option value="<%=suc.getId()%>"
                                                                <%
                                                                if (datosS.get("accion").toString().equals("editar")){
                                                                    if (alma.getSucursal().getId()==suc.getId()){
                                                                %>
                                                                        selected
                                                                <%
                                                                    }
                                                                }
                                                                %>
                                                                    >
                                                                <%=suc.getDatosfis().getRazonsocial()%>
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
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                           style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar Nuevo Almacén">
                                            Guardar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                           style="width: 150px; font-weight: bold; color: #FFFFFF;
                                           background: indianred 50% bottom repeat-x;" title="Cancelar Nuevo Almacén">
                                            Cancelar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
            <div id="procesando" style="display: none">
            <table id="tbmensaje" align="center" width="100%">
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
                var nomAlma = document.getElementById('nombreAlma');
                nomAlma.focus();

            }

            function CancelarClick(){
                Espera();
                var frm = document.getElementById('frmNuevoAlma');
                frm.paginaSig.value = '/Empresa/GestionarAlmacenes/gestionaralmacenes.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoAlma');
                    frm.paginaSig.value = '/Empresa/GestionarAlmacenes/gestionaralmacenes.jsp';
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
                    frm.submit();
                }
                
            }
            
            function ValidaRequeridos(){
                var nombre = document.getElementById('nombreAlma');
                var suc = document.getElementById('sucursal');
                
                if (nombre.value == ''){
                    MostrarMensaje('El campo Nombre está vacío');
                    nombre.focus();
                    return false;
                }
                
                if (suc.value == '0'){
                    MostrarMensaje('Debe establecer la Sucursal');
                    suc.focus();
                    return false;
                }
                
                return true;
            }
        
        </script>
    </body>
</html>