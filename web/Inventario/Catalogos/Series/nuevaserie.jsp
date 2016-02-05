<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Serie"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String serie = "", folio = "", descrip = "", formato = "", puerto = "";
    HashMap datosS = sesion.getDatos();
    String titulo = "Nueva Serie";
    String imagen = "seriesB.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Serie";
        imagen = "seriesC.png";
        Serie ser = (Serie)datosS.get("serie");
        serie = ser.getSerie();
        folio = Float.toString(ser.getFolio());
        descrip = ser.getDescripcion();
        formato = ser.getFormato();
        puerto = ser.getPuerto();
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
                        Gestionar Series / <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaSer" name="frmNuevaSer" action="<%=CONTROLLER%>/Gestionar/Series" method="post">
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
                                                    <span class="etiqueta">Clave:</span><br>
                                                    <input id="clave" name="clave" type="text" value="<%=serie%>"
                                                           onblur="Mayusculas(this)" maxlength="2" style="width: 150px"
                                                           onkeypress="return ValidaAlfaNum(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Folio:</span><br>
                                                    <input id="folio" name="folio" type="text" value="<%=folio%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaCantidad(event, this.value)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descripcion" name="descripcion" type="text" value="<%=descrip%>"
                                                           onblur="Mayusculas(this)" maxlength="25" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Formato:</span><br>
                                                    <input id="formato" name="formato" type="text" value="<%=formato%>"
                                                           onblur="Mayusculas(this)" maxlength="30" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Puerto:</span><br>
                                                    <input id="puerto" name="puerto" type="text" value="<%=puerto%>"
                                                           onblur="Mayusculas(this)" maxlength="120" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
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
                    Serie serT = (Serie)datosS.get("serie");
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    var clave = document.getElementById('clave');
                    var folio = document.getElementById('folio');
                    var descrip = document.getElementById('descripcion');
                    var formato = document.getElementById('formato');
                    var puerto = document.getElementById('puerto');
                    clave.value = '<%=serT.getSerie()%>';
                    folio.value = '<%=Float.toString(serT.getFolio())%>'
                    descrip.value = '<%=serT.getDescripcion()%>';
                    formato.value = '<%=serT.getFormato()%>';
                    puerto.value = '<%=serT.getPuerto()%>';
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
                var clave = document.getElementById('clave');
                clave.focus();
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevaSer');
                frm.paginaSig.value = '/Inventario/Catalogos/Series/gestionarseries.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaSer');
                    frm.paginaSig.value = '/Inventario/Catalogos/Series/gestionarseries.jsp';
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
                var clave = document.getElementById('clave');
                if (clave.value == ''){
                    Mensaje('La Clave de la Serie está vacía');
                    clave.focus();
                    return false;
                }
                
                var folio = document.getElementById('folio');
                if (folio.value == ''){
                    Mensaje('El Folio de la Serie está vacío');
                    folio.focus();
                    return false;
                }
                
                var descr = document.getElementById('descripcion');
                if (descr.value == ''){
                    Mensaje('La Descripción de la Serie está vacía');
                    descr.focus();
                    return false;
                }
                                
                return true;
            }
        
        </script>
    </body>
</html>