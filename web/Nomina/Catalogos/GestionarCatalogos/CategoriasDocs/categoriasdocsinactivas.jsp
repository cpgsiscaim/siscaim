<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.ArrayList, java.util.List, java.util.HashMap, Modelo.Entidades.Catalogos.CategoriaDoc"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
List<CategoriaDoc> inactivas = new ArrayList<CategoriaDoc>();
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
                <td width="20%" align="center" valign="top">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/docs01.png" align="center" width="180" height="100">                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        GESTIONAR CATEGOR&Iacute;AS DE DOCUMENTACI&Oacute;N
                    </div>
                    <div class="titulo" align="center">
                        Inactivas
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmCategoriasDocs" name="frmCategoriasDocs" action="<%=CONTROLLER%>/Gestionar/CategoriasDocs" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCatDoc" name="idCatDoc" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <%-- Boton Salir --%>
                                                <td width="85%" align="left">
                                                    <style>#btnCancelar a{display:block;color:transparent;} #btnCancelar a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnCancelar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <td width="15%" align="right">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="100%" align="center">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Activar">
                                                                            <a href="javascript: ActivarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/activar.png);width:150px;height:30px;display:block;"><br/></a>
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
                                        <table class="tablaLista" width="40%" align="center">
                                            <%                                                
                                                inactivas = (List<CategoriaDoc>) datosS.get("inactivas");
                                                if (inactivas.size()==0){
                                            %>
                                                <tr>
                                                    <td width="100%" align="center">
                                                        <span class="etiquetaB">No hay Categor&iacute;as de Documentaci&oacute;n inactivas</span>
                                                    </td>
                                                </tr>
                                            <%
                                                } else {
                                            %>
                                            <thead>
                                                <tr>
                                                    <td width="100%" align="center" colspan="2">
                                                        <span>Descripción</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody> 
                                                <%
                                                    for (int i = 0; i < inactivas.size(); i++) {
                                                        CategoriaDoc catdoc = inactivas.get(i);
                                                %>
                                                
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioCat" name="radioCat" type="radio" value="<%= catdoc.getId()%>" />
                                                    </td>
                                                    <td width="95%" align="center">                                                        
                                                        <span class="etiqueta"><%=catdoc.getDescripcion()%></span>
                                                    </td>
                                                </tr>
                                                <%
                                                    } //Fin for
                                                %> 
                                            </tbody>
                                            <%}%>
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

        function ActivarClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/categoriasdocsinactivas.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "7";
            var frm = document.getElementById('frmCategoriasDocs');
            frm.submit();
        }
        
        function CancelarClick(){
            var frm = document.getElementById('frmCategoriasDocs');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/categoriasdocs.jsp';
            paso.value = '97';
            frm.submit();                
        }

        function Activa(fila){
            var idCat = document.getElementById('idCatDoc');
            var borrarEdit = document.getElementById('borrarEdit');
            borrarEdit.style.display = '';
            <%
                if (inactivas.size() == 1) {
            %>
                    document.frmCategoriasDocs.radioCat.checked = true;
                    idCat.value = document.frmCategoriasDocs.radioCat.value;
            <%  } else {%>
                    var radio = document.frmCategoriasDocs.radioCat[fila];
                    radio.checked = true;
                    idCat.value = radio.value;
            <% }%>
        }
        
</script>
</body>
</html>

