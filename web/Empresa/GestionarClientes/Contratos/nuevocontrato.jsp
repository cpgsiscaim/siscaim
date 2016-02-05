<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Cliente, Modelo.Entidades.Sucursal, Modelo.Entidades.Contrato"%>
<%@page import="Modelo.Entidades.Catalogos.Titulo, Modelo.Entidades.Catalogos.TipoMedio, Modelo.Entidades.ContactoContrato"%>
<%@page import="Modelo.Entidades.PersonaMedio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliSel = (Cliente)datosS.get("clienteSel");
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String titulo = "NUEVO CONTRATO";
    String imagen = "contratos02.png";
    List<Titulo> titulos = (List<Titulo>)datosS.get("titulos");
    List<TipoMedio> tiposmedios = (List<TipoMedio>)datosS.get("tiposmedios");
    List<ContactoContrato> contactos = new ArrayList<ContactoContrato>();
    List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
    Contrato tempo = new Contrato();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR CONTRATO";
        imagen = "contratoEditar.png";
        contactos = (List<ContactoContrato>)datosS.get("contactos");
        medioscon = (List<PersonaMedio>)datosS.get("medioscon");
    }
    String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
    int banhis = Integer.parseInt(datosS.get("banhis")!=null?datosS.get("banhis").toString():"0");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <!--<link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />-->
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
            <%if (banhis==0){%>
            $( "#fechaIni" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
            <%}%>
        });
        
        $(function() {
            <%if (banhis==0){%>
            $( "#fechaFin" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
            <%}%>
        });

        $(function() {
            <%if (banhis==0){%>
            $( "#fechaesp" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
            <%}%>
        });

        //fecha fianza
        $(function() {
            <%if (banhis==0){%>
            $( "#fecha" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
            <%}%>
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
        
        /*/DIALOGO CONTACTO
        $(function() {
            $( "#dialog-contacto" ).dialog({
            resizable: false,
            width:700,
            height:350,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                AgregarContacto();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                LimpiarInputs();
                }
            }
            });
        });*/        

        //Ventana modal del contrato
        $(function() {
            $( "#dialog-contrato" ).dialog({
                autoOpen: false,
                modal: true,
                width:900,
                height:640
            });
        });
    
        //Subir contrato
        $(function() {
            $( "#dialog-loadcontrato" ).dialog({
                autoOpen: false,
                modal: true,
                width:500,
                height:150
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
    
        //Subir fianza
        $(function() {
            $( "#dialog-loadfianza" ).dialog({
                autoOpen: false,
                modal: true,
                width:500,
                height:150
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
            
            $( "#btnAgregarDocCon" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            
            $( "#btnVerDocCon" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            
            $( "#btnBorrarDocCon" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            
            $( "#btnAgregarDocFianza" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            
            $( "#btnVerDocFianza" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            
            $( "#btnBorrarDocFianza" ).button({
                icons: {
                    primary: "ui-icon-trash"
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
                                <td width="34%">
                                    <span class="etiquetaB">Tel&eacute;fono:</span><br>
                                    <input id="telCon" name="telCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaNums(event)" maxlength="10"/>
                                </td>
                                <td width="34%">
                                    <span class="etiquetaB">Celular:</span><br>
                                    <input id="celCon" name="celCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaNums(event)" maxlength="10"/>
                                </td>
                                <td width="33%">
                                    <span class="etiquetaB">Correo: </span><br>
                                    <input id="mailCon" name="mailCon" class="text" type="text" value="" style="width: 200px"
                                        onkeypress="return ValidaMail(event, this.value)" maxlength="50"/>
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
                        GESTIONAR CONTRATOS - <%=titulo%>
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
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoCon" name="frmNuevoCon" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
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
                            <table width="90%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <div id="tabs">
                                            <ul>
                                                <li><a href="#tabs-1">Contrato</a></li>
                                                <!--<li><a href="#tabs-2">Impuestos y Stock</a></li>-->
                                                <li><a href="#tabs-2">Fianza</a></li>
                                                <%if (banhis==0 && datosS.get("accion").toString().equals("editar")){%>
                                                <li><a href="#tabs-3">Contactos</a></li>
                                                <%}%>
                                            </ul>
                                            <div id="tabs-1">
                                                <%@include file="pestcontrato.jsp"%>
                                            </div>
                                            <div id="tabs-2">
                                                <%@include file="pestfianza.jsp" %>
                                            </div>
                                            <%if (banhis==0 && datosS.get("accion").toString().equals("editar")){%>
                                            <div id="tabs-3">
                                                <%@include file="pestcontactos.jsp" %>
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
                                        <%if (banhis==0){%>
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar contrato">
                                            Guardar
                                        </a>
                                        <%}%>
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
            
            /*function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
                else if (boton.value=='2')
                    EjecutarSalidasProgs();
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
                <%}%><%-- if (contactos.isEmpty()){--%>
                     var btnBajaContac = document.getElementById('btnBajaContac');
                     var btnEditarContac = document.getElementById('btnEditarContac');
                     //var btnNuevoContac = document.getElementById('btnNuevoContac');
                     //btnNuevoContac.style.display = 'none';
                     btnEditarContac.style.display = 'none';
                     btnBajaContac.style.display = 'none';
                <%--}--%>
            }
            /*
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
            */
            function ClickPestana(numpest){
                $( "#tabs" ).tabs({ active: numpest-1 });
                /*PonerInactivo(total);                
                var pest = document.getElementById('pest'+numpest);
                pest.className = 'activo';
                var cont = document.getElementById('pest'+numpest+'cont');
                cont.style.display = '';*/
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmNuevoCon');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoCon');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
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
                if (ValidaDatosContrato())
                    if (ValidaFianza()){
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
        
            function ValidaDatosContrato(){
                //var tipoCli[] = document.getElementById('rdTipoCli');
                
                var contrato = document.getElementById('contrato');
                if (contrato.value == ''){
                    MostrarMensaje('El campo Número de Contrato está vacío');
                    ClickPestana(1);
                    //contrato.focus();*/
                    return false;
                }
                    
                var fechaIni = document.getElementById('fechaIni');
                if (fechaIni.value == ''){
                    MostrarMensaje('El campo Fecha Inicial está vacío');
                    ClickPestana(1);
                    //fechaIni.focus();*/
                    return false;
                }
                    
                var fechaFin = document.getElementById('fechaFin');
                if (fechaFin.value == ''){
                    MostrarMensaje('El campo Fecha Final está vacío');
                    ClickPestana(1);
                    //fechaFin.focus();*/
                    return false;
                }

                var descrip = document.getElementById('descripcion');
                if (descrip.value == ''){
                    MostrarMensaje('El campo Descripción está vacío');
                    ClickPestana(1);
                    //descrip.focus();*/
                    return false;
                }
                
                //configuracion de las fechas de entrega, solo para los nuevos contratos obligatoria
                var opcconfig = document.getElementById('opcconfig');
                if (opcconfig.value == ''){
                    MostrarMensaje('No ha definido la opción de Configuración de Fechas de Entrega');
                    ClickPestana(1);
                    return false;
                } else if (opcconfig.value == '0'){
                    var ndias = document.getElementById('numdias');
                    if (ndias.value == ''){
                        MostrarMensaje('Debe especificar el número de días');
                        ClickPestana(1);
                        //ndias.focus();*/
                        return false;
                    } else {
                        nd = parseInt(ndias.value);
                        if (isNaN(nd)){
                            MostrarMensaje('El número de días escrito no es válido o no es un número');
                            ClickPestana(1);
                            //ndias.focus();*/
                            return false;
                        } else if (nd==0){
                            MostrarMensaje('El número de días debe ser mayor a cero');
                            ClickPestana(1);
                            //ndias.focus();*/
                            return false;
                        }
                    }
                } else if (opcconfig.value == '1'){
                    var lsfechas = document.getElementById('lsfechas');
                    if (lsfechas.length==0){
                        MostrarMensaje('No ha definido las fechas de entrega');
                        ClickPestana(1);
                        return false;
                    } else {
                        var lstfechas = document.getElementById('lstfechas');
                        lstfechas.value = '';
                        //carga la cadena de fechas
                        for (i=0; i<lsfechas.length; i++){
                            if (lstfechas.value == ''){
                                lstfechas.value = lsfechas.options[i].value;
                            } else {
                                lstfechas.value += ','+lsfechas.options[i].value;
                            }
                        }
                    }
                }
                
                
                return true;
            }
            
            function ValidaFianza(){
                var importe = document.getElementById('importe');
                if (importe.value == ''){
                    MostrarMensaje('El campo Importe de la Fianza está vacío o es cero');
                    ClickPestana(2);
                    //importe.focus();*/
                    return false;
                }
                
                var fecha = document.getElementById('fecha');
                if (fecha.value==''){
                    MostrarMensaje('El campo Fecha de la Fianza no ha sido establecido');
                    ClickPestana(2);
                    //fecha.focus();*/
                    return false;
                }
                
                //var estatus = document.getElementById('radioEstatusF');
                //alert(estatus[1].checked);
                if (!document.frmNuevoCon.radioEstatusF[0].checked && !document.frmNuevoCon.radioEstatusF[1].checked){
                    MostrarMensaje('El Estatus de la Fianza no ha sido establecido');
                    ClickPestana(2);
                    //estatus[0].focus();*/
                    return false;                    
                }
                
                return true;
            }

            /*function AgregaContacto(){
                var lista = document.getElementById('lstContactos');
                var k = lista.length;
                var tit = document.getElementById('titulo');
                var nom = document.getElementById('nombrecon');
                var pat = document.getElementById('paternocon');
                var mat = document.getElementById('maternocon');
                var cargo = document.getElementById('cargo');
                var sexo = document.getElementById('sexo');
                var nomfull = tit.value+' '+pat.value+' '+mat.value+' '+nom.value+' ('+cargo.value+')';
                lista.options[k] = new Option(nomfull,'');
                var lsnuevos = document.getElementById('lstConNuevos');
                var n = lsnuevos.length;
                lsnuevos.options[n] = new Option(nom.value+'|'+pat.value+'|'+mat.value+'|'+tit.value+'|'+sexo.value+'|'+cargo.value,'');
                nom.value = '';
                pat.value = '';
                mat.value = '';
                cargo.value = '';
            }
            
            function AgregarMedioClick(){
                $( "#dialog-formm" ).dialog( "open" );
            }
            
            function AgregaMedio(){
                alert('entro');
                var lista = document.getElementById('lstMediosCon');
                var k = lista.length;
                var med = document.getElementById('mediocon');
                var tipom = document.getElementById('tipomedio');
                alert(tipom.value);                
                var medfull = med.value+' ('+tipom.value+')';
                alert(medfull);                
                lista.options[k] = new Option(medfull,'');
                med.value = '';
                //tipom.value = '';
            }*/

            function CargaPdf(archivo){
                tokens = archivo.split('\\');
                nombreArch = tokens[tokens.length-1];
                tokensNom = nombreArch.split('.');
                exten = tokensNom[tokensNom.length-1];
                if (exten.toLowerCase().trim() != 'pdf'){
                    MostrarMensaje('La extensión del archivo debe ser pdf');
                    return;
                }

                $( "#dialog-loadcontrato" ).dialog( "close" );
                
                Espera();
                var frm = document.getElementById('cargaArchivo');
                frm.archivoCargo.value=nombreArch;
                frm.pasoSig.value = '1';
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp';
                frm.submit();
            }

            function BorrarDocContrato(doc){
                var frm = document.getElementById('frmNuevoCon');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp';
                frm.pasoSig.value = '18';
                frm.submit();
            }
    
            function CargaPdfFianza(archivo){
                tokens = archivo.split('\\');
                nombreArch = tokens[tokens.length-1];
                tokensNom = nombreArch.split('.');
                exten = tokensNom[tokensNom.length-1];
                if (exten.toLowerCase().trim() != 'pdf'){
                    MostrarMensaje('La extensión del archivo debe ser pdf');
                    return;
                }

                $( "#dialog-loadfianza" ).dialog( "close" );
                
                Espera();
                var frm = document.getElementById('cargaArchivoFianza');
                frm.archivoCargoFianza.value=nombreArch;
                frm.pasoSig.value = '1';
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp';
                frm.submit();
            }

            function BorrarDocFianza(doc){
                var frm = document.getElementById('frmNuevoCon');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/nuevocontrato.jsp';
                frm.pasoSig.value = '19';
                frm.submit();
            }

        </script>
                    
        <div id="dialog-contrato" title="Documento del Contrato">
            <embed id="pdf" src="" width="870" height="580" align="center" valign="center">
        </div>        

        <div id="dialog-loadcontrato" title="Cargar Documento de Contrato">
            <form id="cargaArchivo" name="cargaArchivo" action="<%=CONTROLLER%>/NuevoDoc/Contrato" method="post" enctype="multipart/form-data">                    
                <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
                <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
                <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
                <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
                <input id="archivoCargo" name="archivoCargo" type="hidden" value=""/>

                <table width="100%">
                    <tr>
                        <td align="center" valign="center">
                            <input type="file" id="uploadfile" name="uploadfile" onchange="CargaPdf(this.value)" /><br><br><br>
                        </td>
                    </tr>
                </table>
           </form>
            
        </div>
                    
        <div id="dialog-fianza" title="Documento de la Fianza">
            <embed id="pdffianza" src="" width="870" height="580" align="center" valign="center">
        </div>        

        <div id="dialog-loadfianza" title="Cargar Documento de la Fianza">
            <form id="cargaArchivoFianza" name="cargaArchivoFianza" action="<%=CONTROLLER%>/NuevoDoc/Fianza" method="post" enctype="multipart/form-data">                    
                <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
                <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
                <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
                <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
                <input id="archivoCargoFianza" name="archivoCargoFianza" type="hidden" value=""/>

                <table width="100%">
                    <tr>
                        <td align="center" valign="center">
                            <input type="file" id="uploadfile" name="uploadfile" onchange="CargaPdfFianza(this.value)" /><br><br><br>
                        </td>
                    </tr>
                </table>
           </form>
            
        </div>
    </body>
</html>