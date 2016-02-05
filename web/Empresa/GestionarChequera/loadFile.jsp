<%-- 
    Document   : loadFile
    Created on : Oct 18, 2013, 12:07:56 PM
    Author     : germha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
 <%@page import="java.util.HashMap"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
    HashMap datosS = sesion.getDatos();  
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <!--<link type="text/css" href="/siscaim/Estilos/titulos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/formValidado.css" rel="stylesheet" />-->
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
        });

        </script>
    <!-- Jquery UI -->
    </head>
    <body>
        <br><br><br>
        <table align="center">
          <tr>
            <td width="20%" align="center">
                <img src="/siscaim/Imagenes/Empresa/load.png" width="180">
            </td>
            <td width="10%" align="center"></td>
            <td width="70%">
              <table width="100%">                                
                <tr>
                  <td><b>INDICACIONES</b></td>
                </tr>
                <tr>
                  <td>* Subir un documento por cada cargo.<br>
                    * El sistema acepta archivos PDF &uacute;nicamente.<br>
                    * El archivo se carga inmediatamente después de seleccionarlo.
                  </td>
                </tr>
              </table>
            <form id="cargaArchivo" name="cargaArchivo" action="<%=CONTROLLER%>/NuevoDoc/Cargo" method="post" enctype="multipart/form-data">                    
                <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
                <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
                <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
                <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
                <input id="archivoCargo" name="archivoCargo" type="hidden" value=""/>
                
                <table width="100%">
                    <tr>
                        <td>
                            <input type="file" id="uploadfile" name="uploadfile" onchange="CargaImagen(this.value)" /><br><br><br>
                        </td>
                    </tr>
                </table>
                <table width="100%">
                    <tr>
                        <td align="right">
                            <a id="btnCancelar" href="javascript: CancelarClick()"
                                style="width: 150px; font-weight: bold; color: #FFFFFF;
                                background: indianred 50% bottom repeat-x;" title="Cancelar registro de gasto">
                                Cancelar
                            </a>
                        </td>
                    </tr>
                </table>
           </form>
            </td>
          </tr>
        </table>        
<script language="javascript">
    function CancelarClick(){
        var frm = document.getElementById('cargaArchivo');
        frm.pasoSig.value = '2';
        frm.paginaSig.value = '/Empresa/GestionarChequera/gestionarMovimientos.jsp';
        frm.submit();
    }
    
    function CargaImagen(archivo){
        tokens = archivo.split('\\');
        nombreArch = tokens[tokens.length-1];
        tokensNom = nombreArch.split('.'); 
        exten = tokensNom[tokensNom.length-1];
        if (exten.toLowerCase().trim() != 'pdf'){
            Mensaje('La extensión del archivo debe ser pdf');
            return;
        }

        var frm = document.getElementById('cargaArchivo');
        frm.archivoCargo.value=nombreArch;
        frm.pasoSig.value = '1';
        frm.paginaSig.value = '/Empresa/GestionarChequera/nuevoCargo.jsp';
        frm.submit();
    }
    
</script>        
    </body>
</html>
