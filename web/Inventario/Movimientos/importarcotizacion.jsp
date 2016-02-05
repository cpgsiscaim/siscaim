<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cabecera, Modelo.Entidades.TipoMov"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
List<Cabecera> listado = (List<Cabecera>)datosS.get("cotizaciones");
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
                        Importar Cotización a Factura
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmImportarPed" name="frmImportarPed" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idMov" name="idMov" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="300" height="250">
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
                                                <style>#btnImportar a{display:block;color:transparent;} #btnImportar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnImportar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Importar">
                                                            <a href="javascript: ImportarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/importar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Cotizaciones disponibles para importar 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="15%" colspan="2">
                                                    <span>Serie</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Folio</span>
                                                </td>
                                                <td align="center" width="50%">
                                                    <span>Proveedor</span>
                                                </td>
                                                <td align="center" width="25%">
                                                    <span>Fecha</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Cabecera mov = listado.get(i);
                                                String fechaCap = mov.getFechaCaptura().toString();
                                                String fechaCapN =fechaCap.substring(8,10) + "-" + fechaCap.substring(5,7) + "-" + fechaCap.substring(0, 4);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioMov" name="radioMov" type="radio" value="<%=mov.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <%=mov.getSerie().getSerie()%>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <%=mov.getFolio()%>
                                                    </td>
                                                    <td align="left" width="50%">
                                                        <span class="etiqueta">
                                                            <%=mov.getCliente().getTipo()==0?mov.getCliente().getDatosFiscales().getRazonsocial():mov.getCliente().getDatosFiscales().getPersona().getNombreCompleto()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiqueta"><%=fechaCapN%></span>
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
                var idMov = document.getElementById('idMov');
                <%
                if (listado.size()==1){
                %>
                    document.frmImportarPed.radioMov.checked = true;
                    idMov.value = document.frmImportarPed.radioMov.value;
                <%
                } else {
                %>
                    var radio = document.frmImportarPed.radioMov[fila];
                    radio.checked = true;
                    idMov.value = radio.value;
                <% } %>
                var importar = document.getElementById('btnImportar');
                importar.style.display = '';
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmImportarPed');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '91';
                frm.submit();                
            }
            
            function ImportarClick(){
                var frm = document.getElementById('frmImportarPed');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '23';
                frm.submit();                
            }
            
        </script>
    </body>
</html>