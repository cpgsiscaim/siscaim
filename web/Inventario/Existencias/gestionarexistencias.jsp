<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.text.DecimalFormat, java.lang.Math, java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Almacen, Modelo.Entidades.Existencia, Modelo.Entidades.UnidadProducto"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
List<Existencia> listado = new ArrayList<Existencia>();
List<UnidadProducto> empaques = new ArrayList<UnidadProducto>();
Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
String matriz = datosS.get("matriz").toString();
Almacen almSel = new Almacen();
List<Almacen> almacenes = (List<Almacen>)datosS.get("almacenes");
if (paso > 1 || almacenes.size()==1){
    almSel = (Almacen)datosS.get("almacenSel");
    listado = datosS.get("listado")!=null?(List<Existencia>)datosS.get("listado"):new ArrayList<Existencia>();
    empaques = datosS.get("empaques")!=null?(List<UnidadProducto>)datosS.get("empaques"):new ArrayList<UnidadProducto>();
}
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
                <td width="20%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/inventarioA.png" align="center" width="180" height="100">
                </td>
                <td width="80%">
                    <div class="bigtitulo" align="center">
                        EXISTENCIAS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarExtis" name="frmGestionarExtis" action="<%=CONTROLLER%>/Gestionar/Existencias" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table width="100%">
                                        <tr>
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
                                            <td width="45%" align="left">
                                                <style>#btnImprimir a{display:block;color:transparent;} #btnImprimir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnImprimir" width=0 cellpadding=0 cellspacing=0 border=0 style="display: none">
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Imprimir">
                                                            <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <input id="xls" name="xls" type="checkbox">
                                                            <span class="etiqueta">Imprimir en formato de Excel</span>
                                                        </td>
                                                    </tr>
                                                </table>                                                    
                                            </td>
                                            <td width="20%" align="right">
                                                <select id="sucursal" name="sucursal" class="combo" style="width: 250px"
                                                        onchange="ObtenerAlmacenes()" <%if (matriz.equals("0")){%>disabled<%}%>>
                                                    <option value="">Elija la Sucursal...</option>
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
                                            </td>
                                            <td width="20%" align="right">
                                                <select id="almacen" name="almacen" class="combo" style="width: 200px"
                                                        onchange="MostrarExistencias()">
                                                    <option value="">Elija el Almacén...</option>
                                                <%
                                                    for (int i=0; i < almacenes.size(); i++){
                                                        Almacen alm = almacenes.get(i);
                                                    %>
                                                    <option value="<%=alm.getId()%>"
                                                            <% if (alm.getId()==almSel.getId()){%> selected <% } %>>
                                                        <%=alm.getDescripcion()%>
                                                    </option>
                                                    <%
                                                    }
                                                %>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <div id="divlis">
                                    <table id="listado" class="tablaLista" width="90%" align="center">
                                    <%
                                    if ((paso > 1 && sucSel.getId()!=0) || almacenes.size()==1){
                                    if (listado.size()==0){
                                    %>
                                        <tr>
                                            <td colspan="3" align="center">
                                                <span class="etiquetaB">
                                                    No hay Existencias registradas con la Sucursal y el Almacen seleccionados 
                                                </span>
                                            </td>
                                        </tr>
                                    <%
                                    } else {
                                    %>
                                        <thead>
                                            <tr>
                                                <td align="center" width="55%" colspan="2">
                                                    <span>Producto</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Empaques</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Sueltos</span>
                                                </td>
                                                <td align="center" width="15%">
                                                    <span>Total</span>
                                                </td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%    
                                            DecimalFormat format = new DecimalFormat("#,##0.00");
                                            for (int i=0; i < listado.size(); i++){
                                                Existencia exis = listado.get(i);
                                                UnidadProducto up = empaques.get(i);
                                                int emp = new Float(exis.getExistencia()/up.getValor()).intValue();
                                                float sueltos = exis.getExistencia()%up.getValor();
                                        %>
                                        <tr <%if (exis.getExistencia()<=0){%> bgcolor="#F78181"<%}%>>
                                                    <td align="center" width="10%">
                                                        <%=exis.getProducto().getClave()%>
                                                    </td>
                                                    <td align="left" width="45%">
                                                        <%=exis.getProducto().getDescripcion()%>
                                                    </td>
                                                    <td align="right" width="15%">
                                                        <%=emp%> (<%=up.getUnidad().getClave()%>)
                                                    </td>
                                                    <td align="right" width="15%">
                                                        <%=format.format(sueltos)%> (<%=exis.getProducto().getUnidad().getClave()%>)
                                                    </td>
                                                    <td align="right" width="15%">
                                                        <%=format.format(exis.getExistencia())%>
                                                    </td>
                                                </tr>
                                        <%
                                            }
                                        %>
                                        </tbody>
                                    <%    
                                    }
                                    }
                                    %>
                                    </table>
                                    <!-- botones siguiente anterior-->
                                    <% if (listado.size()!=0){
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
                                    }
                                    %>
                                    <!--fin botones siguiente anterior-->
                                    </div>
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
                if (listado.size() > 0){
                %>
                    var impr = document.getElementById('btnImprimir');
                    impr.style.display = '';
                <%
                }
                %>
            }
                        
            function SalirClick(){
                var frm = document.getElementById('frmGestionarExtis');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function ObtenerAlmacenes(){
                var suc = document.getElementById('sucursal');
                var alm = document.getElementById('almacen');
                alm.length = 0;
                alm.options[0] = new Option('Elija el Almacén...', '');
                if (suc.value != ''){
                    var frm = document.getElementById('frmGestionarExtis');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                    paso.value = '1';
                    frm.submit();
                } //else {
                    var divlis = document.getElementById("divlis");
                    divlis.style.display = 'none';
                    var impr = document.getElementById('btnImprimir');
                    impr.style.display = 'none';
                //}
            }
            
            function MostrarExistencias(){
                var suc = document.getElementById('sucursal');
                var alm = document.getElementById('almacen');
                if (suc.value != '' && alm.value != ''){
                    var frm = document.getElementById('frmGestionarExtis');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                    paso.value = '2';
                    frm.submit();
                } else {
                    var divlis = document.getElementById("divlis");
                    divlis.style.display = 'none';
                    var impr = document.getElementById('btnImprimir');
                    impr.style.display = 'none';
                }
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmGestionarExtis');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                paso.value = '52';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmGestionarExtis');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                paso.value = '51';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmGestionarExtis');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                paso.value = '50';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmGestionarExtis');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                paso.value = '53';
                frm.submit();                
            }
            
            function ImprimirClick(){
                var xls = document.getElementById('xls');
                banxls = 0;
                if (!xls.checked){
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Existencias'+'&paso=3&dato1='+banxls,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                } else {
                    banxls = 1;
                    var frm = document.getElementById('frmGestionarExtis');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    var dato1 = document.getElementById('dato1');
                    pagina.value = '/Inventario/Existencias/gestionarexistencias.jsp';
                    paso.value = '3';
                    dato1.value = banxls;
                    frm.submit();                
                }
                
            }
        </script>
    </body>
</html>