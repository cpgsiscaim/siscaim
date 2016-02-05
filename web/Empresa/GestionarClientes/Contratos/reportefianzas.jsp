<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.Sucursal"%>
<%@page import="java.lang.String, javax.servlet.http.HttpSession" %>

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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaIni" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechaFin" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnMostrar" ).button({
                icons: {
                    primary: "ui-icon-zoomin"
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
                    <img src="/siscaim/Imagenes/Empresa/contratosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        REPORTE DE FIANZAS VENCIDAS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCon" name="frmGestionarCon" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table id="acciones1" width="100%">
                                        <tr>
                                            <td width="20%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Contratos">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="30%" align="center">
                                                <span class="etiqueta">Fecha Inicial:</span>
                                                <input id="fechaIni" name="fechaIni" type="text" class="text" readonly
                                                       title="Ingrese la fecha inicial" style="width: 150px;" />
                                            </td>
                                            <td width="30%" align="center">
                                                <span class="etiqueta">Fecha Final:</span>
                                                <input id="fechaFin" name="fechaFin" type="text" class="text" readonly
                                                       title="Ingrese la fecha final" style="width: 150px;" />
                                            </td>
                                            <td width="20%" align="right">
                                                <a id="btnMostrar" href="javascript: MostrarClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar">
                                                    Mostrar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                </td>
                            </tr>
                        </table>
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
                <%}%>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '93';
                frm.submit();                
            }
            
            function MostrarClick(){
                var fini = document.getElementById('fechaIni');
                var ffin = document.getElementById('fechaFin');
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Contratos'+'&paso=24&dato1='+fini.value+'&dato2='+ffin.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
            }
        </script>
    </body>
</html>