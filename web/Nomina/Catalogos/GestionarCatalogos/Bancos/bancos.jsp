<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Catalogos.Banco"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Banco> listado = (List<Banco>)datosS.get("bancos");
int paso = Integer.parseInt(datosS.get("paso").toString());
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
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
        <br>
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/bancos.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR BANCOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarBan" name="frmGestionarBan" action="<%=CONTROLLER%>/Gestionar/Bancos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idBan" name="idBan" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <div id="acciones">
                                    <table width="100%">
                                        <tr>
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
                                            <td width="15%" align="left">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="25%" align="right">&nbsp;</td>
                                            <td width="15%" align="right">
                                                <style>#btnBaja a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnBaja" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Baja">
                                                            <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnEditar a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnEditar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Editar">
                                                            <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    </div>
                                    <!--nuevo banco-->
                                    <%if (paso==1 || paso==2){
                                        String titulo = "NUEVO BANCO", nombanco = ""; 
                                        if (paso==2){
                                            titulo = "EDITAR BANCO";
                                            Banco ban = (Banco)datosS.get("banco");
                                            nombanco = ban.getNombre();
                                        }
                                    %>
                                    <div id="nuevo">
                                    <table width="60%" align="center">
                                        <tr>
                                            <td colspan="3" width="100%" align="left">
                                                <span class="subtitulo"><%=titulo%></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="60%" align="left">
                                                <input id="nombre" name="nombre" type="text" maxlength="40" style="width: 400px" value="<%=nombanco%>"
                                                       onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"/>
                                            </td>
                                            <td width="20%" align="right">
                                                <style>#btnGuardar a{display:block;color:transparent;} #btnGuardar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Guardar">
                                                            <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="20%" align="right">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    </div>
                                    <%}%>
                                    <!--nuevo banco-->
                                    <!--listado-->
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <table class="tablaLista" width="40%" align="center">
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No hay Bancos registrados
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    <%
                                    } else {
                                    %>
                                        <table class="tablaLista" width="40%" align="center">
                                            <thead>
                                                <tr>
                                                    <td align="center" width="100%" colspan="2">
                                                        <span>Banco</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                            for (int i=0; i < listado.size(); i++){
                                                Banco ban = listado.get(i);
                                            %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioBan" name="radioBan" type="radio" value="<%=ban.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="95%">
                                                        <span class="etiqueta"><%=ban.getNombre()%></span>
                                                    </td>
                                                </tr>
                                            <%
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                    <%  
                                    }//if listado=0
                                    %>
                                    <!--fin listado-->
                                </td><!--fin del contenido-->
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
        <script language="javascript">
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
                if (paso==1 || paso==2){
                %>
                     var acciones = document.getElementById('acciones');
                     acciones.style.display = 'none';
                     var nombre = document.getElementById('nombre');
                     nombre.focus();
                <%}%>
            }
            
            function Activa(fila){
                var idBan = document.getElementById('idBan');
                var baja = document.getElementById('btnBaja');
                baja.style.display = '';
                var editar = document.getElementById('btnEditar');
                editar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarBan.radioBan.checked = true;
                    idBan.value = document.frmGestionarBan.radioBan.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarBan.radioBan[fila];
                    radio.checked = true;
                    idBan.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancos.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarClick(){
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancos.jsp';
                paso.value = '2';
                frm.submit();               
            }
            
            function BajaClick(){
                var resp = confirm('¿Está seguro en dar de baja el Banco seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarBan');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancos.jsp';
                    paso.value = '4';
                    frm.submit();
                }
            }
            
            function VerInactivos(){
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancosinactivos.jsp';
                paso.value = '5';
                frm.submit();                
            }
                        
            function CancelarClick(){
                var nombre = document.getElementById('nombre');
                nombre.value = '';
                var nuevo = document.getElementById('nuevo');
                nuevo.style.display = 'none';
                var acciones = document.getElementById('acciones');
                acciones.style.display = '';
            }
            
            function GuardarClick(){
                var nombre = document.getElementById('nombre');
                if (nombre.value == ''){
                    Mensaje('Debe escribir el nombre del banco');
                    nombre.focus();
                    return;
                }
                
                var frm = document.getElementById('frmGestionarBan');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Catalogos/GestionarCatalogos/Bancos/bancos.jsp';
                paso.value = '3';
                frm.submit();                    
            }
        </script>
    </body>
</html>
