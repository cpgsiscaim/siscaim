<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="java.text.SimpleDateFormat, Modelo.Entidades.Almacen, Modelo.Entidades.Producto, Modelo.Entidades.Ubicacion, Modelo.Entidades.UnidadProducto, Modelo.Entidades.Unidad, Modelo.Entidades.Cliente"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    Cabecera cab = (Cabecera)datosS.get("cabecera");
    Detalle det = new Detalle();
    String titulo = "AGREGAR DETALLE DE MOVIMIENTO";
    String imagen = "inventarioB.png";
    List<Producto> productos = (List<Producto>)datosS.get("productos");
    Almacen salm = new Almacen(); Ubicacion subi = new Ubicacion();
    String sserie = "", sfolio="";
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
            $( "#btnAgregar" ).button({
                icons: {
                    primary: "ui-icon-plus"
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
            <input id="prodssel" name="prodssel" type="hidden" value=""/>
            <div id="datos">
            <table width="40%" align="center">
                <tr>
                    <td width="100%" colspan="2">
                        <table width="100%">
                            <tr>
                                <td width="40%" align="left">
                                    <span class="etiquetaB">Tipo:</span><br>
                                    <select id="tipo" name="tipo" class="combo" onchange="CargaProductos(this.value)"
                                            style="width: 200px" title="Elija el tipo de los productos">
                                        <option value="0">B&Aacute;SICO</option>
                                        <option value="1">CAMBIO</option>
                                    </select>    
                                </td>
                                <td width="30%" align="left">
                                    <span class="etiquetaB">Unidad:</span>
                                    <select id="unidad" name="unidad" class="combo" style="width: 200px"
                                            title="Elija la unidad de los productos">
                                        <option value="0">M&Iacute;NIMA</option>
                                        <option value="1">EMPAQUE</option>
                                    </select>    
                                </td>
                                <td width="30%" align="left">
                                    <span class="etiquetaB">Cantidad:</span><br>
                                    <input id="cantidad" name="cantidad" class="text" type="text" value="1.00" maxlength="10"
                                           style="width: 70px; text-align: right"
                                           onkeypress="return ValidaCantidad2(event, this)"
                                           title="Ingrese la cantidad de los productos"
                                           onblur="Formatea(this)"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%" colspan="2">
                        <table width="100%">
                            <tr>
                                <td width="40%" align="left">
                                    <span class="etiquetaB">Almac&eacute;n:</span><br>
                                    <select id="almacen" name="almacen" class="combo" style="width: 200px" onchange="CargaUbicaciones(this.value)"
                                            title="Elija el almacén de los productos">                                                        
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
                                <td width="30%" align="left">
                                    <span class="etiquetaB">Ubicaci&oacute;n:</span><br>
                                    <select id="ubicacion" name="ubicacion" class="combo" style="width: 200px"
                                            title="Elija la ubicación en el almacén de los productos">
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
                                    <input id="imprimir" name="imprimir" type="checkbox" checked>
                                    <span class="etiquetaB">Imprimir</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%" colspan="2">
                        <span class="etiquetaB">Seleccione los Productos que desea agregar:</span><br>
                        <span class="etiquetaC">(Use la tecla Control presionada y haga clic en el producto para seleccionar o deseleccionar)</span><br>
                        <select id="prods" name="prods" size="15" style="width: 500px" multiple title="Seleccione los productos a agregar">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="right">
                        <a id="btnAgregar" href="javascript: AgregarClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Agregar Productos seleccionados">
                            Agregar
                        </a>
                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Agregar Productos">
                                    <a href="javascript: AgregarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/agregar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>-->
                    </td>
                    <td width="50%" align="right">
                        <a id="btnCancelar" href="javascript: CancelarClick()"
                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                            background: indianred 50% bottom repeat-x;" title="Cancelar Agregar Productos">
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
    </body>
    <script>
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
            
            function Formatea(obj){
                obj.value = formato_numero(parseFloat(obj.value),2,'.',',');
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
                %>
                CargaProductos('0');
            }
            
            function CargaProductos(tipo){
                var prods = document.getElementById('prods');
                prods.length = 0;
                k=0;
                <%for (int i=0; i < productos.size(); i++){
                    Producto pr = productos.get(i);
                %>
                    if (tipo=='<%=pr.getTipo()%>'){
                        prods.options[k] = new Option('<%=pr.getDescripcion()%>','<%=pr.getId()%>');
                        //prods.options[k].selected = true;
                        k++;
                    }
                <%
                }
                %> 
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
            
            function AgregarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                    frm.pasoSig.value = '11';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var cant = document.getElementById('cantidad');
                if (cant.value == ''){
                    MostrarMensaje('La Cantidad está vacía');
                    //cant.focus();
                    return false;
                } else {
                    nCan = parseFloat(cant.value);
                    if (nCan <= 0){
                        MostrarMensaje('La Cantidad debe ser mayor que cero');
                        //cant.focus();
                        return false;
                    }
                }

                var alm = document.getElementById('almacen');
                if (alm.value == ''){
                    MostrarMensaje('El Almacén no ha sido definido');
                    return false;
                }
                
                var ubi = document.getElementById('ubicacion');
                if (ubi.value == ''){
                    MostrarMensaje('La Ubicación no ha sido definida');
                    return false;
                }
                
                var prodssel = document.getElementById('prodssel');
                prodssel.value = '';
                //carga los elementos seleccionados
                var prods = document.getElementById('prods');
                for (i=0; i < prods.length; i++){
                    if (prods.options[i].selected){
                        if (prodssel.value == '')
                            prodssel.value = prods.options[i].value;
                        else
                            prodssel.value = prodssel.value + ',' + prods.options[i].value;
                    }
                }
                
                if (prodssel.value == ''){
                    MostrarMensaje('Debe seleccionar al menos un Producto');
                    return false;
                }
                
                return true;
            }
    </script>
</html>
