<%-- 
    Document   : contactosct
    Created on : Oct 26, 2013, 10:28:37 AM
    Author     : germha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Sucursal, Modelo.Entidades.Empresa, Modelo.Entidades.CentroDeTrabajo, java.util.List, java.util.ArrayList, Modelo.Entidades.Contactos "%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();    
    List<Contactos> listado = (List<Contactos>)datosS.get("listaContactos");
    CentroDeTrabajo cli = (CentroDeTrabajo)datosS.get("clienteSel");
    int t_c = Integer.parseInt(datosS.get("tipoContact").toString());
    System.out.println("Tamanio de la lista al inicio: "+listado.size());
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/titulos.css" rel="stylesheet" />
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>
        <!-- Archivos para los cuadros modales -->
            <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/normalize.css">
            <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/main.css">
            <script src="http://code.jquery.com/jquery-1.10.0.min.js"></script>
            <script type='text/javascript' src='/siscaim/Utilerias/jquery.modal.js'></script>
            <script type='text/javascript' src='/siscaim/Utilerias/site.js'></script>
        <title></title>
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
        <table width="100%">
            <tr>
                <td><img src="/siscaim/Imagenes/Empresa/agenda.png" width="100"></td>
                <td width="100%" style="padding-left: 30px;">                    
                        <div class="titulo" align="center">
                            AGENDA DE CONTACTOS POR CENTRO DE TRABAJO
                        </div>
                    <br>
                        <div class="subtitulo" align="center">                            
                            CENTRO DE TRABAJO: <%=cli.getNombre() %><br>                                  
                            <br>
                            CONTRATO: <%=cli.getContrato().getContrato() %>                                                                                                                            
                            
                        </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmContacxClientes" name="frmContacxClientes" action="<%=CONTROLLER%>/Gestionar/CentrosTrab" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCli" name="idCli" type="hidden" value="<%=cli.getId()%>"/>
            <input id="tipoCont" name="tipoCont" type="hidden" value="<%=t_c%>"/> 
            <input id="idContacto" name="idContacto" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <!-- Boton de Salir -->
                                            <td width="15%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <!-- Boton de Agregar-->
                                            <td width="15%" align="left">
                                                <style>#btnAgregar a{display:block;color:transparent;} #btnAgregar a:hover{background-position:left bottom;}a#btnAgregara {display:none}</style>
                                                <table id="btnAgregar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: AgregarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/agregar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <!-- Botones que se activan al seleccionar el contacto -->
                                            <td width="20%" align="right">    <!-- tabla de eliminar movimiento -->
                                                <table id="editar" width="100%" style="display: none">
                                                  <tr>
                                                    <td width="15%" align="right">
                                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                            <tr>
                                                                <td style="padding-right:0px" title ="Eliminar">
                                                                    <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                </td>
                                                            </tr>
                                                        </table>                                                    
                                                    </td>
                                                  </tr>
                                                </table>
                                            </td>
                                            <td width="20%" align="right">    <!-- tabla de eliminar movimiento -->
                                                <table id="eliminar" width="100%" style="display: none">
                                                  <tr>
                                                    <td width="15%" align="right">
                                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                            <tr>
                                                                <td style="padding-right:0px" title ="Eliminar">
                                                                    <a href="javascript: EliminarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/borrar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                </td>
                                                            </tr>
                                                        </table>                                                    
                                                    </td>
                                                  </tr>
                                                </table>
                                            </td>
                                            <!-- Boton de Editar -->
                                            
                                            <!-- Boton de Detalles -->
                                            
                                            <!-- Boton de Eliminar -->
                                            
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <!-- Comenzamos el listado de los contactos -->
                        <div id="listado">
                        <table class="tablaLista" width="92%" align="center" style="background-color: rgba(244, 255, 247, 0.7);">
                            <%
                                if(listado.size()==0)   {    //Declaracion de metodos y clases para el listado de contactos
                            %>
                            <tr>
                                <td colspan="4" align="center">
                                    <span class="etiquetaB">
                                        No hay contactos registrados en este centro de trabajo
                                    </span>
                                </td>
                            </tr>
                            <%
                              } else {
                            %>
                            <thead>
                                <tr>
                                    <td align="center" width="5%">
                                        <span></span>
                                    </td>    
                                    <td align="center" width="10%">
                                        <span>Nombre</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Mail</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Celular</span>
                                    </td>
                                    <td align="center" width="10%">
                                        <span>Notas</span>
                                    </td>
                                    <td align="center" width="2%">
                                        <span>Detalles</span>
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                            <% 
                                for (int i=0; i < listado.size(); i++)  {  
                                    Contactos cont = listado.get(i);                                
                            %>
                            <tr onclick="Activa(<%=i%>)">
                                <td align="center" width="3%">
                                    <input id="radioMovi" name="radioMovi" type="radio" value="<%=cont.getId() %>"/>
                                </td>
                                <td align="center" width="10%">
                                    <span class="etiqueta"><%=cont.getNombres()+" "+cont.getAp_paterno() %></span>
                                </td>
                                <td align="center" width="15%">
                                    <span class="etiqueta"><%=cont.getEmail()%></span>
                                </td>
                                <td align="center" width="15%">
                                    <span class="etiqueta"><%=cont.getCelular() %></span>
                                </td>
                                <td align="center" width="10%">
                                    <span class="etiqueta"><%=cont.getNotas() %></span>
                                </td>
                                <td align="center" width="5%">                                        
                                          <a class="modalLink" href="#modal<%=i%>">
                                            <img src="/siscaim/Imagenes/Empresa/detalles.png" width="26">
                                          </a>
                                        <div class="overlay"></div>
                                        <div id="modal<%=i%>" class="modal">
                                          <p class="closeBtn"><b>Cerrar</b></p>
                                          <table>
                                            <tr>
                                              <td> <!-- detalles de nuestro movimiento-->
                                                <table class="t_presentacion" width="500">
                                                  <tr>
                                                    <td colspan="2" style="text-align: center; font-size: 13px;"><b>DETALLES DEL CONTACTO</b></td>
                                                  </tr>
                                                  <tr>
                                                      <td><b>NOMBRE:</b></td>
                                                    <td><%=cont.getNombres()+" "+cont.getAp_paterno()+" "+cont.getAp_materno()%></td>
                                                  </tr>
                                                  <tr>
                                                      <td><b>CELULAR</b></td>
                                                    <td><%=cont.getCelular()%></td>
                                                  </tr>
                                                  <tr>
                                                      <td><b>E-MAIL</b></td>
                                                    <td><%=cont.getEmail()%></td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="2" style="text-align: center;"><B>DIRECCION</B></td>                                                                                                     
                                                  </tr>                                                    
                                                  <tr>
                                                      <td><b>CALLE Y NUMERO:</b></td>
                                                    <td><%=cont.getDireccion()%></td>
                                                  </tr>
                                                  <tr>
                                                      <td><b>COLONIA:</b></td>
                                                    <td><%=cont.getColonia()%></td>
                                                  </tr>
                                                  <tr>
                                                      <td><b>POBLACION:</b></td>
                                                    <td><%=cont.getPoblacion()%></td>
                                                  </tr>
                                                  <tr>
                                                      <td><b>ESTADO:</b></td>
                                                    <td><%=cont.getEstado()%></td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="2" style="text-align: center;"><B>NOTAS</B></td>                                                                                                     
                                                  </tr> 
                                                  <tr>
                                                    <td colspan="2" style="text-align: left;"><%=cont.getNotas()%></td>                                                                                                     
                                                  </tr> 
                                                  <tr>
                                                    <td colspan="2" style="text-align: center;"><B>NUMEROS ALTERNOS</B></td>                                                                                                     
                                                  </tr> 
                                                  <% if (cont.getTel1()!=null)  {  %>
                                                  <tr>
                                                      <td><b>NUMERO 1:</b></td>
                                                      <td><%=cont.getTel1()%></td>
                                                  </tr>
                                                  <% } %>
                                                  <% if (cont.getTel2()!=null)  {  %>
                                                  <tr>
                                                      <td><b>NUMERO 2:</b></td>
                                                      <td><%=cont.getTel2()%></td>
                                                  </tr>
                                                  <% } %>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </div>                                        
                                    </td>                                                                                                
                            </tr>
                            <% }    %>
                            </tbody>
                            <% }    %>
                        </table>
                        </div>
                    </td>
                </tr>                
            </table>
        </form>
        <script language="javascript">
            function EditarClick()  {
                var frm = document.getElementById('frmContacxClientes');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/editarContacto.jsp';
                paso.value = '14';
                frm.submit();
            }
            
            function EliminarClick()    {
                var resp = confirm('¿Está seguro de eliminar el Movimiento seleccionado?','SISCAIM');
                if(resp)    {
                    var frm = document.getElementById('frmContacxClientes');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/contactosct.jsp';
                    paso.value = '13';
                    frm.submit();
                }
            }
            function Activa(fila){  
                var idContacto = document.getElementById('idContacto');
                var editar = document.getElementById('editar');
                var eliminar  = document.getElementById('eliminar');      
                editar.style.display = '';
                eliminar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmContacxClientes.radioMovi.checked = true;
                    idContacto.value = document.frmContacxClientes.radioMovi.value;
                <%
                } else {
                %>
                    var radio = document.frmContacxClientes.radioMovi[fila];
                    radio.checked = true;
                    idContacto.value = radio.value;     
                <% } %>
            }     
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
                var razonCli = document.getElementById('razonCli');
                razonCli.focus();
            }

            function SalirClick(){
                var frm = document.getElementById('frmContacxClientes');
                frm.paginaSig.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }                 
            function AgregarClick(){
                var frm = document.getElementById('frmContacxClientes');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/Contratos/CentrosTrab/nuevocontCT.jsp';
                paso.value = '11';
                frm.submit();             
            }

        </script>
    </body>
</html>