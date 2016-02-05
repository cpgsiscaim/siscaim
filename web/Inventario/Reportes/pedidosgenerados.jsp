<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, java.util.Date, Modelo.Entidades.Sucursal, Modelo.Entidades.Ruta, Modelo.Entidades.Cabecera"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
Ruta rtSel = datosS.get("ruta")!=null?(Ruta)datosS.get("ruta"):new Ruta();
/*fechaI = datosS.get("fechaini").toString();
fechaIN = fechaI.substring(8,10) + "-" + fechaI.substring(5,7) + "-" + fechaI.substring(0, 4);
fechaF = datosS.get("fechafin").toString();
fechaFN = fechaF.substring(8,10) + "-" + fechaF.substring(5,7) + "-" + fechaF.substring(0, 4);*/
SimpleDateFormat ftofecha = new SimpleDateFormat("dd-MM-yyyy");
String fechaI = datosS.get("fechaini").toString();//ftofecha.format((Date)datosS.get("fechaini"));
String fechaF = datosS.get("fechafin").toString();//ftofecha.format((Date)datosS.get("fechafin"));
String tipopedido = datosS.get("tipopedido").toString();
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
        });
        </script>
    <!-- Jquery UI -->
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Entradas/pedidosB.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GENERAR PEDIDOS A PROVEEDORES
                    </div>
                    <div class="titulo" align="left">
                        PEDIDOS <%=tipopedido.equals("1")?"CORPORATIVOS":"LOCALES"%> GENERADOS
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL: <%=sucSel.getDatosfis().getRazonsocial()%><br>
                        RUTA: <%=rtSel.getId()!=-1?rtSel.getDescripcion():"TODAS LAS RUTAS"%><br>
                        DEL: <%=fechaI%> AL: <%=fechaF%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmPedidosProv" name="frmPedidosProv" action="<%=CONTROLLER%>/Gestionar/PedidosProv" method="post">
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
                                            <td width="20%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="80%" align="right">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Imprimir el pedido seleccionado">
                                                    Imprimir
                                                </a>
                                                <!--<style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                        </tr>
                                    </table>
                                    <div id="listado">
                                    <%
                                    List<Cabecera> pedidos = (List<Cabecera>)datosS.get("pedidos");
                                    %>
                                        <table width="100%" class="tablaLista" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="8%" align="center" colspan="2">
                                                        <span>Serie</span>
                                                    </td>
                                                    <td width="7%" align="center">
                                                        <span>Folio</span>
                                                    </td>
                                                    <td width="70%" align="center">
                                                        <span>Proveedor</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Fecha</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                        <%
                                            for(int i=0; i < pedidos.size(); i++){
                                                Cabecera ped = pedidos.get(i);
                                                String fechapedN = ftofecha.format(ped.getFechaCaptura());//ped.getFechaCaptura().toString();
                                                //String fechapedN = fechaped.substring(8,10) + "-" + fechaped.substring(5,7) + "-" + fechaped.substring(0, 4);
                                            %>
                                            <tr onclick="Activa(<%=i%>)">
                                                <td align="center" width="5%">
                                                    <input id="radioMov" name="radioMov" type="radio" value="<%=ped.getId()%>"/>
                                                </td>
                                                <td width="8%" align="center">
                                                    <span class="etiqueta"><%=ped.getSerie().getSerie()%></span>
                                                </td>
                                                <td width="7%" align="center">
                                                    <span class="etiqueta"><%=ped.getFolio()%></span>
                                                </td>
                                                <td width="70%" align="left">
                                                    <span class="etiqueta">
                                                        <%=(ped.getProveedor().getTipo().equals("0")?ped.getProveedor().getDatosfiscales().getRazonsocial():ped.getProveedor().getDatosfiscales().getPersona().getNombreCompleto())%>
                                                    </span>
                                                </td>
                                                <td width="15%" align="right">
                                                    <span class="etiqueta"><%=fechapedN%></span>
                                                </td>
                                            </tr>
                                            <%
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                    </div>
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
                if (pedidos.size()==1){
                %>
                    document.frmPedidosProv.radioMov.checked = true;
                    idMov.value = document.frmPedidosProv.radioMov.value;
                <%
                } else {
                %>
                    var radio = document.frmPedidosProv.radioMov[fila];
                    radio.checked = true;
                    idMov.value = radio.value;
                <% } %>
                var impr = document.getElementById('btnImprimir');
                impr.style.display = '';
            }
            
            function ImprimirClick(){
                var frm = document.getElementById('frmPedidosProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Movimientos/imprimirmovimiento.jsp';
                paso.value = '3';
                frm.submit();                
            }
                        
            function SalirClick(){
                var frm = document.getElementById('frmPedidosProv');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '98';
                frm.submit();                
            }
            
        </script>
    </body>
</html>