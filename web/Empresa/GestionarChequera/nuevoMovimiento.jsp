<%-- 
    Document   : nuevoMovimiento
    Created on : 12/08/2013, 10:04:38 AM
    Author     : germain

MODIFICADO POR: CUAUHTEMOC PALMA, DICIEMBRE-2013
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Chequera"%>
<%@page import="java.text.SimpleDateFormat, java.util.Date, Modelo.Entidades.Movimientos, java.text.DecimalFormat, java.text.NumberFormat"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
    HashMap datosS = sesion.getDatos();
    List<Chequera> listado = (List<Chequera>)datosS.get("listadoTar");
    SimpleDateFormat forfecha = new SimpleDateFormat("dd-MM-yyyy");
    NumberFormat forcant = new DecimalFormat("#,##0.00");
    String shoy = "", concep="", cant="", tit="REGISTRAR", ref="";
    int tipo = 0;
    Chequera tarjeta = new Chequera();
    if (datosS.get("accion").toString().equals("editar")){
        tarjeta = (Chequera)datosS.get("tarjetaSel");
        Movimientos mov = (Movimientos)datosS.get("editarMovimiento");
        concep = mov.getId_ab().getConcepto();
        tipo = mov.getTipo();
        shoy = forfecha.format(mov.getFecha());
        cant = forcant.format(mov.getId_ab().getCantidad());
        ref = mov.getReferencia();
        tit = "EDITAR";
    } else {
        shoy = forfecha.format((Date)datosS.get("hoy"));
    }
%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
    <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
    <!--<link type="text/css" href="/siscaim/Estilos/formValidado.css" rel="stylesheet" />-->
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
                    <%=tit%> DEPÓSITO
                </div>
            </td>
        </tr>
    </table>
    <hr>      
      
    <form id="nuevoMov" name="nuevoMov" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <div id="datos">
      <table id="tablon" width="50%" align="center">
                <tr>
                    <td width="100%">
                        <table width="100%" align="center">
                            <tr>
                                <td width="100%" valign="top">                                        
                                    <span class="etiquetaB">Tarjeta:</span><br>
                                    <select id="nt" name="nt" class="combo" style="width: 400px"
                                            title="Elija la Tarjeta a la que se hará el depósito">
                                        <% 
                                        for (int i=0; i < listado.size(); i++) {
                                            Chequera tarjeton = listado.get(i);
                                        %> 
                                        <option value="<%=tarjeton.getId()%>" <%if(tarjeta.getId()==tarjeton.getId()){%>selected<%}%>>
                                            <%=tarjeton.getUstitular().getEmpleado().getPersona().getNombreCompletoPorApellidos()+" ("+tarjeton.getCuenta().substring(tarjeton.getCuenta().length()-6, tarjeton.getCuenta().length())+")"%>    
                                        </option>
                                        <% 
                                        }
                                        %>
                                    </select><br>                                        
                                    <span class="etiquetaB">Concepto:</span><br>
                                    <input id="concepto" name="concepto" class="text" type="text" value="<%=concep%>" style="width: 400px"
                                           maxlength="80" onblur="Mayusculas(this)" title="Escriba el concepto del depósito"/>
                                    <br>                                  
                                    <span class="etiquetaB">No. de Referencia:</span><br>
                                    <input id="comprueba" name="comprueba" class="text" type="text" value="<%=ref%>" style="width: 300px"
                                           maxlength="35" onblur="Mayusculas(this)" title="Escriba el número de referencia bancario del depósito"/>
                                    <br>
                                    <span class="etiquetaB">Tipo:</span><br>
                                    <select id="tipo" name="tipo" class="combo" style="width: 150px" title="Elija el tipo del depósito">
                                        <option value="0" <%if (tipo==0){%>selected<%}%>>TARJETA</option>
                                        <option value="1" <%if (tipo==1){%>selected<%}%>>EFECTIVO</option>
                                    </select>
                                    <br>
                                    <span class="etiquetaB">Fecha:</span><br>
                                    <input id="fecha" name="fecha" type="text" class="text" readonly value="<%=shoy%>"
                                        title="Ingrese la fecha del depósito"/>
                                    <br>
                                    <span class="etiquetaB">Monto:</span><br>
                                    <input id="abono" name="abono" class="text" type="text" value="<%=cant%>" style="width: 200px; text-align: right"
                                            maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"
                                            onblur="Formatea(this)" title="Escriba el monto del depósito"/>
                                    <br>
                                    <span class="etiquetaB">Referencia:</span><br>
                                    <input id="referencia" name="referencia" class="text" type="text" value="<%=ref%>" style="width: 400px"
                                           maxlength="80" onblur="Mayusculas(this)" title="Escriba la referencia del depósito"/>
                                    <br>                                  
                                </td>
                            </tr>
                        </table>
                        <br><br>
                        <!--botones-->
                        <table width="100%">
                            <tr>
                                <td width="80%" align="right">
                                    <a id="btnGuardar" href="javascript: GuardarClick()"
                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar depósito">
                                        Guardar
                                    </a>
                                </td>
                                <td width="20%">
                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                        background: indianred 50% bottom repeat-x;" title="Cancelar registro de depósito">
                                        Cancelar
                                    </a>
                                </td>
                            </tr>
                        </table>
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
                %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('nuevoMov');
                frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('nuevoMov');
                    frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
                    frm.pasoSig.value = '3';
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var concepto = document.getElementById('concepto');
                if (concepto.value == ''){
                    MostrarMensaje('El campo Concepto está vacío');
                    return false;
                }
                
                var ref = document.getElementById('comprueba');
                if (ref.value == ''){
                    MostrarMensaje('El campo No. de Referencia está vacío');
                    return false;
                }
                
                var monto = document.getElementById('abono');
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
                
                return true;
            }

            function Formatea(obj){
                obj.value = formato_numero(obj.value, 2, '.', ',');
            }
      </script>
  </body>
</html>
