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
int irpagant = Integer.parseInt(datosS.get("origenplazas")!=null?"1":"0");
Cliente clisel = new Cliente();
Contrato consel = new Contrato();
CentroDeTrabajo ctsel = new CentroDeTrabajo();
int vigentes = Integer.parseInt(datosS.get("vigentes")!=null?datosS.get("vigentes").toString():"-1");
if (paso==-2 || paso==-4){
    clisel = (Cliente)datosS.get("clienteSel");
}
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
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnMovExtra" ).button({
                icons: {
                    primary: "ui-icon-bookmark"
		}
            });
            $( "#btnSustituir" ).button({
                icons: {
                    primary: "ui-icon-transferthick-e-w"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnPlazasExt" ).button({
                icons: {
                    primary: "ui-icon-home"
		}
            });
            $( "#btnPlazasLoc" ).button({
                icons: {
                    primary: "ui-icon-home"
		}
            });
            $( "#btnRecalcular" ).button({
                icons: {
                    primary: "ui-icon-calculator"
		}
            });
            $( "#btnVacas" ).button({
                icons: {
                    primary: "ui-icon-note"
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
                        GESTIONAR PLAZAS <%if (irpagant==1){%> DE CENTRO DE TRABAJO <%} else if (exter==1){%> EXTERNAS <%}%>
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
                                            <td width="13%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="13%" align="left">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Empleados asignados a plazas de la Sucursal">
                                                    Imprimir
                                                </a><br>
                                                <input id="xls" name="xls" type="checkbox">
                                                <span class="etiqueta">Imprimir en Excel</span>                                                            
                                            </td>
                                            <td width="60%" align="center">
                                                <table width="100%">
                                                    <tr>
                                                        <td width="10%" align="left">
                                                            <span class="etiquetaB">Sucursal:</span>
                                                        </td>
                                                        <td width="40%" align="left">
                                                            <select id="sucursal" name="sucursal" class="combo" style="width: 250px"
                                                                    onchange="CargaClientes()" <%if (matriz.equals("0") || irpagant==1){%>disabled<%}%>>
                                                                <option value="0">Elija la Sucursal...</option>
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
                                                                    onchange="CargaContratos()" <%if (irpagant==1){%>disabled<%}%>>
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
                                                                    onchange="CargaCT()" <%if (irpagant==1){%>disabled<%}%>>
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
                                                            <select id="ctrab" name="ctrab" class="combo" style="width: 350px"
                                                                    onchange="CargaPlazas()" <%if (irpagant==1){%>disabled<%}%>>
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
                                                </table>
                                            </td>
                                            <td width="14%" align="right">
                                                <a id="btnPlazasExt" href="javascript: PlazasExtClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Obtener Plazas externas">
                                                    Plazas Externas
                                                </a>
                                                <a id="btnPlazasLoc" href="javascript: PlazasLocClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Mostrar Plazas locales">
                                                    Plazas Locales
                                                </a>
                                            </td>
                                        </tr>
                                    </table><!--fin tabla salir sucursal cliente contrato ct -->
                                    <%if (paso>0){%>
                                    <hr>
                                    <%}%>
                                    <!--botones de acciones -->
                                    <table id="acciones" align="center" width="100%" style="display: none">
                                        <tr>
                                            <td width="10%" align="left">
                                                <a id="btnInactivos" href="javascript: VerInactivas()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar plazas dadas de baja">
                                                    Ver Inactivas
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnRecalcular" href="javascript: RecalcularMovsExtras()"
                                                    style="width: 200px; font-weight: bold; color: #0B610B;" title="Recalcular Movimientos Extraordinarios de Todas las plazas">
                                                    Recalcular Movs. Extras
                                                </a>
                                            </td>
                                            <td width="60%" align="center">
                                                <table id="editar" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="20%" align="right">
                                                            <a id="btnVacas" href="javascript: VacacionesClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Vacaciones del Empleado seleccionado">
                                                                Vacaciones
                                                            </a>
                                                        </td>                                                        
                                                        <td width="20%" align="right">
                                                            <a id="btnMovExtra" href="javascript: MovExtrasClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Movimientos extraordinarios de la plaza seleccionada">
                                                                Movs. Extras
                                                            </a>
                                                        </td>
                                                        <td width="20%" align="right">
                                                            <a id="btnSustituir" href="javascript: SustituirClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Sustituir la plaza seleccionada">
                                                                Sustituir
                                                            </a>
                                                        </td>
                                                        <td width="20%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja de la plaza seleccionada">
                                                                Baja
                                                            </a>
                                                        </td>
                                                        <td width="20%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar la plaza seleccionada">
                                                                Editar
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevaClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Nueva plaza">
                                                    Nueva
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <!--fin botones de acciones -->
                                    <hr>
                                    <!--listado-->
                                    
                                    <%
                                    if (paso>0){
                                        if (listado.size()==0){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Plazas registradas
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        <%
                                        } else {
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <thead>
                                                    <tr>
                                                        <td align="center" width="34%" colspan="3">
                                                            <span>Empleado</span>
                                                        </td>
                                                        <td align="center" width="16%">
                                                            <span>Puesto</span>
                                                        </td>
                                                        <td align="center" width="12%">
                                                            <span>Alta</span>
                                                        </td>
                                                        <td align="center" width="12%">
                                                            <span>Sueldo</span>
                                                        </td>
                                                        <td align="center" width="16%">
                                                            <span>Forma de Pago</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Período de Pago</span>
                                                        </td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <%
                                                for (int i=0; i < listado.size(); i++){
                                                    Plaza pl = listado.get(i);
                                                    String falta = pl.getFechaalta().toString();
                                                    String faltanorm = falta.substring(8,10) + "-" + falta.substring(5,7) + "-" + falta.substring(0, 4);
                                                    String formapago = "";
                                                    switch (pl.getFormapago()){
                                                        case 1:
                                                            formapago = "DEPOSITO";
                                                            break;
                                                        case 2:
                                                            formapago = "EFECTIVO";
                                                            break;
                                                        case 3:
                                                            formapago = "TELECOMM";
                                                            break;
                                                    }
                                                %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="3%">
                                                            <input id="radioPlz" name="radioPlz" type="radio" value="<%=pl.getId()%>"/>
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <span class="etiqueta"><%=pl.getEmpleado().getClave()%></span>
                                                        </td>
                                                        <td align="left" width="26%">
                                                            <span class="etiqueta"><%=pl.getEmpleado().getPersona().getNombreCompletoPorApellidos()%></span>
                                                        </td>
                                                        <td align="center" width="16%">
                                                            <span class="etiqueta"><%=pl.getPuesto().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="12%">
                                                            <span class="etiqueta"><%=faltanorm%></span>
                                                        </td>
                                                        <td align="right" width="12%">
                                                            <span class="etiqueta"><%=formato.format(pl.getSueldo())%></span>
                                                        </td>
                                                        <td align="center" width="16%">
                                                            <span class="etiqueta"><%=formapago%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=pl.getPeriodopago().getDescripcion()%></span>
                                                        </td>
                                                    </tr>
                                                <%
                                                }
                                                %>
                                                </tbody>
                                            </table>
                                        <%  
                                        }//if listado=0
                                    }//if paso!=0
                                    %>
                                    <!--fin listado-->
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
                if (paso>0 && banhis==0){
                %>
                    var acciones = document.getElementById('acciones');
                    acciones.style.display = '';
                <%
                }
                %>
                var suc = document.getElementById('sucursal');
                var impr = document.getElementById('btnImprimir');
                if (suc.value=='0'){
                    impr.style.display = 'none';
                }
                <%if (matriz.equals("1")){%>
                    var btnPlzExt = document.getElementById('btnPlazasExt');
                    btnPlzExt.style.display = 'none';
                <%} if (exter==1){%>
                    var btnPlzExt = document.getElementById('btnPlazasExt');
                    btnPlzExt.style.display = 'none';
                    var btnPlzLoc = document.getElementById('btnPlazasLoc');
                    btnPlzLoc.style.display = '';
                <%} else if (matriz.equals("0")){%>
                    var btnPlzExt = document.getElementById('btnPlazasExt');
                    btnPlzExt.style.display = '';
                    var btnPlzLoc = document.getElementById('btnPlazasLoc');
                    btnPlzLoc.style.display = 'none';
                <%}%>
            }
            
            function Activa(fila){
                var idPlz = document.getElementById('idPlz');
                var editar = document.getElementById('editar');
                editar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarPlz.radioPlz.checked = true;
                    idPlz.value = document.frmGestionarPlz.radioPlz.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarPlz.radioPlz[fila];
                    radio.checked = true;
                    idPlz.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                <%if (datosS.get("origenplazas")!=null){%>
                     pagina.value = '<%=datosS.get("origenplazas").toString()%>';
                <%}%>
                paso.value = '99';
                frm.submit();                
            }
            
            function ValidaTopePersonal(){
            <%if (ctsel.getPersonal()>listado.size()){%>
                 return true;
            <%} else {%>
                MostrarMensaje('No se pueden agregar más plazas al CT seleccionado');
                return false;
            <%}%>
            }
            
            function NuevaClick(){
                if (ValidaTopePersonal()){
                    Espera();
                    var frm = document.getElementById('frmGestionarPlz');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Nomina/Plazas/nuevaplaza.jsp';
                    paso.value = '2';
                    frm.submit();
                }
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/nuevaplaza.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function BajaClick(){
                //var resp = confirm('¿Está seguro en dar de baja la Plaza seleccionada?','SISCAIM');
                //if (resp){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/bajadeplaza.jsp';
                paso.value = '6';
                frm.submit();
                //}
            }
            
            function VerInactivas(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/plazasinactivas.jsp';
                paso.value = '7';
                frm.submit();                
            }
                        
            function CargaClientes(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '-1';
                frm.submit();                    
            }
            
            function CargaContratos(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '-2';
                frm.submit();                    
            }
            
            function CargaCT(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
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
            
            function CargaPlazas(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function MovExtrasClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function SustituirClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/sustituirplaza.jsp';
                paso.value = '10';
                frm.submit();                
            }
            
            function ImprimirClick(){
                var suc = document.getElementById('sucursal');
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGestionarPlz');
                    dat1.value = suc.value;
                    paso.value = '13';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Plazas'+'&paso=12&dato1='+suc.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function PlazasExtClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '15';
                frm.submit();                
            }
            
            function PlazasLocClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '16';
                frm.submit();                
            }
            
            function RecalcularMovsExtras(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '17';
                frm.submit();                
            }
            
            function VacacionesClick(){
                Espera();
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/Vacaciones/listado.jsp';
                paso.value = '20';
                frm.submit();                
            }
            
        </script>
    </body>
</html>
