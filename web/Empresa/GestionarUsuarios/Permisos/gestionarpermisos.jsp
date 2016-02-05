<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Usuario, Modelo.Entidades.Operacion"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
List<Operacion> listado = (List<Operacion>) datosS.get("permisos");
Usuario usu = (Usuario)datosS.get("usuario");
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
                        Gestionar Usuarios - Permisos<br>
                        USUARIO: <%=usu.getEmpleado().getPersona().getNombreCompleto()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarPer" name="frmGestionarPer" action="<%=CONTROLLER%>/Gestionar/Permisos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idOp" name="idOp" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Empresa/permisosA.png" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="55%" align="left">
                                                &nbsp;
                                            </td>
                                            <td width="15%" align="left">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="100%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <table class="tablaLista" width="50%" align="center">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Permisos registrados del Usuario
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="100%" colspan="2">
                                                    <span>Operación</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Operacion op = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioOp" name="radioOp" type="radio" value="<%=i%>"/>
                                                    </td>
                                                    <td align="left" width="90%">
                                                        <span class="etiqueta">
                                                        <%=op.getOperacion()%>
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
                var idOp = document.getElementById('idOp');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarPer.radioOp.checked = true;
                    idOp.value = document.frmGestionarPer.radioOp.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarPer.radioOp[fila];
                    radio.checked = true;
                    idOp.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarPer');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarUsuarios/gestionarusuarios.jsp';
                paso.value = '99';
                frm.submit();
            }
            
            function NuevoClick(){
                var frm = document.getElementById('frmGestionarPer');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarUsuarios/Permisos/nuevopermiso.jsp';
                paso.value = '1';
                frm.submit();                
            }
                        
            function BajaClick(){
                var resp = confirm('¿Está seguro en eliminar el Permiso seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarPer');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarUsuarios/Permisos/gestionarpermisos.jsp';
                    paso.value = '3';
                    frm.submit();
                }
            }
                                    
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarPer');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarPer');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarPer');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarPer');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
    </script>
    </body>
</html>