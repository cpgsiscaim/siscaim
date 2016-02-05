<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<CentroDeTrabajo> listado = (List<CentroDeTrabajo>)datosS.get("inactivos");
Cliente cliSel = (Cliente)datosS.get("clienteSel");
Contrato conSel = (Contrato)datosS.get("editarContrato");
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
                    <img src="/siscaim/Imagenes/Empresa/centrostrabA.png" align="center" width="180" height="100">
                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        GESTIONAR CENTROS DE TRABAJO
                    </div>
                    <div class="titulo" align="center">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="center">
                        <%if (cliSel.getTipo()==0){%>
                        <%=cliSel.getDatosFiscales().getRazonsocial()%><br>
                        <%}%>
                        <%if (cliSel.getDatosFiscales().getPersona()!=null){%>
                        <%=cliSel.getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%}%>
                    </div>
                    <div class="subtitulo" align="center">
                        CONTRATO <%=conSel.getContrato()%> <%=conSel.getDescripcion()%>
                    </div><br>
                    <div class="subtitulo" align="center">
                        CENTROS DE TRABAJO INACTIVOS
                    </div>                    
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCTIn" name="frmGestionarCTIn" action="<%=CONTROLLER%>/Gestionar/CentrosTrab" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCT" name="idCT" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="100%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Activar">
                                                                        <a href="javascript: ActivarCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
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
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Centros de Trabajo Inactivos del Contrato seleccionado
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="40%">
                                                    <span>Nombre</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Personal</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Días de Entrega</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Tope de Sueldos</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Tope de Insumos</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                CentroDeTrabajo ct = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="left" width="40%">
                                                        <input id="radioCT" name="radioCT" type="radio" value="<%=ct.getId()%>"/>
                                                        <span class="etiquetaD">
                                                            <%=ct.getNombre()%>
                                                            <%if (ct.getDireccion()!=null){%>
                                                                (<%=ct.getDireccion().getCalle()%>, COL. <%=ct.getDireccion().getColonia()%>,
                                                                <%=ct.getDireccion().getPoblacion().getMunicipio()%>,<%=ct.getDireccion().getPoblacion().getEstado().getEstado()%>)
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=Float.toString(ct.getPersonal())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=Integer.toString(ct.getDiasEntrega())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=Float.toString(ct.getTopeSueldos())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=Float.toString(ct.getTopeInsumos())%>
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
                var idCT = document.getElementById('idCT');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarCTIn.radioCT.checked = true;
                    idCT.value = document.frmGestionarCTIn.radioCT.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCTIn.radioCT[fila];
                    radio.checked = true;
                    idCT.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCTIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarCTClick(){
                var frm = document.getElementById('frmGestionarCTIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/centrosinactivos.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
        </script>
    </body>
</html>