<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliSel = (Cliente)datosS.get("clienteSel");
    Contrato con = (Contrato)datosS.get("editarContrato");
    String fechasug = con.getFechaIni().toString();
    String fechasugN = fechasug.substring(8,10) + "-" + fechasug.substring(5,7) + "-" + fechasug.substring(0, 4);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

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
        
        //CALENDARIOS
        $(function() {
            $( "#fecha" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        //DIALOGO MENSAJE
        $(function() {
        $( "#dialog-message" ).dialog({
            modal: true,
            autoOpen: false,
            show: {
                effect: "blind",
                duration: 500
            },
            hide: {
                effect: "explode",
                duration: 500
            },            
            buttons: {
            Ok: function() {
                $( this ).dialog( "close" );
            }
            }
        });
        });
        
        //BOTONES
        $(function() {
            $( "#btnGenerar" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-cancel"
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GENERAR SALIDAS PROGRAMADAS
                    </div>
                    <div class="titulo">
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
                                    <td width="100%" valign="top">
                                        <table id="tbfecha" width="100%" align="center">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="etiqueta">Fecha Inicial:</span>
                                                    <input id="fecha" name="fecha" type="text" class="text" readonly value="<%=fechasugN%>"
                                                        title="Ingrese la fecha a partir de la que iniciarán las salidas programadas"/>
                                                    <%--
                                                    <input id="fecha" name="fecha" value="<%=fechasug%>" type="hidden">
                                                    <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechasugN%>" onchange="cambiaFecha(this.value,'fecha')" readonly>&nbsp;
                                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                                        onclick="displayCalendar(document.frmSalProgCam.rgFecha,'dd-mm-yyyy',document.frmSalProgCam.rgFecha)"
                                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                                        onclick="limpiar('rgFecha', 'fecha')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                                    --%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" align="left">
                                                    <span class="etiqueta">Seleccione los CT's:</span><br>
                                                    <span class="etiquetaC">(Use la tecla Control presionada y haga clic en el CT para seleccionar o deseleccionar)</span><br>
                                                    <select id="cts" name="cts" size="15" style="width: 500px" multiple title="Seleccione al menos un CT">
                                                    <%
                                                        List<CentroDeTrabajo> cts = (List<CentroDeTrabajo>)datosS.get("listaCentros");
                                                        for (int i=0; i < cts.size(); i++){
                                                            CentroDeTrabajo ct = cts.get(i);
                                                        %>
                                                        <option value="<%=ct.getId()%>" selected>
                                                            <%=ct.getNombre()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                        <br>
                                        <div id="mensaje" style="display: none">
                                            <table id="tbmensaje" align="center" width="100%">
                                                <tr>
                                                    <td width="100%" align="center">
                                                        <img src="/siscaim/Imagenes/procesando02.gif" align="center" width="100" height="100">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="100%" align="center">
                                                        <span class="subtitulo">
                                                            Espere por favor, se está realizando la acción solicitada<br>
                                                            Puede tomar varios minutos
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table id="botones" width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGenerar" href="javascript: GenerarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Generar las salidas programadas">
                                            Generar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Generar">
                                                    <a href="javascript: GenerarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/generar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </form>
        <script language="javascript">
            function MostrarMensaje(mensaje){
                var mens = document.getElementById('alerta');
                mens.textContent = mensaje;
                $( "#dialog-message" ).dialog( "open" );
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
                    var mens = document.getElementById('mensaje');
                    mens.style.display = '';
                    var tbfecha = document.getElementById('tbfecha');
                    tbfecha.style.display = 'none';
                    var botones = document.getElementById('botones');
                    botones.style.display = 'none';
                    var frm = document.getElementById('frmSalProgCam');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                    frm.pasoSig.value = '12';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var fecha = document.getElementById('fecha');
                if (fecha.value == ''){
                    MostrarMensaje('No ha establecido la fecha del movimiento');
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
                    MostrarMensaje('Debe seleccionar al menos un Centro de Trabajo');
                    return false;
                }
                
                ctssel.value = ctssel.value.substr(0, ctssel.value.length-1);
                
                return true;
            }
        

        </script>
    </body>
</html>