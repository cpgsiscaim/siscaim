<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.Sucursal"%>
<%@page import="java.lang.String, javax.servlet.http.HttpSession" %>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Contrato> listado = (List<Contrato>)datosS.get("listaContratos");
Cliente cliSel = (Cliente)datosS.get("clienteSel");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
int banhis = Integer.parseInt(datosS.get("banhis")!=null?datosS.get("banhis").toString():"0");
String matriz = datosS.get("matriz").toString();
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

        //Ventana modal del contrato
        $(function() {
            $( "#dialog-contrato" ).dialog({
                autoOpen: false,
                modal: true,
                width:900,
                height:640
            });
        });
        
        //Ventana modal de la fianza
        $(function() {
            $( "#dialog-fianza" ).dialog({
                autoOpen: false,
                modal: true,
                width:900,
                height:640
            });
        });
        

        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnHistorico" ).button({
                icons: {
                    primary: "ui-icon-folder-collapsed"
		}
            });
            $( "#btnVigentes" ).button({
                icons: {
                    primary: "ui-icon-folder-open"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-minus"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-wrench"
		}
            });
            $( "#btnCts" ).button({
                icons: {
                    primary: "ui-icon-home"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
            $( "#btnImportar" ).button({
                icons: {
                    primary: "ui-icon-tag"
		}
            });
            $( "#btnProductos" ).button({
                icons: {
                    primary: "ui-icon-cart"
		}
            });
            $( "#btnGenSalProgr" ).button({
                icons: {
                    primary: "ui-icon-script"
		}
            });
            $( "#btnContactos" ).button({
                icons: {
                    primary: "ui-icon-contact"
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
        
        <div id="dialog-contrato" title="Documento del Contrato">
            <embed id="pdf" src="" width="870" height="580" align="center" valign="center">
        </div>
        
        <div id="dialog-fianza" title="Documento de la Fianza">
            <embed id="pdffianza" src="" width="870" height="580" align="center" valign="center">
        </div>        
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Empresa/contratosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CONTRATOS
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%if (cliSel.getTipo()==0){%>
                        <%=cliSel.getDatosFiscales().getRazonsocial()%><br>
                        <%}%>
                        <%if (cliSel.getDatosFiscales().getPersona()!=null){%>
                        <%=cliSel.getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%}%>
                    </div>
                    <%if (banhis==1){%>
                    <div class="subtitulo" align="left">
                        CONCLUIDOS
                    </div>
                    <%}%>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCon" name="frmGestionarCon" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCon" name="idCon" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <input id="tipoCont" name="tipoCont" type="hidden" value="2"/> 
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table id="acciones1" width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Contratos">
                                                    Salir
                                                </a>
                                                <!--    
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Contratos dados de baja">
                                                    Ver Inactivos
                                                </a>
                                                <!--<style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnHistorico" href="javascript: VerHistorico()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Contratos vencidos">
                                                    Histórico
                                                </a>
                                                <!--<style>#btnHistorico a{display:block;color:transparent;} #btnHistorico a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnHistorico" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Histórico">
                                                            <a href="javascript: VerHistorico()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/historico.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                                <a id="btnVigentes" href="javascript: VerVigentes()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Ver Contratos vigentes">
                                                    Vigentes
                                                </a>
                                                <!--<style>#btnVigentes a{display:block;color:transparent;} #btnVigentes a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnVigentes" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Vigentes">
                                                            <a href="javascript: VerVigentes()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/vigentes.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="15%" align="center">
                                                <!--
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir">
                                                    Imprimir
                                                </a>
                                                <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="15%" align="center">
                                                <!--<style>#btnFiltrar a{display:block;color:transparent;} #btnFiltrar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnFiltrar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Filtrar">
                                                            <a href="javascript: FiltrarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/filtrar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <style>#btnQuitar a{display:block;color:transparent;} #btnQuitar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnQuitar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Quitar Filtros">
                                                            <a href="javascript: QuitarFiltroClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/quitarfiltro.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="25%" align="right">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="34%" align="right">
                                                            <a id="btnCts" href="javascript: CentrosConClick()"
                                                            style="width: 180px; font-weight: bold; color: #0B610B;" title="Mostrar los Centros de Trabajo del contrato seleccionado">
                                                                Centros de Trabajo
                                                            </a>
                                                            <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnCts" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Centros de Trabajo">
                                                                        <a href="javascript: CentrosConClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/centros.png);width:180px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <td width="33%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaConClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja el contrato seleccionado">
                                                                Baja
                                                            </a>
                                                            <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnBaja" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaConClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <td width="33%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarConClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Modificar datos del contrato seleccionado">
                                                                Editar
                                                            </a>
                                                            <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnEditar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Editar">
                                                                        <a href="javascript: EditarConClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->                                                    
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnNuevo" href="javascript: NuevoConClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Registrar un nuevo contrato">
                                                    Nuevo
                                                </a>
                                                <a id="btnContactos" href="javascript: ContactosClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Gestionar contactos del contrato">
                                                    Contactos
                                                </a>
                                                <!--<style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoConClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="acciones2" width="100%" style="display: none">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnImportar" href="javascript: ImportarClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Importar datos de otros contratos del cliente">
                                                    Importar Datos
                                                </a>
                                                <!--<style>#btnImportar a{display:block;color:transparent;} #btnImportar a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnImportar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Importar Datos">
                                                            <a href="javascript: ImportarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/importdatos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="15%" align="left">
                                                <a id="btnProductos" href="javascript: ProductosClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar los productos del contrato seleccionado">
                                                    Productos
                                                </a>
                                                <!--<style>#btnProductos a{display:block;color:transparent;} #btnProductos a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnProductos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Productos del Contrato">
                                                            <a href="javascript: ProductosClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/productosdecon.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="50%" align="center">&nbsp;</td>                                            
                                            <td width="20%" align="right">
                                                <a id="btnGenSalProgr" href="javascript: SalidasProgClick()"
                                                style="width: 250px; font-weight: bold; color: #0B610B;" title="Generar las salidas programadas del contrato seleccionado">
                                                    Generar Salidas Programadas
                                                </a>
                                                <!--<style>#btnGenSalProgr a{display:block;color:transparent;} #btnGenSalProgr a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnGenSalProgr" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Generar Salidas Programadas">
                                                            <a href="javascript: SalidasProgClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/gensalprogs.png);width:220px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <div id="listado">
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    <%if (banhis==0){%>
                                                        No hay Contratos registrados del Cliente
                                                    <%} else {%>
                                                        No hay Contratos Conclu&iacute;dos del Cliente
                                                    <%}%>
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="20%">
                                                    <span>Contrato</span>
                                                </td>
                                                <td align="center" width="30%">
                                                    <span>Descripción</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Especialidad</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Fecha Inicio</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Fecha Fin</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Documentos</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Contrato con = listado.get(i);
                                                String fechaI = con.getFechaIni().toString();
                                                String fechaF = con.getFechaFin().toString();
                                                String fechaNorIni =fechaI.substring(8,10) + "-" + fechaI.substring(5,7) + "-" + fechaI.substring(0, 4);
                                                String fechaNorFin =fechaF.substring(8,10) + "-" + fechaF.substring(5,7) + "-" + fechaF.substring(0, 4);
                                                String espe = "SIN ESPECIALIDAD";
                                                switch(con.getEspecialidad()){
                                                    case 1: espe = "JARDINERÍA";break;
                                                    case 2: espe = "LIMPIEZA";break;
                                                    case 3: espe = "FUMIGACIÓN";break;
                                                    case 4: espe = "JARDINERÍA Y LIMPIEZA";break;
                                                    case 5: espe = "JARDINERÍA Y FUMIGACIÓN";break;
                                                    case 6: espe = "LIMPIEZA Y FUMIGACIÓN";break;
                                                    case 7: espe = "JARDINERÍA, LIMPIEZA Y FUMIGACIÓN";break;
                                                }
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="left" width="15%">
                                                        <input id="radioCon" name="radioCon" type="radio" value="<%=con.getId()%>"/>
                                                        <span class="etiquetaD">
                                                            <%=con.getContrato()%>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="30%">
                                                        <span class="etiquetaD">
                                                            <%=con.getDescripcion()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=espe%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiquetaD">
                                                            <%=fechaNorIni%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiquetaD">
                                                            <%=fechaNorFin%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <%if (con.getDocumento()==0 && con.getDocfianza()==0){%>
                                                            <span class="etiquetaD">Sin documentos</span>
                                                        <%}%>
                                                        <%if (con.getDocumento()==1){%>
                                                        <a href="javascript: MostrarContrato('/siscaim/Imagenes/Contratos/<%=con.getId()%>.pdf')" title="CONTRATO">
                                                              <img src="/siscaim/Estilos/imgsBotones/doc_activo.png" width="26">
                                                            </a>
                                                        <%}%>
                                                        <%if (con.getDocfianza()==1){%>
                                                        <a href="javascript: MostrarFianza('/siscaim/Imagenes/Contratos/Fianzas/<%=con.getId()%>.pdf')" title="FIANZA">
                                                              <img src="/siscaim/Estilos/imgsBotones/doc_activo.png" width="26">
                                                            </a>
                                                        <%}%>
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
                                    </div>
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
            /*function ContactosClick()   {
              var frm = document.getElementById('frmGestionarCon');
              var pagina = document.getElementById('paginaSig');
              var paso = document.getElementById('pasoSig');
              pagina.value = '/Empresa/GestionarClientes/Contratos/contactoscontrato.jsp';
              paso.value ='17';
              frm.submit();
			}*/
		
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
                else if (boton.value=='2')
                    EjecutarSalidasProgs();
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
                <%} 
                HttpSession sesionHttp = request.getSession();
                if (sesion.isError())
                    sesion.setError(false);
                if (sesion.isExito())
                    sesion.setExito(false);
                sesionHttp.setAttribute("sesion", sesion);

                if (banhis==1){%>
                    var inac = document.getElementById('btnInactivos');
                    inac.style.display = 'none';
                    var his = document.getElementById('btnHistorico');
                    his.style.display = 'none';
                    var vig = document.getElementById('btnVigentes');
                    vig.style.display = '';
                    var nvo = document.getElementById('btnNuevo');
                    nvo.style.display = 'none';
                <%}%>
                
                //validar usuario de sucursales
                ValidaUsuariosSucursales();
            }
            
            function ValidaUsuariosSucursales(){
                <%if (matriz.equals("0")){%>
                    var btnNvo = document.getElementById('btnNuevo');
                    var btnBaja = document.getElementById('btnBaja');
                    var btnEd = document.getElementById('btnEditar');
                    var acciones2 = document.getElementById('acciones2');
                    btnNvo.style.display = 'none';
                    btnBaja.style.display = 'none';
                    btnEd.style.display = 'none';
                    acciones2.style.display = 'none';
                <%}%>
            }
            
            function Activa(fila){
                var idCon = document.getElementById('idCon');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                var acciones2 = document.getElementById('acciones2');
                acciones2.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarCon.radioCon.checked = true;
                    idCon.value = document.frmGestionarCon.radioCon.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCon.radioCon[fila];
                    radio.checked = true;
                    idCon.value = radio.value;
                <% 
                }
                if (banhis==1){%>
                   /*var baja = document.getElementById('btnBaja');
                   baja.style.display = 'none';
                   var edit = document.getElementById('btnEditar');
                   edit.style.display = 'none';*/
                   var impor = document.getElementById('btnImportar');
                   impor.style.display = 'none';
                   var salidas = document.getElementById('btnGenSalProgr');
                   salidas.style.display = 'none';
                <% } %>
                <%if (matriz.equals("0")){%>
                    var btnCon = document.getElementById('btnContactos');
                    btnCon.style.display = '';
                <% } %>    
                ValidaUsuariosSucursales();
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoConClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarConClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '5';
                frm.submit();
            }
            
            function BajaConClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro en dar de baja el Contrato seleccionado?');
                /*
                var resp = confirm('¿Está seguro en dar de baja el Contrato seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarCon');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                    paso.value = '5';
                    frm.submit();
                }*/
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/contratosinactivos.jsp';
                paso.value = '6';
                frm.submit();                
            }
                                    
            function CentrosConClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                paso.value = '8';
                frm.submit();                
            }
            
            function ProductosClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function EjecutarSalidasProgs(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/generarsalidasprog.jsp';
                paso.value = '10';
                frm.submit();
            }
            
            function SalidasProgClick(){
                var boton = document.getElementById('boton');
                boton.value = '2';
                Confirmar('Los datos actuales de las Salidas Programadas serán reemplazados, ¿continuar?');
                /*
                var resp = confirm('Los datos actuales de las Salidas Programadas serán reemplazados, ¿continuar?','SISCAIM');
                if (resp){
                    var mens = document.getElementById('mensaje');
                    mens.style.display = '';
                    var lis = document.getElementById('listado');
                    lis.style.display = 'none';
                    var acciones2 = document.getElementById("acciones2");
                    acciones2.style.display = 'none';
                    var acciones1 = document.getElementById("acciones1");
                    acciones1.style.display = 'none';
                    var frm = document.getElementById('frmGestionarCon');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/generarsalidasprog.jsp';
                    paso.value = '10';
                    frm.submit();
                }*/
            }
            
            /*
            function SalidasProgCambiosClick(){
                var resp = confirm('Los datos actuales de las Salidas Programadas serán reemplazados, ¿continuar?','SISCAIM');
                if (resp){
                    var tbmens = document.getElementById('tbmensaje');
                    tbmens.style.display = '';
                    var frm = document.getElementById('frmGestionarCon');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/salidasprogscambios.jsp';
                    paso.value = '11';
                    frm.submit();
                }
            }*/
            
            function ImportarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/importardatos.jsp';
                paso.value = '13';
                frm.submit();
            }
            
            function VerHistorico(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '15';
                frm.submit();
            }
            
            function VerVigentes(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '16';
                frm.submit();
            }
            
            function ContactosClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/contactoscontrato.jsp';
                paso.value = '17';
                frm.submit();
            }
            
            function MostrarContrato(doc){
                var pdf = document.getElementById('pdf');
                pdf.src = doc;
                $( "#dialog-contrato" ).dialog( "open" );
            }
            
            function MostrarFianza(doc){
                var pdf = document.getElementById('pdffianza');
                pdf.src = doc;
                $( "#dialog-fianza" ).dialog( "open" );
            }
            
        </script>
    </body>
</html>