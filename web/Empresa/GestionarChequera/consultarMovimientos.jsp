<%-- 
    Document   : gestionarMovimientos
    Created on : Sep 19, 2013, 10:44:15 AM
    Author     : marba
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Movimientos, java.text.NumberFormat, java.text.DecimalFormat"%>
<%@page import="Modelo.Entidades.Chequera, java.text.SimpleDateFormat, java.util.Date"%>

<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
  HashMap datosS = sesion.getDatos();
  float saldoActual=((Double)datosS.get("saldoant")).floatValue();
  int paso = Integer.parseInt(datosS.get("paso").toString());
  List<Movimientos> listado = (List<Movimientos>)datosS.get("listaMovimientos");
  Chequera tarjeta = (Chequera)datosS.get("tarjetaSel");
  NumberFormat formato = new DecimalFormat("$ #,###,##0.00");
    SimpleDateFormat forfecha = new SimpleDateFormat("dd-MM-yyyy");
    String feci = forfecha.format((Date)datosS.get("fechai"));
    String fecf = forfecha.format((Date)datosS.get("fechaf"));
    String tipo = datosS.get("tipo").toString();
    int admin = Integer.parseInt(datosS.get("admin").toString());
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
            <link type="text/css" href="/siscaim/Estilos/titulos.css" rel="stylesheet" />
            <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
    <!-- Archivos para los cuadros modales 
            <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/normalize.css">
            <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/main.css">
            <script type='text/javascript' src='/siscaim/Utilerias/jquery-1.4.3.min.js'></script>
            <script type='text/javascript' src='/siscaim/Utilerias/jquery.modal.js'></script>
            <script type='text/javascript' src='/siscaim/Utilerias/site.js'></script>
            -->
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechai" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechaf" ).datepicker({
            changeMonth: true,
            changeYear: true
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
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnMostrar" ).button({
                icons: {
                    primary: "ui-icon-search"
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
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
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
        <td width="5%">
          <img src="/siscaim/Imagenes/Empresa/cheque.png" align="center" width="50" height="40">                  
        </td>
        <td width="95%">
          <div class="bigtitulo" align="left">
              GESTIONAR MOVIMIENTOS
          </div>
          <div class="titulo" align="left">
              TARJETA: <%=tarjeta.getUstitular().getEmpleado().getPersona().getNombreCompletoPorApellidos()%> - <%=tarjeta.getCuenta().substring(tarjeta.getCuenta().length()-6, tarjeta.getCuenta().length()) %>
          </div>
        </td>
      </tr>
    </table>
    <hr>
    <!-- inicia el formulario -->
    <form id="frmGestionarMovs" name="frmGestionarMovs" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <input id="idMovi" name="idMovi" type="hidden" value=""/>
      <input id="boton" name="boton" type="hidden" value=""/>
      <!-- inician los botones -->
      <div id="datos">
      <table width="100%">
          <tr>
              <td width="100%">
                  <table width="100%">
                      <tr>
                          <td width="100%" valign="top">
                              <table id="acciones1" width="100%">
                                  <tr>
                                      <td width="15%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Salir de Movimientos de Tarjeta">
                                            Cancelar
                                        </a>
                                      </td>
                                      <td width="15%" align="left">
                                        <a id="btnImprimir" href="javascript: Imprimir()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir movimientos">
                                            Imprimir
                                        </a>
                                        <%--<a id="btnGasto" href="javascript: NuevoGastoClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Editar Movimiento seleccionado">
                                            Nuevo Gasto
                                        </a>--%>
                                      </td>  
                                      <td width="5%" align="right">
                                      </td>
                                      <td width="15%" align="center">
                                          <select id="tipo" name="tipo" class="combo" style="width: 120px" onchange="OcultaLista()">
                                              <option value="0" <%if(tipo.equals("0")){%>selected<%}%>>TARJETA</option>
                                              <option value="1" <%if(tipo.equals("1")){%>selected<%}%>>EFECTIVO</option>
                                          </select>
                                      </td>
                                        <td width="20%" align="center">
                                            <span class="etiquetaB">Del:</span>
                                            <input id="fechai" name="fechai" type="text" class="text" readonly value="<%=feci%>"
                                                    title="Ingrese la fecha inicial del período a consultar" onchange="OcultaLista()"/>
                                        </td>
                                        <td width="20%" align="center">
                                            <span class="etiquetaB">Al:</span>
                                            <input id="fechaf" name="fechaf" type="text" class="text" readonly value="<%=fecf%>"
                                                title="Ingrese la fecha final del periodo a consultar" onchange="OcultaLista()"/>
                                        </td>
                                        <td width="10%" align="right">
                                            <a id="btnMostrar" href="javascript: BuscarClick()"
                                                style="width: 100px; font-weight: bold; color: #0B610B;" title="Buscar los movimientos">
                                                Buscar
                                            </a>
                                        </td>
                                  </tr>                                  
                              </table>
                              <hr>
                              <div id="dvlistado"> 
                                  <table width="100%">
                                      <tr>
                                          <td width="100%" align="center">
                                              <span class="subtitulo">SALDO ANTERIOR: <%=formato.format((Double)datosS.get("saldoant"))%></span>
                                          </td>
                                      </tr>
                                  </table>
                                  <table class="tablaLista" width="100%" style="background-color: rgba(244, 255, 247, 0.7);">
                                  <%
                                    if (listado.size()==0){
                                  %>
                                  <tr>
                                      <td colspan="4" align="center">
                                          <span class="etiquetaB">
                                              No hay movimientos registrados en esta tarjeta en el período indicado
                                          </span>
                                      </td>
                                  </tr>
                                  <%
                                    } else {
                                  %>
                                  <thead>
                                      <tr>
                                          <td align="center" width="11%">
                                            <span>Fecha</span>
                                          </td>
                                          <td align="center" width="25">
                                            <span>Proveedor</span>
                                          </td>
                                          <td align="center" width="25%">
                                            <span>Concepto</span>
                                          </td>
                                          <td align="center" width="10%">
                                            <span>Abono</span>
                                          </td>
                                          <td align="center" width="10%">
                                            <span>Cargo</span>
                                          </td>
                                          <td align="center" width="10%">
                                            <span>Saldo</span>
                                          </td>
                                          <td align="center" width="5%">
                                            <span>Referencia</span>
                                          </td>
                                          <td align="center" width="1%" style="display: none;">                        
                                          </td>
                                      </tr>
                                  </thead>
                                  <tbody> 
                                  <%
                                    for (int i=0; i < listado.size(); i++)  {  
                                        Movimientos movi = listado.get(i);                                                  
                                  %>
                                  <tr onclick="Activa(<%=i%>)">
                                    <td align="center" width="11%">
                                        <span class="etiqueta"><%=forfecha.format(movi.getFecha())%></span>
                                    </td>
                                    <%
                                        if(movi.getId_ab().getId()!=1)  { // es un abono : 1
                                    %>
                                    <td colspan="2" align="center">
                                        <span class="etiquetaB">DEP&Oacute;SITO</span>
                                    </td>
                                    <td align="right" width="10%">
                                        <span class="etiqueta"><%=formato.format(movi.getId_ab().getCantidad())%></span>
                                    </td>
                                    <td align="center" width="10%">
                                        <span class="etiqueta"></span>
                                    </td>
                                    <td align="right" width="10%">
                                        <% saldoActual = saldoActual + movi.getId_ab().getCantidad(); %>
                                        <span class="etiqueta"><%=formato.format(saldoActual)%></span>
                                        <input id="tipo" name="tipo" type="hidden" value="1"/>
                                    </td>
                                    <td align="center" width="5%">
                                        <span class="etiqueta"><%=movi.getReferencia()!=null?movi.getReferencia():""%></span>
                                        <%--
                                        <span class="etiqueta"> <!-- validamos si existe documento para mostrar el icono correspondiente -->
                                            <img src="/siscaim/Estilos/imgsBotones/doc_inactivo.png" width="26">
                                        </span>--%>
                                    </td>
                                    <td align="center" width="1%"style="display: none;">
                                        <span class="etiqueta"><input id="idCargoValue" name="idCargoValue" type="hidden" value="<%=movi.getId_ab().getId()%>"/> <!-- mandamos el id pa que sepa que cargo borrar --></span>
                                    </td>
                                    <% } else { %> <!-- Aqui entra cuando es un cargo-->
                                    <td align="center" width="25%">
                                        <span class="etiqueta"><%=movi.getId_ca().getProveedor()%></span>
                                    </td>
                                    <td align="center" width="25%">
                                        <span class="etiqueta"><%=movi.getId_ca().getConcepto()%></span>
                                    </td>
                                    <td align="center" width="10%">
                                        <span class="etiqueta"></span>
                                    </td>
                                    <td align="right" width="10%">
                                        <span class="etiqueta"><%=formato.format(movi.getId_ca().getCantidad())%></span>                                                                            
                                    </td>        
                                    <td align="right" width="10%">
                                        <%saldoActual = saldoActual - movi.getId_ca().getCantidad(); %>
                                        <span class="etiqueta"><%=formato.format(saldoActual)%></span>
                                        <input id="tipo" name="tipo" type="hidden" value="2"/>
                                    </td>
                                    <td align="center" width="5%">
                                        <span class="etiqueta"><%=movi.getReferencia()!=null?movi.getReferencia():""%></span>
                                    </td>
                                    <% } %>
                                    
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
<!-- Java Script -->
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
            if (listado.size()==0){
            %>
                var btnImpr = document.getElementById('btnImprimir');
                btnImpr.style.display = 'none';
            <%} if (admin==0){%>
                var btnImpr = document.getElementById('btnImprimir');
                btnImpr.style.display = 'none';
            <%}%>
        }
  
        function CancelarClick(){
            var frm = document.getElementById('frmGestionarMovs');
            frm.paginaSig.value = '/Empresa/GestionarChequera/tarjetasdetitular.jsp';
            frm.pasoSig.value = '13';
            frm.submit();
        }

        function Activa(fila){  
            var idMovi = document.getElementById('idMovi');
            <%
            if (listado.size()==1){
            %>
                document.frmGestionarMovs.radioMovi.checked = true;
                idMovi.value = document.frmGestionarMovs.radioMovi.value;
            <%
            } else {
            %>
                var radio = document.frmGestionarMovs.radioMovi[fila];
                radio.checked = true;
                idMovi.value = radio.value;
            <% } %>
        }            
  
    function OcultaLista(){
        var dvlis = document.getElementById('dvlistado');
        dvlis.style.display = 'none';
        var borrarEdit = document.getElementById('borrarEdit');
        borrarEdit.style.display = 'none';
    }

    function BuscarClick(){
        Espera();
        var frm = document.getElementById('frmGestionarMovs');
        var pagina = document.getElementById('paginaSig');
        var paso = document.getElementById('pasoSig');
        pagina.value = '/Empresa/GestionarChequera/consultarMovimientos.jsp';
        paso.value = '16';
        frm.submit();
    }
        
        function Imprimir(){
            window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Chequeramov'+'&paso=17',
                    '','width =800, height=600, left=0, top = 0, resizable= yes');
        }

</script>                                 
    </body>
</html>
