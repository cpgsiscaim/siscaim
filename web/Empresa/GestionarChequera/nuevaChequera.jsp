 <%-- 
    Document   : nuevaChequera
    Created on : 26/08/2013, 10:05:03 AM
    Author     : germain
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Usuario, Modelo.Entidades.Persona "%>
<%@page import="Modelo.Entidades.Chequera"%>

<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
  HashMap datosS = sesion.getDatos();
  List<Usuario> usuarios = (List<Usuario>)datosS.get("listadoUsu");
  //List<Persona> listaP = (List<Persona>)datosS.get("listadoPer");
  List<Sucursal> listaS = (List<Sucursal>)datosS.get("listadoSuc");
  Chequera tarjeta = new Chequera();
  Sucursal suctar = new Sucursal();
  Usuario ustar = new Usuario(); 
  Usuario ustit = new Usuario();
  String titulo = "NUEVA", titular = "", cta="", clabe="";
  if (datosS.get("accion").toString().equals("editar")){
      tarjeta = (Chequera)datosS.get("tarjetaSel");
      titulo = "EDITAR";
      suctar = tarjeta.getAlmacen();
      ustar = tarjeta.getResponsable();
      ustit = tarjeta.getUstitular()!=null?tarjeta.getUstitular():new Usuario();
      titular = tarjeta.getTitular();
      cta = tarjeta.getCuenta();
      clabe = tarjeta.getClabe();
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
      <%--
    <table width="100%">
      <tr>
        <td width="100%" class="tablaMenu">
          <div align="left">
              <%@include file="/Generales/IniciarSesion/menu.jsp" %>
          </div>
        </td>
      </tr>
    </table>--%>
    <table width="100%">
        <tr>
            <td width="5%">
              <img src="/siscaim/Imagenes/Empresa/agregar.png" align="center" width="50" height="40">
            </td>  
            <td width="95%">
                <div class="bigtitulo" align="left">
                    <%=titulo%> TARJETA
                </div>
            </td>
        </tr>
    </table>
    <hr>
    <form id="nuevaChequera" name="nuevoMov" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <div id="datos">
      <table width="100%">
        <tr>
          <td width="100%">
            <div class="titulo" align="center">
              <table>
                <tr>
                  <td width="30%" align="center" valign="top">
                    <img src="/siscaim/Imagenes/Empresa/tarjeta.png" width="320">
                  </td>
                  <td width="70%" valign="top">                                                            
                    <span class="etiqueta">Sucursal:</span><br>
                    <select id="sucursal" name="sucursal" class="combo" <%--onchange="CargaUsuarios(this.value)"--%>
                            title="Elija la sucursal" style="width: 200px">
                        <option value="">Elija la Sucursal...</option>
                    <%
                        for(int z=0; z < listaS.size(); z++)        {
                            Sucursal suc = listaS.get(z);
                    %>
                    <option value="<%=suc.getId()%>" <%if(suc.getId()==suctar.getId()){%>selected<%}%>>
                        <%=suc.getDatosfis().getRazonsocial()%></option>
                    <% } %>
                    </select> 
                    <br>
                    <span class="etiqueta">Administrador de tarjeta:</span><br>
                    <select id="adminTarjeta" name="adminTarjeta" class="combo" title="Elija el Administrador de la tarjeta"
                            style="width: 300px">
                        <option value="">Elija el Administrador...</option>
                    <% 
                       for (int i=0; i < usuarios.size(); i++) {
                           Usuario user = usuarios.get(i);
                    %>
                    <option value="<%=user.getIdusuario()%>" <%if(user.getIdusuario()==ustar.getIdusuario()){%>selected<%}%>>
                    <%=user.getEmpleado().getPersona().getNombreCompletoPorApellidos()%></option>
                    <%
                      }
                    %>
                    </select>
                    <br>
                    <span class="etiqueta">Titular:</span><br>
                    <select id="ustitular" name="ustitular" class="combo" title="Elija el Titular de la tarjeta"
                            style="width: 300px">
                        <option value="">Elija el Titular...</option>
                        <%for (int i=0; i < usuarios.size(); i++) {
                               Usuario user = usuarios.get(i);
                        %>
                        <option value="<%=user.getIdusuario()%>" <%if(user.getIdusuario()==ustit.getIdusuario()){%>selected<%}%>>
                            <%=user.getEmpleado().getPersona().getNombreCompletoPorApellidos()%>
                        </option>
                        <%}%>
                    </select>
                    <input id="titular" name="titular" class="text" type="hidden" value="<%=titular%>" style="width: 300px"
                        onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                        maxlength="255" title="Ingrese el nombre del titular de la tarjeta"/>
                    <%--
                    <select id="titular" name="titular">
                    <%
                        for(int y=0; y < listaP.size(); y++)  {
                            Persona per = listaP.get(y);
                    %>
                    <option value="<%=per.getNombreCompleto()%>" <%if(user.getIdusuario()==ustar.getIdusuario()){%>selected<%}%>>
                    <%=per.getNombreCompleto()%></option>
                    <%
                       }
                    %>
                    </select>--%>
                    <br>
                    <span class="etiqueta">Cuenta:</span><br>
                    <input id="cuenta" name="cuenta" class="text" type="text" value="<%=cta%>" style="width: 200px"
                           maxlength="35" onblur="Mayusculas(this)" title="Ingrese el número de cuenta de la tarjeta"/><br>  
                    <span class="etiqueta">Clabe:</span><br>
                    <input id="clabe" name="clabe" class="text" type="text" value="<%=clabe%>" style="width: 200px"
                           maxlength="35" onblur="Mayusculas(this)" title="Ingrese el número clabe de la tarjeta"/><br>  
                  </td>
                </tr>
              </table>
              <br><br>
              <!--botones-->
              <table width="100%">
                <tr>
                  <td width="80%" align="right">
                        <a id="btnGuardar" href="javascript: GuardarClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
                            Guardar
                        </a>
                      <!--
                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                      <tr>
                          <td style="padding-right:0px" title ="Guardar">
                              <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                          </td>
                      </tr>
                    </table>-->
                  </td>
                  <td width="20%">
                        <a id="btnCancelar" href="javascript: CancelarClick()"
                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                            Cancelar
                        </a>
                      <!--
                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                      <tr>
                          <td style="padding-right:0px" title ="Cancelar">
                              <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                          </td>
                      </tr>
                    </table>-->
                  </td>
                </tr>
              </table>
              
            </div>
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
<!-- Inician las funciones JavaScript -->      
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
            <%if (sesion!=null && sesion.isError()){%>
                MostrarMensaje('<%=sesion.getMensaje()%>')
            <%
            }
            if (sesion!=null && sesion.isExito()){
            %>
                MostrarMensaje('<%=sesion.getMensaje()%>'); //llamar a la funcion que redirija a la pagina siguiente
            <%}%>
            <%--if (datosS.get("accion").toString().equals("editar")){%>
                CargaUsuarios('<%=suctar.getId()%>');
            <%}--%>
        }
        
        function CargaUsuarios(suc){
            var adminTarjeta = document.getElementById('adminTarjeta');
            adminTarjeta.length=0;
            adminTarjeta.options[0] = new Option('Elija el Administrador...','');
            k=1;
            <%for (int i=0; i < usuarios.size(); i++){
                Usuario us = usuarios.get(i);
            %>
                if (suc == '<%=us.getEmpleado().getPersona().getSucursal().getId()%>'){
                    adminTarjeta.options[k] = new Option('<%=us.getEmpleado().getPersona().getNombreCompletoPorApellidos()%>','<%=us.getIdusuario()%>');
                    <%if (datosS.get("accion").toString().equals("editar")){%>
                        if ('<%=us.getIdusuario()%>'=='<%=ustar.getIdusuario()%>'){
                            adminTarjeta.options[k].selected = true;
                        }
                    <%}%>
                    k++;                    
                }
            <%}%> 
        }
        
        function CancelarClick(){
            var frm = document.getElementById('nuevaChequera');
            frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
            frm.pasoSig.value = '97';
            frm.submit();
        }
        
        function ValidaRequeridos(){
            var suc = document.getElementById('sucursal');
            if (suc.value == ''){
                MostrarMensaje('No ha elegido la sucursal');
                return false;
            }
            
            var admin = document.getElementById('adminTarjeta');
            if (admin.value == ''){
                MostrarMensaje('No ha elegido el Administrador de la tarjeta');
                return false;
            }
            
            var tit = document.getElementById('ustitular');
            if (tit.value == ''){
                MostrarMensaje('No ha elegido el Titular de la tarjeta');
                return false;
            }

            var cuenta = document.getElementById('cuenta');
            if (cuenta.value == ''){
                MostrarMensaje('No ha escrito el número de cuenta de la tarjeta');
                return false;
            }
            
            return true;
        }
            
        function GuardarClick(){
            if (ValidaRequeridos()){
                Espera();
                var frm = document.getElementById('nuevaChequera');
                frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarchequera.jsp';
                frm.pasoSig.value = '4'; //GestionarChequeramovControl 4: agrega nueva chequera
                frm.submit();
            }
        }
      </script>      
  </body>
</html>
