<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Equipo, Modelo.Entidades.Servicio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String fecha = "", fechaN = "", factura = "", km = "", monto = "", descrip = "";
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo Servicio";
    String imagen = "inventarioB.png";
    Equipo activo = (Equipo)datosS.get("activo");
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Servicio";
        imagen = "inventarioC.png";
        Servicio serv = (Servicio)datosS.get("servicio");
        fecha = serv.getFecha().toString();
        fechaN = fecha.substring(8,10) + "-" + fecha.substring(5,7) + "-" + fecha.substring(0, 4);
        factura = serv.getFactura();
        km = Float.toString(serv.getKilometraje());
        monto = Float.toString(serv.getMonto());
        descrip = serv.getDescripcion();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Servicios - <%=titulo%><br>
                        ACTIVO: <%=activo.getDescripcion()%> - <%=activo.getModelo()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoServ" name="frmNuevoServ" action="<%=CONTROLLER%>/Gestionar/Servicios" method="post">
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
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Fecha:</span><br>
                                                    <input id="fecha" name="fecha" value="<%=fecha%>" type="hidden">
                                                    <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechaN%>" onchange="cambiaFecha(this.value,'fecha')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmNuevoServ.rgFecha,'dd-mm-yyyy',document.frmNuevoServ.rgFecha)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFecha', 'fecha')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                </td>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Factura:</span><br>
                                                    <input id="factura" name="factura" type="text" value="<%=factura%>"
                                                           onblur="Mayusculas(this)" maxlength="20" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Monto:</span><br>
                                                    <input id="monto" name="monto" type="text" value="<%=monto%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaCantidad(event, this.value)"/>
                                                </td>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descripcion" name="descripcion" type="text" value="<%=descrip%>"
                                                           onblur="Mayusculas(this)" maxlength="250" style="width: 500px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <%
                                            if (activo.getTipoactivo().getId()==2){
                                            %>
                                            <tr>
                                                <td width="100%" align="left" colspan="2">
                                                    <span class="etiqueta">Kilometraje:</span><br>
                                                    <input id="kilometraje" name="kilometraje" type="text" value="<%=km%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaCantidad(event, this.value)"/>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
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
                    Mensaje('<%=sesion.getMensaje()%>');
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoServ');
                frm.paginaSig.value = '/Inventario/Activos/Servicios/gestionarservicios.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoServ');
                    frm.paginaSig.value = '/Inventario/Activos/Servicios/gestionarservicios.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '4';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '2';
                <%
                    }
                %>
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                var fecha = document.getElementById('fecha');
                if (fecha.value == ''){
                    Mensaje('La Fecha del Servicio está vacía');
                    fecha.focus();
                    return false;
                }
                
                var fact = document.getElementById('factura');
                if (fact.value == ''){
                    Mensaje('La Factura del Servicio está vacía');
                    fact.focus();
                    return false;
                }

                var monto = document.getElementById('monto');
                if (monto.value == ''){
                    Mensaje('El Monto del Servicio está vacío');
                    monto.focus();
                    return false;
                }

                var descrip = document.getElementById('descripcion');
                if (descrip.value == ''){
                    Mensaje('La Descripción del Activo está vacía');
                    descrip.focus();
                    return false;
                }

                return true;
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
        </script>
    </body>
</html>