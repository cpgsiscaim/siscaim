<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="java.text.SimpleDateFormat, Modelo.Entidades.Almacen, Modelo.Entidades.Producto, Modelo.Entidades.Ubicacion, Modelo.Entidades.UnidadProducto, Modelo.Entidades.Unidad, Modelo.Entidades.Cliente"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    Cabecera cab = (Cabecera)datosS.get("cabecera");
    Detalle det = new Detalle();
    String titulo = "Nuevo Detalle de Movimiento";
    String imagen = "inventarioB.png";
    Producto sprod = new Producto(); Almacen salm = new Almacen(); Ubicacion subi = new Ubicacion();
    Unidad sunid = new Unidad();
    String cant = "0", precos = "0", desc = "0", imp = "0", etprecos = "Costo:", stipo = "", sserie = "", sfolio="";
    List<String> precios = new ArrayList<String>();
    List<String> desctos = new ArrayList<String>();
    List<UnidadProducto> unidades = new ArrayList<UnidadProducto>();
    float costo = 0;
    int imprimir = 0;
    if (tmovSel.getCategoria()==2){
        etprecos = "Precio:";
    }
    NumberFormat formcan = new DecimalFormat("#,##0.00");
    if (datosS.get("acciondet").toString().equals("editarDet")){
        titulo = "EDITAR DETALLE DE MOVIMIENTO";
        imagen = "inventarioC.png";
        det = (Detalle)datosS.get("detalle");
        sprod = det.getProducto();
        salm = det.getAlmacen();
        subi = det.getUbicacion();
        sunid = det.getUnidad();
        stipo = Integer.toString(det.getCambio());
        cant = formcan.format(det.getCantidad());//Float.toString(det.getCantidad());
        if (tmovSel.getCategoria()==1)
            precos = formcan.format(det.getCosto());//Float.toString(det.getCosto());
        else
            precos = formcan.format(det.getPrecio());//Float.toString(det.getPrecio());
        desc = formcan.format(det.getDescuento());//Float.toString(det.getDescuento());
        imp = formcan.format(det.getImporte());//Float.toString(det.getImporte());
        precios = (List<String>)datosS.get("precios");
        desctos = (List<String>)datosS.get("descuentos");
        unidades = (List<UnidadProducto>)datosS.get("unidades");
        costo = Float.parseFloat(datosS.get("costo").toString());
        imprimir = det.getImprimir();
    }
    int paso = Integer.parseInt(datosS.get("paso").toString());
    if (paso == -1){
        det = (Detalle)datosS.get("detallep");
        sprod = det.getProducto();
        precios = (List<String>)datosS.get("precios");
        desctos = (List<String>)datosS.get("descuentos");
        unidades = (List<UnidadProducto>)datosS.get("unidades");
        if (tmovSel.getCategoria()==1)
            precos = "0";//Float.toString(det.getProducto().getCostoUltimo());
    }
    if (datosS.get("accion").toString().equals("editar")){
        sserie = cab.getSerie().getSerie();
        sfolio = Integer.toString(cab.getFolio());
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS
                    </div>
                    <div class="titulo" align="left">
                        <%=titulo%>
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%
                        if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
                            if (cab.getTipomov().getCategoria()==1){
                        %>
                            PROVEEDOR <%=cab.getProveedor().getTipo().equals("0")?cab.getProveedor().getDatosfiscales().getRazonsocial():cab.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()%>
                        <%
                            } else {
                        %>
                            CLIENTE <%=cab.getCliente().getTipo()==0?cab.getCliente().getDatosFiscales().getRazonsocial():cab.getCliente().getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%
                            }
                        } else { %>
                            <%=cab.getTipomov().getDescripcion()%>
                        <%}
                        %>
                    </div>
                    <%if (datosS.get("accion").toString().equals("editar")){%>
                    <div class="subtitulo">MOVIMIENTO <%=sserie%> - <%=sfolio%></div>
                    <%}%>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMov" name="frmNuevoMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="80%">
                                <tr>
                                    <td width="100%" valign="top" align="right">
                                        <table width="70%" frame="box" align="center">
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <td width="70%">
                                                            <span class="etiqueta">Producto:</span><br>
                                                            <select id="producto" name="producto" class="combo" style="width: 400px" onchange="CargaDatos(this.value)"
                                                                    title="Elija el producto">
                                                                <option value="">Elija el Producto...</option>
                                                                <%
                                                                    List<Producto> productos = (List<Producto>)datosS.get("productos");
                                                                    for (int i=0; i < productos.size(); i++){
                                                                        Producto prod = productos.get(i);
                                                                    %>
                                                                    <option value="<%=prod.getId()%>"
                                                                            <% if (prod.getId()==sprod.getId()){
                                                                            %> selected 
                                                                            <%}%>
                                                                            >
                                                                        <%=prod.getDescripcion()%>
                                                                    </option>
                                                                <%
                                                                }
                                                                %>
                                                            </select>
                                                        </td>
                                                        <td width="15%">
                                                            <span class="etiqueta">Cantidad:</span><br>
                                                            <input id="cantidad" name="cantidad" class="text" type="text" value="<%=cant%>"
                                                                    maxlength="10" onblur="CalculaImporte()" style="width: 100px; text-align: right"
                                                                    onkeypress="return ValidaCantidad2(event, this)"
                                                                    title="Ingrese la cantidad"/>
                                                        </td>
                                                        <td width="15%">
                                                            <span class="etiqueta">Unidad:</span><br>
                                                            <select id="unidad" name="unidad" class="combo" style="width: 200px" onchange="CalculaPrecio(this.value)"
                                                                    title="Elija la unidad">
                                                                <option value="">Elija la Unidad...</option>
                                                                <%
                                                                for (int i=0; i < unidades.size(); i++){
                                                                    UnidadProducto unip = unidades.get(i);
                                                                %>
                                                                <option value="<%=unip.getUnidad().getId()%>"
                                                                        <%if (unip.getUnidad().getId()==sunid.getId()
                                                                        || det.getProducto().getUnidad().getId()==unip.getUnidad().getId()){%>selected<%}%>>
                                                                    <%=unip.getUnidad().getDescripcion()%>
                                                                </option>
                                                                <%
                                                                }
                                                                %>
                                                            </select>
                                                        </td>
                                                    </table>
                                                </td>
                                            </tr>
                                            <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8){%>
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="35%">
                                                                <span class="etiqueta"><%=etprecos%></span><br>
                                                                <input id="precos" name="precos" class="text" type="text" value="<%=precos%>"
                                                                       maxlength="10" onblur="CalculaImporte()" style="width: 100px; text-align: right"
                                                                       onkeypress="return ValidaCantidad2(event, this)"
                                                                       title="Ingrese el <%=etprecos.substring(0, etprecos.length()-1)%>"/>
                                                                <% if (tmovSel.getCategoria()!=1){%>
                                                                <select id="preciosel" name="preciosel" class="combo" style="width: 40px" onchange="CargaPrecio(this.value)">
                                                                    <option value=""></option>
                                                                    <%
                                                                    for (int i=0; i < precios.size(); i++){
                                                                    %>
                                                                    <option value="<%=precios.get(i)%>"><%=precios.get(i)%></option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                                <% } %>
                                                            </td>
                                                            <td width="35%">
                                                                <span class="etiqueta">Descuento(%):</span><br>
                                                                <input id="descuento" name="descuento" class="text" type="text" value="<%=desc%>"
                                                                       maxlength="10" onblur="CalculaImporte()" style="width: 100px; text-align: right" 
                                                                       onkeypress="return ValidaCantidad2(event, this)"
                                                                       title="Ingrese el descuento en porcentaje"/>
                                                                <select id="descuentosel" name="descuentosel" class="combo" style="width: 40px" onchange="CargaDescuento(this.value)">
                                                                    <option value=""></option>
                                                                    <%
                                                                    for (int i=0; i < desctos.size(); i++){
                                                                    %>
                                                                    <option value="<%=desctos.get(i)%>"><%=desctos.get(i)%></option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                            <td width="30%">
                                                                <span class="etiqueta">Importe:</span><br>
                                                                <input id="importe" name="importe" class="text" type="text" value="<%=imp%>" maxlength="10" readonly
                                                                       style="text-align: right"/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <td width="30%">
                                                            <span class="etiqueta">Almac&eacute;n:</span><br>
                                                            <select id="almacen" name="almacen" class="combo" style="width: 200px" onchange="CargaUbicaciones(this.value)"
                                                                    title="Elija el almacén">                                                        
                                                            <%
                                                                List<Almacen> almacenes = (List<Almacen>)datosS.get("almacenes");
                                                                if (almacenes.size()==1){
                                                                    Almacen alma = almacenes.get(0);
                                                            %>
                                                                    <option value="<%=alma.getId()%>" selected>
                                                                        <%=alma.getDescripcion()%>
                                                                    </option>
                                                            <%
                                                                } else {
                                                            %>
                                                                    <option value="">Elija el Almacén...</option>
                                                                    <%
                                                                    for (int i=0; i < almacenes.size(); i++){
                                                                        Almacen alma = almacenes.get(i);
                                                                    %>
                                                                    <option value="<%=alma.getId()%>"
                                                                            <% if (alma.getId()==salm.getId()){%>
                                                                            selected
                                                                            <%}%>
                                                                            >
                                                                        <%=alma.getDescripcion()%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                }
                                                            %>
                                                            </select>
                                                        </td>
                                                        <td width="25%">
                                                            <span class="etiqueta">Ubicaci&oacute;n:</span><br>
                                                            <select id="ubicacion" name="ubicacion" class="combo" style="width: 200px"
                                                                    title="Elija la ubicación">
                                                            <%
                                                            if (almacenes.size()==1){
                                                                List<Ubicacion> ubis = (List<Ubicacion>)datosS.get("ubicaciones");
                                                                if (ubis.size()==1){
                                                                    Ubicacion ub = ubis.get(0);
                                                                %>
                                                                    <option value="<%=ub.getId()%>" selected><%=ub.getDescripcion()%></option>
                                                                <%
                                                                } else {
                                                                %>
                                                                    <option value="">Elija la Ubicación...</option>
                                                                <%
                                                                    for (int i=0; i < ubis.size(); i++){
                                                                        Ubicacion ub = ubis.get(i);
                                                                    %>
                                                                    <option value="<%=ub.getId()%>"
                                                                            <%if (ub.getId()==subi.getId()){%>selected<%}%>>
                                                                        <%=ub.getDescripcion()%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                }
                                                            } else {
                                                            %>
                                                                <option value="">Elija la Ubicación...</option>
                                                            <%}%>
                                                            </select>
                                                        </td>
                                                        <td width="25%">
                                                            <%if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                                                            <span class="etiqueta">Tipo:</span><br>
                                                            <select id="tipo" name="tipo" class="combo" style="width: 150px" title="Elija el tipo de producto">
                                                                <option value="0" <%if (stipo.equals("0") || (det.getProducto()!=null && det.getProducto().getTipo()==0)){%>selected<%}%>>B&Aacute;SICO</option>
                                                                <option value="1" <%if (stipo.equals("1")|| (det.getProducto()!=null && det.getProducto().getTipo()==1)){%>selected<%}%>>CAMBIO</option>
                                                            </select>
                                                            <%}%> 
                                                        </td>
                                                        <td width="20%" align="left" valign="bottom">
                                                            <input id="imprimir" name="imprimir" type="checkbox" <%if(imprimir==1){%>checked<%}%>>
                                                            <span class="etiquetaB">Imprimir</span>
                                                        </td>
                                                    </table>
                                                </td>
                                            </tr>
                                            <% } else {%>
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="40%">
                                                                <span class="etiqueta">Almac&eacute;n:</span><br>
                                                                <select id="almacen" name="almacen" class="combo" style="width: 200px" onchange="CargaUbicaciones(this.value)"
                                                                        title="Elija el almacén">
                                                                <%
                                                                    List<Almacen> almacenes = (List<Almacen>)datosS.get("almacenes");
                                                                    if (almacenes.size()==1){
                                                                        Almacen alma = almacenes.get(0);
                                                                %>
                                                                        <option value="<%=alma.getId()%>" selected>
                                                                            <%=alma.getDescripcion()%>
                                                                        </option>
                                                                <%
                                                                    } else {
                                                                %>
                                                                        <option value="">Elija el Almacén...</option>
                                                                        <%
                                                                        for (int i=0; i < almacenes.size(); i++){
                                                                            Almacen alma = almacenes.get(i);
                                                                        %>
                                                                        <option value="<%=alma.getId()%>"
                                                                                <% if (alma.getId()==salm.getId()){%>
                                                                                selected
                                                                                <%}%>
                                                                                >
                                                                            <%=alma.getDescripcion()%>
                                                                        </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                %>
                                                                </select>
                                                            </td>
                                                            <td width="30%">
                                                                <span class="etiqueta">Ubicaci&oacute;n:</span><br>
                                                                <select id="ubicacion" name="ubicacion" class="combo" style="width: 200px"
                                                                        title="Elija la ubicación">
                                                                <%
                                                                if (almacenes.size()==1){
                                                                    List<Ubicacion> ubis = (List<Ubicacion>)datosS.get("ubicaciones");
                                                                    if (ubis.size()==1){
                                                                        Ubicacion ub = ubis.get(0);
                                                                    %>
                                                                        <option value="<%=ub.getId()%>" selected><%=ub.getDescripcion()%></option>
                                                                    <%
                                                                    } else {
                                                                    %>
                                                                        <option value="">Elija la Ubicación...</option>
                                                                    <%
                                                                        for (int i=0; i < ubis.size(); i++){
                                                                            Ubicacion ub = ubis.get(i);
                                                                        %>
                                                                        <option value="<%=ub.getId()%>"
                                                                                <%if (ub.getId()==subi.getId()){%>selected<%}%>>
                                                                            <%=ub.getDescripcion()%>
                                                                        </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                } else {
                                                                %>
                                                                    <option value="">Elija la Ubicación...</option>
                                                                <%}%>
                                                                </select>
                                                            </td>
                                                            <td width="30%" align="left" valign="bottom">
                                                                <input id="imprimir" name="imprimir" type="checkbox" <%if(imprimir==1){%>checked<%}%>>
                                                                <span class="etiquetaB">Imprimir</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <% } %>
                                            <tr>
                                                <td width="100%" colspan="2">&nbsp;</td>
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
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar Producto">
                                            Guardar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
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
                    MostrarMensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                if (datosS.get("acciondet").toString().equals("editarDet")){
                %>
                    CargaUbicaciones('<%=salm.getId()%>');
                <%
                }
                if (datosS.get("paso").toString().equals("-1")){
                %>
                   var can = document.getElementById('cantidad');
                   can.focus();
                   CalculaPrecio('<%=det.getProducto().getUnidad().getId()%>');
                <%
                }
                %>
            }
            
            function CargaDatos(prod){
                var uni = document.getElementById('unidad');
                uni.length = 0;
                uni.options[0] = new Option ('Elija la Unidad...', '');
                if (prod!=''){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientodet.jsp';
                    frm.pasoSig.value = '-1';
                    frm.submit();
                }
            }
            
            function CargaUbicaciones(alm){
                var ubi = document.getElementById('ubicacion');
                ubi.length = 0;
                ubi.options[0] = new Option('Elija la Ubicación...', '');
                k=1;
                <%
                List<Ubicacion> ubis = (List<Ubicacion>)datosS.get("ubicaciones");
                for (int i=0; i < ubis.size(); i++){
                    Ubicacion ub = ubis.get(i);
                    %>
                    if ('<%=ub.getAlmacen().getId()%>'==alm){
                        ubi.options[k] = new Option('<%=ub.getDescripcion()%>', '<%=ub.getId()%>');
                    <%
                        if (datosS.get("acciondet").toString().equals("editarDet")){
                            if (ub.getId()==subi.getId()){
                    %>
                            ubi.options[k].selected = true;
                    <%
                            }
                        }
                    %>
                        k++;
                    }
                    <%
                }
                %>
                if (ubi.length==2){
                    ubi.options[1].selected = true;
                }
            }
            
            function RecalculaPrecios(valor){
                <% if (tmovSel.getCategoria()!=1){%>
                var nval = parseFloat(valor);
                var precos = document.getElementById('preciosel');
                precos.length = 0;
                precos.options[0] = new Option('','');
                var k = 1;
                <%
                for (int i = 0; i < precios.size(); i++){
                %>
                    var nprecio = parseFloat('<%=precios.get(i)%>');
                    var nuevo = nprecio * nval;
                    precos.options[k] = new Option(formato_numero(nuevo,2,'.',','), formato_numero(nuevo,2,'.',','));
                    k++;
                <%
                }
                }
                %>
            }
            
            function CalculaPrecio(uni){
                var precos = document.getElementById('precos');
                precos.value = '';
                <%
                if ((paso == -1 || datosS.get("acciondet").toString().equals("editarDet")) && 
                        (tmovSel.getId()!=7 && tmovSel.getId()!=8)){
                    Detalle detp = (Detalle)datosS.get("detallep");
                    Producto prod = detp.getProducto();
                    for (int i=0; i < unidades.size(); i++){
                        UnidadProducto unip = unidades.get(i);
                    %>
                        if (uni == '<%=unip.getUnidad().getId()%>'){
                            <%if (tmovSel.getCategoria()==1){%>
                                precos.value = '<%=unip.getValor()*costo%>';
                            <%} else {
                                Cliente cli = cab.getCliente();
                                float precio = Float.parseFloat(precios.get(0));//prod.getPrecio1()*prod.getCostoUltimo();
                                if (cli.getListaPrecios()!=0)
                                    precio = Float.parseFloat(precios.get(cli.getListaPrecios()-1));
                                /*switch (cli.getListaPrecios()){
                                    case 1: precio = prod.getPrecio1()*prod.getCostoUltimo();
                                        break;
                                    case 2: precio = prod.getPrecio2()*prod.getCostoUltimo();
                                        break;
                                    case 3: precio = prod.getPrecio3()*prod.getCostoUltimo();
                                        break;
                                    case 4: precio = prod.getPrecio4()*prod.getCostoUltimo();
                                        break;
                                    case 5: precio = prod.getPrecio5()*prod.getCostoUltimo();
                                        break;
                                }*/
                            %>
                                precos.value = '<%=unip.getValor()*precio%>';
                            <%}%>
                            RecalculaPrecios('<%=unip.getValor()%>');
                        }
                    <%
                    }
                }
                %>
                CalculaImporte();
            }
            
            function CargaPrecio(valor){
                var preciosel = document.getElementById('preciosel');
                preciosel.selectedIndex = 0;
                var precos = document.getElementById('precos');
                precos.value = valor;
                CalculaImporte();
            }
            
            function CargaDescuento(valor){
                var desctosel = document.getElementById('descuentosel');
                desctosel.selectedIndex = 0;
                var descuento = document.getElementById('descuento');
                descuento.value = valor;
                CalculaImporte()
            }
            
            function CalculaImporte(){
                <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8){%>
                var cant = document.getElementById('cantidad');
                cant.value = formato_numero(parseFloat(cant.value),2,'.',',');
                var precio = document.getElementById('precos');
                precio.value = formato_numero(parseFloat(precio.value),2,'.',',');
                var descto = document.getElementById('descuento');
                descto.value = formato_numero(parseFloat(descto.value),2,'.',',');
                var impor = document.getElementById('importe');
                if (cant.value != '' && precio.value != '' && descto.value != ''){
                    nCan = parseFloat(cant.value);
                    nPre = parseFloat(precio.value);
                    nDesc = parseFloat(descto.value);
                    nImp = nCan*nPre;
                    nd = (nImp * nDesc) / 100;
                    nImp = nImp - nd;
                    impor.value = formato_numero(nImp,2,'.',',');
                }
                <% } %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
                       
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                <%
                    if (datosS.get("acciondet").toString().equals("editarDet")){
                %>
                        frm.pasoSig.value = '13';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '11';
                <%
                    }
                %>
                    frm.submit();
                }
                
            }
            
            function ValidaRequeridos(){
                //serie, folio, tipomov, fecha cap, estatus, plazo
                var prod = document.getElementById('producto');
                if (prod.value == ''){
                    MostrarMensaje('El Producto no ha sido establecido');
                    return false;
                }
                
                var uni = document.getElementById('unidad');
                if (uni.value == ''){
                    MostrarMensaje('La Unidad del producto no ha sido establecida');
                    return false;
                }
                
                <%if (tmovSel.getId()==20){%>
                    var tipo = document.getElementById('tipo');
                    if (tipo.value == ''){
                        MostrarMensaje('El Tipo de producto no ha sido establecido');
                        return false;
                    }
                <%}%>
                
                var cant = document.getElementById('cantidad');
                if (cant.value == ''){
                    MostrarMensaje('La Cantidad está vacía');
                    cant.focus();
                    return false;
                } else {
                    nCan = parseFloat(cant.value);
                    if (nCan == 0){
                        MostrarMensaje('La Cantidad no puede ser 0 (cero)');
                        cant.focus();
                        return false;
                    }
                }
                
                <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8){%>
                var precio = document.getElementById('precos');
                campo = '<%=etprecos.substring(0, etprecos.length()-1)%>';
                if (precio.value == ''){
                    MostrarMensaje('El '+campo+' está vacío');
                    //precio.focus();
                    return false;
                } else {
                    nPre = parseInt(precio.value);
                    if (nPre == 0){
                        MostrarMensaje('El '+campo+' no puede ser 0 (cero)');
                        //precio.focus();
                        return false;
                    }
                }
                
                var desc = document.getElementById('descuento');
                if (desc.value == ''){
                    desc.value = 0;
                    CalculaImporte();
                }
                <% } %>
                
                var alm = document.getElementById('almacen');
                if (alm.value == ''){
                    MostrarMensaje('El Almacén no ha sido establecido');
                    return false;
                }
                
                var ubi = document.getElementById('ubicacion');
                if (ubi.value == ''){
                    MostrarMensaje('La Ubicación no ha sido establecida');
                    return false;
                }
                
                return true;
            }
        
        </script>
    </body>
</html>