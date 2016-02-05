<%-- 
    Document   : login
    Created on : 13-abr-2012, 1:21:10
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
        
        //BOTONES
        $(function() {
            $( "#btnIniciar" ).button({
                icons: {
                    primary: "ui-icon-key"
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
        <br><br><br>
        <table width="100%">
            <tr>
                <td width="100%" align="center">
                    <div class="subtitulo" align="center">
                        Ingrese sus datos de acceso
                    </div>
                    <div class="etiquetaC" align="center">
                        (Recuerde que se hace diferencia entre may&uacute;sculas y min&uacute;sculas)
                    </div>
                </td>
            </tr>
        </table>
        <form id="frmLogin" action="<%=CONTROLLER%>/Login/Usuario" method="post">
            <table width="100%">
                <tr>
                    <td width="50%" align="center">
                        <div align="center">
                            <img src="/siscaim/Imagenes/Login/login01.png" align="center" width="300" height="250">
                        </div>
                    </td>
                    <td width="50%" align="left">
                        <div class="etiqueta" align="left">
                            Usuario:<br>
                            <input id="usuario" name="usuario" type="text" value="" style="width: 200px" maxlength="20"
                                   onkeypress="ValidaTecla(event)" class="text"/>
                        </div>
                        <div class="etiqueta" align="left">
                            Contrase&ntilde;a:<br>
                            <input id="pass" name="pass" type="password" value="" style="width: 200px" maxlength="20"
                                   onkeypress="ValidaTecla(event)" class="text"/>
                        </div>
                        <br>
                        <div class="etiqueta" align="left">
                            <a id="btnIniciar" href="javascript: IniciarClick()"
                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Ingresar al sistema">
                                Iniciar
                            </a>
                            <!--<style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                <tr>
                                    <td style="padding-right:0px" title ="Iniciar">
                                        <a href="javascript: IniciarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/iniciar.png);width:150px;height:30px;display:block;"><br/></a>
                                    </td>
                                </tr>
                            </table>-->
                        </div>
                        <br><br><br>
                        <!--
                        <div class="etiqueta" align="center">
                            <a href="#">Recordar Datos de Acceso</a>
                        </div>-->
                    </td>
                </tr>
            </table>
        </form>
    </body>    
    <script language="javascript">
        function MostrarMensaje(mensaje){
            var mens = document.getElementById('alerta');
            mens.textContent = mensaje;
            $( "#dialog-message" ).dialog( "open" );
        }
        
        function CargaPagina(){
            var txtUsuario = document.getElementById('usuario');
            txtUsuario.focus();
            <%
            if (sesion!=null && sesion.isError()){
            %>
                MostrarMensaje('<%=sesion.getMensaje()%>')
            <%
            }
            %>
        }
        
        function IniciarClick(){
            var txtUsuario = document.getElementById('usuario');
            var txtPass = document.getElementById('pass');
                       
            if (txtUsuario.value == '')
            {
                MostrarMensaje('El campo Usuario está vacío');
                txtUsuario.focus();
                return;
            }
            
            if (txtPass.value == '')
            {
                MostrarMensaje('El campo Contraseña está vacío');
                txtPass.focus();
                return;
            }
            
            var frm = document.getElementById('frmLogin');
            frm.submit()
        }
        
        function ValidaTecla(e){
            var key = window.event ? e.keyCode : e.which;
            if (key==13){
                IniciarClick();
            }
            //var keychar = String.fromCharCode(key);
        }
    </script>
</html>
