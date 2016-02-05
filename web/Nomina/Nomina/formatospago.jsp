<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.DetalleNomina, Modelo.Entidades.Catalogos.Quincena"%>
<%@page import="Modelo.Entidades.Plaza, java.text.DecimalFormat, java.text.NumberFormat"%>
<%@page import="Modelo.Entidades.Catalogos.Banco"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Nomina nom = (Nomina)datosS.get("nomina");
Quincena quinactiva = (Quincena)datosS.get("quinactiva");
//List<CuentasTelecomm> cuentas = (List<CuentasTelecomm>)datosS.get("cuentas");
List<Banco> bancos = (List<Banco>)datosS.get("bancos");
NumberFormat formato = new DecimalFormat("#,##0.00");
List<HashMap> listado = datosS.get("detallenominafp")!=null?(List<HashMap>)datosS.get("detallenominafp"):new ArrayList<HashMap>();
String sniv = "", spago = "", scta = "", scot = "0", totnomina="", totaplicar="", porpagarnvo="", porpagaract = "";
if (paso==31){
    HashMap criterios = (HashMap)datosS.get("criterios");
    HashMap totsnom = (HashMap)datosS.get("totsdenom");
    sniv = criterios.get("nivel").toString();
    spago = criterios.get("formapago").toString();
    scta = criterios.get("cuenta").toString();
    if (criterios.get("cotiza")!=null)
        scot = criterios.get("cotiza").toString();
    totnomina = formato.format(Float.parseFloat(totsnom.get("totalnomina").toString()));
    totaplicar = formato.format(Float.parseFloat(datosS.get("totalaplicar").toString()));
    porpagaract = formato.format(Float.parseFloat(totsnom.get("porpagar").toString()));
    porpagarnvo = formato.format(Float.parseFloat(totsnom.get("porpagar").toString())-Float.parseFloat(datosS.get("totalaplicar").toString()));
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
            $( "#btnMostrar" ).button({
                icons: {
                    primary: "ui-icon-search"
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
            $( "#btnGenerarTxt" ).button({
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
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Catalogos/Nomina.jpg" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GENERAR FORMATOS DE PAGO
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
            <input id="idsplazas" name="idsplazas" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <input id="dato2" name="dato2" type="hidden" value=""/>
            <input id="dato3" name="dato3" type="hidden" value=""/>
            <input id="dato4" name="dato4" type="hidden" value=""/>
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
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Editar Nómina">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <select id="nivel" name="nivel" class="combo" style="width:200px">
                                                    <option value="">Elija el nivel...</option>
                                                    <option value="0" <%if (sniv.equals("0")){%> selected <%}%>>TODOS</option>
                                                    <option value="1" <%if (sniv.equals("1")){%> selected <%}%>>1</option>
                                                    <option value="2" <%if (sniv.equals("2")){%> selected <%}%>>2</option>
                                                    <option value="3" <%if (sniv.equals("3")){%> selected <%}%>>3</option>
                                                </select>
                                            </td>
                                            <td width="15%" align="left">
                                                <select id="pago" name="pago" class="combo" style="width:200px" onchange="ValidaPago(this.value)">
                                                    <option value="">Elija la forma de pago...</option>
                                                    <option value="1" <%if (spago.equals("1")){%> selected <%}%>>DEPOSITO</option>
                                                    <option value="2" <%if (spago.equals("2")){%> selected <%}%>>EFECTIVO</option>
                                                    <option value="3" <%if (spago.equals("3")){%> selected <%}%>>TELECOMM</option>
                                                </select>
                                            </td>
                                            <td width="30%" align="left">
                                                <select id="cuenta" name="cuenta" class="combo" style="width:350px">
                                                    <option value="">Elija la cuenta...</option>
                                                </select>
                                            </td>
                                            <td width="10%" align="left">
                                                <div id="divcotiza" style="display: none">
                                                    <input id="cotiza" name="cotiza" type="checkbox"/>
                                                    <span class="etiqueta">Cotiza</span>
                                                </div>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnMostrar" href="javascript: MostrarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir">
                                                    Mostrar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <div id="resultados" style="display: none">
                                    <!--acciones-->
                                    <table id="acciones" align="center" width="100%">
                                        <tr>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Total de nómina</span><br>
                                                <input id="totnom" name="totnom" type="text" readonly
                                                       style="text-align: right" value="<%=totnomina%>"/>
                                            </td>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Pendiente de pago:</span><br>
                                                <input id="totpenpago" name="totpenpago" type="text" readonly
                                                       style="text-align: right" value="<%=porpagaract%>"/>
                                            </td>
                                            <td width="15%" align="left">
                                                <span class="etiquetaB">Total por aplicar</span><br>
                                                <input id="totaplicar" name="totaplicar" type="text" readonly
                                                       style="text-align: right" value="<%=totaplicar%>"/>
                                            </td>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Nuevo total por pagar:</span><br>
                                                <input id="saldonuevo" name="saldonuevo" type="text" readonly
                                                       style="text-align: right" value="<%=porpagarnvo%>"/>
                                            </td>
                                            <td width="5%" align="center">
                                                
                                            </td>
                                            <td width="10%" align="right">
                                                <a id="btnGenerarTxt" href="javascript: GenerarTxtClick()"
                                                   style="width: 180px; font-weight: bold; color: #0B610B; display: none" title="Generar Archivo de Dispersión de Pagos">
                                                    Generar Dispersión
                                                </a>
                                            </td>
                                            <td width="10%" align="right">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B" title="Imprimir">
                                                    Imprimir
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <input id="xls" name="xls" type="checkbox">
                                                <span class="etiqueta">Imprimir en Excel</span>
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
                                                        No se encontraron plazas por pagar
                                                    </span>
                                                </td>
                                            </tr>
                                        <%} else {%>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="3%">
                                                        <input id="seltodo" name="seltodo" type="checkbox" onclick="SeleccionaTodos()" checked/>
                                                    </td>
                                                    <td align="center" width="24%" colspan="2">
                                                        <span>Empleado</span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        Cliente
                                                    </td>
                                                    <td align="center" width="15%">
                                                        Contrato
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>CT</span>
                                                    </td>
                                                    <td align="center" width="3%">
                                                        <span>Nivel</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Cuenta</span>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <span>Cotiza</span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span>Monto</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                HashMap criterios = (HashMap)datosS.get("criterios");
                                                for (int i=0; i < listado.size(); i++){
                                                    HashMap reg = (HashMap)listado.get(i);
                                                    Plaza plz = (Plaza)reg.get("plaza");
                                                    Integer cotiza = (Integer)reg.get("cotiza");
                                                %>
                                                    <tr onclick="Activa(<%=i%>)" title="ID. PLAZA: <%=plz.getId()%>">
                                                        <td align="center" width="3%">
                                                            <input id="chkPlz<%=i%>" name="chkPlz<%=i%>" type="checkbox" value="<%=plz.getId()%>" checked onclick="Activa(<%=i%>)"/>
                                                        </td>
                                                        <td align="center" width="3%">
                                                            <span>
                                                                <%=plz.getEmpleado().getClave()%>
                                                            </span>
                                                        </td>
                                                        <td align="left" width="21%">
                                                            <span>
                                                                <%=plz.getEmpleado().getPersona().getNombreCompletoPorApellidos()%>
                                                            </span>
                                                        </td>
                                                        <td align="left" width="20%">
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
                                                            <span>
                                                                <%=plz.getCtrabajo().getNombre()%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="3%">
                                                            <span>
                                                                <%=plz.getNivel()%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <span>
                                                                <%if (plz.getFormapago()==1){%>
                                                                    <%=plz.getEmpleado().getBanco().getNombre()%>
                                                                <%} else if (plz.getFormapago()==2){%>
                                                                    EFECTIVO
                                                                <%} else {%>
                                                                    TELECOMM
                                                                <%}%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <span>
                                                                <%if (cotiza.equals(1)){%>SÍ<%} else {%>NO<%}%>
                                                                <%--=plz.getEmpleado().getCotiza()==0?"NO":"SI"--%>
                                                            </span>
                                                        </td>
                                                        <td align="right" width="10%">
                                                            <span>
                                                                <%=formato.format(Float.parseFloat(reg.get("neto").toString()))%>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                <%}%>
                                            </tbody>
                                        <%}%>
                                    </table>
                                    <!--fin listado-->
                                    </div>
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
                <%}
                if (paso==31){
                %>
                    var divresult = document.getElementById('resultados');
                    divresult.style.display = '';
                    ValidaPago('<%=spago%>');
                    <%if (listado.size()==0){%>
                        var acciones = document.getElementById('acciones');
                        acciones.style.display = 'none';
                    <%}%>
                    <%--
                      if (spago.equals("1")){%>
                          var btngentxt = document.getElementById('btnGenerarTxt');
                          btngentxt.style.display = '';
                      <%}--%>
                <%}%>
            }
            
            function ValidaPago(pago){
                var cuenta = document.getElementById('cuenta');
                cuenta.length = 0;
                //cuenta.disabled = false;
                cuenta.options[0] = new Option('Elija la cuenta...','');
                k=1;
                var divcotiza = document.getElementById('divcotiza');
                divcotiza.style.display = 'none';
                if (pago=='1'){
                    //carga los bancos
                    var txt = document.getElementById('btnGenerarTxt');
                    txt.style.display = 'none';
                    <%
                    for (int i=0; i < bancos.size(); i++){
                        Banco ban = bancos.get(i);
                    %>
                        cuenta.options[k] = new Option('<%=ban.getNombre()%>','<%=ban.getId()%>');
                        <%if(paso==31){%>
                            if ('<%=ban.getId()%>'=='<%=scta%>'){
                                cuenta.options[k].selected=true;
                                if ('<%=ban.getId()%>'=='2'){
                                    txt.style.display = '';
                                }
                            }
                        <%}%> 
                        k++;
                    <%}%>
                    divcotiza.style.display = '';
                    var cotiza = document.getElementById('cotiza');
                    if ('<%=scot%>'=='1')
                        cotiza.checked = true;
                } else if (pago=='2' || pago == '3'){
                    cuenta.options[1] = new Option('COTIZA','1');
                    cuenta.options[2] = new Option('NO COTIZA','0');
                    <%if(paso==31){%>
                        if ('<%=scta%>'=='1'){
                            cuenta.options[1].selected=true;
                        } else if ('<%=scta%>'=='0'){
                            cuenta.options[2].selected=true;
                        }
                    <%}%> 
                }
            }
            
            function ValidaRequeridos(){
                var nivel = document.getElementById('nivel');
                if (nivel.value==''){
                    MostrarMensaje('Debe especificar el nivel');
                    return false;
                }
                
                var pago = document.getElementById('pago');
                if (pago.value==''){
                    MostrarMensaje('Debe especificar la forma de pago');
                    return false;
                }
                
                var cuenta = document.getElementById('cuenta');
                if (cuenta.value==''){
                    MostrarMensaje('Debe especificar la cuenta');
                    return false;
                }
                                
                return true;
            }
            
            function MostrarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmGestionarNom');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Nomina/Nomina/formatospago.jsp';
                    paso.value = '31';
                    frm.submit();
                }
            }
            
            function ValidaChkTodos(){
                var seltodo = document.getElementById('seltodo');
                todo = 1; checados = <%=listado.size()%>;
                bloqueados = 0;
                <%for (int i=0; i < listado.size(); i++){%>
                      var chk = document.getElementById('chkPlz<%=i%>');
                      if (!chk.checked){
                          todo = 0;
                          checados--;
                      }
                      if (chk.disabled)
                          bloqueados++;
                <%}%>
                var acciones = document.getElementById('acciones');
                if (bloqueados==<%=listado.size()%>){
                    seltodo.checked = false;
                    seltodo.disabled = true;
                    acciones.style.display = 'none';
                } else {
                    if (todo==1)
                        seltodo.checked = true;
                    else
                        seltodo.checked = false;
                    if (checados==0){
                        acciones.style.display = 'none';
                    } else {
                        acciones.style.display = '';
                    }
                }
            }
            
            function RecalculaTotalAplicar(){
                var tot = document.getElementById('totaplicar');
                var porpagar = document.getElementById('totpenpago');
                var totnom = document.getElementById('totnom');
                var saldo = document.getElementById('saldonuevo');
                //porpagar.value = '';
                tot.value = '';
                saldo.value = '';
                ftotap = 0.0;
                fxpag = parseFloat(porpagar.value.replace(',',''));
                fsal = 0.0;
                <%
                for (int i=0; i < listado.size(); i++){
                    HashMap reg = (HashMap)listado.get(i);
                    String neto = reg.get("neto").toString();
                %>
                      var chk = document.getElementById('chkPlz<%=i%>');
                      if (chk.checked){
                          ftotap+=parseFloat('<%=neto%>')
                      }
                <%}%>
                fsal = fxpag-ftotap;
                tot.value = formato_numero(ftotap,2,'.',',');
                saldo.value = formato_numero(fsal,2,'.',',');
            }
            
            function Activa(fila){
                var chk = document.getElementById('chkPlz'+fila);
                if (!chk.disabled){
                    if (chk.checked)
                        chk.checked = false;
                    else
                        chk.checked = true;
                    ValidaChkTodos();
                    RecalculaTotalAplicar();
                }
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarNom');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/gestionarnominas.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function SeleccionaTodos(){
                var seltodo = document.getElementById('seltodo');
                var acciones = document.getElementById('acciones');
                if (seltodo.checked){
                    acciones.style.display = '';
                    //marca todas las casillas de la lista
                    <%for (int i=0; i < listado.size(); i++){%>
                          var chk = document.getElementById('chkPlz<%=i%>');
                          if (!chk.disabled)
                             chk.checked = true;
                    <%}%>
                    RecalculaTotalAplicar();
                } else {
                    acciones.style.display = 'none';
                    //desmarca todas las casillas de la lista
                    <%for (int i=0; i < listado.size(); i++){%>
                          var chk = document.getElementById('chkPlz<%=i%>');
                          chk.checked = false;
                    <%}%>
                }
            }
            
            function ImprimirClick(){
                //carga las plazas seleccionadas
                var ids = document.getElementById('idsplazas');
                ids.value = '';
                <%for (int i=0; i < listado.size(); i++){%>
                    var chk = document.getElementById('chkPlz<%=i%>');
                    if (chk.checked){
                        if (ids.value==''){
                            ids.value = chk.value;
                        } else {
                            ids.value = ids.value+','+chk.value;
                        }
                        chk.disabled = true;
                        chk.checked = false;
                    }
                <%}%>
                ValidaChkTodos();
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGestionarNom');
                    dat1.value = ids.value;
                    paso.value = '33';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Nominas'+'&paso=32&dato1='+ids.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function GenerarTxtClick(){
                var ids = document.getElementById('idsplazas');
                ids.value = '';
                <%for (int i=0; i < listado.size(); i++){%>
                    var chk = document.getElementById('chkPlz<%=i%>');
                    if (chk.checked){
                        if (ids.value==''){
                            ids.value = chk.value;
                        } else {
                            ids.value = ids.value+','+chk.value;
                        }
                        chk.disabled = true;
                        chk.checked = false;
                    }
                <%}%>
                ValidaChkTodos();
                var dat1 = document.getElementById('dato1');
                var paso = document.getElementById('pasoSig');
                var pagina = document.getElementById('paginaSig');
                var frm = document.getElementById('frmGestionarNom');
                dat1.value = ids.value;
                paso.value = '64';
                pagina.value = '/Nomina/Nomina/formatospago.jsp';
                frm.submit();                
            }
        </script>
    </body>
</html>
