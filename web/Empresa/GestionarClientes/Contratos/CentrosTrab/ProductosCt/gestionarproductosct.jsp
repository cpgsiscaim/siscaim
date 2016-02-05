<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.ProductosCt"%>
<%@page import="java.lang.String, javax.servlet.http.HttpSession" %>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int cat = Integer.parseInt(datosS.get("categoria").toString());
List<ProductosCt> listado = (List<ProductosCt>)datosS.get("productosct");
Cliente cliSel = (Cliente)datosS.get("clienteSel");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
Contrato conSel = (Contrato)datosS.get("editarContrato");
CentroDeTrabajo ct = new CentroDeTrabajo();
String titulo = "CENTRO DE TRABAJO";
if (cat == 1){
    ct = (CentroDeTrabajo)datosS.get("centro");
} else {
    titulo = "CONTRATO";
}
int banhis = Integer.parseInt(datosS.get("banhis")!=null?datosS.get("banhis").toString():"0");
NumberFormat formato = new DecimalFormat("#,##0.00");
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
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnGenProdsCT" ).button({
                icons: {
                    primary: "ui-icon-gear"
		}
            });
            $( "#btnEditarCants" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-minus"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-wrench"
		}
            });
            $( "#btnAgregar" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
            $( "#btnCancelEdicCants" ).button({
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
        
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
        </div>
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/productosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PRODUCTOS DEL <%=titulo%>
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%if (cliSel.getTipo()==0){%>
                        <%=cliSel.getDatosFiscales().getRazonsocial()%>
                        <%}%>
                        <%if (cliSel.getDatosFiscales().getPersona()!=null){%>
                        <%=cliSel.getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%}%>
                         - 
                        CONTRATO <%=conSel.getContrato()%> <%=conSel.getDescripcion()%>
                        <%if (banhis==1){%> (CONCLUIDO) <%}%>
                        <br>
                        <%if (cat==1){%>
                        CENTRO DE TRABAJO <%=ct.getNombre()%>
                        <%}%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarPCT" name="frmGestionarPCT" action="<%=CONTROLLER%>/Gestionar/ProductosDeCT" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idPct" name="idPct" type="hidden" value=""/>
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
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Productos del <%=titulo%>">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="10%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Productos en baja">
                                                    Ver Inactivos
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnGenProdsCT" href="javascript: ProdsxCTClick()"
                                                   style="display: none; width: 200px; font-weight: bold; color: #0B610B;"
                                                   title="Generar Productos en todos los CTs del contrato">
                                                    Generar Productos x CT
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnEditarCants" href="javascript: EditarListado()"
                                                   style="width: 180px; font-weight: bold; color: #0B610B;"
                                                   title="Activar la edición de datos en el listado">
                                                    Editar en listado
                                                </a>
                                            </td>
                                            <td width="20%" align="right">&nbsp;</td>
                                            <td width="20%" align="right">
                                                <table id="borrarEdit" width="100%" style="display: none" align="right">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaPCTClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;"
                                                            title="Dar de baja el producto seleccionado">
                                                                Baja
                                                            </a>
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarPCTClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;"
                                                            title="Editar el producto seleccionado">
                                                                Editar
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="right">
                                                <a id="btnAgregar" href="javascript: NuevoPCTClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B;"
                                                title="Agregar productos">
                                                    Agregar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="tbEditLista" width="100%" style="display: none">
                                        <tr>
                                            <td width="50%" align="right">
                                                <a id="btnGuardar" href="javascript: GuardarListaClick()"
                                                style="width: 150px; font-weight: bold; color: #0B610B;"
                                                title="Guardar datos editados en listado">
                                                    Guardar
                                                </a>
                                            </td>
                                            <td width="50%" align="left">
                                                <a id="btnCancelEdicCants" href="javascript: CancelarListaClick()"
                                                style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;"
                                                title="Cancelar edición de datos en listado">
                                                    Cancelar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Productos del <%=titulo%> registrados
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="10%">
                                                    <span>Clave</span>
                                                </td>
                                                <td align="center" width="45%">
                                                    <span>Descripción</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Unidad</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Cantidad</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Tipo</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <input id="imprTodo" name="imprTodo" type="checkbox" style="display: none"
                                                           title="Marcar/Desmarcar Todos" onclick="CheckTodos(this)"/>
                                                    <span>Imprimir</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%
                                            int tabindex = 1000;
                                            for (int i=0; i < listado.size(); i++){
                                                ProductosCt pct = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="left" width="10%">
                                                        <input id="radioPct" name="radioPct" type="radio" value="<%=pct.getId()%>"/>
                                                        <span class="etiquetaD">
                                                            <%=pct.getProducto().getClave()%>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="45%">
                                                        <span class="etiquetaD">
                                                            <%=pct.getDescripcion()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=pct.getUnidad().getDescripcion()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span id="txtCant<%=i%>" class="etiquetaD">
                                                            <%=formato.format(pct.getCantidad())%>
                                                        </span>
                                                        <input id="cant<%=i%>" name="cant<%=i%>" class="text" type="text"
                                                            style="width: 50px; text-align: right; display: none" value="<%=formato.format(pct.getCantidad())%>"
                                                            maxlength="10" onkeypress="return ValidaCantidad2(event, this)"
                                                            onblur="Formatea(this)" onchange="CambiaClase(this,'text')" tabindex="<%=tabindex+i%>"
                                                            title="Ingrese la cantidad"/>
                                                        
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span id="txtTipo<%=i%>" class="etiquetaD">
                                                            <%=pct.getTipo()==0?"B&AacuteSICO":"A CAMBIO"%>
                                                        </span>
                                                        <select id="tipo<%=i%>" name="tipo<%=i%>" class="combo"
                                                                style="width: 150px; display: none" title="Tipo de producto">
                                                            <option value="0" <%if (pct.getTipo()==0){%>selected<%}%>>B&Aacute;SICO</option>
                                                            <option value="1" <%if (pct.getTipo()==1){%>selected<%}%>>CAMBIO</option>
                                                        </select>    
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span id="txtImpr<%=i%>" class="etiquetaD">
                                                            <%=pct.getImprimir()==0?"NO":"S&Iacute"%>
                                                        </span>
                                                        <input id="imprimir<%=i%>" name="imprimir<%=i%>" type="checkbox"
                                                               style="display: none" <%if(pct.getImprimir()==1){%>checked<%}%>>
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
            
            function CambiaClase (obj, clase){
                obj.className = clase;
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
                
                if (listado.size()!=0 && cat == 0){
                %>
                    var btnGenProdxCt = document.getElementById('btnGenProdsCT');
                    btnGenProdxCt.style.display = '';
                <% }
                if (banhis==1){
                %>
                    var genprod = document.getElementById('btnGenProdsCT');
                    genprod.style.display = 'none';
                    var nvo = document.getElementById('btnNuevo');
                    nvo.style.display = 'none';
                    var inactivos = document.getElementById('btnInactivos');
                    inactivos.style.display = 'none';
                <%}
                if (listado.size()==0){%>
                    var btnEditDatos = document.getElementById('btnEditarCants');
                    btnEditDatos.style.display = 'none';
                <%}%> 
            }
            
            function Activa(fila){
                var idPct = document.getElementById('idPct');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarPCT.radioPct.checked = true;
                    idPct.value = document.frmGestionarPCT.radioPct.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarPCT.radioPct[fila];
                    radio.checked = true;
                    idPct.value = radio.value;
                <% }
                if (banhis==1){
                %>
                   borrarEdit.style.display = 'none';
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarPCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                <%if (cat==1){%>
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                <%} else {%>
                    pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                <%}%>
                paso.value = '99';
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
            
            function Formatea(obj){
                obj.value = formato_numero(obj.value, 2, '.', ',');
            }
            
            function MuestraControlesEdLista(ban){
            <%
                for (int i=0; i < listado.size(); i++){
                    ProductosCt pct = listado.get(i);
                %>
                    var txtCan = document.getElementById('txtCant<%=i%>');
                    var inCan = document.getElementById('cant<%=i%>');
                    var txtTipo = document.getElementById('txtTipo<%=i%>');
                    var inTipo = document.getElementById('tipo<%=i%>');
                    var txtImpr = document.getElementById('txtImpr<%=i%>');
                    var inImpr = document.getElementById('imprimir<%=i%>');
                    var inImprTodo = document.getElementById('imprTodo');
                    if (ban==1){
                        txtCan.style.display = 'none';
                        inCan.style.display = '';
                        inCan.value = '<%=formato.format(pct.getCantidad())%>';
                        txtTipo.style.display = 'none';
                        inTipo.style.display = '';
                        txtImpr.style.display = 'none';
                        inImpr.style.display = '';
                        inImprTodo.style.display = '';
                    } else {
                        txtCan.style.display = '';
                        inCan.style.display = 'none';
                        txtTipo.style.display = '';
                        inTipo.style.display = 'none';
                        txtImpr.style.display = '';
                        inImpr.style.display = 'none';
                        inImprTodo.style.display = 'none';
                    }
                <%
                }
            %>
            }
            
            function ValidaCantidades(){
            <%
                for (int i=0; i < listado.size(); i++){
                    ProductosCt pct = listado.get(i);
                %>
                    var input = document.getElementById('cant<%=i%>');
                    var valor = parseFloat(input.value);
                    if (input.value == '' || valor == 0){
                        MostrarMensaje('La cantidad no es válida');
                        CambiaClase(input,'ui-state-error');
                        return false;
                    }
                <%
                }
            %>
                return true;
            }
            
            function EditarListado(){
                var tbAcciones = document.getElementById('acciones');
                tbAcciones.style.display = 'none';
                var tbEditLista = document.getElementById('tbEditLista');
                tbEditLista.style.display = '';
                MuestraControlesEdLista(1);
            }
            
            function CancelarListaClick(){
                var tbAcciones = document.getElementById('acciones');
                tbAcciones.style.display = '';
                var tbEditLista = document.getElementById('tbEditLista');
                tbEditLista.style.display = 'none';
                MuestraControlesEdLista(0);
            }
            
            function GuardarListaClick(){
                if (ValidaCantidades()){
                    Espera();
                    var frm = document.getElementById('frmGestionarPCT');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                    paso.value = '10';
                    frm.submit();
                }
            }
            
            function CheckTodos(obj){
            <%
                for (int i=0; i < listado.size(); i++){
                %>
                    var inImpr = document.getElementById('imprimir<%=i%>');
                    if (obj.checked)
                        inImpr.checked = true;
                    else
                        inImpr.checked = false;
                <%
                }
            %>                
            }
        </script>
    </body>
</html>