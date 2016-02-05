<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.ArrayList, java.util.List, java.util.HashMap, Modelo.Entidades.Catalogos.CategoriaDoc"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
//Estado edoActual = null;
HashMap datosS = sesion.getDatos();
List<CategoriaDoc> listado = new ArrayList<CategoriaDoc>();//(List<Cliente>)datosS.get("listado");
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
                <td width="20%" align="center" valign="top">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/docs01.png" align="center" width="180" height="100">                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        GESTIONAR CATEGOR&Iacute;AS DE DOCUMENTACI&Oacute;N
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
                                                <td width="15%" align="left">
                                                    <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                    <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Salir">
                                                                <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>                                                    
                                                </td>
                                                <%-- Boton Inactivos--%> 
                                                <td width="15%" align="left">
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                <tr>
                                                    <td style="padding-right:0px" title ="Ver Inactivas">
                                                        <a href="javascript: VerInactivas()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivas.png);width:150px;height:30px;display:block;"><br/></a>
                                                    </td>
                                                </tr>
                                                </table>                                                    
                                                </td>
                                                <td width="25%" align="right">&nbsp;</td>
                                                <td width="30%" align="right">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="50%" align="center">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Baja">
                                                                            <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>                                                    
                                                            </td>
                                                            <td width="50%" align="center">
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Editar">
                                                                            <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>        
                                                    </table>
                                                </td>
                                                <td width="15%" align="right">
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Nueva" >
                                                                <a href="javascript: NuevaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nueva.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>                                     
                                                    </table>
                                                </td>                                                                        
                                            </tr>
                                        </table>
                                        <hr>
                                        <table class="tablaLista" width="40%" align="center">
                                            <%                                                
                                                listado = (List<CategoriaDoc>) datosS.get("listado");
                                                if (listado.size()==0){
                                            %>
                                                <tr>
                                                    <td width="100%" align="center">
                                                        <span class="etiquetaB">No hay Categor&iacute;as de Documentaci&oacute;n registradas</span>
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
                                                    for (int i = 0; i < listado.size(); i++) {
                                                        CategoriaDoc catdoc = listado.get(i);
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

        function NuevaClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/nuevacategoriadoc.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "1";
            var frm = document.getElementById('frmCategoriasDocs');
            frm.submit();
        }
        
        function EditarClick(){
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/nuevacategoriadoc.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "3";
            var frm = document.getElementById('frmCategoriasDocs');
            frm.submit();
        }
        
        function BajaClick(){
            var resp = confirm('¿Está seguro en dar de baja la Categoría seleccionada?','SISCAIM');
            if (resp){
                var frm = document.getElementById('frmCategoriasDocs');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = "/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/categoriasdocs.jsp"
                paso.value = '5';
                frm.submit();
            }
        }

        function SalirClick(){
            var frm = document.getElementById('frmCategoriasDocs');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
            paso.value = '99';
            frm.submit();                
        }

        function VerInactivas(){
            var frm = document.getElementById('frmCategoriasDocs');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Catalogos/GestionarCatalogos/CategoriasDocs/categoriasdocsinactivas.jsp';
            paso.value = '6';
            frm.submit();                
        }

        function Activa(fila){
            var idCat = document.getElementById('idCatDoc');
            var borrarEdit = document.getElementById('borrarEdit');
            borrarEdit.style.display = '';
            <%
                if (listado.size() == 1) {
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

