<%-- 
    Document   : tipoincidencia
    Created on : Jun 19, 2012, 2:24:51 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.ArrayList, java.util.List,  Modelo.Entidades.Catalogos.TipoIncidencia, Modelo.Entidades.Empleado"%>
<%-- aqui poner los imports
<%@page import=""%>
--%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
//Estado edoActual = null;
HashMap datosS = sesion.getDatos();
List<TipoIncidencia> TipoIncidenciaLst = new ArrayList<TipoIncidencia>();//(List<Cliente>)datosS.get("listado");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />        
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"/>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

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
                <td width="100%">
                    <div class="titulo" align="center">
                        Tipos de Incidencia 
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmTipoIncidencia" name="frmTipoIncidencia" action="<%=CONTROLLER%>/Gestionar/Catalogos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idTipoIncidencia" name="idTipoIncidencia" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Nomina/Catalogos/incidenciasA.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <!--aquí poner contenido-->
                                        <table width="100%">
                                            <tr>
                                                <%-- Boton Salir --%>
                                                <td width="55%" align="left">
                                                    <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                    </table>                                                    
                                                </td>
                                                <%-- Boton Inactivos 
                                                <td width="15%" align="center">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                <tr>
                                                    <td style="padding-right:0px" title ="Ver Inactivos">
                                                        <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                    </td>
                                                </tr>
                                                </table>                                                    
                                                </td>
                                                --%>
                                                <td width="15%" align="right">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="50%" align="right">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Baja">
                                                                            <a href="javascript: BajaTincidenciaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                            <td width="50%" align="left">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Editar Persona">
                                                                            <a href="javascript: EditarTincidenciaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>        
                                                    </table>
                                                </td>
                                                <%-- Boton Nuevo --%>
                                                <td width="15%" align="right">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Nueva Persona" >
                                                                <a href="javascript: NuevaTincidenciaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>                                     
                                                    </table>
                                                </td>                                                                        
                                            </tr>
                                        </table> 
                                        
                                                <%-- Botones editar eliminar --%> 
                                        <hr>                                
                                
                                        <table class="tablaLista" width="100%">
                                            <thead>
                                                <tr>
                                                   <td width="10%" align="center">
                                                        <span>Id</span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span>Descripción</span>
                                                    </td>                                    
                                                    <td width="30%" align="center">
                                                        <span>Calcula</span>
                                                    </td>                                    
                                                    <td width="30%" align="center">
                                                        <span>idPery</span>
                                                    </td>                                    
                                                </tr>
                                            </thead>
                                    
                                            <%                                                
                                                TipoIncidenciaLst = (List<TipoIncidencia>) datosS.get("listatipoinc");
                                            %>
                                            <tbody> 
                                                <%
                                                    int nper = TipoIncidenciaLst.size();
                                                    for (int i = 0; i < nper; i++) {
                                                        TipoIncidencia p = (TipoIncidencia) TipoIncidenciaLst.get(i);
                                                %>
                                                
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioTipoIncidencia" name="radioTipoIncidencia" type="radio" value="<%= p.getIdTipoincidencia() %>" />
                                                    </td>                                                                                                         
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%= p.getDescripcion() %></span>                                                        
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%= p.getCalcula() %></span>                                                        
                                                    </td>                                                                                                                                          
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%= p.getIdPery() %></span>                                                        
                                                    </td>                                                                                                                                          
                                                </tr>
                                                <%
                                                    } //Fin for
                                                %> 
                                            </tbody>
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
        }

        function NuevaTincidenciaClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/nuevotincidencia.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "25";
            var frm = document.getElementById('frmTipoIncidencia');
            frm.submit();
        }
        function EditarTincidenciaClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/nuevotincidencia.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "28";
            var frm = document.getElementById('frmTipoIncidencia');
            frm.submit();
        }
        function BajaTincidenciaClick(){
            var resp = confirm('¿Está seguro en dar de baja la operacion seleccionada?','SISCAIM');
            if (resp){
                var frm = document.getElementById('frmTipoIncidencia');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = "/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/tipoincidencia.jsp";
                paso.value = '29';
                frm.submit();
            }
        }

        function SalirClick(){
            var frm = document.getElementById('frmTipoIncidencia');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
            paso.value = '99';
            frm.submit();                
        }

        function VerInactivos(){
            var frm = document.getElementById('frmGesPersonal');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Personal/GestionarPersonal/empleadosinactivos.jsp';
            paso.value = '7';
            frm.submit();                
        }

        function Activa(fila){
                            var idTipoIncidencia = document.getElementById('idTipoIncidencia');
                            var borrarEdit = document.getElementById('borrarEdit');
                            borrarEdit.style.display = '';
                    <%
                        if (TipoIncidenciaLst.size() == 1) {
                    %>
                            //document.frmGestionarCli.radioCli.checked = true;
                            document.frmTipoIncidencia.radioTipoIncidencia.checked = true;
                            //idCli.value = document.frmGestionarCli.radioCli.value;
                            idTipoIncidencia.value = document.frmTipoIncidencia.radioTipoIncidencia.value;
                    <%    }else {
                    %>
                            var radio = document.frmTipoIncidencia.radioTipoIncidencia[fila];//document.frmGestionarCli.radioCli[fila];
                            radio.checked = true;
                            idTipoIncidencia.value = radio.value;
                    <% }%>
        }
        
</script>
</body>
</html>

