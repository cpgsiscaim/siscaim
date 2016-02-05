<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Almacen"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
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
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnUbicaciones" ).button({
                icons: {
                    primary: "ui-icon-tag"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-minus"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-wrench"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-plus"
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
        
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
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
                    <img src="/siscaim/Imagenes/Empresa/almacenes01.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR ALMACENES
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarAlma" name="frmGestionarAlma" action="<%=CONTROLLER%>/Gestionar/Almacenes" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idAlma" name="idAlma" type="hidden" value=""/>            
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="70%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="20%" align="left">
                                                    <a id="btnSalir" href="javascript: SalirClick()"
                                                       style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                       background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Almacenes">
                                                        Salir
                                                    </a>
                                                    <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Salir">
                                                                <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>-->                                                    
                                                </td>
                                                <td width="20%" align="left">
                                                    <a id="btnInactivos" href="javascript: VerInactivos()"
                                                       style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Almacenes dados de baja">
                                                        Ver Inactivos
                                                    </a>
                                                    <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ver Inactivos">
                                                                <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>-->
                                                </td>
                                                <td width="40%">
                                                    <table id="borrarEdit" style="display: none;">
                                                        <tr>
                                                            <td width="33%" align="right">
                                                                <a id="btnUbicaciones" href="javascript: UbicacionesClick()"
                                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Ubicaciones del almacén seleccionado">
                                                                    Ubicaciones
                                                                </a>
                                                                <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Ubicaciones">
                                                                            <a href="javascript: UbicacionesClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/ubicaciones.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>-->                                                    
                                                            </td>
                                                            <td width="33%" align="right">
                                                                <a id="btnBaja" href="javascript: BajaAlmaClick()"
                                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja el Almacén Seleccionado">
                                                                    Baja
                                                                </a>
                                                                <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Baja">
                                                                            <a href="javascript: BajaAlmaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>-->
                                                            </td>
                                                            <td width="34%" align="right">
                                                                <a id="btnEditar" href="javascript: EditarAlmaClick()"
                                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar el Almacén Seleccionado">
                                                                    Editar
                                                                </a>
                                                                <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Editar">
                                                                            <a href="javascript: EditarAlmaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>-->
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="20%" align="right">
                                                    <a id="btnNuevo" href="javascript: NuevoAlmaClick()"
                                                       style="width: 150px; font-weight: bold; color: #0B610B;" title="Agregar Nuevo Almacén">
                                                        Nuevo
                                                    </a>
                                                    <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Nueva">
                                                                <a href="javascript: NuevoAlmaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>-->
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                        <table class="tablaLista" width="70%" align="center">
                                        <%
                                        List<Almacen> listado = (List<Almacen>)datosS.get("listado");
                                        if (listado.size()==0){
                                        %>
                                            <tr>
                                                <td colspan="4" align="center">
                                                    <span class="etiquetaB">
                                                        No hay almacenes registradas
                                                    </span>
                                                </td>
                                            </tr>
                                        <%
                                        } else {
                                        %>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="60%" colspan="2">
                                                        <span>Almacén</span>
                                                    </td>
                                                    <td align="center" width="40%">
                                                        <span>Sucursal</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%    
                                                for (int i=0; i < listado.size(); i++){
                                                    Almacen alma = listado.get(i);
                                            %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="10%">
                                                            <input id="radioAlma" name="radioAlma" type="radio" value="<%=alma.getId()%>"/>
                                                        </td>
                                                        <td align="left" width="50%">
                                                            <span class="etiqueta"><%=alma.getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="40%">
                                                            <span class="etiqueta"><%=alma.getSucursal().getDatosfis().getRazonsocial()%></span>
                                                        </td>
                                                    </tr>
                                            <%
                                                }
                                            %>
                                            </tbody>
                                        <%    
                                        }
                                        %>
                                        </table>
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
            
            function Confirmar(mensaje){
                var mens = document.getElementById('confirm');
                mens.textContent = mensaje;
                $( "#dialog-confirm" ).dialog( "open" );
            }
                        
            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
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
                HttpSession sesionHttp = request.getSession();
                if (sesion.isError())
                    sesion.setError(false);
                if (sesion.isExito())
                    sesion.setExito(false);
                sesionHttp.setAttribute("sesion", sesion);                
                %>
            }
            
            function Activa(fila){
                var idAlma = document.getElementById('idAlma');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarAlma.radioAlma.checked = true;
                    idAlma.value = document.frmGestionarAlma.radioAlma.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarAlma.radioAlma[fila];
                    radio.checked = true;
                    idAlma.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoAlmaClick(){
                Espera();
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/nuevoalmacen.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarAlmaClick(){
                Espera();
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/nuevoalmacen.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/gestionaralmacenes.jsp';
                paso.value = '5';
                frm.submit();
            }
            
            function BajaAlmaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro en dar de baja el Almacén seleccionado?');
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/almacenesinactivos.jsp';
                paso.value = '6';
                frm.submit();                
            }
            
            function UbicacionesClick(){
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/Ubicaciones/gestionarubicaciones.jsp';
                paso.value = '8';
                frm.submit();                
            }
        </script>
    </body>
</html>