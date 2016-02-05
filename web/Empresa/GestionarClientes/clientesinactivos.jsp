<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
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
                <td width="20%" align="center" valign="center">
                    <!--aquí poner la imagen asociada con el proceso-->
                    <img src="/siscaim/Imagenes/Empresa/clientesD.png" align="center" width="180" height="100">
                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        GESTIONAR CLIENTES - INACTIVOS
                    </div>
                    <div class="titulo" align="center">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCliIn" name="frmGestionarCliIn" action="<%=CONTROLLER%>/Gestionar/Clientes" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCli" name="idCli" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <td width="50%">
                                                    <table id="borrarEdit" style="display: none;" width="100%">
                                                        <tr>
                                                            <td width="100%" align="right">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Activar">
                                                                            <a href="javascript: AltaCliClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                        <table class="tablaLista" width="100%">
                                        <%
                                        List<Cliente> listado = (List<Cliente>)datosS.get("inactivos");
                                        if (listado.size()==0){
                                        %>
                                            <tr>
                                                <td colspan="4" align="center">
                                                    <span class="etiquetaB">
                                                        No hay Clientes Inactivos en la Sucursal seleccionada
                                                    </span>
                                                </td>
                                            </tr>
                                        <%
                                        } else {
                                        %>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="50%">
                                                        <span>Cliente</span>
                                                    </td>
                                                    <td align="center" width="30%">
                                                        <span>Ciudad</span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span>Estado</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%    
                                                for (int i=0; i < listado.size(); i++){
                                                    Cliente cli = listado.get(i);
                                            %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="left" width="50%">
                                                            <input id="radioCli" name="radioCli" type="radio" value="<%=cli.getId()%>"/>
                                                            <span class="etiquetaD">
                                                            <%
                                                            if (cli.getTipo()==0){
                                                            %>
                                                                <%=cli.getDatosFiscales().getRazonsocial()%>
                                                            <% } else { %>
                                                                <%=cli.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                            <% } %>
                                                            </span>
                                                        </td>
                                                        <td align="left" width="30%">
                                                            <span class="etiquetaD"><%=cli.getDatosFiscales().getDireccion().getPoblacion().getMunicipio()%></span>
                                                        </td>
                                                        <td align="left" width="20%">
                                                            <span class="etiquetaD"><%=cli.getDatosFiscales().getDireccion().getPoblacion().getEstado().getEstado()%></span>
                                                        </td>
                                                    </tr>
                                            <%
                                                }
                                            %>
                                            </tbody>
                                        <%    
                                        }
                                        %>
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
            
            function Activa(fila){
                var idCli = document.getElementById('idCli');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarCliIn.radioCli.checked = true;
                    idCli.value = document.frmGestionarCliIn.radioCli.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCliIn.radioCli[fila];
                    radio.checked = true;
                    idCli.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarCliIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function AltaCliClick(){
                var frm = document.getElementById('frmGestionarCliIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/clientesinactivos.jsp';
                paso.value = '8';
                frm.submit();                
            }
            
        </script>
    </body>
</html>