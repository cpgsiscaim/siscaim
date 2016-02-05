<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Catalogos.TipoActivo"%>
<%@page import="Modelo.Entidades.Equipo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Equipo> listado = new ArrayList<Equipo>();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
TipoActivo tactSel = new TipoActivo();
if (paso != 0){
    //sucSel = (Sucursal)datosS.get("sucursalSel");
    tactSel = (TipoActivo)datosS.get("tipoactSel");
    listado = datosS.get("listado")!=null?(List<Equipo>)datosS.get("listado"):new ArrayList<Equipo>();
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Activos
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarAct" name="frmGestionarAct" action="<%=CONTROLLER%>/Gestionar/Activos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idAct" name="idAct" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Inventario/Activos/activosA.png" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="60%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="20%" align="right">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 250px"
                                                        onchange="MostrarActivos()">
                                                    <option value="">Elija la Sucursal...</option>
                                                <%
                                                    List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                    if (sucursales!=null){
                                                        if (sucursales.size()!=0){
                                                            for (int i=0; i < sucursales.size(); i++){
                                                                Sucursal suc = sucursales.get(i);
                                                            %>
                                                                <option value="<%=suc.getId()%>"
                                                                        <%
                                                                        //if (paso!=0){
                                                                            //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                            if (sucSel.getId()==suc.getId()){
                                                                            %>
                                                                                selected
                                                                            <%
                                                                            }
                                                                        //}
                                                                        %>
                                                                        >
                                                                    <%=suc.getDatosfis().getRazonsocial()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="20%" align="right">
                                                <select id="tipoactsel" name="tipoactsel" class="combo" style="width: 200px"
                                                        onchange="MostrarActivos()">
                                                    <option value="">Elija el Tipo de Activo...</option>
                                                <%
                                                    List<TipoActivo> tipos = (List<TipoActivo>)datosS.get("tiposactivos");
                                                    if (tipos!=null){
                                                        if (tipos.size()!=0){
                                                            for (int i=0; i < tipos.size(); i++){
                                                                TipoActivo tact = tipos.get(i);
                                                            %>
                                                                <option value="<%=tact.getId()%>"
                                                                        <%
                                                                        if (paso!=0){
                                                                            //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                            if (tact.getId()==tactSel.getId()){
                                                                            %>
                                                                                selected
                                                                            <%
                                                                            }
                                                                        }
                                                                        %>
                                                                        >
                                                                    <%=tact.getDescripcion()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="acciones" width="100%" style="display: none">
                                        <tr>
                                            <td width="5%" align="right">&nbsp;</td>
                                            <td width="15%" align="center">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnServicios a{display:block;color:transparent;} #btnFiltrar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnServicios" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Servicios">
                                                            <a href="javascript: ServiciosClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/servicios.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnResguardos a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="btnResguardos" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Resguardo">
                                                            <a href="javascript: ResguardoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/resguardos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnBaja a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="btnBaja" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Baja">
                                                            <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnEditar a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="btnEditar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Editar">
                                                            <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
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
                                    <table class="tablaLista" width="100%" id="lista">
                                    <%
                                    if (paso != 0 && sucSel.getId()!=0){
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Activos registrados con la Sucursal y el Tipo de Activo seleccionados 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="15%" colspan="2">
                                                    <span>Código</span>
                                                </td>
                                                <td align="center" width="35%">
                                                    <span>Descripción</span>
                                                </td>
                                                <td align="center" width="25%">
                                                    <span>Modelo</span>
                                                </td>
                                                <td align="center" width="25%">
                                                    <span>Serie</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Equipo equi = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioAct" name="radioAct" type="radio" value="<%=equi.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <%=equi.getCodigo()%>
                                                    </td>
                                                    <td align="center" width="35%">
                                                        <%=equi.getDescripcion()%>
                                                    </td>
                                                    <td align="center" width="25%">
                                                        <%=equi.getModelo()%>
                                                    </td>
                                                    <td align="center" width="25%">
                                                        <%=equi.getSerie()%>
                                                    </td>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
                                    }
                                    }
                                    %>
                                    </table>
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
                if (paso != 0){
                %>
                    var sucsel = document.getElementById('sucursalsel');
                    var tactsel = document.getElementById('tipoactsel');
                    if (sucsel.value != '' && tactsel.value != ''){
                        var acciones = document.getElementById('acciones');
                        acciones.style.display = '';
                    }
                <%
                }
                %>
            }
            
            function Activa(fila){
                var idAct = document.getElementById('idAct');
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarAct.radioAct.checked = true;
                    idAct.value = document.frmGestionarAct.radioAct.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarAct.radioAct[fila];
                    radio.checked = true;
                    idAct.value = radio.value;
                <% } %>
                var baja = document.getElementById('btnBaja');
                var edit = document.getElementById('btnEditar');
                var serv = document.getElementById('btnServicios');
                var resg = document.getElementById('btnResguardos');                
                baja.style.display = '';
                edit.style.display = '';
                serv.style.display = '';
                resg.style.display = '';
                    
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/nuevoactivo.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarClick(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/nuevoactivo.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function BajaClick(){
                var resp = confirm('¿Está seguro en dar de baja el Activo seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarAct');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Activos/gestionaractivos.jsp';
                    paso.value = '6';
                    frm.submit();
                }
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/activosinactivos.jsp';
                paso.value = '7';
                frm.submit();
            }
            
            function MostrarActivos(){
                var sucsel = document.getElementById('sucursalsel');
                var tactsel = document.getElementById('tipoactsel');
                if (sucsel.value != '' && tactsel.value != ''){
                    var frm = document.getElementById('frmGestionarAct');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Activos/gestionaractivos.jsp';
                    paso.value = '1';
                    frm.submit();
                } else {
                    var acciones = document.getElementById('acciones');
                    acciones.style.display = 'none';                    
                    var lista = document.getElementById('lista');
                    lista.style.display = 'none';                    
                }
                
            }
            /*
            function FiltrarClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/filtrarproveedores.jsp';
                paso.value = '';
                frm.submit();                
            }
            
            function QuitarFiltroClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '';
                frm.submit();                
            }
            */
            function ServiciosClick(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/Servicios/gestionarservicios.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function AplicarInvClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/aplicarmov.jsp';
                paso.value = '9';
                frm.submit();                
            }
        </script>
    </body>
</html>