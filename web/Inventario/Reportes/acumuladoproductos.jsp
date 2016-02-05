<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.Date, java.text.SimpleDateFormat, Modelo.Entidades.Sucursal, Modelo.Entidades.Ruta, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Cliente"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
Ruta rtSel = datosS.get("ruta")!=null?(Ruta)datosS.get("ruta"):new Ruta();
String matriz = datosS.get("matriz").toString();
SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
String fechaI = "", fechaIN = "", fechaF = "", fechaFN = "";
fechaIN = formato.format((Date)datosS.get("fechai"));
fechaFN = formato.format((Date)datosS.get("fechaf"));
//fechaIN = fechaI.substring(8,10) + "-" + fechaI.substring(5,7) + "-" + fechaI.substring(0, 4);
//fechaFN = fechaF.substring(8,10) + "-" + fechaF.substring(5,7) + "-" + fechaF.substring(0, 4);


if (paso == 1){
    fechaI = datosS.get("fechaini").toString();
    if (!fechaI.equals(""))
        fechaIN =datosS.get("fechaini").toString();//fechaI.substring(8,10) + "-" + fechaI.substring(5,7) + "-" + fechaI.substring(0, 4);
    fechaF = datosS.get("fechafin").toString();
    if (!fechaF.equals(""))
        fechaFN =datosS.get("fechafin").toString();//fechaF.substring(8,10) + "-" + fechaF.substring(5,7) + "-" + fechaF.substring(0, 4);
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
        <title></title>-->
    <!-- Jquery UI -->
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-custom.css" />
        <!--<link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-botones.css" />-->
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
            $( "#fechaini" ).datepicker({
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
            $( "#btnAcumulado" ).button({
                icons: {
                    primary: "ui-icon-note"
		}
            });
            $( "#btnProductos" ).button({
                icons: {
                    primary: "ui-icon-note"
		}
            });
            $( "#btnGenerar" ).button({
                icons: {
                    primary: "ui-icon-arrowthick-1-s"
		}
            });
            $( "#btnCambios" ).button({
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
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <!--aquí poner la imagen asociada con el proceso-->
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        PRODUCTOS POR RUTA Y CT
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmAcumProd" name="frmAcumProd" action="<%=CONTROLLER%>/Gestionar/AcumProd" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="cts" name="cts" type="hidden" value=""/>
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
                                                   background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="20%" align="left">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 250px"
                                                        onchange="CargaRutas(this.value)" <%if (matriz.equals("0")){%>disabled<%}%> title="Elija la sucursal">
                                                    <option value="">Elija la Sucursal...</option>
                                                <%
                                                    List<Sucursal> sucursales = datosS.get("sucursales")!=null?(List<Sucursal>)datosS.get("sucursales"):new ArrayList<Sucursal>();
                                                    for (int i=0; i < sucursales.size(); i++){
                                                        Sucursal suc = sucursales.get(i);
                                                    %>
                                                        <option value="<%=suc.getId()%>"
                                                            <%if (sucSel.getId()==suc.getId()){%>
                                                                selected
                                                            <%}%>>
                                                            <%=suc.getDatosfis().getRazonsocial()%>
                                                        </option>
                                                    <%
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="20%" align="left">
                                                <select id="ruta" name="ruta" class="combo" style="width: 250px" onchange="OcultaListado()" title="Elija la ruta">
                                                    <option value="">Elija la Ruta...</option>
                                                <%
                                                    List<Ruta> rutas = datosS.get("rutas")!=null?(List<Ruta>)datosS.get("rutas"):new ArrayList<Ruta>();
                                                    for (int i=0; i < rutas.size(); i++){
                                                        Ruta rt = rutas.get(i);
                                                    %>
                                                        <option value="<%=rt.getId()%>"
                                                                <%if (rtSel.getId()==rt.getId()){%>
                                                                        selected
                                                                <%}%>><%=rt.getDescripcion()%>
                                                        </option>
                                                    <%
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="15%" align="right">
                                                <span class="etiquetaB">Del:</span>
                                                <input id="fechaini" name="fechaini" type="text" class="text" readonly value="<%=fechaIN%>"
                                                    title="Ingrese la fecha inicial" style="width: 150px;"/>
                                            </td>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Al:</span>
                                                <input id="fechafin" name="fechafin" type="text" class="text" readonly value="<%=fechaFN%>"
                                                    title="Ingrese la fecha final" style="width: 150px;"/>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnGenerar" href="javascript: CalcularClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar">
                                                    Mostrar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%">
                                        <tr>
                                            <td width="40%" align="left">&nbsp;
                                            </td>
                                            <td width="15%" align="left">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir CT's a surtir">
                                                    Imprimir CT's
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <a id="btnAcumulado" href="javascript: AcumuladoClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir Acumulado de Productos">
                                                    Acumulado
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <a id="btnProductos" href="javascript: ProdsxCTClick()"
                                                   style="width: 180px; font-weight: bold; color: #0B610B; display: none" title="Imprimir Productos de CT's seleccionados">
                                                    Productos de CT's
                                                </a>
                                            </td>
                                            <td width="15%" align="left">
                                                <a id="btnCambios" href="javascript: CambiosxCTClick()"
                                                   style="width: 180px; font-weight: bold; color: #0B610B; display: none" title="Imprimir Productos a cambio de CT's seleccionados">
                                                    Cambios de CT's
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <div id="mensaje" style="display: none">
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="subtitulo">
                                                        Espere por favor, se está realizando el cálculo...
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div id="listado">
                                    <%if (paso==1){
                                        List<CentroDeTrabajo> cts = (List<CentroDeTrabajo>)datosS.get("cts");
                                        if (cts.isEmpty()){
                                        %>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="subtitulo">No se encontraron productos a entregar</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <%
                                        } else {
                                        %>
                                        <table width="80%" class="tablaLista" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="50%" align="center">
                                                        <span>Cliente</span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span>Centro de Trabajo</span>
                                                    </td>
                                                    <td width="20%" align="center">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                        <%
                                            for(int i=0; i < cts.size(); i++){
                                                CentroDeTrabajo ct = cts.get(i);
                                                Cliente cli = ct.getCliente();
                                            %>
                                            <tr>
                                                <td width="50%" align="center">
                                                    <span class="etiqueta">
                                                        <%
                                                        if (cli.getTipo()==0){
                                                        %>
                                                            <%=cli.getDatosFiscales().getRazonsocial()%>
                                                        <% } else { %>
                                                            <%=cli.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                        <% } %>
                                                    </span>
                                                </td>
                                                <td width="30%" align="center">
                                                    <span class="etiqueta"><%=ct.getNombre()%></span>
                                                </td>
                                                <td width="20%" align="center">
                                                    <input id="chkct<%=i%>" value="<%=ct.getId()%>" type="checkbox" checked>
                                                </td>
                                            </tr>
                                            <%
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                            <%
                                        }
                                    }
                                    %>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
        <script language="javascript">
            function MostrarMensaje(mensaje){
                var mens = document.getElementById('alerta');
                mens.textContent = mensaje;
                $( "#dialog-message" ).dialog( "open" );
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
                if (paso==1){
                    List<CentroDeTrabajo> cts = (List<CentroDeTrabajo>)datosS.get("cts");
                    if (!cts.isEmpty()){
                    %>
                       var imprcts = document.getElementById('btnImprimir');
                       var acumbas = document.getElementById('btnAcumulado');
                       var cambios = document.getElementById('btnCambios');
                       var prodsxct = document.getElementById('btnProductos');
                       imprcts.style.display = '';
                       acumbas.style.display = '';
                       cambios.style.display = '';
                       prodsxct.style.display = '';
                    <%
                    }
                }
                %>
            }
                        
            function SalirClick(){
                var frm = document.getElementById('frmAcumProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function OcultaListado(){
                var lista = document.getElementById('listado');
                lista.style.display='none';
                var imprcts = document.getElementById('btnImprimir');
                var acumbas = document.getElementById('btnAcumulado');
                var cambios = document.getElementById('btnCambios');
                var prodsxct = document.getElementById('btnProductos');
                imprcts.style.display = 'none';
                acumbas.style.display = 'none';
                cambios.style.display = 'none';
                prodsxct.style.display = 'none';
            }
            
            function CargaRutas(suc){
                OcultaListado();
                var rutas = document.getElementById("ruta");
                rutas.length = 0;
                rutas.options[0] = new Option('Elija la Ruta...','');
                if (suc != ''){
                    var frm = document.getElementById('frmAcumProd');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Reportes/acumuladoproductos.jsp';
                    paso.value = '-1';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var sucsel = document.getElementById('sucursalsel');
                if (sucsel.value == ''){
                    MostrarMensaje('No ha establecido la sucursal');
                    return false;
                }
                
                var ruta = document.getElementById('ruta');
                if (ruta.value == ''){
                    MostrarMensaje('No ha establecido la ruta');
                    return false;
                }
                
                var fechaini = document.getElementById('fechaini');
                var fechafin = document.getElementById('fechafin');
                if (fechaini.value == '' && fechafin.value == ''){
                    MostrarMensaje('Debe establecer al menos una fecha del período');
                    return false;
                }
                
                return true;
            }
            
            function CalcularClick(){
                if (ValidaRequeridos()){
                    /*var mens = document.getElementById('mensaje');
                    mens.style.display = '';
                    var lis = document.getElementById('listado');
                    lis.style.display = 'none';*/
                    var frm = document.getElementById('frmAcumProd');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Reportes/acumuladoproductos.jsp';
                    paso.value = '1';
                    frm.submit();
                }
            }
            
            function ValidaCts(){
                var cts = document.getElementById('cts');
                cts.value = '';
            <%
                if (paso==1){
                    List<CentroDeTrabajo> cts = (List<CentroDeTrabajo>)datosS.get("cts");
                    for (int i=0; i < cts.size(); i++){
            %>
                        var chkct = document.getElementById('chkct<%=i%>');
                        if (chkct.checked){
                            if (cts.value == '')
                                cts.value = chkct.value;
                            else
                                cts.value += ','+chkct.value;
                        }
            <%
                    }
                }
            %>
                if (cts.value == ''){
                    MostrarMensaje('Debe seleccionar al menos un Centro de Trabajo');
                    return false;
                }
                return true;
            }
            
            function ImprimirClick(){
                if (ValidaCts()){
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/AcumProd'+'&paso=3&dato1='+cts.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function AcumuladoClick(){
                if (ValidaCts()){
                    var cts = document.getElementById('cts');
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/AcumProd'+'&paso=2&dato1='+cts.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function AcumBasClick(){
                if (ValidaCts()){
                    var cts = document.getElementById('cts');
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/AcumProd'+'&paso=2&dato1='+cts.value+'&dato2=0',
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function AcumCamClick(){
                if (ValidaCts()){
                    var cts = document.getElementById('cts');
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/AcumProd'+'&paso=2&dato1='+cts.value+'&dato2=1',
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function ProdsxCTClick(){
                if (ValidaCts()){
                    var cts = document.getElementById('cts');
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/AcumProd'+'&paso=4&dato1='+cts.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function CambiosxCTClick(){
                if (ValidaCts()){
                    var cts = document.getElementById('cts');
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/AcumProd'+'&paso=5&dato1='+cts.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
        </script>
    </body>
</html>