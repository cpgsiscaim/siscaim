<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Producto"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>
<%@page import="java.lang.String, javax.servlet.http.HttpSession"%>
<%@page import="Modelo.Entidades.Proveedor, Modelo.Entidades.Categoria, Modelo.Entidades.Marca"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
List<Producto> listado = new ArrayList<Producto>();
//Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
//String matriz = datosS.get("matriz").toString();
NumberFormat formato = new DecimalFormat("#,##0.00");
String sinres = datosS.get("sinresultados")!=null?datosS.get("sinresultados").toString():"";
Sucursal sucusu = (Sucursal)datosS.get("sucusuario");
String matriz = datosS.get("matriz").toString();
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
        
        //DIALOGO LISTA DE PRECIOS
        $(function() {
            $( "#dialog-lista" ).dialog({
            resizable: false,
            width:300,
            height:250,
            modal: true,
            autoOpen: false,
            buttons: {
                "Imprimir": function() {
                Imprimir();
                },
                "Cancelar": function() {
                $( this ).dialog( "close" );
                //LimpiarInputs();
                }
            }
            });
        });
        
        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnInactivos" ).button({
                icons: {
                    primary: "ui-icon-cancel"
		}
            });
            $( "#btnListaPrecios" ).button({
                icons: {
                    primary: "ui-icon-note"
		}
            });
            $( "#btnFiltrar" ).button({
                icons: {
                    primary: "ui-icon-zoomin"
		}
            });
            $( "#btnQuitar" ).button({
                icons: {
                    primary: "ui-icon-zoomout"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-minus"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-wrench"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
            $( "#btnKardex" ).button({
                icons: {
                    primary: "ui-icon-cart"
		}
            });
            $( "#btnAplicarFil" ).button({
                icons: {
                    primary: "ui-icon-check"
		}
            });
            $( "#btnCancelarFil" ).button({
                icons: {
                    primary: "ui-icon-arrowreturn-1-w"
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
        
        <div id="dialog-lista" title="SISCAIM - Imprimir Lista de Precios">
            <table width="100%">
                <tr>
                    <td width="100%" align="left">
                        <p class="subtitulo">Defina la Sucusal</p>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%">
                                    <select id="sucursal" name="sucursal" class="combo" style="width: 200px"
                                            <%if (matriz.equals("0")){%>disabled<%}%>>
                                        <option value="">Elija la Sucursal...</option>
                                    <%
                                        List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                        for (int i=0; i < sucursales.size(); i++){
                                            Sucursal suc = sucursales.get(i);
                                        %>
                                            <option value="<%=suc.getId()%>"
                                                    <%if (sucusu.getId()==suc.getId()){%>selected<%}%>>
                                                <%=suc.getDatosfis().getRazonsocial()%>
                                            </option>
                                        <%
                                        }
                                    %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <input id="xls" name="xls" type="checkbox">
                                    <span class="etiqueta">Imprimir en Excel</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
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
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/productosB.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PRODUCTOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarProd" name="frmGestionarProd" action="<%=CONTROLLER%>/Gestionar/Productos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idPro" name="idPro" type="hidden" value=""/>            
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <input id="dato2" name="dato2" type="hidden" value=""/>
            <input id="dato3" name="dato3" type="hidden" value=""/>
            <input id="dato4" name="dato4" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
                                            <td width="15%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Productos">
                                                    Salir
                                                </a>
                                                <!--
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->                                                    
                                            </td>
                                            <td width="15%" align="center">
                                                <a id="btnInactivos" href="javascript: VerInactivos()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Ver Productos en baja">
                                                    Ver Inactivos
                                                </a>
                                                <!--
                                                <style>#btnInactivos a{display:block;color:transparent;} #btnInactivos a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnInactivos" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ver Inactivos">
                                                            <a href="javascript: VerInactivos()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/inactivos.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="30%" align="center">
                                                <a id="btnListaPrecios" href="javascript: ListaPrecios()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Imprimir Lista de Precios">
                                                    Lista de Precios
                                                </a>
                                                <!--
                                                <style>#btnListaPrecios a{display:block;color:transparent;} #btnListaPrecios a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnListaPrecios" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td width="50%" style="padding-right:0px" title ="Imprimir Lista de Precios">
                                                            <a href="javascript: ListaPrecios()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/listaprecios.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                        <td width="50%">
                                                            <input id="xls" name="xls" type="checkbox">
                                                            <span class="etiqueta">Imprimir en Excel</span>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            <td width="5%" align="right">&nbsp;</td>
                                            <td width="15%" align="center">
                                                <a id="btnFiltrar" href="javascript: FiltrarClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Filtrar la Lista de Productos">
                                                    Filtrar
                                                </a>
                                                <a id="btnQuitar" href="javascript: QuitarFiltroClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Quitar el filtro aplicado">
                                                    Quitar filtro
                                                </a>
                                                <!--
                                                <style>#btnFiltrar a{display:block;color:transparent;} #btnFiltrar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnFiltrar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Filtrar">
                                                            <a href="javascript: FiltrarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/filtrar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                                <style>#btnQuitar a{display:block;color:transparent;} #btnQuitar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnQuitar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Quitar Filtros">
                                                            <a href="javascript: QuitarFiltroClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/quitarfiltro.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->                                                    
                                            </td>
                                            <td width="15%" align="right">
                                                <a id="btnNuevo" href="javascript: NuevoClick()"
                                                   style="width: 150px; font-weight: bold; color: #0B610B;" title="Agregar un nuevo producto">
                                                    Nuevo
                                                </a>
                                                <!--
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->
                                            </td>
                                            
                                            <%--
                                            <td width="40%" align="right">
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px"
                                                        onchange="MostrarProductos()" <%if (matriz.equals("0")){%>disabled<%}%>>
                                                    <option value="0">Elija la Sucursal...</option>
                                                <%
                                                    List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                    if (sucursales!=null){
                                                        if (sucursales.size()!=0){
                                                            for (int i=0; i < sucursales.size(); i++){
                                                                Sucursal suc = sucursales.get(i);
                                                            %>
                                                                <option value="<%=suc.getId()%>"
                                                                        <%
                                                                        //if (paso!=0){
                                                                            //Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
                                                                            if (sucSel.getId()==suc.getId()){
                                                                            %>
                                                                                selected
                                                                            <%
                                                                            }
                                                                        //}
                                                                        %>
                                                                        >
                                                                    <%=suc.getDatosfis().getRazonsocial()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>--%>
                                        </tr>
                                    </table>
                                    <table id="acciones" width="100%">
                                        <tr>
                                            <td width="15%" align="center">
                                                <!--
                                                <style>#btnFiltrar a{display:block;color:transparent;} #btnFiltrar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnFiltrar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Filtrar">
                                                            <a href="javascript: FiltrarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/filtrar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                                <style>#btnQuitar a{display:block;color:transparent;} #btnQuitar a:hover{background-position:left bottom;}a#btnFiltrara {display:none}</style>
                                                <table id="btnQuitar" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Quitar Filtros">
                                                            <a href="javascript: QuitarFiltroClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/quitarfiltro.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>-->                                                    
                                            </td>
                                            <td width="25%">&nbsp;</td>
                                            <td width="60%" align="right">
                                                <table id="borrarEdit" width="100%" style="display: none">
                                                    <tr>
                                                        <td width="50%" align="right">
                                                            <a id="btnKardex" href="javascript: KardexClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar el kárdex del producto">
                                                                Kárdex
                                                            </a>
                                                            <!--
                                                            <style>#btnKardex a{display:block;color:transparent;} #btnKardex a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                            <table id="btnKardex" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Kárdex">
                                                                        <a href="javascript: KardexClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/kardex.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <%--
                                                        <td width="25%" align="right">
                                                            <style>#btnUnidades a{display:block;color:transparent;} #btnUnidades a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                            <table id="btnUnidades" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Otras Unidades">
                                                                        <a href="javascript: UnidadesClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/otrasunid.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                
                                                        </td>
                                                        --%>
                                                        <td width="25%" align="right">
                                                            <a id="btnBaja" href="javascript: BajaClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja el producto seleccionado">
                                                                Baja
                                                            </a>
                                                            <!--
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Baja">
                                                                        <a href="javascript: BajaClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/baja.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                        <td width="25%" align="right">
                                                            <a id="btnEditar" href="javascript: EditarClick()"
                                                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar el producto seleccionado">
                                                                Editar
                                                            </a>
                                                            <!--
                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                <tr>
                                                                    <td style="padding-right:0px" title ="Editar">
                                                                        <a href="javascript: EditarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                    </td>
                                                                </tr>
                                                            </table>-->
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <%--
                                            <td width="15%" align="right">
                                                <style>#btnNuevo a{display:block;color:transparent;} #btnNuevo a:hover{background-position:left bottom;}a#btnNuevoa {display:none}</style>
                                                <table id="btnNuevo" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Nuevo">
                                                            <a href="javascript: NuevoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>--%>
                                        </tr>
                                    </table>
                                    <hr>
                                    <div id="filtros" style="display: none">
                                        <table width="80%" align="center">
                                            <tr>
                                                <td width="25%" align="left"><span class="etiquetaB">Descripci&oacute;n:</span></td>
                                                <td width="25%" align="left"><span class="etiquetaB">Proveedor:</span></td>
                                                <td width="25%" align="left"><span class="etiquetaB">Categor&iacute;a:</span></td>
                                                <td width="25%" align="left"><span class="etiquetaB">Marca:</span></td>
                                            </tr>
                                            <tr>
                                                <td width="25%" align="left">
                                                    <input id="descripcion" name="descripcion" class="text" type="text" value=""
                                                           style="width: 300px" onblur="Mayusculas(this)"/>
                                                </td>
                                                <td width="25%" align="left">
                                                    <select id="proveedor" name="proveedor" class="combo" style="width: 250px">
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
                                                <td width="25%" align="left">
                                                    <select id="categoria" name="categoria" class="combo" style="width: 200px">
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
                                                <td width="25%" align="left">
                                                    <select id="marca" name="marca" class="combo" style="width: 200px">
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
                                            <tr>
                                                <td width="100%" colspan="4">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="70%">&nbsp;</td>
                                                            <td width="15%" align="right">
                                                                <a id="btnAplicarFil" href="javascript: AplicarFilClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Aplicar filtros establecidos">
                                                                    Aplicar
                                                                </a>
                                                                <!--
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Aplicar">
                                                                            <a href="javascript: AplicarFilClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/aplicar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>-->
                                                            </td>
                                                            <td width="15%" align="right">
                                                                <a id="btnCancelarFil" href="javascript: CancelarFilClick()"
                                                                style="width: 150px; font-weight: bold; color: #0B610B;" title="Cancelar filtros">
                                                                    Cancelar
                                                                </a>
                                                                <!--
                                                                <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                    <tr>
                                                                        <td style="padding-right:0px" title ="Cancelar">
                                                                            <a href="javascript: CancelarFilClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                        </td>
                                                                    </tr>
                                                                </table>-->
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                    </div>
                                    <table class="tablaLista" width="100%">
                                    <%
                                    listado = (List<Producto>)datosS.get("listado");
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="4" align="center">
                                                <span class="etiquetaB">
                                                    No hay Productos registrados
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="15%" colspan="2">
                                                    <span>Clave</span>
                                                </td>
                                                <td align="center" width="35%">
                                                    <span>Descripción</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Marca</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Categoría</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Subcategoría</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Tipo</span>
                                                </td>
                                                <td align="center" width="10%">
                                                    <span>Precio 1</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            for (int i=0; i < listado.size(); i++){
                                                Producto prod = listado.get(i);
                                        %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="5%">
                                                        <input id="radioPro" name="radioPro" type="radio" value="<%=prod.getId()%>"/>
                                                    </td>
                                                    <td align="left" width="10%">
                                                        <span>
                                                            <%=prod.getClave()%>
                                                        </span>
                                                    </td>
                                                    <td align="left" width="35%">
                                                        <span><%=prod.getDescripcion()%></span>
                                                    </td>
                                                    <td align="left" width="10%">
                                                        <span><%=prod.getMarca().getDescripcion()%></span>
                                                    </td>
                                                    <td align="left" width="10%">
                                                        <span><%=prod.getCategoria().getDescripcion()%></span>
                                                    </td>
                                                    <td align="left" width="10%">
                                                        <span><%=prod.getSubcategoria()!=null?prod.getSubcategoria().getDescripcion():""%></span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span><%if(prod.getTipo()==0){%>B&Aacute;SICO<%}else{%>A CAMBIO<%}%></span>
                                                    </td>
                                                    <td align="right" width="10%">
                                                        <span></span>
                                                    </td>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
                                    }
                                    %>
                                    </table><!--listado-->
                                    <!-- botones siguiente anterior-->
                                    <%
                                    int grupos = Integer.parseInt(datosS.get("grupos").toString());
                                    if (grupos == 1){
                                        int sigs = Integer.parseInt(datosS.get("siguientes").toString());
                                        int ants = Integer.parseInt(datosS.get("anteriores").toString());
                                    %>
                                    <hr>
                                    <table width="100%">
                                        <tr>
                                            <td width="30%">&nbsp;</td>
                                            <td width="10%" align="center">
                                                <style>#btnPrincipio a{display:block;color:transparent;} #btnPrincipio a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnPrincipio" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al principio del listado">
                                                            <a href="javascript: PrincipioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/principio.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnAnterior a{display:block;color:transparent;} #btnAnterior a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnAnterior" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Anteriores">
                                                            <a href="javascript: AnteriorClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/anterior.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnSiguiente a{display:block;color:transparent;} #btnSiguiente a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnSiguiente" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Siguientes">
                                                            <a href="javascript: SiguienteClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/siguiente.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10%" align="center">
                                                <style>#btnUltimo a{display:block;color:transparent;} #btnUltimo a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                <table id="btnUltimo" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Ir al final del listado">
                                                            <a href="javascript: FinalClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/final.png);width:70px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="30%">&nbsp;</td>
                                        </tr>
                                    </table>
                                    <%
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->                                    
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
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
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
                                    
                if (listado.size()==0){
                %>
                    var acciones = document.getElementById('acciones');
                    acciones.style.display = 'none';
                    var imprlista = document.getElementById('btnListaPrecios');
                    imprlista.style.display = 'none';
                <%
                }
                int fil = Integer.parseInt(datosS.get("filtro")!=null?datosS.get("filtro").toString():"0");
                if (listado.size()>0 && fil == 0){
                %>
                        var btnFiltrar = document.getElementById('btnFiltrar');
                        btnFiltrar.style.display = '';
                        var btnQuitar = document.getElementById('btnQuitar');
                        btnQuitar.style.display = 'none';
                <% } else if (fil==1){
                %>
                        var btnFiltrar = document.getElementById('btnFiltrar');
                        btnFiltrar.style.display = 'none';
                        var btnQuitar = document.getElementById('btnQuitar');
                        btnQuitar.style.display = '';
                <%
                }
                if (sinres.equals("1")){
                    datosS.remove("sinresultados");
                    sesion.setDatos(datosS);
                %>
                     MostrarMensaje('Los filtros establecidos no arrojaron resultados');
                <%
                }
                %>
            }
            
            function Activa(fila){
                var idPro = document.getElementById('idPro');
                var borrarEdit = document.getElementById('borrarEdit');
                borrarEdit.style.display = '';
                <%
                if (listado.size()==1){
                %>
                    document.frmGestionarProd.radioPro.checked = true;
                    idPro.value = document.frmGestionarProd.radioPro.value;
                <%
                } else {
                %>
                    var radio = document.frmGestionarProd.radioPro[fila];
                    radio.checked = true;
                    idPro.value = radio.value;
                <% } %>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function MostrarProductos(){
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '-1';
                frm.submit();                    
            }
            
            function NuevoClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/nuevoproducto.jsp';
                paso.value = '1';
                frm.submit();                
            }
            
            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/nuevoproducto.jsp';
                paso.value = '3';
                frm.submit();               
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '5';
                frm.submit();
            }
            
            function BajaClick(){
                var boton = document.getElementById('boton');
                boton.value = '1';                
                Confirmar('¿Está seguro en dar de baja el Producto seleccionado?');
                /*
                var resp = confirm('¿Está seguro en dar de baja el Producto seleccionado?','SISCAIM');
                if (resp){
                    var frm = document.getElementById('frmGestionarProd');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                    paso.value = '5';
                    frm.submit();
                }*/
            }
            
            function VerInactivos(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/productosinactivos.jsp';
                paso.value = '6';
                frm.submit();
            }
                        
            function FiltrarClick(){
                var dvfil = document.getElementById('filtros');
                dvfil.style.display = '';
                var btnFiltrar = document.getElementById('btnFiltrar');
                btnFiltrar.style.display = 'none';
                /*Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/filtrarproductos.jsp';
                paso.value = '8';
                frm.submit();*/                
            }
            
            function QuitarFiltroClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '10';
                frm.submit();                
            }
            
            function UnidadesClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/Unidades/gestionarunidadessalida.jsp';
                paso.value = '11';
                frm.submit();                
            }
            
            function KardexClick(){
                Espera();
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/kardexproducto.jsp';
                paso.value = '12';
                frm.submit();                
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarProd');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
            function Imprimir(){
                var suc = document.getElementById('sucursal');
                if (suc.value==''){
                    MostrarMensaje('Debe especificar la sucursal');
                    return;
                }
                var dat1 = document.getElementById('dato1');
                dat1.value = suc.value;
                var xls = document.getElementById('xls');
                if (xls.checked){
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmGestionarProd');
                    paso.value = '16';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Productos'+'&paso=15&dato1='+suc.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function ListaPrecios(){
                $( "#dialog-lista" ).dialog( "open" );
            }
            
            function CancelarFilClick(){
                var dvfil = document.getElementById('filtros');
                dvfil.style.display = 'none';
                var btnFiltrar = document.getElementById('btnFiltrar');
                btnFiltrar.style.display = '';                
            }
            
            function AplicarFilClick(){
                if (ValidaFiltros()){
                    Espera();
                    var frm = document.getElementById('frmGestionarProd');
                    frm.paginaSig.value = '/Inventario/Catalogos/Productos/gestionarproductos.jsp';
                    frm.pasoSig.value = '9';
                    frm.submit();                    
                }
            }
            
            function ValidaFiltros(){
                var descrip = document.getElementById('descripcion');
                var prov = document.getElementById('proveedor');
                var cat = document.getElementById('categoria');
                var marca = document.getElementById('marca');
                if (descrip.value == '' && prov.value == '' && cat.value == ''
                    && marca.value == ''){
                    MostrarMensaje('Debe establecer valor en al menos una de las opciones de filtro');
                    return false;
                }

                return true;
            }
            
        </script>
    </body>
</html>