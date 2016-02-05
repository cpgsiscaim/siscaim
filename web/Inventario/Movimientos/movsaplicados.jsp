<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera"%>
<%@page import="java.text.SimpleDateFormat"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
    List<Cabecera> listado = datosS.get("listaaplicados")!=null?(List<Cabecera>)datosS.get("listaaplicados"):new ArrayList<Cabecera>();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
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
                        GESTIONAR MOVIMIENTOS - APLICADOS
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="titulo" align="left">
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
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
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
                                                    No hay Movimientos Aplicados con la Sucursal y el Tipo de Movimiento seleccionados 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="5%">&nbsp;</td>
                                                <td align="center" width="5%">
                                                    <span>Serie</span>
                                                </td>
                                                <td align="center" width="5%">
                                                    <span>Folio</span>
                                                </td>
                                                <td align="center" width="8%">
                                                    <span>Fecha</span>
                                                </td>
                                                <%
                                                String ancho = "67%", ancho1 = "20%", ancho2 = "20%";
                                                if (tmovSel.getId()==6){
                                                    ancho = "61%";
                                                } else if (tmovSel.getId()==20 || tmovSel.getId()==21){
                                                    ancho = "35%";
                                                }
                                                if (tmovSel.getId()!=7 && tmovSel.getId()!=8 && tmovSel.getId()!=20 && tmovSel.getId()!=21 && tmovSel.getId()!=25){%>
                                                    <td align="center" width="<%=ancho%>">                                               
                                                    <%if (tmovSel.getCategoria()==1){%>
                                                        <span>Proveedor</span>
                                                    <% } else { %>
                                                        <span>Cliente</span>
                                                    <% }%>
                                                    </td>
                                                <%}else if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                                                    <td align="center" width="<%=ancho%>">Cliente</td>
                                                    <td align="center" width="<%=ancho1%>">Contrato</td>
                                                    <td align="center" width="<%=ancho2%>">C.T.</td>
                                                <%} else if(tmovSel.getId()!=25){%>
                                                    <td align="center" width="<%=ancho%>">
                                                        <span>Movimiento</span>
                                                    </td>
                                                <%} else if (tmovSel.getId()==25){%>
                                                    <td align="center" width="77">
                                                        <span>Descripción</span>
                                                    </td>
                                                <%}
                                                if (tmovSel.getId()==6){
                                                %>
                                                <td align="center" width="14%" colspan="2">
                                                    <span>Factura Original</span>
                                                </td>
                                                <%}%> 
                                                <td align="center" width="10%">
                                                    <span>Fecha Aplicación</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Cabecera mov = listado.get(i);
                                                //Float tot = totales.get(i);
                                                //String fechaCap = mov.getFechaCaptura().toString();
                                                /*String fechaInv = mov.getFechaInventario()!=null?mov.getFechaInventario().toString():"";
                                                String fechaRec = mov.getFechaRecepcion()!=null?mov.getFechaRecepcion().toString():"";*/
                                                //String fechaCapN =fechaCap.substring(8,10) + "-" + fechaCap.substring(5,7) + "-" + fechaCap.substring(0, 4);
                                                /*String fechaInvN =!fechaInv.equals("")?fechaInv.substring(8,10) + "-" + fechaInv.substring(5,7) + "-" + fechaInv.substring(0, 4):"";
                                                String fechaRecN =!fechaRec.equals("")?fechaRec.substring(8,10) + "-" + fechaRec.substring(5,7) + "-" + fechaRec.substring(0, 4):"";*/
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioMov" name="radioMov" type="radio" value="<%=mov.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <%=mov.getSerie().getSerie()%>
                                                    </td>
                                                    <td align="center" width="5%">
                                                        <%=mov.getFolio()%>
                                                    </td>
                                                    <td align="center" width="8%">
                                                        <span><%=formato.format(mov.getFechaCaptura())%></span>
                                                    </td>
                                                    <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8 && tmovSel.getId()!=20 && tmovSel.getId()!=21 && tmovSel.getId()!=25){%>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getTipomov().getCategoria()==1?(mov.getProveedor().getTipo().equals("0")?mov.getProveedor().getDatosfiscales().getRazonsocial():mov.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()):
                                                            (mov.getCliente().getTipo()==0?mov.getCliente().getDatosFiscales().getRazonsocial():mov.getCliente().getDatosFiscales().getPersona().getNombreCompleto())
                                                            %>
                                                        </td>
                                                    <%} else if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getTipomov().getCategoria()==1?(mov.getProveedor().getTipo().equals("0")?mov.getProveedor().getDatosfiscales().getRazonsocial():mov.getProveedor().getDatosfiscales().getPersona().getNombreCompleto()):
                                                            (mov.getCliente().getTipo()==0?mov.getCliente().getDatosFiscales().getRazonsocial():mov.getCliente().getDatosFiscales().getPersona().getNombreCompleto())
                                                            %>
                                                        </td>
                                                        <td align="left" width="<%=ancho1%>">
                                                            (<%=mov.getContrato().getContrato()%>) <%=mov.getContrato().getDescripcion()%>
                                                        </td>
                                                        <td align="left" width="<%=ancho2%>">
                                                            <%=mov.getCentrotrabajo().getNombre()%>
                                                        </td>
                                                    <%} else if (tmovSel.getId()!=25){ %>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getTipomov().getDescripcion()%>
                                                        </td>
                                                    <%} else if (tmovSel.getId()==25){ %>
                                                        <td align="left" width="<%=ancho%>">
                                                            <%=mov.getDescripcion()%>
                                                        </td>
                                                    <%}if (tmovSel.getId()==6){%>
                                                    <td align="center" width="5%">
                                                        <span><%=mov.getSerieOriginal()!=null?mov.getSerieOriginal():""%></span>
                                                    </td>
                                                    <td align="center" width="9%">
                                                        <span><%=mov.getFolioOriginal()!=0?mov.getFolioOriginal():""%></span>
                                                    </td>
                                                    <%}%> 
                                                    <td align="right" width="10%">
                                                        <span><%=formato.format(mov.getFechaInventario())%></span>
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
                var impr = document.getElementById('btnImprimir');
                impr.style.display = '';
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                paso.value = '90';
                frm.submit();                
            }
            
            function ImprimirClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/imprimirmovimiento.jsp';
                paso.value = '26';
                frm.submit();                
            }
        </script>
    </body>
</html>