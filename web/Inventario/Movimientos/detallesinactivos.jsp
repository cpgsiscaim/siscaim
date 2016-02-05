<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="java.text.SimpleDateFormat, Modelo.Entidades.Producto, Modelo.Entidades.Ubicacion, Modelo.Entidades.Almacen"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    Cabecera cab = (Cabecera)datosS.get("cabecera");
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
                        Gestionar Movimientos - Detalles Inactivos del Movimiento
                    </div>
                </td>
            </tr>
            <tr>
                <td width="50%">
                    <div class="titulo" align="center">
                        Folio: <%=cab.getFolio()%>
                    </div>
                </td>
                <td width="50%">
                    <div class="titulo" align="center">
                        Proveedor: <%=cab.getTipomov().getCategoria()==1?(cab.getProveedor().getTipo().equals("0")?cab.getProveedor().getDatosfiscales().getRazonsocial():cab.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()):
                        (cab.getCliente().getTipo()==0?cab.getCliente().getDatosFiscales().getRazonsocial():cab.getCliente().getDatosFiscales().getPersona().getNombreCompleto())
                        %>
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
            <input id="idDet" name="idDet" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioB.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top" align="right"><%--
                                        <br>--%>
                                        <table width="90%" align="center">
                                            <tr>
                                                <td width="50%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="50%" align="center">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="100%" align="right">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Activar de Detalle">
                                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="90%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="3%"></td>
                                                    <td width="12%" align="center"><span>Clave</span></td>
                                                    <td width="25%" align="center"><span>Producto</span></td>
                                                    <td width="10%" align="center"><span>Unidad</span></td>
                                                    <td width="10%" align="center"><span>Cantidad</span></td>
                                                    <td width="10%" align="center"><span>Precio/Costo</span></td>
                                                    <td width="10%" align="center"><span>Importe</span></td>
                                                </tr>                                                
                                            </thead>
                                            <tbody>
                                            <%
                                                List<Detalle> detalle = datosS.get("inactivosDet")!=null?(List<Detalle>)datosS.get("inactivosDet"):new ArrayList<Detalle>();
                                                if (detalle.size()==0){
                                            %>
                                                <tr>
                                                    <td colspan="7" width="100%" align="center">
                                                        No hay detalles inactivos registrados del movimiento
                                                    </td>
                                                </tr>
                                            <%
                                                } else {
                                                for (int i=0; i < detalle.size(); i++){
                                                    Detalle det = detalle.get(i);
                                                %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td width="3%">
                                                        <input id="radioDet" name="radioDet" type="radio" value="<%=det.getId()%>"/>
                                                    </td>
                                                    <td width="12%" align="center">
                                                        <%=det.getProducto().getClave()%>
                                                    </td>
                                                    <td width="25%" align="left">
                                                        <%=det.getProducto().getDescripcion()%>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <%=det.getUnidad().getDescripcion()%>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <%=Float.toString(det.getCantidad())%>
                                                    </td>
                                                    <td width="10%" align="right">
                                                    <%
                                                    if (tmovSel.getCategoria()==1){
                                                    %>
                                                        <%=Float.toString(det.getCosto())%>
                                                    <%} else {%>
                                                        <%=Float.toString(det.getPrecio())%>
                                                    <%}%>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <%=Float.toString(det.getImporte())%>
                                                    </td>                                                    
                                                </tr>
                                                <%
                                                }
                                                }
                                            %>
                                            </tbody>
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
                var btnEditar = document.getElementById('btnEditarDet');
                var btnAgregar = document.getElementById('btnAgregarDet');
                var btnGuardar = document.getElementById('btnGuardar');
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

            function Activa(fila){
                var acciones = document.getElementById('borrarEdit');
                acciones.style.display = '';
                var idDet = document.getElementById('idDet');
                <%
                if (detalle.size()==1){
                %>
                    document.frmNuevoMov.radioDet.checked = true;
                    idDet.value = document.frmNuevoMov.radioDet.value;
                <%
                } else {
                %>
                    var radio = document.frmNuevoMov.radioDet[fila];
                    radio.checked = true;
                    idDet.value = radio.value;
                <% } %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/detallemov.jsp';
                frm.pasoSig.value = '94';
                frm.submit();
            }
            
            function ActivarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/detallesinactivos.jsp';
                frm.pasoSig.value = '16';
                frm.submit();                
            }
            
        </script>
    </body>
</html>