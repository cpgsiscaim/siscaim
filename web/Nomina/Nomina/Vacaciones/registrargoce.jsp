<%-- 
    Document   : registrargoze
    Created on : 07-sep-2015, 12:22:42
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.util.HashMap, java.text.SimpleDateFormat, Modelo.Entidades.Plaza, Modelo.Entidades.Vacaciones"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Vacaciones vac = (Vacaciones)datosS.get("vacaciones");
Plaza plzsel = (Plaza)datosS.get("plaza");
SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
String fechaIni = vac.getFechainicial()!=null?formato.format(vac.getFechainicial()):"";
String fechaFin = vac.getEstatus()==4?formato.format(vac.getFechafinal()):"";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
    <!-- Jquery UI -->
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-custom.css" />
        <script src="/siscaim/Estilos/jqui/jquery-1.9.1.js"></script>
        <script src="/siscaim/Estilos/jqui/jquery-ui.js"></script>
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/tooltip.css" />
        <script>
        //TOOLTIP
        $(function() {
        $( document ).tooltip({
            position: {
            my: "center bottom-20",
            at: "center top",
            using: function( position, feedback ) {
                $( this ).css( position );
                $( "<div>" )
                .addClass( "arrow" )
                .addClass( feedback.vertical )
                .addClass( feedback.horizontal )
                .appendTo( this );
            }
            }
        });
        });
        
        //DIALOGO MENSAJE
        $(function() {
        $( "#dialog-message" ).dialog({
            modal: true,
            autoOpen: false,
            width:500,
            height:200,            
            show: {
                effect: "blind",
                duration: 500
            },
            hide: {
                effect: "explode",
                duration: 500
            },            
            buttons: {
            "Aceptar": function() {
                $( this ).dialog( "close" );
            }
            }
        });
        });
        
        //CALENDARIO
        $(function() {
            $( "#fechaini" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });


        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            
            $( "#btnQuitar" ).button({
                icons: {
                    primary: "ui-icon-arrowthickstop-1-w"
		}
            });
            
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
        });
        </script>
    <!-- Jquery UI -->
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/MovsExtras/movextraA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        REGISTRAR GOCE DE VACACIONES DEL EMPLEADO
                    </div>
                    <div class="subtitulo" align="left">
                        <%=plzsel.getEmpleado().getPersona().getNombreCompleto()%><br>
                        <%=plzsel.getPuesto().getDescripcion()%> / <%=plzsel.getCtrabajo().getNombre()%>
                    </div>
                </td>
            </tr>
            
        </table>
        <hr>
        <form id="frmGozeVacaciones" name="frmGozeVacaciones" action="<%=CONTROLLER%>/Gestionar/Nominas" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="70%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">D&iacute;as:</span><br>
                                                    <input id="dias" name="dias" type="text" class="text" value="<%=vac.getDias()%>" readonly/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Fecha Inicial del período:</span><br>
                                                    <input id="fechaini" name="fechaini" type="text" class="text" value="<%=fechaIni%>" readonly=""
                                                           title="Ingrese la fecha inicial del período vacacional" style="width: 150px;" onchange="CalculaFechaFinal()"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="10%" align="left"></td>
                                                <td width="90%" align="left">
                                                    <span class="etiqueta">Fecha Final del período:</span><br>
                                                    <input id="fechafin" name="fechafin" type="text" class="text" value="<%=fechaFin%>" readonly/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="60%" align="right">
                                    <%if (vac.getEstatus()==4){%>
                                        <a id="btnQuitar" href="javascript: QuitarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Quitar goce de vacaciones">
                                            Quitar goce
                                        </a>
                                    <%}%>
                                    </td>
                                    <td width="20%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar movimiento">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
            <div id="procesando" style="display: none">
            <table id="tbmensaje" align="center" width="100%">
                <tr>
                    <td width="100%" align="center">
                        <img src="/siscaim/Imagenes/procesando02.gif" align="center" width="100" height="100">
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="center">
                        <span class="subtitulo">
                            Espere por favor, se está realizando la acción solicitada
                        </span>
                    </td>
                </tr>
            </table>
            </div>
        </form>
        <script language="javascript">
            function MostrarMensaje(mensaje){
                var mens = document.getElementById('alerta');
                mens.textContent = mensaje;
                $( "#dialog-message" ).dialog( "open" );
            }
            
            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function CargaPagina(){
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
            }
            
            function CalculaFechaFinal(){
                var fechini = document.getElementById('fechaini');
                var fechfin = document.getElementById('fechafin');
                var dias = document.getElementById('dias');
                fechfin.value = sumarFecha(parseInt(dias.value)-1, fechini.value);
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGozeVacaciones');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '90';
                frm.submit();                
            }
            
            function GuardarClick(){
                Espera();
                var frm = document.getElementById('frmGozeVacaciones');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '45';
                frm.submit();                
            }
            
            function QuitarClick(){
                Espera();
                var frm = document.getElementById('frmGozeVacaciones');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Nomina/detallenomina.jsp';
                paso.value = '46';
                frm.submit();                
            }
        </script>
    </body>
</html>
