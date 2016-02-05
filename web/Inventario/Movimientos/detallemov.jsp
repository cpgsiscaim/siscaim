<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="java.text.SimpleDateFormat, Modelo.Entidades.Producto, Modelo.Entidades.Ubicacion, Modelo.Entidades.Almacen, Modelos.UtilMod"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    Cabecera cab = (Cabecera)datosS.get("cabecera");
    String subtotal = datosS.get("totalmov")!=null?datosS.get("totalmov").toString():"0";
    String descto = datosS.get("totaldesc")!=null?datosS.get("totaldesc").toString():"0";
    UtilMod uMod = new UtilMod();    
    double fiva = uMod.Redondear((Float.parseFloat(subtotal))*(float)0.16,2);
    double ftotal = uMod.Redondear(Float.parseFloat(subtotal)+fiva,2);
    String iva = Double.toString(fiva);
    String total = Double.toString(ftotal);
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
                        Gestionar Movimientos - Detalle del Movimiento
                    </div>
                </td>
            </tr>
            <tr>
                <td width="50%">
                    <div class="titulo" align="center">
                        Serie: <%=cab.getSerie().getSerie()%> &nbsp;&nbsp;&nbsp;&nbsp; Folio: <%=cab.getFolio()%>
                    </div>
                </td>
                <td width="50%">
                    <div class="titulo" align="center">
                        <%
                        if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
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
                                                <td width="20%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="20%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ver Inactivos">
                                                                <a href="javascript: InactivosClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="40%" align="center">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="50%" align="right">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Baja de Detalle">
                                                                            <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Editar Detalle">
                                                                            <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="20%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Nuevo">
                                                                <a href="javascript: NuevoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
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
                                        <hr>
                                        <table width="100%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="3%"></td>
                                                    <td width="12%" align="center"><span>Clave</span></td>
                                                    <td width="25%" align="center"><span>Producto</span></td>
                                                    <td width="8%" align="center"><span>Unidad</span></td>
                                                    <td width="8%" align="center"><span>Cantidad</span></td>
                                                    <td width="8%" align="center"><span>Precio/Costo</span></td>
                                                    <td width="8%" align="center"><span>Descto.</span></td>
                                                    <td width="8%" align="center"><span>Importe</span></td>
                                                </tr>                                                
                                            </thead>
                                            <tbody>
                                            <%
                                                List<Detalle> detalle = datosS.get("detalles")!=null?(List<Detalle>)datosS.get("detalles"):new ArrayList<Detalle>();
                                                if (detalle.size()==0){
                                            %>
                                                <tr>
                                                    <td colspan="8" width="100%" align="center">
                                                        No hay detalle registrado del movimiento
                                                    </td>
                                                </tr>
                                            <%
                                                } else {
                                                for (int i=0; i < detalle.size(); i++){
                                                    Detalle det = detalle.get(i);
                                                    double descdet = uMod.Redondear((det.getCantidad()*det.getCosto()*(det.getDescuento()/100)),2);
                                                    if (tmovSel.getCategoria()==2)
                                                        descdet = uMod.Redondear((det.getCantidad()*det.getPrecio()*(det.getDescuento()/100)),2);
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
                                                    <td width="8%" align="center">
                                                        <%=det.getUnidad().getDescripcion()%>
                                                    </td>
                                                    <td width="8%" align="right">
                                                        <%=Float.toString(det.getCantidad())%>
                                                    </td>
                                                    <td width="8%" align="right">
                                                    <%
                                                    if (tmovSel.getCategoria()==1){
                                                    %>
                                                        <%=Float.toString(det.getCosto())%>
                                                    <%} else {%>
                                                        <%=Float.toString(det.getPrecio())%>
                                                    <%}%>
                                                    </td>
                                                    <td width="8%" align="right">
                                                        <%=descdet%>
                                                    </td>                                                    
                                                    <td width="8%" align="right">
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
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '96';
                frm.submit();
            }
            
            function NuevoClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientodet.jsp';
                frm.pasoSig.value = '10';
                frm.submit();                
            }
            
            function EditarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientodet.jsp';
                frm.pasoSig.value = '12';
                frm.submit();                
            }

            function BajaClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/detallemov.jsp';
                frm.pasoSig.value = '14';
                frm.submit();                
            }
            
            function InactivosClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/detallesinactivos.jsp';
                frm.pasoSig.value = '15';
                frm.submit();                
            }
        </script>
    </body>
</html>