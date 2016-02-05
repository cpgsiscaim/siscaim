<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.Sucursal"%>
<%@page import="java.lang.String, javax.servlet.http.HttpSession"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliSel = (Cliente)datosS.get("clienteSel");
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String titulo = "IMPORTAR DATOS AL CONTRATO";
    String imagen = "contratoEditar.png";
    Contrato con = (Contrato)datosS.get("editarContrato");
    List<Contrato> listado = (List<Contrato>)datosS.get("todosloscontratos");
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
            $( "#btnImportar" ).button({
                icons: {
                    primary: "ui-icon-transferthick-e-w"
		}
            });
            $( "#btnCancelar" ).button({
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
                    <!--aquí poner la imagen asociada con el proceso-->
                    <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR CONTRATOS<br><%=titulo%>
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%if (cliSel.getTipo()==0){%>
                        <%=cliSel.getDatosFiscales().getRazonsocial()%><br>
                        <%}%>
                        <%if (cliSel.getDatosFiscales().getPersona()!=null){%>
                        <%=cliSel.getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%}%>
                    </div>
                    <div class="subtitulo" align="left">
                        <%=con.getContrato()+" - "+con.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmImportarDat" name="frmImportarDat" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="datos" name="datos" type="hidden" value=""/>
            <input id="contrato" name="contrato" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="dvdatos">            
            <table width="100%">
                <tr>
                    <td width="100%">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="90%" align="center">
                                            <tr>
                                                <td width="50%" align="left" valign="top">
                                                    <span class="etiquetaB">
                                                        Elija el contrato que contiene los datos a importar:
                                                    </span><br>
                                                    <select id="contratos" name="contratos" size="7" style="width: 450px">
                                                    <%
                                                    for (int i=0; i < listado.size(); i++){
                                                        Contrato cto = listado.get(i);
                                                        if (cto.getId()!=con.getId()){
                                                    %>
                                                        <option value="<%=cto.getId()%>">
                                                            <%=cto.getContrato()%> - <%=cto.getDescripcion()%>
                                                        </option>
                                                    <%
                                                        }
                                                    }
                                                    %>
                                                    </select>
                                                </td>
                                                <td width="50%" align="left" valign="top">
                                                    <span class="etiquetaB">
                                                        Defina los datos que desea importar:
                                                    </span><br>
                                                    <input id="rddatos" name="rddatos" type="radio" value="1" onclick="ActivaDatos(this.value)">
                                                    <span class="etiqueta">Centros de Trabajo</span><br>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <input id="chkplazas" name="chkplazas" type="checkbox" disabled>
                                                    <span class="etiqueta">Incluir Plazas</span>
                                                    <input id="chkprodcts" name="chkprodcts" type="checkbox" disabled>
                                                    <span class="etiqueta">Incluir Productos</span><br>
                                                    <input id="rddatos" name="rddatos" type="radio" value="2" onclick="ActivaDatos(this.value)">
                                                    <span class="etiqueta">Productos</span><br>
                                                    <input id="rddatos" name="rddatos" type="radio" value="4" onclick="ActivaDatos(this.value)">
                                                    <span class="etiqueta">Contactos</span><br>
                                                    <input id="rddatos" name="rddatos" type="radio" value="3" onclick="ActivaDatos(this.value)">
                                                    <span class="etiqueta">Todo (Centros de Trabajo, Plazas, Productos y Contactos)</span><br>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" colspan="2">
                                                    <input id="chkeliminar" name="chkeliminar" type="checkbox">
                                                    <span class="etiqueta">Eliminar datos actuales antes de importar</span><br>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <a id="btnImportar" href="javascript: ImportarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Importar los datos seleccionados">
                                            Importar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Importar">
                                                    <a href="javascript: ImportarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/importar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>-->
                                    </td>
                                    <td width="20%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar importación de datos">
                                            Cancelar
                                        </a>
                                        <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
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
                var datos = document.getElementById('dvdatos');
                datos.style.display = 'none';                
            }

            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarImportar();
            }            

            function RetornaFalso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    return false;//EjecutarImportar();
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
                HttpSession sesionHttp = request.getSession();
                if (sesion.isError())
                    sesion.setError(false);
                if (sesion.isExito())
                    sesion.setExito(false);
                sesionHttp.setAttribute("sesion", sesion);
                %>
            }
            
            function ActivaDatos(valor){
                var datos = document.getElementById('datos');
                datos.value = valor;
                var chkplazas = document.getElementById('chkplazas');
                var chkprodcts = document.getElementById('chkprodcts');
                chkplazas.disabled = true;
                chkplazas.checked = false;
                chkprodcts.disabled = true;
                chkprodcts.checked = false;
                if (valor==1){
                    chkplazas.disabled = false;
                    chkprodcts.disabled = false;
                }
            }

            function CancelarClick(){
                var frm = document.getElementById('frmImportarDat');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
            
            function EjecutarImportar(){
                Espera();
                var frm = document.getElementById('frmImportarDat');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/gestionarcontratos.jsp';
                frm.pasoSig.value = '14';
                frm.submit();
            }
            
            function ImportarClick(){
                if (ValidaRequeridos()){
                    var chkeliminar = document.getElementById('chkeliminar');
                    if (chkeliminar.checked){
                        var boton = document.getElementById('boton');
                        boton.value = '1';                
                        Confirmar('Los datos actuales del Contrato serán eliminados, ¿continuar?');
                    } else {
                        EjecutarImportar();
                    }
                    
                }
            }
            
            function ValidaRequeridos(){
                var contratos = document.getElementById('contratos');
                var contrato = document.getElementById('contrato');
                contrato.value = '';
                for (i=0; i < contratos.length; i++){
                    if (contratos.options[i].selected){
                        contrato.value = contratos.options[i].value;
                        break;
                    }
                }
                
                if (contrato.value == ''){
                    MostrarMensaje('No ha seleccionado el contrato');
                    return false;
                }
                
                var datos = document.getElementById('datos');
                if (datos.value == ''){
                    MostrarMensaje('No ha definido los datos que desea importar del contrato seleccionado');
                    return false;
                }
                                    
                return true;
            }

        </script>
    </body>
</html>