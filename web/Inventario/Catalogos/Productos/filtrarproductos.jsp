<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Proveedor, Modelo.Entidades.Categoria, Modelo.Entidades.Marca"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String sinres = datosS.get("sinresultados")!=null?datosS.get("sinresultados").toString():"";
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
                        Inventario / Catálogos<br>
                        Gestionar Productos - Filtrar
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmFiltrarPro" name="frmFiltrarPro" action="<%=CONTROLLER%>/Gestionar/Productos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table>
                                <tr>
                                    <td width="20%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/productosD.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="15%" align="right">
                                                    <input id="filtro1" name="filtro1" type="checkbox" onclick="HabilitaCampo(this, 'descripcion')"/>
                                                </td>
                                                <td width="20%" align="left">
                                                    <span class="etiqueta">Descripción:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <input id="descripcion" name="descripcion" type="text" value=""
                                                           style="width: 480px" onblur="Mayusculas(this)" disabled/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%" align="right">
                                                    <input id="filtro2" name="filtro2" type="checkbox" onclick="HabilitaCampo(this, 'proveedor')"/>
                                                </td>
                                                <td width="20%" align="left">
                                                    <span class="etiqueta">Proveedor:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <select id="proveedor" name="proveedor" class="combo" style="width: 480px" disabled>
                                                        <option value="">Elija el Proveedor...</option>
                                                        <%
                                                        List<Proveedor> proveedores = (List<Proveedor>)datosS.get("proveedores");
                                                        for (int i=0; i < proveedores.size(); i++){
                                                            Proveedor pr = proveedores.get(i);
                                                        %>
                                                        <option value="<%=pr.getId()%>">
                                                            <%=pr.getTipo().equals("0")?pr.getDatosfiscales().getRazonsocial():pr.getDatosfiscales().getPersona().getNombreCompleto()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>                        
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%" align="right">
                                                    <input id="filtro3" name="filtro3" type="checkbox" onclick="HabilitaCampo(this, 'categoria')"/>
                                                </td>
                                                <td width="20%" align="left">
                                                    <span class="etiqueta">Categoría:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <select id="categoria" name="categoria" class="combo" style="width: 300px" disabled>
                                                        <option value="">Elija la Categoría...</option>
                                                        <%
                                                        List<Categoria> cats = (List<Categoria>)datosS.get("categorias");
                                                        for (int i=0; i < cats.size(); i++){
                                                            Categoria categ = cats.get(i);
                                                        %>
                                                        <option value="<%=categ.getId()%>">
                                                            <%=categ.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="15%" align="right">
                                                    <input id="filtro4" name="filtro4" type="checkbox" onclick="HabilitaCampo(this, 'marca')"/>
                                                </td>
                                                <td width="20%" align="left">
                                                    <span class="etiqueta">Marca:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <select id="marca" name="marca" class="combo" style="width: 300px" disabled>
                                                        <option value="">Elija la Marca...</option>
                                                        <%
                                                        List<Marca> marcas = (List<Marca>)datosS.get("marcas");
                                                        for (int i=0; i < marcas.size(); i++){
                                                            Marca mar = marcas.get(i);
                                                        %>
                                                        <option value="<%=mar.getId()%>">
                                                            <%=mar.getDescripcion()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
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
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Aplicar">
                                                    <a href="javascript: AplicarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="20%">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Cancelar">
                                                    <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
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
                if (sinres.equals("1")){
                %>
                     Mensaje('Los filtros establecidos no arrojaron resultados');
                <%
                }
                %>
            }
            
            function HabilitaCampo(filtro, objeto){
                valor = true;             
                if (filtro.checked){
                    valor = false;
                }
                
                var campo = document.getElementById(objeto);
                campo.disabled = valor;
                campo.value = '';
                campo.focus();
            }
            
            function AplicarClick(){
                if (Valida()){
                    var frm = document.getElementById('frmFiltrarPro');
                    frm.paginaSig.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                    frm.pasoSig.value = '9';
                    frm.submit();                    
                }
            }
            
            function Valida(){
                var filtro1 = document.getElementById('filtro1');
                if (filtro1.checked){
                    var descrip = document.getElementById('descripcion');
                    if (descrip.value == ''){
                        Mensaje('El campo Descripción está vacío');
                        descrip.focus();
                        return false;
                    }
                }
                var filtro2 = document.getElementById('filtro2');
                if (filtro2.checked){
                    var prov = document.getElementById('proveedor');
                    if (prov.value == ''){
                        Mensaje('El campo Proveedor está vacío');
                        prov.focus();
                        return false;
                    }
                }
                
                var filtro3 = document.getElementById('filtro3');
                if (filtro3.checked){
                    var cat = document.getElementById('categoria');
                    if (cat.value == ''){
                        Mensaje('El campo Categoría está vacío');
                        cat.focus();
                        return false;
                    }
                }
                
                var filtro4 = document.getElementById('filtro4');
                if (filtro4.checked){
                    var marca = document.getElementById('marca');
                    if (marca.value == ''){
                        Mensaje('El campo Marca está vacío');
                        marca.focus();
                        return false;
                    }
                }

                return true;
            }

            function CancelarClick(){
                var frm = document.getElementById('frmFiltrarPro');
                frm.paginaSig.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                frm.pasoSig.value = '96';
                frm.submit();
            }
        </script>
    </body>
</html>