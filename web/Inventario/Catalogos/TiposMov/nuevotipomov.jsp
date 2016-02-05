<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Serie, Modelo.Entidades.TipoMov"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String descrip = "", /*valor = "",*/ cate = "";
    Serie serTMov = new Serie();
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo Tipo de Movimiento";
    String imagen = "inventarioB.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Tipo de Movimiento";
        imagen = "inventarioC.png";
        TipoMov tmov = (TipoMov)datosS.get("tipomov");
        descrip = tmov.getDescripcion();
        //valor = Integer.toString(tmov.getValor());
        if (tmov.getSerie()!=null)
            serTMov = tmov.getSerie();
        cate = Integer.toString(tmov.getCategoria());
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
                        Gestionar Tipos de Movimiento / <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMov" name="frmNuevoMov" action="<%=CONTROLLER%>/Gestionar/TiposMov" method="post">
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
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descripcion" name="descripcion" type="text" value="<%=descrip%>"
                                                           onblur="Mayusculas(this)" maxlength="25" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <%--<tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Valor:</span><br>
                                                    <input id="valor" name="valor" type="text" value="<%=valor%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaNums(event)"/>
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Serie:</span><br>
                                                    <select id="serie" name="serie" class="combo" style="width: 300px">
                                                        <option value="0">Elija la Serie...</option>
                                                        <%
                                                        List<Serie> series = (List<Serie>) datosS.get("series");
                                                        for (int i=0; i < series.size(); i++){
                                                            Serie ser = series.get(i);
                                                        %>
                                                        <option value="<%=ser.getId()%>"
                                                                <%
                                                                if (serTMov.getId()==ser.getId()){
                                                                %>
                                                                selected
                                                                <%
                                                                }
                                                                %>>
                                                            <%=ser.getDescripcion()%>
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
                                                    <span class="etiqueta">Categoría:</span><br>
                                                    <select id="categoria" name="categoria" class="combo" style="width: 300px">
                                                        <option value="">Elija la Categoría...</option>
                                                        <option value="1"
                                                                <%
                                                                if (cate.equals("1")){
                                                                %>
                                                                selected
                                                                <%
                                                                }
                                                                %>>                                                                
                                                                ENTRADA</option>
                                                        <option value="2"
                                                                <%
                                                                if (cate.equals("2")){
                                                                %>
                                                                selected
                                                                <%
                                                                }
                                                                %>>                                                                
                                                                SALIDA</option>
                                                    </select>
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
                var descrip = document.getElementById('descripcion');
                descrip.focus();
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Catalogos/TiposMov/gestionartiposmov.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Catalogos/TiposMov/gestionartiposmov.jsp';
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
                var descrip = document.getElementById('descripcion');
                if (descrip.value == ''){
                    Mensaje('La Descripción del Tipo de Movimiento está vacío');
                    descrip.focus();
                    return false;
                }
                
                /*var valor = document.getElementById('valor');
                if (valor.value == ''){
                    Mensaje('El Valor del Tipo de Movimiento está vacío');
                    valor.focus();
                    return false;
                }*/

                var cat = document.getElementById('categoria');
                if (cat.value == ''){
                    Mensaje('La Categoría del Tipo de Movimiento no ha sido establecida');
                    cat.focus();
                    return false;
                }

                return true;
            }
        
        </script>
    </body>
</html>