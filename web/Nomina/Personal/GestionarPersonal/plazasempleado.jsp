
<%-- 
    Document   : nuevoempleado
    Created on : Jun 6, 2012, 10:37:15 PM
    Author     : roman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal, Modelo.Entidades.Plaza"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursal");
    Empleado empl = (Empleado)datosS.get("empleado");
    String titulo = datosS.get("titulo")!=null?datosS.get("titulo").toString():"VIGENTES";
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
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
                
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnImprimir" ).button({
                icons: {
                    primary: "ui-icon-print"
		}
            });
            $( "#btnVencidas" ).button({
                icons: {
                    primary: "ui-icon-arrowreturnthick-1-s"
		}
            });
            $( "#btnVigentes" ).button({
                icons: {
                    primary: "ui-icon-arrowreturnthick-1-n"
		}
            });
        });
        
        </script>
    <!-- Jquery UI -->

        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Plazas/plazasA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="titulo" align="left">
                        PLAZAS <%=titulo%> DEL EMPLEADO
                    </div>
                    <div class="subtitulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompleto()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmPlazasEmp" name="frmPlazasEmp" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <!--<input id="idPlz" name="idPlz" type="hidden" value=""/>-->
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="50%" align="left">
                                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                        background: indianred 50% bottom repeat-x;" title="Cancelar">
                                                        Cancelar
                                                    </a>
                                                    <!--
                                                    <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Cancelar">
                                                            <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                    </table>-->                                                    
                                                </td>
                                                <td width="35%" align="right">
                                                    <a id="btnImprimir" href="javascript: ImprimirClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir">
                                                        Imprimir
                                                    </a>
                                                    <!--
                                                    <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                    </table>-->
                                                </td>
                                                <td width="15%" align="right">
                                                    <a id="btnVencidas" href="javascript: VencidasClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar plazas no vigentes">
                                                        No vigentes
                                                    </a>
                                                    <a id="btnVigentes" href="javascript: VigentesClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Mostrar plazas no vigentes">
                                                        Vigentes
                                                    </a>
                                                    <!--
                                                    <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                    </table>-->
                                                </td>
                                            </tr>
                                        </table><br>
                                        <%
                                        List<Plaza> listado = (List<Plaza>)datosS.get("plazas");
                                        if (listado.size()==0){
                                        %>
                                            <table class="tablaLista" width="90%" align="center">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            EL EMPLEADO NO TIENE PLAZAS <%=titulo%>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        <%
                                        } else {
                                        %>
                                            <table class="tablaLista" width="100%" align="center">
                                                <thead>
                                                    <tr>
                                                        <td align="center" width="10%">
                                                            <span>Sucursal</span>
                                                        </td>
                                                        <td align="center" width="15%">
                                                            <span>Contrato</span>
                                                        </td>
                                                        <td align="center" width="15%">
                                                            <span>C.T.</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Puesto</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Alta</span>
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
                                                    String falta = pl.getFechaalta().toString();
                                                    String faltanorm = falta.substring(8,10) + "-" + falta.substring(5,7) + "-" + falta.substring(0, 4);
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
                                                        <%--
                                                        <td align="center" width="5%">
                                                            <input id="radioPlz" name="radioPlz" type="radio" value="<%=pl.getId()%>"/>
                                                        </td>--%>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=pl.getSucursal().getDatosfis().getRazonsocial()%></span>
                                                        </td>
                                                        <td align="center" width="15%">
                                                            <span class="etiqueta"><%=pl.getContrato().getContrato()%> - <%=pl.getContrato().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="15%">
                                                            <span class="etiqueta"><%=pl.getCtrabajo().getNombre()%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=pl.getPuesto().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=faltanorm%></span>
                                                        </td>
                                                        <td align="right" width="10%">
                                                            <span class="etiqueta"><%=pl.getSueldo()%></span>
                                                        </td>
                                                        <td align="right" width="10%">
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
                if (listado.size()==0){
                %>
                    var btnImpr = document.getElementById('btnImprimir');
                    btnImpr.style.display = 'none';
                <%}%>
                var btnVen = document.getElementById('btnVencidas');
                var btnVig = document.getElementById('btnVigentes');
                <%if (titulo.equals("VIGENTES")){
                %>
                    btnVen.style.display = '';
                    btnVig.style.display = 'none';
                <%} else {%>
                    btnVen.style.display = 'none';
                    btnVig.style.display = '';
                <%}%>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmPlazasEmp');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                paso.value = '94';
                frm.submit();                
            }
            
            function ImprimirClick(){
                window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=19',
                        '','width =800, height=600, left=0, top = 0, resizable= yes');                
            }
            
            function VencidasClick(){
                var frm = document.getElementById('frmPlazasEmp');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/plazasempleado.jsp';
                paso.value = '30';
                frm.submit();                
            }
            
            function VigentesClick(){
                var frm = document.getElementById('frmPlazasEmp');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Personal/GestionarPersonal/plazasempleado.jsp';
                paso.value = '31';
                frm.submit();                
            }
                <%--
            function Activa(fila){
                var idPlz = document.getElementById('idPlz');
                var btnmovext = document.getElementById('btnMovsExtras');
                btnmovext.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmPlazasEmp.radioPlz.checked = true;
                    idPlz.value = document.frmPlazasEmp.radioPlz.value;
                <%
                } else {
                %>
                    var radio = document.frmPlazasEmp.radioPlz[fila];
                    radio.checked = true;
                    idPlz.value = radio.value;
                <% } %>
            }
                --%>
        </script>
    </body>
</html>