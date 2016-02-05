<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Plaza"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Plaza> listado = new ArrayList<Plaza>();//(List<Cliente>)datosS.get("listado");
NumberFormat formato = new DecimalFormat("#,##0.00");

//if (paso != 0){
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
String matriz = datosS.get("matriz").toString();
int irpagant = Integer.parseInt(datosS.get("irpagant")!=null?datosS.get("irpagant").toString():"0");
Cliente clisel = new Cliente();
Contrato consel = new Contrato();
CentroDeTrabajo ctsel = new CentroDeTrabajo();
int vigentes = Integer.parseInt(datosS.get("vigentes")!=null?datosS.get("vigentes").toString():"-1");
if (paso==-2 || paso==-4)
    clisel = (Cliente)datosS.get("clienteSel");
if (paso==-3){
    clisel = (Cliente)datosS.get("clienteSel");
    consel = (Contrato)datosS.get("editarContrato");
}
if (paso>0){
    clisel = (Cliente)datosS.get("clienteSel");
    consel = (Contrato)datosS.get("editarContrato");
    ctsel = (CentroDeTrabajo)datosS.get("centro");
    listado = (List<Plaza>)datosS.get("plazas");
}
int banhis = Integer.parseInt(datosS.get("banhis")!=null?datosS.get("banhis").toString():"0");
int exter = Integer.parseInt(datosS.get("externas")!=null?datosS.get("externas").toString():"0");
//}
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaini" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechafin" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechaini2" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechafin2" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });

        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnReporteSat" ).button({
                icons: {
                    primary: "ui-icon-calculator"
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
        <%
        if (irpagant==0){
        %>
        <table width="100%">
            <tr>
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>
        <% } %>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Plazas/plazasA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        REPORTE DE PLAZAS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarPlz" name="frmGestionarPlz" action="<%=CONTROLLER%>/Gestionar/Plazas" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idPlz" name="idPlz" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="30%" align="left">
                                                <input id="rdopc" name="rdopc" value="0" type="radio" onclick="ChecaOpcion(this.value)" checked/><span class="etiquetaB">Reporte de plazas
                                            </td>
                                            <td width="30%" align="left">
                                                <input id="rdopc" name="rdopc" value="1" type="radio" onclick="ChecaOpcion(this.value)"/><span class="etiquetaB">Reporte SAT
                                            </td>
                                            <td width="25%" align="left">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <table id="repplazas" width="100%">
                                        <tr>
                                            <td width="15%" align="left">&nbsp;</td>
                                            <td width="70%" align="center">
                                                <table width="100%">
                                                    <tr>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Sucursal:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="sucursal" name="sucursal" class="combo" style="width: 250px"
                                                                    onchange="CargaClientes()" <%if (matriz.equals("0")){%>disabled<%}%>>
                                                            <%
                                                                List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                                if (sucursales!=null){
                                                                    if (sucursales.size()!=0){
                                                                        for (int i=0; i < sucursales.size(); i++){
                                                                            Sucursal suc = sucursales.get(i);
                                                                        %>
                                                                            <option value="<%=suc.getId()%>"
                                                                                <%
                                                                                if (sucSel.getId()==suc.getId()){
                                                                                %>
                                                                                    selected
                                                                                <%
                                                                                }
                                                                                %>
                                                                                >
                                                                                <%=suc.getDatosfis().getRazonsocial()%>
                                                                            </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                }
                                                            %>
                                                            </select>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Cliente:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="cliente" name="cliente" class="combo" style="width: 400px"
                                                                    onchange="CargaContratos()">
                                                                <option value="0">Elija el Cliente...</option>
                                                            <%
                                                                List<Cliente> clientes = (List<Cliente>)datosS.get("clientes");
                                                                if (clientes!=null){
                                                                    if (clientes.size()!=0){
                                                                        for (int i=0; i < clientes.size(); i++){
                                                                            Cliente cli = clientes.get(i);
                                                                        %>
                                                                            <option value="<%=cli.getId()%>"
                                                                                <%
                                                                                if (clisel.getId()==cli.getId()){
                                                                                %>
                                                                                    selected
                                                                                <%
                                                                                }
                                                                                %>
                                                                                >
                                                                                <%=cli.getTipo()==0?cli.getDatosFiscales().getRazonsocial():cli.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                                            </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                }
                                                            %>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Contrato:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="contrato" name="contrato" class="combo" style="width: 250px"
                                                                    onchange="CargaCT()">
                                                                <option value="0">Elija el Contrato...</option>
                                                                <%if (vigentes==1){%>
                                                                    <option value="-1">Ver Histórico...</option>
                                                                <%}else if (vigentes==0){%>
                                                                    <option value="-2">Ver Vigentes...</option>
                                                                <%}%>
                                                            <%
                                                                List<Contrato> contratos = (List<Contrato>)datosS.get("contratos");
                                                                if (contratos!=null){
                                                                    if (contratos.size()!=0){
                                                                        for (int i=0; i < contratos.size(); i++){
                                                                            Contrato con = contratos.get(i);
                                                                        %>
                                                                            <option value="<%=con.getId()%>"
                                                                                <%
                                                                                if (consel.getId()==con.getId()){
                                                                                %>
                                                                                    selected
                                                                                <%
                                                                                }
                                                                                %>
                                                                                >
                                                                                <%=con.getDescripcion()%>
                                                                            </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                }
                                                            %>
                                                            </select>
                                                            <% if (banhis==1){%>
                                                            <br><span class="etiquetaC">(CONCLUIDO)</span>
                                                            <%}%>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">C.T.:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="ctrab" name="ctrab" class="combo" style="width: 350px">
                                                                <option value="0">Elija el Centro de Trabajo...</option>
                                                            <%
                                                                List<CentroDeTrabajo> centros = (List<CentroDeTrabajo>)datosS.get("centros");
                                                                if (centros!=null){
                                                                    if (centros.size()!=0){
                                                                        for (int i=0; i < centros.size(); i++){
                                                                            CentroDeTrabajo ct = centros.get(i);
                                                                        %>
                                                                            <option value="<%=ct.getId()%>"
                                                                                <%
                                                                                if (ctsel.getId()==ct.getId()){
                                                                                %>
                                                                                    selected
                                                                                <%
                                                                                }
                                                                                %>
                                                                                >
                                                                                <%=ct.getNombre()%>
                                                                            </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                }
                                                            %>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Cotiza:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="cotiza" name="cotiza" class="combo" style="width:150px">
                                                                <option value="-1">TODOS</option>
                                                                <option value="1">SÍ</option>
                                                                <option value="0">NO</option>
                                                            </select>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Estatus Empleados:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="estatus" name="estatus" class="combo" style="width:150px">
                                                                <option value="-1">TODOS</option>
                                                                <option value="1">ACTIVO</option>
                                                                <option value="0">BAJA</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Fecha Inicio:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <input id="fechaini" name="fechaini" type="text" class="text" readonly value=""
                                                                title="Ingrese la fecha de inicio"/>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Fecha Fin:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <input id="fechafin" name="fechafin" type="text" class="text" readonly value=""
                                                                title="Ingrese la fecha de fin"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Empleados asignados a plazas de la Sucursal">
                                                    Imprimir
                                                </a>
                                            </td>
                                        </tr>
                                    </table><!--fin tabla salir sucursal cliente contrato ct -->
                                    <table id="repsat" width="100%" style="display: none">
                                        <tr>
                                            <td width="15%" align="left">&nbsp;</td>
                                            <td width="70%" align="center">
                                                <table width="100%">
                                                    <tr>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Registro patronal:</span>
                                                        </td>
                                                        <td width="24%" align="left">
                                                            <select id="sucursal" name="sucursal" class="combo" style="width: 250px">
                                                            <%
                                                                //List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                                if (sucursales!=null){
                                                                    if (sucursales.size()!=0){
                                                                        for (int i=0; i < sucursales.size(); i++){
                                                                            Sucursal suc = sucursales.get(i);
                                                                        %>
                                                                            <option value="<%=suc.getId()%>"
                                                                                <%
                                                                                if (sucSel.getId()==suc.getId()){
                                                                                %>
                                                                                    selected
                                                                                <%
                                                                                }
                                                                                %>
                                                                                >
                                                                                <%=suc.getRegistropatronal()%>
                                                                            </option>
                                                                        <%
                                                                        }
                                                                    }
                                                                }
                                                            %>
                                                            </select>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Fecha Inicio:</span>
                                                        </td>
                                                        <td width="23%" align="left">
                                                            <input id="fechaini2" name="fechaini2" type="text" class="text" readonly value=""
                                                                title="Ingrese la fecha de inicio"/>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Fecha Fin:</span>
                                                        </td>
                                                        <td width="23%" align="left">
                                                            <input id="fechafin2" name="fechafin2" type="text" class="text" readonly value=""
                                                                title="Ingrese la fecha de fin"/>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnReporteSat" href="javascript: ReporteSatClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Reporte SAT">
                                                    Reporte SAT
                                                </a>
                                            </td>
                                        </tr>
                                    </table><!--fin tabla salir sucursal cliente contrato ct -->
                                </td><!--fin del contenido-->
                            </tr>
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
            function ChecaOpcion(opc){
                var repplazas = document.getElementById('repplazas');
                var repsat = document.getElementById('repsat');
                if (opc=='1'){
                    repplazas.style.display = 'none';
                    repsat.style.display = '';
                } else {
                    repplazas.style.display = '';
                    repsat.style.display = 'none';
                }
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
                var cliente = document.getElementById('cliente');
                var btnRepSat = document.getElementById('btnReporteSat');
                btnRepSat.style.display = '';
                if (cliente.value!='0'){
                    btnRepSat.style.display = 'none';
                }
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function CargaClientes(){
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                paso.value = '-1';
                pagina.value = '/Nomina/Plazas/reportedeplazas.jsp';
                frm.submit();
            }
            
            function CargaContratos(){
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/reportedeplazas.jsp';
                paso.value = '-2';
                frm.submit();                    
            }
            
            function CargaCT(){
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/reportedeplazas.jsp';
                var con = document.getElementById('contrato');
                if (con.value=='-1'){
                    paso.value = '-4';
                } else if (con.value=='-2'){
                    paso.value = '-2';
                } else {
                    paso.value = '-3';
                }
                frm.submit();                
            }
            
            function ImprimirClick(){
                var suc = document.getElementById('sucursal');
                var cli = document.getElementById('cliente');
                var con = document.getElementById('contrato');
                var ct = document.getElementById('ctrab');
                var cot = document.getElementById('cotiza');
                var est = document.getElementById('estatus');
                var fini = document.getElementById('fechaini');
                var ffin = document.getElementById('fechafin');
                if (fini.value==''){
                    MostrarMensaje('Debe indicar la fecha inicial del período');
                    return;
                }
                if (ffin.value==''){
                    MostrarMensaje('Debe indicar la fecha final del período');
                    return;
                }
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Plazas'+'&paso=18&dato1='+suc.value+'&dato2='+cli.value+
                        '&dato3='+con.value+'&dato4='+ct.value+'&dato5='+cot.value+'&dato6='+est.value+'&dato7='+fini.value+'&dato8='+ffin.value,
                    '','width =800, height=600, left=0, top = 0, resizable= yes');
            }
            
            function ReporteSatClick(){
                var suc = document.getElementById('sucursal');
                var fini = document.getElementById('fechaini2');
                var ffin = document.getElementById('fechafin2');
                if (fini.value==''){
                    MostrarMensaje('Debe indicar la fecha inicial del período');
                    return;
                }
                if (ffin.value==''){
                    MostrarMensaje('Debe indicar la fecha final del período');
                    return;
                }
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Plazas'+'&paso=19&dato1='+suc.value+'&dato2='+fini.value+'&dato3='+ffin.value,
                    '','width =800, height=600, left=0, top = 0, resizable= yes');
            }
            
        </script>
    </body>
</html>
