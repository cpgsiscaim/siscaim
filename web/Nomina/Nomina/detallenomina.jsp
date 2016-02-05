<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.DetalleNomina, Modelo.Entidades.Catalogos.Quincena"%>
<%@page import="Modelo.Entidades.Plaza, java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<HashMap> listado = (List<HashMap>)datosS.get("detallenomina");
Nomina nom = (Nomina)datosS.get("nomina");
Quincena quinactiva = (Quincena)datosS.get("quinactiva");
NumberFormat formato = new DecimalFormat("#,##0.00");
int pago = Integer.parseInt(datosS.get("estatus")!=null?datosS.get("estatus").toString():"0");
int bcotiza = Integer.parseInt(datosS.get("bcotiza")!=null?datosS.get("bcotiza").toString():"-1");
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
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnInactivas" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnQuitarPago" ).button({
                icons: {
                    primary: "ui-icon-arrowthickstop-1-w"
		}
            });
            $( "#btnMovsExtras" ).button({
                icons: {
                    primary: "ui-icon-script"
		}
            });
            $( "#btnRecalcular" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnPagar" ).button({
                icons: {
                    primary: "ui-icon-star"
		}
            });
            
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-minus"
		}
            });
            $( "#btnVacas" ).button({
                icons: {
                    primary: "ui-icon-note"
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
                        DETALLE DE N&Oacute;MINA
                    </div>
                    <div class="subtitulo" align="left">
                        <%=nom.getAnio()%> - QUINCENA <%=quinactiva.getId()%> (<%=quinactiva.getMes()%> - <%=quinactiva.getNumero()%>)
                    </div>
                    <div class="subtitulo" align="left">
                        <%=nom.getSucursal().getDatosfis().getRazonsocial()%>
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
            <input id="idPlz" name="idPlz" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <input id="varios" name="varios" type="hidden" value="0"/>
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
                                            <td width="15%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Editar Nómina">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <!--<a id="btnInactivas" href="javascript: InactivasClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Inactivas">
                                                    Ver Inactivas
                                                </a>-->
                                            </td>
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
                                            <td width="15%" align="left">
                                                <span class="etiqueta">Estatus:</span>
                                                <select id="estatuspago" name="estatuspago" class="combo"
                                                        onchange="CargaDetalle()" style="width: 150px">
                                                    <option value="0" <%if (pago==0){%>selected<%}%>>NO PAGADO</option>
                                                    <option value="1" <%if (pago==1){%>selected<%}%>>PAGADO</option>
                                                </select>
                                            </td>
                                            <td width="10%" align="left">
                                                <span class="etiqueta">Cotiza:</span>
                                                <select id="cotiza" name="cotiza" class="combo"
                                                        onchange="CargaDetalle()" style="width: 150px">
                                                    <option value="-1" <%if (bcotiza==-1){%>selected<%}%>>TODOS</option>
                                                    <option value="0" <%if (bcotiza==0){%>selected<%}%>>NO</option>
                                                    <option value="1" <%if (bcotiza==1){%>selected<%}%>>SI</option>
                                                </select>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnQuitarPago" href="javascript: QuitarPagoClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Quitar Pago">
                                                    Quitar Pago
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <!--acciones-->
                                    <table id="acciones" align="center" width="100%" style="display: none">
                                        <tr>
                                            <td width="25%" align="center">&nbsp;</td>
                                            <td width="15%" align="center">
                                                <a id="btnVacas" href="javascript: VacacionesClick()"
                                                   style="width: 250px; font-weight: bold; color: #0B610B; display: none" title="Registrar Goce de Vacaciones">
                                                    Registrar goce de Vacaciones
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnMovsExtras" href="javascript: MovExtrasClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Movimientos Extraordinarios">
                                                    Movs. Extras
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnRecalcular" href="javascript: RecalcularClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Recalcular">
                                                    Recalcular
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnPagar" href="javascript: PagarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Pagar">
                                                    Pagar
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnBaja" href="javascript: BajaClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja">
                                                    Baja
                                                </a>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="7" width="100%">
                                                <hr>
                                            </td>
                                        </tr>
                                    </table>
                                    <!--fin acciones-->
                                    <!--listado-->
                                    <table class="tablaLista" width="100%" align="center">
                                        <%if (listado.size()==0){%>
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No se encontraron detalles de nómina
                                                    </span>
                                                </td>
                                            </tr>
                                        <%} else {%>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="30%" colspan="3">
                                                        <span>Empleado</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Cotiza</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>Cliente</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>Contrato</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>C.T.</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Percep</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Deduc</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Neto</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Estatus</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                for (int i=0; i < listado.size(); i++){
                                                    HashMap reg = (HashMap)listado.get(i);
                                                    Plaza plz = (Plaza)reg.get("plaza");
                                                    Integer cotiza = (Integer)reg.get("cotiza");
                                                    int vacaciones = Integer.parseInt(reg.get("vacaciones").toString());
                                                %>
                                                <tr onclick="Activa(<%=i%>)" <%if (vacaciones==1){%> bgcolor="#ACFA58" <%}%>>
                                                        <td align="center" width="5%">
                                                            <input id="chkplz<%=i%>" name="chkplz<%=i%>" type="checkbox" value="<%=plz.getId()%>">
                                                            <input id="vacas<%=i%>" name="vacas<%=i%>" type="hidden" value="<%=vacaciones%>">
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <span>
                                                                <%=plz.getEmpleado().getClave()%>
                                                            </span>
                                                        </td>
                                                        <td align="left" width="20%">
                                                            <span>
                                                                <%=plz.getEmpleado().getPersona().getNombreCompletoPorApellidos()%><br>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <%if (cotiza.equals(1)){%>SÍ<%} else {%>NO<%}%>
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <%if (plz.getCliente().getTipo()==0){%>
                                                                <%=plz.getCliente().getDatosFiscales().getRazonsocial()%>
                                                            <%} else {%>
                                                                <%=plz.getCliente().getDatosFiscales().getPersona().getNombreCompletoPorApellidos()%>
                                                            <%}%>
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <%=plz.getContrato().getContrato()%> - <%=plz.getContrato().getDescripcion()%>
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <%=plz.getCtrabajo().getNombre()%>
                                                        </td>
                                                        <td align="right" width="5%">
                                                            <span><%=formato.format(Float.parseFloat(reg.get("percepciones").toString()))%> </span>
                                                        </td>
                                                        <td align="right" width="5%">
                                                            <span><%=formato.format(Float.parseFloat(reg.get("deducciones").toString()))%></span>
                                                        </td>
                                                        <td align="right" width="5%">
                                                            <span><%=formato.format(Float.parseFloat(reg.get("neto").toString()))%></span>
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <span><%=reg.get("estatus").toString()%></span>
                                                            <input id="estatus<%=i%>" name="estatus<%=i%>" type="hidden" value="<%=reg.get("estatus").toString()%>"/>
                                                        </td>
                                                    </tr>
                                                <%}%>
                                            </tbody>
                                            
                                        <%}%>
                                    </table>
                                    <!--fin listado-->
                                    <!-- botones siguiente anterior-->
                                    <%
                                    int grupos = Integer.parseInt(datosS.get("grupos").toString());
                                    if (grupos == 1){
                                        int sigs = Integer.parseInt(datosS.get("siguientes").toString());
                                        int ants = Integer.parseInt(datosS.get("anteriores").toString());
                                    %>
                                    <hr>
                                    <table width="100%">
                                        <tr>
                                            <td width="30%">&nbsp;</td>
                                            <td width="10%" align="center">
                                                <style>#btnPrincipio a{display:block;color:transparent;} #btnPrincipio a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnPrincipio" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al principio del listado">
                                                            <a href="javascript: PrincipioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/principio.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnAnterior a{display:block;color:transparent;} #btnAnterior a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnAnterior" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Anteriores">
                                                            <a href="javascript: AnteriorClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/anterior.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnSiguiente a{display:block;color:transparent;} #btnSiguiente a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnSiguiente" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Siguientes">
                                                            <a href="javascript: SiguienteClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/siguiente.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnUltimo a{display:block;color:transparent;} #btnUltimo a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnUltimo" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al final del listado">
                                                            <a href="javascript: FinalClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/final.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="30%">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <%
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->
                                    
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
                //var idPlz = document.getElementById('idPlz');
                var acciones = document.getElementById('acciones');
                var estatus = document.getElementById('estatuspago');
                var quitarpago = document.getElementById('btnQuitarPago');
                var chk = document.getElementById('chkplz'+fila);
                var txtvac = document.getElementById('vacas'+fila);
                var btnvac = document.getElementById('btnVacas');
                chk.checked = !chk.checked;
                if (estatus.value!='1'){
                    acciones.style.display = '';
                    quitarpago.style.display = 'none';
                }else{
                    acciones.style.display = 'none';
                    quitarpago.style.display = '';
                }
                sels = 0; banvac = false;
                <%for (int i=0; i < listado.size(); i++){%>
                     var chk = document.getElementById('chkplz<%=i%>');
                     var txvc = document.getElementById('vacas<%=i%>');
                     if (chk.checked){
                         sels++;
                         if (txvc.value=='1')
                             banvac = true;
                     }
                <%}%>
                var movs = document.getElementById('btnMovsExtras');
                if (sels>1 && acciones.style.display==''){
                    movs.style.display='none';
                    btnvac.style.display='none';
                } else if (sels==1 && acciones.style.display==''){
                    movs.style.display='';
                    if (banvac && estatus.value!='1'){
                        btnvac.style.display='';
                    } else {
                        btnvac.style.display='none';
                    }
                } else if (sels==0){
                    acciones.style.display = 'none';
                    quitarpago.style.display = 'none';
                }
                <%--
                if (listado.size()==1){
                %>
                    document.frmGestionarNom.radioPlz.checked = true;
                    idPlz.value = document.frmGestionarNom.radioPlz.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarNom.radioPlz[fila];
                    radio.checked = true;
                    idPlz.value = radio.value;
                <% } --%>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/gestionarnominas.jsp';
                paso.value = '98';
                frm.submit();                
            }
            
            function MovExtrasClick(){
                CargaItemsSeleccionados();
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                paso.value = '20';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '23';
                frm.submit();
            }
            
            function BajaClick(){
                mens = '¿Está seguro en dar de baja la Plaza seleccionada?';
                sels = 0;
                <%for (int i=0; i < listado.size(); i++){%>
                     var chk = document.getElementById('chkplz<%=i%>');
                     if (chk.checked){
                         sels++;
                     }
                <%}%>
                if (sels>1){
                    mens = '¿Está seguro en dar de baja las Plazas seleccionadas?';
                }
                CargaItemsSeleccionados();
                var boton = document.getElementById('boton');
                boton.value = '1';                
                Confirmar(mens);
            }
            
            function VerInactivas(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/plazasinactivas.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
            function CargaItemsSeleccionados(){
                sels = 0;
                movs = '';
                <%for (int i=0; i < listado.size(); i++){%>
                     var chk = document.getElementById('chkplz<%=i%>');
                     if (chk.checked){
                         sels++;
                         if (movs == '')
                             movs = '<%=i%>';
                         else
                             movs += ','+'<%=i%>';
                     }
                <%}%>
                var varios = document.getElementById('varios');
                varios.value = movs;
            }
            
            function PagarClick(){
                CargaItemsSeleccionados();
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '21';
                frm.submit();                    
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
            function RecalcularClick(){
                CargaItemsSeleccionados();
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '22';
                frm.submit();                
            }
            
            function QuitarPagoClick(){
                CargaItemsSeleccionados();
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '24';
                frm.submit();                
            }
            
            function ImprimirClick(){
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGestionarNom');
                    dat1.value = '<%=nom.getId()%>';
                    paso.value = '26';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Nominas'+'&paso=25&dato1=<%=nom.getId()%>',
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function CargaDetalle(){
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '27';
                frm.submit();                
            }
            
            function VacacionesClick(){
                CargaItemsSeleccionados();
                Espera();
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/Vacaciones/registrargoce.jsp';
                paso.value = '44';
                frm.submit();                
            }
            
        </script>
    </body>
</html>
