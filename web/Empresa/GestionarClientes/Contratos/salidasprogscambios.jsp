<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliSel = (Cliente)datosS.get("clienteSel");
    Contrato con = (Contrato)datosS.get("editarContrato");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%">
                    <div class="titulo" align="center">
                        Generar Salidas Programadas - Productos a cambio<br>
                        <%if (cliSel.getTipo()==0){%>
                        <%=cliSel.getDatosFiscales().getRazonsocial()%><br>
                        <%}%>
                        <%if (cliSel.getDatosFiscales().getPersona()!=null){%>
                        <%=cliSel.getDatosFiscales().getPersona().getNombreCompleto()%><br>
                        <%}%>
                        CONTRATO: <%=con.getContrato()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmSalProgCam" name="frmSalProgCam" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="ctssel" name="ctssel" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="80%" align="center">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="etiqueta">Fecha:</span>
                                                    <input id="fecha" name="fecha" value="" type="hidden">
                                                    <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="" onchange="cambiaFecha(this.value,'fecha')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmSalProgCam.rgFecha,'dd-mm-yyyy',document.frmSalProgCam.rgFecha)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFecha', 'fecha')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" align="center">
                                                    <select id="cts" name="cts" size="5" style="width: 400px" multiple>
                                                    <%
                                                        List<CentroDeTrabajo> cts = (List<CentroDeTrabajo>)datosS.get("listaCentros");
                                                        for (int i=0; i < cts.size(); i++){
                                                            CentroDeTrabajo ct = cts.get(i);
                                                        %>
                                                        <option value="<%=ct.getId()%>">
                                                            <%=ct.getNombre()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
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
                                                <td style="padding-right:0px" title ="Generar">
                                                    <a href="javascript: GenerarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/generar.png);width:150px;height:30px;display:block;"><br/></a>
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

            function limpiar(nombreObj1, nombreObj2)
            {
                obj = document.getElementById(nombreObj1);
                obj.value='';
                obj = document.getElementById(nombreObj2);
                obj.value='';
            }

            function cambiaFecha(fecha, nombreObj)
            {
                d = fecha.substr(0,2);
                m = fecha.substr(3,2);
                y = fecha.substr(6,4);
                txtFecha = document.getElementById(nombreObj);
                txtFecha.value=y+'-'+m+'-'+d;
            }

            function CancelarClick(){
                var frm = document.getElementById('frmSalProgCam');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                frm.pasoSig.value = '96';
                frm.submit();
            }
            
            function GenerarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmSalProgCam');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                    frm.pasoSig.value = '12';
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                var fecha = document.getElementById('fecha');
                if (fecha.value == ''){
                    Mensaje('No ha establecido la fecha del movimiento');
                    return false;
                }
                
                var ctssel = document.getElementById('ctssel');
                ctssel.value = '';
                //carga los elementos seleccionados
                var cts = document.getElementById('cts');
                for (i=0; i < cts.length; i++){
                    if (cts.options[i].selected){
                        ctssel.value = ctssel.value + cts.options[i].value + ',';
                    }
                }
                
                if (ctssel.value == ''){
                    Mensaje('Debe seleccionar al menos un Centro de Trabajo');
                    return false;
                }
                
                ctssel.value = ctssel.value.substr(0, ctssel.value.length-1);
                
                return true;
            }
        

        </script>
    </body>
</html>