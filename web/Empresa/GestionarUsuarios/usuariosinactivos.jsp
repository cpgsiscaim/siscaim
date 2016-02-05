<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Usuario"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Usuario> listado = (List<Usuario>)datosS.get("inactivos");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
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
                        Gestionar Usuarios - Inactivos<br>
                        SUCURSAL: <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarUsu" name="frmGestionarUsu" action="<%=CONTROLLER%>/Gestionar/Usuarios" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idUsu" name="idUsu" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Empresa/usuariosD.png" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnActivar a{display:block;color:transparent;} #btnActivar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnActivar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Activar">
                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <table class="tablaLista" width="70%" align="center">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Usuarios inactivos en la Sucursal seleccionada
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="30%" colspan="2">
                                                    <span>Usuario</span>
                                                </td>
                                                <td align="center" width="70%">
                                                    <span>Nombre</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Usuario usu = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioCli" name="radioCli" type="radio" value="<%=usu.getIdusuario()%>"/>
                                                    </td>
                                                    <td align="left" width="20%">
                                                        <span class="etiqueta">
                                                        <%=usu.getUsuario()%>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="70%">
                                                        <span class="etiqueta">
                                                            <%=usu.getEmpleado().getPersona().getNombreCompleto()%>
                                                        </span>
                                                    </td>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
                                    }
                                    %>
                                    </table><!--listado-->
                                    <!-- botones siguiente anterior-->
                                    <%
                                    int grupos = Integer.parseInt(datosS.get("grupos").toString());
                                    if (grupos == 1){
                                        int sigs = Integer.parseInt(datosS.get("siguientes").toString());
                                        int ants = Integer.parseInt(datosS.get("anteriores").toString());
                                    %>
                                    <hr>
                                    <table width="100%">
                                        <tr>
                                            <td width="30%">&nbsp;</td>
                                            <td width="10%" align="center">
                                                <style>#btnPrincipio a{display:block;color:transparent;} #btnPrincipio a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnPrincipio" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al principio del listado">
                                                            <a href="javascript: PrincipioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/principio.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnAnterior a{display:block;color:transparent;} #btnAnterior a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnAnterior" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Anteriores">
                                                            <a href="javascript: AnteriorClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/anterior.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnSiguiente a{display:block;color:transparent;} #btnSiguiente a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnSiguiente" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Siguientes">
                                                            <a href="javascript: SiguienteClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/siguiente.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnUltimo a{display:block;color:transparent;} #btnUltimo a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnUltimo" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al final del listado">
                                                            <a href="javascript: FinalClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/final.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="30%">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <%
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->
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
                var idUsu = document.getElementById('idUsu');
                var btnActivar = document.getElementById('btnActivar');
                btnActivar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarUsu.radioCli.checked = true;
                    idUsu.value = document.frmGestionarUsu.radioCli.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarUsu.radioCli[fila];
                    radio.checked = true;
                    idUsu.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarUsu');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarUsuarios/gestionarusuarios.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarClick(){
                var frm = document.getElementById('frmGestionarUsu');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarUsuarios/usuariosinactivos.jsp';
                paso.value = '8';
                frm.submit();                
            }
                        
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarUsu');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarUsu');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarUsu');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarUsu');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '53';
                frm.submit();                
            }
    </script>
    </body>
</html>