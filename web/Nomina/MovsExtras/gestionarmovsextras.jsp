<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Plaza, Modelo.Entidades.MovimientoExtraordinario, Modelo.Entidades.Catalogos.Quincena"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<MovimientoExtraordinario> listado = (List<MovimientoExtraordinario>)datosS.get("movsextras");
List<MovimientoExtraordinario> fijos = (List<MovimientoExtraordinario>)datosS.get("movsextrasfijos");
fijos.addAll(listado);
Plaza plzsel = (Plaza)datosS.get("plaza");
Quincena qact = (Quincena)datosS.get("quincenasel");
String anioact = datosS.get("aniosel").toString();
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
        
        //DIALOGO CONFIRMACION
        $(function() {
            $( "#dialog-confirm" ).dialog({
            resizable: false,
            width:500,
            height:200,
            modal: true,
            autoOpen: false,
            buttons: {
                "Aceptar": function() {
                $( this ).dialog( "close" );
                EjecutarProceso();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
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
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
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
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
        </div>
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/MovsExtras/movextraA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS EXTRAORDINARIOS
                    </div>
                    <div class="subtitulo" align="left">
                        <%=plzsel.getEmpleado().getPersona().getNombreCompleto()%><br>
                        <%=plzsel.getPuesto().getDescripcion()%> / <%=plzsel.getCtrabajo().getNombre()%>
                    </div>
                </td>
            </tr>
            
        </table>
        <hr>
        <form id="frmGestionarMovExt" name="frmGestionarMovExt" action="<%=CONTROLLER%>/Gestionar/MovExtra" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idMext" name="idMext" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="40%" align="left">
                                                <a id="btnSalir" href="javascript: CancelarClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Cancelar">
                                                    Cancelar
                                                </a>
                                            </td>
                                            <td width="25%" align="right">
                                                <span class="etiquetaB">Año:</span>
                                                <input id="anio" name="anio" type="text" class="text" style="width: 50px; text-align: center;" value="<%=anioact%>"
                                                       onkeypress="return ValidaNums(event)" maxlength="4" onblur="CargaMovsExtras()"/>
                                            </td>
                                            <td width="35%" align="right">
                                                <span class="etiquetaB">Quincena:</span>
                                                <select id="quincena" name="quincena" class="combo" style="width: 250px"
                                                        onchange="CargaMovsExtras()">
                                                    <option value="">Elija la Quincena...</option>
                                                <%
                                                    List<Quincena> quincenas = (List<Quincena>)datosS.get("quincenas");
                                                    for (int i=0; i < quincenas.size(); i++){
                                                        Quincena quin = quincenas.get(i);
                                                    %>
                                                        <option value="<%=quin.getId()%>"<%if (qact.getId()==quin.getId()){%>selected<%}%>>
                                                            <%=quin.getMes()%> - <%=quin.getNumero()%>
                                                        </option>
                                                    <%
                                                    }
                                                %>
                                                </select>
                                            </td>
                                        </tr>
                                    </table><!--fin tabla salir sucursal cliente contrato ct -->
                                    <%if (paso>0){%>
                                    <hr>
                                    <%}%>
                                    <!--botones de acciones -->
                                    <table id="acciones" align="center" width="100%" style="display: none">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar movs. extraordinarios dadas de baja">
                                                    Ver Inactivos
                                                </a>
                                            </td>
                                            <td width="40%" align="center">&nbsp;</td>
                                            <td width="30%" align="center">
                                                <table id="editar" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja del mov. extraordinario seleccionado">
                                                                Baja
                                                            </a>
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar el mov. extraordinario seleccionado">
                                                                Editar
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevoClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Nuevo mov. extraordinario">
                                                    Nuevo
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <!--fin botones de acciones -->
                                    <hr>
                                    <!--listado-->
                                    
                                    <%
                                    if (paso>0){
                                        if (fijos.isEmpty()){
                                        %>
                                            <table class="tablaLista" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <span class="etiquetaB">
                                                            No hay Movimientos Extraordinarios registrados
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                        <%
                                        } else {
                                        %>
                                            <table class="tablaLista" width="100%" id="listado">
                                                <thead>
                                                    <tr>
                                                        <td align="center" width="20%" colspan="2">
                                                            <span>Movimiento</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Tipo de Cambio</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Tipo de Nómina</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Año</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Cantidad</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Quincenas</span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span>Total</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Cotiza</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Permanente</span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span>Prestaci&oacute;n IMSS</span>
                                                        </td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <%
                                                for (int i=0; i < fijos.size(); i++){
                                                    MovimientoExtraordinario mextra = fijos.get(i);
                                                %>
                                                    <tr onclick="Activa(<%=i%>, <%=mextra.getPerded().getIdPeryded()%>)">
                                                        <td align="center" width="3%">
                                                            <%if (mextra.getPerded().getIdPeryded()!=6 && mextra.getPerded().getIdPeryded()!=7){%>
                                                            <input id="radioMext" name="radioMext" type="radio" value="<%=mextra.getId()%>"/>
                                                            <% } else { %>
                                                                <input id="radioMext" name="radioMext" type="radio" value="<%=mextra.getId()%>" disabled/>
                                                            <%}%>
                                                        </td>
                                                        <td align="left" width="18%">
                                                            <span class="etiqueta">
                                                                <%=mextra.getPerded().getDescripcion()%> 
                                                                (<%if (mextra.getPerded().getPeroDed()==1){%>+<%}else{%>-<%}%>)
                                                            </span>
                                                        </td>
                                                        <td align="left" width="10%">
                                                            <span class="etiqueta"><%=mextra.getTipocambio().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%=mextra.getTiponomina().getDescripcion()%></span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span class="etiqueta"><%=mextra.getAnio()%></span>
                                                        </td>
                                                        <td align="right" width="8%">
                                                            <span class="etiqueta"><%=mextra.getImporte()%></span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span class="etiqueta"><%=mextra.getNumero()%></span>
                                                        </td>
                                                        <td align="right" width="8%">
                                                            <span class="etiqueta"><%=mextra.getTotal()%></span>
                                                        </td>
                                                        <td align="center" width="8%">
                                                            <span class="etiqueta"><%if(mextra.getCotiza()==1){%>SÍ<%} else {%>NO<%}%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%if(mextra.getFijo()==1){%>SÍ<%} else {%>NO<%}%></span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiqueta"><%if(mextra.getPrestacionimss()==1){%>SÍ<%} else {%>NO<%}%></span>
                                                        </td>
                                                    </tr>
                                                <%
                                                }
                                                %>
                                                </tbody>
                                            </table>
                                        <%  
                                        }//if listado=0
                                    }//if paso!=0
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
            
            function Confirmar(mensaje){
                var mens = document.getElementById('confirm');
                mens.textContent = mensaje;
                $( "#dialog-confirm" ).dialog( "open" );
            }
            
            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
                else if (boton.value=='2')
                    EjecutarSalidasProgs();
            }
            
            function CargaPagina(){
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                if (paso>0){
                %>
                    var acciones = document.getElementById('acciones');
                    acciones.style.display = '';
                <%
                }
                %>
            }
            
            function Activa(fila, idconcep){
                if (idconcep!=6 && idconcep!=7){
                var idMext = document.getElementById('idMext');
                var editar = document.getElementById('editar');
                editar.style.display = '';
                <%
                if (fijos.size()==1){
                %>
                    document.frmGestionarMovExt.radioMext.checked = true;
                    idMext.value = document.frmGestionarMovExt.radioMext.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarMovExt.radioMext[fila];
                    radio.checked = true;
                    idMext.value = radio.value;
                <% } %>
                }
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/Plazas/gestionarplazas.jsp';
                <%if(datosS.get("origenmovext")!=null){%>
                     pagina.value = '<%=datosS.get("origenmovext").toString()%>';
                <%}%>
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevoClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/nuevomovextra.jsp';
                paso.value = '2';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/nuevomovextra.jsp';
                paso.value = '4';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                paso.value = '6';
                frm.submit();
            }
            
            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar('¿Está seguro en dar de baja el Movimiento seleccionado?');
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/movsextrasinactivos.jsp';
                paso.value = '7';
                frm.submit();                
            }
                        
            function CargaMovsExtras(){
                var anio = document.getElementById('anio');
                var quin = document.getElementById('quincena');
                if (anio.value == ''){
                    anio.focus();
                    MostrarMensaje('El Año no ha sido definido');
                    return;
                } else {
                    nAnio = parseInt(anio.value);
                    if (nAnio<2000 || nAnio>=3000){
                        anio.focus();
                        MostrarMensaje('El Año escrito no es válido. Ingrese un valor entre 2000 y 2099');
                        return;
                    }
                }
                
                if (quin.value == ''){
                    quin.focus();
                    MostrarMensaje('La Quincena no ha sido establecida');
                    return;
                }
                
                Espera();
                var frm = document.getElementById('frmGestionarMovExt');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Nomina/MovsExtras/gestionarmovsextras.jsp';
                paso.value = '1';
                frm.submit();                    
            }
        </script>
    </body>
</html>
