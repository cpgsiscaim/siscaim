<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cabecera, Modelo.Entidades.TipoMov"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
List<Cabecera> listado = datosS.get("inactivosCab")!=null?(List<Cabecera>)datosS.get("inactivosCab"):new ArrayList<Cabecera>();
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS - INACTIVOS
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%=tmovSel.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarMov" name="frmGestionarMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idMov" name="idMov" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnActivar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Activar">
                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
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
                                                    No hay Movimientos Inactivos en la Sucursal y el Tipo de Movimiento seleccionados 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="15%" colspan="2">
                                                    <span>Serie</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Folio</span>
                                                </td>
                                                <td align="center" width="50%">
                                                <%
                                                if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
                                                    if (tmovSel.getCategoria()==1){
                                                    %>
                                                        <span>Proveedor</span>
                                                    <% } else { %>
                                                        <span>Cliente</span>
                                                    <% }
                                                } else {
                                                %>
                                                    <span>Movimiento</span>
                                                <%
                                                }
                                                %>
                                                </td>
                                                <td align="center" width="25%">
                                                    <span>Fecha</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Cabecera mov = listado.get(i);
                                                String fechaCap = mov.getFechaCaptura().toString();
                                                /*String fechaInv = mov.getFechaInventario()!=null?mov.getFechaInventario().toString():"";
                                                String fechaRec = mov.getFechaRecepcion()!=null?mov.getFechaRecepcion().toString():"";*/
                                                String fechaCapN =fechaCap.substring(8,10) + "-" + fechaCap.substring(5,7) + "-" + fechaCap.substring(0, 4);
                                                /*String fechaInvN =!fechaInv.equals("")?fechaInv.substring(8,10) + "-" + fechaInv.substring(5,7) + "-" + fechaInv.substring(0, 4):"";
                                                String fechaRecN =!fechaRec.equals("")?fechaRec.substring(8,10) + "-" + fechaRec.substring(5,7) + "-" + fechaRec.substring(0, 4):"";*/
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioMov" name="radioMov" type="radio" value="<%=mov.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <%=mov.getSerie().getSerie()%>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <%=mov.getFolio()%>
                                                    </td>
                                                    <td align="left" width="50%">
                                                        <span>
                                                            <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8){%>
                                                            <%=mov.getTipomov().getCategoria()==1?(mov.getProveedor().getTipo().equals("0")?mov.getProveedor().getDatosfiscales().getRazonsocial():mov.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()):
                                                            (mov.getCliente().getTipo()==0?mov.getCliente().getDatosFiscales().getRazonsocial():mov.getCliente().getDatosFiscales().getPersona().getNombreCompleto())
                                                            %>
                                                            <% } else { %>
                                                            <%=mov.getTipomov().getDescripcion()%>
                                                            <% } %>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span><%=fechaCapN%></span>
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
                    Mensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    Mensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
            }
            
            function Activa(fila){
                var idMov = document.getElementById('idMov');
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarMov.radioMov.checked = true;
                    idMov.value = document.frmGestionarMov.radioMov.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarMov.radioMov[fila];
                    radio.checked = true;
                    idMov.value = radio.value;
                <% } %>
                var act = document.getElementById('btnActivar');
                act.style.display = '';
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/movimientosinactivos.jsp';
                paso.value = '8';
                frm.submit();                
            }
        </script>
    </body>
</html>