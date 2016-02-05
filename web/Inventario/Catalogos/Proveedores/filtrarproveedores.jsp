<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Sucursal, Modelo.Entidades.Ruta"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String sinres = datosS.get("sinresultados")!=null?datosS.get("sinresultados").toString():"";
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
                        Gestionar Proveedores - Filtrar<br>
                        Sucursal <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmFiltrarPro" name="frmFiltrarPro" action="<%=CONTROLLER%>/Gestionar/Proveedores" method="post">
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
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/filtrarProveedores.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="15%" align="right">
                                                    <input id="filtro1" name="filtro1" type="checkbox" onclick="HabilitaCampo(this, 'razonSoc')"/>
                                                </td>
                                                <td width="20%" align="left">
                                                    <span class="etiqueta">Razón Social:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <input id="razonSoc" name="razonSoc" type="text" value=""
                                                           style="width: 480px" onblur="Mayusculas(this)" disabled/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%" align="right">
                                                    <input id="filtro2" name="filtro2" type="checkbox" onclick="HabilitaCampo(this, 'nombre')"/>
                                                </td>
                                                <td width="20%" align="left">
                                                    <span class="etiqueta">Nombre del Proveedor:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <input id="nombre" name="nombre" type="text" value=""
                                                           style="width: 150px" onblur="Mayusculas(this)" disabled/>&nbsp;
                                                    <input id="paterno" name="paterno" type="text" value=""
                                                           style="width: 150px" onblur="Mayusculas(this)" disabled/>&nbsp;
                                                    <input id="materno" name="materno" type="text" value=""
                                                           style="width: 150px" onblur="Mayusculas(this)" disabled/>
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
                                                <td style="padding-right:0px" title ="Aplicar">
                                                    <a href="javascript: AplicarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;"><br/></a>
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
                if (sinres.equals("1")){
                %>
                     Mensaje('Los filtros establecidos no arrojaron resultados');
                <%
                }
                %>
            }
            
            function HabilitaCampo(filtro, objeto){
                valor = true;             
                if (filtro.checked){
                    valor = false;
                }
                
                if (objeto == 'razonSoc'){
                    var campo = document.getElementById(objeto);
                    campo.disabled = valor;
                    campo.value = '';
                    campo.focus();
                } else if (objeto == 'nombre'){
                    var nom = document.getElementById('nombre');
                    nom.disabled = valor;
                    nom.value = '';
                    nom.focus();
                    var pat = document.getElementById('paterno');
                    pat.disabled = valor;
                    pat.value = '';
                    var mat = document.getElementById('materno');
                    mat.disabled = valor;
                    mat.value = '';
                }
            }
            
            function AplicarClick(){
                if (Valida()){
                    var frm = document.getElementById('frmFiltrarPro');
                    frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                    frm.pasoSig.value = '10';
                    frm.submit();                    
                }
            }
            
            function Valida(){
                var filtro1 = document.getElementById('filtro1');
                if (filtro1.checked){
                    var razon = document.getElementById('razonSoc');
                    if (razon.value == ''){
                        Mensaje('El campo Razón Social está vacío');
                        razon.focus();
                        return false;
                    }
                }
                var filtro2 = document.getElementById('filtro2');
                if (filtro2.checked){
                    var nombre = document.getElementById('nombre');
                    var paterno = document.getElementById('paterno');
                    var materno = document.getElementById('materno');
                    if (nombre.value == '' && paterno.value == '' && materno.value == ''){
                        Mensaje('El Nombre del Proveedor debe tener un valor en al menos uno de sus campos');
                        if (nombre.value == '')
                            nombre.focus();
                        else if (paterno.value == '')
                            paterno.focus();
                        else if (materno.value == '')
                            materno.focus();
                        return false;
                    }
                }
                
                return true;
            }

            function CancelarClick(){
                var frm = document.getElementById('frmFiltrarPro');
                frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                frm.pasoSig.value = '96';
                frm.submit();
            }
        </script>
    </body>
</html>