<%-- 
    Document   : gestionarTarjetas
    Created on : Sep 18, 2013, 10:38:21 AM
    Author     : marba
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Chequera"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
  HashMap datosS = sesion.getDatos();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title>Gestionar Chequera</title>
    </head>
    <body onload="CargaPagina()">
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
              <td width="15%">
                <img src="/siscaim/Imagenes/Empresa/cheque.png" width="80">                  
              </td>
              <td width="85%">
                <div class="titulo" align="left">
                    Administracion de Tarjetas
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
            <input id="idAlma" name="idAlma" type="hidden" value=""/>            
            <!-- inician los botones -->
            <table width="100%">
                <tr>
                    <td width="20%" align="left">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                          <tr>
                            <td style="padding-right:0px" title ="Salir">
                              <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                            </td>
                          </tr>
                        </table>                                                    
                    </td>
                    
                </tr>
            </table>
            <br>
  <!-- inicia el listado de las tarjetas existentes -->
        <center><h2>Tarjetas existentes al   
          <script type="text/javascript">
          var dias_semana = new Array("Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado");
          var meses = new Array ("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre", "Diciembre");
          var fecha_actual = new Date();
          document.write(dias_semana[fecha_actual.getDay()] + " " + fecha_actual.getDate() + " de " + meses[fecha_actual.getMonth()] + " de " + fecha_actual.getFullYear());
          </script>
        </h1></center>
            <table class="tablaLista" width="70%" align="center">
                <%
                    List<Chequera> listado = (List<Chequera>)datosS.get("listadoTarjetas");   
                    System.out.println("Listado de las tarjetas "+listado.size());
                    if (listado.size()==0){
                %>
                <tr>
                    <td colspan="4" align="center">
                        <span class="etiquetaB">
                            No hay tarjetas registradas :(
                        </span>
                    </td>
                </tr>
                <%
                    } else {
                %>
                <thead>
                    <tr>
                      <td align="center" width="10%">                        
                      </td>
                      <td align="center" width="10%">
                          <span>Tarjeta</span>
                      </td>
                      <td align="center" width="20%">
                          <span>Banco</span>
                      </td>
                      <td align="center" width="15%">
                          <span>Titular</span>
                      </td>
                      <td align="center" width="15%">
                          <span>Cuenta</span>
                      </td>                
                      <td align="center" width="10%">
                          <span>Saldo</span>
                      </td>
                    </tr>
            </thead>
            <tbody>
            <%    
                for (int i=0; i < listado.size(); i++){
                    Chequera tarjeta = listado.get(i);
            %>
                <tr onclick="Activa(<%=i%>)">
                    <td align="center" width="10%">
                        <input id="radioAlma" name="radioAlma" type="radio" value="<%=tarjeta.getId() %>"/>
                    </td>
                    <td align="center" width="10%">
                        <span class="etiqueta"><%=tarjeta.getEstado() %></span>
                    </td>
                    <td align="center" width="10%">
                        <span class="etiqueta"><%=tarjeta.getBanco()  %></span>
                    </td>
                </tr>
            </tbody>
            </table>
        </form>
    </body>
</html>
