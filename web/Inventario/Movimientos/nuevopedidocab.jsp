
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
    Serie serie = (Serie) datosS.get("seriedelmov");
    int folio = (int) ((float)serie.getFolio());
    String titulo = datosS.get("titulo").toString();
    Date dhoy = (Date)datosS.get("hoy");
    String shoy = dhoy.toString();
    String hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
    String imagen = "inventarioB.png", tipbtn = "Agregar Detalle", btn = "agregardet.png";
    Cabecera cab = new Cabecera();
    Proveedor pr = new Proveedor();
    Cliente cli = new Cliente();
    if (datosS.get("accion").toString().equals("editar")){
        //titulo = "Editar "+ datosS.get("titulo").toString();
        imagen = "inventarioC.png";
        cab = (Cabecera)datosS.get("cabecera");
        serie = cab.getSerie();
        folio = cab.getFolio();
        shoy = cab.getFechaCaptura().toString();
        hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
        pr = cab.getProveedor();
        cli = cab.getCliente();
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
                                        <table width="70%" align="center">
                                            <tr>
                                                <td width="30%" align="left">
                                                    <span class="etiqueta">Serie:</span>
                                                    <input id="serie" name="serie" type="text" style="width: 100px; text-align: center;" value="<%=serie.getSerie()%>" readonly>
                                                </td>
                                                <td width="30%" align="center">
                                                    <span class="etiqueta">Folio:</span>
                                                    <input id="folio" name="folio" type="text" style="width: 100px; text-align: center;" value="<%=folio%>" readonly>
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
                                                <td width="100%" colspan="3" align="left">
                                                <%
                                                if (tmovSel.getCategoria()==1){//entrada
                                                %>
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
                                                <% } else {%>
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
                                                <% } %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" colspan="3">
                                                    <table id="datosprov" width="90%" align="right" style="display: none">
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
                                                    </table>
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
                    if (tmovSel.getCategoria()==1){
                %>
                    CargaProveedor('<%=pr.getId()%>');
                    var guardar = document.getElementById('btnGuardar');
                    guardar.style.display = '';
                <%
                    } else {
                %>
                    CargaCliente('<%=cli.getId()%>');
                    var guardar = document.getElementById('btnGuardar');
                    guardar.style.display = '';
                <%
                    }
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
            
            function CargaProveedor(prov){
                <%
                if (tmovSel.getCategoria()==1){
                %>
                var datos = document.getElementById('datosprov');
                datos.style.display = 'none';
                var dir = document.getElementById('direccion');
                dir.value = '';
                var pob = document.getElementById('poblacion');
                pob.value = '';
                if (prov != ''){
                    datos.style.display = '';
                    <%
                    List<Proveedor> provs = (List<Proveedor>)datosS.get("proveedores");
                    for (int i=0; i < provs.size(); i++){
                        Proveedor prv = provs.get(i);
                    %>
                        if (prov == '<%=prv.getId()%>'){
                            dir.value = '<%=prv.getDatosfiscales().getDireccion().getCalle()%>, <%=prv.getDatosfiscales().getDireccion().getColonia()%>';
                            pob.value = '<%=prv.getDatosfiscales().getDireccion().getPoblacion().getMunicipio()%>';
                        }
                    <%
                    }
                    %>
                }
                <% } %>
            }
            
            function CargaCliente(cliente){
                <%
                if (tmovSel.getCategoria()==2){
                %>
                var datos = document.getElementById('datosprov');
                datos.style.display = 'none';
                var dir = document.getElementById('direccion');
                dir.value = '';
                var pob = document.getElementById('poblacion');
                pob.value = '';
                if (cliente != ''){
                    datos.style.display = '';
                    <%
                    List<Cliente> clis = (List<Cliente>)datosS.get("clientes");
                    for (int i=0; i < clis.size(); i++){
                        Cliente cte = clis.get(i);
                    %>
                        if (cliente == '<%=cte.getId()%>'){
                            dir.value = '<%=cte.getDatosFiscales().getDireccion().getCalle()%>, <%=cte.getDatosFiscales().getDireccion().getColonia()%>';
                            pob.value = '<%=cte.getDatosFiscales().getDireccion().getPoblacion().getMunicipio()%>';
                        }
                    <%
                    }
                    %>
                }
                <% } %>
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
                <% if (tmovSel.getCategoria()==1){ %>
                    var prov = document.getElementById('proveedor');
                    if (prov.value == ''){
                        Mensaje('El Proveedor no ha sido establecido');
                        return false;
                    }
                <% } %>

                <% if (tmovSel.getCategoria()==2){ %>
                    var cli = document.getElementById('cliente');
                    if (cli.value == ''){
                        Mensaje('El Cliente no ha sido establecido');
                        return false;
                    }
                <% } %>
                
                var fecha = document.getElementById('fecha');
                if (fecha.value == ''){
                    Mensaje('La fecha no ha sido establecida');
                    return false;
                }
                
                return true;
            }
        
        </script>
    </body>
</html>