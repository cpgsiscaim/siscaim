<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList"%>
<%@page import="Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Sucursal> sucursalesdisp = (List<Sucursal>)datosS.get("sucursalesdispagui");
int anioact = Integer.parseInt(datosS.get("anio").toString());
//Quincena quinactiva = (Quincena)datosS.get("quinactiva");
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
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
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
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Catalogos/Nomina.jpg" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR N&Oacute;MINAS DE AGUINALDOS
                    </div>
                    <div class="subtitulo" align="left">
                        NUEVA N&Oacute;MINA DE AGUINALDOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarNom" name="frmGestionarNom" action="<%=CONTROLLER%>/Gestionar/Nominas" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="40%" align="center">
                <tr>
                    <td width="100%" align="left">
                        <span class="etiquetaB">Elija la Sucursal:</span>
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <select id="sucursal" name="sucursal" class="combo" style="width: 300px">
                        <%
                            if (sucursalesdisp.size()==1){
                                Sucursal suc = sucursalesdisp.get(0);
                        %>
                                <option value="<%=suc.getId()%>">
                                    <%=suc.getDatosfis().getRazonsocial()%>
                                </option>
                        <%
                            } else {
                        %>
                                <option value="">Elija la Sucursal...</option>
                        <%
                                for (int i=0; i < sucursalesdisp.size(); i++){
                                    Sucursal suc = sucursalesdisp.get(i);
                        %>
                                    <option value="<%=suc.getId()%>">
                                        <%=suc.getDatosfis().getRazonsocial()%>
                                    </option>
                        <%
                                }//for
                            }//if
                        %>
                        </select>
                    </td>
                </tr>
            </table>
            <table width="40%" align="center">
                <tr>
                    <td width="50%" align="center">
                        <a id="btnGenerar" href="javascript: GenerarClick()"
                           style="width: 150px; font-weight: bold; color: #0B610B;" title="Generar la Nueva Nómina de Aguinaldos">
                            Generar
                        </a>
                    </td>
                    <td width="50%" align="center">
                        <a id="btnCancelar" href="javascript: CancelarClick()"
                           style="width: 150px; font-weight: bold; color: #FFFFFF;
                           background: indianred 50% bottom repeat-x;" title="Cancelar Nueva Nómina de Aguinaldos">
                            Cancelar
                        </a>
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
            }
            
            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }            
                        
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/nominasaguinaldos.jsp';
                paso.value = '93';
                frm.submit();                
            }
            
            function GenerarClick(){
                var suc = document.getElementById('sucursal');
                if (suc.value==''){
                    MostrarMensaje('Debe elegir la sucursal');
                    return;
                }
                
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/detallenominaagui.jsp';
                paso.value = '17';
                frm.submit();                
            }
            
        </script>
    </body>
</html>
