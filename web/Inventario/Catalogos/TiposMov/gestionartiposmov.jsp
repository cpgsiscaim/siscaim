<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.TipoMov"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
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
                        Inventario / Catálogos<br>Gestionar Tipos de Movimientos
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarTmov" name="frmGestionarTmov" action="<%=CONTROLLER%>/Gestionar/TiposMov" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idMov" name="idMov" type="hidden" value=""/>            
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
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
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
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
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
                                            <td width="20%" align="center">
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
                                    <table class="tablaLista" width="80%" align="center">
                                    <%
                                    List<TipoMov> listado = (List<TipoMov>)datosS.get("listado");
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Tipos de Movimientos registrados
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="10%">    
                                                </td>
                                                <td align="center" width="50%">
                                                    <span>Descripción</span>
                                                </td>
                                                <!--
                                                <td align="center" width="20%">
                                                    <span>Valor</span>
                                                </td>-->
                                                <td align="center" width="20%">
                                                    <span>Serie</span>
                                                </td>
                                                <td align="center" width="20%">
                                                    <span>Categoría</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                TipoMov tmov = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioMov" name="radioMov" type="radio" value="<%=tmov.getId()%>"/>
                                                    </td>
                                                    <td align="left" width="50%">
                                                        <span class="etiqueta">
                                                            <%=tmov.getDescripcion()%>
                                                        </span>
                                                    </td>
                                                    <%--
                                                    <td align="center" width="20%">
                                                        <span class="etiqueta">
                                                            <%=Integer.toString(tmov.getValor())%>
                                                        </span>
                                                    </td>--%>
                                                    <td align="center" width="20%">
                                                        <span class="etiqueta"><%=tmov.getSerie()!=null?tmov.getSerie().getDescripcion():""%></span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiqueta"><%=tmov.getCategoria()==1?"ENTRADA":"SALIDA"%></span>
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
                var idMov = document.getElementById('idMov');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarTmov.radioMov.checked = true;
                    idMov.value = document.frmGestionarTmov.radioMov.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarTmov.radioMov[fila];
                    radio.checked = true;
                    idMov.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarTmov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                var frm = document.getElementById('frmGestionarTmov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/TiposMov/nuevotipomov.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarClick(){
                var frm = document.getElementById('frmGestionarTmov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/TiposMov/nuevotipomov.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function BajaClick(){
                var resp = confirm('¿Está seguro en dar de baja el Tipo de Movimiento seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarTmov');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Catalogos/TiposMov/gestionartiposmov.jsp';
                    paso.value = '5';
                    frm.submit();
                }
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarTmov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/TiposMov/tiposmovinactivos.jsp';
                paso.value = '6';
                frm.submit();
            }
                        
        </script>
    </body>
</html>