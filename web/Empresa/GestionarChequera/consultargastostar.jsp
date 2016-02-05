<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Chequera, Modelo.Entidades.Abono, java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
  HashMap datosS = sesion.getDatos();  
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title></title>
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
        
        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
                }
            });
            $( "#btnConsultar" ).button({
                icons: {
                    primary: "ui-icon-gear"
                }
            });
        });
        </script>
        <!-- Jquery UI -->
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
                    <img src="/siscaim/Imagenes/Empresa/cheque.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        CONSULTAR GASTOS DE TARJETAS
                    </div>
                </td>
            </tr>
        </table>
    <hr>
    <!-- inicia el formulario -->
    <form id="frmConsultarGastos" name="frmConsultarGastos" action="<%=CONTROLLER%>/Consultar/GastosTar" method="post">
        <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
        <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
        <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
        <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
        <input id="idTar" name="idTar" type="hidden" value=""/>            
        <!-- inician los botones -->
        <table width="100%">
            <tr>
                <td width="20%" align="left">
                    <a id="btnSalir" href="javascript: SalirClick()"
                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                        background: indianred 50% bottom repeat-x;" title="Salir de Consultar Gastos de Tarjetas">
                        Salir
                    </a>
                </td>
                <td width="80%" align="right">
                    <a id="btnConsultar" href="javascript: ConsultarClick()"
                        style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Mostrar los gastos registrados">
                        Consultar
                    </a>
                </td>
            </tr>
        </table>
        <hr>
        <!-- Aqui comienza el listado de los movimientos -->
        <table class="tablaLista" width="70%" align="center">
            <%
            List<Chequera> listota = (List<Chequera>)datosS.get("listadoTar");    
            if(listota.size()==0) {             
            %>
            <tr>
                <td colspan="4" align="center">
                    <span class="etiquetaB">
                        No hay tarjetas registradas
                    </span>
                </td>
            </tr>
            <%} else {%>
            <thead>
                <tr>
                    <td align="center" width="5%">
                        <span></span>
                    </td>      
                    <td align="center" width="20%">
                        <span>Sucursal</span>
                    </td>
                    <td align="center" width="25%">
                        <span>Administrador</span>
                    </td>
                    <td align="center" width="25%">
                        <span>Titular</span>
                    </td>
                    <td align="center" width="25%">
                        <span>Cuenta</span>
                    </td>
                </tr>
            </thead>
            <tbody>
                <%
                for (int i=0; i < listota.size(); i++){
                    Chequera tarjeta = listota.get(i);
                %>
                <tr onclick="Activa(<%=i%>)">
                    <td align="center" width="3%">
                        <input id="radioTar" name="radioTar" type="radio" value="<%=tarjeta.getId()%>"/>
                    </td> 
                    <td align="left" width="12%">
                        <span class="etiqueta"><%=tarjeta.getAlmacen().getDatosfis().getRazonsocial()%></span>
                    </td> 
                    <td align="left" width="20%">
                        <span class="etiqueta"><%=tarjeta.getResponsable().getEmpleado().getPersona().getNombreCompleto()%></span>
                    </td>
                    <td align="left" width="17%">
                        <span class="etiqueta"><%=tarjeta.getTitular()%></span>
                    </td>
                    <td align="right" width="10%">
                        <span class="etiqueta"><%=tarjeta.getCuenta()%></span>
                    </td>
                </tr>
                <%}%>
            </tbody>
            <%}%>
        </table>
    </form>
    <!-- Java Script -->
    <script language="javascript">
    function Activa(fila){  
        var idTar = document.getElementById('idTar');
        var btnCons = document.getElementById('btnConsultar');
        btnCons.style.display = '';
        <%
        if (listota.size()==1){
        %>
            document.frmConsultarGastos.radioTar.checked = true;
            idTar.value = document.frmConsultarGastos.radioTar.value;
        <%
        } else {
        %>
            var radio = document.frmConsultarGastos.radioTar[fila];
            radio.checked = true;
            idTar.value = radio.value;
        <% } %>
    }
    
    function ConsultarClick(){
        var frm = document.getElementById('frmConsultarGastos');
        var pagina = document.getElementById('paginaSig');
        var paso = document.getElementById('pasoSig');
        pagina.value = '/Empresa/GestionarChequera/listagastostar.jsp';
        paso.value = '1';
        frm.submit();                
    }
    
    function SalirClick(){
        var frm = document.getElementById('frmConsultarGastos');
        var pagina = document.getElementById('paginaSig');
        var paso = document.getElementById('pasoSig');
        pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
        paso.value = '99';
        frm.submit();                
    }
    </script>
    </body>  
</html>