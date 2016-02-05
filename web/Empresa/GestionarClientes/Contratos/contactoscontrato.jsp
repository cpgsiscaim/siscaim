<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.List, java.util.ArrayList, java.util.HashMap, Modelo.Entidades.Cliente, Modelo.Entidades.Sucursal, Modelo.Entidades.Contrato"%>
<%@page import="Modelo.Entidades.Catalogos.Titulo, Modelo.Entidades.Catalogos.TipoMedio, Modelo.Entidades.ContactoContrato"%>
<%@page import="Modelo.Entidades.PersonaMedio"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Cliente cliSel = (Cliente)datosS.get("clienteSel");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
List<Titulo> titulos = (List<Titulo>)datosS.get("titulos");
List<TipoMedio> tiposmedios = (List<TipoMedio>)datosS.get("tiposmedios");
List<ContactoContrato> contactos = (List<ContactoContrato>)datosS.get("contactos");
List<PersonaMedio> medioscon = (List<PersonaMedio>)datosS.get("medioscon");
Contrato tempo = (Contrato)datosS.get("editarContrato");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
    <!-- Jquery UI -->
        <link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-custom.css" />
        <!--<link rel="stylesheet" href="/siscaim/Estilos/jqui/jquery-ui-botones.css" />-->
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
        
        //DIALOGO CONTACTO
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
        });        
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnEliminar" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-minus"
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
                    <img src="/siscaim/Imagenes/Empresa/contactos01.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CONTRATO
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
                    <div class="subtitulo" align="left">
                        CONTACTOS DEL CONTRATO
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmContactosCon" name="frmContactosCon" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCon" name="idCon" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table id="acciones" width="100%">
                                        <tr>
                                            <td width="10%" align="left">
                                                <a id="btnCancelar" href="javascript: CancelarClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Contactos">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="20%" align="right">&nbsp;</td>
                                            <td width="20%" align="right">
                                                <%--
                                                <table id="borrarEdit" width="100%" style="display: none" align="right">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <a id="btnEliminar" href="javascript: EliminarContacto()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;"
                                                            title="Eliminar el contacto seleccionado">
                                                                Eliminar
                                                            </a>
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <a id="btnEditar" href="javascript: ContactoClick(1)"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;"
                                                            title="Editar el contacto seleccionado">
                                                                Editar
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                                --%>
                                            </td>
                                            <td width="10%" align="right">
                                                <%--
                                                <a id="btnNuevo" href="javascript: ContactoClick(0)"
                                                style="width: 150px; font-weight: bold; color: #0B610B; display: none"
                                                title="Nuevo Contacto">
                                                    Nuevo
                                                </a>--%>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <table class="tablaLista" width="80%" align="center">
                                    <%
                                    if (contactos.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Contactos registrados en el contrato
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="30%">
                                                    <span>Nombre</span>
                                                </td>
                                                <td align="center" width="20%">
                                                    <span>Cargo</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Teléfonos</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Celulares</span>
                                                </td>
                                                <td align="center" width="20%">
                                                    <span>Correos Electrónicos</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%
                                            int tabindex = 1000;
                                            for (int i=0; i < contactos.size(); i++){
                                                ContactoContrato ctcon = contactos.get(i);
                                        %>
                                                <tr > <%--onclick="Activa(<%=i%>)"--%>
                                                    <%--<td align="left" width="5%">
                                                        <input id="radioCto" name="radioCto" type="radio" value="<%=ctcon.getId()%>"/>
                                                    </td>--%>
                                                    <td align="left" width="30%">
                                                        <span class="etiquetaD">
                                                            <%=ctcon.getContacto().getNombreCompletoPorApellidos()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiquetaD">
                                                            <%=ctcon.getContacto().getCargo()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%
                                                            int p=0;
                                                            for (int m=0; m < medioscon.size(); m++){
                                                                PersonaMedio pm = medioscon.get(m);
                                                                if (ctcon.getContacto().getIdpersona()==pm.getPersona().getIdpersona()
                                                                        && pm.getMedio().getTipo().getIdtipomedio()==1){
                                                            %>
                                                                    <%if (p>0){%><br><%}%>
                                                                    <%=pm.getMedio().getFormatoTelefono()%>
                                                            <%
                                                                    p++;
                                                                }
                                                            }%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%
                                                            p=0;
                                                            for (int m=0; m < medioscon.size(); m++){
                                                                PersonaMedio pm = medioscon.get(m);
                                                                if (ctcon.getContacto().getIdpersona()==pm.getPersona().getIdpersona()
                                                                        && pm.getMedio().getTipo().getIdtipomedio()==2){
                                                            %>
                                                                    <%if (p>0){%><br><%}%>
                                                                    <%=pm.getMedio().getFormatoTelefono()%>
                                                            <%
                                                                    p++;
                                                                }
                                                            }%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiquetaD">
                                                            <%
                                                            p=0;
                                                            for (int m=0; m < medioscon.size(); m++){
                                                                PersonaMedio pm = medioscon.get(m);
                                                                if (ctcon.getContacto().getIdpersona()==pm.getPersona().getIdpersona()
                                                                        && pm.getMedio().getTipo().getIdtipomedio()==3){
                                                            %>
                                                                    <%if (p>0){%><br><%}%>
                                                                    <%=pm.getMedio().getMedio()%>
                                                            <%
                                                                p++;
                                                                }
                                                            }%>
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
                    EjecutarProdsxCt();
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
                %>
            }
            
            function Activa(fila){
                var idCon = document.getElementById('idCon');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (contactos.size()==1){
                %>
                    document.frmContactosCon.radioCto.checked = true;
                    idCon.value = document.frmContactosCon.radioCto.value;
                <%
                } else {
                %>
                    var radio = document.frmContactosCon.radioCto[fila];
                    radio.checked = true;
                    idCon.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmContactosCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '96';
                frm.submit();                
            }
            
            function NuevoPCTClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/agregardetalle.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarPCTClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/nuevoprodct.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarPCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                paso.value = '6';
                frm.submit();                
            }
            
            function BajaPCTClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                
                /*var resp = */Confirmar('¿Está seguro en dar de baja el Producto seleccionado?');
                /*if (resp){
                    var frm = document.getElementById('frmGestionarPCT');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                    paso.value = '6';
                    frm.submit();
                }*/
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarPCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/prodctinactivos.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
            function EjecutarProdsxCt(){
                Espera();
                var frm = document.getElementById('frmGestionarPCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                paso.value = '9';
                frm.submit();
            }
            
            function ProdsxCTClick(){
                var boton = document.getElementById('boton');
                boton.value = '2';
                Confirmar('Los datos actuales de los Centros de Trabajo serán eliminados, ¿continuar?');
                /*
                var resp = confirm('Los datos actuales de los Centros de Trabajo serán eliminados, ¿continuar?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarPCT');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                    paso.value = '9';
                    frm.submit();
                }*/
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
                    /*var nom = document.getElementById('nombreCon');
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
                    mail.value = lsMails.options[sel].value!='&'?lsMails.options[sel].value:'';*/
                }
                $( "#dialog-contacto" ).dialog( "open" );
            }

            function ContactoClick(opcion){
                var titvent = "NUEVO CONTACTO";
                if (opcion==1)
                    titvent='EDITAR CONTACTO';
                Contacto(titvent, opcion);
            }

        </script>
    </body>
</html>