<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Ruta, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nueva Ruta";
    String imagen = "rutaNueva.png";
    String nomRuta = "";
    Sucursal suc = (Sucursal)datosS.get("sucursalSel");
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Ruta";
        imagen = "rutaEditar.png";
        Ruta ruta = (Ruta)datosS.get("editarRuta");
        nomRuta = ruta.getDescripcion();
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
                        Gestionar Rutas - <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaRuta" name="frmNuevaRuta" action="<%=CONTROLLER%>/Gestionar/Rutas" method="post">
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
                                        <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <span class="eitqueta">Sucursal</span><br>
                                        <input id="sucursal" name="sucursal" type="text" value="<%=suc.getDatosfis().getRazonsocial()%>"
                                               style="width: 200px" disabled/><br>
                                        <span class="etiqueta">Nombre de la Ruta:</span><br>
                                        <input id="nombreRuta" name="nombreRuta" type="text" value="<%=nomRuta%>" style="width: 200px"
                                               maxlength="30" onblur="Mayusculas(this)"/>
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
                var nomRuta = document.getElementById('nombreRuta');
                nomRuta.focus();
            }


            function CancelarClick(){
                var frm = document.getElementById('frmNuevaRuta');
                frm.paginaSig.value = '/Empresa/GestionarRutas/gestionarrutas.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaRuta');
                    frm.paginaSig.value = '/Empresa/GestionarRutas/gestionarrutas.jsp';
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
                var nomRuta = document.getElementById('nombreRuta');
                if (nomRuta.value == ''){
                    Mensaje('El campo Nombre de la Ruta está vacío');
                    nomRuta.focus();
                    return false;
                }
                return true;
            }
        
        </script>
    </body>
</html>