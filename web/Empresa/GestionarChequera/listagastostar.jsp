<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Movimientos, java.text.NumberFormat, java.text.DecimalFormat"%>
<%@page import="Modelo.Entidades.Chequera"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
  HashMap datosS = sesion.getDatos();
  List<Movimientos> listado = (List<Movimientos>)datosS.get("cargos");
  Chequera tarjeta = (Chequera)datosS.get("tarjeta");
  NumberFormat formato = new DecimalFormat("$ #,###,##0.00");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
            <!--<link type="text/css" href="/siscaim/Estilos/titulos.css" rel="stylesheet" />-->
            <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
    <!-- Archivos para los cuadros modales 
            <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/normalize.css">
            <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/main.css">
            <script type='text/javascript' src='/siscaim/Utilerias/jquery-1.4.3.min.js'></script>
            <script type='text/javascript' src='/siscaim/Utilerias/jquery.modal.js'></script>
            <script type='text/javascript' src='/siscaim/Utilerias/site.js'></script>
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
        
        //VENTANA MODAL DEL PDF
        $(function() {
            $( "#dialog-pdf" ).dialog({
                autoOpen: false,
                modal: true,
                width:900,
                height:640,
                show: {
                effect: "blind",
                duration: 1000
                },
                hide: {
                effect: "explode",
                duration: 1000
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
        });
        
        <%--for(int i=0; i < listado.size(); i++){%>
        $(function() {
            $( "#dialog<%=i%>" ).dialog({
                autoOpen: false,
                show: {
                effect: "blind",
                duration: 1000
                },
                hide: {
                effect: "explode",
                duration: 1000
                },
                height: 750,
                width: 700
            });
        });
        <%}--%>
        </script>
        <!-- Jquery UI -->
            
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-pdf" title="Comprobante del Movimiento">
            <embed id="pdf" src="" width="870" height="580" align="center" valign="center">
        </div>        
    <table width="100%">
      <tr>
        <td width="5%">
          <img src="/siscaim/Imagenes/Empresa/cheque.png" align="center" width="50" height="40">                  
        </td>
        <td width="95%">
          <div class="titulo" align="left">
              GASTOS REGISTRADOS DE LA TARJETA DE <%=tarjeta.getTitular()%> - <%=tarjeta.getCuenta().substring(tarjeta.getCuenta().length()-6, tarjeta.getCuenta().length()) %>
          </div>
        </td>
      </tr>
    </table>
    <hr>
    <!-- inicia el formulario -->
    <form id="frmConsultarGastos" name="frmConsultarGastos" action="<%=CONTROLLER%>/Consultar/GastosTar" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <!-- inician los botones -->
        <table width="100%">
            <tr>
                <td width="100%" align="left">
                    <a id="btnCancelar" href="javascript: CancelarClick()"
                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                        background: indianred 50% bottom repeat-x;" title="Salir de Consultar Gastos de Tarjetas">
                        Cancelar
                    </a>
                </td>
            </tr>
        </table>
        <hr>
      <table width="100%">
          <tr>
              <td width="100%">
                  <table width="100%">
                      <tr>
                          <td width="100%" valign="top">
                              <div id="listado">
                                  <table class="tablaLista" width="100%" style="background-color: rgba(244, 255, 247, 0.7);">
                                  <%
                                    if (listado.size()==0){
                                  %>
                                  <tr>
                                      <td colspan="4" align="center">
                                          <span class="etiquetaB">
                                              No hay Gastos registrados en esta tarjeta
                                          </span>
                                      </td>
                                  </tr>
                                  <%
                                    } else {
                                  %>
                                  <thead>
                                      <tr>
                                          <td align="center" width="15%">
                                            <span>Fecha</span>
                                          </td>
                                          <td align="center" width="35">
                                            <span>Proveedor</span>
                                          </td>
                                          <td align="center" width="35%">
                                            <span>Concepto</span>
                                          </td>
                                          <td align="center" width="10%">
                                            <span>Monto</span>
                                          </td>
                                          <td align="center" width="5%">
                                            <span>Documento</span>
                                          </td>
                                      </tr>
                                  </thead>
                                  <tbody> 
                                  <%
                                    for (int i=0; i < listado.size(); i++)  {  
                                        Movimientos movi = listado.get(i);                                                  
                                  %>
                                  <tr onclick="Activa(<%=i%>)">
                                    <td align="center" width="15%">
                                        <span class="etiqueta"><%=movi.getFecha()%></span>
                                    </td>
                                    <td align="center" width="35%">
                                        <span class="etiqueta"><%=movi.getId_ca().getProveedor()%></span>
                                    </td>
                                    <td align="center" width="35%">
                                        <span class="etiqueta"><%=movi.getId_ca().getConcepto()%></span>
                                    </td>
                                    <td align="right" width="10%">
                                        <span class="etiqueta"><b><%=formato.format(movi.getId_ca().getCantidad())%></b></span>                                                                            
                                    </td>        
                                    <td align="center" width="5%">
                                          <a href="javascript: MostrarComprobante('/siscaim/Imagenes/Comprobantes/<%=movi.getId_ca().getRutaComprobante()%>')">
                                            <img src="/siscaim/Estilos/imgsBotones/doc_activo.png" width="26">
                                          </a>
                                    </td>
                                  </tr>
                                  <% } %>
                                  </tbody>
                                  <% }   %>
                                  </table>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td>
          </tr>
      </table>
    </form>
        <!-- Java Script -->
        <script language="javascript">
            function MostrarComprobante(doc){
                var pdf = document.getElementById('pdf');
                pdf.src = doc;
                $( "#dialog-pdf" ).dialog( "open" );
            }
            
            function CargaPagina(){
            <%
            if (sesion!=null && sesion.isError()){
            %>
            <%

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

        function CancelarClick(){
            var frm = document.getElementById('frmConsultarGastos');
            frm.paginaSig.value = '/Empresa/GestionarChequera/consultargastostar.jsp';
            frm.pasoSig.value = '98';
            frm.submit();
        }
        
        function MostrarDocumento(fila){
            $( "#dialog"+fila ).dialog( "open" );
        }
        </script>                                 
    </body>
</html>
