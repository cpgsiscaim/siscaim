<%-- 
    Document   : tiponomina
    Created on : Jun 20, 2012, 9:45:51 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, java.util.ArrayList, java.util.List,  Modelo.Entidades.Catalogos.TipoCambio"%>
<%-- aqui poner los imports
<%@page import=""%>
--%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
//Estado edoActual = null;
HashMap datosS = sesion.getDatos();
List<TipoCambio> TipoCambioLst = new ArrayList<TipoCambio>();
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
                        Tipos de Cambios - Inactivos
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmTipoCambio" name="frmTipoCambio" action="<%=CONTROLLER%>/Gestionar/TiposCambios" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idTipoCambio" name="idTipoCambio" type="hidden" value=""/>
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
                                                <%-- Boton Cancelar --%>
                                                <td width="50%" align="left">
                                                    <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <%-- Boton Activar --%>
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
                                        <%
                                        TipoCambioLst = (List<TipoCambio>) datosS.get("tcinactivos");
                                        if (TipoCambioLst.size()==0){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Tipos de Cabmio inactivos
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
                                                        <span>Descripción</span>
                                                    </td>                                                                                      
                                                </tr>
                                            </thead>
                                            <tbody> 
                                                <%
                                                    for (int i = 0; i < TipoCambioLst.size(); i++) {
                                                        TipoCambio tc = TipoCambioLst.get(i);
                                                %>
                                                
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioTipoCambio" name="radioTipoCambioa" type="radio" value="<%= tc.getId() %>" />
                                                    </td>
                                                    <td width="90%" align="center">                                                        
                                                        <span class="etiqueta"><%= tc.getDescripcion()%></span>
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

        function ActivarClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/TiposCambios/tiposcambiosinactivos.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "7";
            var frm = document.getElementById('frmTipoCambio');
            frm.submit();
        }
        

        function CancelarClick(){
            var frm = document.getElementById('frmTipoCambio');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Catalogos/GestionarCatalogos/TiposCambios/tiposcambios.jsp';
            paso.value = '97';
            frm.submit();                
        }

        function Activa(fila){
                            var idTipoCambio = document.getElementById('idTipoCambio');
                            var btnActivar = document.getElementById('btnActivar');
                            btnActivar.style.display = '';
                    <%
                        if (TipoCambioLst.size() == 1) {
                    %>
                            //document.frmGestionarCli.radioCli.checked = true;
                            document.frmTipoCambio.radioTipoCambio.checked = true;
                            //idCli.value = document.frmGestionarCli.radioCli.value;
                            idTipoCambio.value = document.frmTipoCambio.radioTipoCambio.value;
                    <%    }else {
                    %>
                            var radio = document.frmTipoCambio.radioTipoCambio[fila];//document.frmGestionarCli.radioCli[fila];
                            radio.checked = true;
                            idTipoCambio.value = radio.value;
                    <% }%>
        }
        
</script>
</body>
</html>

