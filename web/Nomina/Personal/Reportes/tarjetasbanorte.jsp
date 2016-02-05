
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
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
            $( "#btnCancelar" ).button({
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
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/empleadosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        FORMATO PARA SOLICITAR TARJETAS BANORTE
                    </div>
                </td>
            </tr>
            </tr>
        </table>
        <hr>
        <form id="frmReportes" name="frmReportes" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%" align="left" valign="top">
                                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                        background: indianred 50% bottom repeat-x;" title="Salir">
                                                        Salir
                                                    </a>
                                                </td>
                                                <td width="50%" align="right" valign="top">
                                                    <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir">
                                                        Imprimir
                                                    </a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
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
            
            function ImprimirClick(){
                var paso = document.getElementById('pasoSig');
                var frm = document.getElementById('frmReportes');
                paso.value = '43';
                frm.submit();                
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmReportes');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '91';
                frm.submit();                
            }
        </script>
    </body>
</html>