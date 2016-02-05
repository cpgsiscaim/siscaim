<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Vacaciones, Modelo.Entidades.Empleado, java.text.SimpleDateFormat, java.util.Date"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
List<Vacaciones> listado = (List<Vacaciones>)datosS.get("vacacionesemp");
Empleado empl = (Empleado)datosS.get("empleado");
SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
NumberFormat fmnum = new DecimalFormat("#,##0.00");
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
        
        //DIALOGO CONFIRMACION
        $(function() {
            $( "#dialog-confirm" ).dialog({
            resizable: false,
            width:500,
            height:200,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                $( this ).dialog( "close" );
                EjecutarProceso();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                }
            }
            });
        });
        
        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-document"
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
        
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
        </div>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/empleadosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR VACACIONES DE EMPLEADO
                    </div>
                    <div class="titulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarVacs" name="frmGestionarVacs" action="<%=CONTROLLER%>/Gestionar/Vacaciones" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idVac" name="idVac" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                            </td>
                                            <td width="45%" align="center">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="33%" align="right">
                                                        </td>
                                                        <td width="33%" align="right">
                                                        </td>
                                                        <td width="33%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja de registro de vacaciones seleccionada">
                                                                Baja
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="25%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevoClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Nuevo Registro de Vacaciones">
                                                    Nuevo
                                                </a>
                                            </td>
                                        </tr>
                                    </table>

                                    <hr>
                                    <table class="tablaLista" width="70%" align="center">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td align="center">
                                                <span class="etiquetaB">
                                                    No hay Vacaciones Registradas del Empleado
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="5%">
                                                    &nbsp;
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Año</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Antigüedad</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Días</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Vacaciones</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Prima</span>
                                                </td>
                                                <td align="center" width="20%" colspan="2">
                                                    <span>Período</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Quincena de pago</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Vacaciones vac = listado.get(i);
                                        %>
                                                <tr <%if (vac.getEstatus()==5){%>onclick="Activa(<%=i%>)"<%}%>>
                                                    <td align="center" width="5%">
                                                        <%if (vac.getEstatus()==5){%>
                                                        <input id="radioVac" name="radioVac" type="radio" value="<%=vac.getId()%>"/>
                                                        <%}%>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%=vac.getAnio()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%=vac.getAntiguedad()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%=vac.getDias()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%=fmnum.format(vac.getMontovacaciones())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%=fmnum.format(vac.getMontoprima())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%if(vac.getEstatus()==4 || vac.getEstatus()==5){%>
                                                            <%=vac.getFechainicial()!=null?ffecha.format(vac.getFechainicial()):""%>
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%if(vac.getEstatus()==4 || vac.getEstatus()==5){%>
                                                            <%=vac.getFechafinal()!=null?ffecha.format(vac.getFechafinal()):""%>
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiqueta">
                                                            <%=vac.getQuincena().getMes()+" - "+vac.getQuincena().getNumero()%>
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
                                    <!-- botones siguiente anterior-->
                                    <%
                                    int grupos = Integer.parseInt(datosS.get("gruposvac").toString());
                                    if (grupos == 1){
                                        int sigs = Integer.parseInt(datosS.get("siguientesvac").toString());
                                        int ants = Integer.parseInt(datosS.get("anterioresvac").toString());
                                    %>
                                    <hr>
                                    <table width="100%">
                                        <tr>
                                            <td width="30%">&nbsp;</td>
                                            <td width="10%" align="center">
                                                <style>#btnPrincipio a{display:block;color:transparent;} #btnPrincipio a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnPrincipio" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al principio del listado">
                                                            <a href="javascript: PrincipioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/principio.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnAnterior a{display:block;color:transparent;} #btnAnterior a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnAnterior" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Anteriores">
                                                            <a href="javascript: AnteriorClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/anterior.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnSiguiente a{display:block;color:transparent;} #btnSiguiente a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnSiguiente" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Siguientes">
                                                            <a href="javascript: SiguienteClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/siguiente.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnUltimo a{display:block;color:transparent;} #btnUltimo a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnUltimo" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al final del listado">
                                                            <a href="javascript: FinalClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/final.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="30%">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <%
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->
                                    
                                </td>
                            </tr>
                        </table>
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
            
            function Confirmar(mensaje){
                var mens = document.getElementById('confirm');
                mens.textContent = mensaje;
                $( "#dialog-confirm" ).dialog( "open" );
            }

            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
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
            
            function Activa(fila){
                var idVac = document.getElementById('idVac');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarVacs.radioVac.checked = true;
                    idVac.value = document.frmGestionarVacs.radioVac.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarVacs.radioVac[fila];
                    radio.checked = true;
                    idVac.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                Espera();
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Vacaciones/nueva.jsp';
                paso.value = '1';
                frm.submit();                
            }
                        
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Vacaciones/listado.jsp';
                paso.value = '3';
                frm.submit();
            }
            
            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';                
                Confirmar('¿Está seguro en eliminar el registro seleccionado?');
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentos/inactivos.jsp';
                paso.value = '6';
                frm.submit();
            }
              
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarVacs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                paso.value = '53';
                frm.submit();                
            }

            function ImprimirClick(){
                sels = 0;
                docs = '';
                <%for (int i=0; i < listado.size(); i++){%>
                     var chk = document.getElementById('chkdoc<%=i%>');
                     if (chk.checked){
                         sels++;
                         if (docs == '')
                             docs = chk.value;
                         else
                             docs += ','+chk.value;
                     }
                <%}%>
                var idVac = document.getElementById('idVac');
                var varios = document.getElementById('varios');
                if (sels<1){
                    varios.value = idVac.value;
                } else {
                    varios.value = docs;
                }
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Documentos'+'&paso=8&dato1='+varios.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
            }
        </script>
    </body>
</html>