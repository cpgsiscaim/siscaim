<%-- 
    Document   : nuevo peryded
    Created on : Jun 21, 2012, 9:17:03 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Catalogos.CategoriaDoc"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nueva ";    
    //String imagen = "inventarioA.png";
    CategoriaDoc catdoc = new CategoriaDoc();
    String descripcion = "";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar ";
        catdoc = (CategoriaDoc)datosS.get("categoriadoc");
        descripcion = catdoc.getDescripcion();
        //imagen = "inventarioA.png";
    }
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
                <td width="20%" align="center" valign="top">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/docs01.png" align="center" width="180" height="100">
                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        GESTIONAR CATEGOR&Iacute;AS DE DOCUMENTACI&Oacute;N
                    </div>
                    <div class="titulo" align="center">
                        <%=titulo%> Categor&iacute;a de Documentaci&oacute;n
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaCatDoc" name="frmNuevaCatDoc" action="<%=CONTROLLER%>/Gestionar/CategoriasDocs" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="40%" align="center">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descripcion" name="descripcion" type="text" 
                                                           style="width: 400px" onkeypress="return ValidaRazonSocial(event, this.value)" value="<%=descripcion%>"
                                                           onblur="Mayusculas(this)" maxlength="100"/>
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
                var desc = document.getElementById('descripcion');
                desc.focus();

            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevaCatDoc');
                frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/categoriasdocs.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaCatDoc');
                    frm.paginaSig.value = '/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/categoriasdocs.jsp';
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
                var desc = document.getElementById('descripcion');                
                
                if (desc.value == ''){
                    Mensaje('El campo Descripción está vacío');
                    desc.focus();
                    return false;
                }                
                return true;
            }
        
        </script>
    </body>
</html>