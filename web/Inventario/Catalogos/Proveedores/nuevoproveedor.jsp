<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.ArrayList, java.util.List, Modelo.Entidades.Sucursal, Modelo.Entidades.ContactoProveedor, Modelo.Entidades.PersonaMedio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String titulo = "NUEVO";
    String imagen = "proveedoresB.png";
    List<ContactoProveedor> contactos = new ArrayList<ContactoProveedor>();
    List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR";
        imagen = "proveedoresC.png";
        contactos = (List<ContactoProveedor>)datosS.get("contactos");
        medioscon = (List<PersonaMedio>)datosS.get("medioscon");
    }
    String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaAlta" ).datepicker({
            changeMonth: true,
            changeYear: true
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
        
        //DIALOGO CONTACTO
        $(function() {
            $( "#dialog-contacto" ).dialog({
            resizable: false,
            width:700,
            height:460,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                //AgregarContacto();
                GuardaContacto();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                LimpiarInputs();
                }
            }
            });
        });        
        
        
        //TABS
        $(function() {
            $( "#tabs" ).tabs();
            //inicializar los tabs
            <%switch (Integer.parseInt(pestaña)){
                case 1:%>$( "#tabs" ).tabs({ active: 0 });<%break;
                case 2:%>$( "#tabs" ).tabs({ active: 1 });<%break;
                case 3:%>$( "#tabs" ).tabs({ active: 2 });<%break;
            }%>
        });
                
        //BOTONES
        $(function() {
            //pestaña contactos
            $( "#btnBajaContac" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnEditarContac" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevoContac" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            //fin pestaña contactos
            
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PROVEEDORES - <%=titulo%>
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoPro" name="frmNuevoPro" action="<%=CONTROLLER%>/Gestionar/Proveedores" method="post">
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
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Datos Generales</a></li>
                                                <!--<li><a href="#tabs-2">Impuestos y Stock</a></li>-->
                                                <li><a href="#tabs-2">Otros</a></li>
                                                <%if (datosS.get("accion").toString().equals("editar")){%>
                                                <li><a href="#tabs-3">Contactos</a></li>
                                                <%}%>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestdatosgenprov.jsp"%>
                                            </div>
                                            <div id="tabs-2">
                                                <%@include file="pestotrosprov.jsp" %>
                                            </div>
                                            <%if (datosS.get("accion").toString().equals("editar")){%>
                                            <div id="tabs-3">
                                                <%@include file="pestcontactosprov.jsp" %>
                                            </div>
                                            <%}%>
                                        </div>                                        
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar Proveedor">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar cambios del proveedor">
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
                <table id="tbprocesando" align="center" width="100%">
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
                var razonProv = document.getElementById('razonProv');
                razonProv.focus();
                var btnBajaContac = document.getElementById('btnBajaContac');
                var btnEditarContac = document.getElementById('btnEditarContac');
                btnEditarContac.style.display = 'none';
                btnBajaContac.style.display = 'none';
                
            }

            function PonerInactivo(total){
                for (i=1; i<=total; i++){
                    var pest = document.getElementById('pest'+i);
                    if (pest.className=='activo'){
                        pest.className='inactivo';
                        var cont = document.getElementById('pest'+i+'cont');
                        cont.style.display = 'none';
                    }
                }
            }
        
            function ClickPestana(numpest, total){
                PonerInactivo(total);                
                var pest = document.getElementById('pest'+numpest);
                pest.className = 'activo';
                var cont = document.getElementById('pest'+numpest+'cont');
                cont.style.display = '';
                if (numpest==1){
                    var razonProv = document.getElementById('razonProv');
                    razonProv.focus();                    
                } else {
                    var banco = document.getElementById('banco');
                    banco.focus();                    
                }
            }

            function CancelarClick(){
                Espera();
                var frm = document.getElementById('frmNuevoPro');
                frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoPro');
                    frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '5';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '3';
                <%
                    }
                %>
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                if (ValidaDatosGenerales())
                    if (ValidaOtros())
                        return true;

                return false;
            }
        
            function ValidaDatosGenerales(){
                //var tipoCli[] = document.getElementById('rdTipoCli');
                
                if (document.frmNuevoPro.rdTipoPro[0].checked){
                    var razonProv = document.getElementById('razonProv');
                    if (razonProv.value == ''){
                        razonProv.focus();
                        MostrarMensaje('El campo Razón Social del Proveedor está vacío');
                        return false;
                    }
                    
                    var rfcPro = document.getElementById('rfcPro');
                    if (rfcPro.value == ''){
                        rfcPro.focus();
                        MostrarMensaje('El campo RFC del Proveedore está vacío');
                        return false;
                    }
                    
                    var nombreRep = document.getElementById('nombreRepr');
                    var paternoRep = document.getElementById('paternoRepr');
                    var maternoRep = document.getElementById('maternoRepr');
                    if ((nombreRep.value != '' && paternoRep.value == '') ||
                        (paternoRep.value != '' && nombreRep.value == '')
                        || (maternoRep.value != '' && (paternoRep.value == '' || nombreRep.value == ''))){
                            nombreRep.focus();
                            MostrarMensaje('El Nombre del Representante Legal está incompleto');
                            return false;
                    }
                    
                    /*
                    var nombreRep = document.getElementById('nombreRepr');
                    if (nombreRep.value == ''){
                        Mensaje('El campo Nombre del Representante está vacío');
                        ClickPestana(1,2);
                        nombreRep.focus();
                        return false;
                    }

                    var paternoRep = document.getElementById('paternoRepr');
                    if (paternoRep.value == ''){
                        Mensaje('El campo Ap. Paterno del Representante está vacío');
                        ClickPestana(1,2);
                        paternoRep.focus();
                        return false;
                    }

                    var maternoRep = document.getElementById('maternoRepr');
                    if (maternoRep.value == ''){
                        Mensaje('El campo Ap. Materno del Representante está vacío');
                        ClickPestana(1,2);
                        maternoRep.focus();
                        return false;
                    }*/
                }
                else {
                    var rfcPro = document.getElementById('rfcProFis');
                    if (rfcPro.value == ''){
                        rfcPro.focus();
                        MostrarMensaje('El campo RFC del Proveedor está vacío');
                        return false;
                    }

                    var nombreRep = document.getElementById('nombreReprFis');
                    if (nombreRep.value == ''){
                        nombreRep.focus();
                        MostrarMensaje('El campo Nombre del Representante está vacío');
                        return false;
                    }

                    var paternoRep = document.getElementById('paternoReprFis');
                    if (paternoRep.value == ''){
                        paternoRep.focus();
                        MostrarMensaje('El campo Ap. Paterno del Representante está vacío');
                        return false;
                    }
                    /*
                    var maternoRep = document.getElementById('maternoReprFis');
                    if (maternoRep.value == ''){
                        Mensaje('El campo Ap. Materno del Representante está vacío');
                        ClickPestana(1,2);
                        maternoRep.focus();
                        return false;
                    }
                    */
                }
                
        
                var callePro = document.getElementById('callePro');
                if (callePro.value == ''){
                    callePro.focus();
                    MostrarMensaje('El campo Calle y Número del Proveedor está vacío');
                    return false;
                }
                
                var colPro = document.getElementById('coloniaPro');
                if (colPro.value == ''){
                    colPro.focus();
                    MostrarMensaje('El campo Colonia del Proveedor está vacío');
                    return false;
                }
                
                var edoPro = document.getElementById('estadoPro');
                if (edoPro.value == '0'){
                    edoPro.focus();
                    MostrarMensaje('El campo Estado del Cliente no ha sido establecido');
                    return false;
                }
                
                var pobPro = document.getElementById('poblacionPro');
                if (pobPro.value == '0'){
                    pobPro.focus();
                    MostrarMensaje('El campo Población del Proveedor no ha sido establecido');
                    return false;
                }
                                
                return true;
            }
            
            function ValidaOtros(){
                /*var agente = document.getElementById('agente');
                if (agente.value=='0'){
                    Mensaje('El campo Agente no ha sido establecido');
                    ClickPestana(2,2);
                    agente.focus();
                    return false;
                }
                
                var ruta = document.getElementById('ruta');
                if (ruta.value=='0'){
                    Mensaje('El campo Ruta no ha sido establecido');
                    ClickPestana(2,2);
                    ruta.focus();
                    return false;
                }
                
                var fech = document.getElementById('fechaAlta');
                if (fech.value==''){
                    Mensaje('El campo Fecha Alta no ha sido establecida');
                    ClickPestana(2,2);
                    fech.focus();
                    return false;
                }
                
                var desc1 = document.getElementById('descto1');
                if (desc1.value==''){
                    Mensaje('El campo Descuento 1 está vacío');
                    ClickPestana(2,2);
                    desc1.focus();
                    return false;
                }
                
                var desc2 = document.getElementById('descto2');
                if (desc2.value==''){
                    Mensaje('El campo Descuento 2 está vacío');
                    ClickPestana(2,2);
                    desc2.focus();
                    return false;
                }
                
                var desc3 = document.getElementById('descto3');
                if (desc3.value==''){
                    Mensaje('El campo Descuento 3 está vacío');
                    ClickPestana(2,2);
                    desc3.focus();
                    return false;
                }
                                
                var plazo = document.getElementById('plazo');
                if (plazo.value==''){
                    Mensaje('El campo Plazo del Crédito está vacío');
                    ClickPestana(2,2);
                    plazo.focus();
                    return false;
                }
                */
                return true;
            }

        </script>
    </body>
</html>