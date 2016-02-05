<%-- 
    Document   : tiponomina
    Created on : Jun 20, 2012, 9:45:51 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, java.util.ArrayList, java.util.List,  Modelo.Entidades.Catalogos.TipoCambio, Modelo.Entidades.Catalogos.TipoCambioPyD, Modelo.Entidades.Catalogos.PeryDed"%>
<%-- aqui poner los imports
<%@page import=""%>
--%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
//Estado edoActual = null;
HashMap datosS = sesion.getDatos();
PeryDed pyd = (PeryDed)datosS.get("perded");
List<TipoCambioPyD> tcpydLst = new ArrayList<TipoCambioPyD>();
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />        
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"/>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Tipos de Cambios de <%=pyd.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmTipoCambio" name="frmTipoCambio" action="<%=CONTROLLER%>/Gestionar/TiposCambiosPyD" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idTcPyD" name="idTcPyD" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Personal/configuracion.jpg" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <!--aquí poner contenido-->
                                        <table width="100%">
                                            <tr>
                                                <%-- Boton Salir --%>
                                                <td width="40%" align="left">
                                                    <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <%-- Boton Inactivos --%>
                                                <td width="15%" align="center">
                                                    <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                    <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ver Inactivos">
                                                                <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <td width="30%" align="center">
                                                    <%-- Botones editar eliminar --%> 
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="50%" align="center">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Editar">
                                                                            <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td width="50%" align="center">
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
                                                <%-- Boton Nuevo --%>
                                                <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo" >
                                                            <a href="javascript: NuevoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>                                     
                                                </table>
                                            </td>                                                                        
                                        </tr>
                                        </table> 
                                        <hr>
                                        <%
                                        tcpydLst = (List<TipoCambioPyD>) datosS.get("listatcpyd");
                                        if (tcpydLst.size()==0){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Tipos de Cambio registrados para <%=pyd.getDescripcion()%>.
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        <%
                                        } else {
                                        %>

                                        <table class="tablaLista" width="60%" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="100%" align="center" colspan="2">
                                                        <span>Tipo de Cambio</span>
                                                    </td>                                                                                      
                                                </tr>
                                            </thead>
                                            <tbody> 
                                                <%
                                                    for (int i = 0; i < tcpydLst.size(); i++) {
                                                        TipoCambioPyD tc = tcpydLst.get(i);
                                                %>
                                                
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radiotcpyd" name="radiotcpyd" type="radio" value="<%= tc.getId() %>" />
                                                    </td>
                                                    <td width="90%" align="center">                                                        
                                                        <span class="etiqueta"><%=tc.getTipocambio().getDescripcion()%></span>
                                                    </td>                                                                                                                                         
                                                </tr>
                                                <%
                                                    } //Fin for
                                                %> 
                                            </tbody>
                                        </table>  
                                    <% } %>
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

        function NuevoClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/nuevotcpyd.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "1";
            var frm = document.getElementById('frmTipoCambio');
            frm.submit();
        }
        
        function EditarClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/nuevotcpyd.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "3";
            var frm = document.getElementById('frmTipoCambio');
            frm.submit();
        }
        
        function BajaClick(){
            var resp = confirm('¿Está seguro en dar de baja el Tipo de Cambio seleccionado?','SISCAIM');
            if (resp){
                var frm = document.getElementById('frmTipoCambio');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = "/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/tiposcambiospyd.jsp";
                paso.value = '5';
                frm.submit();
            }
        }

        function CancelarClick(){
            var frm = document.getElementById('frmTipoCambio');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp';
            paso.value = '99';
            frm.submit();                
        }

        function VerInactivos(){
            var frm = document.getElementById('frmTipoCambio');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/tcpydinactivos.jsp';
            paso.value = '6';
            frm.submit();                
        }

        function Activa(fila){
                            var idTcPyD = document.getElementById('idTcPyD');
                            var borrarEdit = document.getElementById('borrarEdit');
                            borrarEdit.style.display = '';
                    <%
                        if (tcpydLst.size() == 1) {
                    %>
                            //document.frmGestionarCli.radioCli.checked = true;
                            document.frmTipoCambio.radiotcpyd.checked = true;
                            //idCli.value = document.frmGestionarCli.radioCli.value;
                            idTcPyD.value = document.frmTipoCambio.radiotcpyd.value;
                    <%    }else {
                    %>
                            var radio = document.frmTipoCambio.radiotcpyd[fila];//document.frmGestionarCli.radioCli[fila];
                            radio.checked = true;
                            idTcPyD.value = radio.value;
                    <% }%>
        }
        
</script>
</body>
</html>

