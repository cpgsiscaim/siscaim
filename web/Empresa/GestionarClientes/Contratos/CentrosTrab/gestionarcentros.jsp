<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.text.NumberFormat, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<CentroDeTrabajo> listado = (List<CentroDeTrabajo>)datosS.get("listaCentros");
Cliente cliSel = (Cliente)datosS.get("clienteSel");
Contrato conSel = (Contrato)datosS.get("editarContrato");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
int banhis = Integer.parseInt(datosS.get("banhis")!=null?datosS.get("banhis").toString():"0");
NumberFormat formato = new DecimalFormat("#,##0.00");
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
            $( "#btnProdsCt" ).button({
                icons: {
                    primary: "ui-icon-cart"
		}
            });
            $( "#btnPlazas" ).button({
                icons: {
                    primary: "ui-icon-home"
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
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-plus"
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
                    <img src="/siscaim/Imagenes/Empresa/centrostrabA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CENTROS DE TRABAJO
                    </div>
                    <div class="titulo" align="left">
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
                    <div class="subtitulo" align="left">
                        CONTRATO <%=conSel.getContrato()%> <%=conSel.getDescripcion()%>
                        <%if (banhis==1){%> (CONCLUIDO) <%}%>
                    </div>
                </td>
                
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCT" name="frmGestionarCT" action="<%=CONTROLLER%>/Gestionar/CentrosTrab" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCT" name="idCT" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <input id="tipoCont" name="tipoCont" type="hidden" value="3"/>
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
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Centros de Trabajo">
                                                    Salir
                                                </a>
                                                <!--<style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Centros de Trabajo dados de baja">
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
                                            <td width="60%" align="right">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="25%" align="right">
                                                            <a id="btnProdsCt" href="javascript: ProductosCTClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Productos del Centro de Trabajo">
                                                                Productos
                                                            </a>
                                                            <!--<style>#btnProdsCt a{display:block;color:transparent;} #btnProdsCt a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnProdsCt" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Productos">
                                                                        <a href="javascript: ProductosCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/productosct.png);width:180px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <a id="btnPlazas" href="javascript: PlazasCTClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Plazas del Centro de Trabajo">
                                                                Plazas
                                                            </a>
                                                            <!--<style>#btnPlazas a{display:block;color:transparent;} #btnPlazas a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                            <table id="btnPlazas" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Plazas del CT">
                                                                        <a href="javascript: PlazasCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/plazas.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaCTClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja el Centro de Trabajo seleccionado">
                                                                Baja
                                                            </a>
                                                            <!--<style>#btnBaja a{display:block;color:transparent;} #btnBaja a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnBaja" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarCTClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Modificar datos del Centro de Trabajo seleccionado">
                                                                Editar
                                                            </a>
                                                            <!--<style>#btnEditar a{display:block;color:transparent;} #btnEditar a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnEditar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Editar">
                                                                        <a href="javascript: EditarCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <a id="btnNuevo" href="javascript: NuevoCTClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Registrar un nuevo Centro de Trabajo">
                                                    Nuevo
                                                </a>
                                                <!--<style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Centros de Trabajo registrados del Contrato seleccionado
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="40%">
                                                    <span>Nombre</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Personal</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Entregas</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Tope de Sueldos</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Tope de Insumos</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                CentroDeTrabajo ct = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="left" width="40%">
                                                        <input id="radioCT" name="radioCT" type="radio" value="<%=ct.getId()%>"/>
                                                        <span class="etiquetaD">
                                                            <%=ct.getNombre()%>
                                                            <%if (ct.getDireccion()!=null){%>
                                                                (<%=ct.getDireccion().getCalle()%>, COL. <%=ct.getDireccion().getColonia()%>,
                                                                <%=ct.getDireccion().getPoblacion().getMunicipio()%>,<%=ct.getDireccion().getPoblacion().getEstado().getEstado()%>)
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=Float.toString(ct.getPersonal())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%if (ct.getConfigentrega()==0){%>
                                                                DEFINIDAS EN EL CONTRATO
                                                            <%} else if (ct.getTipoentrega()==0){%>
                                                                CADA <%=Integer.toString(ct.getDiasEntrega())%> D&Iacute;AS
                                                            <%} else if (ct.getTipoentrega()==1){%>
                                                                FECHAS ESPEC&Iacute;FICAS
                                                            <%} else {%>
                                                                NO CONFIGURADAS
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=formato.format(ct.getTopeSueldos())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=formato.format(ct.getTopeInsumos())%>
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
                else if (boton.value=='2')
                    EjecutarSalidasProgs();
            }
            
            /*function ContactosClick()   {
              var frm = document.getElementById('frmGestionarCT');
              var pagina = document.getElementById('paginaSig');
              var paso = document.getElementById('pasoSig');
              pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/contactosct.jsp';
              paso.value ='10';
              frm.submit();
            }*/
            
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
                if (banhis==1){
                %>
                    var nvo = document.getElementById('btnNuevo');
                    nvo.style.display = 'none';
                    var inactivos = document.getElementById('btnInactivos');
                    inactivos.style.display = 'none';
                <%}%>
                ValidaUsuariosSucursales();
            }
            
            function ValidaUsuariosSucursales(){
                <%if (matriz.equals("0")){%>
                    var btnNvo = document.getElementById('btnNuevo');
                    var btnProdsCt = document.getElementById('btnProdsCt');
                    var btnBaja = document.getElementById('btnBaja');
                    var btnEd = document.getElementById('btnEditar');
                    btnNvo.style.display = 'none';
                    btnProdsCt.style.display = 'none';
                    btnBaja.style.display = 'none';
                    btnEd.style.display = 'none';
                <%}%>
            }
            
            function Activa(fila){
                var idCT = document.getElementById('idCT');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarCT.radioCT.checked = true;
                    idCT.value = document.frmGestionarCT.radioCT.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCT.radioCT[fila];
                    radio.checked = true;
                    idCT.value = radio.value;
                <% }
                if (banhis==1){
                %>
                    borrarEdit.style.display = 'none';
                <% } %>
                ValidaUsuariosSucursales();
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoCTClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/nuevocentro.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarCTClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/nuevocentro.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                paso.value = '5';
                frm.submit();
            }
            
            function BajaCTClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro en dar de baja el Centro de Trabajo seleccionado?');
                
                
                /*var resp = confirm('¿Está seguro en dar de baja el Centro de Trabajo seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarCT');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                    paso.value = '5';
                    frm.submit();
                }*/
            }
            
            function ProductosCTClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                paso.value = '8';
                frm.submit();
            }

            function PlazasCTClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '9';
                frm.submit();
            }

            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/centrosinactivos.jsp';
                paso.value = '6';
                frm.submit();                
            }
                                    
            /*function CentrosConClick(){
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                paso.value = '8';
                frm.submit();                
            }*/
        </script>
    </body>
</html>