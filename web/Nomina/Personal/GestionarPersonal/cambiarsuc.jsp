<%-- 
    Document   : cambiar sucursal
    Created on : Agosto 14, 2013
    Author     : temoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- aqui poner los imports--%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Persona, Modelo.Entidades.Empleado"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
List<Sucursal> sucscambio = (List<Sucursal>)datosS.get("sucscambio");
Sucursal sucSel = (Sucursal)datosS.get("sucursal");
Empleado emp = (Empleado)datosS.get("empleado");
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
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/empleadosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="subtitulo" align="left">
                        CAMBIAR DE SUCURSAL AL EMPLEADO
                    </div>
                    <div class="subtitulo" align="left">
                        <%=emp.getClave()%> - <%=emp.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGesPersonal" name="frmGesPersonal" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">                                
                <tr>
                    <td width="100%" valign="top">
                        <table width="50%" align="center">
                            <tr>
                                <td width="100%" align="left">
                                    <span class="etiquetaB">Sucursal Actual:</span>
                                    <span class="etiqueta"><%=sucSel.getDatosfis().getRazonsocial()%></span>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%" align="left">
                                    <span class="etiquetaB">Sucursal Nueva:</span>
                                    <select id="nuevasucursal" name="nuevasucursal" class="combo" style="width: 300px">
                                        <option value="0">Elija la Sucursal...</option>
                                        <%for (int i=0; i < sucscambio.size(); i++){
                                            Sucursal suc = sucscambio.get(i);
                                        %>
                                            <option value="<%=suc.getId()%>">
                                                <%=suc.getDatosfis().getRazonsocial()%>
                                            </option>
                                        <%}%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <table width="50%" align="center">
                            <tr>
                                <td width="50%" align="right">
                                    <style>#btnGuardar a{display:block;color:transparent;} #btnGuardar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                    <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0>
                                        <tr>
                                            <td style="padding-right:0px" title ="Guardar">
                                                <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                            </td>
                                        </tr>
                                    </table>                                                    
                                </td>
                                <td width="50%" align="center">
                                    <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                    <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                        <tr>
                                            <td style="padding-right:0px" title ="Cancelar">
                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                            </td>
                                        </tr>
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

        function GuardarClick(){
            var nvasuc = document.getElementById('nuevasucursal');
            if (nvasuc.value == '0'){
                Mensaje('Debe seleccionar la nueva sucursal');
                return;
            }
            
            var frm = document.getElementById('frmGesPersonal');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
            paso.value = '24';
            frm.submit();                    
        }

        function CancelarClick(){
            var frm = document.getElementById('frmGesPersonal');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
            paso.value = '93';
            frm.submit();                    
        }
        </script>
    </body>
</html>
