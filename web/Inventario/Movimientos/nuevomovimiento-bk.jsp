<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.Date, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="Modelo.Entidades.Proveedor, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>
<%@page import="java.text.SimpleDateFormat, Modelos.UtilMod"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    String titulo = datosS.get("titulo").toString().toUpperCase();
    String imagen = "inventarioB.png";
    Cabecera cab = new Cabecera();
    TipoMov tipoMov = new TipoMov();
    Date dhoy = (Date)datosS.get("hoy");
    String shoy = dhoy.toString();
    String hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
    Proveedor pr = new Proveedor();
    Cliente cli = new Cliente();
    UtilMod uMod = new UtilMod();   
    String subtotal = "0", descto = "0", iva = "0", total = "0", sfolorig = "", sserorig = "", sserie = "", sfolio="";
    int bandet = Integer.parseInt(datosS.get("bandet")!=null?datosS.get("bandet").toString():"0");
    int bancon = Integer.parseInt(datosS.get("bancon")!=null?datosS.get("bancon").toString():"0");
    List<Detalle> detalle = datosS.get("detalles")!=null?(List<Detalle>)datosS.get("detalles"):new ArrayList<Detalle>();
    Contrato scon = new Contrato();
    CentroDeTrabajo sct = new CentroDeTrabajo();
    if (datosS.get("accion").toString().equals("editar") ||
            bandet == 1 || bancon == 1 || bancon == 2){
        cab = (Cabecera)datosS.get("cabecera");
        if (datosS.get("accion").toString().equals("editar")){
            imagen = "inventarioC.png";
            sserie = cab.getSerie().getSerie();
            sfolio = Integer.toString(cab.getFolio());
        }
        tipoMov = cab.getTipomov();
        pr = cab.getProveedor();
        cli = cab.getCliente();
        if (tipoMov.getId()==20 || tipoMov.getId()==21){
            if (bancon > 0 || datosS.get("accion").toString().equals("editar"))
                scon = cab.getContrato();
            if (bancon == 2 || datosS.get("accion").toString().equals("editar"))
                sct = cab.getCentrotrabajo();
        }
        if (tipoMov.getId()==6){
            sfolorig = Integer.toString(cab.getFolioOriginal());
            sserorig = cab.getSerieOriginal()!=null?cab.getSerieOriginal():"";
        }
        SimpleDateFormat form = new SimpleDateFormat("yyyy-MM-dd");
        shoy = form.format(cab.getFechaCaptura()!=null?cab.getFechaCaptura():dhoy);
        hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
        subtotal = datosS.get("totalmov")!=null?datosS.get("totalmov").toString():"0";
        descto = datosS.get("totaldesc")!=null?datosS.get("totaldesc").toString():"0";
        double fiva = uMod.Redondear((Float.parseFloat(subtotal))*(float)0.16,2);
        double ftotal = uMod.Redondear(Float.parseFloat(subtotal)+fiva,2);
        iva = Double.toString(fiva);
        total = Double.toString(ftotal);
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
                <td width="20%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="150" height="90">
                </td>
                <td width="80%" align="center" valign="center">
                    <div class="bigtitulo" align="center">
                        GESTIONAR MOVIMIENTOS
                    </div>
                    <div class="titulo" align="center">
                        <%=titulo%>
                    </div>
                    <div class="subtitulo" align="center">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <%if (datosS.get("accion").toString().equals("editar")){%>
                    <div class="subtitulo">Movimiento: <%=sserie%> - <%=sfolio%></div>
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
            <input id="idDet" name="idDet" type="hidden" value=""/>
            <input id="variosdet" name="variosdet" type="hidden" value="0"/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <%--
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="300" height="250">
                                    </td>--%>
                                    <td width="100%" valign="top" align="right">
                                        <!-- cabecera -->
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="60%" align="left">
                                                <!-- si tipomov = otras entradas u otras salidas -->
                                                <% if (tmovSel.getId()==7 || tmovSel.getId()==8){%>
                                                    <span class="etiquetaB">Movimiento:</span>
                                                    <select id="movimiento" name="movimiento" class="combo" style="width: 400px">
                                                        <option value="">Elija el Movimiento...</option>
                                                        <%
                                                        List<TipoMov> tiposmovs = (List<TipoMov>)datosS.get("otrostiposmovs");
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
                                                <!--fin si tipomov = otras entradas u otras salidas -->
                                                <% } else if (tmovSel.getCategoria()==1) {%>
                                                <!--si tipomov es entrada -->
                                                    <span class="etiqueta">Proveedor:</span>
                                                    <select id="proveedor" name="proveedor" class="combo" style="width: 600px"
                                                            onchange="CargaProveedor(this.value)">
                                                        <option value="">Elija el Proveedor...</option>
                                                        <%
                                                        List<Proveedor> proveedores = (List<Proveedor>)datosS.get("proveedores");
                                                        for (int i=0; i < proveedores.size(); i++){
                                                            Proveedor prov = proveedores.get(i);
                                                        %>
                                                        <option value="<%=prov.getId()%>" <%if (prov.getId()==pr.getId()){%>selected<%}%>>
                                                            <%=prov.getTipo().equals("0")?prov.getDatosfiscales().getRazonsocial():prov.getDatosfiscales().getPersona().getNombreCompleto()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                <!--fin si tipomov es entrada -->
                                                <% } else if (tmovSel.getCategoria()==2){%>
                                                <!--si tipomov es salida -->
                                                    <span class="etiqueta">Cliente:</span>
                                                    <select id="cliente" name="cliente" class="combo" style="width: 600px"
                                                            onchange="CargaCliente(this.value)">
                                                        <option value="">Elija el Cliente...</option>
                                                        <%
                                                        List<Cliente> clientes = (List<Cliente>)datosS.get("clientes");
                                                        for (int i=0; i < clientes.size(); i++){
                                                            Cliente cl = clientes.get(i);
                                                        %>
                                                        <option value="<%=cl.getId()%>" <%if (cl.getId()==cli.getId()){%>selected<%}%>>
                                                            <%=cl.getTipo()==0?cl.getDatosFiscales().getRazonsocial():cl.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                <!--fin si tipomov es salida -->
                                                <% } %>
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
                                            <!-- datos del proveedor / cliente -->
                                            <% if (tmovSel.getId()!=7 && tmovSel.getId()!=8) {%>
                                            <tr>
                                                <td width="100%" colspan="2">
                                                    <table id="datos" width="90%" align="right" style="display: none">
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="etiqueta">Dirección:</span>
                                                                <input id="direccion" name="direccion" type="text" style="width: 500px" readonly/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="etiqueta">Población:</span>
                                                                <input id="poblacion" name="poblacion" type="text" style="width: 350px" readonly/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="etiqueta">RFC:</span>
                                                                <input id="rfc" name="rfc" type="text" style="width: 150px" readonly/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <%}%>
                                            <% if (tmovSel.getId()==20 || tmovSel.getId()==21) {%>
                                            <tr>
                                                <td width="100%" colspan="2">
                                                    <table width="100%" align="center">
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Contrato:</span>
                                                                <select id="contrato" name="contrato" class="combo" style="width: 450px"
                                                                        onchange="CargaCt(this.value)">
                                                                    <option value="">Elija el Contrato...</option>
                                                                    <%
                                                                    List<Contrato> contratos = datosS.get("contratos")!=null?(List<Contrato>)datosS.get("contratos"):new ArrayList<Contrato>();
                                                                    for (int i=0; i < contratos.size(); i++){
                                                                        Contrato con = contratos.get(i);
                                                                    %>
                                                                    <option value="<%=con.getId()%>" <%if (con.getId()==scon.getId()){%>selected<%}%>>
                                                                        <%=con.getContrato()%> - <%=con.getDescripcion()%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">C.T.:</span>
                                                                <select id="ct" name="ct" class="combo" style="width: 350px">
                                                                    <option value="">Elija el Centro de Trabajo...</option>
                                                                    <%
                                                                    List<CentroDeTrabajo> centros = datosS.get("centros")!=null?(List<CentroDeTrabajo>)datosS.get("centros"):new ArrayList<CentroDeTrabajo>();
                                                                    for (int i=0; i < centros.size(); i++){
                                                                        CentroDeTrabajo ct = centros.get(i);
                                                                    %>
                                                                    <option value="<%=ct.getId()%>" <%if (ct.getId()==sct.getId()){%>selected<%}%>>
                                                                        <%=ct.getNombre()%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <%}
                                            if (tmovSel.getId()==6){%>
                                            <tr>
                                                <td width="100%" colspan="2">
                                                    <table width="100%" align="center">
                                                        <tr>
                                                            <td width="50%">&nbsp;</td>
                                                            <td width="25%" align="right">
                                                                <span class="etiqueta">Serie Original:</span>
                                                                <input id="serieorig" name="serieorig" type="text" value="<%=sserorig%>" maxlength="3" style="width: 80px; text-align: center"
                                                                    onkeypress="return ValidaAlfa(event)" onblur="Mayusculas(this)"/>                                                                
                                                            </td>
                                                            <td width="25%" align="right">
                                                                <span class="etiqueta">Folio Original:</span>
                                                                <input id="folioorig" name="folioorig" type="text" value="<%=sfolorig%>" maxlength="10" style="width: 150px; text-align: right"
                                                                    onkeypress="return ValidaNums(event)"/>                                                                
                                                            </td>
                                                        </tr>
                                                </td>
                                            </tr>
                                            <%}%>
                                            <!-- fin datos del proveedor / cliente -->
                                        </table><!-- fin cabecera -->
                                        <br>
                                        <!--totales -->
                                        <% if (tmovSel.getId()!=7 && tmovSel.getId()!=8) {%>
                                        <table width="100%" align="center" class="tablaSubtotal">
                                            <thead>
                                                <tr>
                                                    <td width="25%" align="center">
                                                        <span>SUBTOTAL:</span>
                                                        <%=subtotal%> 
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>DESCUENTO:</span>
                                                        <%=descto%> 
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>IVA:</span>
                                                        <%=iva%> 
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>TOTAL:</span>
                                                        <%=total%> 
                                                    </td>
                                                </tr>
                                            </thead>
                                        </table>
                                        <% } %>
                                        <!-- fin totales -->
                                        <br>
                                        <!-- detalle -->
                                        <table width="100%" align="center" style="background-color: #0B610B">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="subtituloblanco" style="color: #ffffff;">DETALLE</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- acciones del detalle -->
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="25%" align="left">&nbsp;
                                                </td>
                                                <td width="15%" align="left">
                                                    <%
                                                    if (detalle.size()>0){
                                                    %>
                                                    <style>#btnEditCant a{display:block;color:transparent;} #btnEditCant a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="btnEditCant" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Editar Cantidades">
                                                                <a href="javascript: EditarCantsClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editarcants.png);width:180px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <style>#btnActCant a{display:block;color:transparent;} #btnActCant a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="btnActCant" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Actualiza Cantidades">
                                                                <a href="javascript: ActualizarCantsClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/actualizarcants.png);width:180px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <%} else {%>
                                                    &nbsp;
                                                    <%}%>
                                                </td>
                                                <td width="40%" align="right">
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
                                                <td width="20%" align="right">
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
                                        <!-- fin acciones del detalle -->
                                        <hr>
                                        <!-- listado del detalle -->
                                        <%
                                        int anchoProd = 25, anchoUnid = 8, anchoCant = 8;
                                        if (tmovSel.getId()==7 || tmovSel.getId()==8){
                                            anchoProd = 33; anchoUnid = 16; anchoCant = 16;
                                        } else if (tmovSel.getId()==20){
                                            anchoUnid = 5; anchoCant = 5;
                                        }
                                        %>
                                        <table width="100%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="5%"></td>
                                                    <td width="10%" align="center"><span>Clave</span></td>
                                                    <td width="<%=anchoProd%>%" align="center"><span>Producto</span></td>
                                                    <% if (tmovSel.getId()==20){ %>
                                                    <td width="6%" align="center"><span>Tipo</span></td>
                                                    <%}%>
                                                    <td width="<%=anchoUnid%>%" align="center"><span>Unid</span></td>
                                                    <td width="<%=anchoCant%>%" align="center"><span>Cant</span></td>
                                                    <% if (tmovSel.getId()!=7 && tmovSel.getId()!=8){ %>
                                                    <td width="8%" align="center">
                                                        <span>
                                                            <% if (tmovSel.getCategoria()==1){%>Costo<%} else {%> Precio <%}%>
                                                        </span>
                                                    </td>
                                                    <td width="8%" align="center"><span>Descto.</span></td>
                                                    <td width="8%" align="center"><span>Importe</span></td>
                                                    <% } %>
                                                </tr>                                                
                                            </thead>
                                            <tbody>
                                            <%
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
                                                    <td width="5%">
                                                        <input id="chkdet<%=i%>" name="chkdet<%=i%>" type="checkbox" value="<%=i%>">
                                                        <input id="radioDet" name="radioDet" type="radio" value="<%=i%>"/>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <%=det.getProducto().getClave()%>
                                                    </td>
                                                    <td width="<%=anchoProd%>%" align="left">
                                                        <%=det.getProducto().getDescripcion()%>
                                                    </td>
                                                    <% if (tmovSel.getId()==20){ %>
                                                    <td width="6%" align="center">
                                                        <%=det.getCambio()==0?"BÁSICO":"CAMBIO"%>
                                                    </td>
                                                    <%}%>
                                                    <td width="<%=anchoUnid%>%" align="center">
                                                        <%=det.getUnidad().getClave()%>
                                                    </td>
                                                    <td width="<%=anchoCant%>%" align="right">
                                                        <span id="etcant<%=i%>"><%=Float.toString(det.getCantidad())%></span>
                                                        <input id="txtcant<%=i%>" type="text" style="width: 50px; display: none; text-align: right"
                                                               maxlength="10" value="<%=Float.toString(det.getCantidad())%>"
                                                               onkeypress="return ValidaCantidad(event, this.value)"
                                                               tabindex="<%=1000+i%>"/>
                                                    </td>
                                                    <% if (tmovSel.getId()!=7 && tmovSel.getId()!=8){ %>
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
                                                    <% } %>
                                                </tr>
                                                <%
                                                }
                                                }
                                            %>
                                            </tbody>
                                        </table>
                                        <!-- fin listado del detalle -->
                                        <br><br>
                                        <!--botones-->
                                        <table width="100%">
                                            <tr>
                                                <td width="60%" align="left">
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
                                        </table><!-- fin botones -->
                                    </td> <!-- fin contenido -->
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
                if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
                    if (datosS.get("accion").toString().equals("editar") || 
                        bandet == 1){
                        if (tmovSel.getCategoria()==1){
                    %>
                            CargaProveedor('<%=pr.getId()%>');
                    <%
                        } else {
                    %>
                            CargaCliente('<%=cli.getId()%>');
                    <%
                        }
                    }
                }
                if (datosS.get("accion").toString().equals("editar")
                    || detalle.size()>0){
                %>
                    var guardar = document.getElementById('btnGuardar');
                    guardar.style.display = '';
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
            
            function CargaProveedor(prov){
                <%
                if (tmovSel.getCategoria()==1 && tmovSel.getId()!=7 && tmovSel.getId()!=8){
                %>
                var datos = document.getElementById('datos');
                datos.style.display = 'none';
                var dir = document.getElementById('direccion');
                dir.value = '';
                var pob = document.getElementById('poblacion');
                pob.value = '';
                var rfc = document.getElementById('rfc');
                rfc.value = '';
                if (prov != ''){
                    datos.style.display = '';
                    <%
                    List<Proveedor> provs = (List<Proveedor>)datosS.get("proveedores");
                    for (int i=0; i < provs.size(); i++){
                        Proveedor prv = provs.get(i);
                    %>
                        if (prov == '<%=prv.getId()%>'){
                            dir.value = '<%=prv.getDatosfiscales().getDireccion().getCalle()%>, <%=prv.getDatosfiscales().getDireccion().getColonia()%>';
                            pob.value = '<%=prv.getDatosfiscales().getDireccion().getPoblacion().getMunicipio()%>, <%=prv.getDatosfiscales().getDireccion().getPoblacion().getEstado().getEstado()%>';
                            rfc.value = '<%=prv.getDatosfiscales().getRfc()%>';
                        }
                    <%
                    }
                    %>
                }
                <% } %>
            }
            
            function CargaCliente(cliente){
                <%
                if (tmovSel.getCategoria()==2 && tmovSel.getId()!=7 && tmovSel.getId()!=8
                    && (tmovSel.getId()!=20 || (tmovSel.getId()==20 && (bandet == 1 || bancon > 0 ||
                    datosS.get("accion").toString().equals("editar")))) &&
                    (tmovSel.getId()!=21 || (tmovSel.getId()==21 && (bandet == 1 || bancon > 0 ||
                    datosS.get("accion").toString().equals("editar"))))){
                %>
                var datos = document.getElementById('datos');
                datos.style.display = 'none';
                var dir = document.getElementById('direccion');
                dir.value = '';
                var pob = document.getElementById('poblacion');
                pob.value = '';
                var rfc = document.getElementById('rfc');
                rfc.value = '';
                if (cliente != ''){
                    datos.style.display = '';
                    <%
                    List<Cliente> clis = (List<Cliente>)datosS.get("clientes");
                    for (int i=0; i < clis.size(); i++){
                        Cliente cte = clis.get(i);
                    %>
                        if (cliente == '<%=cte.getId()%>'){
                            dir.value = '<%=cte.getDatosFiscales().getDireccion().getCalle()%>, <%=cte.getDatosFiscales().getDireccion().getColonia()%>';
                            pob.value = '<%=cte.getDatosFiscales().getDireccion().getPoblacion().getMunicipio()%>, <%=cte.getDatosFiscales().getDireccion().getPoblacion().getEstado().getEstado()%>';
                            rfc.value = '<%=cte.getDatosFiscales().getRfc()%>';
                        }
                    <%
                    }
                    %>
                }
                <% } else if (tmovSel.getId()==20 || tmovSel.getId()==21) {%>
                    //obtener los contratos del cliente
                    if (cliente != ''){
                        var frm = document.getElementById('frmNuevoMov');
                        frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                        frm.pasoSig.value = '-2';
                        frm.submit();                        
                    }
                <% } %>
            }
            
            function CargaCt(contrato){
                if(contrato != ''){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                    frm.pasoSig.value = '-3';
                    frm.submit();                    
                }
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }

            function ValidaCabecera(){
                <%if (tmovSel.getId()==7 || tmovSel.getId()==8){%>
                     var mov = document.getElementById('movimiento');
                     if (mov.value == ''){
                         Mensaje('El Movimiento no ha sido establecido');
                         return false;
                     }
                <%} else if (tmovSel.getCategoria()==1){%>
                     var prov = document.getElementById('proveedor');
                     if (prov.value == ''){
                         Mensaje('El Proveedor no ha sido establecido');
                         return false;
                     }
                <%} else if (tmovSel.getCategoria()==2){%>
                     var cli = document.getElementById('cliente');
                     if (cli.value == ''){
                         Mensaje('El Cliente no ha sido establecido');
                         return false;
                     }
                     <% if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                         var con = document.getElementById('contrato');
                         if (con.value == ''){
                             Mensaje ('El Contrato no ha sido establecido');
                             return false;
                         }
                         var ct = document.getElementById('ct');
                         if (ct.value == ''){
                             Mensaje ('El Centro de Trabajo no ha sido establecido');
                             return false;
                         }
                     <% } %>
                <% }
                if (tmovSel.getId()==6){%>
                        var folorig = document.getElementById('folioorig');
                        if (folorig.value == ''){
                            Mensaje('El Folio Original está vacío');
                            return false;
                        }
                <%}%>
                    var fecha = document.getElementById('fecha');
                    if (fecha.value == ''){
                        Mensaje('La Fecha no ha sido establecida');
                        return false;
                    }
                return true;
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
            
            function NuevoClick(){
                if (ValidaCabecera()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientodet.jsp';
                    frm.pasoSig.value = '10';
                    frm.submit();
                }
            }

            function EditarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientodet.jsp';
                frm.pasoSig.value = '12';
                frm.submit();                
            }

            function BajaClick(){
                sels = 0;
                movs = '';
                <%for (int i=0; i < detalle.size(); i++){%>
                     var chk = document.getElementById('chkdet<%=i%>');
                     if (chk.checked){
                         sels++;
                         if (movs == '')
                             movs = chk.value;
                         else
                             movs += ','+chk.value;
                     }
                <%}%>
                var varios = document.getElementById('variosdet');
                if (sels>1){
                    varios.value = movs;
                } else if (sels==1){
                    //desmarca el chk que haya quedado activado
                    <%for (int i=0; i < detalle.size(); i++){%>
                        var chk = document.getElementById('chkdet<%=i%>');
                        if (chk.checked){
                            chk.checked = false;
                        }
                    <%}%>
                }

                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                frm.pasoSig.value = '14';
                frm.submit();                
            }
            
            function ValidaMovimiento(){
                if (!ValidaCabecera())
                    return false;
                
                return true;
            }

            function GuardarClick(){
                if (ValidaMovimiento()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    frm.pasoSig.value = '3';
                    frm.submit();                
                }
            }
            
            function EditarCantsClick(){
                <%
                if (detalle.size()>0){
                    for (int i=0; i < detalle.size(); i++){
                %>
                        var etcant = document.getElementById('etcant<%=i%>');
                        var txtcant = document.getElementById('txtcant<%=i%>');
                        etcant.style.display = 'none';
                        txtcant.style.display = '';
                <%
                    }
                %>
                    var txt = document.getElementById('txtcant0');
                    txt.focus();
                    var btneditcant = document.getElementById('btnEditCant');
                    btneditcant.style.display = 'none';
                    var btnactcant = document.getElementById('btnActCant');
                    btnactcant.style.display = '';
                <% } %>
            }
        </script>
    </body>
</html>