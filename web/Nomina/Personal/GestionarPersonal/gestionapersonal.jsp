<%-- 
    Document   : gestionapersonal
    Created on : May 14, 2012, 1:28:16 PM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- aqui poner los imports--%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Persona, Modelo.Entidades.Empleado"%>
<%@page import="java.lang.String, javax.servlet.http.HttpSession, java.text.SimpleDateFormat, java.util.Date"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
List<Empleado> listado = new ArrayList<Empleado>();//(List<Cliente>)datosS.get("listado");
Sucursal sucSel = (Sucursal)datosS.get("sucursal");
int banfiltro = datosS.get("banfiltro")!=null?Integer.parseInt(datosS.get("banfiltro").toString()):0;
SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
String hoy = ffecha.format((Date)datosS.get("hoy"));
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
                SolicitarFecha();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                }
            }
            });
        });
        
        //DIALOGO CONFIRMACION
        $(function() {
            $( "#dialog-baja" ).dialog({
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
            $( "#btnSalir" ).button({
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
            $( "#btnFirma" ).button({
                icons: {
                    primary: "ui-icon-pin-s"
		}
            });
            $( "#btnContrato" ).button({
                icons: {
                    primary: "ui-icon-note"
		}
            });
            $( "#btnPagos" ).button({
                icons: {
                    primary: "ui-icon-calculator"
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
        
        <div id="dialog-baja" title="SISCAIM - Fecha de baja">
            <span class="etiquetaB">Ingrese la fecha de baja:</span>
            <input id="fechabaja" name="fechabaja" type="text" class="text" readonly value=""
                title="Ingrese la fecha de baja del empleado" />            
        </div>
        
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
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/empleadosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGesPersonal" name="frmGesPersonal" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idEmp" name="idEmp" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <input id="fechaalta" name="fechaalta" type="hidden" value=""/>
            <input id="fechab" name="fechab" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">                                
                <tr>
                    <td width="100%" valign="top">
                        <div class="titulo" align="center">
                            <!--aquí poner el contenido de la jsp --> 
                            <table width="100%">
                                <tr>
                                    <%-- Boton Salir --%>
                                    <td width="50%" align="left">
                                        <a id="btnSalir" href="javascript: SalirClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Salir">
                                            Salir
                                        </a>
                                    </td>
                                    <td width="50%" align="right">
                                        <select id="sucursalsel" name="sucursalsel" class="combo" onchange="MostrarEmpleados()" style="width: 300px">
                                            <option value="0">Elija la Sucursal...</option>
                                        <%
                                            List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                            if (sucursales!=null){
                                                if (sucursales.size()!=0){
                                                    for (int i=0; i < sucursales.size(); i++){
                                                        Sucursal suc = sucursales.get(i);
                                                    %>
                                                        <option value="<%=suc.getId()%>"
                                                                <%
                                                                //if (paso!=0){
                                                                    //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                    if (sucSel.getId()==suc.getId()){
                                                                    %>
                                                                        selected
                                                                    <%
                                                                    }
                                                                //}
                                                                %>
                                                                >
                                                            <%=suc.getDatosfis().getRazonsocial()%>
                                                        </option>
                                                    <%
                                                    }
                                                }
                                            }
                                        %>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <table id="acciones" width="100%" style="display: none">
                                <tr>
                                    <%-- Boton Inactivos --%>
                                    <td width="15%" align="left">
                                        <a id="btnInactivos" href="javascript: VerInactivos()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Inactivos">
                                            Ver Inactivos
                                        </a>
                                    </td>
                                    <td width="15%" align="center">&nbsp;</td>
                                    <%-- Boton Imprimir --%>
                                    <td width="25%" align="center">
                                        <a id="btnImprimir" href="javascript: ImprimirClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Listado de la sucursal">
                                            Imprimir
                                        </a>
                                        <input id="xls" name="xls" type="checkbox">
                                        <span class="etiqueta">Imprimir en Excel</span>                                                            
                                    </td>
                                    <%-- Boton Filtrar --%>
                                    <td width="15%" align="center">
                                        <a id="btnFiltrar" href="javascript: FiltrarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Filtrar personal">
                                            Filtrar
                                        </a>
                                        <a id="btnQuitar" href="javascript: QuitarFiltrosClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Quitar el filtro de personal">
                                            Quitar filtro
                                        </a>
                                    </td>
                                    <td width="15%" align="center">
                                        <a id="btnImprimirGaf" href="javascript: ImprimirGafetesClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Gafetes">
                                            Imprimir Gafetes
                                        </a>
                                    </td>
                                    <%-- Boton Nuevo --%>
                                    <td width="15%" align="right">
                                        <a id="btnNuevo" href="javascript: NuevaPersonaClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Nuevo Empleado">
                                            Nuevo
                                        </a>
                                    </td>
                                </tr>
                            </table>
                            <table id="acciones2" width="100%" style="display: none">
                                <tr>
                                    <td width="10%" align="right">
                                        <a id="btnVacas" href="javascript: VacacionesClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Vacaciones del Empleado seleccionado">
                                            Vacaciones
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnFoto" href="javascript: FotoClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Fotografía del Empleado seleccionado">
                                            Foto
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnMedios" href="javascript: MediosClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Medios del empleado seleccionado (tels y mails)">
                                            Medios
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnFamiliares" href="javascript: FamiliaresClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Beneficiarios del empleado seleccionado">
                                            Beneficiarios
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnGafete" href="javascript: GafeteClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Gafete del empleado seleccionado">
                                            Gafete
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnBaja" href="javascript: BajaCliClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja del empleado seleccionado">
                                            Baja
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnEditar" href="javascript: EditarPersonaClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar el empleado seleccionado">
                                            Editar
                                        </a>
                                    </td>
                                </tr>
                            </table>
                            <table id="acciones3" width="100%" style="display: none">
                                <tr>
                                    <td width="10%" align="right">
                                        <a id="btnPagos" href="javascript: PagosClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Pagos del Empleado">
                                            Pagos
                                        </a>                                        
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnContrato" href="javascript: ContratoClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Contrato Individual de Trabajo">
                                            Contrato
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnFirma" href="javascript: FirmaClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar Firma del Empleado">
                                            Firma
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnCambiarSuc" href="javascript: CambiarSucClick()"
                                            style="width: 180px; font-weight: bold; color: #0B610B;" title="Cambiar de sucursal empleado seleccionado">
                                            Cambiar de Sucursal
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnDocumentos" href="javascript: DocumentosClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Documentos del empleado seleccionado">
                                            Documentos
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnFormatos" href="javascript: FormatosClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Formatos de ingreso del empleado seleccionado">
                                            Formatos
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnPlazas" href="javascript: PlazasClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Plazas del empleado seleccionado">
                                            Plazas
                                        </a>
                                    </td>
                                </tr>
                            </table>
                            <hr>
                            <div id="dvfiltros" style="display: none">
                                <table width="100%">
                                    <tr>
                                        <td width="10%" align="left">
                                            <span class="etiquetaC">Clave:</span><br>
                                            <input id="filclave" name="filclave" type="text" class="text" value="" style="width: 100px"
                                                onkeypress="return ValidaAlfaNum(event)" onblur="Mayusculas(this)"
                                                maxlength="5"/>
                                        </td>
                                        <td width="14%" align="left">
                                            <span class="etiquetaC">Nombre:</span><br>
                                            <input id="filnombre" name="filnombre" type="text" class="text" value="" style="width: 150px"
                                                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                maxlength="30"/>
                                        <td width="13%" align="left">
                                            <span class="etiquetaC">Paterno:</span><br>
                                            <input id="filpaterno" name="filpaterno" type="text" class="text" value="" style="width: 150px"
                                                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                maxlength="30"/>
                                        </td>
                                        <td width="13%" align="left">
                                            <span class="etiquetaC">Materno:</span><br>
                                            <input id="filmaterno" name="filmaterno" type="text" value="" class="text" style="width: 150px"
                                                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                maxlength="30"/>                                            
                                        </td>
                                        <td width="5%" align="center">
                                            <a id="btnMostrar" href="javascript: BuscarClick()"
                                                style="width: 100px; font-weight: bold; color: #0B610B;" title="Obtener empleados que cumplan los criterios">
                                                Mostrar
                                            </a>
                                        </td>
                                        <td width="45%" align="left">&nbsp;</td>
                                    </tr>
                                </table>
                                <hr>
                            </div>
                            
                            <%
                            if (sucSel.getId()!=0){
                                listado = (List<Empleado>)datosS.get("listado");
                                if (listado.size()==0){
                            %>
                            <table class="tablaLista" width="100%">
                                <tr>
                                    <td width="100%" align="center">
                                        <span class="etiquetaB">
                                            No hay Empleados registrados en la Sucursal seleccionada
                                        </span>
                                    </td>
                                </tr>
                            </table>
                            <%
                                } else {
                            %>
                            <%-- Tabla de Datos --%>
                            <table class="tablaLista" width="100%">
                                <thead>
                                <tr>
                                    <td width="15%" align="center" colspan="2">
                                        <span>Clave</span>
                                    </td>
                                    <td width="35%" align="center">
                                        <span>Nombre</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>CURP</span>
                                    </td>
                                    <td width="20%" align="center">
                                        <span>Ciudad</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>Estado</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>Documentaci&oacute;n</span>
                                    </td>
                                </tr>
                                </thead>
                                <tbody>
                                    <%
                                    //List<String> docus = (List<String>)datosS.get("estatusdocs");
                                    //rojo=FF2828, amarillo=FBFF28, verde=45FF28
                                    for (int i=0; i < listado.size(); i++){
                                        Empleado p = (Empleado)listado.get(i);
                                        String color = "#45FF28";
                                        if (p.getDocestatus()==2)
                                            color = "#FBFF28";
                                        else if (p.getDocestatus()==3)
                                            color = "#FF2828";
                                    %>
                                    <tr onclick="Activa(<%=i%>)" ondblclick="VerFicha(<%=i%>)">
                                        <td align="center" width="5%">
                                            <input id="radioEmp" name="radioEmp" type="radio" value="<%=p.getNumempleado()%>"/>
                                            <input id="falta<%=i%>" name="falta<%=i%>" type="hidden" value="<%=ffecha.format(p.getFecha())%>"/>
                                        </td>
                                        <td align="left" width="10%">
                                            <span class="etiqueta"><%=p.getClave()%></span>
                                            <img src="/siscaim/Imagenes/Personal/Fotos/<%=p.getImagen()%>" width="20" height="20"/>
                                        </td>
                                        <td width="35%" align="left">
                                            <span class="etiqueta"><%=p.getPersona().getNombreCompletoPorApellidos()%></span>
                                        </td>
                                        <td width="10%" align="center">
                                            <span class="etiqueta"><%=p.getPersona().getCurp()%></span>
                                        </td>
                                        <td width="20%" align="center">
                                            <span class="etiqueta"><%=p.getPersona().getDireccion().getPoblacion().getMunicipio()%></span>
                                        </td>
                                        <td width="10%" align="center">
                                            <span class="etiqueta"><%=p.getPersona().getDireccion().getPoblacion().getEstado().getEstado()%></span>
                                        </td>
                                        <td width="10%" align="center">
                                            <table width="30%" height="20px" align="center"><tr>
                                                    <td width="100%" bgcolor="<%=color%>"></td>
                                                </tr></table>
                                        </td>
                                    </tr>
                                    <%
                                    } //Fin for
                                    %>                                        
                                </tbody>
                            </table>
                            <%
                                }
                            }
                            %>
                        </div>
                        <!-- botones siguiente anterior-->
                        <%
                        int grupos = Integer.parseInt(datosS.get("grupos").toString());
                        if (grupos == 1){
                            int sigs = Integer.parseInt(datosS.get("siguientes").toString());
                            int ants = Integer.parseInt(datosS.get("anteriores").toString());
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
            
            function SolicitarFecha(){
                //obtener la fecha de alta del empleado seleccionado
                var fechaalta = document.getElementById('fechaalta');
                $( "#fechabaja" ).datepicker( "option", "maxDate", "<%=hoy%>" );
                $( "#fechabaja" ).datepicker( "option", "minDate", fechaalta.value);
                $( "#dialog-baja" ).dialog( "open" );
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
            
            function VacacionesClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Vacaciones/listado.jsp';
                paso.value = '35';
                frm.submit();                
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
            HttpSession sesionHttp = request.getSession();
            if (sesion.isError())
                sesion.setError(false);
            if (sesion.isExito())
                sesion.setExito(false);
            sesionHttp.setAttribute("sesion", sesion);
            
            if (sucSel.getId()!=0){
            %>
                var acciones = document.getElementById('acciones');
                acciones.style.display = '';
            <%
                if (listado.size()==0){
                %>
                    var imprlis = document.getElementById('btnImprimir');
                    var fil = document.getElementById('btnFiltrar');
                    var quitarfil = document.getElementById('btnQuitar');
                    var imprgaf = document.getElementById('btnImprimirGaf');
                    imprlis.style.display = 'none';
                    fil.style.display = 'none';
                    quitarfil.style.display = 'none';
                    imprgaf.style.display = 'none';
                <%
                }
            }
            if (banfiltro==1){
                HashMap filtros = (HashMap)datosS.get("filtros");
            %>
                var btnFiltrar = document.getElementById('btnFiltrar');
                var btnQuitarFil = document.getElementById('btnQuitar');
                var dvfiltros = document.getElementById('dvfiltros');
                var filclave = document.getElementById('filclave');
                var filnom = document.getElementById('filnombre');
                var filpat = document.getElementById('filpaterno');
                var filmat = document.getElementById('filmaterno');
                btnFiltrar.style.display = 'none';
                btnQuitarFil.style.display = '';
                dvfiltros.style.display = '';
                filclave.value = '<%=filtros.get("clave").toString()%>'
                filnom.value = '<%=filtros.get("nombre").toString()%>'
                filpat.value = '<%=filtros.get("paterno").toString()%>'
                filmat.value = '<%=filtros.get("materno").toString()%>'
                filclave.focus();
            <% } %>
        }           

        function MostrarEmpleados(){
            var frm = document.getElementById('frmGesPersonal');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
            paso.value = '100';
            frm.submit();                    
        }

        function NuevaPersonaClick(){
            Espera();
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "1";
            var frm = document.getElementById('frmGesPersonal');
            frm.submit();
        }
        
        function EditarPersonaClick(){
            Espera();
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "4";
            var frm = document.getElementById('frmGesPersonal');
            frm.submit();
        }
        
        function EjecutarBaja(){
            Espera();
            var fb = document.getElementById('fechabaja');
            var fechab = document.getElementById('fechab');
            fechab.value = fb.value;
            var frm = document.getElementById('frmGesPersonal');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = "/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp";
            paso.value = '6';
            frm.submit();
        }
        
            
        function BajaCliClick(){
            var boton = document.getElementById('boton');
            boton.value = '1';                
            Confirmar('¿Está seguro en dar de baja el Empleado seleccionado?');
        }

        function SalirClick(){
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp';
                paso.value = '7';
                frm.submit();                
            }

            function Activa(fila){
                var idEmp = document.getElementById('idEmp');
                var acciones2 = document.getElementById('acciones2');
                acciones2.style.display = '';
                var acciones3 = document.getElementById('acciones3');
                acciones3.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    //document.frmGestionarCli.radioCli.checked = true;
                    document.frmGesPersonal.radioEmp.checked = true;
                    //idCli.value = document.frmGestionarCli.radioCli.value;
                    idEmp.value = document.frmGesPersonal.radioEmp.value;
                <%
                } else {
                %>
                    var radio = document.frmGesPersonal.radioEmp[fila];//document.frmGestionarCli.radioCli[fila];
                    radio.checked = true;
                    idEmp.value = radio.value;
                <% } %>
                var fechaalta = document.getElementById('fechaalta');
                var falta = document.getElementById('falta'+fila);
                fechaalta.value = falta.value;
            }

            function FotoClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/nuevafoto.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function GafeteClick(){
                var idEmp = document.getElementById('idEmp');
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=10&dato1='+idEmp.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');                
            }
            
            function ImprimirGafetesClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/imprimirgafetes.jsp';
                paso.value = '11';
                frm.submit();                
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
            function FamiliaresClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Familiares/gestionarfamiliares.jsp';
                paso.value = '13';
                frm.submit();                
            }
            
            function MediosClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Medios/mediosempleado.jsp';
                paso.value = '14';
                frm.submit();                
            }
            
            function ImprimirClick(){
                var suc = document.getElementById('sucursalsel');
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGesPersonal');
                    dat1.value = suc.value;
                    paso.value = '25';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=15&dato1='+suc.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
                <%--
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=15',
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                --%>
            }
            
            function FormatosClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/formatosempleado.jsp';
                paso.value = '16';
                frm.submit();                
            }
            
            function PlazasClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/plazasempleado.jsp';
                paso.value = '18';
                frm.submit();                
            }
            
            function DocumentosClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                paso.value = '20';
                frm.submit();                
            }
            
            function FiltrarClick(){
                var btnFiltrar = document.getElementById('btnFiltrar');
                var btnQuitarFil = document.getElementById('btnQuitar');
                var dvfiltros = document.getElementById('dvfiltros');
                var filclave = document.getElementById('filclave');
                btnFiltrar.style.display = 'none';
                btnQuitarFil.style.display = '';
                dvfiltros.style.display = '';
                filclave.focus();
            }
            
            function QuitarFiltrosClick(){
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '22';
                frm.submit();                
            }
            
            function BuscarClick(){
                var filclave = document.getElementById('filclave');
                var filnom = document.getElementById('filnombre');
                var filpat = document.getElementById('filpaterno');
                var filmat = document.getElementById('filmaterno');
                if (filclave.value == '' && filnom.value == '' && filpat.value == ''
                    && filmat.value == ''){
                    Mensaje ('Debe especificar el valor en al menos un campo');
                    return;
                }
                
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '21';
                frm.submit();                
            }
            
            function CambiarSucClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/cambiarsuc.jsp';
                paso.value = '23';
                frm.submit();                
            }
            
            function FirmaClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/nuevafirma.jsp';
                paso.value = '36';
                frm.submit();                
            }
            
            function ContratoClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/generacontratotrabajo.jsp';
                paso.value = '38';
                frm.submit();                
            }
            
            function PagosClick(){
                Espera();
                var frm = document.getElementById('frmGesPersonal');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/pagos.jsp';
                paso.value = '40';
                frm.submit();                
            }
            
            function VerFicha(fila){
                var idEmp = document.getElementById('idEmp');
                <%
                if (listado.size()==1){
                %>
                    idEmp.value = document.frmGesPersonal.radioEmp.value;
                <%
                } else {
                %>
                    var radio = document.frmGesPersonal.radioEmp[fila];
                    idEmp.value = radio.value;
                <% } %>
                Espera();
                var paginaSig = document.getElementById("paginaSig");
                paginaSig.value = "/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp";
                var pasoSig = document.getElementById("pasoSig");
                pasoSig.value = "4";
                var frm = document.getElementById('frmGesPersonal');
                frm.submit();
            }
            
        </script>
    </body>
</html>
