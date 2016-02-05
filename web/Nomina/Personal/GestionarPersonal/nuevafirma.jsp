<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Empleado"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Empleado empl = (Empleado)datosS.get("editarEmpleado");
String firma = "";
if (paso == 36){
    firma = empl.getFirma()!=null && !empl.getFirma().equals("")?empl.getFirma():"default.png";
} else if (paso == 1){
    firma = datosS.get("firma")!=null?datosS.get("firma").toString():"default.png";
}
//String ruta = datosS.get("rutafoto").toString()+"\\"+fotoSel;
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
    </head>
    <body onload="CargaPagina()">
        <div id="dialog-message" title="SISCAIM - Mensaje">
            <p id="alerta" class="error"></p>
        </div>
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/firmaA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="titulo" align="left">
                        EDITAR FIRMA
                    </div>
                    <div class="subtitulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompleto()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevaFirmaAlt" name="frmNuevaFirmaAlt" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="firmaNueva" name="firmaNueva" type="hidden" value=""/>
        </form>
            
        <form id="frmNuevaFirma" name="frmNuevaFirma" action="<%=CONTROLLER%>/Nueva/Firma" enctype="multipart/form-data" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="firmaNueva" name="firmaNueva" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="60%" align="center">
                                <tr>
                                    <td width="100%" valign="center">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Elija la imagen de la firma:</span><br>
                                                    <span class="etiquetaC">(El nombre del archivo debe ser la clave del empleado: <%=empl.getClave()%>)</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="firmaFile" name="firmaFile" type="file" accept="images/*.png"
                                                           onchange="CargaImagen(this.value)">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    <img src="/siscaim/Imagenes/Personal/Firmas/<%=firma%>"
                                                         align="center" width="300" height="150">
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="50%" align="right">
                                        <a id="btnGuardar" href="javascript: GuardarClick()"
                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
                                            Guardar
                                        </a>
                                    </td>
                                    <td width="50%">
                                        <a id="btnCancelar" href="javascript: CancelarClick()"
                                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                                            Cancelar
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
            <div id="procesando" style="display: none">
                <table id="tbprocesando" align="center" width="100%">
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
                    MostrarMensaje('<%=sesion.getMensaje()%>')
                <%
                }
                if (sesion!=null && sesion.isExito()){
                %>
                    MostrarMensaje('<%=sesion.getMensaje()%>');
                    //llamar a la funcion que redirija a la pagina siguiente
                <%
                }
                %>
            }
            
            function GuardarClick(){
                <%
                if (datosS.get("firma")==null){
                %>
                        MostrarMensaje('Debe seleccionar la firma');
                        return;
                <%
                }
                %>
                Espera();
                var frm = document.getElementById('frmNuevaFirmaAlt');
                frm.firmaNueva.value = '<%=firma%>';
                frm.pasoSig.value = '37';
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.submit();
            }
            
            function CargaImagen(archivo){
                Espera();
                tokens = archivo.split('\\');
                nombreArch = tokens[tokens.length-1];
                tokensNom = nombreArch.split('.');
                solonombre = tokensNom[0].toUpperCase();
                if (solonombre != '<%=empl.getClave()%>'){
                    MostrarMensaje('El nombre del archivo no corresponde a la clave del Empleado');
                    return;
                }
                
                var frm = document.getElementById('frmNuevaFirma');
                frm.firmaNueva.value=nombreArch;
                frm.pasoSig.value = '1';
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/nuevafirma.jsp';
                frm.submit();
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmNuevaFirmaAlt');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.pasoSig.value = '90';
                frm.submit();
            }

        </script>
    </body>
</html>