<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
//int paso = Integer.parseInt(datosS.get("paso").toString());
List<Cliente> listado = new ArrayList<Cliente>();//(List<Cliente>)datosS.get("listado");
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
    </head>
    <body onload="CargaPagina()">
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
                    <img src="/siscaim/Imagenes/Empresa/clientesA1.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CLIENTES
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCli" name="frmGestionarCli" action="<%=CONTROLLER%>/Gestionar/Clientes" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCli" name="idCli" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnFiltrar a{display:block;color:transparent;} #btnFiltrar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnFiltrar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Filtrar">
                                                            <a href="javascript: FiltrarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/filtrar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                                <style>#btnQuitar a{display:block;color:transparent;} #btnQuitar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnQuitar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Quitar Filtros">
                                                            <a href="javascript: QuitarFiltroClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/quitarfiltro.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoCliClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="25%" align="right">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px"
                                                        onchange="MostrarClientes()" <%if (matriz.equals("0")){%>disabled<%}%>>
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
                                            <td width="25%" align="right">&nbsp;</td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Consumo">
                                                            <a href="javascript: ConsumoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/consumo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Contactos">
                                                            <a href="javascript: ContactosClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/contactos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Baja">
                                                            <a href="javascript: BajaCliClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Editar">
                                                            <a href="javascript: EditarCliClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Contratos">
                                                            <a href="javascript: ContratosCliClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/contratos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>

                                    <hr>
                                    <div id="listado">
                                    <table class="tablaLista" width="100%">
                                    <%
                                    if (sucSel.getId()!=0){
                                        listado = (List<Cliente>)datosS.get("listado");
                                    if (listado.isEmpty()){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Clientes registrados en la Sucursal seleccionada
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="50%">
                                                    <span>Cliente</span>
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
                                                Cliente cli = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="left" width="50%">
                                                        <input id="radioCli" name="radioCli" type="radio" value="<%=cli.getId()%>"/>
                                                        <span class="etiquetaD">
                                                        <%
                                                        if (cli.getTipo()==0){
                                                        %>
                                                            <%=cli.getDatosFiscales().getRazonsocial()%>
                                                        <% } else { %>
                                                            <%=cli.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                        <% } %>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiquetaD"><%=cli.getDatosFiscales().getDireccion().getPoblacion().getMunicipio()%></span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiquetaD"><%=cli.getDatosFiscales().getDireccion().getPoblacion().getEstado().getEstado()%></span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span class="etiquetaD"><%=cli.getCglobal()==1?"NACIONAL":"LOCAL"%></span>
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
                                    </table><!--listado-->
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
        </form>
        <script language="javascript">
            function CargaPagina(){
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
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
                        var btnImprimir = document.getElementById('btnImprimir');
                        btnImprimir.style.display = '';
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
                var idCli = document.getElementById('idCli');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarCli.radioCli.checked = true;
                    idCli.value = document.frmGestionarCli.radioCli.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCli.radioCli[fila];
                    radio.checked = true;
                    idCli.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoCliClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/nuevocliente.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarCliClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/nuevocliente.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function BajaCliClick(){
                var resp = confirm('¿Está seguro en dar de baja el Cliente seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarCli');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                    paso.value = '6';
                    frm.submit();
                }
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/clientesinactivos.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
            function MostrarClientes(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                var divlist = document.getElementById('listado');
                divlist.style.display = 'none';
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '1';
                frm.submit();                    
            }
            
            function FiltrarClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/filtrarclientes.jsp';
                paso.value = '9';
                frm.submit();                
            }
            
            function QuitarFiltroClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '11';
                frm.submit();                
            }
            
            function ImprimirClick(){
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Clientes'+'&paso=12',
                        '','width =800, height=600, left=0, top = 0, resizable= yes');                

            }
            
            function ContratosCliClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '13';
                frm.submit();                
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
            function ConsumoClick(){
                var frm = document.getElementById('frmGestionarCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                paso.value = '14';
                frm.submit();                
            }
    </script>
    </body>
</html>