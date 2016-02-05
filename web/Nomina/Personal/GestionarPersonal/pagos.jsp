
<%-- 
    Document   : nuevoempleado
    Created on : Jun 6, 2012, 10:37:15 PM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.Date, Modelo.Entidades.Empleado, Modelo.Entidades.DetalleNomina"%>
<%@page import="Modelo.Entidades.Nomina"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Empleado tempo = (Empleado)datosS.get("empleado");
    List<HashMap> pagos = (List<HashMap>)datosS.get("pagos");
    NumberFormat formato = new DecimalFormat("#,##0.00");
    
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
            $( "#btnRecibo" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnSalir" ).button({
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
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/cuentastelecomm.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        PAGOS DE EMPLEADO
                    </div>
                    <div class="subtitulo" align="left">
                        <%=tempo.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmPagos" name="frmPagos" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="pago" name="pago" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="70%" align="left">
                                        <a id="btnSalir" href="javascript: SalirClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Salir">
                                            Salir
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnRecibo" href="javascript: ReciboClick()"
                                            style="display: none;width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Recibo de Pago">
                                            Recibo
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnImprimir" href="javascript: ImprimirClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Lista">
                                            Imprimir
                                        </a>
                                    </td>
                                </tr>
                            </table>
                            <hr>
                            <table class="tablaLista" width="100%">
                                <%if (pagos.isEmpty()){%>
                                <tr>
                                    <td width="100%" valign="top">
                                        <span class="etiquetaB">
                                            No hay pagos registrados del empleado
                                        </span>
                                    </td>
                                </tr>
                                <%} else {%>
                                    <thead>
                                        <tr>
                                            <td width="8%" align="center" colspan="2">
                                                <span>Sucursal</span>
                                            </td>
                                            <td width="5%" align="center">
                                                <span>Año</span>
                                            </td>
                                            <td width="9%" align="center">
                                                <span>Quincena</span>
                                            </td>
                                            <td width="25%" align="center">
                                                <span>Percepciones</span>
                                            </td>
                                            <td width="25%" align="center">
                                                <span>Deducciones</span>
                                            </td>
                                            <td width="10%" align="center">
                                                <span>Neto</span>
                                            </td>
                                            <td width="8%" align="center">
                                                <span>Estatus</span>
                                            </td>
                                            <td width="8%" align="center">
                                                <span>Fecha Pago</span>
                                            </td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%for(int p=0; p < pagos.size(); p++){
                                            HashMap pg = pagos.get(p);
                                            Nomina nom = (Nomina)pg.get("nomina");
                                            List<DetalleNomina> perceps = (List<DetalleNomina>)pg.get("percepciones");
                                            List<DetalleNomina> deducs = (List<DetalleNomina>)pg.get("deducciones");
                                            String sestatus = "NO PAGADO";
                                            if (((Integer)pg.get("estatus")).intValue()==2)
                                                sestatus = "PAGADO";
                                            String fechapago = pg.get("fechapago").toString();
                                        %>
                                        <tr onclick="Activa(<%=p%>)">
                                            <td width="3%" align="center">
                                                <input id="radioPago" name="radioPago" type="radio" value="<%=nom.getId()%>"/>
                                            </td>
                                            <td width="5%" align="center">
                                                <span class="etiqueta"><%=nom.getSucursal().getDatosfis().getRazonsocial()%></span>
                                            </td>
                                            <td width="5%" align="center">
                                                <span class="etiqueta"><%=nom.getAnio()%></span>
                                            </td>
                                            <td width="9%" align="center">
                                                <span class="etiqueta"><%=nom.getQuincena()!=null?nom.getQuincena().getMes()+" - "+Integer.toString(nom.getQuincena().getNumero()):""%></span>
                                            </td>
                                            <td width="25%" align="center">
                                                <table width="100%" style="padding: 0px; border-spacing: 0px;">
                                                <%
                                                for (int dp=0; dp < perceps.size(); dp++){
                                                    DetalleNomina det = perceps.get(dp);
                                                %>
                                                    <tr>
                                                        <td width="60%" align="left" style="border-style: none;">
                                                            <span class="etiqueta"><%=det.getMovimiento().getDescripcion()%></span>
                                                        </td>
                                                        <td width="40%" align="right" style="border-style: none;">
                                                            <span class="etiqueta"><%=formato.format(det.getMonto())%></span>
                                                        </td>
                                                    </tr>
                                                <%}%>
                                                </table>
                                            </td>
                                            <td width="25%" align="center">
                                                <table width="100%" style="padding: 0px; border-spacing: 0px;">
                                                <%
                                                for (int dp=0; dp < deducs.size(); dp++){
                                                    DetalleNomina det = deducs.get(dp);
                                                    %>
                                                    <tr>
                                                        <td width="60%" align="left" style="border-style: none;">
                                                            <span class="etiqueta"><%=det.getMovimiento().getDescripcion()%></span>
                                                        </td>
                                                        <td width="40%" align="right" style="border-style: none;">
                                                            <span class="etiqueta"><%=formato.format(det.getMonto())%></span>
                                                        </td>
                                                    </tr>
                                                <%}%>
                                                </table>
                                            </td>
                                            <td width="10%" align="right">
                                                <span class="etiqueta"><%=formato.format(((Float)pg.get("neto")).floatValue())%></span>
                                            </td>
                                            <td width="8%" align="center">
                                                <span class="etiqueta"><%=sestatus%></span>
                                            </td>
                                            <td width="8%" align="center">
                                                <span class="etiqueta"><%=fechapago%></span>
                                            </td>
                                        </tr>
                                        <%}%>
                                    </tbody>
                                <%}%>
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
                <%}%>
            }
            
            function Activa(fila){
                var pago = document.getElementById('pago');
                var btnrecibo = document.getElementById('btnRecibo');
                btnrecibo.style.display = '';
                <%
                if (pagos.size()==1){
                %>
                    document.frmPagos.radioPago.checked = true;
                    pago.value = document.frmPagos.radioPago.value;
                <%
                } else {
                %>
                    var radio = document.frmPagos.radioPago[fila];
                    radio.checked = true;
                    pago.value = radio.value;
                <% } %>
            }
            
            function ReciboClick(){
                var pago = document.getElementById("pago");
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=44&dato1='+pago.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');                
            }
            
            function SalirClick(){
                Espera();
                var frm = document.getElementById('frmPagos');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.pasoSig.value = '88';
                frm.submit();
            }
                         
        </script>
    </body>
</html>