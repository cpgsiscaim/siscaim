<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.text.SimpleDateFormat, java.util.List, java.util.ArrayList, java.util.HashMap, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato,
        Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Catalogos.Estado, Modelo.Entidades.Catalogos.Municipio, Modelo.Entidades.Ruta,
        Modelo.Entidades.Direccion, Modelo.Entidades.Catalogos.FechasEntrega"%>
<%@page import="Modelo.Entidades.Catalogos.Titulo, Modelo.Entidades.Catalogos.TipoMedio, Modelo.Entidades.ContactoCT, Modelo.Entidades.PersonaMedio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliSel = (Cliente)datosS.get("clienteSel");
    Contrato conSel = (Contrato)datosS.get("editarContrato");
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String datosfis = "none";
    if (conSel.getFacturarCT()==1)
        datosfis = "";
    String titulo = "NUEVO CENTRO DE TRABAJO";
    String imagen = "centrostrabB.png";
    int cp = 0;
    String nombre = "", personal = "", dias = Integer.toString(conSel.getDiasentrega()), topes = "", topei = "0", observacion = "", rfc = "", razonsoc = "", calle = "", colonia = "", sCp = "";
    Municipio munActual = null;
    Estado edoActual = null;
    Ruta rutActual = null;
    Direccion direc = null;
    String callect = "", colct = "", scpct = "";
    int surtidoexterno = 0, configent = 0, tipoent = 0;
    Sucursal sucalt = new Sucursal();
    Ruta rutaalt = new Ruta();
    CentroDeTrabajo ct = new CentroDeTrabajo();
    List<Titulo> titulos = (List<Titulo>)datosS.get("titulos");
    List<TipoMedio> tiposmedios = (List<TipoMedio>)datosS.get("tiposmedios");
    List<ContactoCT> contactos = new ArrayList<ContactoCT>();
    List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
    
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR CENTRO DE TRABAJO";
        imagen = "centrostrabC.png";
        ct = (CentroDeTrabajo)datosS.get("centro");
        nombre = ct.getNombre();
        direc = ct.getDireccion();
        personal = Float.toString(ct.getPersonal());
        dias = Integer.toString(ct.getDiasEntrega());
        topes = Float.toString(ct.getTopeSueldos());
        topei = Float.toString(ct.getTopeInsumos());
        observacion = ct.getObservaciones();
        rutActual = ct.getRuta();
        if (conSel.getFacturarCT()==1){
            rfc = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getRfc():"";
            razonsoc = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getRazonsocial():"";
            calle = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getDireccion().getCalle():"";
            colonia = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getDireccion().getColonia():"";
            cp = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getDireccion().getCp():0;
            if (cp!=0)
                sCp = Integer.toString(ct.getDatosfiscales().getDireccion().getCp());            
            munActual = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getDireccion().getPoblacion():new Municipio();
            edoActual = ct.getDatosfiscales()!=null?ct.getDatosfiscales().getDireccion().getPoblacion().getEstado(): new Estado();
        }
        surtidoexterno = ct.getSurtidoexterno();
        configent = ct.getConfigentrega();
        tipoent = ct.getTipoentrega();
        if (surtidoexterno==1){
            sucalt = ct.getSucalterna();
            rutaalt = ct.getRutaalterna();
        }
        contactos = (List<ContactoCT>)datosS.get("contactos");
        medioscon = (List<PersonaMedio>)datosS.get("medioscon");
        
    }
    int disconfcon = 0, disconfper = 0, chkconfcon = 0, chkconfper = 0, chktipodias = 0, chktipofechas = 0;
    if (conSel.getTipoentrega()==2){
        disconfper = 1;
        chkconfper = 1;
        if (ct.getTipoentrega()==2 || ct.getTipoentrega()==0){
            chktipodias = 1;
        } else {
            chktipofechas = 1;
        }
    } else {
        disconfcon = 1;
        disconfper = 1;
        if (ct.getConfigentrega()==2 || ct.getConfigentrega()==0){
            chkconfcon = 1;
        } else {
            chkconfper = 1;
            if (ct.getTipoentrega()==0)
                chktipodias = 1;
            else
                chktipofechas = 1;
        }
    }
    String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaesp" ).datepicker({
            changeMonth: true,
            changeYear: true
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
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="50" height="40">
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
                    </div>
                    <div class="subtitulo" align="left">
                        <%=titulo%>
                    </div>                    
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoCT" name="frmNuevoCT" action="<%=CONTROLLER%>/Gestionar/CentrosTrab" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="configentrega" name="configentrega" type="hidden" value=""/>
            <input id="tipoentrega" name="tipoentrega" type="hidden" value=""/>
            <input id="listafechas" name="listafechas" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="90%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Datos</a></li>
                                                <%if (datosS.get("accion").toString().equals("editar")){%>
                                                <li><a href="#tabs-2">Contactos</a></li>
                                                <%}%>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestcentro.jsp"%>
                                            </div>
                                            <%if (datosS.get("accion").toString().equals("editar")){%>
                                            <div id="tabs-2">
                                                <%@include file="pestcontactos.jsp" %>
                                            </div>
                                            <%}%>
                                        </div>                                        
                                    </td>
                                </tr>
                            </table>
                            <hr>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar Centro de Trabajo">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar cambios del contrato">
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
                if (datosS.get("accion").toString().equals("editar")){
                    //ct = (CentroDeTrabajo)datosS.get("centro");
                    if (ct.getSurtidoexterno()==1){
                    %>
                        var divrutanor = document.getElementById('rutanormal');
                        var divsurext = document.getElementById('divsurext');
                        divrutanor.style.display = 'none';
                        divsurext.style.display = '';
                        CargaRutasExt('<%=ct.getSucalterna().getId()%>');
                        SeleccionaRutaExt('<%=ct.getRutaalterna().getId()%>');
                    <%
                    }
                }
                %>
                <%
                if (conSel.getTipoentrega()==2){
                %>
                    ChecaConfigEntrega(1);
                    <%if (datosS.get("accion").toString().equals("nuevo") || 
                         (datosS.get("accion").toString().equals("editar") && tipoent==2)){%>
                        ChecaTipoEntrega(0);
                    <%} else if (datosS.get("accion").toString().equals("editar") && tipoent!=2){%>
                        ChecaTipoEntrega('<%=tipoent%>');
                    <%}%>
                <%} else if (datosS.get("accion").toString().equals("nuevo") ||
                         (datosS.get("accion").toString().equals("editar") && tipoent==2)){%>
                    ChecaConfigEntrega(0);
                <%} else if (datosS.get("accion").toString().equals("editar") && tipoent!=2){%>
                    ChecaConfigEntrega('<%=configent%>');
                    ChecaTipoEntrega('<%=tipoent%>');
                <%}%>
                var nombre = document.getElementById('nombre');
                nombre.focus();
                     var btnBajaContac = document.getElementById('btnBajaContac');
                     var btnEditarContac = document.getElementById('btnEditarContac');
                     btnEditarContac.style.display = 'none';
                     btnBajaContac.style.display = 'none';
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoCT');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoCT');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '4';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '2';
                <%
                    }
                %>
                    frm.submit();
                }
                
            }
            
            function ValidaRequeridos(){
                var nombre = document.getElementById('nombre');
                if (nombre.value == ''){
                    Mensaje('El campo Nombre del Centro de Trabajo está vacío');
                    nombre.focus();
                    return false;
                }
                
                var callect = document.getElementById('callect');
                var colct = document.getElementById('coloniact');
                var edoct = document.getElementById('estadoct');
                var munct = document.getElementById('poblacionct');
                if (callect.value != '' || colct.value != '' || edoct.value != '' || munct.value != ''){
                    if (callect.value == '' || colct.value == '' || edoct.value == '' || munct.value == ''){
                        Mensaje('El domicilio no está completo, por favor complete los campos marcados con *');
                        return false;
                    }
                }
                var personal = document.getElementById('personal');
                if (personal.value == ''){
                    Mensaje('El campo Personal del Centro de Trabajo está vacío');
                    personal.focus();
                    return false;                    
                }

                var topes = document.getElementById('topes');
                if (topes.value == ''){
                    Mensaje('El campo Tope de Sueldos del Centro de Trabajo está vacío');
                    topes.focus();
                    return false;                    
                }
                                
                var topei = document.getElementById('topei');
                if (topei.value == ''){
                    Mensaje('El campo Tope de Insumos del Centro de Trabajo está vacío');
                    topei.focus();
                    return false;                    
                }
                
                var surext = document.getElementById('surtidoexterno');
                if (!surext.checked){
                    var ruta = document.getElementById('ruta');
                    if (ruta.value == ''){
                        Mensaje('El campo Ruta no ha sido establecido');
                        return false;
                    }
                } else {
                    var sucext = document.getElementById('sucursalext');
                    if (sucext.value == ''){
                        Mensaje('No ha definido la Sucursal desde donde se surtirá el CT');
                        return false;
                    }
                    
                    var rutext = document.getElementById('rutaext');
                    if (rutext.value == ''){
                        Mensaje('No ha definido la Ruta desde donde se surtirá el CT');
                        return false;
                    }
                }
                <%
                if (conSel.getFacturarCT()==1){
                %>
                    var rfc = document.getElementById('rfc');
                    if (rfc.value == ''){
                        Mensaje('El campo RFC del Centro de Trabajo está vacío');
                        rfc.focus();
                        return false;                    
                    }
                        
                    var razon = document.getElementById('razonsoc');
                    if (razon.value == ''){
                        Mensaje('El campo Razón Social del Centro de Trabajo está vacío');
                        razon.focus();
                        return false;                    
                    }
                    
                    var calle = document.getElementById('calle');
                    if (calle.value == ''){
                        Mensaje('El campo Calle del Centro de Trabajo está vacío');
                        calle.focus();
                        return false;                    
                    }
                    
                    var col = document.getElementById('colonia');
                    if (col.value == ''){
                        Mensaje('El campo Colonia del Centro de Trabajo está vacío');
                        col.focus();
                        return false;                    
                    }

                    var cp = document.getElementById('cp');
                    if (cp.value == ''){
                        Mensaje('El campo Código Postal del Centro de Trabajo está vacío');
                        cp.focus();
                        return false;                    
                    }
                    
                    var col = document.getElementById('colonia');
                    if (col.value == ''){
                        Mensaje('El campo Colonia del Centro de Trabajo está vacío');
                        col.focus();
                        return false;                    
                    }

                    var edo = document.getElementById('estado');
                    if (edo.value == '0'){
                        Mensaje('El campo Estado del Centro de Trabajo no ha sido establecido');
                        edo.focus();
                        return false;
                    }

                    var pob = document.getElementById('poblacion');
                    if (pob.value == ''){
                        Mensaje('El campo Población del Centro de Trabajo no ha sido establecido');
                        pob.focus();
                        return false;
                    }
                <%
                }
                %>
                var confent = document.getElementById('configentrega');
                var tipoent = document.getElementById('tipoentrega');
                
                if (confent.value == ''){
                    Mensaje('No ha definido la configuración de las entregas');
                    return false;
                } else if (confent.value == '1'){
                    if (tipoent.value==''){
                        Mensaje('No ha definido el tipo de entrega');
                        return false;
                    }

                    if (tipoent.value=='0'){
                        var dias = document.getElementById('numdias');
                        if (dias.value == ''){
                            Mensaje('No ha indicado el número de días');
                            dias.focus();
                            return false;
                        } else {
                            ndias = parseInt(dias.value);
                            if (isNaN(ndias)){
                                Mensaje('El número de días especificado no es válido');
                                dias.focus();
                                return false;
                            }

                            if (ndias==0){
                                Mensaje('El número de días especificado no es válido');
                                dias.focus();
                                return false;
                            }
                        }
                    } else if (tipoent.value=='1'){
                        var lsfechas = document.getElementById('lsfechas');
                        if (lsfechas.length==0){
                            Mensaje('No especificado las fechas de entrega');
                            return false;
                        }

                        var listafe = document.getElementById('listafechas');
                        listafe.value = '';
                        for (i=0; i < lsfechas.length; i++){
                            if (listafe.value == '')
                                listafe.value = lsfechas.options[i].value;
                            else
                                listafe.value += ','+lsfechas.options[i].value;
                        }
                    }
                }
                
                return true;
            }

            function CargaMunicipios(estado){
                var poblacion = document.getElementById("poblacion");
                poblacion.length = 0;
                poblacion.options[0] = new Option('Elija la Población...','');
                k=1;
            <%
                for (int i=0; i < estados.size(); i++){
                    Estado edo = (Estado) estados.get(i);
                %>
                    if (<%=edo.getIdestado()%> == estado){
                    <%
                        List<Municipio> munis = edo.getMunicipios();
                        for (int j=0; j < munis.size(); j++){
                            Municipio mun = munis.get(j);
                        %>
                            poblacion.options[k] = new Option('<%=mun.getMunicipio()%>','<%=mun.getIdmunicipio()%>');
                            k++;
                        <%
                        }
                    %>
                    }
                <%
                }
            %>
            }

            function CargaMunicipiosCt(estado){
                var poblacion = document.getElementById("poblacionct");
                poblacion.length = 0;
                poblacion.options[0] = new Option('Elija la Población...','');
                k=1;
            <%
                for (int i=0; i < estados.size(); i++){
                    Estado edo = (Estado) estados.get(i);
                %>
                    if (<%=edo.getIdestado()%> == estado){
                    <%
                        List<Municipio> munis = edo.getMunicipios();
                        for (int j=0; j < munis.size(); j++){
                            Municipio mun = munis.get(j);
                        %>
                            poblacion.options[k] = new Option('<%=mun.getMunicipio()%>','<%=mun.getIdmunicipio()%>');
                            k++;
                        <%
                        }
                    %>
                    }
                <%
                }
            %>
            }

            function SurtidoExterno(){
                var surext = document.getElementById('surtidoexterno');
                var divrutanorm = document.getElementById('rutanormal');
                var divsurext = document.getElementById('divsurext');
                if (surext.checked){
                    divsurext.style.display = '';
                    divrutanorm.style.display = 'none';
                } else {
                    divsurext.style.display = 'none';
                    divrutanorm.style.display = '';
                }
            }
            
            function CargaRutasExt(suc){
                var rutaext = document.getElementById('rutaext');
                rutaext.length = 0;
                rutaext.options[0] = new Option('Elija la Ruta...','');
                if (suc != ''){
                    k=1;
                    <%
                    List<Ruta> rutassucs = (List<Ruta>)datosS.get("rutassucs");
                    for (int i=0; i < rutassucs.size(); i++){
                        Ruta rt = rutassucs.get(i);
                    %>
                        if (suc == '<%=rt.getSucursal().getId()%>'){
                            rutaext.options[k] = new Option('<%=rt.getDescripcion()%>','<%=rt.getId()%>');
                            k++;
                        }
                    <%
                    }
                    %>
                }
            }
            
            function SeleccionaRutaExt(ruta){
                var rutaext = document.getElementById('rutaext');
                if (rutaext.length>1){
                    for (i=1; i < rutaext.length; i++){
                        if (rutaext.options[i].value == ruta){
                            rutaext.options[i].selected = true;
                            break;
                        }
                    }
                }
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
            
            function ChecaConfigEntrega(config){
                var opcentrega = document.getElementById('opcentrega');
                var conent = document.getElementById('configentrega');
                conent.value = config;
                if (config==0){
                    opcentrega.style.display = 'none';
                }else{
                    opcentrega.style.display = '';
                    <%if (conSel.getTipoentrega()==0 || conSel.getTipoentrega()==2){%>
                         ChecaTipoEntrega(0);
                    <%} else if (conSel.getTipoentrega()==1){%>
                        ChecaTipoEntrega(1);
                    <%}%>
                }
            }
            
            function ChecaTipoEntrega(tipo){
                var numd = document.getElementById('numdias');
                var dvfech = document.getElementById('divfechas');
                var tipoent = document.getElementById('tipoentrega');
                tipoent.value = tipo;
                if (tipo==0){
                    numd.disabled = false;
                    numd.focus();
                    dvfech.style.display = 'none';
                } else {
                    numd.disabled = true;
                    dvfech.style.display = '';
                }
            }
            
            function AgregaFecha(){
                var fechaesp = document.getElementById('fechascon');
                if (fechaesp.length==0){
                    Mensaje('Ya ha agregado todas las fechas disponibles');
                    return;
                }
                
                if (fechaesp.value == ''){
                    Mensaje('Debe especificar una fecha');
                    return;
                }
                

                var lsfechas = document.getElementById('lsfechas');
                k = lsfechas.length;
                if (k>0){
                    //checar si la fecha ya existe
                    for (i=0; i < lsfechas.length; i++){
                        if (lsfechas.options[i].value == fechaesp.value){
                            Mensaje('La fecha ya fue agregada');
                            return;
                        }
                    }
                }
                
                //alert(fechaesp.value);
                var xMonth=fechaesp.value.substring(3, 5);  
                var xDay=fechaesp.value.substring(0, 2);  
                var xYear=fechaesp.value.substring(6,10);
                fechasql = xYear+'-'+xMonth+'-'+xDay;
                
                lsfechas.options[k] = new Option(fechaesp.value, fechasql);
                //eliminar la fecha agregada del combo
                for (i=0; i < fechaesp.length; i++){
                    if (fechaesp.options[i].selected)
                        fechaesp.remove(i);
                }
            }

            function QuitarFechas(){
                var lsfechas = document.getElementById('lsfechas');
                if (lsfechas.length==0){
                    Mensaje('La lista de fechas está vacía');
                    return;
                }
                sel=0;
                indices = '';
                for (i=0; i<lsfechas.length; i++){
                    if (lsfechas.options[i].selected){
                        if (indices == '')
                            indices += lsfechas.options[i].value;
                        else
                            indices += ','+lsfechas.options[i].value;
                        sel++;
                    }
                }
                if (sel==0){
                    Mensaje('Debe seleccionar al menos una fecha');
                    return;
                }
                tokens = indices.split(',');
                for (i=0; i < tokens.length; i++){
                    valor = tokens[i];
                    for (j=0; j < lsfechas.length; j++){
                        if (lsfechas.options[j].value==valor)
                            lsfechas.remove(j);
                    }
                    //agregarla al combo de fechas
                    var xMonth=valor.substring(5, 7);  
                    var xDay=valor.substring(8, 10);  
                    var xYear=valor.substring(0,4);
                    fechanor = xDay+'-'+xMonth+'-'+xYear;
                    var fechaesp = document.getElementById('fechascon');
                    fechaesp.options[fechaesp.length] = new Option(fechanor, fechanor);
                }
            }
            
            function AgregaFecha2(){
                var fechai = '<%=conSel.getFechaIni().toString()%>';
                var fechaf = '<%=conSel.getFechaFin().toString()%>';
                
                var fechaesp = document.getElementById('fechaesp');
                //var rgfechaesp = document.getElementById('rgFechaEsp');
                if (fechaesp.value == ''){
                    MostrarMensaje('Debe especificar una fecha');
                    return;
                }

                d = fechaesp.value.substr(0,2);
                m = fechaesp.value.substr(3,2);
                y = fechaesp.value.substr(6,4);
                fesp=y+'-'+m+'-'+d;

                //validar que la fecha este dentro del periodo del contrato
                if (ComparaFechas(fechai, fesp)==1 || ComparaFechas(fechaf, fesp)==0){
                    MostrarMensaje('La fecha especificada está fuera del período del contrato');
                    return;
                }

                var lsfechas = document.getElementById('lsfechas');
                k = lsfechas.length;
                if (k>0){
                    //checar si la fecha ya existe
                    for (i=0; i < lsfechas.length; i++){
                        if (lsfechas.options[i].value == fechaesp.value){
                            MostrarMensaje('La fecha ya fue agregada');
                            return;
                        }
                    }
                }
                lsfechas.options[k] = new Option(fechaesp.value,fechaesp.value);
                fechaesp.value = '';
            }

            function QuitarFechas2(){
                var lsfechas = document.getElementById('lsfechas');
                if (lsfechas.length==0){
                    MostrarMensaje('La lista de fechas está vacía');
                    return;
                }
                sel=0;
                indices = '';
                for (i=0; i<lsfechas.length; i++){
                    if (lsfechas.options[i].selected){
                        if (indices == '')
                            indices += lsfechas.options[i].value;
                        else
                            indices += ','+lsfechas.options[i].value;
                        sel++;
                    }
                }
                if (sel==0){
                    MostrarMensaje('Debe seleccionar al menos una fecha');
                    return;
                }
                tokens = indices.split(',');
                for (i=0; i < tokens.length; i++){
                    valor = tokens[i];
                    for (j=0; j < lsfechas.length; j++){
                        if (lsfechas.options[j].value==valor)
                            lsfechas.remove(j);
                    }
                }
            }

            function ComparaFechas(f1, f2){
                var xMonth=f1.substring(5, 7);  
                var xDay=f1.substring(8, 10);  
                var xYear=f1.substring(0,4);
                var yMonth=f2.substring(5, 7);  
                var yDay=f2.substring(8, 10);  
                var yYear=f2.substring(0,4);
                if (xYear> yYear)  
                {  
                    return 1;  
                }  
                else  
                {  
                    if (xYear == yYear)  
                    {   
                        if (xMonth> yMonth)  
                        {  
                            return 1;  
                        }  
                        else  
                        {   
                            if (xMonth == yMonth)  
                            {  
                                if (xDay> yDay)  
                                    return 1;  
                                else {
                                    if (xDay == yDay)
                                        return -1;
                                    else
                                        return 0;
                                }
                            }  
                            else  
                                return 0;  
                        }  
                    }  
                    else  
                        return 0;  
                }
            }
            
        </script>
    </body>
</html>