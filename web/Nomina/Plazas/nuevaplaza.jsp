<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Plaza, Modelo.Entidades.Catalogos.PerPagos, Modelo.Entidades.Catalogos.Puestos, Modelo.Entidades.Empleado"%>
<%@page import="Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
Cliente clisel = (Cliente)datosS.get("clienteSel");
Contrato consel = (Contrato)datosS.get("editarContrato");
CentroDeTrabajo ctsel = (CentroDeTrabajo)datosS.get("centro");
String matriz = datosS.get("matriz").toString();
    
String sueldo = "0.00", compensacion = "0.00", sueldocot = "0.00", compencot = "0.00", falta = "", faltanorm = "";
int nivel = 0, formapago = 0;
PerPagos periodo = new PerPagos();
Puestos puesto = new Puestos();
Empleado empl = new Empleado();
String titulo = "NUEVA PLAZA";
String imagen = "plazasB.png";
List<Empleado> empleados = (List<Empleado>)datosS.get("empleados");
List<Puestos> puestos = (List<Puestos>)datosS.get("puestos");
List<PerPagos> periodos = (List<PerPagos>)datosS.get("periodos");
float acumsueldos = ((Float)datosS.get("acumsueldos")).floatValue();
float sueldoact = 0.0f, sueldocotact = 0.0f;
NumberFormat formato = new DecimalFormat("#,##0.00");
if (datosS.get("accion").toString().equals("editar")){
    titulo = "EDITAR PLAZA";
    imagen = "plazasC.png";
    Plaza pl = (Plaza)datosS.get("plaza");
    periodo = pl.getPeriodopago();
    puesto = pl.getPuesto();
    empl = pl.getEmpleado();
    falta = pl.getFechaalta().toString();
    faltanorm = falta.substring(8,10) + "-" + falta.substring(5,7) + "-" + falta.substring(0, 4);
    nivel = pl.getNivel();
    sueldo = formato.format(pl.getSueldo());//Float.toString(pl.getSueldo());
    sueldocot = formato.format(pl.getSueldocotiza());
    sueldoact = pl.getSueldo();
    /*sueldocotact = pl.getSueldocotiza();
    compensacion = formato.format(pl.getCompensacion());//Float.toString(pl.getCompensacion());
    compencot = formato.format(pl.getCompensacioncotiza());*/
    formapago = pl.getFormapago();
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <!--
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
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
            $( "#fechaAlta" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechafin" ).datepicker({
            changeMonth: true,
            changeYear: true
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
                    <img src="/siscaim/Imagenes/Nomina/Plazas/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PLAZAS - <%=titulo%>
                    </div>
                    <div align="left">
                        <table width="100%">
                            <tr>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">SUCURSAL:</span>&nbsp;
                                    <span class="subtitulo"><%=sucSel.getDatosfis().getRazonsocial()%></span>                                    
                                </td>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">CLIENTE:</span>&nbsp;
                                    <span class="subtitulo"><%=clisel.getTipo()==0?clisel.getDatosFiscales().getRazonsocial():clisel.getDatosFiscales().getPersona().getNombreCompleto()%></span>
                                </td>
                            </tr>
                            <tr>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">CONTRATO:</span>&nbsp;
                                    <span class="subtitulo"><%=consel.getContrato()%> - <%=consel.getDescripcion()%></span>
                                </td>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">C.T.:</span>&nbsp;
                                    <span class="subtitulo"><%=ctsel.getNombre()%></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaPlz" name="frmNuevaPlz" action="<%=CONTROLLER%>/Gestionar/Plazas" method="post">
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
                                                    <span class="etiqueta">Empleado:</span><br>
                                                    <select id="empleado" name="empleado" class="combo" style="width: 500px"
                                                            onchange="CambiaClase(this, 'combo')">
                                                        <option value="">Elija el Empleado...</option>
                                                        <%
                                                        if (datosS.get("accion").toString().equals("editar")){
                                                        %>
                                                        <option value="<%=empl.getNumempleado()%>" selected>
                                                            <%=empl.getPersona().getNombreCompletoPorApellidos()%>
                                                        </option>
                                                        <%
                                                        }
                                                        for (int i=0; i < empleados.size(); i++){
                                                            Empleado e = empleados.get(i);
                                                        %>
                                                        <option value="<%=e.getNumempleado()%>" <%if (e.getNumempleado()==empl.getNumempleado()){%>selected<%}%>>
                                                            <%=e.getPersona().getNombreCompletoPorApellidos()%>
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
                                                    <span class="etiqueta">Puesto:</span><br>
                                                    <select id="puesto" name="puesto" class="combo" style="width: 300px"
                                                            onchange="CargaSueldo(this, 'combo')">
                                                        <option value="">Elija el Puesto...</option>
                                                        <%
                                                        for (int i=0; i < puestos.size(); i++){
                                                            Puestos p = puestos.get(i);
                                                        %>
                                                        <option value="<%=p.getIdPuestos()%>" <%if (p.getIdPuestos()==puesto.getIdPuestos()){%>selected<%}%>>
                                                            <%=p.getDescripcion()%>
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
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Nivel:</span><br>
                                                                <select id="nivel" name="nivel" class="combo" style="width: 150px"
                                                                        onchange="CambiaClase(this, 'combo')">
                                                                    <option value="0" <%if (nivel==0){%>selected<%}%>>
                                                                        Elija el Nivel...
                                                                    </option>
                                                                    <%
                                                                    for (int i=1; i < 4; i++){
                                                                    %>
                                                                    <option value="<%=i%>" <%if (i==nivel){%>selected<%}%>>
                                                                        <%=i%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Fecha Alta:</span><br>
                                                                <input id="fechaAlta" name="fechaAlta" type="text" class="text" readonly value="<%=faltanorm%>"
                                                                       title="Ingrese la fecha de alta" onchange="CambiaClase(this, 'text')"/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Sueldo:</span><br>
                                                                <input id="sueldo" name="sueldo" type="text" class="text" value="<%=sueldo%>" style="width: 150px; text-align: right"
                                                                       onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="Formatea(this, 'text')"
                                                                       <%if(matriz.equals("0")){%>readonly<%}%>/>
                                                            </td>
                                                            <%--
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Compensación:</span><br>
                                                                <input id="compensacion" name="compensacion" type="text" class="text" value="<%=compensacion%>" style="width: 150px; text-align: right"
                                                                    onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="Formatea(this, 'text')"
                                                                    <%if(matriz.equals("0")){%>readonly<%}%>/>
                                                            </td>--%>
                                                        </tr>
                                                        <%--
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Sueldo Cotización:</span><br>
                                                                <input id="sueldocotiza" name="sueldocotiza" type="text" class="text" value="<%=sueldocot%>" style="width: 150px; text-align: right"
                                                                       onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="Formatea(this, 'text')"
                                                                       <%if(matriz.equals("0")){%>readonly<%}%>/>
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Compensación Cotización:</span><br>
                                                                <input id="compensacioncotiza" name="compensacioncotiza" type="text" class="text" value="<%=compencot%>" style="width: 150px; text-align: right"
                                                                    onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="Formatea(this, 'text')"
                                                                    <%if(matriz.equals("0")){%>readonly<%}%>/>
                                                            </td>
                                                        </tr>--%>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Forma de Pago:</span><br>
                                                                <select id="formapago" name="formapago" class="combo" style="width: 200px"
                                                                        onchange="CambiaClase(this, 'combo')">
                                                                    <option value="0"<%if (formapago==0){%>selected<%}%>>
                                                                        Elija la Forma de Pago...
                                                                    </option>
                                                                    <option value="1" <%if (formapago==1){%>selected<%}%>>
                                                                        DEPOSITO
                                                                    </option>
                                                                    <option value="2" <%if (formapago==2){%>selected<%}%>>
                                                                        EFECTIVO
                                                                    </option>
                                                                    <option value="3" <%if (formapago==3){%>selected<%}%>>
                                                                        TELECOMM
                                                                    </option>
                                                                </select>
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Período de Pago:</span><br>
                                                                <select id="periodo" name="periodo" class="combo" style="width: 250px"
                                                                        onchange="CambiaClase(this, 'combo')">
                                                                    <option value="">Elija el Período de Pago...</option>
                                                                    <%
                                                                    for (int i=0; i < periodos.size(); i++){
                                                                        PerPagos pp = periodos.get(i);
                                                                    %>
                                                                    <option value="<%=pp.getIdPerPagos()%>" <%if (pp.getIdPerPagos()==periodo.getIdPerPagos()){%>selected<%}%>>
                                                                        <%=pp.getDescripcion()%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                    </table>
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
                %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevaPlz');
                frm.paginaSig.value = '/Nomina/Plazas/gestionarplazas.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevaPlz');
                    frm.paginaSig.value = '/Nomina/Plazas/gestionarplazas.jsp';
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
                    frm.submit();
                }
                
            }
            
            function ValidaRequeridos(){
                var empleado = document.getElementById('empleado');
                if (empleado.value == ''){
                    MostrarMensaje('El Empleado no ha sido establecido');
                    CambiaClase(empleado,'comboerror');
                    //empleado.className = 'ui-state-error';
                    //empleado.focus();
                    return false;
                }
                
                var puesto = document.getElementById('puesto');
                if (puesto.value == ''){
                    MostrarMensaje('El Puesto no ha sido establecido');
                    CambiaClase(puesto,'comboerror');
                    //puesto.focus();
                    return false;
                }
                                
                var nivel = document.getElementById('nivel');
                if (nivel.value == '0'){
                    MostrarMensaje('El Nivel no ha sido establecido');
                    CambiaClase(nivel,'comboerror');
                    //nivel.focus();
                    return false;
                }
                
                var fecha = document.getElementById('fechaAlta');
                if (fecha.value == ''){
                    MostrarMensaje('La Fecha de Alta no ha sido establecida');
                    CambiaClase(fecha,'ui-state-error');
                    //fecha.focus();
                    return false;
                }
                
                var sueldo = document.getElementById('sueldo');
                if (sueldo.value == ''){
                    MostrarMensaje('El Sueldo está vacío');
                    CambiaClase(sueldo,'ui-state-error');
                    //sueldo.focus();
                    return false;
                }

                /*var compensacion = document.getElementById('compensacion');
                if (compensacion.value == ''){
                    MostrarMensaje('La Compensación está vacía');
                    CambiaClase(compensacion,'ui-state-error');
                    //compensacion.focus();
                    return false;
                }
                
                var sueldocot = document.getElementById('sueldocotiza');
                if (sueldocot.value == ''){
                    MostrarMensaje('El Sueldo de Cotización está vacío');
                    CambiaClase(sueldocot,'ui-state-error');
                    //sueldo.focus();
                    return false;
                }
                

                var compencot = document.getElementById('compensacioncotiza');
                if (compencot.value == ''){
                    MostrarMensaje('La Compensación de Cotización está vacía');
                    CambiaClase(compencot,'ui-state-error');
                    //compensacion.focus();
                    return false;
                }
                */
                var forma = document.getElementById('formapago');
                if (forma.value == '0'){
                    MostrarMensaje('La Forma de Pago no ha sido establecida');
                    CambiaClase(forma,'comboerror');
                    return false;
                }

                var periodo = document.getElementById('periodo');
                if (periodo.value == ''){
                    MostrarMensaje('El Período de Pago no ha sido establecido');
                    CambiaClase(periodo,'comboerror');
                    return false;
                }
                
                //valida tope de sueldos
                <%if (datosS.get("accion").toString().equals("editar")){%>
                     var acumnvo = parseFloat('<%=acumsueldos%>');
                     var sueact = parseFloat('<%=sueldoact%>');
                     <%--var suecotact = parseFloat('<%=sueldocotact%>');--%>
                     var fsueldo = parseFloat(sueldo.value.replace(',',''));
                     <%--var fsueldocot = parseFloat(sueldocot.value.replace(',',''));--%>
                     var suetot = sueact;//+suecotact;
                     var fsuetot = fsueldo;//+fsueldocot;
                     
                     acumnvo -= suetot;
                     acumnvo += fsuetot;
                     
                     if (acumnvo > parseFloat('<%=ctsel.getTopeSueldos()%>')){
                         var dif = formato_numero(acumnvo - parseFloat('<%=ctsel.getTopeSueldos()%>'),2,'.',',');
                         MostrarMensaje('El tope de sueldos del CT ha sido excedido por '+dif+' pesos');
                         return false;
                     }
                <%} else {%>
                     var acumnvo = parseFloat('<%=acumsueldos%>');
                     var fsueldo = parseFloat(sueldo.value.replace(',',''));
                     <%--var fsueldocot = parseFloat(sueldocot.value.replace(',',''));--%>
                     var fsuetot = fsueldo;//+fsueldocot;
                     acumnvo += fsuetot;
                     
                     if (acumnvo > parseFloat('<%=ctsel.getTopeSueldos()%>')){
                         var dif = formato_numero(acumnvo - parseFloat('<%=ctsel.getTopeSueldos()%>'),2,'.',',');
                         MostrarMensaje('El tope de sueldos del CT ha sido excedido por '+dif+' pesos');
                         return false;
                     }
                <%}%>

                return true;
            }
            
            function CambiaClase (obj, clase){
                obj.className = clase;
            }
            
            function Formatea(obj, clase){
                CambiaClase(obj, clase);
                obj.value = formato_numero(obj.value.replace(',',''),2,'.',',');
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
            }*/
            
            function CargaSueldo(obj, clase){
                CambiaClase(obj,clase);
                puesto = obj.value;
                <%
                for (int i=0; i < puestos.size(); i++){
                    Puestos p = puestos.get(i);
                %>
                    if (puesto == '<%=p.getIdPuestos()%>'){
                        var sueldo = document.getElementById('sueldo');
                        sueldo.value = formato_numero('<%=p.getSalario().toString()%>',2,'.',',');
                    }
                <% } %>
            }
        </script>
    </body>
</html>