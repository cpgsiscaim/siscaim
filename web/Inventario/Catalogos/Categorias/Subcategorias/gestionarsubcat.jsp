<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Categoria, Modelo.Entidades.Subcategoria"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
Categoria catSel = (Categoria)datosS.get("categoriaEditar");
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
                <td width="100%">
                    <div class="titulo" align="center">
                        Inventario / Catálogos / Categorías<br>Gestionar Subcategorías<br><br>
                        CATEGORIA <%=catSel.getClave()%> - <%=catSel.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarScat" name="frmGestionarScat" action="<%=CONTROLLER%>/Gestionar/Subcategorias" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idSub" name="idSub" type="hidden" value=""/>            
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Inventario/Catalogos/subcatA.png" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="20%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="20%" align="center">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivas">
                                                            <a href="javascript: VerInactivas()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivas.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="40%" align="center">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaSubClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                        <td width="50%" align="right">
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Editar">
                                                                        <a href="javascript: EditarSubClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                    
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="20%" align="center">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nueva">
                                                            <a href="javascript: NuevaSubClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nueva.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                        </tr>
                                    </table>

                                    <hr>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    List<Subcategoria> listado = (List<Subcategoria>)datosS.get("listaSubcategorias");
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Subcategorías registradas de la Categoría seleccionada
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="15%">    
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Clave</span>
                                                </td>
                                                <td align="center" width="50%">
                                                    <span>Subcategoría</span>
                                                </td>
                                                <td align="center" width="20%">
                                                    <span>Fecha Alta</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Subcategoria scat = listado.get(i);
                                                String fechaAlta = scat.getFechaAlta().toString();
                                                String fechaNormal =fechaAlta.substring(8,10) + "-" + fechaAlta.substring(5,7) + "-" + fechaAlta.substring(0, 4);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="15%">
                                                        <input id="radioCat" name="radioCat" type="radio" value="<%=scat.getId()%>"/>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span class="etiqueta">
                                                            <%=scat.getClave()%>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="50%">
                                                        <span class="etiqueta">
                                                            <%=scat.getDescripcion()%>
                                                        </span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span class="etiqueta"><%=fechaNormal%></span>
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
                var idSub = document.getElementById('idSub');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarScat.radioCat.checked = true;
                    idSub.value = document.frmGestionarScat.radioCat.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarScat.radioCat[fila];
                    radio.checked = true;
                    idSub.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarScat');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Categorias/gestionarcategorias.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function NuevaSubClick(){
                var frm = document.getElementById('frmGestionarScat');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Categorias/Subcategorias/nuevasubcat.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarSubClick(){
                var frm = document.getElementById('frmGestionarScat');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Categorias/Subcategorias/nuevasubcat.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function BajaSubClick(){
                var resp = confirm('¿Está seguro en dar de baja la Subcategoría seleccionada?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarScat');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Catalogos/Categorias/Subcategorias/gestionarsubcat.jsp';
                    paso.value = '5';
                    frm.submit();
                }
            }
            
            function VerInactivas(){
                var frm = document.getElementById('frmGestionarScat');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Categorias/Subcategorias/subcatinactivas.jsp';
                paso.value = '6';
                frm.submit();                
            }
            
        </script>
    </body>
</html>