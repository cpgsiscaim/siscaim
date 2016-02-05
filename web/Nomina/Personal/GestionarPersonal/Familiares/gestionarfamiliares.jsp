<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Familiar, Modelo.Entidades.Empleado"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
List<Familiar> listado = (List<Familiar>)datosS.get("familiares");
Empleado empl = (Empleado)datosS.get("empleado");
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
        
        //FECHAS
        $(function() {
            $( "#fechabaja" ).datepicker({
            changeMonth: true,
            changeYear: true,
            });
        });
        
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            
            $( "#btnImprimirGaf" ).button({
                icons: {
                    primary: "ui-icon-contact"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnFiltrar" ).button({
                icons: {
                    primary: "ui-icon-zoomin"
		}
            });
            $( "#btnQuitar" ).button({
                icons: {
                    primary: "ui-icon-zoomout"
		}
            });
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            $( "#btnFoto" ).button({
                icons: {
                    primary: "ui-icon-person"
		}
            });
            $( "#btnMedios" ).button({
                icons: {
                    primary: "ui-icon-mail-closed"
		}
            });
            $( "#btnFamiliares" ).button({
                icons: {
                    primary: "ui-icon-link"
		}
            });
            $( "#btnGafete" ).button({
                icons: {
                    primary: "ui-icon-comment"
		}
            });
            $( "#btnCambiarSuc" ).button({
                icons: {
                    primary: "ui-icon-shuffle"
		}
            });
            $( "#btnDocumentos" ).button({
                icons: {
                    primary: "ui-icon-folder-open"
		}
            });
            $( "#btnFormatos" ).button({
                icons: {
                    primary: "ui-icon-note"
		}
            });
            $( "#btnPlazas" ).button({
                icons: {
                    primary: "ui-icon-home"
		}
            });
            $( "#btnMostrar" ).button({
                icons: {
                    primary: "ui-icon-search"
		}
            });
            $( "#btnVacas" ).button({
                icons: {
                    primary: "ui-icon-note"
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
                    <img src="/siscaim/Imagenes/Empresa/familiaresA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        BENEFICIARIOS
                    </div>
                    <div class="titulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarFam" name="frmGestionarFam" action="<%=CONTROLLER%>/Gestionar/Familiar" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <input id="idFam" name="idFam" type="hidden" value=""/>
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
                                                <a id="btnCancelar" href="javascript: CancelarClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Cancelar">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Inactivos">
                                                    Ver Inactivos
                                                </a>
                                            </td>
                                            <td width="45%" align="center">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja">
                                                                Baja
                                                            </a>
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar">
                                                                Editar
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="25%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevoClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Nuevo">
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
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Familiares registrados del Empleado
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="60%" colspan="2">
                                                    <span>Nombre</span>
                                                </td>
                                                <td align="center" width="40%">
                                                    <span>Tipo de Familiar</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Familiar fam = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioFam" name="radioFam" type="radio" value="<%=fam.getId()%>"/>
                                                    </td>
                                                    <td align="left" width="50%">
                                                        <span class="etiqueta">
                                                            <%=fam.getPersona().getNombreCompletoPorApellidos()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="40%">
                                                        <span class="etiqueta">
                                                            <%=fam.getTipofamiliar().getDescripcion()%>
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
                var idFam = document.getElementById('idFam');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarFam.radioFam.checked = true;
                    idFam.value = document.frmGestionarFam.radioFam.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarFam.radioFam[fila];
                    radio.checked = true;
                    idFam.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarFam');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                Espera();
                var frm = document.getElementById('frmGestionarFam');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Familiares/nuevofamiliar.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarFam');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Familiares/nuevofamiliar.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarFam');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Familiares/gestionarfamiliares.jsp';
                paso.value = '5';
                frm.submit();
            }
            
            
            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';                
                Confirmar('¿Está seguro en dar de baja el Beneficiario seleccionado?');
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarFam');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Familiares/familiaresinactivos.jsp';
                paso.value = '6';
                frm.submit();
            }
                        
        </script>
    </body>
</html>