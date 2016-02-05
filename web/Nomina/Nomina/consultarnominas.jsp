<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.text.NumberFormat"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.Catalogos.Quincena, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Nomina> listado = (List<Nomina>)datosS.get("nominashis");
List<Integer> anioshis = (List<Integer>)datosS.get("anioshis");
List<Quincena> quinhis = (List<Quincena>)datosS.get("quinhis");
List<HashMap> totales = (List<HashMap>)datosS.get("totalesnomhis");
int aniohissel = Integer.parseInt(datosS.get("aniohissel").toString());
Quincena quinhissel = (Quincena)datosS.get("quinhissel");
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
            $( "#btnSalariosPag" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnLayout" ).button({
                icons: {
                    primary: "ui-icon-print"
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
                        CONSULTAR N&Oacute;MINAS HIST&Oacute;RICAS
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
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="10%" align="left">
                                                <a id="btnCancelar" href="javascript: CancelarClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Cancelar">
                                                    Cancelar
                                                </a>
                                                <!--<style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="10%" align="right">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir">
                                                    Imprimir
                                                </a>
                                                <!--<style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="10%" align="right">
                                                <div id="chkimprxls" style="display: none">
                                                    <input id="xls" name="xls" type="checkbox">
                                                    <span class="etiqueta">Imprimir en Excel</span>
                                                </div>
                                            </td>
                                            <td width="25%" align="center">
                                                <a id="btnSalariosPag" href="javascript: SalariosPagadosClick()"
                                                   style="width: 250px; font-weight: bold; color: #0B610B; display: none" title="Reporte de Salarios Pagados">
                                                    Reporte de Salarios Pagados
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnLayout" href="javascript: LayoutClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Layout de Empleados">
                                                    Layout
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <select id="aniosel" name="aniosel" class="combo" style="width: 200px"
                                                        onchange="ObtenerQuincenas()">
                                                <% for (int i=0; i < anioshis.size(); i++){
                                                    Integer aniohis = anioshis.get(i);
                                                %>
                                                    <option value="<%=aniohis.toString()%>" <%if (aniohis.intValue()==aniohissel){%> selected <%}%>>
                                                        <%=aniohis.toString()%>
                                                    </option>
                                                <%}%>
                                                </select>
                                            </td>
                                            <td width="15%" align="left">
                                                <select id="quinsel" name="quinsel" class="combo" style="width: 200px"
                                                        onchange="ObtenerNominas()">
                                                <% for (int i=0; i < quinhis.size(); i++){
                                                    Quincena quinh = quinhis.get(i);
                                                %>
                                                    <option value="<%=quinh.getId()%>" <%if (quinh.getId()==quinhissel.getId()){%> selected <%}%>>
                                                        (<%=quinh.getId()%>) <%=quinh.getMes()%> - <%=quinh.getNumero()%>
                                                    </option>
                                                <%}%>
                                                </select>
                                            </td>                                            
                                        </tr>
                                    </table>
                                    <hr>
                                    <!--listado-->
                                    <table class="tablaLista" width="70%" align="center">
                                        <%if (listado.size()==0){%>
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No hay Nóminas registradas en el año y quincena seleccionados
                                                    </span>
                                                </td>
                                            </tr>
                                        <%} else {%>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="60%" colspan="2">
                                                        <span>Sucursal</span>
                                                    </td>
                                                    <td align="center" width="40%">
                                                        <span>Total</span>
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
                                                        <td align="center" width="55%">
                                                            <span class="etiqueta"><%=nom.getSucursal().getDatosfis().getRazonsocial()%></span>
                                                        </td>
                                                        <td align="right" width="40%">
                                                            <span class="etiqueta"><%=formato.format(Float.parseFloat(tots.get("totalnomina").toString()))%></span>
                                                        </td>
                                                    </tr>
                                                <%}%>
                                            </tbody>
                                            <tfoot>
                                                <%
                                                HashMap totsgen = (HashMap)datosS.get("totalesgenhis");
                                                %>
                                                <tr>
                                                    <td width="60%" colspan="2" align="right">
                                                        <span>Total</span>
                                                    </td>
                                                    <td align="right" width="40%">
                                                        <span><%=formato.format(Float.parseFloat(totsgen.get("totnomgen").toString()))%></span>
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
                var idNom = document.getElementById('idNom');
                var btnimpr = document.getElementById('btnImprimir');
                btnimpr.style.display = '';
                var chkimpr = document.getElementById('chkimprxls');
                chkimpr.style.display = '';
                var btnsalpag = document.getElementById('btnSalariosPag');
                btnsalpag.style.display = '';
                var btnlayout = document.getElementById('btnLayout');
                btnlayout.style.display = '';
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
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/gestionarnominas.jsp';
                paso.value = '95';
                frm.submit();                
            }
            
            
            function ImprimirClick(){
                var idNom = document.getElementById('idNom');
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGestionarNom');
                    dat1.value = idNom.value;
                    paso.value = '8';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Nominas'+'&paso=7&dato1='+idNom.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function ObtenerQuincenas(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/consultarnominas.jsp';
                paso.value = '11';
                frm.submit();                
            }
            
            function ObtenerNominas(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/consultarnominas.jsp';
                paso.value = '12';
                frm.submit();                
            }
            
            function SalariosPagadosClick(){
                var idNom = document.getElementById('idNom');
                var dat1 = document.getElementById('dato1');
                var paso = document.getElementById('pasoSig');
                var frm = document.getElementById('frmGestionarNom');
                dat1.value = idNom.value;
                paso.value = '13';
                frm.submit();
            }
            
            function LayoutClick(){
                var idNom = document.getElementById('idNom');
                var dat1 = document.getElementById('dato1');
                var paso = document.getElementById('pasoSig');
                var frm = document.getElementById('frmGestionarNom');
                dat1.value = idNom.value;
                paso.value = '14';
                frm.submit();
            }
        </script>
    </body>
</html>
