<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Serie"%>

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
                <td width="100%">
                    <div class="titulo" align="center">
                        Inventario / Catálogos<br>Gestionar Series - Inactivas
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarSerIn" name="frmGestionarSerIn" action="<%=CONTROLLER%>/Gestionar/Series" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idSer" name="idSer" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Inventario/Catalogos/seriesA.png" align="center" width="300" height="250">
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
                                            <td width="50%" align="center">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="100%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Activar">
                                                                        <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>

                                    <hr>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    List<Serie> listado = (List<Serie>)datosS.get("inactivas");
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Series Inactivas
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="5%">    
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Serie</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Folio</span>
                                                </td>
                                                <td align="center" width="35%">
                                                    <span>Descripción</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Formato</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Puerto</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Serie ser = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioSer" name="radioSer" type="radio" value="<%=ser.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiqueta">
                                                            <%=ser.getSerie()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiqueta">
                                                            <%=Float.toString(ser.getFolio())%>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="35%">
                                                        <span class="etiqueta"><%=ser.getDescripcion()%></span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiqueta"><%=ser.getFormato()%></span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiqueta"><%=ser.getPuerto()%></span>
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
                var idSer = document.getElementById('idSer');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarSerIn.radioSer.checked = true;
                    idSer.value = document.frmGestionarSerIn.radioSer.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarSerIn.radioSer[fila];
                    radio.checked = true;
                    idSer.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarSerIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Series/gestionarseries.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarClick(){
                var frm = document.getElementById('frmGestionarSerIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Series/seriesinactivas.jsp';
                paso.value = '7';
                frm.submit();                
            }
        </script>
    </body>
</html>