<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Catalogos.TipoActivo"%>
<%@page import="Modelo.Entidades.Equipo, Modelo.Entidades.Servicio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Equipo activo = (Equipo)datosS.get("activo");
List<Servicio>listado = datosS.get("servinactivos")!=null?(List<Servicio>)datosS.get("servinactivos"):new ArrayList<Servicio>();
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
                        Gestionar Servicios - Inactivos<br>
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
                                            <td width="50%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnActivar a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnActivar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Activar">
                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
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
                                                    No hay Servicios inactivos del Activo seleccionado 
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
                var activar = document.getElementById('btnActivar');
                activar.style.display = '';
                    
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarServ');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/Servicios/gestionarservicios.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarClick(){
                var frm = document.getElementById('frmGestionarServ');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/Servicios/serviciosinactivos.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
        </script>
    </body>
</html>