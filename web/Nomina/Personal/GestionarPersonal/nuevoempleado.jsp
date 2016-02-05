
<%-- 
    Document   : nuevoempleado
    Created on : Jun 6, 2012, 10:37:15 PM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.Date, Modelo.Entidades.Empleado, Modelo.Entidades.HistorialIMSS "%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    
    Sucursal sucSel = (Sucursal)datosS.get("sucursal");
    String titulo = "NUEVO EMPLEADO";
    String imagen = "empleadosB.png";
    Empleado tempo = new Empleado();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR EMPLEADO";
        imagen = "empleadosC.png";
    }
    
    if (datosS.containsKey("editarEmpleado") || datosS.containsKey("nuevoEmpleado")){
        if (datosS.containsKey("editarEmpleado")){
            tempo = (Empleado)datosS.get("editarEmpleado");
        } else
            tempo = (Empleado)datosS.get("nuevoEmpleado");
    }
    
    String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
    List<HistorialIMSS> historial = datosS.get("historial")!=null?(List<HistorialIMSS>)datosS.get("historial"):new ArrayList<HistorialIMSS>();
    List<String> rps = datosS.get("regispatrs")!=null?(List<String>)datosS.get("regispatrs"): new ArrayList<String>();
    String rpe = tempo.getRegistropatronal()!=null?tempo.getRegistropatronal():"";
    int paso = Integer.parseInt(datosS.get("paso").toString());
    if (paso==45)
        titulo = "DATOS DEL EMPLEADO";
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <!--<link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />-->
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <!--
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"/>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>
        -->
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaNac" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechaAlta" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechamov" ).datepicker({
            changeMonth: true,
            changeYear: true,
            });
        });
        
        $(function() {
            $( "#fechamovalta" ).datepicker({
            changeMonth: true,
            changeYear: true,
            });
        });
        $(function() {
            $( "#fechamovbaja" ).datepicker({
            changeMonth: true,
            changeYear: true,
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
        
        //DIALOGO MOVIMIENTO
        $(function() {
            $( "#dialog-movimiento" ).dialog({
            resizable: false,
            width:500,
            height:350,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                AgregarMovimiento();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                }
            }
            });
        });        
        
        //DIALOGO EDITAR MOVIMIENTO IMSS
        $(function() {
            $( "#dialog-editarmovimss" ).dialog({
            resizable: false,
            width:500,
            height:350,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                GuardarMovimiento();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                }
            }
            });
        });
        
        //TABS
        $(function() {
            $( "#tabs" ).tabs();
            //inicializar los tabs
            <%switch (Integer.parseInt(pestaña)){
                case 1:%>$( "#tabs" ).tabs({ active: 0 });<%break;
                case 2:%>$( "#tabs" ).tabs({ active: 1 });<%break;
                case 3:%>$( "#tabs" ).tabs({ active: 2 });<%break;
            }%>
        });
        
        //BOTONES
        $(function() {
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnAlta" ).button({
                icons: {
                    primary: "ui-icon-locked"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-unlocked"
		}
            });
            $( "#btnBorrarHist" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnEditarHist" ).button({
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
        
        <div id="dialog-movimiento" title="SISCAIM - Movimiento IMSS">
            <table width="100%">
                <tr>
                    <td width="100%" align="left" colspan="2">
                        <p id="movtitulo" class="titulo"></p>
                    </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span class="etiquetaB">Fecha:</span><br>
                        <input id="fechamov" name="fechamov" type="text" class="text" readonly value=""
                            title="Ingrese la fecha" />
                    </td>
                </tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span id="etRp" name="etRp" class="etiquetaB">Registro Patronal:</span><br>
                        <select id="regpatr" name="regpatr" class="combo" style="width: 200px">
                            <option value="" <%if(rpe.equals("")){%>selected<%}%> >ELIJA EL REGISTRO PATRONAL...</option>
                            <%for(int i=0; i < rps.size(); i++){
                                String rp = rps.get(i);
                            %>
                                <option value="<%=rp%>" <%if(rpe.equals(rp)){%>selected<%}%>><%=rp%></option>
                            <%}%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span id="etSbc" name="etSbc" class="etiquetaB">Salario Base de Cotización:</span><br>
                        <input id="sbc" name="sbc" type="text" class="text" value="" style="width: 150px; text-align: right"
                               onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="Formatea(this, 'text')"/>
                    </td>
                </tr>
            </table>
        </div>
        
        <div id="dialog-editarmovimss" title="SISCAIM - Editar Movimiento IMSS">
            <table width="100%">
                <tr>
                    <td width="100%" align="left" colspan="2">
                        <p id="movtitulo" class="titulo"></p>
                    </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span class="etiquetaB">Fecha Alta:</span><br>
                        <input id="fechamovalta" name="fechamovalta" type="text" class="text" readonly value=""
                            title="Ingrese la fecha de alta" />
                    </td>
                </tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span class="etiquetaB">Fecha Baja:</span><br>
                        <input id="fechamovbaja" name="fechamovbaja" type="text" class="text" readonly value=""
                            title="Ingrese la fecha de baja" />
                    </td>
                </tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span class="etiquetaB">Registro Patronal:</span><br>
                        <select id="regpatredit" name="regpatredit" class="combo" style="width: 200px">
                            <option value="">ELIJA EL REGISTRO PATRONAL...</option>
                            <%for(int i=0; i < rps.size(); i++){
                                String rp = rps.get(i);
                            %>
                                <option value="<%=rp%>"><%=rp%></option>
                            <%}%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width="20%">
                        &nbsp;
                    </td>
                    <td width="80%">
                        <span id="etSbc" name="etSbc" class="etiquetaB">Salario Base de Cotización:</span><br>
                        <input id="sbcedit" name="sbcedit" type="text" class="text" value="" style="width: 150px; text-align: right"
                               onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="Formatea(this, 'text')"/>
                    </td>
                </tr>
            </table>
        </div>

        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="subtitulo" align="left">
                        <%=titulo%> - SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoEmp" name="frmNuevoEmp" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="fechaimss" name="fechaimss" type="hidden" value=""/>
            <input id="fechaimssbaja" name="fechaimssbaja" type="hidden" value=""/>
            <input id="rpimss" name="rpimss" type="hidden" value=""/>
            <input id="movi" name="movi" type="hidden" value=""/>
            <input id="sbcimss" name="sbcimss" type="hidden" value=""/>
            <input id="idssel" name="idssel" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="80%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Datos Generales</a></li>
                                                <li><a href="#tabs-2">Otros Datos</a></li>
                                                <%if (datosS.get("accion").toString().equals("editar")){%>
                                                <li><a href="#tabs-3">IMSS</a></li>
                                                <%}%>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestdatosemp.jsp"%>
                                            </div>
                                            <div id="tabs-2">
                                                <%@include file="pestdetallesemp.jsp" %>
                                            </div>
                                            <%if (datosS.get("accion").toString().equals("editar")){%>
                                            <div id="tabs-3">
                                                <%@include file="pesthistorialimss.jsp" %>
                                            </div>
                                             <%}%>
                                        </div>                                        
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
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
            
            function Confirmar(mensaje){
                var mens = document.getElementById('confirm');
                mens.textContent = mensaje;
                $( "#dialog-confirm" ).dialog( "open" );
            }

            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
            }
    
            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function CambiaClase (obj, clase){
                obj.className = clase;
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
                %>
                var clave = document.getElementById('clave');
                clave.focus();
                var nss = document.getElementById('nssEmpPer');
                var rp = document.getElementById('regpatr');
                rp.disabled = true;
                if (nss.value!='')
                    rp.disabled = false;
            }
            
            function AgregarMovimiento(){
                var fechamov = document.getElementById('fechamov');
                if (fechamov.value == ''){
                    MostrarMensaje('Debe indicar la fecha del movimiento en el IMSS');
                    return;
                }
                
                var mov = document.getElementById('movi');
                var rp = document.getElementById('regpatr');
                var sbc = document.getElementById('sbc');
                if (mov.value=='1'){
                    if (rp.value==''){
                        MostrarMensaje('Debe indicar el registro patronal');
                        return;
                    }
                    if (sbc.value==''){
                        MostrarMensaje('El salario base de cotización no puede estar vacío');
                        return;
                    } else {
                        var fsbc = parseFloat(sbc.value.replace(',',''));
                        if (fsbc<=0){
                            MostrarMensaje("El valor del salario base de cotización no es válido");
                            return;
                        }
                    }
                }
                /*if (!ValidaFecha()){
                    MostrarMensaje('La fecha indicada no es válida');
                    return;
                }*/
                
                $( "#dialog-movimiento" ).dialog( "close" );
                var fechaimss = document.getElementById('fechaimss');
                var rpimss = document.getElementById('rpimss');
                var sbcimss = document.getElementById('sbcimss');
                fechaimss.value = fechamov.value;
                if (mov.value=='1'){
                    rpimss.value = rp.value;
                    sbcimss.value = sbc.value;
                } else {
                    rpimss.value = '';
                }
                var frm = document.getElementById('frmNuevoEmp');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp';
                if (mov.value=='1'){
                    frm.pasoSig.value = '26';                    
                } else {
                    frm.pasoSig.value = '27';
                }
                frm.submit();
            }
            
            function GuardarMovimiento(){
                var fechamova = document.getElementById('fechamovalta');
                if (fechamova.value == ''){
                    MostrarMensaje('Debe indicar la fecha de alta del movimiento en el IMSS');
                    return;
                }
                
                var fechamovb = document.getElementById('fechamovbaja');
                if (!fechamovb.disabled && fechamovb.value == ''){
                    MostrarMensaje('Debe indicar la fecha de baja del movimiento en el IMSS');
                    return;
                }
                
                var mov = document.getElementById('movi');
                var rp = document.getElementById('regpatredit');
                var sb = document.getElementById('sbcedit');
                if (mov.value=='1'){
                    if (rp.value==''){
                        MostrarMensaje('Debe indicar el registro patronal');
                        return;
                    }
                    if (sb.value==''){
                        MostrarMensaje('El salario base de cotización no puede estar vacío');
                        return;
                    } else {
                        var fsbc = parseFloat(sb.value.replace(',',''));
                        if (fsbc<=0){
                            MostrarMensaje("El valor del salario base de cotización no es válido");
                            return;
                        }
                    }
                }
                $( "#dialog-editarmovimss" ).dialog( "close" );
                var fechaimss = document.getElementById('fechaimss');
                var fechaimssb = document.getElementById('fechaimssbaja');
                var rpimss = document.getElementById('rpimss');
                var sbcimss = document.getElementById('sbcimss');
                fechaimss.value = fechamova.value;
                fechaimssb.value = fechamovb.value;
                rpimss.value = rp.value;
                sbcimss.value = sb.value;
                var frm = document.getElementById('frmNuevoEmp');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp';
                frm.pasoSig.value = '34';
                frm.submit();
            }
            
        /*function limpiar(nombreObj1, nombreObj2)
        {
            obj = document.getElementById(nombreObj1);
            obj.value='';
            obj = document.getElementById(nombreObj2);
            obj.value='';
        }
        
        function cambiaFecha(fecha, nombreObj)
        {
            d = fecha.substr(0,2);
            m = fecha.substr(3,2);
            y = fecha.substr(6,4);
            txtFecha = document.getElementById(nombreObj);
            txtFecha.value=y+'-'+m+'-'+d;
        }
            function PonerInactivo(total){
                for (i=1; i<=total; i++){
                    var pest = document.getElementById('pest'+i);
                    if (pest.className=='activo'){
                        pest.className='inactivo';
                        var cont = document.getElementById('pest'+i+'cont');
                        cont.style.display = 'none';
                    }
                }
            }*/
        
            function ClickPestana(numpest){
                $( "#tabs" ).tabs({ active: numpest-1 });
                /*PonerInactivo(total);                
                var pest = document.getElementById('pest'+numpest);
                pest.className = 'activo';
                var cont = document.getElementById('pest'+numpest+'cont');
                cont.style.display = '';*/
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoEmp');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.pasoSig.value = '98';
                <%if (paso==45){%>
                    frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp';
                    frm.pasoSig.value = '7';
                <%}%>
                frm.submit();
            }
            
            function CargaMunicipios(estado){
                    var poblacion = document.getElementById("poblacionPer");
                    poblacion.length = 0;
                    poblacion.options[0] = new Option('Elija la Población...','0');
                    k=1;
                <%
                    for (int i = 0; i < estados.size(); i++) {
                        Estado edo = (Estado) estados.get(i);
                %>
                    if (<%=edo.getIdestado()%> == estado){
                <%
                    List<Municipio> munis = edo.getMunicipios();
                    for (int j = 0; j < munis.size(); j++) {
                        Municipio mun = munis.get(j);
                %>
                        poblacion.options[k] = new Option('<%=mun.getMunicipio()%>','<%=mun.getIdmunicipio()%>');
                        k++;
                <%
                    }
                %>
                    }
                <%
                    }
                %>
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoEmp');
                    frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                    <%if (paso==45){%>
                        frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp';
                    <%}%>
                    <%
                        if (datosS.get("accion").toString().equals("editar")) {
                    %>
                        frm.pasoSig.value = '5';
                    <%                } else {
                    %>
                        frm.pasoSig.value = '2';
                    <%                    }
                    %>
                    frm.submit();
                 }
            }            
            
            function ValidaRequeridos(){
                if (ValidaDatos())
                    if (ValidaDetalles())
                        return true;
                return false;
            }
                  
            function ValidaDatos(){                
                    var clave = document.getElementById('clave');
                    if (clave.value == ''){
                        MostrarMensaje('La Clave del Empleado está vacía');
                        ClickPestana(1);
                        CambiaClase(clave,'ui-state-error');
                        return false;
                    }
                    
                    var nombreEmp = document.getElementById('nombrePer');
                    if (nombreEmp.value == ''){
                        MostrarMensaje('El campo Nombre del Empleado está vacío');
                        ClickPestana(1);
                        CambiaClase(nombreEmp,'ui-state-error');
                        return false;
                    }      
                    var paternoEmp = document.getElementById('paternoPer');
                    if (paternoEmp.value == ''){
                        MostrarMensaje('El campo Ap. Paterno del Empleado está vacío');
                        ClickPestana(1);
                        CambiaClase(paternoEmp,'ui-state-error');
                        return false;
                    }
                    /*
                    var maternoEmp = document.getElementById('maternoPer');
                    if (maternoEmp.value == ''){
                        Mensaje('El campo Ap. Materno del Empleado está vacío');
                        ClickPestana(1,2);
                        maternoEmp.focus();
                        return false;
                    }
                    var rfcEmp = document.getElementById('rfcPer');
                    if (rfcEmp.value == ''){
                        Mensaje('El campo RFC del Empleado está vacío');
                        ClickPestana(1,2);
                        rfcEmp.focus();
                        return false;
                    }*/
                
                    /*var curpEmp = document.getElementById('curpPer');
                    if (curpEmp.value == ''){
                        Mensaje('El campo CURP del Empleado está vacío');
                        ClickPestana(1,2);
                        curpEmp.focus();
                        return false;
                    }*/
                    
                    var edonac = document.getElementById('estadoNac');
                    if (edonac.value == '0'){
                        MostrarMensaje('El Estado de nacimiento no ha sido establecido');
                        ClickPestana(1);
                        CambiaClase(edonac,'comboerror');
                        return false;
                    }
                    
                    var sexo = document.getElementById('sexoPer');
                    if (sexo.value == ''){
                        MostrarMensaje('El Sexo del Empleado no ha sido establecido');
                        ClickPestana(1);
                        CambiaClase(sexo,'comboerror');
                        return false;
                    }
                    
                    var fnac = document.getElementById('fechaNac');
                    if (fnac.value == ''){
                        MostrarMensaje('La Fecha de Nacimiento del Empleado no ha sido establecida');
                        ClickPestana(1);
                        CambiaClase(fnac,'ui-state-error');
                        return false;
                    }
                    
                    var falta = document.getElementById('fechaAlta');
                    if (falta.value == ''){
                        MostrarMensaje('La Fecha de Registro del Empleado no ha sido establecida');
                        ClickPestana(1);
                        CambiaClase(falta,'ui-state-error');
                        return false;
                    }
                    /*
                    var telefonoEmp = document.getElementById('telefonoPer');
                    if (telefonoEmp.value == ''){
                        Mensaje('El campo Telefono del Empleado está vacío');
                        ClickPestana(1,2);
                        telefonoEmp.focus();
                        return false;
                    }*/
        
                    var calleEmp = document.getElementById('callenumPer');
                    if (calleEmp.value == ''){
                        MostrarMensaje('El campo Calle del Empleado está vacío');
                        ClickPestana(1);
                        CambiaClase(calleEmp,'ui-state-error');
                        return false;
                    }
                    var coloniaEmp = document.getElementById('coloniaPer');
                    if (coloniaEmp.value == ''){
                        MostrarMensaje('El campo Colonia del Empleado está vacío');
                        ClickPestana(1);
                        CambiaClase(coloniaEmp,'ui-state-error');
                        return false;
                    }
                    /*
                    var estadoEmp = document.getElementById('estadoPer');
                    if (estadoEmp.value=='0'){
                    Mensaje('El campo Estado no ha sido establecido');
                    ClickPestana(2,2);
                    estadoEmp.focus();
                    return false;
                    }
        */
                    var poblacionEmp = document.getElementById('poblacionPer');
                    if (poblacionEmp.value=='0'){
                        MostrarMensaje('El campo Poblacion no ha sido establecido');
                        ClickPestana(1);
                        CambiaClase(poblacionEmp,'comboerror');
                        return false;
                    }
                    
                    <%--if (datosS.get("accion").toString().equals("editar")){%>                    
                    var nss = document.getElementById('nssEmpPer');
                    var rp = document.getElementById('regpatr');
                    if (nss.value!='' && rp.value==''){
                        ClickPestana(3);
                        MostrarMensaje('El campo Registro Patronal no ha sido establecido');
                        return false;
                    }
                    <%}--%>
                    
                    return true;
             }
             function ValidaDetalles(){
                 /*
                var sucEmp = document.getElementById('sucursalPer');
                if (sucEmp.value=='0'){
                    Mensaje('El campo Sucursal no ha sido establecido');
                    ClickPestana(2,2);
                    sucEmp.focus();
                    return false;
                }
        
                var cargoEmp = document.getElementById('cargoPer');
                    if (cargoEmp.value == ''){
                        Mensaje('El campo Cargo del Empleado está vacío');
                        ClickPestana(2,2);
                        cargoEmp.focus();
                        return false;
                    }           
                    
                var cuentaEmp = document.getElementById('cuentaEmpPer');
                    if (cuentaEmp.value == ''){
                        Mensaje('El campo Cuenta del Empleado está vacío');
                        ClickPestana(2,2);
                        cuentaEmp.focus();
                        return false;
                    }*/
                    
                    /*var cotiza = document.getElementById('cotizaEmpPer');
                    if (cotiza.checked){
                        var nss = document.getElementById('nssEmpPer');
                        if (nss.value == ''){
                            Mensaje('El campo NSS del Empleado está vacío');
                            ClickPestana(2,2);
                            nss.focus();
                            return false;
                        }
                    }*/
                    var banco = document.getElementById('banco');
                    var cuenta = document.getElementById('cuentaEmpPer');
                    if (banco.value != '' && cuenta.value == ''){
                        MostrarMensaje ('El campo Cuenta está vacío');
                        ClickPestana(2);
                        CambiaClase(cuenta,'ui-state-error');
                        return false;
                    }
                    var cons = document.getElementById('consecutivo');
                    if (banco.value == '2' && cons.value == ''){
                        MostrarMensaje('El campo Consecutivo está vacío');
                        ClickPestana(2);
                        CambiaClase(cons,'ui-state-error');
                        return false;
                    }
                    
                    return true;
             }
             
            function Formatea(obj, clase){
                obj.value = formato_numero(obj.value.replace(',',''),2,'.',',');
            }
             
        </script>
    </body>
</html>