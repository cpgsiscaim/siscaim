<%-- 
    Document   : nuevoCargo
    Created on : 16/08/2013, 08:28:21 AM
    Author     : germain
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Chequera, Modelo.Entidades.Usuario"%>
<%@page import="java.text.SimpleDateFormat, java.util.Date, Modelo.Entidades.Movimientos, java.text.DecimalFormat, java.text.NumberFormat"%>

<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
  HashMap datosS = sesion.getDatos();
  //List<Chequera> listado = (List<Chequera>)datosS.get("listadoTar");
  Chequera tarjeta = (Chequera)datosS.get("tarjetaSel");
  NumberFormat forcant = new DecimalFormat("#,##0.00");
  SimpleDateFormat forfecha = new SimpleDateFormat("dd-MM-yyyy");
  String shoy = "", concep="", cant="", prov="", archivoCargo="", titulo="REGISTRAR", ref="";
  int tipo = 0;
  if (datosS.get("accion").toString().equals("editar")){
      Movimientos mov = (Movimientos)datosS.get("editarMovimiento");
      concep = mov.getId_ca().getConcepto();
      tipo = mov.getTipo();
      shoy = forfecha.format(mov.getFecha());
      cant = forcant.format(mov.getId_ca().getCantidad());
      prov = mov.getId_ca().getProveedor();
      titulo = "EDITAR";
      archivoCargo = mov.getId_ca().getRutaComprobante();
      ref = mov.getReferencia();
  } else {
      shoy = forfecha.format((Date)datosS.get("hoy"));
      archivoCargo = datosS.get("archivoCargo").toString();
  }
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
    <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
    <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
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
            $( "#fecha" ).datepicker({
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
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
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
            <td width="5%">
              <img src="/siscaim/Imagenes/Empresa/chequeFirma.jpg" align="center" width="50" height="40">
            </td>  
            <td width="95%">
                <div class="bigtitulo" align="left">
                    <%=titulo%> GASTO
                </div>
                <div class="titulo" align="left">
                    TARJETA: <%=tarjeta.getTitular()%> - <%=tarjeta.getCuenta().substring(tarjeta.getCuenta().length()-6, tarjeta.getCuenta().length()) %>
                </div>
            </td>
        </tr>
    </table>
    <hr>
    <!-- enctype="multipart/form-data" /siscaim/Empresa/GestionarChequera/subeComprobante.jsp CONTROLLER>/Gestionar/Chequeramov -->
    <form id="nuevoCargo" name="nuevoCargo" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <input id="rutaArchivo" name="rutaArchivo" type="hidden" value="<%=archivoCargo%>"/>
      <!-- Inician los botones :p -->
      <div id="datos">
      <table id="tablon">
        <tr>
          <td width="100%">
            <div class="titulo" align="center">
              <table>
                <tr>
                  <td width="30%" align="center" valign="top">
                    <img src="/siscaim/Imagenes/Empresa/tarjeta.png" width="320">
                  </td>
                  <td width="70%" valign="top">    
                    <span class="etiqueta">Concepto:</span><br>
                    <input id="concepto" name="concepto" class="text" type="text" value="<%=concep%>" style="width: 230px"
                           maxlength="80" onblur="Mayusculas(this)" title="Escriba el concepto del gasto"/>
                    <br>
                    <span class="etiqueta">Tipo de pago:</span><br>
                    <select id="tipoP" name="tipoP" class="combo" style="width: 230px"
                            title="Elija de dónde se pagó el gasto">
                        <option value="0" <%if (tipo==0){%>selected<%}%>>TARJETA</option>
                        <option value="1" <%if (tipo==1){%>selected<%}%>>EFECTIVO</option>
                    </select><br>                   
                    <span class="etiquetaB">Fecha:</span><br>
                    <input id="fecha" name="fecha" type="text" class="text" readonly value="<%=shoy%>"
                        title="Ingrese la fecha del depósito"/>
                    <br>
                    <span class="etiqueta">Monto del gasto:</span><br>
                    <input id="cantidad" name="cantidad" class="text" type="text" value="<%=cant%>" style="width: 230px; text-align: right"
                           maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"
                           onblur="Formatea(this)" title="Escriba el monto del gasto"/>
                    <br>                                        
                    <span class="etiqueta">Proveedor:</span><br>
                    <input id="proveedor" name="proveedor" class="text" type="text" value="<%=prov%>" style="width: 230px"
                           maxlength="35" onblur="Mayusculas(this)" title="Escriba el nombre de la empresa donde se realizó la compra"/>
                    <br>
                    <span class="etiqueta">Referencia:</span><br>
                    <input id="referencia" name="referencia" class="text" type="text" value="<%=ref%>" style="width: 230px"
                           maxlength="80" onblur="Mayusculas(this)" title="Escriba la referencia del gasto"/>
                    <br>
                  </td>
                </tr>
              </table>
            </div>
          </td>
        </tr>
      </table>
    <table width="100%">
        <tr>
            <td width="80%" align="right">
                <a id="btnGuardar" href="javascript: GuardarClick()"
                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar gasto">
                    Guardar
                </a>
            </td>
            <td width="20%" align="right">
                <a id="btnCancelar" href="javascript: CancelarClick()"
                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                    background: indianred 50% bottom repeat-x;" title="Cancelar registro de gasto">
                    Cancelar
                </a>
            </td>
        </tr>
    </table>
    </div>
    <div id="procesando" style="display: none">
        <table id="tbprocesando" align="center" width="100%">
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
  <!-- Codigo Java Script -->
    <script language="javascript">
        function MostrarMensaje(mensaje){
            var mens = document.getElementById('alerta');
            mens.textContent = mensaje;
            $( "#dialog-message" ).dialog( "open" );
        }
            
        function Espera(){
            var mens = document.getElementById('procesando');
            mens.style.display = '';
            var datos = document.getElementById('datos');
            datos.style.display = 'none';                
        }
        
        function Formatea(obj){
            obj.value = formato_numero(obj.value, 2, '.', ',');
        }
        
        function ValidaRequeridos(){
            var concepto = document.getElementById('concepto');
            if (concepto.value == ''){
                MostrarMensaje('El campo Concepto está vacío');
                return false;
            }

            var monto = document.getElementById('cantidad');
            if (monto.value == ''){
                MostrarMensaje('El campo Monto está vacío');
                return false;
            } else {
                var fmon = parseFloat(monto.value);
                if (fmon<=0){
                    MostrarMensaje('El campo Monto debe ser mayor a cero');
                    return false;
                }
            }
            
            var prov = document.getElementById('proveedor');
            if (prov.value == ''){
                MostrarMensaje('El campo Proveedor está vacío');
                return false;
            }
            
            return true;
        }
        
        function GuardarClick(){
            if (ValidaRequeridos()){
                Espera();
                var frm = document.getElementById('nuevoCargo');
                frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
                frm.pasoSig.value = '6';
                frm.submit();
            }
        }
        
        function CancelarClick(){
            var frm = document.getElementById('nuevoCargo');
            frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
            frm.pasoSig.value = '98';
            frm.submit();
        }
  </script>
  </body>
</html>
