<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.text.NumberFormat"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Nomina> listado = (List<Nomina>)datosS.get("nominasagui");
List<HashMap> totales = (List<HashMap>)datosS.get("totalesnomagui");
int anioact = Integer.parseInt(datosS.get("anio").toString());
//int anioini = Integer.parseInt(datosS.get("anioini").toString());
int bannomact = Integer.parseInt(datosS.get("bannominaactagui").toString());
//Quincena quinactiva = (Quincena)datosS.get("quinactiva");
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
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnImprimir2" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnHistorico" ).button({
                icons: {
                    primary: "ui-icon-folder-collapsed"
		}
            });
            $( "#btnNueva" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
            $( "#btnRecalcular" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnCerrar" ).button({
                icons: {
                    primary: "ui-icon-locked"
		}
            });
            
            $( "#btnFormatosPago" ).button({
                icons: {
                    primary: "ui-icon-note"
		}
            });
            
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
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
                        GESTIONAR N&Oacute;MINAS DE AGUINALDOS
                    </div>
                    <div class="subtitulo" align="left">
                        AGUINALDOS DEL AÑO <%=anioact%>
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
            <input id="idNom" name="idNom" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="40%" align="left">
                                                <a id="btnCancelar" href="javascript: CancelarClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Nóminas de Aguinaldos">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnImprimir2" href="javascript: ImprimirClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir">
                                                    Imprimir
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <div id="chkimprxls2" style="display: none">
                                                    <input id="xls" name="xls" type="checkbox">
                                                    <span class="etiqueta">Imprimir en Excel</span>
                                                </div>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnHistorico" href="javascript: HistoricoClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Consultar Nóminas de Años anteriores">
                                                    Histórico
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnNueva" href="javascript: NuevaClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Nueva">
                                                    Nueva
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <!--acciones-->
                                    <table id="acciones" align="center" width="100%" style="display: none">
                                        <tr>
                                            <td width="15%" align="center">&nbsp;</td>
                                            <td width="10%" align="left">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir">
                                                    Imprimir
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <div id="chkimprxls">
                                                    <input id="xls" name="xls" type="checkbox">
                                                    <span class="etiqueta">Imprimir en Excel</span>
                                                </div>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnRecalcular" href="javascript: RecalcularClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Recalcular">
                                                    Recalcular
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnCerrar" href="javascript: CerrarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Cerrar">
                                                    Cerrar
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnFormatosPago" href="javascript: FormatosClick()"
                                                   style="width: 180px; font-weight: bold; color: #0B610B;" title="Generar Formatos de Pago">
                                                    Formatos de Pago
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnEditar" href="javascript: EditarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar">
                                                    Editar
                                                </a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" width="100%">
                                                <hr>
                                            </td>
                                        </tr>
                                    </table>
                                    <!--fin acciones-->
                                    <!--listado-->
                                    <table class="tablaLista" width="70%" align="center">
                                        <%if (listado.size()==0){%>
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No hay Nóminas registradas
                                                    </span>
                                                </td>
                                            </tr>
                                        <%} else {%>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="40%" colspan="2">
                                                        <span>Sucursal</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>Estatus</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>Total</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>Pagado</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>Por Pagar</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                for (int i=0; i < listado.size(); i++){
                                                    Nomina nom = listado.get(i);
                                                    HashMap tots = totales.get(i);
                                                %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="5%">
                                                            <input id="radioNom" name="radioNom" type="radio" value="<%=nom.getId()%>"/>
                                                        </td>
                                                        <td align="center" width="35%">
                                                            <span class="etiqueta"><%=nom.getSucursal().getDatosfis().getRazonsocial()%></span>
                                                        </td>
                                                        <td align="center" width="15%">
                                                            <span class="etiqueta"><%=nom.getEstatus()==1?"ABIERTA":"CERRADA"%></span>
                                                            <input id="estatus<%=i%>" name="estatus<%=i%>" type="hidden" value="<%=nom.getEstatus()%>"/>
                                                        </td>
                                                        <td align="right" width="15%">
                                                            <span class="etiqueta"><%=formato.format(Float.parseFloat(tots.get("totalnomina").toString()))%></span>
                                                        </td>
                                                        <td align="right" width="15%">
                                                            <span class="etiqueta"><%=formato.format(Float.parseFloat(tots.get("pagado").toString()))%></span>
                                                        </td>
                                                        <td align="right" width="15%">
                                                            <span class="etiqueta"><%=formato.format(Float.parseFloat(tots.get("porpagar").toString()))%></span>
                                                        </td>
                                                    </tr>
                                                <%}%>
                                            </tbody>
                                            <tfoot>
                                                <%
                                                HashMap totsgen = (HashMap)datosS.get("totalesgenagui");
                                                %>
                                                <tr>
                                                    <td width="55%" colspan="3" align="right">
                                                        <span>Totales</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span><%=formato.format(Float.parseFloat(totsgen.get("totnomgen").toString()))%></span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span><%=formato.format(Float.parseFloat(totsgen.get("totpaggen").toString()))%></span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span><%=formato.format(Float.parseFloat(totsgen.get("totporpaggen").toString()))%></span>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        <%}%>
                                    </table>
                                    <!--fin listado-->
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
            
            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
                else if (boton.value=='2')
                    EjecutarCerrar();
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
                
                if (bannomact==0){%>
                    var btnnueva = document.getElementById('btnNueva');
                    btnnueva.style.display = 'none';
                <%}%>
            }
            
            function Activa(fila){
                var idNom = document.getElementById('idNom');
                var acciones = document.getElementById('acciones');
                var estatus = document.getElementById('estatus'+fila);
                var btnimpr = document.getElementById('btnImprimir2');
                var chkimpr = document.getElementById('chkimprxls2');
                if (estatus.value == '1'){
                    acciones.style.display = '';
                    btnimpr.style.display = 'none';
                    chkimpr.style.display = 'none';
                } else {
                    acciones.style.display = 'none';
                    btnimpr.style.display = '';
                    chkimpr.style.display = '';
                }
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarNom.radioNom.checked = true;
                    idNom.value = document.frmGestionarNom.radioNom.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarNom.radioNom[fila];
                    radio.checked = true;
                    idNom.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/gestionarnominas.jsp';
                paso.value = '94';
                frm.submit();                
            }
            
            function NuevaClick(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/nuevanominaaguinaldos.jsp';
                paso.value = '16';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/detallenominaagui.jsp';
                paso.value = '18';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '6';
                frm.submit();
            }
            
            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro en dar de baja la Nómina seleccionada?');
            }
            
            function RecalcularClick(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/detallenominaagui.jsp';
                paso.value = '36';
                frm.submit();
            }
            
            function EjecutarCerrar(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/nominasaguinaldos.jsp';
                paso.value = '43';
                frm.submit();
            }
            
            function CerrarClick(){
                var boton = document.getElementById('boton');
                boton.value = '2';
                Confirmar('¿Está seguro de Cerrar la Nómina seleccionada (no podrá deshacer esta acción)?');
            }
            
            function FormatosClick(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Aguinaldos/formatospago.jsp';
                paso.value = '39';
                frm.submit();
            }
            
            function EjecutarCerrarQuin(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/gestionarnominas.jsp';
                paso.value = '6';
                frm.submit();
            }            
                    
            function CerrarQuinClick(){
                /*var boton = document.getElementById('boton');
                boton.value = '3';
                Confirmar('Esta acción cerrará todas las nóminas, ¿desea continuar?');*/
            }
            
            function ImprimirClick(){
                var idNom = document.getElementById('idNom');
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGestionarNom');
                    dat1.value = idNom.value;
                    paso.value = '38';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Nominas'+'&paso=37&dato1='+idNom.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function HistoricoClick(){
            }
            
        </script>
    </body>
</html>
