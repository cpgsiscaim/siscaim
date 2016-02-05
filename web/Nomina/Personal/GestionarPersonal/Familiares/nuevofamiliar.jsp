<%@page import="Modelo.Entidades.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Empleado, Modelo.Entidades.Catalogos.TipoFamiliar, Modelo.Entidades.Familiar, Modelo.Entidades.Persona"%>
<%@page import="Modelo.Entidades.Catalogos.Municipio, Modelo.Entidades.Catalogos.Estado, java.text.SimpleDateFormat"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "NUEVO", fechaNac = "";
    String imagen = "familiaresB.png";
    TipoFamiliar tfam = new TipoFamiliar();
    Persona per = new Persona();
    String obs = "";
    Empleado empl = (Empleado)datosS.get("empleado");
    Municipio munActual = null;
    Estado edoActual = null;
    Familiar fam = new Familiar();
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "EDITAR";
        imagen = "familiaresC.png";
        fam = (Familiar)datosS.get("familiar");
        tfam = fam.getTipofamiliar();
        per = fam.getPersona();
        munActual = fam.getPersona().getDireccion().getPoblacion()!=null?fam.getPersona().getDireccion().getPoblacion():null;
        edoActual = fam.getPersona().getDireccion().getPoblacion()!=null?fam.getPersona().getDireccion().getPoblacion().getEstado():null;
        obs = fam.getObservacion()!=null?fam.getObservacion():"";
        SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
        fechaNac = formato.format(per.getFnaci());
    }
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaNac" ).datepicker({
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
        
        //BOTONES
        $(function() {
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
                    <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        BENEFICIARIOS - <%=titulo%>
                    </div>
                    <div class="titulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoFam" name="frmNuevoFam" action="<%=CONTROLLER%>/Gestionar/Familiar" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="50%" align="center">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="50%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%" cellpadding="5px">
                                            <tr>
                                                <td width="67%" align="left" colspan="2">
                                                    <span class="etiquetaB">Tipo de Familiar:</span><br>
                                                    <select id="tipofam" name="tipofam" class="combo" style="width: 350px">
                                                        <option value="">Elija el Tipo de Familiar...</option>
                                                    <%
                                                        List<TipoFamiliar> tiposfam = (List<TipoFamiliar>)datosS.get("tiposfam");
                                                        for (int i=0; i < tiposfam.size(); i++){
                                                            TipoFamiliar tipofam = tiposfam.get(i);
                                                        %>
                                                        <option value="<%=tipofam.getId()%>"
                                                                <%if (tipofam.getId()==tfam.getId()){%>selected<%}%>>
                                                            <%=tipofam.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                    %>
                                                    </select>
                                                </td>
                                                <td width="33%">
                                                    <span class="etiqueta">Fecha de Nacimiento:</span><br>
                                                    <input id="fechaNac" name="fechaNac" type="text" class="text" readonly value="<%=fechaNac%>"
                                                        title="Ingrese la fecha de nacimiento"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="34%">
                                                    <span class="etiqueta">Nombre(s):</span><br>
                                                    <input id="nombre" name="nombre" type="text" value="<%=per.getNombre()!=null?per.getNombre():""%>" style="width: 300px"
                                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                        maxlength="30"/>
                                                </td>
                                                <td width="33%">
                                                    <span class="etiqueta">Ap. Paterno:</span><br>
                                                    <input id="paterno" name="paterno" type="text" value="<%=per.getPaterno()!=null?per.getPaterno():""%>" style="width: 200px"
                                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                        maxlength="20"/>
                                                </td>
                                                <td width="33%">
                                                    <span class="etiqueta">Ap. Materno:</span><br>
                                                    <input id="materno" name="materno" type="text" value="<%=per.getMaterno()!=null?per.getMaterno():""%>" style="width: 200px"
                                                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                        maxlength="20"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%">
                                                    <span class="etiqueta">Calle y Número:</span><br>
                                                    <input id="callenum" name="callenum" type="text" value="<%=per.getDireccion()!=null?per.getDireccion().getCalle():""%>" style="width: 400px"
                                                        onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                                                        maxlength="50"/>
                                                </td>
                                                <td width="25%">
                                                    <span class="etiqueta">Colonia:</span><br>
                                                    <input id="colonia" name="colonia" type="text" value="<%=per.getDireccion()!=null?per.getDireccion().getColonia():""%>"  style="width: 250px"
                                                        onkeypress="return ValidaRazonSocial(event, this.value)"
                                                        onblur="Mayusculas(this)" maxlength="50"/>
                                                </td>
                                                <td width="25%">
                                                    <span class="etiqueta">C.P. :</span><br>
                                                    <input id="codigop" name="codigop" type="text" value="<%=per.getDireccion()!=null?per.getDireccion().getCp():""%>" style="width: 150px"
                                                        onkeypress="return ValidaNums(event)"
                                                        onblur="Mayusculas(this)" maxlength="5"/>
                                                </td>        
                                            </tr>
                                            <tr>
                                                <td width="40%">
                                                    <span class="etiqueta">Estado:</span><br>
                                                    <select id="estado" name="estado" class="combo" style="width: 250px"
                                                            onchange="CargaMunicipios(this.value)">
                                                        <option value="">Elija el Estado...</option>
                                                        <%
                                                            List<Estado> estados = (List<Estado>) datosS.get("estados");
                                                            for (int i = 0; i < estados.size(); i++) {
                                                                Estado edo = (Estado) estados.get(i);
                                                        %>
                                                        <option value="<%=edo.getIdestado()%>"
                                                                <%
                                                                    if (edoActual != null && edo.getIdestado() == edoActual.getIdestado()) {
                                                                %>
                                                                selected
                                                                <%                                            }
                                                                %>
                                                                >
                                                            <%=edo.getEstado()%>
                                                        </option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </td>
                                                <td width="40%">
                                                    <span class="etiqueta">Población:</span><br>
                                                    <select id="poblacion" name="poblacion" class="combo" style="width: 350px">
                                                        <option value="">Elija la Población...</option>
                                                        <%
                                                            if (munActual != null) {
                                                                for (int p = 2; p >= 0; p--) {
                                                                    List<Municipio> municipios = edoActual.getMunicipios();
                                                                    for (int i = 0; i < municipios.size(); i++) {
                                                                        Municipio m = municipios.get(i);
                                                                        if (m.getPrioridad() == p) {
                                                        %>
                                                        <option value="<%=m.getIdmunicipio()%>"
                                                                <%
                                                                    if (m.getIdmunicipio() == munActual.getIdmunicipio()) {
                                                                %>
                                                                selected
                                                                <%                                                        }
                                                                %>
                                                                >
                                                            <%=m.getMunicipio()%>
                                                        </option>
                                                        <%
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                </td>
                                                <td width="20%">
                                                    <span class="etiqueta">Teléfono:</span><br>
                                                    <input id="telefono" name="telefono" type="text" value="<%=per.getDireccion()!=null?per.getDireccion().getTelefono():""%>" style="width: 150px"
                                                        onblur="Mayusculas(this)" onkeypress="return ValidaNums(event)" maxlength="10"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="70%" colspan="3">
                                                    <span class="etiqueta">Observaciones:</span><br>
                                                    <input id="observaciones" name="observaciones" type="text" value="<%=obs%>" style="width: 750px"
                                                        onblur="Mayusculas(this)" maxlength="200"/>
                                                </td>                    
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
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
                    MostrarMensaje('<%=sesion.getMensaje()%>');
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

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoFam');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Familiares/gestionarfamiliares.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmNuevoFam');
                    frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Familiares/gestionarfamiliares.jsp';
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
                var tipofam = document.getElementById('tipofam');
                if (tipofam.value == ''){
                    Mensaje('El Tipo de Familiar no ha sido establecido');
                    return false;
                }
                
                var nombre = document.getElementById('nombre');
                if (nombre.value == ''){
                    Mensaje('El Nombre del Familiar está vacío');
                    nombre.focus();
                    return false;
                }
                
                var paterno = document.getElementById('paterno');
                if (paterno.value == ''){
                    Mensaje('El Ap. Paterno del Familiar está vacío');
                    paterno.focus();
                    return false;
                }
                               
                var fnac = document.getElementById('fechaNac');
                if (fnac.value == ''){
                    MostrarMensaje('La Fecha de Nacimiento del Familiar no ha sido establecida');
                    return false;
                }
               
                return true;
            }
        
            function CargaMunicipios(estado){
                    var poblacion = document.getElementById("poblacion");
                    poblacion.length = 0;
                    poblacion.options[0] = new Option('Elija la Población...','0');
                    k=1;
                <%
                    for (int i = 0; i < estados.size(); i++) {
                        Estado edo = (Estado) estados.get(i);
                %>
                    if (<%=edo.getIdestado()%> == estado){
                <%
                    List<Municipio> munis = edo.getMunicipios();
                    for (int j = 0; j < munis.size(); j++) {
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
        </script>
    </body>
</html>