<%-- 
    Document   : movimientoOk
    Created on : Oct 16, 2013, 9:58:03 AM
    Author     : germha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%@page import="java.util.HashMap, Modelo.Entidades.Cargo, java.util.List, Modelo.Entidades.Chequera"%>
<!DOCTYPE html>
<%
    HashMap datosS = sesion.getDatos();  
    int t = Integer.parseInt(datosS.get("tipoMovimiento").toString());
    int z = Integer.parseInt(datosS.get("temporalAlma").toString());
    int i = (Integer.parseInt(datosS.get("temporalCargo").toString()));
    //Recibimos el id, pero lo ajustamos con el valor recibido del monto ;) se condiciona con un AND
    System.out.println("valor del id del cargo a borrar "+i);     
    //Enlistamos los cargos 
    List<Cargo> listado = (List<Cargo>)datosS.get("listadoCar");
    //Comparamos que se cumpla el id = id y monto = monto, para asegurar que es el id
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/titulos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title>JSP Page</title>
    </head>
    <body>
        <br>    
        <table width="40%" align="center">
            <tr>
                <td  align="center"><h1>Movimiento eliminado exitosamente!!</h1></td>
            </tr>
            <tr>
                <td>
                <center>
                  <img src="/siscaim/Imagenes/Empresa/ok.png">
                </center>
                </td>
            </tr>
            <tr>
                <form id="frmGestionarMovs" name="frmGestionarMovs" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
                    <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
                    <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
                    <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
                    <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
                    <input id="id_cargo" name="id_cargo" type="hidden" value="<%=i%>"/>                        
                    <input id="idAlma" name="idAlma" type="hidden" value="<%=z%>"/>
                    <table id="borrarEdit" width="100%">
                      <tr>
                        <td width="15%" align="center">
                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:center bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                <tr>
                                    <td style="width: 200px; alignment-adjust: central;" title ="Editar">
                                      <%
                                      if(t==1)  {
                                      %>
                                        <a href="javascript: borrarAbono()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/continuar.png);width:150px;height:30px;display:block;"><br/></a>
                                      <% } else { %>
                                        <a href="javascript: borrarCargo()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/continuar.png);width:150px;height:30px;display:block;"><br/></a>
                                      <% } %>  
                                    </td>
                                </tr>
                            </table>                                                    
                        </td>
                      </tr>
                    </table>
                </form>
            </tr>
        </table>    
        
<!-- Java Script -->
<script language="javascript">
  function borrarAbono()  {
    var frm = document.getElementById('frmGestionarMovs');
    var pagina = document.getElementById('paginaSig');
    var paso = document.getElementById('pasoSig');
    pagina.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
    paso.value = '14';
    frm.submit();             
  }
    function borrarCargo()   {
        var frm = document.getElementById('frmGestionarMovs');
        var pagina = document.getElementById('paginaSig');
        var paso = document.getElementById('pasoSig');
        pagina.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
        paso.value = '11';
        frm.submit();             
    }
</script>            
    </body>
</html>
