<%-- 
    Document   : documentacion
    Created on : 06-ene-2014, 13:02:33
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Documento, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal"%>
<%@page import="Modelo.Entidades.Catalogos.CategoriaDoc, Modelo.Entidades.Catalogos.TipoDocumento"%>
<%@page import="java.util.StringTokenizer"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Empleado> empleados = datosS.get("empleados")!=null?(List<Empleado>)datosS.get("empleados"):new ArrayList<Empleado>();
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
            $( "#btnObtener" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnCambiar" ).button({
                icons: {
                    primary: "ui-icon-refresh"
		}
            });
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
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
                    <img src="/siscaim/Imagenes/Personal/docsA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        IMPRIMIR DOCUMENTACIÓN DEL PERSONAL
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarDocs" name="frmGestionarDocs" action="<%=CONTROLLER%>/Gestionar/Documentacion" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="docs" name="docs" type="hidden" value=""/>
            <input id="emples" name="emples" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="15%">
                                    <a id="btnSalir" href="javascript: SalirClick()"
                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                        background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Clientes">
                                        Salir
                                    </a>                                    
                                </td>
                                <td width="55%">
                                </td>
                                <td width="15%">
                                    <a id="btnImprimir" href="javascript: Imprimir()"
                                        style="width: 180px; font-weight: bold; color: #0B610B; display: none" title="Imprimir los documentos de los empleados seleccionados">
                                        Imprimir Documentos
                                    </a>
                                </td>
                                <td width="15%">
                                    <a id="btnObtener" href="javascript: ObtenerEmpleados()"
                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Obtener los empleados que cumplan con los criterios">
                                        Obtener
                                    </a>
                                    <a id="btnCambiar" href="javascript: CambiarFiltros()"
                                        style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Obtener los empleados que cumplan con los criterios">
                                        Cambiar Filtros
                                    </a>
                                </td>
                            </tr>
                        </table>
                        <hr>
                        <div id="filtros">
                        <table width="70%" align="center">
                            <tr>
                                <td width="80%">
                                    <span class="etiquetaC">(Use la tecla Control presionada y haga clic en el Documento para seleccionar o deseleccionar)</span><br>
                                    <select id="documentos" name="documentos" class="lista" size="10"
                                            style="width: 600px" multiple>
                                        <%List<CategoriaDoc> cats = (List<CategoriaDoc>)datosS.get("categorias");
                                        for (int c=0; c < cats.size(); c++){
                                            CategoriaDoc cd = cats.get(c);
                                            List<TipoDocumento> tipos = (List<TipoDocumento>)datosS.get("tiposdoc");
                                            for (int t=0; t < tipos.size(); t++){
                                                TipoDocumento td = tipos.get(t);
                                                if (td.getCategoria().getId()==cd.getId()){
                                                %>
                                                    <option value="<%=td.getId()%>"><%=td.getDescripcion()%></option>
                                                <%}
                                            }
                                        }%>
                                    </select>
                                </td>
                                <td width="20%" valign="top" align="left">
                                    <select id="sucursal" name="sucursal" class="combo" style="width: 200px">
                                        <option value="">Elija la Sucursal...</option>
                                    <%
                                        List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                        for (int i=0; i < sucursales.size(); i++){
                                            Sucursal suc = sucursales.get(i);
                                        %>
                                            <option value="<%=suc.getId()%>">
                                                <%=suc.getDatosfis().getRazonsocial()%>
                                            </option>
                                        <%
                                        }
                                    %>
                                    </select><br><br>
                                    <select id="estatus" name="estatus" class="combo" style="width: 250px">
                                        <option value="">Elija el estatus de los empleados...</option>
                                        <option value="1">ACTIVOS</option>
                                        <option value="0">INACTIVOS</option>
                                        <option value="-1">TODOS</option>
                                    </select><br><br>
                                    <select id="cotiza" name="cotiza" class="combo" style="width: 250px">
                                        <option value="">Elija el estatus de cotización...</option>
                                        <option value="1">COTIZA</option>
                                        <option value="0">NO COTIZA</option>
                                        <option value="-1">TODOS</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        </div>
                        <%if (paso==1){%>
                        <div id="listado">
                            <%HashMap filtros = (HashMap)datosS.get("filtros");
                            int idsuc = Integer.parseInt(filtros.get("sucursal").toString());
                            String docs = filtros.get("documentos").toString();
                            StringTokenizer tkdocs = new StringTokenizer(docs,",");
                            String estatus = filtros.get("estatus").toString();
                            String cotiza = filtros.get("cotiza").toString();
                            %>
                            <table width="70%" align="center" frame="box">
                                <tr>
                                    <td width="20%" align="center">
                                        <span class="etiquetaB">Sucursal</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span class="etiquetaB">Estatus</span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span class="etiquetaB">Cotiza</span>
                                    </td>
                                    <td width="60%" align="center">
                                        <span class="etiquetaB">Documentos</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="20%" align="center">
                                        <span class="etiqueta">
                                            <%
                                            List<Sucursal> sucs = (List<Sucursal>)datosS.get("sucursales");
                                            for (int s=0; s < sucs.size(); s++){
                                                Sucursal suc = sucs.get(s);
                                                if (idsuc == suc.getId()){
                                                %>
                                                <%=suc.getDatosfis().getRazonsocial()%>
                                                <%}
                                            }
                                            %>
                                        </span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span class="etiqueta">
                                            <%if (estatus.equals("-1")){%>
                                                TODOS
                                            <%} else if (estatus.equals("0")) {%>
                                                INACTIVOS
                                            <%} else {%>
                                                ACTIVOS
                                            <%}%>
                                        </span>
                                    </td>
                                    <td width="10%" align="center">
                                        <span class="etiqueta">
                                            <%if (cotiza.equals("-1")){%>
                                                TODOS
                                            <%} else if (cotiza.equals("0")) {%>
                                                NO
                                            <%} else {%>
                                                S&Iacute;
                                            <%}%>
                                        </span>
                                    </td>
                                    <td width="60%" align="left">
                                        <span class="etiqueta">
                                        <%
                                        String sdocs = "";
                                        while(tkdocs.hasMoreTokens()){
                                            int iddoc = Integer.parseInt(tkdocs.nextToken());
                                            List<TipoDocumento> tipos = (List<TipoDocumento>)datosS.get("tiposdoc");
                                            for (int t=0; t < tipos.size(); t++){
                                                TipoDocumento td = tipos.get(t);
                                                if (td.getId()==iddoc){
                                                    if (sdocs.equals(""))
                                                        sdocs = td.getDescripcion();
                                                    else
                                                        sdocs += ", "+td.getDescripcion();
                                                }
                                            }
                                        }
                                        %>
                                        <%=sdocs%>
                                        </span>
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <table class="tablaLista" width="50%" align="center">
                                <%if (empleados.size()==0){%>
                                <tr>
                                    <td colspan="4" align="center">
                                        <span class="etiquetaB">
                                            No se encontraron empleados que cumplan los criterios establecidos
                                        </span>
                                    </td>
                                </tr>
                                <%} else {%>
                                <thead>
                                    <tr>
                                        <td align="center" width="10%">
                                            <input id="chkTodo" name="chkTodo" type="checkbox" checked
                                                    title="Marcar/Desmarcar Todos" onclick="CheckTodos(this)"/>
                                        </td>
                                        <td align="center" width="10%">
                                            <span>Clave</span>
                                        </td>
                                        <td align="center" width="60%">
                                            <span>Empleado</span>
                                        </td>
                                        <td align="center" width="10%">
                                            <span>Estatus</span>
                                        </td>
                                        <td align="center" width="10%">
                                            <span>Cotiza</span>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                <%    
                                    for (int i=0; i < empleados.size(); i++){
                                        Empleado emp = empleados.get(i);
                                %>
                                        <tr>
                                            <td align="center" width="10%">
                                                <span><%=i+1%></span>
                                                <input id="chkemp<%=i%>" value="<%=emp.getNumempleado()%>" type="checkbox" checked
                                                       onclick="VerificaCheckTodo()">
                                            </td>
                                            <td align="center" width="10%">
                                                <span><%=emp.getClave()%></span>
                                            </td>
                                            <td align="left" width="60%">
                                                <span><%=emp.getPersona().getNombreCompletoPorApellidos()%></span>
                                            </td>
                                            <td align="center" width="10%">
                                                <span><%=emp.getEstatus()==0?"INACTIVO":"ACTIVO"%></span>
                                            </td>
                                            <td align="center" width="10%">
                                                <span><%=emp.getCotiza()==0?"NO":"SÍ"%></span>
                                            </td>
                                        </tr>
                                    <%}%>
                                </tbody>
                                <%}%>
                            </table>
                        </div>
                        <%}%>
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
                <%}%> 
                var filtros = document.getElementById('filtros');
                var lista = document.getElementById('listado');
                var btnObt = document.getElementById('btnObtener');
                var btnFil = document.getElementById('btnCambiar');
                var btnImp = document.getElementById('btnImprimir');
                <%if (paso==0){%>
                     filtros.style.display = '';
                     lista.style.display = 'none';
                     btnObt.style.display = '';
                     btnFil.style.display = 'none';
                     btnImp.style.display = 'none';
                <%} else if (paso == 1){%>
                     filtros.style.display = 'none';
                     lista.style.display = '';
                     btnObt.style.display = 'none';
                     btnFil.style.display = '';
                     btnImp.style.display = '';
                <%}%>
            }

            function SalirClick(){
                var frm = document.getElementById('frmGestionarDocs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }

            function ValidaRequeridos(){
                var docus = document.getElementById('documentos');
                var docs = document.getElementById('docs');
                docs.value = '';
                for (i=0; i < docus.length; i++){
                    if (docus.options[i].selected){
                        if (docs.value=='')
                            docs.value = docus.options[i].value;
                        else
                            docs.value += ','+docus.options[i].value;
                    }
                }
                
                if (docs.value == ''){
                    MostrarMensaje('Debe seleccionar al menos un Documento');
                    return false;
                }
                
                var suc = document.getElementById('sucursal');
                if (suc.value==''){
                    MostrarMensaje('Debe especificar la sucursal');
                    return false;
                }
                
                var estatus = document.getElementById('estatus');
                if (estatus.value == ''){
                    MostrarMensaje('Debe especificar el estatus de los empleados');
                    return false;
                }
                
                var cot = document.getElementById('cotiza');
                if (cot.value == ''){
                    MostrarMensaje('Debe especificar el estatus de cotización');
                    return false;
                }
                return true;
            }
            
            function ObtenerEmpleados(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmGestionarDocs');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Nomina/Personal/GestionarPersonal/Documentacion/documentacion.jsp';
                    paso.value = '1';
                    frm.submit();
                }
            }
            
            function CheckTodos(obj){
            <%
                for (int i=0; i < empleados.size(); i++){
                %>
                    var chk = document.getElementById('chkemp<%=i%>');
                    if (obj.checked)
                        chk.checked = true;
                    else
                        chk.checked = false;
                <%
                }
            %>                
            }
            
            function VerificaCheckTodo(){
                var todos = true;
                var chkTodo = document.getElementById("chkTodo")
                <%
                for (int i=0; i < empleados.size(); i++){
                %>
                    var chk = document.getElementById('chkemp<%=i%>');
                    if (!chk.checked)
                        todos = false;
                <%
                }
                %>
                chkTodo.checked = todos;
            }
            
            function Imprimir(){
                var emples = document.getElementById('emples');
                emples.value = '';
                <%
                for (int i=0; i < empleados.size(); i++){
                %>
                    var chk = document.getElementById('chkemp<%=i%>');
                    if (chk.checked){
                        if (emples.value=='')
                            emples.value = chk.value;
                        else
                            emples.value += ','+chk.value;
                    }
                <%
                }
                %>                
                
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Documentacion'+'&paso=2&dato1='+emples.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
            }
            
            function CambiarFiltros(){
                var frm = document.getElementById('frmGestionarDocs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Documentacion/documentacion.jsp';
                paso.value = '3';
                frm.submit();
            }
        </script>
    </body>
</html>