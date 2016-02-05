<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Proveedor"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Proveedor> listado = new ArrayList<Proveedor>();//(List<Cliente>)datosS.get("listado");
Sucursal sucSel = new Sucursal();
//if (paso != 0){
    sucSel = (Sucursal)datosS.get("sucursalSel");
    String matriz = datosS.get("matriz").toString();
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
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnFiltrar" ).button({
                icons: {
                    primary: "ui-icon-zoomin"
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
            $( "#btnQuitar" ).button({
                icons: {
                    primary: "ui-icon-zoomout"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
            $( "#btnCambiarSuc" ).button({
                icons: {
                    primary: "ui-icon-shuffle"
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
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/proveedoresA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PROVEEDORES
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarProv" name="frmGestionarProv" action="<%=CONTROLLER%>/Gestionar/Proveedores" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idPro" name="idPro" type="hidden" value=""/>            
            <input id="boton" name="boton" type="hidden" value=""/>
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
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Proveedores">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Proveedores dados de baja">
                                                    Ver Inactivos
                                                </a>
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnFiltrar" href="javascript: FiltrarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Flitrar Listado">
                                                    Filtrar
                                                </a>
                                                <a id="btnQuitar" href="javascript: QuitarFiltroClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Quitar Filtros Aplicados">
                                                    Quitar Filtros
                                                </a>
                                            </td>
                                            <td width="25%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevoClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Agregar Nuevo Proveedor">
                                                    Nuevo
                                                </a>
                                            </td>
                                            <td width="30%" align="right">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px"
                                                        onchange="MostrarProveedores()" <%if (matriz.equals("0")){%>disabled<%}%>>
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
                                                                        //if (paso!=0){
                                                                            //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                            if (sucSel.getId()==suc.getId()){
                                                                            %>
                                                                                selected
                                                                            <%
                                                                            }
                                                                        //}
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
                                        </tr>
                                    </table>
                                    <table id="borrarEdit" width="100%" style="display: none">
                                        <tr>
                                            <td width="55%" align="right">&nbsp;</td>
                                            <td width="15%" align="right">
                                                <a id="btnCambiarSuc" href="javascript: CambiarSucClick()"
                                                   style="width: 180px; font-weight: bold; color: #0B610B;" title="Cambiar de Sucursal al Proveedor Seleccionado">
                                                    Cambiar de Sucursal
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnBaja" href="javascript: BajaClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja el Proveedor Seleccionado">
                                                    Baja
                                                </a>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnEditar" href="javascript: EditarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar el Cliente Seleccionado">
                                                    Editar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>

                                    <hr>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (sucSel.getId()!=0){
                                        listado = (List<Proveedor>)datosS.get("listado");
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Proveedores registrados en la Sucursal seleccionada
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="50%" colspan="2">
                                                    <span>Proveedor</span>
                                                </td>
                                                <td align="center" width="20%">
                                                    <span>Ciudad</span>
                                                </td>
                                                <td align="center" width="20%">
                                                    <span>Estado</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Tipo</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Proveedor prov = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioPro" name="radioPro" type="radio" value="<%=prov.getId()%>"/>
                                                    </td>
                                                    <td align="left" width="40%">
                                                        <span class="etiqueta">
                                                        <%
                                                        if (prov.getTipo().equals("0")){
                                                        %>
                                                            <%=prov.getDatosfiscales().getRazonsocial()%>
                                                        <% } else { %>
                                                            <%=prov.getDatosfiscales().getPersona().getNombreCompleto()%>
                                                        <% } %>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="20%">
                                                        <span class="etiqueta"><%=prov.getDatosfiscales().getDireccion().getPoblacion().getMunicipio()%></span>
                                                    </td>
                                                    <td align="left" width="20%">
                                                        <span class="etiqueta"><%=prov.getDatosfiscales().getDireccion().getPoblacion().getEstado().getEstado()%></span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiquetaD"><%=prov.getNacional()==1?"NACIONAL":"LOCAL"%></span>
                                                    </td>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
                                    }
                                    }
                                    %>
                                    </table>
                                    <!-- botones siguiente anterior-->
                                    <%
                                    int grupos = Integer.parseInt(datosS.get("grupos").toString());
                                    if (grupos == 1){
                                        int sigs = Integer.parseInt(datosS.get("siguientes").toString());
                                        int ants = Integer.parseInt(datosS.get("anteriores").toString());
                                    %>
                                    <hr>
                                    <table width="100%">
                                        <tr>
                                            <td width="30%">&nbsp;</td>
                                            <td width="10%" align="center">
                                                <style>#btnPrincipio a{display:block;color:transparent;} #btnPrincipio a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnPrincipio" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al principio del listado">
                                                            <a href="javascript: PrincipioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/principio.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnAnterior a{display:block;color:transparent;} #btnAnterior a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnAnterior" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Anteriores">
                                                            <a href="javascript: AnteriorClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/anterior.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnSiguiente a{display:block;color:transparent;} #btnSiguiente a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnSiguiente" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Siguientes">
                                                            <a href="javascript: SiguienteClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/siguiente.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnUltimo a{display:block;color:transparent;} #btnUltimo a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnUltimo" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al final del listado">
                                                            <a href="javascript: FinalClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/final.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="30%">&nbsp;</td>
                                        </tr>
                                    </table>
                                    </div>
                                    <%
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->
                                    
                                </td>
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
                    EjecutarSalidasProgs();
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
                int fil = Integer.parseInt(datosS.get("filtro")!=null?datosS.get("filtro").toString():"0");
                //if (paso != 0){
                    if (sucSel.getId()!=0 && listado.size()>0){
                        //activar botones
                    %>
                        var btnInactivos = document.getElementById('btnInactivos');
                        btnInactivos.style.display = '';
                        <%
                        if (fil==0){
                        %>
                            var btnFiltrar = document.getElementById('btnFiltrar');
                            btnFiltrar.style.display = '';
                        <% } else { %>
                            var btnQuitar = document.getElementById('btnQuitar');
                            btnQuitar.style.display = '';
                        <% } %>
                        var btnNuevo = document.getElementById('btnNuevo');
                        btnNuevo.style.display = '';
                    <%
                    } else if (sucSel.getId()!=0){
                    %>
                        var btnInactivos = document.getElementById('btnInactivos');
                        btnInactivos.style.display = '';
                        var btnNuevo = document.getElementById('btnNuevo');
                        btnNuevo.style.display = '';
                    <%
                    }
                //}
                %>
            }
            
            function Activa(fila){
                var idPro = document.getElementById('idPro');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarProv.radioPro.checked = true;
                    idPro.value = document.frmGestionarProv.radioPro.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarProv.radioPro[fila];
                    radio.checked = true;
                    idPro.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/nuevoproveedor.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/nuevoproveedor.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '6';
                frm.submit();
            }
            
            
            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro en dar de baja el Proveedor seleccionado?');
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/proveedoresinactivos.jsp';
                paso.value = '7';
                frm.submit();
            }
            
            function MostrarProveedores(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '1';
                frm.submit();                    
            }
            
            function FiltrarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/filtrarproveedores.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function QuitarFiltroClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '11';
                frm.submit();                
            }
            
            function SiguienteClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
            function CambiarSucClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Proveedores/cambiarsucprov.jsp';
                paso.value = '16';
                frm.submit();                
            }
        </script>
    </body>
</html>