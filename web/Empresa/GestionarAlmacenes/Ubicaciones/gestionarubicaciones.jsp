<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Almacen, Modelo.Entidades.Ubicacion"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Almacen alma = (Almacen) datosS.get("almacen");
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
                        Gestionar Ubicaciones<br>
                        ALMACEN: <%=alma.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarUbi" name="frmGestionarUbi" action="<%=CONTROLLER%>/Gestionar/Ubicaciones" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idUbi" name="idUbi" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Empresa/ubicacion01.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="20%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <td width="20%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ver Inactivas">
                                                                <a href="javascript: VerInactivas()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivas.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <td width="40%">
                                                    <table id="borrarEdit" style="display: none;">
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
                                                <td width="20%" align="right">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Nueva">
                                                                <a href="javascript: NuevaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nueva.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                        <table class="tablaLista" width="70%" align="center">
                                        <%
                                        List<Ubicacion> listado = (List<Ubicacion>)datosS.get("ubicaciones");
                                        if (listado.size()==0){
                                        %>
                                            <tr>
                                                <td colspan="4" align="center">
                                                    <span class="etiquetaB">
                                                        No hay Ubicaciones registradas en el almacén
                                                    </span>
                                                </td>
                                            </tr>
                                        <%
                                        } else {
                                        %>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="100%" colspan="2">
                                                        <span>Descripción</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%    
                                                for (int i=0; i < listado.size(); i++){
                                                    Ubicacion ubi = listado.get(i);
                                            %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="10%">
                                                            <input id="radioUbi" name="radioUbi" type="radio" value="<%=ubi.getId()%>"/>
                                                        </td>
                                                        <td align="left" width="90%">
                                                            <span class="etiqueta"><%=ubi.getDescripcion()%></span>
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
            
            function Activa(fila){
                var idUbi = document.getElementById('idUbi');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarUbi.radioUbi.checked = true;
                    idUbi.value = document.frmGestionarUbi.radioUbi.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarUbi.radioUbi[fila];
                    radio.checked = true;
                    idUbi.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarUbi');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/gestionaralmacenes.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevaClick(){
                var frm = document.getElementById('frmGestionarUbi');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/Ubicaciones/nuevaubicacion.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarClick(){
                var frm = document.getElementById('frmGestionarUbi');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/Ubicaciones/nuevaubicacion.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function BajaClick(){
                var resp = confirm('¿Está seguro en dar de baja la Ubicación seleccionada?','SISCAIM');
                if (resp){                
                    var frm = document.getElementById('frmGestionarUbi');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarAlmacenes/Ubicaciones/gestionarubicaciones.jsp';
                    paso.value = '5';
                    frm.submit();
                }
            }
            
            function VerInactivas(){
                var frm = document.getElementById('frmGestionarUbi');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/Ubicaciones/ubicacionesinactivas.jsp';
                paso.value = '6';
                frm.submit();                
            }
            
            function UbicacionesClick(){
                var frm = document.getElementById('frmGestionarAlma');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarAlmacenes/Ubicaciones/gestionarubicaciones.jsp';
                paso.value = '8';
                frm.submit();                
            }
        </script>
    </body>
</html>