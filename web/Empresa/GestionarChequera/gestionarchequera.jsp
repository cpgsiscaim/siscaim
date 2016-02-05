<%@page import="java.text.DecimalFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Chequera, Modelo.Entidades.Abono, java.text.NumberFormat"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
  HashMap datosS = sesion.getDatos();
  List<HashMap> totales = (List<HashMap>)datosS.get("totales");
  NumberFormat formato = new DecimalFormat("$ #,###,##0.00");
  int admin = Integer.parseInt(datosS.get("admin").toString());
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
        
        //DIALOGO CONFIRMACION
        $(function() {
            $( "#dialog-confirm" ).dialog({
            resizable: false,
            width:500,
            height:200,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                $( this ).dialog( "close" );
                EjecutarProceso();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
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
            $( "#btnNueva" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            $( "#btnAbono" ).button({
                icons: {
                    primary: "ui-icon-document-b"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnMovs" ).button({
                icons: {
                    primary: "ui-icon-video"
		}
            });
            $( "#btnInactivas" ).button({
                icons: {
                    primary: "ui-icon-cancel"
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
        
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
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
        <td width="95%" align="left" valign="center">
            <div class="bigtitulo" align="left">
                ADMINISTRACI&Oacute;N DE TARJETAS
            </div>
        </td>
      </tr>
    </table>
    <hr>
    <!-- inicia el formulario -->
    <form id="frmGestionarCheq" name="frmGestionarCheq" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <input id="idTar" name="idTar" type="hidden" value=""/>            
      <input id="boton" name="boton" type="hidden" value=""/>
      <!-- inician los botones -->
      <div id="datos">
      <table width="100%">
        <tr>
          <td width="10%" align="left">
            <a id="btnSalir" href="javascript: SalirClick()"
                style="width: 150px; font-weight: bold; color: #FFFFFF;
                background: indianred 50% bottom repeat-x;" title="Salir de Administración de Tarjetas">
                Salir
            </a>
          </td>
          <td width="15%" align="center">
            <a id="btnInactivas" href="javascript: VerInactivasClick()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar Tarjetas dadas de baja">
                Ver Inactivas
            </a>
          </td>
          <td width="15%" align="center">
            <a id="btnNueva" href="javascript: NuevaTarjeta()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Nueva Tarjeta">
                Nueva Tarjeta
            </a>
          </td>
          <td width="15%" align="center">
            <a id="btnAbono" href="javascript: NuevoMovClick()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Nuevo Depósito">
                Nuevo Depósito
            </a>
          </td>
          <td width="45%" align="right">
            <table id="borrarEdit" width="100%" style="display: none">
              <tr>
                <td width="33%" align="right">
                    <a id="btnEditar" href="javascript: EditarClick()"
                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar datos de la tarjeta seleccionada">
                        Editar
                    </a>
                </td>          
                <td width="33%" align="right">
                    <a id="btnBaja" href="javascript: BajaClick()"
                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja la tarjeta seleccionada">
                        Baja
                    </a>
                </td>          
                <td width="33%" align="right">
                    <a id="btnMovs" href="javascript: MovimientosClick()"
                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver movimientos de la tarjeta">
                        Movimientos
                    </a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <br>
<!-- Aqui comienza el listado de los movimientos -->
    <table class="tablaLista" width="90%" align="center">
    <%
      List<Chequera> listota = (List<Chequera>)datosS.get("listadoTar");    
      if(listota.size()==0) {             
    %>
    <tr>
        <td colspan="4" align="center">
            <span class="etiquetaB">
                No hay tarjetas registradas
            </span>
        </td>
    </tr>
    <%
         } else {
    %>
    <thead>
      <tr>
        <td align="center" width="3%">
            <span></span>
        </td>      
        <td align="center" width="12%">
            <span>Sucursal</span>
        </td>
        <td align="center" width="20%">
            <span>Administrador</span>
        </td>
        <td align="center" width="17%">
            <span>Titular</span>
        </td>
        <td align="center" width="10%">
            <span>Cuenta</span>
        </td>
        <td align="center" width="10%">
            <span>Saldo Tarjeta</span>
        </td>
        <td align="center" width="10%">
            <span>Saldo Efectivo</span>
        </td>
      </tr>
    </thead>
    <tbody>
    <%
      for (int i=0; i < listota.size(); i++){
        Chequera tarjeta = listota.get(i);
        HashMap tots = totales.get(i);
    %>
    <tr onclick="Activa(<%=i%>)">
      <td align="center" width="3%">
          <input id="radioTar" name="radioTar" type="radio" value="<%=tarjeta.getId()%>"/>
      </td> 
      <td align="left" width="12%">
          <span class="etiqueta"><%=tarjeta.getAlmacen().getDatosfis().getRazonsocial()%></span>
      </td> 
      <td align="left" width="20%">
          <span class="etiqueta"><%=tarjeta.getResponsable().getEmpleado().getPersona().getNombreCompleto()%></span>
      </td>
      <td align="left" width="17%">
          <span class="etiqueta"><%=tarjeta.getUstitular()!=null?tarjeta.getUstitular().getEmpleado().getPersona().getNombreCompleto():""%></span>
      </td>
      <td align="right" width="10%">
          <span class="etiqueta"><%=tarjeta.getCuenta()%></span>
      </td>
      <td align="right" width="10%">
          <span class="etiqueta"><%=formato.format(Double.parseDouble(tots.get("totsaldotar").toString()))%></span>
      </td>
      <td align="right" width="10%">
          <span class="etiqueta"><%=formato.format(Double.parseDouble(tots.get("totsaldoefe").toString()))%></span>
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
                <%} if (admin==0){%>
                    var btnNva = document.getElementById('btnNueva');
                    var btnAbo = document.getElementById('btnAbono');
                    var btnEdi = document.getElementById('btnEditar');
                    var btnBaja = document.getElementById('btnBaja');
                    var btnInac = document.getElementById('btnInactivas');
                    btnNva.style.display = 'none';
                    btnAbo.style.display = 'none';
                    btnEdi.style.display = 'none';
                    btnBaja.style.display = 'none';
                    btnInac.style.display = 'none';
                <%}%>
            }
            
            function NuevoMovClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/nuevoMovimiento.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function MovimientosClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
            function NuevaTarjeta()  {
                Espera();
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/nuevaChequera.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function ImprimirReporte(){
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/imprimirReporte.jsp';
            }
            
            function Activa(fila){
                var idRuta = document.getElementById('idTar');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listota.size()==1){
                %>
                    document.frmGestionarCheq.radioTar.checked = true;
                    idTar.value = document.frmGestionarCheq.radioTar.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarCheq.radioTar[fila];
                    radio.checked = true;
                    idTar.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/nuevaChequera.jsp';
                paso.value = '18';
                frm.submit();                
            }

            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
            }

            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
                paso.value = "19";
                frm.submit();     
            }

            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro de dar de baja la tarjeta seleccionada?');
            }
            
            function VerInactivasClick(){
                Espera();
                var frm = document.getElementById('frmGestionarCheq');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarChequera/inactivas.jsp';
                paso.value = "20";
                frm.submit();     
            }
        </script>
  </body>  
</html>