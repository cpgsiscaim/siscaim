<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Categoria, Modelo.Entidades.Subcategoria"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String descrip = "", fechaSql = "", fechaNorm = "", clave = "";
    HashMap datosS = sesion.getDatos();
    Categoria catSel = (Categoria)datosS.get("categoriaEditar");
    String titulo = "Nueva Subategoría";
    String imagen = "subcatB.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Subcategoría";
        imagen = "subcatC.png";
        Subcategoria scat = (Subcategoria)datosS.get("subcat");
        clave = scat.getClave();
        descrip = scat.getDescripcion();
        fechaSql = scat.getFechaAlta().toString();
        fechaNorm = fechaSql.substring(8,10) + "-" + fechaSql.substring(5,7) + "-" + fechaSql.substring(0, 4);
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
                        Inventario / Catálogos / Categorías<br>
                        Gestionar Subcategorías / <%=titulo%><br><br>
                        CATEGORIA <%=catSel.getClave()%> - <%=catSel.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaSub" name="frmNuevaSub" action="<%=CONTROLLER%>/Gestionar/Subcategorias" method="post">
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
                                                           onblur="Mayusculas(this)" maxlength="5" style="width: 150px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descripcion" name="descripcion" type="text" value="<%=descrip%>"
                                                           onblur="Mayusculas(this)" maxlength="50" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="left"></td>
                                                <td width="80%" align="left">
                                                    <span class="etiqueta">Fecha de Alta:</span><br>
                                                    <input id="fechaAlta" name="fechaAlta" value="<%=fechaSql%>" type="hidden">
                                                    <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechaNorm%>" onchange="cambiaFecha(this.value,'fechaAlta')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmNuevaSub.rgFecha,'dd-mm-yyyy',document.frmNuevaSub.rgFecha)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFecha', 'fechaAlta')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
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
                    Subcategoria scatT = (Subcategoria)datosS.get("subcat");
                    SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
                    String fechaSqlT = formatoDelTexto.format(scatT.getFechaAlta());
                    String fechaNormT = fechaSqlT.substring(8,10) + "-" + fechaSqlT.substring(5,7) + "-" + fechaSqlT.substring(0, 4);

                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    var clave = document.getElementById('clave');
                    var descr = document.getElementById('descripcion');
                    var fechaH = document.getElementById('fechaAlta');
                    var fechaV = document.getElementById('rgFecha');
                    clave.value = '<%=scatT.getClave()%>';
                    descr.value = '<%=scatT.getDescripcion()%>';
                    fechaH.value = '<%=fechaSqlT%>';
                    fechaV.value = '<%=fechaNormT%>';
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
                var frm = document.getElementById('frmNuevaSub');
                frm.paginaSig.value = '/Inventario/Catalogos/Categorias/Subcategorias/gestionarsubcat.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevaSub');
                    frm.paginaSig.value = '/Inventario/Catalogos/Categorias/Subcategorias/gestionarsubcat.jsp';
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
                    Mensaje('La Clave de la Categoría está vacía');
                    clave.focus();
                    return false;
                }
                
                var descr = document.getElementById('descripcion');
                if (descr.value == ''){
                    Mensaje('La Descripción de la Categoría está vacía');
                    descr.focus();
                    return false;
                }
                
                var fecha = document.getElementById('fechaAlta');
                if (fecha.value == ''){
                    Mensaje('La Fecha de Alta de la Categoría no se ha establecido');
                    fecha.focus();
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