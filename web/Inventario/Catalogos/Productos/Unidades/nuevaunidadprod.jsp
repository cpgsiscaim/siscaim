<%@page import="Modelo.Entidades.UnidadProducto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.List, java.util.HashMap, Modelo.Entidades.Producto, Modelo.Entidades.Unidad, Modelo.Entidades.UnidadProducto"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Producto prod = (Producto)datosS.get("producto");
    String titulo = "Nueva Unidad de Salida";
    String imagen = "marcasB.png";
    String valor = "";
    Unidad unprod = new Unidad();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Unidad de Salida";
        imagen = "marcasC.png";
        UnidadProducto up = (UnidadProducto)datosS.get("uniprod");
        unprod = up.getUnidad();
        valor = Float.toString(up.getValor());
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
                <td width="100%">
                    <div class="titulo" align="center">
                        Inventario / Catálogos<br>
                        Gestionar Productos - Unidades de Salida<br>
                        PRODUCTO <%=prod.getDescripcion()%><br><br>
                        <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaUP" name="frmNuevaUP" action="<%=CONTROLLER%>/Gestionar/UnidadesProducto" method="post">
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
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Unidad:</span><br>
                                                    <select id="unidad" name="unidad" class="combo" style="width: 250px">
                                                        <option value="">Elija la Unidad...</option>
                                                        <%
                                                        List<Unidad> unidades = (List<Unidad>)datosS.get("unidades");
                                                        for (int i=0; i < unidades.size(); i++){
                                                            Unidad un = unidades.get(i);
                                                        %>
                                                        <option value="<%=un.getId()%>" <%if (un.getId()==unprod.getId()){%>selected<%}%>>
                                                            <%=un.getDescripcion()%> (<%=un.getClave()%>)
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Factor:</span><br>
                                                    <input id="valor" name="valor" type="text" value="<%=valor%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 200px"
                                                           onkeypress="return ValidaCantidad(event)"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
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
                    Mensaje('<%=sesion.getMensaje()%>');
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
                var frm = document.getElementById('frmNuevaUP');
                frm.paginaSig.value = '/Inventario/Catalogos/Productos/Unidades/gestionarunidadessalida.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaUP');
                    frm.paginaSig.value = '/Inventario/Catalogos/Productos/Unidades/gestionarunidadessalida.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '4';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '2';
                <%
                    }
                %>
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                var unidad = document.getElementById('unidad');
                if (unidad.value == ''){
                    Mensaje('La Unidad está vacía');
                    unidad.focus();
                    return false;
                }
                
                var valor = document.getElementById('valor');
                if (valor.value == ''){
                    Mensaje('El Factor está vacío');
                    valor.focus();
                    return false;
                }
                                
                return true;
            }
        </script>
    </body>
</html>