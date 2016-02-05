<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.text.NumberFormat, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<CentroDeTrabajo> listado = (List<CentroDeTrabajo>)datosS.get("listaCentros");
Cliente cliSel = (Cliente)datosS.get("clienteSel");
Contrato conSel = (Contrato)datosS.get("editarContrato");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
int banhis = Integer.parseInt(datosS.get("banhis")!=null?datosS.get("banhis").toString():"0");
NumberFormat formato = new DecimalFormat("#,##0.00");
String matriz = datosS.get("matriz").toString();
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
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Empresa/centrostrabA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CENTROS DE TRABAJO
                    </div>
                    <div class="titulo" align="left">
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
                        CONTRATO <%=conSel.getContrato()%> <%=conSel.getDescripcion()%>
                        <%if (banhis==1){%> (CONCLUIDO) <%}%>
                    </div>
                </td>
                
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCT" name="frmGestionarCT" action="<%=CONTROLLER%>/Gestionar/CentrosTrab" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCT" name="idCT" type="hidden" value=""/>            
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
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="60%" align="right">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="25%" align="right">
                                                            <style>#btnProdsCt a{display:block;color:transparent;} #btnProdsCt a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnProdsCt" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Productos">
                                                                        <a href="javascript: ProductosCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/productosct.png);width:180px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <style>#btnPlazas a{display:block;color:transparent;} #btnPlazas a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                            <table id="btnPlazas" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Plazas del CT">
                                                                        <a href="javascript: PlazasCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/plazas.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <style>#btnBaja a{display:block;color:transparent;} #btnBaja a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnBaja" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <style>#btnEditar a{display:block;color:transparent;} #btnEditar a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="btnEditar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Editar">
                                                                        <a href="javascript: EditarCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoCTClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
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
                                                    No hay Centros de Trabajo registrados del Contrato seleccionado
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="40%">
                                                    <span>Nombre</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Personal</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Entregas</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Tope de Sueldos</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Tope de Insumos</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                CentroDeTrabajo ct = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="left" width="40%">
                                                        <input id="radioCT" name="radioCT" type="radio" value="<%=ct.getId()%>"/>
                                                        <span class="etiquetaD">
                                                            <%=ct.getNombre()%>
                                                            <%if (ct.getDireccion()!=null){%>
                                                                (<%=ct.getDireccion().getCalle()%>, COL. <%=ct.getDireccion().getColonia()%>,
                                                                <%=ct.getDireccion().getPoblacion().getMunicipio()%>,<%=ct.getDireccion().getPoblacion().getEstado().getEstado()%>)
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=Float.toString(ct.getPersonal())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%if (ct.getConfigentrega()==0){%>
                                                                DEFINIDAS EN EL CONTRATO
                                                            <%} else if (ct.getTipoentrega()==0){%>
                                                                CADA <%=Integer.toString(ct.getDiasEntrega())%> D&Iacute;AS
                                                            <%} else if (ct.getTipoentrega()==1){%>
                                                                FECHAS ESPEC&Iacute;FICAS
                                                            <%} else {%>
                                                                NO CONFIGURADAS
                                                            <%}%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=formato.format(ct.getTopeSueldos())%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiquetaD">
                                                            <%=formato.format(ct.getTopeInsumos())%>
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
                <%}
                if (banhis==1){
                %>
                    var nvo = document.getElementById('btnNuevo');
                    nvo.style.display = 'none';
                    var inactivos = document.getElementById('btnInactivos');
                    inactivos.style.display = 'none';
                <%}%>
                ValidaUsuariosSucursales();
            }
            
            function ValidaUsuariosSucursales(){
                <%if (matriz.equals("0")){%>
                    var btnNvo = document.getElementById('btnNuevo');
                    var btnProdsCt = document.getElementById('btnProdsCt');
                    var btnBaja = document.getElementById('btnBaja');
                    var btnEd = document.getElementById('btnEditar');
                    btnNvo.style.display = 'none';
                    btnProdsCt.style.display = 'none';
                    btnBaja.style.display = 'none';
                    btnEd.style.display = 'none';
                <%}%>
            }
            
            function Activa(fila){
                var idCT = document.getElementById('idCT');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarCT.radioCT.checked = true;
                    idCT.value = document.frmGestionarCT.radioCT.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCT.radioCT[fila];
                    radio.checked = true;
                    idCT.value = radio.value;
                <% }
                if (banhis==1){
                %>
                    borrarEdit.style.display = 'none';
                <% } %>
                ValidaUsuariosSucursales();
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoCTClick(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/nuevocentro.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarCTClick(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/nuevocentro.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function BajaCTClick(){
                var resp = confirm('¿Está seguro en dar de baja el Centro de Trabajo seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarCT');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                    paso.value = '5';
                    frm.submit();
                }
            }
            
            function ProductosCTClick(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/ProductosCt/gestionarproductosct.jsp';
                paso.value = '8';
                frm.submit();
            }

            function PlazasCTClick(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '9';
                frm.submit();
            }

            function VerInactivos(){
                var frm = document.getElementById('frmGestionarCT');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/centrosinactivos.jsp';
                paso.value = '6';
                frm.submit();                
            }
                                    
            function CentrosConClick(){
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/gestionarcentros.jsp';
                paso.value = '8';
                frm.submit();                
            }
        </script>
    </body>
</html>