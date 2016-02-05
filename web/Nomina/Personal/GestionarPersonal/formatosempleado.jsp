
<%-- 
    Document   : formatosempleado
    Created on : Ago 14, 2015, 13:11 hrs
    Author     : temoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal "%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Empleado empl = (Empleado)datosS.get("empleado");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Personal - Imprimir Formatos del Empleado<br>
                        EMPLEADO: <%=empl.getPersona().getNombreCompleto()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmFormatosEmp" name="frmFormatosEmp" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="formato" name="formato" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Personal/formatosempA.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="80%" align="center">
                                            <tr>
                                                <td width="50%" align="center">
                                                    <span class="etiquetaB">Ingreso</span>
                                                </td>
                                                <td width="50%" align="center">
                                                    <span class="etiquetaB">Renuncia</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%" align="left" valign="top">
                                                    <input id="opcformato" name="opcformato" type="radio" value="1" onclick="SeleccionaFormato(this.value)">
                                                    <span class="etiqueta">Solicitud de Ingreso Ordinaria</span><br>
                                                    <input id="opcformato" name="opcformato" type="radio" value="2" onclick="SeleccionaFormato(this.value)">
                                                    <span class="etiqueta">Acuerdo de la Solicitud de Ingreso</span><br>
                                                    <input id="opcformato" name="opcformato" type="radio" value="3" onclick="SeleccionaFormato(this.value)">
                                                    <span class="etiqueta">Certificado de Aportación</span><br>
                                                    <input id="opcformato" name="opcformato" type="radio" value="4" onclick="SeleccionaFormato(this.value)">
                                                    <span class="etiqueta">Formato Banamex</span><br>
                                                </td>
                                                <td width="50%" align="left" valign="top">
                                                    <input id="opcformato" name="opcformato" type="radio" value="5" onclick="SeleccionaFormato(this.value)">
                                                    <span class="etiqueta">Renuncia</span><br>
                                                    <input id="opcformato" name="opcformato" type="radio" value="6" onclick="SeleccionaFormato(this.value)">
                                                    <span class="etiqueta">Acuerdo de Aceptación de Renuncia</span><br>
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
                                                <td style="padding-right:0px" title ="Imprimir">
                                                    <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
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
                %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmFormatosEmp');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
            
            function ImprimirClick(){
                if (ValidaRequeridos()){
                    var formato = document.getElementById('formato');
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=17&dato1='+formato.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');                
                 }   
            }
            
            function ValidaRequeridos(){
                var formato = document.getElementById('formato');
                if (formato.value == ""){
                    Mensaje('Debe seleccionar un formato');
                    return false;
                }
                
                return true;
            }
            
            function SeleccionaFormato(fto){
                var formato = document.getElementById('formato');
                formato.value = fto;
            }
        </script>
    </body>
</html>