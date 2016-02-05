<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Catalogos.TipoActivo"%>
<%@page import="Modelo.Entidades.Equipo, Modelo.Entidades.Servicio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Equipo activo = (Equipo)datosS.get("activo");
List<Servicio>listado = datosS.get("servicios")!=null?(List<Servicio>)datosS.get("servicios"):new ArrayList<Servicio>();
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
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Servicios<br>
                        ACTIVO: <%=activo.getDescripcion()%> - <%=activo.getModelo()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarServ" name="frmGestionarServ" action="<%=CONTROLLER%>/Gestionar/Servicios" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idServ" name="idServ" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="20%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="20%" align="center">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="40%" align="center">
                                                <table id="acciones" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <style>#btnBaja a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnBaja" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <style>#btnEditar a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnEditar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Editar">
                                                                        <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="20%" align="right">
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
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Servicios registrados del Activo seleccionado 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="50%" colspan="2">
                                                    <span>Descripción</span>
                                                </td>
                                                <td align="center" width="25%">
                                                    <span>Fecha</span>
                                                </td>
                                                <td align="center" width="25%">
                                                    <span>Monto</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Servicio serv = listado.get(i);
                                                String sfech = serv.getFecha().toString();
                                                String sfechN = sfech.substring(8,10) + "-" + sfech.substring(5,7) + "-" + sfech.substring(0, 4);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioServ" name="radioServ" type="radio" value="<%=serv.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="45%">
                                                        <%=serv.getDescripcion()%>
                                                    </td>
                                                    <td align="center" width="25%">
                                                        <%=sfechN%>
                                                    </td>
                                                    <td align="right" width="25%">
                                                        <%=serv.getMonto()%>
                                                    </td>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
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
                %>
            }
            
            function Activa(fila){
                var idServ = document.getElementById('idServ');
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarServ.radioServ.checked = true;
                    idServ.value = document.frmGestionarServ.radioServ.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarServ.radioServ[fila];
                    radio.checked = true;
                    idServ.value = radio.value;
                <% } %>
                var acc = document.getElementById('acciones');
                acc.style.display = '';
                    
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarServ');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/gestionaractivos.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                var frm = document.getElementById('frmGestionarServ');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/Servicios/nuevoservicio.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarClick(){
                var frm = document.getElementById('frmGestionarServ');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/Servicios/nuevoservicio.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function BajaClick(){
                var resp = confirm('¿Está seguro en dar de baja el Servicio seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarServ');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Activos/Servicios/gestionarservicios.jsp';
                    paso.value = '5';
                    frm.submit();
                }
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarServ');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/Servicios/serviciosinactivos.jsp';
                paso.value = '6';
                frm.submit();
            }
            
        </script>
    </body>
</html>