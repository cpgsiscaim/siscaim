<%@page import="Modelo.Entidades.Medio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Catalogos.TipoMedio, Modelo.Entidades.Medio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datos = sesion.getDatos();
int paso = Integer.parseInt(datos.get("paso").toString());
String titulo = "Nuevo Medio";
Medio edit = new Medio();
if (paso == 12){
    edit= (Medio) datos.get("editarMedio");
    titulo = "Editar Medio";
}
else
    edit = null;
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
                <td width="20%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Medios/mediosA.png" align="center" width="180" height="100">
                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        CONFIGURAR EMPRESA<br>
                        <%=titulo.toUpperCase()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMedio" name="frmNuevoMedio" action="<%=CONTROLLER%>/Configurar/Empresa" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%" align="center">
                                <tr>
                                    <td width="30%">&nbsp;</td>
                                    <td width="70%" valign="center">
                                        <table width="100%" align="center">
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Tipo:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <select id="tipomedio" name="tipomedio" class="combo"
                                                            style="width: 300px" onchange="ActivaMedio(this.value)">
                                                        <option value="0">Elija el tipo de medio...</option>
                                                        <%
                                                        List<TipoMedio> tiposMed = (List<TipoMedio>) datos.get("tiposmedios");
                                                        for (int i=0; i < tiposMed.size(); i++){
                                                            TipoMedio tipo = tiposMed.get(i);
                                                            if (paso == 10){
                                                            %>
                                                            <option value="<%=tipo.getIdtipomedio()%>">
                                                                <%=tipo.getTipomedio()%>
                                                            </option>
                                                            <%
                                                            } else if (paso == 12){
                                                            %>
                                                            <option value="<%=tipo.getIdtipomedio()%>"
                                                                <%
                                                                if (edit != null && edit.getTipo().getIdtipomedio()==tipo.getIdtipomedio()){
                                                                %>
                                                                selected
                                                                <%}%>
                                                            >
                                                                <%=tipo.getTipomedio()%>
                                                            </option>
                                                            <%    
                                                            }
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Medio:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="medio" name="medio" type="text" value="<%if (paso==12){%><%=edit.getMedio()%><%}%>" 
                                                           style="width: 300px" onkeypress="return ValidaSegunTipo(event, this.value)" maxlength=""/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="leyenda" class="etiquetaC" style="display: none">
                                                        (10 dígitos)
                                                    </span>
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
                                                    <a href="javascript: GuardarMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="50%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
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
        }
            
            function CancelarMedioClick(){
                var paginaSig = document.getElementById('paginaSig');
                paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
                var pasoSig = document.getElementById('pasoSig');
                pasoSig.value = '1';
                var frm = document.getElementById('frmNuevoMedio');
                frm.submit();
            }
            
            function ValidaSegunTipo(e, cadena){
                var tipomedio = document.getElementById('tipomedio');
                var medio = document.getElementById('medio');
                if(tipomedio.value=='3'){
                    medio.maxLength = 50;
                    medio.title = '';
                    return ValidaMail(e, cadena);
                }
                else if (tipomedio.value=='1' || tipomedio.value=='2'){
                    medio.maxLength = 10;
                    medio.title = '10 dígitos';                    
                    return ValidaNums(e);
                }
                else
                    return false;
            }
            
            function ActivaMedio(tipo){
                var medio = document.getElementById('medio');
                var leyenda = document.getElementById('leyenda');
                if (tipo == 1 || tipo == 2)
                    leyenda.style.display = '';
                else
                    leyenda.style.display = 'none';
                medio.focus();
                medio.value = '';
            }
            
            function GuardarMedioClick(){
                if (ValidaRequeridos()){
                    var paginaSig = document.getElementById('paginaSig');
                    paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
                    var pasoSig = document.getElementById('pasoSig');
                    <%
                    if (paso == 12){
                    %>
                        pasoSig.value = '13';
                    <%} else {%>
                        pasoSig.value = '11';
                    <%}%>
                    var frm = document.getElementById('frmNuevoMedio');
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var tipom = document.getElementById('tipomedio');
                if (tipom.value == '0'){
                    Mensaje('Debe especificar el tipo de medio');
                    tipom.focus();
                    return false;
                }
                
                var medio = document.getElementById("medio");
                if (medio.value == ''){
                    Mensaje('Debe establecer el medio');
                    medio.focus();
                    return false;
                }
                
                if (tipom.value=='1' || tipom.value=='2'){
                    if (medio.value.length<10){
                        Mensaje('El número debe ser de 10 dígitos exactamente');
                        medio.focus();
                        return false;
                    }
                    //validar que si sea numero
                    if (!ValidaNumsAfter(medio.value)){
                        Mensaje('El número del medio no es válido');
                        medio.focus();
                        return false;
                    }
                }
                
                if (tipom.value == '3'){
                    if (!ValidaMailAfter(medio.value)){
                        Mensaje('El correo ingresado no es válido');
                        medio.focus();
                        return false;
                    }
                }
                
                return true;
            }
        </script>
    </body>
</html>

