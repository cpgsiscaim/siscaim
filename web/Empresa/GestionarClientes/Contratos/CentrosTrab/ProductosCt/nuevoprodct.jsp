<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.List, java.util.HashMap, java.util.ArrayList, java.text.DecimalFormat, java.text.NumberFormat,java.text.SimpleDateFormat,
        Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelos.UtilMod,
        Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Catalogos.FechasEntrega,
        Modelo.Entidades.Producto, Modelo.Entidades.ProductosCt, Modelo.Entidades.Almacen,
        Modelo.Entidades.Unidad, Modelo.Entidades.UnidadProducto"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    List<FechasEntrega> listafechas = new ArrayList<FechasEntrega>();
    HashMap datosS = sesion.getDatos();
    int cat = Integer.parseInt(datosS.get("categoria").toString());
    Cliente cliSel = (Cliente)datosS.get("clienteSel");
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    Contrato conSel = (Contrato)datosS.get("editarContrato");
    List<Almacen> almacenes = datosS.get("almacenes")!=null?(List<Almacen>)datosS.get("almacenes"):new ArrayList<Almacen>();
    List<Producto> productos = (List<Producto>)datosS.get("productos");
    CentroDeTrabajo ctrab = new CentroDeTrabajo();
    String titulo2 = "CENTRO DE TRABAJO";
    if (cat == 1){
        ctrab = (CentroDeTrabajo)datosS.get("centro");
    } else {
        titulo2 = "CONTRATO";
    }
    String titulo = "NUEVO PRODUCTO DE "+titulo2;
    String imagen = "productosB.png";
    String descrip = "", tipo = "0", listap = "1", cant = "", categoria = "0", precio = "0";
    int imprimir = 0;
    Producto prod = datosS.get("productosel")!=null?(Producto)datosS.get("productosel"):new Producto();
    Unidad uniact = new Unidad();
    Almacen almact = new Almacen();
    UtilMod uMod = new UtilMod();
    NumberFormat formato = new DecimalFormat("#,##0.00");
    ProductosCt pct = new ProductosCt();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR PRODUCTO DE "+titulo2;
        imagen = "productosC.png";
        pct = (ProductosCt)datosS.get("prodct");
        descrip = pct.getDescripcion();
        prod = datosS.get("productosel")!=null?(Producto)datosS.get("productosel"):pct.getProducto();
        tipo = Integer.toString(pct.getTipo());
        listap = Integer.toString(pct.getListaprecios());
        cant = Float.toString(pct.getCantidad());
        categoria = Integer.toString(pct.getCategoria());
        uniact = pct.getUnidad();
        almact = pct.getAlmacen();
        precio = formato.format(pct.getPrecio());
        imprimir = pct.getImprimir();
    }
    List<String> precios = (List<String>)datosS.get("precios");
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
        
        //DIALOGO MENSAJE
        $(function() {
        $( "#dialog-message" ).dialog({
            modal: true,
            autoOpen: false,
            width: 500,
            height: 200,
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
                        GESTIONAR PRODUCTOS DEL <%=titulo2%>
                    </div>
                    <div class="titulo" align="left">
                        <%=titulo%><br>
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%if (cliSel.getTipo()==0){%>
                        <%=cliSel.getDatosFiscales().getRazonsocial()%>
                        <%}%>
                        <%if (cliSel.getDatosFiscales().getPersona()!=null){%>
                        <%=cliSel.getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%}%>
                         - 
                        CONTRATO <%=conSel.getContrato()%> <%=conSel.getDescripcion()%>
                        <%if (cat==1){%>
                        CENTRO DE TRABAJO <%=ctrab.getNombre()%>
                        <%}%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoPCT" name="frmNuevoPCT" action="<%=CONTROLLER%>/Gestionar/ProductosDeCT" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="60%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <% if (productos.isEmpty()){%>
                                        <table width="100%" align="center" cellpadding="5px">
                                            <tr>
                                                <td width="100%">
                                                    <span class="subtitulo">
                                                        NO HAY PRODUCTOS DISPONIBLES PARA ASIGNAR AL <%=titulo2.toUpperCase()%>
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                        <% } else { %>
                                        <table width="80%" align="center" cellpadding="5px">
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="60%">
                                                                <span class="etiqueta">Producto:</span><br>
                                                                <select id="producto" name="producto" class="combo" style="width: 400px"
                                                                        onchange="ObtenerUnidades(this.value)">
                                                                    <option value="">Elija el Producto...</option>
                                                                    <%
                                                                        for (int i=0; i < productos.size(); i++){
                                                                            Producto pr = productos.get(i);
                                                                        %>
                                                                        <option value="<%=pr.getId()%>"
                                                                                <% if (pr.getId()==prod.getId()){
                                                                                %> selected 
                                                                                <%}%>
                                                                                >
                                                                            <%=pr.getDescripcion()%>
                                                                        </option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                            <td width="20%">
                                                                <span class="etiqueta">Cantidad</span><br>
                                                                <input id="cantidad" name="cantidad" class="text" type="text" style="width: 100px; text-align: right" value="<%=cant%>"
                                                                    maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"/>
                                                            </td>
                                                            <td width="20%">
                                                                <span class="etiqueta">Unidad:</span><br>
                                                                <select id="unidad" name="unidad" class="combo" style="width: 150px" onchange="CalculaPrecio(this.value)">
                                                                    <option value="">Elija la Unidad...</option>
                                                                    <%
                                                                    List<UnidadProducto> unidades = datosS.get("unidades")!=null?(List<UnidadProducto>)datosS.get("unidades"):new ArrayList<UnidadProducto>();
                                                                    for (int i=0; i < unidades.size(); i++){
                                                                        UnidadProducto unip = unidades.get(i);
                                                                    %>
                                                                    <option value="<%=unip.getUnidad().getId()%>"
                                                                            <%if (unip.getUnidad().getId()==uniact.getId() || 
                                                                            (prod.getUnidad()!=null && unip.getUnidad().getId()==prod.getUnidad().getId())){%>selected<%}%>>
                                                                        <%=unip.getUnidad().getDescripcion()%>
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
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="30%" valign="bottom">
                                                                <span class="etiqueta">Precio:</span><br>
                                                                <input id="precio" name="precio" class="text" type="text" value="<%=precio%>" maxlength="10"
                                                                       style="width: 100px" onkeypress="return ValidaCantidad(event, this.value)"
                                                                       onblur="Formatea(this)"/>
                                                                <select id="preciosel" name="preciosel" class="combo" style="width: 40px" onchange="CargaPrecio(this.value)">
                                                                    <option value=""></option>
                                                                    <%
                                                                    for (int i=0; i < precios.size(); i++){
                                                                    %>
                                                                    <option value="<%=precios.get(i)%>"><%=formato.format(Float.parseFloat(precios.get(i)))%><%--=precios.get(i)--%></option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                            <td width="25%">
                                                                <span class="etiqueta">Tipo:</span><br>
                                                                <select id="tipo" name="tipo" class="combo" style="width: 150px">
                                                                    <option value="0" <%if (tipo.equals("0") ||
                                                                            pct.getTipo()==0){%>selected<%}%>>
                                                                        B&Aacute;SICO
                                                                    </option>
                                                                    <option value="1" <%if (tipo.equals("1") ||
                                                                            pct.getTipo()==1){%>selected<%}%>>
                                                                        A CAMBIO
                                                                    </option>
                                                                </select>
                                                            </td>
                                                            <td width="25%">
                                                                <span class="etiqueta">Almacen:</span><br>
                                                                <select id="almacen" name="almacen" class="combo" style="width: 200px">
                                                                    <option value="">Elija el Almacen...</option>
                                                                    <%
                                                                    for (int i=0; i < almacenes.size(); i++){
                                                                        Almacen alm = almacenes.get(i);
                                                                    %>
                                                                    <option value="<%=alm.getId()%>"
                                                                        <%if (alm.getId()==almact.getId() || almacenes.size()==1){%>selected<%}%>>
                                                                        <%=alm.getDescripcion()%>
                                                                    </option>
                                                                    <%
                                                                    }
                                                                    %>
                                                                </select>
                                                            </td>
                                                            <td width="20%" align="left" valign="bottom">
                                                                <input id="imprimir" name="imprimir" type="checkbox" <%if(imprimir==1){%>checked<%}%>>
                                                                <span class="etiquetaB">Imprimir</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <!--&& pct.getTipo()==0-->
                                            <%if (cat == 1 && ctrab.getConfigentrega()!=2){%>
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="100%" align="left" colspan="2">
                                                                <input id="opcconfig" name="opcconfig" value="0" type="hidden">
                                                                <input id="lstfechas" name="lstfechas" value="" type="hidden">
                                                                <input id="chkfechasent" name="chkfechasent" type="checkbox" onclick="ChecaFechas()">
                                                                <span class="etiquetaB">Definir Entregas</span>
                                                                <div id="divfechas" style="display: none">
                                                                    <%if ((ctrab.getConfigentrega()==0 && ctrab.getContrato().getTipoentrega()==0)
                                                                            || (ctrab.getConfigentrega()==1 && ctrab.getTipoentrega()==0)){
                                                                            List<String> diasdis = (List<String>)datosS.get("diasdis");%>
                                                                        <span class="etiqueta">Cada&nbsp;
                                                                            <select id="numdias" name="numdias" class="combo" style="width: 80px">
                                                                            <%for (int i=0; i < diasdis.size(); i++){
                                                                                String dia = diasdis.get(i);
                                                                            %>
                                                                                <option value="<%=dia%>"
                                                                                        <%if(pct.getDiasentrega()==Integer.parseInt(dia)){%>
                                                                                        selected<%}%>>
                                                                                    <%=dia%>
                                                                                </option>
                                                                            <%}%>
                                                                            </select>&nbsp;
                                                                            d&iacute;as
                                                                        </span>
                                                                    <%} else if (ctrab.getConfigentrega()==0 && ctrab.getContrato().getTipoentrega()==1){%>
                                                                        <select id="fechasdis" name="fechasdis" class="combo" style="width: 200px;">
                                                                            <%
                                                                                List<FechasEntrega> fechasent = (List<FechasEntrega>)datosS.get("fechasdiscon");
                                                                                SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
                                                                                String sfecha = "";
                                                                                for (int i=0; i < fechasent.size(); i++){
                                                                                    FechasEntrega fe = fechasent.get(i);
                                                                                    sfecha = form.format(fe.getFecha());
                                                                            %>
                                                                                    <option value="<%=sfecha%>"><%=sfecha%></option>
                                                                            <%
                                                                                }
                                                                            %>
                                                                        </select>
                                                                        <img src="/siscaim/Imagenes/Varias/mas01.png" width="25" height="25"
                                                                            onclick="AgregaFecha()" title="Agrega la fecha" onmouseover="this.style.cursor='pointer'"/><br>
                                                                        <select id="lsfechas" name="lsfechas" size="5" style="width: 200px" multiple>
                                                                            <%if (datosS.get("accion").toString().equals("editar")){
                                                                                List<FechasEntrega> fechasprod = (List<FechasEntrega>)datosS.get("fechasprod");
                                                                                SimpleDateFormat forma = new SimpleDateFormat("dd-MM-yyyy");
                                                                                String sfech = "";
                                                                                for (int i=0; i < fechasprod.size(); i++){
                                                                                    FechasEntrega fect = fechasprod.get(i);
                                                                                    sfech = forma.format(fect.getFecha());
                                                                                %>
                                                                                    <option value="<%=fect.getFecha()%>"><%=sfech%></option>
                                                                                <%
                                                                                }
                                                                            }%>
                                                                        </select>
                                                                        <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                                                            onclick="QuitarFechas()" title="Quitar las fechas seleccionadas" onmouseover="this.style.cursor='pointer'"/><br>
                                                                    <%} else if (ctrab.getConfigentrega()==1 && ctrab.getTipoentrega()==1){%>
                                                                        <select id="fechasdis" name="fechasdis" class="combo" style="width: 200px;">
                                                                            <%
                                                                                List<FechasEntrega> fechasent = (List<FechasEntrega>)datosS.get("fechasdisct");
                                                                                SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
                                                                                String sfecha = "";
                                                                                for (int i=0; i < fechasent.size(); i++){
                                                                                    FechasEntrega fe = fechasent.get(i);
                                                                                    sfecha = form.format(fe.getFecha());
                                                                            %>
                                                                                    <option value="<%=sfecha%>"><%=sfecha%></option>
                                                                            <%
                                                                                }
                                                                            %>
                                                                        </select>
                                                                        <img src="/siscaim/Imagenes/Varias/mas01.png" width="25" height="25"
                                                                            onclick="AgregaFecha()" title="Agrega la fecha" onmouseover="this.style.cursor='pointer'"/><br>
                                                                        <select id="lsfechas" name="lsfechas" size="5" style="width: 200px" multiple>
                                                                            <%if (datosS.get("accion").toString().equals("editar")){
                                                                                List<FechasEntrega> fechasprod = (List<FechasEntrega>)datosS.get("fechasprod");
                                                                                SimpleDateFormat forma = new SimpleDateFormat("dd-MM-yyyy");
                                                                                String sfech = "";
                                                                                for (int i=0; i < fechasprod.size(); i++){
                                                                                    FechasEntrega fect = fechasprod.get(i);
                                                                                    sfech = forma.format(fect.getFecha());
                                                                                %>
                                                                                    <option value="<%=fect.getFecha()%>"><%=sfech%></option>
                                                                                <%
                                                                                }
                                                                            }%>
                                                                        </select>
                                                                        <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                                                            onclick="QuitarFechas()" title="Quitar las fechas seleccionadas" onmouseover="this.style.cursor='pointer'"/><br>
                                                                    <%}%>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <%}%>
                                        </table>
                                        <% } %>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar Producto">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
            <div id="procesando" style="display: none">
                <table id="tbprocesando" align="center" width="100%">
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
                if (datosS.get("paso").toString().equals("50")){%>
                   var can = document.getElementById('cantidad');
                   can.focus();
                <%}
                if (cat==1 && ctrab.getConfigentrega()!=2){//&& pct.getTipo()==0 
                    if (pct.getConfigentrega()==1){%>
                        var chkent = document.getElementById('chkfechasent');
                        chkent.checked = true;
                        ChecaFechas();
                    <%}
                }
                %>
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoPCT');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var mens = document.getElementById('procesando');
                    mens.style.display = '';
                    var datos = document.getElementById('datos');
                    datos.style.display = 'none';
                    
                    var frm = document.getElementById('frmNuevoPCT');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
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
            
            function ValidaRequeridos(){
                var producto = document.getElementById('producto');
                if (producto.value == ''){
                    MostrarMensaje('El campo Producto está vacío');
                    return false;
                }
                
                var unid = document.getElementById('unidad');
                if (unid.value == ''){
                    MostrarMensaje('El campo Unidad no ha sido establecido');
                    return false;                    
                }
                
                var cant = document.getElementById('cantidad');
                if (cant.value == ''){
                    MostrarMensaje('El campo Cantidad está vacío');
                    cant.focus();
                    return false;                    
                } else {
                    nCan = parseFloat(cant.value);
                    if (nCan==0){
                        MostrarMensaje('El campo Cantidad no puede ser cero');
                        cant.focus();
                        return false;                    
                    }
                }
                
                
                var tipo = document.getElementById('tipo');
                if (tipo.value == ''){
                    MostrarMensaje('El campo Tipo está vacío');
                    tipo.focus();
                    return false;                    
                }
                
                var alma = document.getElementById('almacen');
                if (alma.value == ''){
                    MostrarMensaje('El Almacén no ha sido establecido');
                    return false;                    
                }
                
                <%if (cat == 1 && pct.getTipo()==0 && ctrab.getConfigentrega()!=2){%>
                    var chkent = document.getElementById('chkfechasent');
                    if (chkent.checked){
                        <%if ((ctrab.getConfigentrega()==0 && ctrab.getContrato().getTipoentrega()==0)
                                || (ctrab.getConfigentrega()==1 && ctrab.getTipoentrega()==0)){%>
                              var numd = document.getElementById('numdias');
                              if (numd.value == ''){
                                  MostrarMensaje('Debe especificar el número de días');
                                  return false;
                              }
                        <%} else if ((ctrab.getConfigentrega()==0 && ctrab.getContrato().getTipoentrega()==1)
                                || (ctrab.getConfigentrega()==1 && ctrab.getTipoentrega()==1)){%>
                              var lsfechas = document.getElementById('lsfechas');
                              if (lsfechas.length == 0){
                                  MostrarMensaje('No ha definido las fechas de entrega');
                                  return false;
                              } else {
                                  var lstfechas = document.getElementById('lstfechas');
                                  lstfechas.value = '';
                                  for (i=0; i < lsfechas.length; i++){
                                      if (lstfechas.value == '')
                                          lstfechas.value = lsfechas.options[i].value;
                                      else
                                          lstfechas.value += ','+lsfechas.options[i].value;
                                  }
                              }
                        <%}%>
                    }
                <%}%>
                return true;
            }
            
            function ObtenerUnidades(prod){
                var unid = document.getElementById('unidad');
                unid.length = 0;
                unid.options[0] = new Option('Elija la Unidad...', '');
                if (prod != ''){
                    var frm = document.getElementById('frmNuevoPCT');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/nuevoprodct.jsp';
                    frm.pasoSig.value = '50';
                    frm.submit();
                }
            }
            
            function RecalculaPrecios(valor){
                nval = parseFloat(valor);
                var precos = document.getElementById('preciosel');
                precos.length = 0;
                precos.options[0] = new Option('','');
                k = 1;
                <%
                for (int i = 0; i < precios.size(); i++){
                %>
                    nprecio = parseFloat('<%=precios.get(i)%>');
                    nuevo = nprecio * nval;
                    nuevo = Math.round(nuevo*100)/100;
                    precos.options[k] = new Option(nuevo, nuevo);
                    k++;
                <%
                }
                %>
            }
            
            function CalculaPrecio(uni){
                var precio = document.getElementById('precio');
                //precio.value = '';
                <%
                if (datosS.get("accion").toString().equals("editar")){
                    List<UnidadProducto> unidades = datosS.get("unidades")!=null?(List<UnidadProducto>)datosS.get("unidades"):new ArrayList<UnidadProducto>();
                    //pct = (ProductosCt)datosS.get("prodct");
                    //Producto pr = pct.getProducto();
                    for (int i=0; i < unidades.size(); i++){
                        UnidadProducto unip = unidades.get(i);
                    %>
                        if (uni == '<%=unip.getUnidad().getId()%>'){
                        <%--
                            float pre = new Double(uMod.Redondear(pr.getPrecio1()*pr.getCostoUltimo(),2)).floatValue();
                            if (cliSel.getListaPrecios()!=0)
                                pre = new Double(uMod.Redondear(Float.parseFloat(precios.get(cliSel.getListaPrecios()-1)),2)).floatValue();
                        --%>
                            var unival = parseFloat('<%=unip.getValor()%>');
                            var pre = parseFloat(precio.value);
                            precio.value = formato_numero(unival*pre,2,'.',',');
                            //precio.value = '<%--=new Double(uMod.Redondear(unip.getValor()*pre,2)).floatValue()--%>';
                            RecalculaPrecios('<%=unip.getValor()%>');
                        }
                    <%
                    }
                }
                %>
            }
            
            function CargaPrecio(valor){
                var preciosel = document.getElementById('preciosel');
                preciosel.selectedIndex = 0;
                var precio = document.getElementById('precio');
                precio.value = formato_numero(valor,2,'.',',');
            }
            
            function Formatea(obj){
                obj.value = formato_numero(obj.value, 2, '.', ',');
            }
            
            function ChecaFechas(){
                var chkfechas = document.getElementById('chkfechasent');
                var divfechas = document.getElementById('divfechas');
                var opcconfig = document.getElementById('opcconfig');
                opcconfig.value = '0';
                divfechas.style.display = 'none';
                if (chkfechas.checked){
                    divfechas.style.display = '';
                    opcconfig.value = '1';
                }
            }
            
            function AgregaFecha(){
                var fechaesp = document.getElementById('fechasdis');
                if (fechaesp.length==0){
                    MostrarMensaje('Ya ha agregado todas las fechas disponibles');
                    return;
                }
                
                if (fechaesp.value == ''){
                    MostrarMensaje('Debe especificar una fecha');
                    return;
                }
                

                var lsfechas = document.getElementById('lsfechas');
                k = lsfechas.length;
                if (k>0){
                    //checar si la fecha ya existe
                    for (i=0; i < lsfechas.length; i++){
                        if (lsfechas.options[i].value == fechaesp.value){
                            MostrarMensaje('La fecha ya fue agregada');
                            return;
                        }
                    }
                }
                
                //alert(fechaesp.value);
                var xMonth=fechaesp.value.substring(3, 5);  
                var xDay=fechaesp.value.substring(0, 2);  
                var xYear=fechaesp.value.substring(6,10);
                fechasql = xYear+'-'+xMonth+'-'+xDay;
                
                lsfechas.options[k] = new Option(fechaesp.value, fechasql);
                //eliminar la fecha agregada del combo
                for (i=0; i < fechaesp.length; i++){
                    if (fechaesp.options[i].selected)
                        fechaesp.remove(i);
                }
            }

            function QuitarFechas(){
                var lsfechas = document.getElementById('lsfechas');
                if (lsfechas.length==0){
                    MostrarMensaje('La lista de fechas está vacía');
                    return;
                }
                sel=0;
                indices = '';
                for (i=0; i<lsfechas.length; i++){
                    if (lsfechas.options[i].selected){
                        if (indices == '')
                            indices += lsfechas.options[i].value;
                        else
                            indices += ','+lsfechas.options[i].value;
                        sel++;
                    }
                }
                if (sel==0){
                    MostrarMensaje('Debe seleccionar al menos una fecha');
                    return;
                }
                tokens = indices.split(',');
                for (i=0; i < tokens.length; i++){
                    valor = tokens[i];
                    for (j=0; j < lsfechas.length; j++){
                        if (lsfechas.options[j].value==valor)
                            lsfechas.remove(j);
                    }
                    //agregarla al combo de fechas
                    var xMonth=valor.substring(5, 7);  
                    var xDay=valor.substring(8, 10);  
                    var xYear=valor.substring(0,4);
                    fechanor = xDay+'-'+xMonth+'-'+xYear;
                    var fechaesp = document.getElementById('fechasdis');
                    fechaesp.options[fechaesp.length] = new Option(fechanor, fechanor);
                }
            }
            
        </script>
    </body>
</html>