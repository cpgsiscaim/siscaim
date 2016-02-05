<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Equipo, Modelo.Entidades.Catalogos.TipoActivo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Equipo> listado = new ArrayList<Equipo>();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
TipoActivo tactSel = (TipoActivo)datosS.get("tipoactSel");
String imagen = "";
    switch (tactSel.getId()){
        case 1:
            imagen = "maquinaD.png";
            break;
        case 2:
            imagen = "vehiculosD.png";
            break;
        case 3:
            imagen = "herramientaD.png";
            break;
    }

listado = datosS.get("inactivos")!=null?(List<Equipo>)datosS.get("inactivos"):new ArrayList<Equipo>();
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
                        Gestionar Activos - Inactivos
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
                                    <img src="/siscaim/Imagenes/Inventario/Activos/<%=imagen%>" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
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
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Activos en baja en la Sucursal y el Tipo de Activo seleccionados 
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
                                                Equipo act = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioAct" name="radioAct" type="radio" value="<%=act.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <%=act.getCodigo()%>
                                                    </td>
                                                    <td align="center" width="35%">
                                                        <%=act.getDescripcion()%>
                                                    </td>
                                                    <td align="center" width="25%">
                                                        <%=act.getModelo()%>
                                                    </td>
                                                    <td align="center" width="25%">
                                                        <%=act.getSerie()%>
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
                var activar = document.getElementById('btnActivar');
                activar.style.display = '';                    
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/gestionaractivos.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarClick(){
                var frm = document.getElementById('frmGestionarAct');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Activos/activosinactivos.jsp';
                paso.value = '8';
                frm.submit();                
            }
        </script>
    </body>
</html>