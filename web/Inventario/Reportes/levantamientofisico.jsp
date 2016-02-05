<%-- 
    Document   : levantamientofisico
    Created on : 17-mar-2014, 0:15:23
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Sucursal, Modelo.Entidades.Almacen"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
String matriz = datosS.get("matriz").toString();
List<Almacen> almacenes = (List<Almacen>)datosS.get("almacenes");
Almacen almSel = (Almacen)datosS.get("almacenSel")!=null?(Almacen)datosS.get("almacenSel"):new Almacen();
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
    <body>
        <table width="100%">
            <tr>
                <td width="100%" class="tablaMenu">
                    <div align="left">
                        <%@include file="/Generales/IniciarSesion/menu.jsp" %>
                    </div>
                </td>
            </tr>
        </table>
        <!--<br>-->
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        IMPRIMIR FORMATO DE LEVANTAMIENTO FÍSICO
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
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="70%" align="center">
                                        <tr>
                                            <td width="100%" align="center">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px"
                                                        onchange="ObtenerAlmacenes()" <%if (matriz.equals("0")){%>disabled<%}%>
                                                        title="Elija la sucursal">
                                                    <option value="">Elija la Sucursal...</option>
                                                <%
                                                    List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                    if (sucursales!=null){
                                                        if (sucursales.size()!=0){
                                                            for (int i=0; i < sucursales.size(); i++){
                                                                Sucursal suc = sucursales.get(i);
                                                            %>
                                                                <option value="<%=suc.getId()%>"
                                                                        <%if (sucSel.getId()==suc.getId()){%>
                                                                             selected
                                                                        <%}%>>
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
                                        <tr>
                                            <td width="100%" align="center">
                                                <select id="almacen" name="almacen" class="combo" style="width: 200px" title="Elija el almacén">
                                                    <option value="">Elija el Almacén...</option>
                                                <%
                                                    for (int i=0; i < almacenes.size(); i++){
                                                        Almacen alm = almacenes.get(i);
                                                    %>
                                                    <option value="<%=alm.getId()%>"
                                                            <% if (alm.getId()==almSel.getId()){%> selected <% } %>>
                                                        <%=alm.getDescripcion()%>
                                                    </option>
                                                    <%
                                                    }
                                                %>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="acciones" width="100%">
                                        <tr>
                                            <td width="80%" align="right">
                                                <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir el formato">
                                                    Imprimir
                                                </a>
                                            </td>
                                            <td width="50%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                            </td>
                                        </tr>
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
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarMov');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function ImprimirClick(){
                var suc = document.getElementById('sucursalsel');
                var alm = document.getElementById('almacen');
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Movimientos'+'&paso=41&dato1='+suc.options[suc.selectedIndex].text+'&dato2='+alm.value,
                        '','width =800, height=600, left=0, top = 0, resizable= yes');
            }

            function ObtenerAlmacenes(){
                var suc = document.getElementById('sucursalsel');
                var alm = document.getElementById('almacen');
                alm.length = 0;
                alm.options[0] = new Option('Elija el Almacén...', '');
                if (suc.value != ''){
                    var frm = document.getElementById('frmGestionarMov');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Reportes/levantamientofisico.jsp';
                    paso.value = '40';
                    frm.submit();
                }
            }

        </script>
    </body>
</html>
