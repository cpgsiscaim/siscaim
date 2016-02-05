<%-- 
    Document   : tiponomina
    Created on : Jun 20, 2012, 9:45:51 AM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.ArrayList, java.util.List,  Modelo.Entidades.Catalogos.TipoNomina, Modelo.Entidades.Empleado"%>
<%-- aqui poner los imports
<%@page import=""%>
--%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
//Estado edoActual = null;
HashMap datosS = sesion.getDatos();
List<TipoNomina> TipoNominaLst = new ArrayList<TipoNomina>();//(List<Cliente>)datosS.get("listado");
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
                        Tipos de Nomina
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmTipoNomina" name="frmTipoNomina" action="<%=CONTROLLER%>/Gestionar/Catalogos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idTipoNomina" name="idTipoNomina" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Personal/configuracion.jpg" align="center" width="300" height="250">
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
                                                <%-- Boton Nuevo --%>
                                                <td width="15%" align="right">
                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nueva Persona" >
                                                            <a href="javascript: NuevaTnominaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>                                     
                                                </table>
                                            </td>                                                                        
                                        </tr>
                                        </table> 
                                        
                                                <%-- Botones editar eliminar --%> 
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                    <td width="70%" align="right">&nbsp;</td>
                                    
                                                    <td width="15%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Editar Persona">
                                                                <a href="javascript: EditarTnominaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    </td>
                                    
                                                    <td width="15%" align="right">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Baja">
                                                                <a href="javascript: BajaTnominaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                    </td>
                                                   </tr>        
                                                </table>
                                        <hr>                                
                                
                                        <table class="tablaLista" width="100%">
                                            <thead>
                                                <tr>
                                                    <td width="10%" align="center">
                                                        <span>Id</span>
                                                    </td>
                                                    <td width="45%" align="center">
                                                        <span>Descripción</span>
                                                    </td>                                                                                      
                                                </tr>
                                            </thead>
                                    
                                            <%                                                
                                                TipoNominaLst = (List<TipoNomina>) datosS.get("listatiponom");
                                            %>
                                            <tbody> 
                                                <%
                                                    int nper = TipoNominaLst.size();
                                                    for (int i = 0; i < nper; i++) {
                                                        TipoNomina p = (TipoNomina) TipoNominaLst.get(i);
                                                %>
                                                
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioTipoNomina" name="radioTipoNomina" type="radio" value="<%= p.getIdTnomina() %>" />
                                                    </td>
                                                    <td width="90%" align="center">                                                        
                                                        <span class="etiqueta"><%= p.getDescripcion() %></span>
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

        function NuevaTnominaClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/TiposNomina/nuevotnomina.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "13";
            var frm = document.getElementById('frmTipoNomina');
            frm.submit();
        }
        function EditarTnominaClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/TiposNomina/nuevotnomina.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "16";
            var frm = document.getElementById('frmTipoNomina');
            frm.submit();
        }
        function BajaTnominaClick(){
            var resp = confirm('¿Está seguro en dar de baja el Tipo de Nomina seleccionado?','SISCAIM');
            if (resp){
                var frm = document.getElementById('frmTipoNomina');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = "/Nomina/Catalogos/GestionarCatalogos/TiposNomina/tiponomina.jsp";
                paso.value = '17';
                frm.submit();
            }
        }

        function SalirClick(){
            var frm = document.getElementById('frmTipoNomina');
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
                            var idTipoNomina = document.getElementById('idTipoNomina');
                            var borrarEdit = document.getElementById('borrarEdit');
                            borrarEdit.style.display = '';
                    <%
                        if (TipoNominaLst.size() == 1) {
                    %>
                            //document.frmGestionarCli.radioCli.checked = true;
                            document.frmTipoNomina.radioTipoNomina.checked = true;
                            //idCli.value = document.frmGestionarCli.radioCli.value;
                            idTipoNomina.value = document.frmTipoNomina.radioTipoNomina.value;
                    <%    }else {
                    %>
                            var radio = document.frmTipoNomina.radioTipoNomina[fila];//document.frmGestionarCli.radioCli[fila];
                            radio.checked = true;
                            idTipoNomina.value = radio.value;
                    <% }%>
        }
        
</script>
</body>
</html>

