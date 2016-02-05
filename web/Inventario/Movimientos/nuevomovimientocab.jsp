<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="Modelo.Entidades.Serie, Modelo.Entidades.Almacen, Modelo.Entidades.Proveedor, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato"%>
<%@page import="java.text.SimpleDateFormat, Modelo.Entidades.Producto, Modelo.Entidades.Ubicacion"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    String titulo = "Nuevo Movimiento";
    String imagen = "inventarioB.png";
    Cabecera cab = new Cabecera();
    String sfol = "", sfechcap = "", sfechcapn = "", spla = "", sfechven = "", sfechvenn = "";
    Serie sser = new Serie(); Proveedor sprov = new Proveedor();
    Cliente scli = new Cliente(); Contrato scon = new Contrato();
    String sfolorig = "", sfechorig = "", sfechorign = "", sserorig = "";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Movimiento";
        imagen = "inventarioC.png";
        cab = (Cabecera)datosS.get("cabecera");
        sfol = Integer.toString(cab.getFolio());
        sfechcap = cab.getFechaCaptura().toString();
        sfechcapn =sfechcap.substring(8,10) + "-" + sfechcap.substring(5,7) + "-" + sfechcap.substring(0, 4);
        sser = cab.getSerie();
        spla = Integer.toString(cab.getPlazo());
        sfechven = cab.getFechaVencimiento().toString();
        sfechvenn =sfechven.substring(8,10) + "-" + sfechven.substring(5,7) + "-" + sfechven.substring(0, 4);
        if (tmovSel.getCategoria()==1)
            sprov = cab.getProveedor();
        else {
            scli = cab.getCliente();
            scon = cab.getContrato();
        }
        sfolorig = Integer.toString(cab.getFolioOriginal());
        sfechorig = cab.getFechaDocumento().toString();
        sfechorign =sfechorig.substring(8,10) + "-" + sfechorig.substring(5,7) + "-" + sfechorig.substring(0, 4);
        sserorig = cab.getSerieOriginal();
    }
    
    if (datosS.get("paso").toString().equals("21")){
        cab = (Cabecera)datosS.get("cabecera");
        sfol = Integer.toString(cab.getFolio());
 
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        sfechcap = cab.getFechaCaptura()!=null?sdf.format(cab.getFechaCaptura()):"";        
        //sfechcap = cab.getFechaCaptura()!=null?cab.getFechaCaptura().toString():"";
        sfechcapn =!sfechcap.equals("")?sfechcap.substring(8,10) + "-" + sfechcap.substring(5,7) + "-" + sfechcap.substring(0, 4):"";
        sser = cab.getSerie();
        spla = Integer.toString(cab.getPlazo());
        sfechven = cab.getFechaVencimiento()!=null?sdf.format(cab.getFechaVencimiento()):"";
        sfechvenn =!sfechven.equals("")?sfechven.substring(8,10) + "-" + sfechven.substring(5,7) + "-" + sfechven.substring(0, 4):"";
        
        sprov = cab.getProveedor();
        scli = cab.getCliente();
        if (datosS.get("paso").toString().equals("22")){
            scon = cab.getContrato()!=null?cab.getContrato():new Contrato();
        }
        sfolorig = Integer.toString(cab.getFolioOriginal());
        sfechorig = cab.getFechaDocumento()!=null?sdf.format(cab.getFechaDocumento()):"";
        sfechorign =!sfechorig.equals("")?sfechorig.substring(8,10) + "-" + sfechorig.substring(5,7) + "-" + sfechorig.substring(0, 4):"";
        sserorig = cab.getSerieOriginal();
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
                                    <td width="80%" valign="top" align="right">
                                        <table width="90%" frame="box" align="center">
                                            <tr>
                                                <td width="5%"></td>
                                                <td width="32%" align="left">
                                                    <span class="etiqueta">Folio:</span><br>
                                                    <input id="folio" name="folio" type="text" value="<%=sfol%>" maxlength="6" style="width: 200px"/>
                                                </td>
                                                <td width="32%" align="left">
                                                    <span class="etiqueta">Fecha:</span><br>
                                                    <input id="fechaCap" name="fechaCap" value="<%=sfechcap%>" type="hidden">
                                                    <input id="rgFechaC" name="rgFechaC" class="cajaDatos" style="width:120px" type="text" value="<%=sfechcapn%>" onchange="cambiaFecha(this.value,'fechaCap')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmNuevoMov.rgFechaC,'dd-mm-yyyy',document.frmNuevoMov.rgFechaC)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFechaC', 'fechaCap')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                </td>
                                                <td width="31%" align="left">
                                                    <span class="etiqueta">Serie:</span><br>
                                                    <select id="serie" name="serie" class="combo" style="width: 250px">
                                                        <option value="">Elija la Serie...</option>
                                                    <%
                                                        List<Serie> series = (List<Serie>)datosS.get("series");
                                                        for (int i=0; i < series.size(); i++){
                                                            Serie ser = series.get(i);
                                                        %>
                                                        <option value="<%=ser.getId()%>"
                                                                <%if (ser.getId()==sser.getId()){%>
                                                                selected <%}%>
                                                                >
                                                            <%=ser.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="5%"></td>
                                                <td width="40%" align="left">
                                                    <span class="etiqueta">Plazo:</span><br>
                                                    <input id="plazo" name="plazo" type="text" value="<%=spla%>" maxlength="3" style="width: 200px"/>
                                                </td>
                                                <td width="55%" align="left" colspan="2">
                                                    <span class="etiqueta">Fecha Vencimiento:</span><br>
                                                    <input id="fechaVen" name="fechaVen" value="<%=sfechven%>" type="hidden">
                                                    <input id="rgFechaV" name="rgFechaV" class="cajaDatos" style="width:120px" type="text" value="<%=sfechvenn%>" onchange="cambiaFecha(this.value,'fechaVen')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmNuevoMov.rgFechaV,'dd-mm-yyyy',document.frmNuevoMov.rgFechaV)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFechaV', 'fechaVen')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="5%"></td>
                                                <td width="32%" align="left">
                                                    <span class="etiqueta">Folio Original:</span><br>
                                                    <input id="folioOrig" name="folioOrig" type="text" value="<%=sfolorig%>" maxlength="6" style="width: 200px"/>
                                                </td>
                                                <td width="32%" align="left">
                                                    <span class="etiqueta">Fecha Original:</span><br>
                                                    <input id="fechaOrig" name="fechaOrig" value="<%=sfechorig%>" type="hidden">
                                                    <input id="rgFechaO" name="rgFechaO" class="cajaDatos" style="width:120px" type="text" value="<%=sfechorign%>" onchange="cambiaFecha(this.value,'fechaOrig')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmNuevoMov.rgFechaO,'dd-mm-yyyy',document.frmNuevoMov.rgFechaO)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFechaO', 'fechaOrig')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                </td>
                                                <td width="31%" align="left">
                                                    <span class="etiqueta">Serie Original:</span><br>
                                                    <input id="serieOrig" name="serieOrig" type="text" value="<%=sserorig%>" maxlength="2" style="width: 250px"/>                                                </td>
                                            </tr>
                                            <%
                                            if (tmovSel.getCategoria()==1){//entrada
                                            %>
                                            <tr>
                                                <td width="5%"></td>
                                                <td colspan="3" width="95%">
                                                    <span class="etiqueta">Proveedor:</span><br>
                                                    <select id="proveedor" name="proveedor" class="combo" style="width: 500px">
                                                        <option value="">Elija el Proveedor...</option>
                                                    <%
                                                        List<Proveedor> proveedores = (List<Proveedor>)datosS.get("proveedores");
                                                        for (int i=0; i < proveedores.size(); i++){
                                                            Proveedor prov = proveedores.get(i);
                                                        %>
                                                        <option value="<%=prov.getId()%>"
                                                                <% if (sprov.getId()==prov.getId()){%>
                                                                    selected
                                                                <%}%>
                                                                >
                                                            <%=prov.getTipo().equals("0")?prov.getDatosfiscales().getRazonsocial():prov.getDatosfiscales().getPersona().getNombreCompleto()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <%
                                            } else {
                                            %>
                                            <tr>
                                                <td width="5%"></td>
                                                <td colspan="2" width="55%">
                                                    <span class="etiqueta">Cliente:</span><br>
                                                    <select id="cliente" name="cliente" class="combo" style="width: 400px" onchange="ObtenerContratos(this.value)">
                                                        <option value="">Elija el Cliente...</option>
                                                    <%
                                                        List<Cliente> clientes = (List<Cliente>)datosS.get("clientes");
                                                        for (int i=0; i < clientes.size(); i++){
                                                            Cliente cli = clientes.get(i);
                                                        %>
                                                        <option value="<%=cli.getId()%>"
                                                                <% if (scli.getId()==cli.getId()){%>
                                                                selected
                                                                <%}%>
                                                                >
                                                            <%=cli.getTipo()==0?cli.getDatosFiscales().getRazonsocial():cli.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                                <td width="40%">
                                                    <span class="etiqueta">Contrato:</span><br>
                                                    <select id="contrato" name="contrato" class="combo" style="width: 200px">
                                                        <option value="">Elija el Contrato...</option>
                                                    <%
                                                        List<Contrato> contratos = datosS.get("contratos")!=null?(List<Contrato>)datosS.get("contratos"):new ArrayList<Contrato>();
                                                        for (int i=0; i < contratos.size(); i++){
                                                            Contrato con = contratos.get(i);
                                                        %>
                                                        <option value="<%=con.getId()%>"
                                                                <% if (scon.getId()==con.getId()){%>
                                                                selected
                                                                <%}%>
                                                                >
                                                            <%=con.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <%
                                            }
                                            %>
                                        </table><br>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0>
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
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function ObtenerContratos(cliente){
                if (cliente != ''){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientocab.jsp';
                    frm.pasoSig.value = '21';
                    frm.submit();
                } else {
                    var contrato = document.getElementById('contrato');
                    contrato.length = 0;
                    contrato.options[0] = new Option('Elija el Contrato...', '');
                }
            }
                       
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
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
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                //serie, folio, tipomov, fecha cap, estatus, plazo
                return true;
            }
        
        </script>
    </body>
</html>