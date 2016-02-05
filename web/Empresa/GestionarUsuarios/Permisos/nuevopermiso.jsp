<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Usuario, Modelo.Entidades.Operacion"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Usuario usu = (Usuario)datosS.get("usuario");
    String titulo = "Nuevo Permiso";
    String imagen = "permisosB.png";
    List<Operacion> operaciones = (List<Operacion>)datosS.get("operaciones");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Usuarios - Permisos - <%=titulo%><br>
                        USUARIO: <%=usu.getEmpleado().getPersona().getNombreCompleto()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoPer" name="frmNuevoPer" action="<%=CONTROLLER%>/Gestionar/Permisos" method="post">
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
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="280" height="200">
                                    </td>
                                    <td width="70%" valign="top">
                                        <%if (operaciones.isEmpty()){%>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="etiquetaB">
                                                        No hay operaciones disponibles para asignar al usuario
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                        <%} else {%>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Operación:</span><br>
                                                    <select id="operacion" name="operacion" class="combo" style="width: 500px">
                                                        <option value="">Elija la Operación...</option>
                                                    <%
                                                        for (int i=0; i < operaciones.size(); i++){
                                                            Operacion oper = operaciones.get(i);
                                                    %>
                                                            <option value="<%=oper.getIdoperacion()%>">
                                                                <%=oper.getOperacion()%>
                                                            </option>
                                                    <%
                                                    }
                                                    %>
                                                    </select>
                                                </td>
                                            </tr>
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
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0 <%if (operaciones.isEmpty()){%>style="display: none"<%}%>>
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

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoPer');
                frm.paginaSig.value = '/Empresa/GestionarUsuarios/Permisos/gestionarpermisos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoPer');
                    frm.paginaSig.value = '/Empresa/GestionarUsuarios/Permisos/gestionarpermisos.jsp';
                    frm.pasoSig.value = '2';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var operacion = document.getElementById('operacion');
                if (operacion.value == ''){
                    Mensaje('La Operación no ha sido establecida');
                    return false;
                }
                
                return true;
            }
        
        </script>
    </body>
</html>