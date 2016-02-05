<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.ArrayList, Modelo.Entidades.Producto"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Producto prod = (Producto)datosS.get("producto");
int paso = Integer.parseInt(datosS.get("paso").toString());
String /*fechainiN="", fechafinN = "",*/ fechaini = "", fechafin="";
List kardex = new ArrayList();
if (paso==13){
    fechaini = datosS.get("fechaini").toString();
    //fechainiN =fechaini.substring(8,10) + "-" + fechaini.substring(5,7) + "-" + fechaini.substring(0, 4);
    fechafin = datosS.get("fechafin").toString();
    //fechafinN =fechafin.substring(8,10) + "-" + fechafin.substring(5,7) + "-" + fechafin.substring(0, 4);

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
        </script>
    <!-- Jquery UI -->
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/kardexA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PRODUCTOS
                    </div>
                    <div class="titulo" align="left">
                        K&Aacute;RDEX DEL PRODUCTO
                    </div>
                    <div class="subtitulo" align="left">
                        PRODUCTO: <%=prod.getClave()%> - <%=prod.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmKardexProd" name="frmKardexProd" action="<%=CONTROLLER%>/Gestionar/Productos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="80%" align="center">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="30%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="20%" align="right">
                                                <span class="etiqueta">Del:</span>
                                                <input id="fechaini" name="fechaini" type="text" class="text" readonly value="<%=fechaini%>"
                                                    title="Ingrese la fecha inicial"/>
                                                
                                                <%--
                                                <input id="fechaini" name="fechaini" value="<%=fechaini%>" type="hidden">
                                                <input id="rgFechaIni" name="rgFechaIni" class="cajaDatos" style="width:120px" type="text" value="<%=fechainiN%>" onchange="cambiaFecha(this.value,'fechaini')" readonly>&nbsp;
                                                <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                    onclick="displayCalendar(document.frmKardexProd.rgFechaIni,'dd-mm-yyyy',document.frmKardexProd.rgFechaIni)"
                                                    title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                    onclick="limpiar('rgFechaIni', 'fechaini')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                --%>
                                            </td>
                                            <td width="20%" align="right">
                                                <span class="etiqueta">Al:</span>
                                                <input id="fechafin" name="fechafin" type="text" class="text" readonly value="<%=fechafin%>"
                                                    title="Ingrese la fecha final"/>
                                                <%--
                                                <input id="fechafin" name="fechafin" value="<%=fechafin%>" type="hidden">
                                                <input id="rgFechaFin" name="rgFechaFin" class="cajaDatos" style="width:120px" type="text" value="<%=fechafinN%>" onchange="cambiaFecha(this.value,'fechafin')" readonly>&nbsp;
                                                <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                    onclick="displayCalendar(document.frmKardexProd.rgFechaFin,'dd-mm-yyyy',document.frmKardexProd.rgFechaFin)"
                                                    title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                    onclick="limpiar('rgFechaFin', 'fechafin')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                --%>
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnMostrara {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnMostrar a{display:block;color:transparent;} #btnMostrar a:hover{background-position:left bottom;}a#btnMostrara {display:none}</style>
                                                <table id="btnMostrar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Mostrar">
                                                            <a href="javascript: MostrarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/mostrar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <% if (paso == 13){
                                        kardex = (List)datosS.get("kardex");
                                        if (kardex.size()==0){
                                        %>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="etiquetaB">No se encontraron movimientos en el período indicado</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <%
                                        } else {
                                            float sini = Float.parseFloat(datosS.get("saldoinicial").toString());
                                        %>
                                        <table class="tablaLista" width="50%" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="100%" align="center">
                                                        <span>Saldo Inicial:<%=sini%></span>
                                                    </td>
                                                </tr>
                                            </thead>
                                        </table><br>
                                        <table class="tablaLista" width="100%">
                                            <thead>
                                                <tr>
                                                    <td width="10%" align="center">
                                                        <span>Fecha</span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span>Serie</span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span>Folio</span>
                                                    </td>
                                                    <td width="35%" align="center">
                                                        <span>Movimiento</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Cant</span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span>Unidad</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Saldo</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Costo</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Precio</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Importe</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                            float saldo = sini;
                                            float totentr = 0, totsal = 0, totcos = 0, totpre = 0, totimp = 0;
                                            for (int i=0; i < kardex.size(); i++){
                                                List fila = (List)kardex.get(i);
                                                String fecha = fila.get(0).toString();
                                                String fechaN =fecha.substring(8,10) + "-" + fecha.substring(5,7) + "-" + fecha.substring(0, 4);
                                                int cat = Integer.parseInt(fila.get(4).toString());
                                                String costo = "", precio = "", fondo = "", ssaldo = "", scant = "", importe = "";
                                                float cant = Float.parseFloat(fila.get(5).toString());
                                                importe = fila.get(8).toString();
                                                totimp += Float.parseFloat(importe);
                                                if (cat==1){
                                                    costo = fila.get(7).toString();
                                                    totcos += Float.parseFloat(costo);
                                                    fondo = "#58ACFA";
                                                    saldo += cant;
                                                    totentr += cant;
                                                }else{
                                                    precio = fila.get(6).toString();
                                                    totpre += Float.parseFloat(precio);
                                                    fondo = "#F78181";
                                                    saldo -= cant;
                                                    totsal += cant;
                                                }
                                                ssaldo = Float.toString(saldo);
                                                scant = Float.toString(cant);
                                            %>
                                                <tr bgcolor="<%=fondo%>">
                                                    <td width="10%" align="center">
                                                        <span class="etiqueta"><%=fechaN%></span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span class="etiqueta"><%=fila.get(1).toString()%></span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span class="etiqueta"><%=fila.get(2).toString()%></span>
                                                    </td>
                                                    <td width="25%" align="left">
                                                        <span class="etiqueta"><%=fila.get(3).toString()%></span>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <span class="etiqueta"><%=scant%></span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span class="etiqueta"><%=fila.get(9).toString()%></span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span class="etiqueta"><%=ssaldo%></span>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <span class="etiqueta"><%=costo%></span>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <span class="etiqueta"><%=precio%></span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span class="etiqueta"><%=importe%></span>
                                                    </td>
                                                </tr>
                                            <%}%>
                                            </tbody>
                                        </table>
                                        <br>
                                        <table class="tablaLista" width="70%" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="100%" align="right" colspan="6">
                                                        <span>Totales</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="17%" align="right">
                                                        <span>Entradas</span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span>Salidas</span>
                                                    </td>
                                                    <td width="15%" align="right">
                                                        <span>Saldo</span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span>Costo</span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span>Precio</span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span>Importe</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td width="17%" align="center">
                                                        <span><%=totentr%></span>
                                                    </td>
                                                    <td width="17%" align="center">
                                                        <span><%=totsal%></span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span><%=saldo%></span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span><%=totcos%></span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span><%=totpre%></span>
                                                    </td>
                                                    <td width="17%" align="right">
                                                        <span><%=totimp%></span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <%
                                        }
                                    %>
                                        
                                    <%}%>
                                </td>
                            </tr>
                        </table>
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
                if (paso==13 && kardex.size()>0){
                %>
                    var btnImprimir = document.getElementById('btnImprimir');
                    btnImprimir.style.display = '';
                <%
                }
                %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmKardexProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '95';
                frm.submit();                
            }
            
            function MostrarClick(){
                var frm = document.getElementById('frmKardexProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/kardexproducto.jsp';
                paso.value = '13';
                frm.submit();                
            }
            
            function ImprimirClick(){
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
            
            function ImprimirClick(){
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Productos'+'&paso=14',
                        '','width =800, height=600, left=0, top = 0, resizable= yes');                
            }
        </script>
    </body>
</html>