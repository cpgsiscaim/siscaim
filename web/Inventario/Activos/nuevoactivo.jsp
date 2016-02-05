<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Equipo, Modelo.Entidades.Catalogos.TipoActivo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String codigo = "", descrip = "", placa = "", serie = "", motor = "", modelo = "", factura = "", caract = "", precio = "";
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo Activo";
    String imagen = "";
    TipoActivo tactSel = (TipoActivo)datosS.get("tipoactSel");
    switch (tactSel.getId()){
        case 1:
            imagen = "maquinaB.png";
            break;
        case 2:
            imagen = "vehiculosB.png";
            break;
        case 3:
            imagen = "herramientaB.png";
            break;
    }
    
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Activo";
        //imagen = "inventarioC.png";
        switch (tactSel.getId()){
            case 1:
                imagen = "maquinaC.png";
                break;
            case 2:
                imagen = "vehiculosC.png";
                break;
            case 3:
                imagen = "herramientaC.png";
                break;
        }
        Equipo activo = (Equipo)datosS.get("activo");
        codigo = activo.getCodigo();
        descrip = activo.getDescripcion();
        placa = activo.getPlaca();
        serie = activo.getSerie();
        motor = activo.getMotor();
        modelo = activo.getModelo();
        factura = activo.getFactura();
        caract = activo.getCaracteristicas();
        precio = Float.toString(activo.getPrecio());
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
                        Gestionar Activos / <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoAct" name="frmNuevoAct" action="<%=CONTROLLER%>/Gestionar/Activos" method="post">
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
                                        <img src="/siscaim/Imagenes/Inventario/Activos/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Código:</span><br>
                                                    <input id="codigo" name="codigo" type="text" value="<%=codigo%>"
                                                           onblur="Mayusculas(this)" maxlength="20" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Descripción:</span><br>
                                                    <input id="descripcion" name="descripcion" type="text" value="<%=descrip%>"
                                                           onblur="Mayusculas(this)" maxlength="30" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Serie:</span><br>
                                                    <input id="serie" name="serie" type="text" value="<%=serie%>"
                                                           onblur="Mayusculas(this)" maxlength="30" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Modelo:</span><br>
                                                    <input id="modelo" name="modelo" type="text" value="<%=modelo%>"
                                                           onblur="Mayusculas(this)" maxlength="50" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" colspan="2">
                                                    <table id="auto" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Placa:</span><br>
                                                                <input id="placa" name="placa" type="text" value="<%=placa%>"
                                                                    onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                                    onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <span class="etiqueta">Motor:</span><br>
                                                                <input id="motor" name="motor" type="text" value="<%=motor%>"
                                                                    onblur="Mayusculas(this)" maxlength="30" style="width: 300px"
                                                                    onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Factura:</span><br>
                                                    <input id="factura" name="factura" type="text" value="<%=factura%>"
                                                           onblur="Mayusculas(this)" maxlength="20" style="width: 300px"
                                                           onkeypress="return ValidaAlfaNumSignos(event)"/>
                                                </td>
                                                <td width="50%" align="left">
                                                    <span class="etiqueta">Precio:</span><br>
                                                    <input id="precio" name="precio" type="text" value="<%=precio%>"
                                                           onblur="Mayusculas(this)" maxlength="10" style="width: 300px"
                                                           onkeypress="return ValidaCantidad(event, this.value)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" align="left" colspan="2">
                                                    <span class="etiqueta">Características:</span><br>
                                                    <input id="caracteristicas" name="caracteristicas" type="text" value="<%=caract%>"
                                                           onblur="Mayusculas(this)" maxlength="120" style="width: 650px"
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
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                if (tactSel.getId() == 2){ //vehiculo
                %>
                     var auto = document.getElementById('auto');
                     auto.style.display = '';
                <%
                }
                %>
                var codigo = document.getElementById('codigo');
                codigo.focus();
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoAct');
                frm.paginaSig.value = '/Inventario/Activos/gestionaractivos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoAct');
                    frm.paginaSig.value = '/Inventario/Activos/gestionaractivos.jsp';
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
                var descrip = document.getElementById('descripcion');
                if (descrip.value == ''){
                    Mensaje('La Descripción del Activo está vacía');
                    descrip.focus();
                    return false;
                }

                var modelo = document.getElementById('modelo');
                if (modelo.value == ''){
                    Mensaje('El Modelo del Activo está vacío');
                    modelo.focus();
                    return false;
                }

                return true;
            }
        
        </script>
    </body>
</html>