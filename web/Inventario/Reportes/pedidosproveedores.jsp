<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.util.Date, java.text.NumberFormat, java.text.SimpleDateFormat, Modelo.Entidades.Sucursal, Modelo.Entidades.Ruta, Modelo.Entidades.Detalle, Modelo.Entidades.Almacen, Modelo.Entidades.Ubicacion"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
Ruta rtSel = datosS.get("ruta")!=null?(Ruta)datosS.get("ruta"):new Ruta();
String matriz = datosS.get("matriz").toString();
SimpleDateFormat ftofecha = new SimpleDateFormat("dd-MM-yyyy");
String fechaI = ftofecha.format((Date)datosS.get("fechai"));
String fechaF = ftofecha.format((Date)datosS.get("fechaf"));
/*String fechaI = "", fechaIN = "", fechaF = "", fechaFN = "";
fechaI = format.format((Date)datosS.get("fechai"));
fechaF = format.format((Date)datosS.get("fechaf"));
fechaIN = fechaI.substring(8,10) + "-" + fechaI.substring(5,7) + "-" + fechaI.substring(0, 4);
fechaFN = fechaF.substring(8,10) + "-" + fechaF.substring(5,7) + "-" + fechaF.substring(0, 4);*/
NumberFormat formato = new DecimalFormat("#,##0.00");
if (paso == 1){
    fechaI = datosS.get("fechaini").toString();
    /*if (!fechaI.equals(""))
        fechaIN =fechaI.substring(8,10) + "-" + fechaI.substring(5,7) + "-" + fechaI.substring(0, 4);
    fechaF = datosS.get("fechafin").toString();
    if (!fechaF.equals(""))
        fechaFN =fechaF.substring(8,10) + "-" + fechaF.substring(5,7) + "-" + fechaF.substring(0, 4);*/
}
List<Almacen> alms = (List<Almacen>)datosS.get("almacenes");
List<Ubicacion> ubis = (List<Ubicacion>)datosS.get("ubicaciones");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
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
        
        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnCalcular" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnGenerar" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnGenerar2" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-minus"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-wrench"
		}
            });
            $( "#btnAgregar" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
            $( "#btnCancelEdicCants" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
        });
        </script>
    <!-- Jquery UI -->
        <title></title>
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
        <br>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Entradas/pedidosB.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GENERAR PEDIDOS A PROVEEDORES
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmPedidosProv" name="frmPedidosProv" action="<%=CONTROLLER%>/Gestionar/PedidosProv" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%" align="center">
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
                                                <%--<style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>--%>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 180px"
                                                        onchange="CargaRutas(this.value)" <%if (matriz.equals("0")){%>disabled<%}%>>
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
                                            <td width="15%" align="center">
                                                <select id="ruta" name="ruta" class="combo" style="width: 180px" onchange="OcultaListado()">
                                                    <option value="">Elija la Ruta...</option>
                                                    <option value="-1" <%if (rtSel.getId()==-1){%>
                                                                        selected
                                                                <%}%>>TODAS LAS RUTAS</option>
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
                                                <input id="fechaini" name="fechaini" type="text" class="text" readonly value="<%=fechaI%>"
                                                       title="Ingrese la fecha inicial del período a consultar" style="width:120px"/>
                                                
                                                <%--<input id="fechaini" name="fechaini" value="<%=fechaI%>" type="hidden">
                                                <input id="rgFechaIni" name="rgFechaIni" class="cajaDatos" style="width:120px" type="text" value="<%=fechaIN%>"
                                                        onchange="cambiaFecha(this.value,'fechaini')" onfocus="displayCalendar(document.frmPedidosProv.rgFechaIni,'dd-mm-yyyy',document.frmPedidosProv.rgFechaIni)"
                                                        tabindex="3" readonly>&nbsp;
                                                <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                    onclick="displayCalendar(document.frmPedidosProv.rgFechaIni,'dd-mm-yyyy',document.frmPedidosProv.rgFechaIni)"
                                                    title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                    onclick="limpiar('rgFechaIni', 'fechaini')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                --%>
                                            </td>
                                            <td width="15%">
                                                <span class="etiquetaB">Al:</span>
                                                <input id="fechafin" name="fechafin" type="text" class="text" readonly value="<%=fechaF%>"
                                                       title="Ingrese la fecha inicial del período a consultar" style="width:120px"/>
                                                <%--<input id="fechafin" name="fechafin" value="<%=fechaF%>" type="hidden">
                                                <input id="rgFechaFin" name="rgFechaFin" class="cajaDatos" style="width:120px" type="text" value="<%=fechaFN%>"
                                                        onchange="cambiaFecha(this.value,'fechafin')" 
                                                        onfocus="displayCalendar(document.frmPedidosProv.rgFechaFin,'dd-mm-yyyy',document.frmPedidosProv.rgFechaFin)"
                                                        tabindex="4" readonly>&nbsp;
                                                <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                    onclick="displayCalendar(document.frmPedidosProv.rgFechaFin,'dd-mm-yyyy',document.frmPedidosProv.rgFechaFin)"
                                                    title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                    onclick="limpiar('rgFechaFin', 'fechafin')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                --%>
                                            </td>
                                            <td width="15%" align="right">
                                                <select id="tipopedido" name="tipopedido" class="combo" style="width: 220px">
                                                    <option value="1">PEDIDOS CORPORATIVOS</option>
                                                    <option value="2">PEDIDOS LOCALES</option>
                                                </select>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnCalcular" href="javascript: CalcularClick()"
                                                    style="width: 100px; font-weight: bold; color: #0B610B;" title="Calcular">
                                                    Calcular
                                                </a>
                                                <a id="btnGenerar" href="javascript: GenerarClick()"
                                                    style="width: 100px; font-weight: bold; color: #0B610B; display: none" title="Generar los pedidos">
                                                    Generar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <div id="almaubi" style="display: none">
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="45%" align="center">
                                                    <span class="etiquetaB">Almacen:</span>
                                                    <select id="almacen" name="almacen" class="combo" style="width: 200px"
                                                            onchange="CargaUbicaciones(this.value)">
                                                        <option value="">Elija el Almacén...</option>
                                                    <%
                                                        for (int i=0; i < alms.size(); i++){
                                                            Almacen al = alms.get(i);
                                                    %>
                                                        <option value="<%=al.getId()%>"><%=al.getDescripcion()%></option>
                                                    <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                                <td width="40%" align="center">
                                                    <span class="etiquetaB">Ubicacion:</span>
                                                    <select id="ubicacion" name="ubicacion" class="combo" style="width: 200px">
                                                        <option value="">Elija la Ubicación...</option>
                                                    </select>
                                                </td>
                                                <td width="15%">
                                                    <a id="btnGenerar2" href="javascript: Generar2Click()"
                                                        style="width: 100px; font-weight: bold; color: #0B610B;" title="Generar los pedidos">
                                                        Generar
                                                    </a>
                                                    <%--<style>#btnGenerar2 a{display:block;color:transparent;} #btnGenerar2 a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnGenerar2" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Generar los pedidos">
                                                                <a href="javascript: Generar2Click()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/generarped.png);width:180px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>--%>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <%--<div id="mensaje" style="display: none">
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="subtitulo">
                                                        Espere por favor, se est&aacute; realizando la acción solicitada...
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>--%>
                                    <div id="listado">
                                    <%if (paso==1){
                                        List<HashMap> acum = (List<HashMap>)datosS.get("acumulado");
                                        if (acum.isEmpty()){
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
                                        <table width="100%" class="tablaLista" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="60%" colspan="2" align="center">
                                                        <span>Producto</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Unidad</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Cantidad</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Existencia</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Cantidad a Pedir</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                        <%
                                            for(int i=0; i < acum.size(); i++){
                                                HashMap prod = acum.get(i);
                                                Detalle det = (Detalle)prod.get("detalle");
                                                String exis = prod.get("existencia").toString();
                                                String pedir = prod.get("pedir").toString();
                                            %>
                                            <tr>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=det.getProducto().getClave()%></span>
                                                </td>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta"><%=det.getProducto().getDescripcion()%></span>
                                                </td>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=det.getUnidad().getDescripcion()%></span>
                                                </td>
                                                <td width="10%" align="right">
                                                    <span class="etiqueta"><%=formato.format(det.getCantidad())%></span>
                                                </td>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=exis%></span>
                                                </td>
                                                <td width="10%" align="right">
                                                    <span class="etiqueta"><%=pedir%></span>
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
            </div>
            <div id="procesando" style="display: none">
                <table id="tbprocesando" align="center" width="100%">
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
                if (paso==1){
                    List<HashMap> ac = (List<HashMap>)datosS.get("acumulado");
                    if (!ac.isEmpty()){
                    %>
                       var btnGenerar = document.getElementById('btnGenerar');
                       btnGenerar.style.display = '';
                    <%
                    }
                }%>
                var tipopedido = document.getElementById("tipopedido");
                <%if (sucSel.getTipo()==0){%>
                    tipopedido.disabled = true;
                <%} else {%>
                    tipopedido.disabled = false;
                <%}%>
            }
                        
            function SalirClick(){
                var frm = document.getElementById('frmPedidosProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function OcultaListado(){
                var lista = document.getElementById('listado');
                lista.style.display='none';
                var btnGenerar = document.getElementById('btnGenerar');
                btnGenerar.style.display = 'none';
            }
            
            function CargaRutas(suc){
                OcultaListado();
                var rutas = document.getElementById("ruta");
                rutas.length = 0;
                rutas.options[0] = new Option('Elija la Ruta...','');
                var tipopedido = document.getElementById("tipopedido");
                if (suc != ''){
                    if (suc=='3'){
                        tipopedido.options[0].selected=true;
                        tipopedido.disabled = true;
                    } else {
                        tipopedido.disabled = false;
                    }
                    var frm = document.getElementById('frmPedidosProv');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Reportes/pedidosproveedores.jsp';
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
                    Espera();
                    var frm = document.getElementById('frmPedidosProv');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Reportes/pedidosproveedores.jsp';
                    paso.value = '1';
                    frm.submit();
                }
            }
            
            function CargaUbicaciones(almacen){
                var ubi = document.getElementById('ubicacion');
                ubi.length = 0;
                ubi.options[0] = new Option('Elija la Ubicación...','');
                k=1;
                if (almacen.value != ''){
                    <%for (int i=0; i < ubis.size(); i++){
                        Ubicacion ub = ubis.get(i);
                    %>
                        if ('<%=ub.getAlmacen().getId()%>'==almacen){
                            ubi.options[k] = new Option('<%=ub.getDescripcion()%>','<%=ub.getId()%>');
                            k++;
                        }
                    <%}%>
                }
            }
            
            function GenerarClick(){
                <%if (alms.size()>1 || ubis.size()>1){%>
                     var almaubi = document.getElementById('almaubi');
                     almaubi.style.display = '';
                     return;
                <%}%>
                Espera();
                var frm = document.getElementById('frmPedidosProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Reportes/pedidosgenerados.jsp';
                paso.value = '2';
                frm.submit();
            }
            
            function Generar2Click(){
                var alm = document.getElementById('almacen');
                var ubi = document.getElementById('ubicacion');
                if (alm.value == ''){
                    MostrarMensaje('No ha definido el Almacén');
                    return;
                }
                if (ubi.value == ''){
                    MostrarMensaje('No ha definido la Ubicación');
                    return;
                }
                Espera();
                var frm = document.getElementById('frmPedidosProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Reportes/pedidosgenerados.jsp';
                paso.value = '2';
                frm.submit();
            }
        </script>
    </body>
</html>