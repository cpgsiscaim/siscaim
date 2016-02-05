<%-- 
    Document   : editarMovimientos
    Created on : Oct 14, 2013, 11:53:12 AM
    Author     : germha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, Modelo.Entidades.Movimientos, Modelo.Entidades.Chequera,java.util.Date;"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    String tarjeta="", concep_cargo="", fe="", concepto="";
    float cargo=0, abono=0;
    int id_=0,x=0, idupdateC=0, idupdateA=0, tipo_movi=0;
    Date fecha;    
    HashMap datosS = sesion.getDatos();
    Chequera ta = (Chequera)datosS.get("tarjetaSel");
    if (datosS.containsKey("editarMovimiento"))    {     
     Movimientos temp = new Movimientos();   
     temp = (Movimientos)datosS.get("editarMovimiento");
     
     tarjeta = temp.getId_ch().getCuenta();
     cargo = temp.getId_ca().getCantidad();
     concep_cargo = temp.getId_ca().getConcepto();
     abono = temp.getId_ab().getCantidad();
     concepto = temp.getId_ab().getConcepto();
     fecha = temp.getFecha();
     fe = fecha.toString();
     id_ = temp.getId();
     idupdateC = temp.getId_ca().getId();
     idupdateA = temp.getId_ab().getId();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/formValidado.css" rel="stylesheet" />
        <title>JSP Page</title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="10%">
                  <img src="/siscaim/Imagenes/Empresa/agregar.png" width="50">
                </td>  
                <td width="90%">
                    <div class="titulo" align="left">
                        Editar movimiento
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form class="contact_form" id="nuevoMov" name="nuevoMov" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>      
            <input id="idMovi" name="idMovi" type="hidden" value="<%=id_%>"/>      
            <input id="idAlma" name="idAlma" type="hidden" value="<%=ta.getId()%>"/>
            <table id="tablon">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table class="tablon">
                                <tr>
                                    <td width="30%" align="center" valign="top">
                                      <img src="/siscaim/Imagenes/Empresa/chequeFirma.jpg" width="400">
                                    </td>
                                    <td width="70%" valign="top">
                                        <span class="etiqueta">Tipo de Movimiento: </span>
                                        <table>
                                        <%
                                            if(cargo==0)    {      // edicion del movimiento tipo Abono          
                                                tipo_movi = 1;
                                        %>
                                        <tr>
                                            <td colspan="2" style="text-align: center; background-color: rgba(200, 245, 201, 0.8);">Abono</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="etiqueta">Tarjeta</span><br>
                                                <input id="tarjeta" name="tarjeta" type="text" value="<%=tarjeta%>"  disabled>
                                                <input id="idUpdate" name="idUpdate" type="hidden" value="<%=idupdateA%>"/>
                                                <input id="tipo" name="tipo" type="hidden" value="1"/>
                                                <br><br>
                                            </td>
                                            <td>
                                                <span class="etiqueta">Fecha</span><br>
                                                <input id="fecha" name="fecha" type="text" value="<%=fe.toString()%>" style="margin-left: 12px; width: 70px;" onblur="Mayusculas(this)">
                                                <br><br>
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td>
                                                <span class="etiqueta">Concepto</span><br>
                                                <input id="concepto" name="concepto" type="text" value="<%=concepto%>" onblur="Mayusculas(this)">
                                                <br>
                                            </td>
                                            <td>
                                                <span class="etiqueta">Monto</span><br>
                                                <input id="monto" name="monto" type="text" value="<%=abono%>" style="margin-left: 12px; width: 70px;" onkeypress="return soloNumeros(event)">
                                                <br>
                                            </td>                                            
                                        </tr>
                                        <% } else {     //edicion del movimiento tipo cargo
                                            tipo_movi = 2;
                                        %>
                                        <tr>
                                            <td colspan="2" style="text-align: center; background-color: rgba(200, 245, 201, 0.8);">Cargo</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="etiqueta">Tarjeta</span><br>
                                                <input id="tarjeta" name="tarjeta" type="text" value="<%=tarjeta%>"  disabled>
                                                <input id="idUpdate" name="idUpdate" type="hidden" value="<%=idupdateC%>"/>
                                                <input id="tipo" name="tipo" type="hidden" value="2"/>
                                            </td>
                                            <td>
                                                <span class="etiqueta">Fecha</span><br>
                                                <input id="fecha" name="fecha" type="text" value="<%=fe.toString()%>" onblur="Mayusculas(this)">
                                                <br>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span class="etiqueta">Monto</span><br>
                                                <input id="monto" name="monto" type="text" value="<%=cargo%>" onkeypress="return soloNumeros(event)">
                                            </td>
                                            <td>
                                                <span class="etiqueta">Concepto</span><br>
                                                <input id="concepto" name="concepto" type="text" value="<%=concep_cargo%>" onblur="Mayusculas(this)">
                                            </td>
                                        </tr>
                                        <% } %>                                        
                                        </table>
                                    </td>                                    
                                </tr>
                            </table>
                            <br><br>
                            <!-- botones para la edicion-->
                            <table width="100%">
                                <tr>
                                    <%if(tipo_movi==1)  { // es un abono %>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarAbonoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <% } else   {  // es un cargo %>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <%  }   %>
                                    <td width="20%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
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
    function soloNumeros(e){
       key = e.keyCode || e.which;
       tecla = String.fromCharCode(key).toLowerCase();
       letras = "1234567890.";
       especiales = [9];

       tecla_especial = false
       for(var i in especiales){
            if(key == especiales[i]){
                tecla_especial = true;
                break;
            }
        }

        if(letras.indexOf(tecla)==-1 && !tecla_especial){
            return false;
        }
    }
    function GuardarAbonoClick()   {
        var frm = document.getElementById('nuevoMov');
        frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
        frm.pasoSig.value = '15';
        frm.submit();
    }
    function GuardarClick(){ //Mas bien es actualizar
                var frm = document.getElementById('nuevoMov');
                frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
                frm.pasoSig.value = '10';
                frm.submit();
 }
      function CancelarClick(){
                var frm = document.getElementById('nuevoMov');
                frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
 }
</script>                                       
    </body>
</html>
