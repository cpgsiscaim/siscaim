<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Unidad"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String descrip = "", entero = "", fraccion = "", clave = "";
    HashMap datosS = sesion.getDatos();
    String titulo = "Nueva Unidad";
    String imagen = "unidadesB.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Unidad";
        imagen = "unidadesC.png";
        Unidad uni = (Unidad)datosS.get("unidad");
        clave = uni.getClave();
        descrip = uni.getDescripcion();
        entero = Float.toString(uni.getEntero());
        fraccion = Float.toString(uni.getFraccion());
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Inventario / Catálogos<br>
                        Gestionar Unidades / <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaUni" name="frmNuevaUni" action="<%=CONTROLLER%>/Gestionar/Unidades" method="post">
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
                                                    <input id="clave" name="clave" type="text" value="<%=clave%>"
                                                           onblur="Mayusculas(this)" maxlength="3" style="width: 150px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
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
                                                    <span class="etiqueta">Representación Entera:</span><br>
                                                    <input id="entero" name="entero" type="text" value="<%=entero%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaCantidad(event, this.value)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Representación Decimal:</span><br>
                                                    <input id="fraccion" name="fraccion" type="text" value="<%=fraccion%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaCantidad(event, this.value)"/>
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
                    Unidad uniT = (Unidad)datosS.get("unidad");
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    var clave = document.getElementById('clave');
                    var descr = document.getElementById('descripcion');
                    var entero = document.getElementById('entero');
                    var fraccion = document.getElementById('fraccion');
                    clave.value = '<%=uniT.getClave()%>';
                    descr.value = '<%=uniT.getDescripcion()%>';
                    entero.value = '<%=Float.toString(uniT.getEntero())%>';
                    fraccion.value = '<%=Float.toString(uniT.getFraccion())%>';
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
                var frm = document.getElementById('frmNuevaUni');
                frm.paginaSig.value = '/Inventario/Catalogos/Unidades/gestionarunidades.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaUni');
                    frm.paginaSig.value = '/Inventario/Catalogos/Unidades/gestionarunidades.jsp';
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
                    Mensaje('La Clave de la Unidad está vacía');
                    clave.focus();
                    return false;
                }
                
                var descr = document.getElementById('descripcion');
                if (descr.value == ''){
                    Mensaje('La Descripción de la Unidad está vacía');
                    descr.focus();
                    return false;
                }
                
                var entero = document.getElementById('entero');
                if (entero.value == ''){
                    Mensaje('La Representación Entera de la Unidad está vacía');
                    entero.focus();
                    return false;
                }
                
                var fraccion = document.getElementById('fraccion');
                if (fraccion.value == ''){
                    Mensaje('La Representación Decimal de la Unidad está vacía');
                    fraccion.focus();
                    return false;
                }
                
                return true;
            }
        
            function limpiar(nombreObj1, nombreObj2)
            {
                obj = document.getElementById(nombreObj1);
                obj.value='';
                obj = document.getElementById(nombreObj2);
                obj.value='';
            }

            function cambiaFecha(fecha, nombreObj)
            {
                d = fecha.substr(0,2);
                m = fecha.substr(3,2);
                y = fecha.substr(6,4);
                txtFecha = document.getElementById(nombreObj);
                txtFecha.value=y+'-'+m+'-'+d;
            }

        </script>
    </body>
</html>