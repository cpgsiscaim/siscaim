<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Plaza, Modelo.Entidades.Catalogos.PeryDed, Modelo.Entidades.Catalogos.TipoNomina, Modelo.Entidades.Catalogos.TipoCambio"%>
<%@page import="Modelo.Entidades.Catalogos.TipoCambioPyD, Modelo.Entidades.Catalogos.Quincena, Modelo.Entidades.MovimientoExtraordinario"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "NUEVO MOVIMIENTO EXTRAORDINARIO";
    String imagen = "movextraB.png";
    Plaza plzsel = (Plaza)datosS.get("plaza");
    Quincena qact = (Quincena)datosS.get("quincenasel");
    String anioact = datosS.get("aniosel").toString();
    String importe = "", quincenas = "1", total = "", obser = "";
    PeryDed movact = new PeryDed(); TipoNomina tnomact = new TipoNomina();
    tnomact.setIdTnomina(1);
    TipoCambio tcact = new TipoCambio();
    int fijo = 0, cotiza = plzsel.getEmpleado().getCotiza(), prestacion = 0;
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR MOVIMIENTO EXTRAORDINARIO";
        imagen = "movextraC.png";
        MovimientoExtraordinario mextra = (MovimientoExtraordinario)datosS.get("movext");
        importe = Float.toString(mextra.getImporte());
        quincenas = Integer.toString(mextra.getNumero());
        total = Float.toString(mextra.getTotal());
        movact = mextra.getPerded();
        tnomact = mextra.getTiponomina();
        tcact = mextra.getTipocambio();
        obser = mextra.getObservaciones()!=null?mextra.getObservaciones():"";
        fijo = mextra.getFijo();
        cotiza = mextra.getCotiza();
        prestacion = mextra.getPrestacionimss();
    }
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
                    <img src="/siscaim/Imagenes/Nomina/MovsExtras/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS EXTRAORDINARIOS
                    </div>
                    <div class="titulo" align="left">
                        <%=titulo%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%=plzsel.getEmpleado().getPersona().getNombreCompleto()%><br>
                        <%=plzsel.getPuesto().getDescripcion()%> / <%=plzsel.getCtrabajo().getNombre()%>
                        <%=qact.getMes()%> - <%=qact.getNumero()%> / <%=anioact%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMovExtra" name="frmNuevoMovExtra" action="<%=CONTROLLER%>/Gestionar/MovExtra" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
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
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Movimiento:</span><br>
                                                    <select id="movimiento" name="movimiento" class="combo" style="width: 500px"
                                                            onchange="CargaTiposCambios(this.value)">
                                                        <option value="">Elija el Movimiento...</option>
                                                        <%
                                                        List<PeryDed> movs = (List<PeryDed>)datosS.get("movimientos");
                                                        for (int i=0; i < movs.size(); i++){
                                                            PeryDed mov = movs.get(i);
                                                        %>
                                                        <option value="<%=mov.getIdPeryded()%>" <%if (mov.getIdPeryded()==movact.getIdPeryded()){%>selected<%}%>>
                                                            <%=mov.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Tipo de Nómina:</span><br>
                                                    <select id="tiponomina" name="tiponomina" class="combo" style="width: 300px">
                                                        <option value="">Elija el Tipo de Nómina...</option>
                                                        <%
                                                        List<TipoNomina> tnom = (List<TipoNomina>)datosS.get("tiposnomina");
                                                        for (int i=0; i < tnom.size(); i++){
                                                            TipoNomina tn = tnom.get(i);
                                                        %>
                                                        <option value="<%=tn.getIdTnomina()%>" <%if (tn.getIdTnomina()==tnomact.getIdTnomina()){%>selected<%}%>>
                                                            <%=tn.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Tipo de Cambio:</span><br>
                                                    <select id="tipocambio" name="tipocambio" class="combo" style="width: 300px">
                                                        <option value="">Elija el Tipo de Cambio...</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Importe:</span><br>
                                                    <input id="importe" name="importe" class="text" type="text" value="<%=importe%>" style="width: 150px; text-align: right"
                                                           onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onblur="CalculaTotal()"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Quincenas:</span><br>
                                                    <input id="quincenas" name="quincenas" class="text" type="text" value="<%=quincenas%>" style="width: 150px; text-align: right"
                                                           onkeypress="return ValidaNums(event)" maxlength="2" onblur="CalculaTotal()"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Total:</span><br>
                                                    <input id="total" name="total" class="text" type="text" value="<%=total%>" style="width: 150px; text-align: right"
                                                           maxlength="10" readonly/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Cotiza:</span><br>
                                                    <input id="cotiza" name="cotiza" class="text" type="hidden" value="<%=cotiza%>"/>
                                                    <input id="vcotiza" name="vcotiza" class="text" type="text" value="<%if (cotiza==0){%>NO<%}else{%>SÍ<%}%>" style="width: 150px; text-align: center"
                                                           readonly/>
                                                    <%--<select id="cotiza" name="cotiza" class="combo"
                                                            onchange="CargaDetalle()" style="width: 150px" readonly>
                                                        <option value="0" <%if (cotiza==0){%>selected<%}%>>NO</option>
                                                        <option value="1" <%if (cotiza==1){%>selected<%}%>>SI</option>
                                                    </select>--%>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <input id="chkfijo" name="chkfijo" type="checkbox" value="1" <%if (fijo==1){%>checked<%}%>>
                                                    <span class="etiqueta">Permanente</span>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <input id="chkpresta" name="chkpresta" type="checkbox" value="1" <%if (prestacion==1){%>checked<%}%>>
                                                    <span class="etiqueta">Prestaci&oacute;n IMSS</span>
                                                </td>                                                
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                </td>                                                
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Observaciones:</span><br>
                                                    <input id="observaciones" name="observaciones" class="text" type="text" value="<%=obser%>" style="width: 400px;"
                                                           maxlength="150" onblur="Mayusculas(this)"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar movimiento">
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
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
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
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                if (datosS.get("accion").toString().equals("editar")){
                %>
                    CargaTiposCambios('<%=movact.getIdPeryded()%>');
                <%
                }
                %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMovExtra');
                frm.paginaSig.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoMovExtra');
                    frm.paginaSig.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '5';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '3';
                <%
                    }
                %>
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                var mov = document.getElementById('movimiento');
                if (mov.value == ''){
                    Mensaje('El Movimiento no ha sido establecido');
                    mov.focus();
                    return false;
                }
                
                var tiponom = document.getElementById('tiponomina');
                if (tiponom.value == ''){
                    Mensaje('El Tipo de Nómina no ha sido establecido');
                    tiponom.focus();
                    return false;
                }
                                
                var tipocam = document.getElementById('tipocambio');
                if (tipocam.value == ''){
                    Mensaje('El Tipo de Cambio no ha sido establecido');
                    tipocam.focus();
                    return false;
                }
                
                var imp = document.getElementById('importe');
                if (imp.value == ''){
                    Mensaje('El Importe está vacío');
                    imp.focus();
                    return false;
                }
                
                var quin = document.getElementById('quincenas');
                if (quin.value == ''){
                    Mensaje('El campo Quincenas está vacío');
                    quin.focus();
                    return false;
                }

                return true;
            }
                        
            function CargaTiposCambios(mov){
                var tiposcambios = document.getElementById('tipocambio');
                tiposcambios.length = 0;
                tiposcambios.options[0] = new Option('Elija el Tipo de Cambio...','');
                k=1;
            <%
                List<TipoCambioPyD> tcpds = (List<TipoCambioPyD>)datosS.get("tiposcambios");
                for (int i=0; i < tcpds.size(); i++){
                    TipoCambioPyD tcpd = tcpds.get(i);
                %>
                    if ('<%=tcpd.getPerded().getIdPeryded()%>'==mov){
                        tiposcambios.options[k] = new Option('<%=tcpd.getTipocambio().getDescripcion()%>','<%=tcpd.getTipocambio().getId()%>');
                        if ('<%=tcpd.getTipocambio().getId()%>'=='<%=tcact.getId()%>')
                            tiposcambios.options[k].selected = true;
                        k++;
                    }
                <%
                }
            %>
                if (tiposcambios.length==2){
                    tiposcambios.options[1].selected = true;
                }
            }
            
            function CalculaTotal(){
                var importe = document.getElementById('importe');
                var quincenas = document.getElementById('quincenas');
                var total = document.getElementById('total');
                if (importe.value=='')
                    nImp = 0;
                else
                    nImp = parseFloat(importe.value);
                if (quincenas.value == '')
                    nQuin = 0;
                else
                    nQuin = parseInt(quincenas.value);
                nTotal = nImp * nQuin;
                total.value = nTotal;
            }
        </script>
    </body>
</html>