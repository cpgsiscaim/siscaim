<%-- 
    Document   : generararchivo
    Created on : 06-feb-2015, 10:33:49
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.text.NumberFormat"%>
<%@page import="Modelo.Entidades.Catalogos.Quincena, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
List<Integer> anioshis = (List<Integer>)datosS.get("anioshis");
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
            $( "#btnGenerar" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
        });

        </script>
    <!-- Jquery UI -->
    <body>
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Timbrado/timbrado01.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GENERAR ARCHIVO DE TIMBRADO DE AGUINALDOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGenerarTimbrado" name="frmGenerarTimbrado" action="<%=CONTROLLER%>/Generar/Timbrado" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="quincenas" name="quincenas" type="hidden" value=""/>
            <div id="datos">
                <table width="100%">
                    <tr>
                        <td width="50%" align="left">
                            <a id="btnSalir" href="javascript: SalirClick()"
                               style="width: 150px; font-weight: bold; color: #FFFFFF;
                               background: indianred 50% bottom repeat-x;" title="Salir">
                                Salir
                            </a>
                        </td>
                        <td width="50%" align="right">
                            <a id="btnGenerar" href="javascript: GenerarClick()"
                               style="width: 150px; font-weight: bold; color: #0B610B;" title="Generar Archivo de Timbrado">
                                Generar
                            </a>
                        </td>
                    </tr>
                </table>
                <br>
                <table width="70%" align="center">
                    <tr>
                        <td width="30%" align="right">
                            <span class="etiquetaB">Registro Patronal:</span>
                        </td>
                        <td width="70%" align="left">
                            <select id="sucursal" name="sucursal" class="combo" style="width: 250px">
                            <%
                                for (int i=0; i < sucursales.size(); i++){
                                    Sucursal suc = sucursales.get(i);
                                %>
                                <option value="<%=suc.getId()%>">
                                        <%=suc.getRegistropatronal()%>
                                    </option>
                                <%
                                }
                            %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" align="right">
                            <span class="etiquetaB">A&ntilde;o:</span>
                        </td>
                        <td width="70%" align="left">
                            <select id="aniosel" name="aniosel" class="combo" style="width: 200px">
                            <% for (int i=0; i < anioshis.size(); i++){
                                Integer aniohis = anioshis.get(i);
                            %>
                                <option value="<%=aniohis.toString()%>">
                                    <%=aniohis.toString()%>
                                </option>
                            <%}%>
                            </select>
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

            function SalirClick(){
                var frm = document.getElementById('frmGenerarTimbrado');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function GenerarClick(){
                var frm = document.getElementById('frmGenerarTimbrado');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Timbrado/aguinaldos.jsp';
                paso.value = '2';
                frm.submit();
            }
            
        </script>
    </body>
</html>
