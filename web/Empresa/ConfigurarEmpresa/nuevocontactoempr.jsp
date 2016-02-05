<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Persona"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datos = sesion.getDatos();
int paso = Integer.parseInt(datos.get("paso").toString());
String titulo = "Nuevo Contacto";
Persona edit = new Persona();
if (paso == 22){
    edit= (Persona) datos.get("editarContacto");
    titulo = "Editar Contacto";
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
                    <img src="/siscaim/Imagenes/Empresa/contactos01.png" align="center" width="180" height="100">
                </td>
                <td width="100%">
                    <div class="bigtitulo" align="center">
                        CONFIGURAR EMPRESA<br>
                        <%=titulo.toUpperCase()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoContacto" name="frmNuevoContacto" action="<%=CONTROLLER%>/Configurar/Empresa" method="post">
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
                                        <img src="/siscaim/Imagenes/Empresa/contactos01.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="center">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Título:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="tituloCon" name="tituloCon" type="text" value="<%if (paso==22){%><%=edit.getTitulo()%><%}%>"
                                                           style="width: 300px" onkeypress="return ValidaLetrasYPunto(event, this.value)" onblur="Mayusculas(this)" maxlength="10"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Nombre(s):</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="nombreCon" name="nombreCon" type="text" value="<%if (paso==22){%><%=edit.getNombre()%><%}%>"
                                                           style="width: 300px" onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)" maxlength="30"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Paterno:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="paternoCon" name="paternoCon" type="text" value="<%if (paso==22){%><%=edit.getPaterno()%><%}%>"
                                                           style="width: 300px" onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)" maxlength="20"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Materno:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="maternoCon" name="maternoCon" type="text" value="<%if (paso==22){%><%=edit.getMaterno()%><%}%>"
                                                           style="width: 300px" onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)" maxlength="20"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Cargo:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="cargoCon" name="cargoCon" type="text" value="<%if (paso==22){%><%=edit.getCargo()%><%}%>"
                                                           style="width: 300px" onkeypress="return ValidaLetrasAcenEspPun(event, this.value)" onblur="Mayusculas(this)" maxlength="20"/>
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
                                                    <a href="javascript: GuardarContactoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="50%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarContactoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
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
                var titulo = document.getElementById('tituloCon');
                titulo.focus();
            }
            
            function CancelarContactoClick(){
                var paginaSig = document.getElementById('paginaSig');
                paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
                var pasoSig = document.getElementById('pasoSig');
                pasoSig.value = '1';
                var frm = document.getElementById('frmNuevoContacto');
                frm.submit();
            }

            function GuardarContactoClick(){
                if (ValidaRequeridos()){
                    var paginaSig = document.getElementById('paginaSig');
                    paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
                    var pasoSig = document.getElementById('pasoSig');
                    <%
                    if (paso == 22){
                    %>
                        pasoSig.value = '23';
                    <%} else {%>
                        pasoSig.value = '21';
                    <%}%>
                    var frm = document.getElementById('frmNuevoContacto');
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var titulo = document.getElementById('tituloCon');
                if (titulo.value == ''){
                    Mensaje('Debe escribir el Título del contacto');
                    titulo.focus();
                    return false;
                }
                
                var nombre = document.getElementById("nombreCon");
                if (nombre.value == ''){
                    Mensaje('Debe escribir el Nombre del contacto');
                    nombre.focus();
                    return false;
                }
                
                var paterno = document.getElementById("paternoCon");
                if (paterno.value == ''){
                    Mensaje('Debe escribir el Ap. Paterno del contacto');
                    paterno.focus();
                    return false;
                }
                
                var materno = document.getElementById("maternoCon");
                if (materno.value == ''){
                    Mensaje('Debe escribir el Ap. Materno del contacto');
                    materno.focus();
                    return false;
                }
                
                var cargo = document.getElementById("cargoCon");
                if (cargo.value == ''){
                    Mensaje('Debe escribir el Cargo del contacto');
                    cargo.focus();
                    return false;
                }
                
                return true;
            }
        </script>
    </body>
</html>