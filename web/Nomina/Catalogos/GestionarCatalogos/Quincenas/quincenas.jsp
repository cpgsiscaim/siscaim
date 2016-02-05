<%-- 
    Document   : tiponomina
    Created on : Jun 20, 2012, 9:45:51 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, java.util.ArrayList, java.util.List,  Modelo.Entidades.Catalogos.Quincena"%>
<%-- aqui poner los imports
<%@page import=""%>
--%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
//Estado edoActual = nullTipoCambioLst;
HashMap datosS = sesion.getDatos();
List<Quincena> QuincenasLst = new ArrayList<Quincena>();
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
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Quincenas
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmQuincenas" name="frmQuincenas" action="<%=CONTROLLER%>/Gestionar/Quincenas" method="post">
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
                                        <img src="/siscaim/Imagenes/Personal/configuracion.jpg" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <!--aquí poner contenido-->
                                        <table width="100%">
                                            <tr>
                                                <%-- Boton Salir --%>
                                                <td width="100%" align="left">
                                                    <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Salir">
                                                                <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                            </tr>
                                        </table> 
                                        <hr>
                                        <%
                                        QuincenasLst = (List<Quincena>) datosS.get("quincenas");
                                        if (QuincenasLst.size()==0){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Quincenas registradas
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
                                                    <td width="100%" align="center">
                                                        <span>Descripción</span>
                                                    </td>                                                                                      
                                                </tr>
                                            </thead>
                                            <tbody> 
                                                <%
                                                    for (int i = 0; i < QuincenasLst.size(); i++) {
                                                        Quincena quin = QuincenasLst.get(i);
                                                %>
                                                
                                                <tr>
                                                    <td width="100%" align="center">                                                        
                                                        <span class="etiqueta"><%=quin.getMes()%> - <%=quin.getNumero()%></span>
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

        function SalirClick(){
            var frm = document.getElementById('frmQuincenas');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
            paso.value = '99';
            frm.submit();                
        }

</script>
</body>
</html>

