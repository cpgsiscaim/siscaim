<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="Modelo.Entidades.Proveedor, Modelo.Entidades.Cliente, Modelos.UtilMod"%>
<%@page import="java.text.SimpleDateFormat, java.text.DecimalFormat, java.text.NumberFormat"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    NumberFormat formcan = new DecimalFormat("#,##0.00");
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    Cabecera cab = (Cabecera)datosS.get("cabecera");
    String subtotal = datosS.get("totalmov")!=null?formcan.format(Float.parseFloat(datosS.get("totalmov").toString())):"0.00";
    String descto = datosS.get("totaldesc")!=null?formcan.format(Float.parseFloat(datosS.get("totaldesc").toString())):"0.00";
    UtilMod uMod = new UtilMod();    
    double fiva = uMod.Redondear((Float.parseFloat(subtotal.replace(",","")))*(float)0.16,2);
    double ftotal = uMod.Redondear(Float.parseFloat(subtotal.replace(",", ""))+fiva,2);
    String iva = formcan.format(fiva);
    String total = formcan.format(ftotal);
    List<Detalle> detalle = (List<Detalle>)datosS.get("detalles");
    String sfechcap = cab.getFechaCaptura().toString();
    String sfechcapn =sfechcap.substring(8,10) + "-" + sfechcap.substring(5,7) + "-" + sfechcap.substring(0, 4);
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaInv" ).datepicker({
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
            $( "#btnAplicar" ).button({
                icons: {
                    primary: "ui-icon-check"
		}
            });
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-cancel"
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS
                    </div>
                    <div class="titulo" align="left">
                        APLICAR MOVIMIENTO AL INVENTARIO
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%><br>
                        <%=tmovSel.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <table width="80%" align="center">
            <tr>
                <td width="50%">
                    <div class="titulo" align="center">
                        Serie: <%=cab.getSerie().getSerie()%> &nbsp;&nbsp;&nbsp;&nbsp;
                        Folio: <%=cab.getFolio()%> &nbsp;&nbsp;&nbsp;&nbsp;
                        Fecha: <%=sfechcapn%>
                    </div>
                </td>
                <td width="50%">
                    <div class="titulo" align="center">
                        <%
                        if (tmovSel.getId()!=7 && tmovSel.getId()!=8 && tmovSel.getId()!=25){
                            if (cab.getTipomov().getCategoria()==1){
                        %>
                            Proveedor: <%=cab.getProveedor().getTipo().equals("0")?cab.getProveedor().getDatosfiscales().getRazonsocial():cab.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()%>
                        <%
                            } else {
                        %>
                            Cliente: <%=cab.getCliente().getTipo()==0?cab.getCliente().getDatosFiscales().getRazonsocial():cab.getCliente().getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%
                            }
                        } else { %>
                            Movimiento: <%=cab.getTipomov().getDescripcion()%>
                        <%}
                        %>
                    </div>
                </td>
            </tr>            
        </table>
        <hr>
        <form id="frmAplicarMov" name="frmAplicarMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="80%" align="center">
                                <tr>
                                    <td width="100%" valign="top" align="right">
                                        <!-- ingresar fecha de aplicacion al inventario -->
                                        <table width="90%" frame="box" align="center">
                                            <tr>
                                                <td width="50%" align="right">
                                                    <span class="subtitulo">
                                                        Ingrese la fecha de aplicación:
                                                    </span>
                                                </td>
                                                <td width="50%" align="left">
                                                    <input id="fechaInv" name="fechaInv" type="text" class="text" readonly value=""
                                                        title="Ingrese la fecha de aplicación al inventario"/>
                                                    <%--
                                                    <input id="fechaInv" name="fechaInv" value="" type="hidden">
                                                    <input id="rgFechaI" name="rgFechaI" class="cajaDatos" style="width:120px" type="text" value="" onchange="cambiaFecha(this.value,'fechaInv')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmAplicarMov.rgFechaI,'dd-mm-yyyy',document.frmAplicarMov.rgFechaI)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFechaI', 'fechaInv')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    --%>
                                                </td>
                                            </tr>
                                        </table>
                                        <%if(tmovSel.getId()!=25){%>
                                        <hr>
                                        <table width="90%" align="center">
                                            <tr>
                                                <td width="20%" align="center">&nbsp;</td>
                                                <td width="20%" align="center">
                                                    <span class="subtitulo">SUBTOTAL:</span>
                                                    <%=subtotal%> 
                                                </td>
                                                <td width="20%" align="center">
                                                    <span class="subtitulo">DESCUENTO:</span>
                                                    <%=descto%> 
                                                </td>
                                                <td width="20%" align="center">
                                                    <span class="subtitulo">IVA:</span>
                                                    <%=iva%> 
                                                </td>
                                                <td width="20%" align="center">
                                                    <span class="subtitulo">TOTAL:</span>
                                                    <%=total%> 
                                                </td>
                                            </tr>
                                        </table>
                                        <%}%>
                                        <hr>
                                        <!-- detalle -->
                                        <table width="90%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="10%" align="center"><span>Clave</span></td>
                                                    <td width="30%" align="center"><span>Producto</span></td>
                                                    <td width="10%" align="center"><span>Unidad</span></td>
                                                    <td width="<%if(tmovSel.getId()!=25){%>10%<%}else{%>15%<%}%>" align="center"><span><%if(tmovSel.getId()!=25){%>Cantidad<%}else{%>Existencia Actual<%}%></span></td>
                                                    <%if(tmovSel.getId()!=25){%>
                                                    <td width="10%" align="center"><span>Precio/Costo</span></td>
                                                    <%}%>
                                                    <td width="<%if(tmovSel.getId()!=25){%>10%<%}else{%>15%<%}%>%" align="center"><span><%if(tmovSel.getId()!=25){%>Importe<%}else{%>Existencia Física<%}%></span></td>
                                                </tr>                                                
                                            </thead>
                                            <tbody>
                                            <%
                                                if (detalle.size()==0){
                                            %>
                                                <tr>
                                                    <td colspan="6" width="100%" align="center">
                                                        No hay detalle registrado del movimiento
                                                    </td>
                                                </tr>
                                            <%
                                                } else {
                                                for (int i=0; i < detalle.size(); i++){
                                                    Detalle det = detalle.get(i);
                                                    if(det.getImprimir()==1){
                                                %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td width="10%" align="center">
                                                        <%=det.getProducto().getClave()%>
                                                    </td>
                                                    <td width="30%" align="left">
                                                        <%=det.getProducto().getDescripcion()%>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <%=det.getUnidad().getDescripcion()%>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <%=formcan.format(det.getCantidad())%>
                                                    </td>
                                                    <%if(tmovSel.getId()!=25){%>
                                                    <td width="10%" align="right">
                                                    <%
                                                    if (tmovSel.getCategoria()==1){
                                                    %>
                                                        <%=formcan.format(det.getCosto())%>
                                                    <%} else {%>
                                                        <%=formcan.format(det.getPrecio())%>
                                                    <%}%>
                                                    </td>
                                                    <%}%>
                                                    <td width="<%if(tmovSel.getId()!=25){%>10%<%}else{%>15%<%}%>%" align="right">
                                                        <%=formcan.format(det.getImporte())%>
                                                    </td>                                                    
                                                </tr>
                                                <%
                                                }
                                                }
                                                }
                                            %>
                                            </tbody>
                                        </table>
                                        
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnAplicar" href="javascript: AplicarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Aplicar el movimiento al inventario">
                                            Aplicar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Aplicar">
                                                    <a href="javascript: AplicarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
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
                    Mensaje('<%=sesion.getMensaje()%>')
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
            
            function limpiar(nombreObj1, nombreObj2){
                obj = document.getElementById(nombreObj1);
                obj.value='';
                obj = document.getElementById(nombreObj2);
                obj.value='';
            }

            function cambiaFecha(fecha, nombreObj){
                d = fecha.substr(0,2);
                m = fecha.substr(3,2);
                y = fecha.substr(6,4);
                txtFecha = document.getElementById(nombreObj);
                txtFecha.value=y+'-'+m+'-'+d;
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmAplicarMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '93';
                frm.submit();
            }
            
                       
            function AplicarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmAplicarMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    frm.pasoSig.value = '18';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                //serie, folio, tipomov, fecha cap, estatus, plazo
                var fechainv = document.getElementById('fechaInv');
                if (fechainv.value == ''){
                    MostrarMensaje('No ha especificado la fecha de aplicación');
                    return false;
                }
                return true;
            }
        
        </script>
    </body>
</html>