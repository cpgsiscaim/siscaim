<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datos = sesion.getDatos();
String logoSel = datos.get("logoSel")!=null?"Logotipo/"+datos.get("logoSel").toString():"carita01.png";
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
                        Configurar Empresa - Nuevo Logotipo
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoLogoAlt" name="frmNuevoLogoAlt" action="<%=CONTROLLER%>/Configurar/Empresa" method="post">
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="logoNuevo" name="logoNuevo" type="hidden" value=""/>
        </form>
            
        <form id="frmNuevoLogo" name="frmNuevoLogo" action="<%=CONTROLLER%>/Nuevo/Logo" enctype="multipart/form-data" method="post">
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
                                        <img src="/siscaim/Imagenes/Empresa/empresa01.png" align="center" width="300" height="250">
                                        <input id="logoNuevo" name="logoNuevo" type="hidden" value=""/>
                                    </td>
                                    <td width="70%" valign="center">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Elija el nuevo logotipo:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="logoFile" name="logoFile" type="file" accept="images/*.png"
                                                           onchange="CargaImagen(this.value)">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <img src="/siscaim/Imagenes/Empresa/<%=logoSel%>"
                                                         align="center" width="300" height="250">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="50%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarLogoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="50%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarLogoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
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
                var titulo = document.getElementById('tituloCon');
                titulo.focus();
            }
            
            function GuardarLogoClick(){
                <%
                if (datos.get("logoSel")==null){
                %>
                        Mensaje('Debe seleccionar la imagen del nuevo logotipo');
                        return;
                <%
                }
                %>
                var frm = document.getElementById('frmNuevoLogoAlt');
                frm.logoNuevo.value = '<%=logoSel%>';
                frm.pasoSig.value = '41';
                frm.paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
                frm.submit();
            }
            
            function CargaImagen(archivo){
                tokens = archivo.split('\\');
                nombreArch = tokens[tokens.length-1];
                var frm = document.getElementById('frmNuevoLogo');
                frm.logoNuevo.value=nombreArch;
                frm.pasoSig.value = '1';
                frm.paginaSig.value = '/Empresa/ConfigurarEmpresa/nuevologoempr.jsp';
                frm.submit();
            }
            
            function CancelarLogoClick(){
                var frm = document.getElementById('frmNuevoLogoAlt');
                frm.paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
                frm.pasoSig.value = '1';
                frm.submit();
            }

        </script>
    </body>
</html>