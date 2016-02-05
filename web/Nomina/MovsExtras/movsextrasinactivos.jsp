<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Plaza, Modelo.Entidades.MovimientoExtraordinario, Modelo.Entidades.Catalogos.Quincena"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<MovimientoExtraordinario> inactivos = (List<MovimientoExtraordinario>)datosS.get("meinactivos");
List<MovimientoExtraordinario> listado = (List<MovimientoExtraordinario>)datosS.get("meinactivosfijos");
listado.addAll(inactivos);
Plaza plzsel = (Plaza)datosS.get("plaza");
Quincena qact = (Quincena)datosS.get("quincenasel");
String anioact = datosS.get("aniosel").toString();
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
            $( "#btnActivar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
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
                    <img src="/siscaim/Imagenes/Nomina/MovsExtras/movextraD.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS EXTRAORDINARIOS
                    </div>
                    <div class="titulo" align="left">
                        INACTIVOS
                    </div>
                    <div class="subtitulo" align="left">
                        <%=plzsel.getEmpleado().getPersona().getNombreCompleto()%><br>
                        <%=plzsel.getPuesto().getDescripcion()%> / <%=plzsel.getCtrabajo().getNombre()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarMovExt" name="frmGestionarMovExt" action="<%=CONTROLLER%>/Gestionar/MovExtra" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idMext" name="idMext" type="hidden" value=""/>
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
                                                <a id="btnSalir" href="javascript: CancelarClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Cancelar">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="50%" align="right">
                                                <a id="btnActivar" href="javascript: ActivarClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Activar el mov. extraordinario seleccionado">
                                                    Activar
                                                </a>
                                            </td>
                                        </tr>
                                    </table><!--fin tabla salir sucursal cliente contrato ct -->
                                    <hr>
                                    <!--listado-->
                                    <%
                                        if (listado.isEmpty()){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Movimientos Extraordinarios Inactivos
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
                                                        <td align="center" width="20%" colspan="2">
                                                            <span>Movimiento</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Tipo de Cambio</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Tipo de Nómina</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Año</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Cantidad</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Quincenas</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Total</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Cotiza</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Permanente</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Prestaci&oacute;n IMSS</span>
                                                        </td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <%
                                                for (int i=0; i < listado.size(); i++){
                                                    MovimientoExtraordinario mextra = listado.get(i);
                                                %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="5%">
                                                            <input id="radioMext" name="radioMext" type="radio" value="<%=mextra.getId()%>"/>
                                                        </td>
                                                        <td align="left" width="18%">
                                                            <span class="etiqueta">
                                                                <%=mextra.getPerded().getDescripcion()%> 
                                                                (<%if (mextra.getPerded().getPeroDed()==1){%>+<%}else{%>-<%}%>)
                                                            </span>
                                                        </td>
                                                        <td align="left" width="10%">
                                                            <span class="etiqueta"><%=mextra.getTipocambio().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=mextra.getTiponomina().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span class="etiqueta"><%=mextra.getAnio()%></span>
                                                        </td>
                                                        <td align="right" width="8%">
                                                            <span class="etiqueta"><%=mextra.getImporte()%></span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span class="etiqueta"><%=mextra.getNumero()%></span>
                                                        </td>
                                                        <td align="right" width="8%">
                                                            <span class="etiqueta"><%=mextra.getTotal()%></span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span class="etiqueta"><%if(mextra.getCotiza()==1){%>SÍ<%} else {%>NO<%}%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%if(mextra.getFijo()==1){%>SÍ<%} else {%>NO<%}%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%if(mextra.getPrestacionimss()==1){%>SÍ<%} else {%>NO<%}%></span>
                                                        </td>
                                                    </tr>
                                                <%
                                                }
                                                %>
                                                </tbody>
                                            </table>
                                        <%  
                                        }//if listado=0
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
                var idMext = document.getElementById('idMext');
                var activar = document.getElementById('btnActivar');
                activar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarMovExt.radioMext.checked = true;
                    idMext.value = document.frmGestionarMovExt.radioMext.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarMovExt.radioMext[fila];
                    radio.checked = true;
                    idMext.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ActivarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/movsextrasinactivos.jsp';
                paso.value = '8';
                frm.submit();                
            }
            
        </script>
    </body>
</html>
