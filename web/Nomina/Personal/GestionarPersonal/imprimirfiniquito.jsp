<%-- 
    Document   : empleadosinactivos
    Created on : Jun 18, 2012, 11:44:37 AM
    Author     : roman
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- aqui poner los imports--%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, Modelo.Entidades.Persona, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal"%>
<%@page import="Modelo.Entidades.Finiquito, Modelo.Entidades.HistorialIMSS, java.text.DecimalFormat, java.text.NumberFormat, java.util.Date"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
    HashMap datosS = sesion.getDatos();
    // List<Cliente> listado = new ArrayList<Cliente>();//(List<Cliente>)datosS.get("listado");
    Sucursal sucSel = (Sucursal)datosS.get("sucursal");
    SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
    NumberFormat fnum2 = new DecimalFormat("#,##0.00");
    NumberFormat fnum4 = new DecimalFormat("#,##0.0000");
    Empleado empl = (Empleado)datosS.get("empleado");
    Finiquito fin = (Finiquito)datosS.get("finiquito");
    String sfaempr = ffecha.format(empl.getFecha());
    String sfbempr = ffecha.format(empl.getFechabaja());
    
    HistorialIMSS ulthss = (HistorialIMSS)datosS.get("ultimohistorialimss");
    String sfaimss = (ulthss!=null && ulthss.getFechaalta()!=null)?ffecha.format(ulthss.getFechaalta()):"SIN FECHA";
    String sfbimss = (ulthss!=null && ulthss.getFechabaja()!=null)?ffecha.format(ulthss.getFechabaja()):"SIN FECHA";

    int diasant = fin.getAntdias();
    Float aniosant = fin.getAntanios();
    Float sueldodia = fin.getSueldodia();
    
    String sfinivac = ffecha.format(fin.getFvacaciones());
    String sfagui = ffecha.format(fin.getFaguinaldo());
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
                    <img src="/siscaim/Imagenes/Personal/empleadosD.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        FINIQUITO DE EMPLEADO
                    </div>
                    <div class="subtitulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompleto()%>
                    </div>
                    
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmFiniquito" name="frmFiniquito" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idEmp" name="idEmp" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">                                
                <tr>
                    <td width="100%" valign="top">
                        <!--aquí poner el contenido de la jsp --> 
                        <table width="100%">
                            <tr>
                                <%-- Boton Cancelar --%>
                                <td width="50%">
                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                        background: indianred 50% bottom repeat-x;" title="Cancelar">
                                        Cancelar
                                    </a>
                                </td>
                                <td width="30%" align="right">
                                    &nbsp;
                                </td>
                                <td width="15%" align="right">
                                </td>
                                <td width="15%" align="right">
                                    <a id="btnImprimir" href="javascript: ImprimirClick()"
                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir finiquito">
                                        Imprimir
                                    </a>
                                </td>
                            </tr>
                        </table>
                        <hr>
                        <table width="60%" align="center" frame="box">
                            <tr>
                                <td width="15%">
                                    <span class="etiqueta">ALTA IMSS:</span>
                                </td>
                                <td width="35%">
                                    <input id="faimss" name="faimss" class="text" value="<%=sfaimss%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="15%">
                                    <span class="etiqueta">BAJA IMSS:</span>
                                </td>
                                <td width="35%">
                                    <input id="fbimss" name="fbimss" class="text" value="<%=sfbimss%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%">
                                    <span class="etiqueta">FECHA DE INGRESO:</span>
                                </td>
                                <td width="35%">
                                    <input id="faempr" name="faempr" class="text" value="<%=sfaempr%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="15%">
                                    <span class="etiqueta">FECHA DE SEPARACIÓN:</span>
                                </td>
                                <td width="35%">
                                    <input id="fbempr" name="fbempr" class="text" value="<%=sfbempr%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%">
                                    <span class="etiqueta">ANTIG&Uuml;EDAD EN D&Iacute;AS:</span>
                                </td>
                                <td width="35%">
                                    <input id="antdias" name="antdias" class="text" value="<%=diasant%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="15%">
                                    <span class="etiqueta">ANTIG&Uuml;EDAD EN AÑOS:</span>
                                </td>
                                <td width="35%">
                                    <input id="antanios" name="antanios" class="text" value="<%=fnum2.format(aniosant)%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="30%" colspan="2" align="right">
                                    <span class="etiqueta">SUELDO DIARIO:</span>
                                </td>
                                <td width="70%" colspan="2" align="left">
                                    <input id="sueldodia" name="sueldodia" class="text" value="<%=fnum2.format(sueldodia)%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <table width="60%" align="center" frame="box">
                            <tr>
                                <td width="20%">
                                    <span class="etiqueta">FECHA INICIAL PER&Iacute;ODO VACACIONAL:</span>
                                </td>
                                <td width="30%">
                                    <input id="finivac" name="finivac" class="text" value="<%=sfinivac%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">FECHA C&Oacute;MPUTO AGUINALDO:</span>
                                </td>
                                <td width="30%">
                                    <input id="fcomagui" name="fcomagui" class="text" value="<%=sfagui%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <table width="60%" align="center" frame="box">
                            <tr>
                                <td width="20%">
                                    <span class="etiqueta">D&Iacute;AS AGUINALDO AL AÑO:</span>
                                </td>
                                <td width="30%">
                                    <input id="diasaguianio" name="diasaguianio" class="text" value="<%=fin.getDiasaguianio()%>" style="width:150px; text-align: right"
                                          readonly/>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">PORCENTAJE DE PRIMA VACACIONAL:</span>
                                </td>
                                <td width="30%">
                                    <input id="porcprimavac" name="porcprimavac" class="text" value="<%=fnum2.format(fin.getPorcprimavac())%>" style="width:150px; text-align: right"
                                           readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%">
                                    <span class="etiqueta">D&Iacute;AS DE VACACIONES DEL PER&Iacute;ODO PENDIENTES:</span>
                                </td>
                                <td width="30%">
                                    <input id="diasvacpend" name="diasvacpend" class="text" value="<%=fin.getDiasvacpend()%>" style="width:150px; text-align: right"
                                           readonly/>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">D&Iacute;AS DE VACACIONES TOMADAS DEL PER&Iacute;ODO:</span>
                                </td>
                                <td width="30%">
                                    <input id="diasvactomadas" name="diasvactomadas" class="text" value="<%=fin.getDiasvactomadas()%>" style="width:150px; text-align: right"
                                           readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="30%" colspan="2" align="right">
                                    <span class="etiqueta">D&Iacute;AS DE VACACIONES ANTERIORES:</span>
                                </td>
                                <td width="70%" colspan="2" align="left">
                                    <input id="diasvacant" name="diasvacant" class="text" value="<%=fin.getDiasvacanteriores()%>" style="width:150px; text-align: right"
                                           readonly/>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <table width="60%" align="center" frame="box">
                            <tr>
                                <td width="33%">
                                    <span class="etiqueta">&nbsp;</span>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">D&Iacute;AS</span>
                                </td>
                                <td width="34%" align="center">
                                    <span class="etiqueta">IMPORTE</span>
                                </td>
                            </tr>
                            <tr>
                                <td width="33%" align="left">
                                    <span class="etiqueta">AGUINALDO</span>
                                </td>
                                <td width="33%" align="center">
                                    <input id="diasagui" name="diasagui" class="text" value="<%=fnum4.format(fin.getDiasagui())%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="34%" align="center">
                                    <input id="impagui" name="impagui" class="text" value="<%=fnum2.format(fin.getImpagui())%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="33%" align="left">
                                    <span class="etiqueta">VACACIONES</span>
                                </td>
                                <td width="33%" align="center">
                                    <input id="diasvac" name="diasvac" class="text" value="<%=fnum4.format(fin.getDiasvac())%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="34%" align="center">
                                    <input id="impvac" name="impvac" class="text" value="<%=fnum2.format(fin.getImpvac())%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="33%" align="left">
                                    <span class="etiqueta">PRIMA VACACIONAL</span>
                                </td>
                                <td width="33%" align="center">
                                    <input id="diaspv" name="diaspv" class="text" value="<%=fnum4.format(fin.getDiasprimavac())%>" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="34%" align="center">
                                    <input id="imppv" name="imppv" class="text" value="<%=fnum2.format(fin.getImpprimavac())%>" style="width:150px; text-align: right" readonly/>
                                </td>
                            </tr>
                            <tr>
                                <td width="33%" align="left">
                                    <span class="etiqueta">TOTALES</span>
                                </td>
                                <td width="33%" align="center">
                                    <input id="totdias" name="totdias" class="text" value="" style="width:150px; text-align: right" readonly/>
                                </td>
                                <td width="34%" align="center">
                                    <input id="totimp" name="totimp" class="text" value="" style="width:150px; text-align: right" readonly/>
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
                <%
                }
                %>
                CalculaTotales();
            }
            
            function CalculaTotales(){
                var diasagui = document.getElementById('diasagui');
                var nda = 0;
                if (diasagui.value!='')
                    nda = parseFloat(diasagui.value);
                var impagui = document.getElementById('impagui');
                var nia = 0;
                if (impagui.value!='')
                    nia = parseFloat(impagui.value.replace(',',''));
                var diasvac = document.getElementById('diasvac');
                var ndv = 0;
                if (diasvac.value!='')
                    ndv = parseFloat(diasvac.value);
                var impvac = document.getElementById('impvac');
                var niv = 0;
                if (impvac.value!='')
                    niv = parseFloat(impvac.value.replace(',',''));
                var diaspv = document.getElementById('diaspv');
                var ndpv = 0;
                if (diaspv.value!='')
                    ndpv = parseFloat(diaspv.value);
                var imppv = document.getElementById('imppv');
                var nipv = 0;
                if (imppv.value!='')
                    nipv = parseFloat(imppv.value.replace(',',''));
                var totdias = document.getElementById('totdias');
                totdias.value = '';
                var ntd = 0;
                var totimp = document.getElementById('totimp');
                totimp.value = '';
                var nti = 0;
                ntd = nda+ndv+ndpv;
                nti = nia+niv+nipv;
                totdias.value = redondear2(ntd,4);
                totimp.value = formato_numero(redondear2(nti,4),2,'.',',');
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmFiniquito');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function ImprimirClick(){
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=32',
                        '','width =800, height=600, left=0, top = 0, resizable= yes');                
            }
        </script>
    </body>
</html>
