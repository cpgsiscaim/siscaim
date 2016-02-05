<%-- 
    Document   : empleadosinactivos
    Created on : Jun 18, 2012, 11:44:37 AM
    Author     : roman
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- aqui poner los imports--%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, Modelo.Entidades.Persona, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
    HashMap datosS = sesion.getDatos();
    // List<Cliente> listado = new ArrayList<Cliente>();//(List<Cliente>)datosS.get("listado");
    List<Empleado> EmpleadoLst = new ArrayList<Empleado>();//(List<Cliente>)datosS.get("listado");
    Sucursal sucSel = (Sucursal)datosS.get("sucursal");
    SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
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
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnActivar" ).button({
                icons: {
                    primary: "ui-icon-arrowreturnthick-1-w"
		}
            });
            $( "#btnFiniquito" ).button({
                icons: {
                    primary: "ui-icon-wrench"
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
                    <img src="/siscaim/Imagenes/Personal/empleadosD.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="titulo" align="left">
                        EMPLEADOS DADOS DE BAJA
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmEmpInactivos" name="frmEmpInactivos" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idEmp" name="idEmp" type="hidden" value=""/>
            <input id="fila" name="fila" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">                                
                <tr>
                    <td width="100%" valign="top">
                            <!--aquí poner el contenido de la jsp --> 
                            <table width="100%">
                                <tr>
                                    <%-- Boton Cancelar --%>
                                    <td width="50%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                    </td>
                                    <td width="30%" align="right">
                                        &nbsp;
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnFiniquito" href="javascript: FiniquitoClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Activar">
                                            Finiquito
                                        </a>
                                    </td>
                                    <td width="15%" align="right">
                                        <a id="btnActivar" href="javascript: AltaEmpClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Activar">
                                            Activar
                                        </a>
                                    </td>
                                </tr>
                            </table>
                            <hr>        
                            <%-- Tabla de Datos --%>
                            <table class="tablaLista" width="100%">
                             <%
                                EmpleadoLst = (List<Empleado>) datosS.get("inactivos");
                                if (EmpleadoLst.size()==0){
                             %>
                                <tr>
                                    <td colspan="4" align="center">
                                        <span class="etiquetaB">
                                            No hay Empleados Inactivos en la Sucursal seleccionada
                                        </span>
                                    </td>
                                </tr>
                             <%
                                } else {
                             %>
                                <thead>
                                <tr>
                                    <td width="10%" align="center" colspan="2">
                                        <span>Clave</span>
                                    </td>
                                    <td width="35%" align="center">
                                        <span>Nombre</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>CURP</span>
                                    </td>
                                    <td width="15%" align="center">
                                        <span>Ciudad</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>Estado</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>Fecha de alta</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span>Fecha de baja</span>
                                    </td>
                                </tr>
                                </thead>
                                                         
                            <tbody>
                                            <%
                                            //int nper = EmpleadoLst.size();
                                            for (int i=0; i < EmpleadoLst.size(); i++){
                                                Empleado p = (Empleado)EmpleadoLst.get(i);
                                                String sfechabaja = "", sfechaalta = "";
                                                if (p.getFechabaja()!=null)
                                                    sfechabaja = ffecha.format(p.getFechabaja());
                                                if (p.getFecha()!=null)
                                                    sfechaalta = ffecha.format(p.getFecha());
                                            %>
                                            <tr onclick="Activa(<%=i%>)" ondblclick="VerFicha(<%=i%>)">
                                                <td align="center" width="3%">
                                                    <input id="radioEmp" name="radioEmp" type="radio" value="<%=p.getNumempleado()%>"/>
                                                </td>
                                                <td align="left" width="7%">
                                                    <span class="etiqueta"><%=p.getClave()%></span>
                                                    <img src="/siscaim/Imagenes/Personal/Fotos/<%=p.getImagen()%>" width="20" height="20"/>
                                                </td>
                                                <td width="35%" align="left">
                                                    <span class="etiqueta"><%=p.getPersona().getNombreCompletoPorApellidos()%></span>
                                                </td>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=p.getPersona().getCurp()%></span>
                                                </td>
                                                <td width="15%" align="center">
                                                    <span class="etiqueta"><%=p.getPersona().getDireccion().getPoblacion().getMunicipio()%></span>
                                                </td>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=p.getPersona().getDireccion().getPoblacion().getEstado().getEstado()%></span>
                                                </td>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=sfechaalta%></span>
                                                </td>
                                                <td width="10%" align="center">
                                                    <span class="etiqueta"><%=sfechabaja%></span>
                                                </td>
                                            </tr>
                                            <%
                                            } //Fin for
                                            %>                                        
                             </tbody>
                             <% } %>
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
                HttpSession sesionHttp = request.getSession();
                if (sesion.isError())
                    sesion.setError(false);
                if (sesion.isExito())
                    sesion.setExito(false);
                sesionHttp.setAttribute("sesion", sesion);            
            %>                    
        }                   

       
            function Activa(fila){
                var idEmp = document.getElementById('idEmp');
                var f = document.getElementById('fila');
                var btnActivar = document.getElementById('btnActivar');
                var btnFin = document.getElementById('btnFiniquito');
                btnActivar.style.display = '';
                btnFin.style.display = '';
                f.value = fila;
                <%
                if (EmpleadoLst.size()==1){
                %>
                    //document.frmGestionarCli.radioCli.checked = true;
                    document.frmEmpInactivos.radioEmp.checked = true;
                    //idCli.value = document.frmGestionarCli.radioCli.value;
                    idEmp.value = document.frmEmpInactivos.radioEmp.value;
                <%
                } else {
                %>
                    var radio = document.frmEmpInactivos.radioEmp[fila];//document.frmGestionarCli.radioCli[fila];
                    radio.checked = true;
                    idEmp.value = radio.value;
                <% } %>
            }

            function AltaEmpClick(){
                Espera();
                var frm = document.getElementById('frmEmpInactivos');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp';
                paso.value = '8';
                frm.submit();                
            }
            
             function CancelarClick(){
                var frm = document.getElementById('frmEmpInactivos');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function FiniquitoClick(){
                //valida que el empleado tenga fecha de baja registrada
                var fila = document.getElementById('fila');
                <%
                    for (int i=0; i < EmpleadoLst.size(); i++){
                        Empleado p = (Empleado)EmpleadoLst.get(i);
                        String sfb = "", sfa = "";
                        if (p.getFechabaja()!=null)
                            sfb = ffecha.format(p.getFechabaja());
                        if (p.getFecha()!=null)
                            sfa = ffecha.format(p.getFecha());
                %>
                        if ('<%=i%>'==fila.value){
                            if ('<%=sfb%>'==''){
                                MostrarMensaje('El empleado no tiene fecha de baja registrada. Activelo y registre la fecha');
                                return;
                            }
                            if ('<%=sfa%>'==''){
                                MostrarMensaje('El empleado no tiene fecha de alta registrada. Activelo y registre la fecha');
                                return;
                            }
                        }
                <%}%>
                Espera();
                var frm = document.getElementById('frmEmpInactivos');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/generarfiniquito.jsp';
                frm.pasoSig.value = '28';
                frm.submit();
            }
            
            function VerFicha(fila){
                var idEmp = document.getElementById('idEmp');
                <%
                if (EmpleadoLst.size()==1){
                %>
                    idEmp.value = document.frmEmpInactivos.radioEmp.value;
                <%
                } else {
                %>
                    var radio = document.frmEmpInactivos.radioEmp[fila];
                    idEmp.value = radio.value;
                <% } %>
                Espera();
                var paginaSig = document.getElementById("paginaSig");
                paginaSig.value = "/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp";
                var pasoSig = document.getElementById("pasoSig");
                pasoSig.value = "45";
                var frm = document.getElementById('frmEmpInactivos');
                frm.submit();
            }
        </script>
    </body>
</html>
