<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.Aguinaldo, Modelo.Entidades.DetalleNomina"%>
<%@page import="Modelo.Entidades.Plaza, java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
Nomina nom = (Nomina)datosS.get("nominaagui");
DetalleNomina det = (DetalleNomina)datosS.get("detnomedit");
Aguinaldo agui = (Aguinaldo)datosS.get("aguinaldo");
//Quincena quinactiva = (Quincena)datosS.get("quinactiva");
NumberFormat formato = new DecimalFormat("#,##0.00");
NumberFormat format4 = new DecimalFormat("#,##0.0000");
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
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
        </div>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Catalogos/Nomina.jpg" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        DETALLE DE N&Oacute;MINA DE AGUINALDOS
                    </div>
                    <div class="subtitulo" align="left">
                        <%=nom.getAnio()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%=nom.getSucursal().getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        EDITAR AGUINALDO<br>
                        <%=det.getPlaza().getEmpleado().getPersona().getNombreCompletoPorApellidos()%>
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
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnCancelar" href="javascript: CancelarClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Editar Aguinaldo">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                            </td>
                                            <td width="10%" align="left">
                                            </td>
                                            <td width="15%" align="left">
                                            </td>
                                            <td width="15%" align="left">
                                            </td>
                                            <td width="10%" align="left">
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnGuardar" href="javascript: GuardarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar cambios">
                                                    Guardar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <!--listado-->
                                    <table width="50%" align="center">
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Días trabajados:</span>
                                            </td>
                                            <td width="80%" align="left">
                                                <input id="diastrab" name="diastrab" class="text" type="number" value="<%=agui.getDiastrabajadosbrutos()%>"
                                                       onkeypress="return ValidaNums(event)" maxlength="3" min="1" max="365" onblur="CalculaDiasNetos()"
                                                       style="text-align: right"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Faltas:</span>
                                            </td>
                                            <td width="80%" align="left">
                                                <input id="faltas" name="faltas" class="text" type="number" value="<%=agui.getFaltas()%>"
                                                       onkeypress="return ValidaNums(event)" maxlength="3" min="1" max="365" onblur="CalculaDiasNetos()"
                                                       style="text-align: right"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Días trabajados netos:</span>
                                            </td>
                                            <td width="80%" align="left">
                                                <input id="diasnetos" name="diasnetos" class="text" type="number" value="<%=(agui.getDiastrabajadosbrutos()-agui.getFaltas())%>"
                                                       style="text-align: right" readonly/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Días de Aguinaldo:</span>
                                            </td>
                                            <td width="80%" align="left">
                                                <input id="diasagui" name="diasagui" class="text" type="number" style="text-align: right"
                                                       value="<%=format4.format(agui.getDiasaguinaldo())%>" readonly/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Sueldo diario:</span>
                                            </td>
                                            <td width="80%" align="left">
                                                <input id="sueldodia" name="sueldodia" class="text" type="text" value="<%=formato.format(agui.getSueldodiario())%>"
                                                       onkeypress="return ValidaCantidad2(event, this.value)" maxlength="10" onblur="CalculaMontoAguinaldo()"
                                                       style="text-align: right"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Monto Aguinaldo:</span>
                                            </td>
                                            <td width="80%" align="left">
                                                <input id="montoaguinaldo" name="montoaguinaldo" class="text" type="text" style="text-align: right"
                                                       value="<%=formato.format(agui.getMontoaguinaldo())%>" readonly/>
                                            </td>
                                        </tr>
                                    </table>
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
            
            function CalculaDiasNetos(){
                var dt = document.getElementById('diastrab');
                var fal = document.getElementById('faltas');
                var dn = document.getElementById('diasnetos');
                dn.value = '';
                if (dt.value == ''){
                    MostrarMensaje('No ha indicado los días trabajados');
                    return;
                }
                var ndt = parseInt(dt.value);
                if (isNaN(ndt)){
                    MostrarMensaje('El valor de los días trabajados no es válido');
                    return;
                }
                
                if (fal.value == ''){
                    MostrarMensaje('No ha indicado las faltas');
                    return;
                }
                var nfal = parseInt(fal.value);
                if (isNaN(nfal)){
                    MostrarMensaje('El valor de las faltas no es válido');
                    return;
                }
                
                var ndn = ndt - nfal;
                dn.value = ndn;
                CalculaDiasAguinaldo();
            }
            
            function CalculaDiasAguinaldo(){
                var dn = document.getElementById('diasnetos');
                var da = document.getElementById('diasagui');
                da.value = '';
                if (dn.value != ''){
                    var ndn = parseInt(dn.value);
                    var nda = (ndn*15)/365;
                    da.value = formato_numero(nda,4,'.',',');
                }
                CalculaMontoAguinaldo();
            }
            
            function CalculaMontoAguinaldo(){
                var da = document.getElementById('diasagui');
                var sd = document.getElementById('sueldodia');
                var monto = document.getElementById('montoaguinaldo');
                monto.value = '';
                if (da.value!=''){
                    if (sd.value==''){
                        MostrarMensaje('No ha ingresado el sueldo diario');
                        return;
                    }
                    
                    var fsd = parseFloat(sd.value);
                    if (isNaN(fsd)){
                        MostrarMensaje('El valor del sueldo diario no es válido');
                        return;
                    }
                    
                    var fda = parseFloat(da.value.replace(','));
                    var fma = fda * fsd;
                    monto.value = formato_numero(fma,0,'.',',')+'.00';
                }
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/detallenominaagui.jsp';
                paso.value = '91';
                frm.submit();                
            }
            
            function ValidaRequeridos(){
                var dn = document.getElementById('diasnetos');
                var da = document.getElementById('diasagui');
                var monto = document.getElementById('montoaguinaldo');
                
                if (dn.value==''){
                    MostrarMensaje('Los días netos están vacíos');
                    return false;
                }
                if (da.value==''){
                    MostrarMensaje('Los días de aguinaldo están vacíos');
                    return false;
                }

                if (monto.value==''){
                    MostrarMensaje('El monto del aguinaldo está vacío');
                    return false;
                }
                
                return true;
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmGestionarNom');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Nomina/Nomina/Aguinaldos/detallenominaagui.jsp';
                    paso.value = '28';
                    frm.submit();
                }
            }
            
        </script>
    </body>
</html>
