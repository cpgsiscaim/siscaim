<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Plaza"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
List<Plaza> listado = (List<Plaza>)datosS.get("plazasinactivas");
List<Plaza> activas = (List<Plaza>)datosS.get("plazas");
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
Cliente clisel = (Cliente)datosS.get("clienteSel");
Contrato consel = (Contrato)datosS.get("editarContrato");
CentroDeTrabajo ctsel = (CentroDeTrabajo)datosS.get("centro");
float acumsueldos = ((Float)datosS.get("acumsueldos")).floatValue();
//}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
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
        </script>
    <!-- Jquery UI -->
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Plazas/plazasD.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PLAZAS INACTIVAS
                    </div>
                    <div align="left">
                        <table width="100%">
                            <tr>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">SUCURSAL:</span>&nbsp;
                                    <span class="subtitulo"><%=sucSel.getDatosfis().getRazonsocial()%></span>                                    
                                </td>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">CLIENTE:</span>&nbsp;
                                    <span class="subtitulo"><%=clisel.getTipo()==0?clisel.getDatosFiscales().getRazonsocial():clisel.getDatosFiscales().getPersona().getNombreCompleto()%></span>
                                </td>
                            </tr>
                            <tr>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">CONTRATO:</span>&nbsp;
                                    <span class="subtitulo"><%=consel.getContrato()%> - <%=consel.getDescripcion()%></span>
                                </td>
                                <td width="50%" align="left">
                                    <span class="etiquetaB">C.T.:</span>&nbsp;
                                    <span class="subtitulo"><%=ctsel.getNombre()%></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarPlz" name="frmGestionarPlz" action="<%=CONTROLLER%>/Gestionar/Plazas" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idPlz" name="idPlz" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <style>#btnCancelar a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="50%" align="right">
                                                <style>#btnActivar a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnActivar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Activar">
                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table><!--fin tabla salir sucursal cliente contrato ct -->
                                    <hr>
                                    <!--listado-->                                    
                                    <%
                                        if (listado.size()==0){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Plazas Inactivas
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        <%
                                        } else {
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <thead>
                                                    <tr>
                                                        <td align="center" width="40%" colspan="3">
                                                            <span>Empleado</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Puesto</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Baja</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Sueldo</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Compens.</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Forma de Pago</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Período de Pago</span>
                                                        </td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <%
                                                for (int i=0; i < listado.size(); i++){
                                                    Plaza pl = listado.get(i);
                                                    String fbaja = pl.getFechabaja().toString();
                                                    String fbajanorm = fbaja.substring(8,10) + "-" + fbaja.substring(5,7) + "-" + fbaja.substring(0, 4);
                                                    String formapago = "";
                                                    switch (pl.getFormapago()){
                                                        case 1:
                                                            formapago = "DEPOSITO";
                                                            break;
                                                        case 2:
                                                            formapago = "EFECTIVO";
                                                            break;
                                                        case 3:
                                                            formapago = "TELECOMM";
                                                            break;
                                                    }
                                                %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="5%">
                                                            <input id="radioPlz" name="radioPlz" type="radio" value="<%=pl.getId()%>"/>
                                                        </td>
                                                        <td align="center" width="5%">
                                                            <span class="etiqueta"><%=pl.getEmpleado().getClave()%></span>
                                                        </td>
                                                        <td align="left" width="30%">
                                                            <span class="etiqueta"><%=pl.getEmpleado().getPersona().getNombreCompletoPorApellidos()%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=pl.getPuesto().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="14%">
                                                            <span class="etiqueta"><%=fbajanorm%></span>
                                                        </td>
                                                        <td align="right" width="8%">
                                                            <span class="etiqueta"><%=pl.getSueldo()%></span>
                                                        </td>
                                                        <td align="right" width="8%">
                                                            <span class="etiqueta"><%=pl.getCompensacion()%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=formapago%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=pl.getPeriodopago().getDescripcion()%></span>
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
            </div>
            <div id="procesando" style="display: none">
            <table id="tbmensaje" align="center" width="100%">
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
            
            function Activa(fila){
                var idPlz = document.getElementById('idPlz');
                var activar = document.getElementById('btnActivar');
                activar.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarPlz.radioPlz.checked = true;
                    idPlz.value = document.frmGestionarPlz.radioPlz.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarPlz.radioPlz[fila];
                    radio.checked = true;
                    idPlz.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarPlz');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                paso.value = '97';
                frm.submit();                
            }
            
            function ValidaTopeSueldos(){
                //obtener el sueldo de la plaza a activar
                var idplz = document.getElementById('idPlz');
                var sueldoplz = 0;
                <%for (int i=0; i < listado.size(); i++){
                    Plaza p = listado.get(i);%>
                    if (idplz.value == '<%=p.getId()%>'){
                        sueldoplz = parseFloat('<%=p.getSueldo()%>');
                    }
                <%}%>
                var acumnvo = parseFloat('<%=acumsueldos%>');
                acumnvo += sueldoplz;

                if (acumnvo > parseFloat('<%=ctsel.getTopeSueldos()%>')){
                    var dif = formato_numero(acumnvo - parseFloat('<%=ctsel.getTopeSueldos()%>'),2,'.',',');
                    MostrarMensaje('La plaza no se puede activar porque se excede el tope de sueldos del CT por '+dif+' pesos');
                    return false;
                }
                
                return true;
            }
            
            function ValidaTopePersonal(){
            <%if (ctsel.getPersonal()>activas.size()){%>
                 if (ValidaTopeSueldos()){
                     return true;
                 } else {
                     return false;
                 }
            <%} else {%>
                MostrarMensaje('No se pueden agregar más plazas al CT seleccionado');
                return false;
            <%}%>
            }
            
            function ActivarClick(){
                if (ValidaTopePersonal()){
                    Espera();
                    var frm = document.getElementById('frmGestionarPlz');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Nomina/Plazas/plazasinactivas.jsp';
                    paso.value = '8';
                    frm.submit();
                }
            }
        </script>
    </body>
</html>
