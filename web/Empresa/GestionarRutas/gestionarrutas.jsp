<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Ruta"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Ruta> listado = new ArrayList<Ruta>();//(List<Cliente>)datosS.get("listado");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
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
                        Gestionar Rutas
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarRutas" name="frmGestionarRutas" action="<%=CONTROLLER%>/Gestionar/Rutas" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idRuta" name="idRuta" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Empresa/rutas01A.png" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnInactivas a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivas" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivas">
                                                            <a href="javascript: VerInactivas()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivas.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                            </td>
                                            <td width="15%" align="center">
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nueva">
                                                            <a href="javascript: NuevaRutaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="25%" align="right">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px"
                                                        onchange="MostrarRutas()">
                                                    <option value="0">Elija la Sucursal...</option>
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
                                        </tr>
                                    </table>
                                    <table id="borrarEdit" width="100%" style="display: none">
                                        <tr>
                                            <td width="70%" align="right">&nbsp;</td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Baja">
                                                            <a href="javascript: BajaRutaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Editar">
                                                            <a href="javascript: EditarRutaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>

                                    <hr>
                                    <table class="tablaLista" width="50%" align="center">
                                    <%
                                    if (sucSel.getId()!=0){
                                        listado = (List<Ruta>)datosS.get("listado");
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <span class="etiquetaB">
                                                    No hay Rutas registradas en la Sucursal seleccionada
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="100%" colspan="2">
                                                    <span>Ruta</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Ruta ruta = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioRuta" name="radioRuta" type="radio" value="<%=ruta.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="90%">
                                                        <span class="etiqueta"><%=ruta.getDescripcion()%></span>
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
                //if (paso != 0){
                    if (sucSel.getId()!=0){
                        //activar botones
                    %>
                        var btnInactivas = document.getElementById('btnInactivas');
                        btnInactivas.style.display = '';
                        var btnNuevo = document.getElementById('btnNuevo');
                        btnNuevo.style.display = '';
                    <%
                    }
                //}
                %>
            }
            
            function Activa(fila){
                var idRuta = document.getElementById('idRuta');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarRutas.radioRuta.checked = true;
                    idRuta.value = document.frmGestionarRutas.radioRuta.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarRutas.radioRuta[fila];
                    radio.checked = true;
                    idRuta.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarRutas');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevaRutaClick(){
                var frm = document.getElementById('frmGestionarRutas');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarRutas/nuevaruta.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarRutaClick(){
                var frm = document.getElementById('frmGestionarRutas');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarRutas/nuevaruta.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function BajaRutaClick(){
                var resp = confirm('¿Está seguro en dar de baja la Ruta seleccionada?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarRutas');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarRutas/gestionarrutas.jsp';
                    paso.value = '6';
                    frm.submit();
                }
            }
            
            function VerInactivas(){
                var frm = document.getElementById('frmGestionarRutas');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarRutas/rutasinactivas.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
            function MostrarRutas(){
                var frm = document.getElementById('frmGestionarRutas');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarRutas/gestionarrutas.jsp';
                paso.value = '1';
                frm.submit();                    
            }
        </script>
    </body>
</html>