<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Plaza, Modelo.Entidades.Empleado"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Plaza plz = (Plaza)datosS.get("plaza");
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
                        Gestionar Plazas / Sustituir Plaza
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmSustituirPlz" name="frmSustituirPlz" action="<%=CONTROLLER%>/Gestionar/Plazas" method="post">
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
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Nomina/Plazas/plazasE.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="90%" align="center">
                                            <tr>
                                                <td width="100%" align="left">
                                                    <span class="subtitulo">Plaza que se dará de BAJA:</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="90%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="10%" align="center">
                                                        <span>Contrato</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>C.T.</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Puesto</span>
                                                    </td>
                                                    <td width="35%" align="center">
                                                        <span>Empleado</span>
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>Fecha de Baja</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td width="10%" align="center">
                                                        <span class="etiqueta"><%=plz.getContrato().getContrato()%></span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%=plz.getCtrabajo().getNombre()%></span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%=plz.getPuesto().getDescripcion()%></span>
                                                    </td>
                                                    <td width="35%" align="center">
                                                        <span class="etiqueta"><%=plz.getEmpleado().getPersona().getNombreCompletoPorApellidos()%></span>
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <input id="fechaBaja" name="fechaBaja" value="" type="hidden">
                                                        <input id="rgFechaB" name="rgFechaB" class="cajaDatos" style="width:120px" type="text" value="" onchange="cambiaFecha(this.value,'fechaBaja')" readonly>&nbsp;
                                                        <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                            onclick="displayCalendar(document.frmSustituirPlz.rgFechaB,'dd-mm-yyyy',document.frmSustituirPlz.rgFechaB)"
                                                            title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                        <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                            onclick="limpiar('rgFechaB', 'fechaBaja')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <br>
                                        <table width="90%" align="center">
                                            <tr>
                                                <td width="100%" align="left">
                                                    <span class="subtitulo">Plaza que se dará de ALTA:</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="90%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="10%" align="center">
                                                        <span>Contrato</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>C.T.</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Puesto</span>
                                                    </td>
                                                    <td width="35%" align="center">
                                                        <span>Empleado</span>
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>Fecha de Alta</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td width="10%" align="center">
                                                        <span class="etiqueta"><%=plz.getContrato().getContrato()%></span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%=plz.getCtrabajo().getNombre()%></span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%=plz.getPuesto().getDescripcion()%></span>
                                                    </td>
                                                    <td width="35%" align="center">
                                                        <select id="empleado" name="empleado" class="combo" style="width: 400px">
                                                            <option value="">Elija el Empleado...</option>
                                                            <%
                                                            List<Empleado> empleados = (List<Empleado>)datosS.get("empleados");
                                                            for (int i=0; i < empleados.size(); i++){
                                                                Empleado e = empleados.get(i);
                                                            %>
                                                            <option value="<%=e.getNumempleado()%>">
                                                                <%=e.getPersona().getNombreCompletoPorApellidos()%>
                                                            </option>
                                                            <%
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <input id="fechaAlta" name="fechaAlta" value="" type="hidden">
                                                        <input id="rgFechaA" name="rgFechaA" class="cajaDatos" style="width:120px" type="text" value="" onchange="cambiaFecha(this.value,'fechaAlta')" readonly>&nbsp;
                                                        <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                            onclick="displayCalendar(document.frmSustituirPlz.rgFechaA,'dd-mm-yyyy',document.frmSustituirPlz.rgFechaA)"
                                                            title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                        <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                            onclick="limpiar('rgFechaA', 'fechaAlta')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Aplicar">
                                                    <a href="javascript: AplicarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;"><br/></a>
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
                    Mensaje('<%=sesion.getMensaje()%>');
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

            function CancelarClick(){
                var frm = document.getElementById('frmSustituirPlz');
                frm.paginaSig.value = '/Nomina/Plazas/gestionarplazas.jsp';
                frm.pasoSig.value = '96';
                frm.submit();
            }
            
            function AplicarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmSustituirPlz');
                    frm.paginaSig.value = '/Nomina/Plazas/gestionarplazas.jsp';
                    frm.pasoSig.value = '11';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var fechaBaja = document.getElementById('fechaBaja');
                if (fechaBaja.value == ''){
                    Mensaje('La Fecha de Baja no ha sido establecida');
                    fechaBaja.focus();
                    return false;
                }

                var empleado = document.getElementById('empleado');
                if (empleado.value == ''){
                    Mensaje('El Empleado no ha sido establecido');
                    empleado.focus();
                    return false;
                }
                                
                var fecha = document.getElementById('fechaAlta');
                if (fecha.value == ''){
                    Mensaje('La Fecha de Alta no ha sido establecida');
                    fecha.focus();
                    return false;
                }
                
                return true;
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
            
        </script>
    </body>
</html>