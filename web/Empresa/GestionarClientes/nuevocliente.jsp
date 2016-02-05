<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa"%>
<%@page import="Modelo.Entidades.Catalogos.Titulo, Modelo.Entidades.Catalogos.TipoMedio, Modelo.Entidades.ContactoCliente"%>
<%@page import="Modelo.Entidades.PersonaMedio"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String titulo = "NUEVO";
    String imagen = "clientesB.png";
    List<Titulo> titulos = (List<Titulo>)datosS.get("titulos");
    List<TipoMedio> tiposmedios = (List<TipoMedio>)datosS.get("tiposmedios");
    List<ContactoCliente> contactos = new ArrayList<ContactoCliente>();
    List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR";
        imagen = "clientesC.png";
        contactos = (List<ContactoCliente>)datosS.get("contactos");
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
        
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>

        <%--
        <div id="dialog-contacto" title="SISCAIM - Contactos">
            <table width="100%">
                <tr>
                    <td width="100%" align="left">
                        <p id="contitulo" class="titulo"></p>
                        <input id="conaccion" type="hidden" value=""/>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="34%">
                                    <span class="etiquetaB">Nombre:</span><br>
                                    <input id="nombreCon" name="nombreCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="30"/>
                                </td>
                                <td width="34%">
                                    <span class="etiquetaB">Paterno:</span><br>
                                    <input id="paternoCon" name="paternoCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="30"/>
                                </td>
                                <td width="33%">
                                    <span class="etiquetaB">Materno:</span><br>
                                    <input id="maternoCon" name="maternoCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="30"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="25%">
                                    <span class="etiquetaB">Sexo:</span><br>
                                    <select id="sexoCon" name="sexoCon" class="combo" style="width: 150px">
                                        <option value="F">FEMENINO</option>
                                        <option value="M">MASCULINO</option>
                                    </select>
                                </td>
                                <td width="25%">
                                    <span class="etiquetaB">Titulo:</span><br>
                                    <select id="tituloCon" name="tituloCon" class="combo" style="width: 150px">
                                        <%for (int t=0; t < titulos.size(); t++){
                                            Titulo tit = titulos.get(t);
                                        %>
                                            <option value="<%=tit.getTitulo()%>"><%=tit.getTitulo()%></option>
                                        <%}%>
                                    </select>
                                </td>
                                <td width="50%">
                                    <span class="etiquetaB">Cargo:</span><br>
                                    <input id="cargoCon" name="cargoCon" class="text" type="text" value="" style="width: 300px"
                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="35"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <span class="etiquetaB">Medios:</span>
                        <table width="100%" frame="box">
                            <tr>
                                <td width="35%" valign="top">
                                    <span class="etiquetaB">Tipo:</span><br>
                                    <select id="tipomedio" name="tipomedio" style="width:200px" class="combo" onchange="ValidaTipoMedio(this.value)">
                                        <option value="">Elija el tipo de medio...</option>
                                        <% for (int i=0; i < tiposmedios.size(); i++){
                                            TipoMedio tm = tiposmedios.get(i);
                                        %>
                                        <option value="<%=tm.getIdtipomedio()%>"><%=tm.getTipomedio()%></option>
                                        <%}%>
                                    </select>
                                </td>
                                <td width="35%" valign="top">
                                    <span class="etiquetaB">Medio:</span><br>
                                    <input id="telCon" name="telCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaNums(event)" maxlength="10"/>
                                    <input id="mail" name="mail" class="text" type="text" value="" style="width: 200px; display:none"
                                        maxlength="50"/>
                                </td>
                                <td width="30%" valign="top">
                                    <span class="etiquetaB">Extensi&oacute;n:</span><br>
                                    <input id="extCon" name="extCon" class="text" type="text" value="" style="width: 100px"
                                           maxlength="30" readonly/>
                                    <img src="/siscaim/Imagenes/Varias/mas01.png" width="25" height="25"
                                        onclick="AgregaMedio()" title="Agregar medio" onmouseover="this.style.cursor='pointer'"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="35%" valign="top">
                                    <select id="lstipos" name="lstipos" class="combo" multiple size="5" onclick="Selecciona(this)" style="width:200px"></select>
                                </td>
                                <td width="35%" valign="top">
                                    <select id="lstels" name="lstels" class="combo" multiple size="5" onclick="Selecciona(this)" style="width:200px"></select>
                                </td>
                                <td width="30%" valign="top">                                    
                                    <select id="lsexts" name="lsexts" class="combo" multiple size="5" onclick="Selecciona(this)" style="width:100px"></select>
                                    <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                        onclick="QuitarMedio()" title="Quitar los medios seleccionados" onmouseover="this.style.cursor='pointer'"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        --%>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CLIENTES - <%=titulo%>
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoCli" name="frmNuevoCli" action="<%=CONTROLLER%>/Gestionar/Clientes" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <%--<input id="tituloform" name="tituloform" type="hidden" value=""/>
            <input id="conactuales" name="conactuales" type="hidden" value=""/>
            <input id="connombres" name="connombres" type="hidden" value=""/>
            <input id="conpaternos" name="conpaternos" type="hidden" value=""/>
            <input id="conmaternos" name="conmaternos" type="hidden" value=""/>
            <input id="consexos" name="consexos" type="hidden" value=""/>
            <input id="contitulos" name="contitulos" type="hidden" value=""/>
            <input id="concargos" name="concargos" type="hidden" value=""/>
            <input id="contels" name="contels" type="hidden" value=""/>
            <input id="concels" name="concels" type="hidden" value=""/>
            <input id="conmails" name="conmails" type="hidden" value=""/>
            <input id="connuevos" name="connuevos" type="hidden" value=""/>
            <input id="conedits" name="conedits" type="hidden" value=""/>
            <input id="conbajas" name="conbajas" type="hidden" value=""/>--%>
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
                                                <%@include file="pestdatosgencli.jsp"%>
                                            </div>
                                            <div id="tabs-2">
                                                <%@include file="pestotroscli.jsp" %>
                                            </div>
                                            <%if (datosS.get("accion").toString().equals("editar")){%>
                                            <div id="tabs-3">
                                                <%@include file="pestcontactos.jsp" %>
                                            </div>
                                            <%}%>
                                        </div>                                        
                                        <%--<div class="cajamenu2">
                                            <ul id="pest">
                                                <%
                                                %>
                                                <li><a id="pest1" href="javascript: ClickPestana(1,2)" class="<%if (pestaña.equals("1")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Datos Generales</span></a>
                                                </li>
                                                <li><a id="pest2" href="javascript: ClickPestana(2,2)" class="<%if (pestaña.equals("2")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Otros</span></a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div id="cajahoja2">
                                            <div style="height: 20px"></div>
                                            <div id="pest1cont" style="display: <%if (pestaña.equals("1")){%>''<%}else{%>none<%}%>" align="center">
                                                <%@include file="pestdatosgencli.jsp" %>
                                            </div>
                                            <div id="pest2cont" style="display: <%if (pestaña.equals("2")){%>''<%}else{%>none<%}%>">
                                                <%@include file="pestotroscli.jsp"%>
                                            </div>                                
                                        </div><!--cajahoja2-->--%>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar cliente">
                                            Guardar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar cambios del cliente">
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
            function GuardaContacto(){
                //valida requeridos
                //guardar el contacto en la base de datos
            }
            
            function QuitarMedio(){
                var lstipos = document.getElementById('lstipos');
                var lstels = document.getElementById('lstels');
                var lsexts = document.getElementById('lsexts');
                var pos = lstipos.selectedIndex;
                lstipos.remove(pos);
                lstels.remove(pos);
                lsexts.remove(pos);
            }
            
            function SeleccionaX(lista){
                var lstipos = document.getElementById('lstipos');
                var lstels = document.getElementById('lstels');
                var lsexts = document.getElementById('lsexts');
                var pos = lista.selectedIndex;
                
                lstipos.selectedIndex = -1;
                lstels.selectedIndex = -1;
                lsexts.selectedIndex = -1;
                
                lstipos.options[pos].selected = true;
                lstels.options[pos].selected = true;
                lsexts.options[pos].selected = true;
            }
            
            function ValidaTipoMedio(tipo){
                var ext = document.getElementById('extCon');
                var tel = document.getElementById('telCon');
                var mail = document.getElementById('mail');
                if (tipo==1){
                    ext.readOnly = false;
                    mail.value = '';
                    mail.style.display = 'none';
                    tel.style.display = '';
                } else {
                    mail.value = '';
                    mail.style.display = 'none';
                    tel.style.display = '';
                    ext.readOnly = true;
                    ext.value='';
                    if (tipo==3){
                        mail.value = '';
                        mail.style.display = ''; 
                        tel.style.display = 'none';
                    }
                }
            }
            
            function ExisteMedio(){
                var tipo = document.getElementById('tipomedio');
                var medio = document.getElementById('telCon');
                var itipo = tipo.selectedIndex;
                if (tipo.options[itipo].value==3)
                    medio = document.getElementById('mail');
                var ext = document.getElementById('extCon');
                var lstipos = document.getElementById('lstipos');
                var lstels = document.getElementById('lstels');
                var lsexts = document.getElementById('lsexts');
                for (i=0; i < lstipos.length; i++){
                    if ((tipo.options[itipo].value == lstipos.options[i].value) &&
                            (medio.value == lstels.options[i].value)){
                        MostrarMensaje('El medio ya existe');
                        return true;
                    }
                }
                return false;
            }
            
            function AgregaMedio(){
                var tipo = document.getElementById('tipomedio');
                var itipo = tipo.selectedIndex;
                var medio = document.getElementById('telCon');
                if (tipo.options[itipo].value==3)
                    medio = document.getElementById('mail');
                var ext = document.getElementById('extCon');
                if (tipo.options[itipo].value==''){
                    MostrarMensaje('Debe elegir el tipo de medio');
                    return;
                }
                if (medio.value == ''){
                    medio.focus();
                    MostrarMensaje('Debe escribir el medio');
                    return;
                }
                
                var lstipos = document.getElementById('lstipos');
                var lstels = document.getElementById('lstels');
                var lsexts = document.getElementById('lsexts');
                if (!ExisteMedio()){
                    var pos = lstipos.length;
                    lstipos.options[pos] = new Option(tipo.options[itipo].text,tipo.options[itipo].value);
                    lstels.options[pos] = new Option(medio.value, medio.value);
                    lsexts.options[pos] = new Option(ext.value, ext.value);
                    tipo.options[0].selected = true;
                    medio.value = '';
                    ext.value = '';
                }
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
                var btnBajaContac = document.getElementById('btnBajaContac');
                var btnEditarContac = document.getElementById('btnEditarContac');
                //var btnNuevoContac = document.getElementById('btnNuevoContac');
                //btnNuevoContac.style.display = 'none';
                btnEditarContac.style.display = 'none';
                btnBajaContac.style.display = 'none';
            }

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
            
            function LimpiarInputs(){
                var nom = document.getElementById('nombreCon');
                var pat = document.getElementById('paternoCon');
                var mat = document.getElementById('maternoCon');
                var sex = document.getElementById('sexoCon');
                var tit = document.getElementById('tituloCon');
                var car = document.getElementById('cargoCon');
                var tel = document.getElementById('telCon');
                var cel = document.getElementById('celCon');
                var mail = document.getElementById('mailCon');
                var acc = document.getElementById('conaccion');
                nom.value='';
                pat.value='';
                mat.value='';
                car.value='';
                tel.value='';
                cel.value='';
                mail.value='';
                sex.options[0].selected=true;
                tit.options[0].selected=true;
                acc.value = '';
            }

            function Contacto(titulo, accion){
                var tit = document.getElementById('contitulo');
                tit.textContent = titulo;
                var accioncon = document.getElementById('conaccion');
                accioncon.value = accion;
                if (accion==1){
                    var lsCon = document.getElementById('lstContactos');
                    var sel = lsCon.selectedIndex;
                    var lsNom = document.getElementById('lstConNombres');
                    var lsPat = document.getElementById('lstConPaternos');
                    var lsMat = document.getElementById('lstConMaternos');
                    var lsSex = document.getElementById('lstConSexos');
                    var lsTit = document.getElementById('lstConTitulos');
                    var lsCar = document.getElementById('lstConCargos');
                    var lsTel = document.getElementById('lstConTels');
                    var lsCel = document.getElementById('lstConCels');
                    var lsMails = document.getElementById('lstConMails');
                    var nom = document.getElementById('nombreCon');
                    nom.value = lsNom.options[sel].value;
                    var pat = document.getElementById('paternoCon');
                    pat.value = lsPat.options[sel].value;
                    var mat = document.getElementById('maternoCon');
                    mat.value = lsMat.options[sel].value!='&'?lsMat.options[sel].value:'';
                    var sex = document.getElementById('sexoCon');
                    sex.value = lsSex.options[sel].value;
                    var tit = document.getElementById('tituloCon');
                    tit.value = lsTit.options[sel].value;
                    var car = document.getElementById('cargoCon');
                    car.value = lsCar.options[sel].value!='&'?lsCar.options[sel].value:'';
                    var tel = document.getElementById('telCon');
                    tel.value = lsTel.options[sel].value!='&'?lsTel.options[sel].value:'';
                    var cel = document.getElementById('celCon');
                    cel.value = lsCel.options[sel].value!='&'?lsCel.options[sel].value:'';
                    var mail = document.getElementById('mailCon');
                    mail.value = lsMails.options[sel].value!='&'?lsMails.options[sel].value:'';
                }
                $( "#dialog-contacto" ).dialog( "open" );
            }
            
            function AgregarContacto(){
                var lsCon = document.getElementById('lstContactos');
                var lsNom = document.getElementById('lstConNombres');
                var lsPat = document.getElementById('lstConPaternos');
                var lsMat = document.getElementById('lstConMaternos');
                var lsSex = document.getElementById('lstConSexos');
                var lsTit = document.getElementById('lstConTitulos');
                var lsCar = document.getElementById('lstConCargos');
                var lsTel = document.getElementById('lstConTels');
                var lsCel = document.getElementById('lstConCels');
                var lsMails = document.getElementById('lstConMails');
                var lsNue = document.getElementById('lstNuevos');
                var lsEdi = document.getElementById('lstEditados');
                //var lsBaja = document.getElementById('lstBajas');
                var nom = document.getElementById('nombreCon');
                var pat = document.getElementById('paternoCon');
                var mat = document.getElementById('maternoCon');
                var sex = document.getElementById('sexoCon');
                var tit = document.getElementById('tituloCon');
                var car = document.getElementById('cargoCon');
                var tel = document.getElementById('telCon');
                var cel = document.getElementById('celCon');
                var mail = document.getElementById('mailCon');
                var acc = document.getElementById('conaccion');
                //validar requeridos: nombre, paterno, y al menos un medio
                if (nom.value==''){
                    nom.focus();
                    MostrarMensaje('El nombre del contacto está vacío');
                    return;
                }
                if (pat.value==''){
                    pat.focus();
                    MostrarMensaje('El Apellido Paterno del contacto está vacío');
                    return;
                }
                if (tel.value=='' && cel.value=='' && mail.value==''){
                    tel.focus();
                    MostrarMensaje('Debe ingresar al menos uno de los medios de contacto');
                    return;
                }
                //fin validacion requeridos
                var id = -1;
                if (acc.value==0){
                    var k = lsCon.length;
                    var n = lsNue.length;
                    lsNue.options[n] = new Option(k,k);
                } if (acc.value==1){
                    var k = lsCon.selectedIndex;
                    var esnuevo=false;
                    for (i=0; i < lsNue.length; i++){
                        if (lsNue.options[i].value==k)
                            esnuevo=true;
                    }
                    if (!esnuevo){
                        var idcon = lsCon.options[k].value;
                        var posed = -1;
                        for (i=0; i < lsEdi.length; i++){
                            if (lsEdi.options[i].value == idcon)
                                posed = i;
                        }
                        if (posed<0){
                            lsEdi.options[lsEdi.length] = new Option(idcon,idcon);
                            id = idcon;
                        }
                    }
                }
                
                lsCon.options[k] = new Option(tit.value+' '+nom.value+' '+pat.value+' '+mat.value+' - '+car.value,id);
                lsNom.options[k] = new Option(nom.value,nom.value);
                lsPat.options[k] = new Option(pat.value,pat.value);
                lsMat.options[k] = new Option(mat.value,mat.value==''?'&':mat.value);
                lsSex.options[k] = new Option(sex.value,sex.value);
                lsTit.options[k] = new Option(tit.value,tit.value);
                lsCar.options[k] = new Option(car.value,car.value==''?'&':car.value); 
                lsTel.options[k] = new Option(tel.value,tel.value==''?'&':tel.value); 
                lsCel.options[k] = new Option(cel.value,cel.value==''?'&':cel.value);
                lsMails.options[k] = new Option(mail.value,mail.value==''?'&':mail.value);
                nom.value='';
                pat.value='';
                mat.value='';
                car.value='';
                tel.value='';
                cel.value='';
                mail.value='';
                sex.options[0].selected=true;
                tit.options[0].selected=true;
                var txtTel = document.getElementById('txtTel');
                txtTel.value = '';
                var txtCel = document.getElementById('txtCel');
                txtCel.value = '';
                var txtMail = document.getElementById('txtMail');
                txtMail.value = '';
                $( "#dialog-contacto" ).dialog( "close" );
            }


            /*function PonerInactivo(total){
                for (i=1; i<=total; i++){
                    var pest = document.getElementById('pest'+i);
                    if (pest.className=='activo'){
                        pest.className='inactivo';
                        var cont = document.getElementById('pest'+i+'cont');
                        cont.style.display = 'none';
                    }
                }
            }*/
        
            function ClickPestana(numpest){
                $( "#tabs" ).tabs({ active: numpest-1 });
                /*PonerInactivo(total);                
                var pest = document.getElementById('pest'+numpest);
                pest.className = 'activo';
                var cont = document.getElementById('pest'+numpest+'cont');
                cont.style.display = '';*/
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoCli');
                frm.paginaSig.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoCli');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
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
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                if (ValidaDatosGenerales())
                    if (ValidaOtros()){
                        /*/carga datos de contactos
                        var actuales = document.getElementById('conactuales');
                        var nombres = document.getElementById('connombres');
                        var paternos = document.getElementById('conpaternos');
                        var maternos = document.getElementById('conmaternos');
                        var sexos = document.getElementById('consexos');
                        var titulos = document.getElementById('contitulos');
                        var cargos = document.getElementById('concargos');
                        var tels = document.getElementById('contels');
                        var cels = document.getElementById('concels');
                        var mails = document.getElementById('conmails');
                        var nuevos = document.getElementById('connuevos');
                        var edits = document.getElementById('conedits');
                        var bajas = document.getElementById('conbajas');
                        var lsAct = document.getElementById('lstContactos');
                        var lsNom = document.getElementById('lstConNombres');
                        var lsPat = document.getElementById('lstConPaternos');
                        var lsMat = document.getElementById('lstConMaternos');
                        var lsSex = document.getElementById('lstConSexos');
                        var lsTit = document.getElementById('lstConTitulos');
                        var lsCar = document.getElementById('lstConCargos');
                        var lsTel = document.getElementById('lstConTels');
                        var lsCel = document.getElementById('lstConCels');
                        var lsMails = document.getElementById('lstConMails');
                        var lsNue = document.getElementById('lstNuevos');
                        var lsEdi = document.getElementById('lstEditados');
                        var lsBaja = document.getElementById('lstBajas');
                        
                        for (i=0; i < lsNom.length; i++){
                            if (nombres.value==''){
                                actuales.value = lsAct.options[i].value;
                                nombres.value = lsNom.options[i].value;
                                paternos.value = lsPat.options[i].value;
                                maternos.value = lsMat.options[i].value;
                                sexos.value = lsSex.options[i].value;
                                titulos.value = lsTit.options[i].value;
                                cargos.value = lsCar.options[i].value;
                                tels.value = lsTel.options[i].value;
                                cels.value = lsCel.options[i].value;
                                mails.value = lsMails.options[i].value;
                            } else {
                                actuales.value += '|'+lsAct.options[i].value;
                                nombres.value += '|'+lsNom.options[i].value;
                                paternos.value += '|'+lsPat.options[i].value;
                                maternos.value += '|'+lsMat.options[i].value;
                                sexos.value += '|'+lsSex.options[i].value;
                                titulos.value += '|'+lsTit.options[i].value;
                                cargos.value += '|'+lsCar.options[i].value;
                                tels.value += '|'+lsTel.options[i].value;
                                cels.value += '|'+lsCel.options[i].value;
                                mails.value += '|'+lsMails.options[i].value;
                            }
                        }
                    
                        for (i=0; i < lsNue.length; i++){
                            if (nuevos.value==''){
                                nuevos.value = lsNue.options[i].value;
                            } else {
                                nuevos.value += '|'+lsNue.options[i].value;
                            }
                        }
                    
                        for (i=0; i < lsEdi.length; i++){
                            if (edits.value==''){
                                edits.value = lsEdi.options[i].value;
                            } else {
                                edits.value += '|'+lsEdi.options[i].value;
                            }
                        }
                    
                        for (i=0; i < lsBaja.length; i++){
                            if (bajas.value==''){
                                bajas.value = lsBaja.options[i].value;
                            } else {
                                bajas.value += '|'+lsBaja.options[i].value;
                            }
                        }*/
                        
                        return true;
                    }
                return false;
            }
        
            function ValidaDatosGenerales(){
                //var tipoCli[] = document.getElementById('rdTipoCli');
                
                if (document.frmNuevoCli.rdTipoCli[0].checked){
                    var razonCli = document.getElementById('razonCli');
                    if (razonCli.value == ''){
                        Mensaje('El campo Razón Social del Cliente está vacío');
                        ClickPestana(1);
                        razonCli.focus();
                        return false;
                    }
                    
                    var rfcCli = document.getElementById('rfcCli');
                    if (rfcCli.value == ''){
                        Mensaje('El campo RFC del Cliente está vacío');
                        ClickPestana(1);
                        rfcCli.focus();
                        return false;
                    }
                    
                    var nombreRep = document.getElementById('nombreRepr');
                    var paternoRep = document.getElementById('paternoRepr');
                    var maternoRep = document.getElementById('maternoRepr');
                    if ((nombreRep.value != '' && paternoRep.value == '') ||
                        (paternoRep.value != '' && nombreRep.value == '')
                        || (maternoRep.value != '' && (paternoRep.value == '' || nombreRep.value == ''))){
                        Mensaje('El Nombre del Representante Legal está incompleto');
                        ClickPestana(1);
                        nombreRep.focus();
                        return false;
                    }
                    /*
                    if (nombreRep.value == ''){
                        Mensaje('El campo Nombre del Representante está vacío');
                        ClickPestana(1,2);
                        nombreRep.focus();
                        return false;
                    }

                    
                    if (paternoRep.value == ''){
                        Mensaje('El campo Ap. Paterno del Representante está vacío');
                        ClickPestana(1,2);
                        paternoRep.focus();
                        return false;
                    }

                    
                    if (maternoRep.value == ''){
                        Mensaje('El campo Ap. Materno del Representante está vacío');
                        ClickPestana(1,2);
                        maternoRep.focus();
                        return false;
                    }*/
                }
                else {
                    var rfcCli = document.getElementById('rfcCliFis');
                    if (rfcCli.value == ''){
                        Mensaje('El campo RFC del Cliente está vacío');
                        ClickPestana(1);
                        rfcCli.focus();
                        return false;
                    }

                    var nombreRep = document.getElementById('nombreReprFis');
                    if (nombreRep.value == ''){
                        Mensaje('El campo Nombre del Representante está vacío');
                        ClickPestana(1);
                        nombreRep.focus();
                        return false;
                    }

                    var paternoRep = document.getElementById('paternoReprFis');
                    if (paternoRep.value == ''){
                        Mensaje('El campo Ap. Paterno del Representante está vacío');
                        ClickPestana(1);
                        paternoRep.focus();
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
                
        
                var calleCli = document.getElementById('calleCli');
                if (calleCli.value == ''){
                    Mensaje('El campo Calle y Número del Cliente está vacío');
                    ClickPestana(1);
                    calleCli.focus();
                    return false;
                }
                
                var colCli = document.getElementById('coloniaCli');
                if (colCli.value == ''){
                    Mensaje('El campo Colonia del Cliente está vacío');
                    ClickPestana(1);
                    colCli.focus();
                    return false;
                }
                
                var edoCli = document.getElementById('estadoCli');
                if (edoCli.value == '0'){
                    Mensaje('El campo Estado del Cliente no ha sido establecido');
                    ClickPestana(1);
                    edoCli.focus();
                    return false;
                }
                
                var pobCli = document.getElementById('poblacionCli');
                if (pobCli.value == '0'){
                    Mensaje('El campo Población del Cliente no ha sido establecido');
                    ClickPestana(1);
                    pobCli.focus();
                    return false;
                }
                                
                return true;
            }
            
            function ValidaOtros(){
                var agente = document.getElementById('agente');
                if (agente.value=='0'){
                    Mensaje('El campo Agente no ha sido establecido');
                    ClickPestana(2);
                    agente.focus();
                    return false;
                }
                /*
                var ruta = document.getElementById('ruta');
                if (ruta.value=='0'){
                    Mensaje('El campo Ruta no ha sido establecido');
                    ClickPestana(2,2);
                    ruta.focus();
                    return false;
                }*/
                
                var fech = document.getElementById('fechaAlta');
                if (fech.value==''){
                    Mensaje('El campo Fecha Alta no ha sido establecida');
                    ClickPestana(2);
                    fech.focus();
                    return false;
                }
                
                var desc1 = document.getElementById('descto1');
                if (desc1.value==''){
                    Mensaje('El campo Descuento 1 está vacío');
                    ClickPestana(2);
                    desc1.focus();
                    return false;
                }
                
                var desc2 = document.getElementById('descto2');
                if (desc2.value==''){
                    Mensaje('El campo Descuento 2 está vacío');
                    ClickPestana(2);
                    desc2.focus();
                    return false;
                }
                
                var desc3 = document.getElementById('descto3');
                if (desc3.value==''){
                    Mensaje('El campo Descuento 3 está vacío');
                    ClickPestana(2);
                    desc3.focus();
                    return false;
                }
                                
                var plazo = document.getElementById('plazo');
                if (plazo.value==''){
                    Mensaje('El campo Plazo del Crédito está vacío');
                    ClickPestana(2);
                    plazo.focus();
                    return false;
                }
                
                var lista = document.getElementById('listap');
                if (lista.value==''){
                    Mensaje('El campo Lista de Precios está vacío');
                    ClickPestana(2);
                    lista.focus();
                    return false;
                }
                
                nLis = parseInt(lista.value);
                if ((nLis < 1) || (nLis > 5)){
                    Mensaje('El campo Lista de Precios debe ser un valor entre 1 y 5');
                    ClickPestana(2);
                    lista.focus();
                    return false;
                }
                
                return true;
            }

        </script>
    </body>
</html>