<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Sucursal"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
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
                        Gestionar Sucursales - Inactivas
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarSucIn" name="frmGestionarSucIn" action="<%=CONTROLLER%>/Gestionar/Sucursales" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idSuc" name="idSuc" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Empresa/sucursalesA.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="50%" align="left">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <td width="50%">
                                                    <table id="borrarEdit" style="display: none;" width="100%">
                                                        <tr>
                                                            <td width="100%" align="right">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Activar">
                                                                            <a href="javascript: AltaSucClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                        <table class="tablaLista" width="100%">
                                        <%
                                        List<Sucursal> listado = (List<Sucursal>)datosS.get("inactivas");
                                        if (listado.size()==0){
                                        %>
                                            <tr>
                                                <td colspan="4" align="center">
                                                    <span class="etiquetaB">
                                                        No hay sucursales inactivas
                                                    </span>
                                                </td>
                                            </tr>
                                        <%
                                        } else {
                                        %>
                                            <thead>
                                                <tr>
                                                    <td align="center" width="50%" colspan="2">
                                                        <span>Sucursal</span>
                                                    </td>
                                                    <td align="center" width="30%">
                                                        <span>Ciudad</span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span>Estado</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%    
                                                for (int i=0; i < listado.size(); i++){
                                                    Sucursal suc = listado.get(i);
                                            %>
                                                    <tr onclick="Activa(<%=i%>)">
                                                        <td align="center" width="10%">
                                                            <input id="radioSucIn" name="radioSucIn" type="radio" value="<%=suc.getId()%>"/>
                                                        </td>
                                                        <td align="left" width="40%">
                                                            <span class="etiqueta"><%=suc.getDatosfis().getRazonsocial()%></span>
                                                        </td>
                                                        <td align="left" width="30%">
                                                            <span class="etiqueta"><%=suc.getDatosfis().getDireccion().getPoblacion().getMunicipio()%></span>
                                                        </td>
                                                        <td align="left" width="20%">
                                                            <span class="etiqueta"><%=suc.getDatosfis().getDireccion().getPoblacion().getEstado().getEstado()%></span>
                                                        </td>
                                                    </tr>
                                            <%
                                                }
                                            %>
                                            </tbody>
                                        <%    
                                        }
                                        %>
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
            
            function Activa(fila){
                var idSuc = document.getElementById('idSuc');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarSucIn.radioSucIn.checked = true;
                    idSuc.value = document.frmGestionarSucIn.radioSucIn.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarSucIn.radioSucIn[fila];
                    radio.checked = true;
                    idSuc.value = radio.value;
                <% } %>
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmGestionarSucIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarSucursales/gestionarsucursales.jsp';
                paso.value = '96';
                frm.submit();                
            }
            
            function AltaSucClick(){
                var frm = document.getElementById('frmGestionarSucIn');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarSucursales/sucursalesinactivas.jsp';
                paso.value = '7';
                frm.submit();                
            }
            
        </script>
    </body>
</html>