<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa"%>
<%@page import="Modelo.Entidades.Catalogos.Titulo, Modelo.Entidades.Catalogos.TipoMedio"%>
<%@page import="java.util.List, Modelo.Entidades.ContactoProveedor, Modelo.Entidades.PersonaMedio"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String accion = datosS.get("accionContacto")!=null?datosS.get("accionContacto").toString():"nuevo";
    String titulo = "NUEVO CONTACTO DE PROVEEDOR";
    String nombre = "", paterno = "", materno = "", sexo = "", titcon="", cargocon = "";
    List<PersonaMedio> medios = new ArrayList<PersonaMedio>();
    if (accion.equals("editar")){
        titulo = "EDITAR CONTACTO DE PROVEEDOR";
        ContactoProveedor cc = (ContactoProveedor)datosS.get("contacto");
        nombre = cc.getContacto().getNombre();
        paterno = cc.getContacto().getPaterno();
        materno = cc.getContacto().getMaterno();
        sexo = cc.getContacto().getSexo();
        titcon = cc.getContacto().getTitulo();
        cargocon = cc.getContacto().getCargo();
        medios = (List<PersonaMedio>)datosS.get("medioscontacto");
    }
    String imagen = "proveedoresB.png";
    List<Titulo> titulos = (List<Titulo>)datosS.get("titulos");
    List<TipoMedio> tiposmedios = (List<TipoMedio>)datosS.get("tiposmedios");
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
                        GESTIONAR PROVEEDORES
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoConCli" name="frmNuevoConCli" action="<%=CONTROLLER%>/Gestionar/Proveedores" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="60%" align="center">
                            <tr>
                                <td width="100%">
                                    <table width="100%">
                                        <tr>
                                            <td width="34%">
                                                <span class="etiquetaB">Nombre:</span><br>
                                                <input id="nombreCon" name="nombreCon" class="text" type="text" value="<%=nombre%>" style="width: 200px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="30"/>
                                            </td>
                                            <td width="34%">
                                                <span class="etiquetaB">Paterno:</span><br>
                                                <input id="paternoCon" name="paternoCon" class="text" type="text" value="<%=paterno%>" style="width: 200px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="30"/>
                                            </td>
                                            <td width="33%">
                                                <span class="etiquetaB">Materno:</span><br>
                                                <input id="maternoCon" name="maternoCon" class="text" type="text" value="<%=materno%>" style="width: 200px"
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
                                                    <option value="F" <%if(sexo.equals("F")){%>selected<%}%>>FEMENINO</option>
                                                    <option value="M" <%if(sexo.equals("M")){%>selected<%}%>>MASCULINO</option>
                                                </select>
                                            </td>
                                            <td width="25%">
                                                <span class="etiquetaB">Titulo:</span><br>
                                                <select id="tituloCon" name="tituloCon" class="combo" style="width: 150px">
                                                    <option value="">NINGUNO</option>
                                                    <%for (int t=0; t < titulos.size(); t++){
                                                        Titulo tit = titulos.get(t);
                                                    %>
                                                        <option value="<%=tit.getTitulo()%>" <%if(titcon.equals(tit.getTitulo())){%>selected<%}%>><%=tit.getTitulo()%></option>
                                                    <%}%>
                                                </select>
                                            </td>
                                            <td width="50%">
                                                <span class="etiquetaB">Cargo:</span><br>
                                                <input id="cargoCon" name="cargoCon" class="text" type="text" value="<%=cargocon%>" style="width: 300px"
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
                                                <select id="lstipos" name="lstipos" class="combo" multiple size="5" onclick="Selecciona(this)" style="width:200px">
                                                    <%if (accion.equals("editar")){
                                                        for (int i=0; i < medios.size(); i++){
                                                            PersonaMedio pm = medios.get(i);
                                                            String color = "#FFFFFF";
                                                            if (i%2==0){
                                                                color = "#99FF66";
                                                            }
                                                        %>
                                                        <option value="<%=pm.getMedio().getTipo().getIdtipomedio()%>" style="background-color: <%=color%>">
                                                            <%=pm.getMedio().getTipo().getTipomedio()%>
                                                        </option>
                                                        <%}
                                                    }
                                                    %>
                                                </select>
                                            </td>
                                            <td width="35%" valign="top">
                                                <select id="lstels" name="lstels" class="combo" multiple size="5" onclick="Selecciona(this)" style="width:200px">
                                                    <%if (accion.equals("editar")){
                                                        for (int i=0; i < medios.size(); i++){
                                                            PersonaMedio pm = medios.get(i);
                                                            String color = "#FFFFFF";
                                                            if (i%2==0){
                                                                color = "#99FF66";
                                                            }
                                                        %>
                                                        <option value="<%=pm.getMedio().getMedio()%>" style="background-color: <%=color%>">
                                                            <%=pm.getMedio().getFormatoTelefono()%>
                                                        </option>
                                                        <%}
                                                    }
                                                    %>
                                                </select>
                                            </td>
                                            <td width="30%" valign="top">                                    
                                                <select id="lsexts" name="lsexts" class="combo" multiple size="5" onclick="Selecciona(this)" style="width:100px">
                                                    <%if (accion.equals("editar")){
                                                        for (int i=0; i < medios.size(); i++){
                                                            PersonaMedio pm = medios.get(i);
                                                            String color = "#FFFFFF";
                                                            if (i%2==0){
                                                                color = "#99FF66";
                                                            }
                                                        %>
                                                        <option value="<%=pm.getMedio().getExtension()%>" style="background-color: <%=color%>">
                                                            <%=pm.getMedio().getExtension()%>
                                                        </option>
                                                        <%}
                                                    }
                                                    %>
                                                </select>
                                                <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                                    onclick="QuitarMedio()" title="Quitar los medios seleccionados" onmouseover="this.style.cursor='pointer'"/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br><br>
                        <!--botones-->
                        <table width="100%">
                            <tr>
                                <td width="80%" align="right">
                                    <a id="btnGuardar" href="javascript: GuardarClick()"
                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar contacto del cliente">
                                        Guardar
                                    </a>
                                </td>
                                <td width="20%">
                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                        background: indianred 50% bottom repeat-x;" title="Cancelar cambios del contacto">
                                        Cancelar
                                    </a>
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
            function QuitarMedio(){
                var lstipos = document.getElementById('lstipos');
                var lstels = document.getElementById('lstels');
                var lsexts = document.getElementById('lsexts');
                var pos = lstipos.selectedIndex;
                lstipos.remove(pos);
                lstels.remove(pos);
                lsexts.remove(pos);
            }
            
            function Selecciona(lista){
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
                
                //muestra info para editar del medio seleccionado
                var tipom = document.getElementById('tipomedio');
                var tel = document.getElementById('telCon');
                var mail = document.getElementById('mail');
                var ext = document.getElementById('extCon');
                
                for (i=0; i < tipom.length; i++){
                    if (tipom.options[i].value==lstipos.options[pos].value)
                        tipom.options[i].selected = true;
                }
                
                if (lstipos.options[pos].value!=3){
                    tel.style.display = '';
                    mail.style.display = 'none';
                    tel.value = lstels.options[pos].value;
                } else {
                    tel.style.display = 'none';
                    mail.style.display = '';
                    mail.value = lstels.options[pos].value;
                }
                
                if (lstipos.options[pos].value==1)
                    ext.readOnly = false;
                else
                    ext.readOnly = true;
                ext.value = lsexts.options[pos].value;
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
                        //MostrarMensaje('El medio ya existe');
                        lsexts.options[i] = new Option(ext.value, ext.value);
                        tipo.options[0].selected = true;
                        medio.value = '';
                        ext.value = '';                        
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
                    lstels.options[pos] = new Option(telefono(medio.value), medio.value);
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
            
            function CancelarClick(){
                var frm = document.getElementById('frmNuevoConCli');
                frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/nuevoproveedor.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
            
            function MarcaMedios(){
                var lstipos = document.getElementById('lstipos');
                var lstels = document.getElementById('lstels');
                var lsexts = document.getElementById('lsexts');
                for (i=0; i < lstipos.length; i++){
                    lstipos.options[i].selected = true;
                    lstels.options[i].selected = true;
                    lsexts.options[i].selected = true;
                }
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    MarcaMedios();
                    var frm = document.getElementById('frmNuevoConCli');
                    frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/nuevoproveedor.jsp';
                    frm.pasoSig.value = '13';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var nombre = document.getElementById('nombreCon');
                if (nombre.value == ''){
                    nombre.focus();
                    MostrarMensaje('Debe ingresar el nombre del contacto');
                    return false;
                }
                
                /*var pat = document.getElementById('paternoCon');
                if (pat.value == ''){
                    pat.focus();
                    MostrarMensaje('Debe ingresar el apellido paterno del contacto');
                    return false;
                }*/
                
                var lstipos = document.getElementById('lstipos');
                if (lstipos.length == 0){
                    MostrarMensaje('Debe ingresar al menos un medio de contacto');
                    return false;
                }
                
                return true;
            }
        </script>
    </body>
</html>