<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo Producto";
    String imagen = "productosB.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Producto";
        imagen = "productosC.png";
    }
    String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
    List<Sucursal> sucus = (List<Sucursal>)datosS.get("sucursales");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <!--<link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />-->
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <!--<link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>-->
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
            $( "#fechauc" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechauv" ).datepicker({
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
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PRODUCTOS
                    </div>
                    <div class="bigtitulo" align="left">
                        <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoPro" name="frmNuevoPro" action="<%=CONTROLLER%>/Gestionar/Productos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="80%" align="center">
                                <tr>
                                    <td width="100%" valign="top" align="center">
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Datos Generales</a></li>
                                                <!--<li><a href="#tabs-2">Impuestos y Stock</a></li>-->
                                                <li><a href="#tabs-2">Costos, Precios y Descuentos</a></li>
                                                <li><a href="#tabs-3">Otros</a></li>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestdatosgenprod.jsp"%>
                                            </div>
                                            <%--<div id="tabs-2">
                                                <%@include file="pestimpstock.jsp"%>
                                            </div>--%>
                                            <div id="tabs-2">
                                                <%@include file="pestpreciosdesc.jsp" %>
                                            </div>
                                            <div id="tabs-3">
                                                <%@include file="pestotros.jsp" %>
                                            </div>
                                        </div>                                        
                                        <%--
                                        <div class="cajamenu2">
                                            <ul id="pest">
                                                <%
                                                String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
                                                %>
                                                <li><a id="pest1" href="javascript: ClickPestana(1,4)" class="<%if (pestaña.equals("1")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Datos Generales</span></a>
                                                </li>
                                                <li><a id="pest2" href="javascript: ClickPestana(2,4)" class="<%if (pestaña.equals("2")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Impuestos y Stock</span></a>
                                                </li>
                                                <li><a id="pest3" href="javascript: ClickPestana(3,4)" class="<%if (pestaña.equals("3")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Costos, Precios y Descuentos</span></a>
                                                </li>
                                                <li><a id="pest4" href="javascript: ClickPestana(4,4)" class="<%if (pestaña.equals("4")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Otros</span></a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div id="cajahoja2">
                                            <div style="height: 10px"></div>
                                            <div id="pest1cont" style="display: <%if (pestaña.equals("1")){%>''<%}else{%>none<%}%>" align="center">
                                                <%@include file="pestdatosgenprod.jsp"%>
                                            </div>
                                            <div id="pest2cont" style="display: <%if (pestaña.equals("2")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestimpstock.jsp"%>
                                            </div>                                
                                            <div id="pest3cont" style="display: <%if (pestaña.equals("3")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestpreciosdesc.jsp" %>
                                            </div>                                
                                            <div id="pest4cont" style="display: <%if (pestaña.equals("4")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestotros.jsp" %>
                                            </div>                                
                                        </div><!--cajahoja2-->
                                        --%>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%" align="center">
                                <tr>
                                    <td width="100%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar Producto">
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
                }if (datosS.get("accion").toString().equals("editar")){
                    for (int i=0; i < sucus.size(); i++){
                        Sucursal su = sucus.get(i);
                    %>
                        CalculaPrecios('<%=su.getId()%>');
                    <%}
                }
                %>
                var clave = document.getElementById('clave');
                clave.focus();
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
        
            function ClickPestana(numpest){
                $( "#tabs" ).tabs({ active: numpest-1 });
                /*
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
                */
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoPro');
                frm.paginaSig.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoPro');
                    frm.paginaSig.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
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
                if (ValidaDatosGenerales())
                    //if (ValidaImpuestos())
                        if (ValidaPrecios())
                            return true;

                return false;
            }
            
            function ValidaDatosGenerales(){
                
                var clave = document.getElementById('clave');
                if (clave.value == ''){
                    MostrarMensaje('El campo Clave del Producto está vacío');
                    /*var mens = 'El campo Clave del Producto está vacío';
                    $( "#dialog-message" ).dialog( "open" );*/
                    ClickPestana(1);
                    //clave.focus();
                    return false;
                }
                                
                var descrip = document.getElementById('descripcion');
                if (descrip.value == ''){
                    MostrarMensaje('El campo Descripción del Producto está vacío');
                    ClickPestana(1);
                    //descrip.focus();
                    return false;
                }
                
                var marca = document.getElementById('marca');
                if (marca.value == ''){
                    MostrarMensaje('La Marca del Producto no ha sido establecida');
                    ClickPestana(1);
                    //marca.focus();
                    return false;
                }

                var cat = document.getElementById('categoria');
                if (cat.value == ''){
                    MostrarMensaje('La Categoría del Producto no ha sido establecida');
                    ClickPestana(1);
                    //cat.focus();
                    return false;
                }
                
                var unidad = document.getElementById('unidad');
                if (unidad.value == ''){
                    MostrarMensaje('La Unidad Mínima del Producto no ha sido establecida');
                    ClickPestana(1);
                    //unidad.focus();
                    return false;
                }

                var unidade = document.getElementById('unidademp');
                if (unidade.value == ''){
                    MostrarMensaje('La Unidad de Empaque del Producto no ha sido establecida');
                    ClickPestana(1);
                    //unidade.focus();
                    return false;
                }

                var factor = document.getElementById('valor');
                if (factor.value == ''){
                    MostrarMensaje('Las Piezas de Empaque del Producto no ha sido establecida');
                    ClickPestana(1);
                    //factor.focus();
                    return false;
                }

                var tipo = document.getElementById('tipo');
                if (tipo.value == ''){
                    MostrarMensaje('El Tipo de Producto no ha sido establecido');
                    ClickPestana(1);
                    //tipo.focus();
                    return false;
                }

                var prov = document.getElementById('proveedor');
                if (prov.value == ''){
                    MostrarMensaje('El Proveedor del Producto no ha sido establecido');
                    ClickPestana(1);
                    //prov.focus();
                    return false;
                }

                var serv = document.getElementById('servicio');
                if (serv.value == ''){
                    MostrarMensaje('El Servicio del Producto no ha sido establecido');
                    ClickPestana(1);
                    //serv.focus();
                    return false;
                }
                /*
                var peso = document.getElementById('peso');
                if (peso.value == ''){
                    Mensaje('El Peso del Producto está vacío');
                    ClickPestana(1,4);
                    peso.focus();
                    return false;
                }
                */

                /*var cult = document.getElementById('costoultimo');
                if (cult.value == ''){
                    MostrarMensaje('El Costo Último del Producto está vacío');
                    ClickPestana(1,4);
                    cult.focus();
                    return false;
                }*/
                /*
                var cprom = document.getElementById('costopromedio');
                if (cprom.value == ''){
                    Mensaje('El Costo Promedio del Producto está vacío');
                    ClickPestana(1,4);
                    cprom.focus();
                    return false;
                }
                
                var cact = document.getElementById('costoactual');
                if (cact.value == ''){
                    Mensaje('El Costo Actualizado del Producto está vacío');
                    ClickPestana(1,4);
                    cact.focus();
                    return false;
                }
                */
                return true;
            }
            
            function ValidaImpuestos(){
                var iep = document.getElementById('iep');
                if (iep.value == ''){
                    MostrarMensaje('El IEP del Producto está vacío');
                    ClickPestana(2);
                    //iep.focus();
                    return false;
                }

                var ivan = document.getElementById('ivan');
                if (ivan.value == ''){
                    MostrarMensaje('El IVA Nacional del Producto está vacío');
                    ClickPestana(2);
                    //ivan.focus();
                    return false;
                }

                var ivae = document.getElementById('ivae');
                if (ivae.value == ''){
                    MostrarMensaje('El IVA Extranjero del Producto está vacío');
                    ClickPestana(2);
                    //ivae.focus();
                    return false;
                }

                var stockmax = document.getElementById('stockmax');
                if (stockmax.value == ''){
                    MostrarMensaje('El Stock Máximo del Producto está vacío');
                    ClickPestana(2);
                    //stockmax.focus();
                    return false;
                }

                var stockmin = document.getElementById('stockmin');
                if (stockmin.value == ''){
                    MostrarMensaje('El Stock Mínimo del Producto está vacío');
                    ClickPestana(2);
                    //stockmin.focus();
                    return false;
                }
        
                return true;
            }

            function ValidaPrecios(){
                //valida costos
                <%for (int i=0; i < sucus.size(); i++){%>
                     var costo = document.getElementById('costo<%=i%>');
                     if (costo.value == ''){
                         MostrarMensaje('No ha ingresado todos los costos');
                         ClickPestana(2);
                         return false;
                     }
                <%}%>
                    
                //valida los factores de precios
                <%for (int i=0; i < sucus.size(); i++){%>
                for (i=1; i <=5; i++){
                    var precio = document.getElementById('precio'+i+<%=i%>);
                    if (precio.value == ''){
                        MostrarMensaje('No ha ingresados todos los factores de precio');
                        ClickPestana(2);
                        return false;
                    }
                }
                <%}%>
                
                for (i=1; i <=5; i++){
                    var descto = document.getElementById('descto'+i);
                    if (descto.value == ''){
                        MostrarMensaje('El Descuento '+i+' del Producto está vacío');
                        ClickPestana(2);
                        return false;
                    }
                }

                var descmax = document.getElementById('descmax');
                if (descmax.value == ''){
                    MostrarMensaje('El Descuento Máximo del Producto está vacío');
                    ClickPestana(2);
                    return false;
                }

                return true;                
            }

        </script>
    </body>
</html>