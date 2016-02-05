
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.Date, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Serie"%>
<%@page import="java.util.List, Modelo.Entidades.Proveedor, Modelo.Entidades.Cabecera, Modelo.Entidades.Cliente"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    List<TipoMov> tiposmovs = (List<TipoMov>)datosS.get("otrostiposmovs");
    String titulo = datosS.get("titulo").toString();
    Date dhoy = (Date)datosS.get("hoy");
    String shoy = dhoy.toString();
    String hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
    String imagen = "inventarioB.png", tipbtn = "Agregar Detalle", btn = "agregardet.png";
    Cabecera cab = new Cabecera();
    String serie = "", folio = "";
    TipoMov tipoMov = new TipoMov();
    if (datosS.get("accion").toString().equals("editar")){
        imagen = "inventarioC.png";
        cab = (Cabecera)datosS.get("cabecera");
        tipoMov = cab.getTipomov();
        serie = cab.getSerie().getSerie();
        folio = Integer.toString(cab.getFolio());
        shoy = cab.getFechaCaptura().toString();
        hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
        tipbtn = "Editar Detalle";
        btn = "editardet.png";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%" colspan="2">
                    <div class="titulo" align="center">
                        Gestionar Movimientos - <%=titulo%>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="50%" align="rigth">
                    <div class="titulo" align="center">
                        Sucursal: <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
                <td width="50%" align="left">
                    <div class="titulo" align="center">
                        Tipo de Movimiento: <%=tmovSel.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMov" name="frmNuevoMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="60%" align="left">
                                                    <span class="etiqueta">Movimiento:</span>
                                                    <select id="movimiento" name="movimiento" class="combo" style="width: 300px"
                                                            onchange="CargaSerie(this.value)">
                                                        <option value="">Elija el Movimiento...</option>
                                                        <%
                                                        for (int i=0; i < tiposmovs.size(); i++){
                                                            TipoMov tm = tiposmovs.get(i);
                                                        %>
                                                        <option value="<%=tm.getId()%>" 
                                                                <%if (tm.getId()==tipoMov.getId()){%>selected<%}%>>
                                                            <%=tm.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                                <td width="40%" align="right">
                                                    <span class="etiqueta">Fecha:</span>
                                                    <input id="fecha" name="fecha" value="<%=shoy%>" type="hidden">
                                                    <input id="rgFecha" name="rgFecha" style="width:120px; text-align: center" type="text" value="<%=hoyN%>" onchange="cambiaFecha(this.value,'fecha')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmNuevoMov.rgFecha,'dd-mm-yyyy',document.frmNuevoMov.rgFecha)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFecha', 'fecha')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%" align="center">
                                                    <span class="etiqueta">Serie:</span>
                                                    <input id="serie" name="serie" type="text" style="width: 100px; text-align: center;" value="<%=serie%>" readonly>
                                                </td>
                                                <td width="50%" align="center">
                                                    <span class="etiqueta">Folio:</span>
                                                    <input id="folio" name="folio" type="text" style="width: 100px; text-align: center;" value="<%=folio%>" readonly>
                                                </td>                                                
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="40%" align="left">
                                        &nbsp;
                                    </td>
                                    <td width="20%" align="left">
                                        <style>#btnGuardar a{display:block;color:transparent;} #btnGuardar a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="20%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="<%=tipbtn%>">
                                                    <a href="javascript: DetalleClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/<%=btn%>);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="20%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
        <script language="javascript">
            function CargaPagina(){                
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                if (datosS.get("accion").toString().equals("editar")){
                %>
                    var guardar = document.getElementById('btnGuardar');
                    guardar.style.display = '';
                <%
                }
                %>
            }

            function limpiar(nombreObj1, nombreObj2)
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
            
            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function DetalleClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/detallemov.jsp';
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
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    frm.pasoSig.value = '5';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var mov = document.getElementById('movimiento');
                if (mov.value == ''){
                    Mensaje('El Movimiento no ha sido establecido');
                    return false;
                }
                
                var fecha = document.getElementById('fecha');
                if (fecha.value == ''){
                    Mensaje('La fecha no ha sido establecida');
                    return false;
                }
                
                return true;
            }
        
            function CargaSerie(tipo){
                var serie = document.getElementById('serie');
                var folio = document.getElementById('folio');
                serie.value = '';
                folio.value = '';
                <%
                for (int i=0; i < tiposmovs.size(); i++){
                    TipoMov tipm = tiposmovs.get(i);
                %>
                    if (tipo == '<%=tipm.getId()%>'){
                        serie.value = '<%=tipm.getSerie().getSerie()%>';
                        folio.value = '<%=tipm.getSerie().getFolio().intValue()%>';
                    }
                <%
                }
                %>
            }
        </script>
    </body>
</html>