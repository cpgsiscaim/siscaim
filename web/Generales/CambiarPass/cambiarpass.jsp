<%-- 
    Document   : cambiarpass
    Created on : 16-abr-2012, 14:24:47
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
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
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
		}
            });
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
        });

        </script>
    <!-- Jquery UI -->
        <title></title>
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
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
                    <img src="/siscaim/Imagenes/Login/login02.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        CAMBIAR CONTRASE&Ntilde;A
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmCambiarPass" action="<%=CONTROLLER%>/Cambiar/Pass" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="40%">&nbsp;
                                </td>
                                <td width="60%">
                                    <div class="etiqueta" align="left">
                                        Contrase&ntilde;a Actual:<br>
                                        <input id="passAct" name="passAct" type="password" class="text" value="" style="width: 200px" maxlength="20"
                                               onkeypress="return ValidaAlfaNum(event)"/>
                                    </div>
                                    <div class="etiqueta" align="left">
                                        Contrase&ntilde;a Nueva:<br>
                                        <input id="passNva" name="passNva" type="password" class="text" value="" style="width: 200px" maxlength="20"
                                               onkeypress="return ValidaAlfaNum(event)"/>
                                        <span class="etiquetaC">M&iacute;nimo 8 caracteres, letras y/o n&uacute;meros</span>
                                    </div>
                                    <div class="etiqueta" align="left">
                                        Confirmar Contrase&ntilde;a Nueva:<br>
                                        <input id="passConfirm" name="passConfirm" type="password" class="text" value="" style="width: 200px" maxlength="20"
                                               onkeypress="return ValidaAlfaNum(event)"/>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%" colspan="2">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td width="40%">
                                    &nbsp;
                                </td>
                                <td width="60%">                                
                                    <div align="left">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%" align="right">
                                                    <a id="btnGuardar" href="javascript: GuardarClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar la nueva contraseña">
                                                        Guardar
                                                    </a>
                                                    <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Guardar">
                                                                <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>-->
                                                </td>
                                                <td width="50%">
                                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                        background: indianred 50% bottom repeat-x;" title="Cancelar cambio de contraseña">
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
                                    </div>                                
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
        <script language="javascript">
            function MostrarMensaje(mensaje){
                var mens = document.getElementById('alerta');
                mens.textContent = mensaje;
                $( "#dialog-message" ).dialog( "open" );
            }
            
            function CargaPagina(){
                var txtPassAct = document.getElementById('passAct');
                txtPassAct.focus();
                <%
                if (sesion!=null && sesion.isError()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                <%
                }
                
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    CancelarClick();
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
            
            function GuardarClick(){
                //validar campos completos
                var txtPassAct = document.getElementById('passAct');
                var txtPassNva = document.getElementById('passNva');
                var txtPassConfirm = document.getElementById('passConfirm');
                
                if (txtPassAct.value == ''){
                    txtPassAct.focus();
                    MostrarMensaje('La contraseña actual está vacía');
                    return;
                }
                
                if (txtPassNva.value == ''){
                    txtPassNva.focus();
                    MostrarMensaje('La contraseña nueva está vacía');
                    return;
                }
                
                if (txtPassConfirm.value == ''){
                    txtPassConfirm.focus();
                    MostrarMensaje('La confirmación de la contraseña nueva está vacía');
                    return;
                }

                //checar longitud minima de pass nueva
                if (txtPassNva.value.length<8){
                    txtPassNva.value = '';
                    txtPassNva.focus();
                    MostrarMensaje('La contraseña nueva debe ser por lo menos de 8 caracteres');
                    return;
                }
                
                //checar si actual y nueva son iguales
                if (txtPassAct.value == txtPassNva.value){
                    txtPassNva.value = '';
                    txtPassNva.focus();
                    MostrarMensaje('La contraseña nueva debe ser diferente de la actual');
                    return;                    
                }
                
                //checar pass nueva con pass confirm
                if (txtPassNva.value != txtPassConfirm.value){
                    txtPassConfirm.value = '';
                    txtPassConfirm.focus();
                    MostrarMensaje('La confirmación de la contraseña nueva no coincide');
                    return;                    
                }
                
                var txtPasoSig = document.getElementById('pasoSig');
                pasoSig.value = 1;
                
                var frm = document.getElementById('frmCambiarPass');
                frm.submit();
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmCambiarPass');
                var pagina = document.getElementById('paginaSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                frm.action = '<%=CONTROLLER%>/Redirecciona/Pagina';
                frm.submit();
            }
        </script>
    </body>
</html>
