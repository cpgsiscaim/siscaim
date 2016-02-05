<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.Date, java.text.SimpleDateFormat, Modelo.Entidades.Sucursal, Modelo.Entidades.Cabecera, Modelo.Entidades.TipoMov, Modelo.Entidades.Ruta"%>
<%@page import="Modelos.UtilMod, java.text.DecimalFormat, java.text.NumberFormat"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Cabecera> listado = new ArrayList<Cabecera>();
List<Float> totales = new ArrayList<Float>();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
String matriz = datosS.get("matriz").toString();
TipoMov tmovSel = new TipoMov();
SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
String feci = formato.format((Date)datosS.get("fechai"));
String fecf = formato.format((Date)datosS.get("fechaf"));
NumberFormat ftocant= new DecimalFormat("#,##0.00");
//String sfeci = feci.substring(8,10) + "-" + feci.substring(5,7) + "-" + feci.substring(0, 4);
//String sfecf = fecf.substring(8,10) + "-" + fecf.substring(5,7) + "-" + fecf.substring(0, 4);
if (paso != 0){
    //sucSel = 
    tmovSel = (TipoMov)datosS.get("tipomovSel");
    listado = datosS.get("listadoCab")!=null?(List<Cabecera>)datosS.get("listadoCab"):new ArrayList<Cabecera>();
    totales = datosS.get("listadoCab")!=null?(List<Float>)datosS.get("totales"):new ArrayList<Float>();
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <!--<link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>-->
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
            $( "#fechai" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechaf" ).datepicker({
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
            $( "#btnMostrar" ).button({
                icons: {
                    primary: "ui-icon-search"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnFiltrar" ).button({
                icons: {
                    primary: "ui-icon-zoomin"
		}
            });
            $( "#btnQuitar" ).button({
                icons: {
                    primary: "ui-icon-zoomout"
		}
            });
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            $( "#btnAplicados" ).button({
                icons: {
                    primary: "ui-icon-pin-s"
		}
            });
            $( "#btnImportarCot" ).button({
                icons: {
                    primary: "ui-icon-copy"
		}
            });
            $( "#btnImportarPed" ).button({
                icons: {
                    primary: "ui-icon-copy"
		}
            });
            $( "#btnAplicar" ).button({
                icons: {
                    primary: "ui-icon-cart"
		}
            });
            $( "#btnAplicarFil" ).button({
                icons: {
                    primary: "ui-icon-check"
		}
            });
            $( "#btnOcultarFil" ).button({
                icons: {
                    primary: "ui-icon-close"
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
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <!--<br>-->
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarMov" name="frmGestionarMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idMov" name="idMov" type="hidden" value=""/>
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
                                            <td width="20%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="20%" align="center">
                                                <span class="etiquetaB">Del:</span>
                                                <input id="fechai" name="fechai" type="text" class="text" readonly value="<%=feci%>"
                                                       title="Ingrese la fecha inicial del período a consultar" onchange="OcultaLista()"/>
                                            </td>
                                            <td width="20%" align="center">
                                                <span class="etiquetaB">Al:</span>
                                                <input id="fechaf" name="fechaf" type="text" class="text" readonly value="<%=fecf%>"
                                                    title="Ingrese la fecha final del periodo a consultar" onchange="OcultaLista()"/>
                                            </td>
                                            <td width="20%" align="center">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px"
                                                        onchange="MostrarMovimientos()" <%if (matriz.equals("0")){%>disabled<%}%>
                                                        title="Elija la sucursal a consultar">
                                                    <option value="">Elija la Sucursal...</option>
                                                <%
                                                    List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                    if (sucursales!=null){
                                                        if (sucursales.size()!=0){
                                                            for (int i=0; i < sucursales.size(); i++){
                                                                Sucursal suc = sucursales.get(i);
                                                            %>
                                                                <option value="<%=suc.getId()%>"
                                                                        <%
                                                                        //if (paso!=0){
                                                                            //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                            if (sucSel.getId()==suc.getId()){
                                                                            %>
                                                                                selected
                                                                            <%
                                                                            }
                                                                        //}
                                                                        %>
                                                                        >
                                                                    <%=suc.getDatosfis().getRazonsocial()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="20%" align="center">
                                                <select id="tipomovsel" name="tipomovsel" class="combo" style="width: 250px"
                                                        onchange="MostrarMovimientos()" title="Elija el movimiento a consultar">
                                                    <option value="">Elija el Movimiento...</option>
                                                <%
                                                    List<TipoMov> tipos = (List<TipoMov>)datosS.get("tiposmovs");
                                                    if (tipos!=null){
                                                        if (tipos.size()!=0){
                                                            for (int i=0; i < tipos.size(); i++){
                                                                TipoMov tmov = tipos.get(i);
                                                            %>
                                                                <option value="<%=tmov.getId()%>"
                                                                        <%
                                                                        if (paso!=0){
                                                                            //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                            if (tmovSel.getId()==tmov.getId()){
                                                                            %>
                                                                                selected
                                                                            <%
                                                                            }
                                                                        }
                                                                        %>
                                                                        >
                                                                    <%=tmov.getDescripcion()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnMostrar" href="javascript: BuscarClick()"
                                                    style="width: 100px; font-weight: bold; color: #0B610B;" title="Buscar los movimientos">
                                                    Buscar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <div id="dvlistado">
                                    <table id="acciones" width="100%" style="display: none">
                                        <tr>
                                            <td width="5%" align="right">&nbsp;</td>
                                            <td width="15%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Inactivos">
                                                    Ver Inactivos
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnFiltrar" href="javascript: FiltrarClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Filtrar movimientos">
                                                    Filtrar
                                                </a>
                                                <a id="btnQuitar" href="javascript: QuitarFiltroClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Quitar el filtro de movimientos">
                                                    Quitar filtro
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir el movimiento seleccionado">
                                                    Imprimir
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnBaja" href="javascript: BajaClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Dar de baja los movimientos seleccionados">
                                                    Baja
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnEditar" href="javascript: EditarClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Editar el movimiento seleccionado">
                                                    Editar
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevoClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Crear un nuevo movimiento">
                                                    Nuevo
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="acciones2" width="100%" style="display: none">
                                        <tr>
                                            <td width="5%" align="right">&nbsp;</td>
                                            <td width="15%" align="center">
                                                <a id="btnAplicados" href="javascript: AplicadosClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver movimientos aplicados al inventario">
                                                    Aplicados
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnImportarCot" href="javascript: ImportarCotClick()"
                                                    style="width: 180px; font-weight: bold; color: #0B610B; display: none" title="Importar de cotización">
                                                    Importar de Cotización
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnImportarPed" href="javascript: ImportarPedClick()"
                                                    style="width: 180px; font-weight: bold; color: #0B610B; display: none" title="Importar de pedido">
                                                    Importar de Pedido
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnAplicar" href="javascript: AplicarInvClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Aplicar al inventario movimiento seleccionado">
                                                    Aplicar
                                                </a>
                                                <!--
                                                <style>#btnAplicar a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnAplicar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Aplicar a Inventario">
                                                            <a href="javascript: AplicarInvClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="40%" align="right">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <!-- Opciones de filtrado -->
                                    <div id="dvfiltrar" style="display: none">
                                    <table id="opcfiltro" width="100%">
                                        <tr>
                                            <td width="100%" colspan="5" align="left">
                                                <span class="etiquetaB">Establezca los filtros:</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="10%">
                                                <span class="etiquetaB">Folio:</span><br>
                                                <input id="filfolio" name="filfolio" class="text" type="text" style="width: 100px" value=""
                                                        onkeypress="return ValidaNums(event)" maxlength="4" tabindex="1"/>
                                            </td>
                                            <td width="25%">
                                                <span class="etiquetaB">
                                                    <%
                                                    if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
                                                        if (tmovSel.getCategoria()==1){
                                                        %>
                                                            Proveedor*:
                                                        <% } else { %>
                                                            Cliente*:
                                                            <input id="opccliente" name="opccliente" type="radio" value="0" checked/>
                                                            <span class="etiqueta">Razón Social</span>&nbsp;&nbsp;&nbsp;
                                                            <input id="opccliente" name="opccliente" type="radio" value="1"/>
                                                            <span class="etiqueta">Nombre</span>                                                            
                                                        <% }
                                                    } else {
                                                    %>
                                                        Movimiento*:
                                                    <%
                                                    }
                                                    %>
                                                    
                                                </span><br>
                                                <input id="filcliente" name="filcliente" class="text" type="text" style="width: 350px" value=""
                                                        onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                                                        maxlength="120" tabindex="2"/>
                                                <%--if (tmovSel.getId()!=7 && tmovSel.getId()!=8){%>
                                                <input id="opccliente" name="opccliente" type="radio" value="0" checked/>
                                                <span class="etiqueta">Razón Social</span>&nbsp;&nbsp;&nbsp;
                                                <input id="opccliente" name="opccliente" type="radio" value="1"/>
                                                <span class="etiqueta">Nombre</span>
                                                <%}--%>
                                            </td>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Contrato:*</span><br>
                                                <input id="filcontrato" name="filcontrato" class="text" type="text" style="width: 250px" value=""
                                                       onkeypress="return ValidaAlfaNums(event)" maxlength="20" onblur="Mayusculas(this)" tabindex="5"/>
                                            </td>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">C.T.:*</span><br>
                                                <input id="filct" name="filct" type="text" class="text" style="width: 250px" value=""
                                                       maxlength="120" onblur="Mayusculas(this)" tabindex="6"/>
                                            </td>
                                            <td width="25%" align="left">
                                                <span class="etiquetaB">Ruta:</span><br>
                                                <select id="ruta" name="ruta" class="combo" style="width: 200px">
                                                    <option value="">Elija la Ruta...</option>
                                                    <%
                                                    List<Ruta> rutas = datosS.get("rutas")!=null?(List<Ruta>)datosS.get("rutas"):new ArrayList<Ruta>();
                                                    for (int i=0; i < rutas.size(); i++){
                                                        Ruta rt = rutas.get(i);
                                                    %>
                                                    <option value="<%=rt.getId()%>"><%=rt.getDescripcion()%></option>
                                                    <%
                                                    }
                                                    %>
                                                </select>
                                            </td>
                                            <%--
                                            <td width="40%">
                                                
                                                <table width="100%">
                                                    <tr>
                                                        <td colspan="2" width="100%">
                                                            <span class="etiquetaB">Período:</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="50%">
                                                            <span class="etiquetaB">Del:</span>
                                                            <input id="fechaini" name="fechaini" value="" type="hidden">
                                                            <input id="rgFechaIni" name="rgFechaIni" class="cajaDatos" style="width:120px" type="text" value=""
                                                                   onchange="cambiaFecha(this.value,'fechaini')" onfocus="displayCalendar(document.frmGestionarMov.rgFechaIni,'dd-mm-yyyy',document.frmGestionarMov.rgFechaIni)"
                                                                   tabindex="3" readonly>&nbsp;
                                                            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                                onclick="displayCalendar(document.frmGestionarMov.rgFechaIni,'dd-mm-yyyy',document.frmGestionarMov.rgFechaIni)"
                                                                title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                                onclick="limpiar('rgFechaIni', 'fechaini')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                        </td>
                                                        <td width="50%">
                                                            <span class="etiquetaB">Al:</span>
                                                            <input id="fechafin" name="fechafin" value="" type="hidden">
                                                            <input id="rgFechaFin" name="rgFechaFin" class="cajaDatos" style="width:120px" type="text" value=""
                                                                   onchange="cambiaFecha(this.value,'fechafin')" 
                                                                   onfocus="displayCalendar(document.frmGestionarMov.rgFechaFin,'dd-mm-yyyy',document.frmGestionarMov.rgFechaFin)"
                                                                   tabindex="4" readonly>&nbsp;
                                                            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                                onclick="displayCalendar(document.frmGestionarMov.rgFechaFin,'dd-mm-yyyy',document.frmGestionarMov.rgFechaFin)"
                                                                title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                                onclick="limpiar('rgFechaFin', 'fechafin')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>--%>
                                        </tr>
                                    </table>
                                    <%--
                                    <table id="opcfiltro2" width="100%" style="display: none">
                                        <tr>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">Contrato:*</span><br>
                                                <input id="filcontrato" name="filcontrato" type="text" style="width: 200px" value=""
                                                       onkeypress="return ValidaAlfaNums(event)" maxlength="20" onblur="Mayusculas(this)" tabindex="5"/>
                                            </td>
                                            <td width="20%" align="left">
                                                <span class="etiquetaB">C.T.:*</span><br>
                                                <input id="filct" name="filct" type="text" style="width: 350px" value=""
                                                       maxlength="120" onblur="Mayusculas(this)" tabindex="6"/>
                                            </td>
                                            <td width="60%" align="left">
                                                <span class="etiquetaB">Ruta:</span><br>
                                                <select id="ruta" name="ruta" class="combo" style="width: 300px">
                                                    <option value="">Elija la Ruta...</option>
                                                    <%
                                                    List<Ruta> rutas = datosS.get("rutas")!=null?(List<Ruta>)datosS.get("rutas"):new ArrayList<Ruta>();
                                                    for (int i=0; i < rutas.size(); i++){
                                                        Ruta rt = rutas.get(i);
                                                    %>
                                                    <option value="<%=rt.getId()%>"><%=rt.getDescripcion()%></option>
                                                    <%
                                                    }
                                                    %>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    --%>
                                    <table id="btnfiltro" width="100%">
                                        <tr>
                                            <td width="60%" align="left">
                                                <input id="chkExacto" name="chkExacto" type="checkbox"/>
                                                <span class="etiquetaB">Coincidencias Exactas</span><br>
                                                <span class="etiquetaC">Aplica sólo a los campos marcados con *</span>
                                            </td>
                                            <td width="20%" align="right">
                                                <a id="btnAplicarFil" href="javascript: AplicarFiltrosClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Aplicar filtros establecidos">
                                                    Aplicar
                                                </a>
                                                <!--<style>#btnAplicarFil a{display:block;color:transparent;} #btnAplicarFil a:hover{background-position:left bottom;}a#btnAplicarFila {display:none}</style>
                                                <table id="btnAplicarFil" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Aplicar Filtros">
                                                            <a href="javascript: AplicarFiltrosClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;" tabindex="7"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->                                                    
                                            </td>
                                            <td width="20%" align="left">
                                                <a id="btnOcultarFil" href="javascript: OcultarFiltrosClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Ocultar filtros">
                                                    Ocultar
                                                </a>
                                                <!--<style>#btnOcultarFil a{display:block;color:transparent;} #btnOcultarFil a:hover{background-position:left bottom;}a#btnAplicarFila {display:none}</style>
                                                <table id="btnOcultarFil" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ocultar Filtros">
                                                            <a href="javascript: OcultarFiltrosClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/ocultar.png);width:150px;height:30px;display:block;" tabindex="8"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->                                                    
                                            </td>
                                        </tr>
                                    </table>
                                    <hr id="lnfiltro" style="display: none">
                                    </div>
                                    <!-- Opciones de filtrado -->
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (paso != 0 && sucSel.getId()!=0){
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Movimientos registrados con la Sucursal y el Tipo de Movimiento seleccionados 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="5%">&nbsp;</td>
                                                <td align="center" width="5%">
                                                    <span>Serie</span>
                                                </td>
                                                <td align="center" width="5%">
                                                    <span>Folio</span>
                                                </td>
                                                <td align="center" width="8%">
                                                    <span>Fecha</span>
                                                </td>
                                                <%
                                                String ancho = "67%", ancho1 = "20%", ancho2 = "20%";
                                                if (tmovSel.getId()==6){
                                                    ancho = "61%";
                                                } else if (tmovSel.getId()==20 || tmovSel.getId()==21){
                                                    ancho = "35%";
                                                }
                                                if (tmovSel.getId()!=7 && tmovSel.getId()!=8 && tmovSel.getId()!=20 && tmovSel.getId()!=21 && tmovSel.getId()!=25){%>
                                                    <td align="center" width="<%=ancho%>">                                               
                                                    <%if (tmovSel.getCategoria()==1){%>
                                                        <span>Proveedor</span>
                                                    <% } else { %>
                                                        <span>Cliente</span>
                                                    <% }%>
                                                    </td>
                                                <%}else if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                                                    <td align="center" width="<%=ancho%>">Cliente</td>
                                                    <td align="center" width="<%=ancho1%>">Contrato</td>
                                                    <td align="center" width="<%=ancho2%>">C.T.</td>
                                                <%} else if(tmovSel.getId()!=25){%>
                                                    <td align="center" width="<%=ancho%>">
                                                        <span>Movimiento</span>
                                                    </td>
                                                <%} else if (tmovSel.getId()==25){%>
                                                    <td align="center" width="77">
                                                        <span>Descripción</span>
                                                    </td>
                                                <%}
                                                if (tmovSel.getId()==6){
                                                %>
                                                <td align="center" width="14%" colspan="2">
                                                    <span>Factura Original</span>
                                                </td>
                                                <%
                                                }
                                                if (tmovSel.getId()!=25){
                                                %> 
                                                <td align="center" width="10%">
                                                    <span>Total</span>
                                                </td>
                                                <%}%>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Cabecera mov = listado.get(i);
                                                Float tot = totales.get(i);
                                                String fechaCap = mov.getFechaCaptura().toString();
                                                /*String fechaInv = mov.getFechaInventario()!=null?mov.getFechaInventario().toString():"";
                                                String fechaRec = mov.getFechaRecepcion()!=null?mov.getFechaRecepcion().toString():"";*/
                                                String fechaCapN =fechaCap.substring(8,10) + "-" + fechaCap.substring(5,7) + "-" + fechaCap.substring(0, 4);
                                                /*String fechaInvN =!fechaInv.equals("")?fechaInv.substring(8,10) + "-" + fechaInv.substring(5,7) + "-" + fechaInv.substring(0, 4):"";
                                                String fechaRecN =!fechaRec.equals("")?fechaRec.substring(8,10) + "-" + fechaRec.substring(5,7) + "-" + fechaRec.substring(0, 4):"";*/
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="chkmov<%=i%>" name="chkmov<%=i%>" type="checkbox" value="<%=mov.getId()%>">
                                                        <input id="radioMov" name="radioMov" type="radio" value="<%=mov.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <%=mov.getSerie().getSerie()%>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <%=mov.getFolio()%>
                                                    </td>
                                                    <td align="center" width="8%">
                                                        <span><%=fechaCapN%></span>
                                                    </td>
                                                    <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8 && tmovSel.getId()!=20 && tmovSel.getId()!=21 && tmovSel.getId()!=25){%>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getTipomov().getCategoria()==1?(mov.getProveedor().getTipo().equals("0")?mov.getProveedor().getDatosfiscales().getRazonsocial():mov.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()):
                                                            (mov.getCliente().getTipo()==0?mov.getCliente().getDatosFiscales().getRazonsocial():mov.getCliente().getDatosFiscales().getPersona().getNombreCompleto())
                                                            %>
                                                        </td>
                                                    <%} else if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getTipomov().getCategoria()==1?(mov.getProveedor().getTipo().equals("0")?mov.getProveedor().getDatosfiscales().getRazonsocial():mov.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()):
                                                            (mov.getCliente().getTipo()==0?mov.getCliente().getDatosFiscales().getRazonsocial():mov.getCliente().getDatosFiscales().getPersona().getNombreCompleto())
                                                            %>
                                                        </td>
                                                        <td align="left" width="<%=ancho1%>">
                                                            (<%=mov.getContrato().getContrato()%>) <%=mov.getContrato().getDescripcion()%>
                                                        </td>
                                                        <td align="left" width="<%=ancho2%>">
                                                            <%=mov.getCentrotrabajo().getNombre()%>
                                                        </td>
                                                    <%} else if (tmovSel.getId()!=25){ %>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getTipomov().getDescripcion()%>
                                                        </td>
                                                    <%} else if (tmovSel.getId()==25){ %>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getDescripcion()%>
                                                        </td>
                                                    <%}if (tmovSel.getId()==6){%>
                                                    <td align="center" width="5%">
                                                        <span><%=mov.getSerieOriginal()!=null?mov.getSerieOriginal():""%></span>
                                                    </td>
                                                    <td align="center" width="9%">
                                                        <span><%=mov.getFolioOriginal()!=0?mov.getFolioOriginal():""%></span>
                                                    </td>
                                                    <%} if (tmovSel.getId()!=25){%> 
                                                    <td align="right" width="10%">
                                                        <span><%=ftocant.format(tot)%></span>
                                                    </td>
                                                    <%}%>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
                                    }
                                    %>
                                    </table>
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
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->
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
                <%
                }
                HttpSession sesionHttp = request.getSession();
                if (sesion.isError())
                    sesion.setError(false);
                if (sesion.isExito())
                    sesion.setExito(false);
                sesionHttp.setAttribute("sesion", sesion);
                
                if (paso != 0){
                %>
                    var acciones = document.getElementById('acciones');
                    acciones.style.display = '';
                    var acciones2 = document.getElementById('acciones2');
                <%
                    switch (tmovSel.getId()){
                        case 6://compra
                            %>
                            acciones2.style.display = '';
                            var importarPed = document.getElementById('btnImportarPed');
                            importarPed.style.display = '';
                            <%
                            break;
                        case 7: case 8: case 20: case 21: case 25://otras entradas | salidas | salidas progs (20,21)
                            %>
                            acciones2.style.display = '';
                            <%
                            break;
                        case 10://facturacion
                            %>
                            acciones2.style.display = '';
                            var importarCot = document.getElementById('btnImportarCot');
                            importarCot.style.display = '';
                            <%
                            break;
                    }
                    if (listado.size()>0){
                        int banfiltro = Integer.parseInt(datosS.get("banfiltro")!=null?datosS.get("banfiltro").toString():"0");
                        if (banfiltro==0){
                    %>
                            var filtrar = document.getElementById('btnFiltrar');
                            filtrar.style.display = '';
                    <%
                        } else {
                    %>
                            var quitarfil = document.getElementById('btnQuitar');
                            quitarfil.style.display = '';
                    <%
                        }
                    }
                }
                %>
            }
            
            function Activa(fila){
                var idMov = document.getElementById('idMov');
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarMov.radioMov.checked = true;
                    idMov.value = document.frmGestionarMov.radioMov.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarMov.radioMov[fila];
                    radio.checked = true;
                    idMov.value = radio.value;
                <% } %>
                var impr = document.getElementById('btnImprimir');
                impr.style.display = '';
                var baja = document.getElementById('btnBaja');
                baja.style.display = '';
                var editar = document.getElementById('btnEditar');
                editar.style.display = '';
                var aplicar = document.getElementById('btnAplicar');
                aplicar.style.display='';
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '6';
                frm.submit();
            }
            
            function BajaClick(){
                mens = '¿Está seguro en dar de baja el Movimiento seleccionado?';
                sels = 0;
                movs = '';
                <%for (int i=0; i < listado.size(); i++){%>
                     var chk = document.getElementById('chkmov<%=i%>');
                     if (chk.checked){
                         sels++;
                         if (movs == '')
                             movs = chk.value;
                         else
                             movs += ','+chk.value;
                     }
                <%}%>
                var varios = document.getElementById('varios');
                if (sels>1){
                    mens = '¿Está seguro en dar de baja los Movimientos seleccionados?';
                    varios.value = movs;
                } else if (sels==1){
                    //desmarca el chk que haya quedado activado
                    <%for (int i=0; i < listado.size(); i++){%>
                        var chk = document.getElementById('chkmov<%=i%>');
                        if (chk.checked){
                            chk.checked = false;
                        }
                    <%}%>
                }
                
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar(mens);
                /*
                var resp = confirm(mens,'SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarMov');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    paso.value = '6';
                    frm.submit();
                }*/
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/movimientosinactivos.jsp';
                paso.value = '7';
                frm.submit();
            }
            
            function MostrarMovimientos(){
                var sucsel = document.getElementById('sucursalsel');
                var tmovsel = document.getElementById('tipomovsel');
                var fechai = document.getElementById('fechai');
                var fechaf = document.getElementById('fechaf');
                if (sucsel.value != '' && tmovsel.value != '' && fechai.value != '' && fechaf.value != ''){                    
                    /*var dvlis = document.getElementById('dvlistado');
                    dvlis.style.display = 'none';*/
                    Espera();
                    var frm = document.getElementById('frmGestionarMov');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    paso.value = '1';
                    frm.submit();
                }
            }
            
            function FiltrarClick(){
                var dvfil = document.getElementById('dvfiltrar');
                dvfil.style.display = '';
                var filcontr = document.getElementById('filcontrato');
                filcontr.readOnly = true;
                var filct = document.getElementById('filct');
                filct.readOnly = true;
                var ruta = document.getElementById('ruta');
                ruta.readOnly = true;
                <%if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                     filcontr.readOnly = false;
                     filct.readOnly = false;
                     ruta.readOnly = false;
                <%}%>
                /*var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/filtrarproveedores.jsp';
                paso.value = '';
                frm.submit();*/
                /*var opcfil = document.getElementById('opcfiltro');
                opcfil.style.display = '';
                var btnfil = document.getElementById('btnfiltro');
                btnfil.style.display = '';
                var lnfil = document.getElementById('lnfiltro');
                lnfil.style.display = '';
                var filfolio = document.getElementById('filfolio');
                filfolio.focus();*/
            }
            /*
            function QuitarFiltroClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '';
                frm.submit();                
            }
            */
            function DetalleClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/detallemov.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function AplicarInvClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/aplicarmov.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function ImportarPedClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/importarpedido.jsp';
                paso.value = '20';
                frm.submit();                
            }
            
            function ImportarCotClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/importarcotizacion.jsp';
                paso.value = '24';
                frm.submit();                
            }
            
            function AplicadosClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/movsaplicados.jsp';
                paso.value = '25';
                frm.submit();                
            }
            
            function SiguienteClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '62';
                frm.submit();                
            }

            function AnteriorClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '61';
                frm.submit();                
            }

            function PrincipioClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '60';
                frm.submit();                
            }

            function FinalClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '63';
                frm.submit();                
            }
            
            function ImprimirClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/imprimirmovimiento.jsp';
                paso.value = '26';
                frm.submit();                
            }
            
            function OcultarFiltrosClick(){
                var dvfil = document.getElementById('dvfiltrar');
                dvfil.style.display = 'none';
                <%--
                var opcfiltro = document.getElementById('opcfiltro');
                opcfiltro.style.display = 'none';
                var btnfiltro = document.getElementById('btnfiltro');
                btnfiltro.style.display = 'none';
                var lnfiltro = document.getElementById('lnfiltro');
                lnfiltro.style.display = 'none';
                <%if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                     var opcfil2 = document.getElementById('opcfiltro2');
                     opcfil2.style.display = 'none';
                <%}%>--%>
            }
            
            function ValidaFiltros(){
                var filfolio = document.getElementById('filfolio');
                var filcliente = document.getElementById('filcliente');
                /*var fechaini = document.getElementById('fechaini');
                var fechafin = document.getElementById('fechafin');*/
                var filcon = document.getElementById('filcontrato');
                var filct = document.getElementById('filct');
                var filruta = document.getElementById('ruta');
                if (filfolio.value == '' && filcliente.value == '' /*&& fechaini.value == '' && fechafin.value == ''*/){
                    <%if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                         if (filcon.value == '' && filct.value == '' && filruta.value == ''){
                             MostrarMensaje('Debe establecer al menos una opción de filtrado');
                             return false;
                         }
                    <%} else {%>
                            MostrarMensaje('Debe establecer al menos una opción de filtrado');
                            return false;
                    <%}%>
                }
                
                return true;
            }
            
            function AplicarFiltrosClick(){
                if (ValidaFiltros()){
                    Espera();
                    var frm = document.getElementById('frmGestionarMov');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    paso.value = '28';
                    frm.submit();                
                }
            }
            
            function limpiar(nombreObj1, nombreObj2)
            {
                obj = document.getElementById(nombreObj1);
                obj.value='';
                obj = document.getElementById(nombreObj2);
                obj.value='';
                var dvlis = document.getElementById('dvlistado');
                dvlis.style.display = 'none';
            }

            function cambiaFecha(fecha, nombreObj)
            {
                d = fecha.substr(0,2);
                m = fecha.substr(3,2);
                y = fecha.substr(6,4);
                txtFecha = document.getElementById(nombreObj);
                txtFecha.value=y+'-'+m+'-'+d;
                var dvlis = document.getElementById('dvlistado');
                dvlis.style.display = 'none';
            }
            
            function QuitarFiltroClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '29';
                frm.submit();                
            }
            
            function ImprimirXlsClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/imprimirmovimiento.jsp';
                paso.value = '30';
                frm.submit();
            }
            
            function BuscarClick(){
                MostrarMovimientos();
            }
            
            function OcultaLista(){
                var dvlis = document.getElementById('dvlistado');
                dvlis.style.display = 'none';
            }
        </script>
    </body>
</html>