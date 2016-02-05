
<%-- 
    Document   : nuevoempleado
    Created on : Jun 6, 2012, 10:37:15 PM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursal");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
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
                        Gestionar Personal - Imprimir Gafetes<br>
                        SUCURSAL: <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmImprimirGaf" name="frmImprimirGaf" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="empleados" name="empleados" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="25%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Personal/gafete03.png" align="right" width="300" height="250">
                                    </td>
                                    <td width="75%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="60%" align="center" valign="top">
                                                    <span class="etiquetaB">Seleccione los empleados:</span><br>
                                                    <select id="lsempleados" name="lsempleados" style="width: 400px" size="15" multiple>
                                                    <%
                                                        List<Empleado> empleados = (List<Empleado>)datosS.get("listagafetes");
                                                        for (int i=0; i < empleados.size(); i++){
                                                            Empleado emp = empleados.get(i);
                                                        %>
                                                        <option value="<%=emp.getNumempleado()%>">
                                                            <%=emp.getClave()%> - <%=emp.getPersona().getNombreCompletoPorApellidos()%> <%if (emp.getEstatus()==0){%> (INACTIVO) <%}%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                                <td width="40%" align="center" valign="center">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Imprimir">
                                                                <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br>
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
            
            function ImprimirClick(){
                var emples = document.getElementById('empleados');
                emples.value = '';
                //carga los elementos seleccionados
                var lsemp = document.getElementById('lsempleados');
                for (i=0; i < lsemp.length; i++){
                    if (lsemp.options[i].selected){
                        emples.value = emples.value + lsemp.options[i].value + ',';
                    }
                }
                if (emples.value == ''){
                    Mensaje('Debe seleccionar al menos un empleado');
                    return;
                }
                
                emples.value = emples.value.substr(0, emples.value.length-1);
                
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=12&dato1='+emples.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmImprimirGaf');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '96';
                frm.submit();                
            }
        </script>
    </body>
</html>