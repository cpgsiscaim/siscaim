<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    String titulo = "Nuevo Movimiento";
    String imagen = "inventarioB.png";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Movimiento";
        imagen = "inventarioC.png";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>

        <title></title>
    </head>
    <body onload="CargaPagina()">
        <table width="100%">
            <tr>
                <td width="100%" colspan="2">
                    <div class="titulo" align="center">
                        Gestionar Movimientos - <%=titulo%>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="50%" align="rigth">
                    <div class="titulo" align="center">
                        Sucursal: <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
                <td width="50%" align="left">
                    <div class="titulo" align="center">
                        Tipo de Movimiento: <%=tmovSel.getDescripcion()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMov" name="frmNuevoMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
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
                                        <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <div class="cajamenu2">
                                            <ul id="pest">
                                                <%
                                                String pestaña = (String)datosS.get("pestaña")!=null?(String)datosS.get("pestaña"):"1";
                                                %>
                                                <li><a id="pest1" href="javascript: ClickPestana(1,2)" class="<%if (pestaña.equals("1")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Cabecera</span></a>
                                                </li>
                                                <li><a id="pest2" href="javascript: ClickPestana(2,2)" class="<%if (pestaña.equals("2")){%>activo<%}else{%>inactivo<%}%>">
                                                        <span>Detalle</span></a>
                                                </li>
                                            </ul>
                                        </div>
                                        <div id="cajahoja2">
                                            <div style="height: 20px"></div>
                                            <div id="pest1cont" style="display: <%if (pestaña.equals("1")){%>''<%}else{%>none<%}%>" align="center">
                                                <%--@include file="pestdatosgenprov.jsp"--%>
                                            </div>
                                            <div id="pest2cont" style="display: <%if (pestaña.equals("2")){%>''<%}else{%>none<%}%>">
                                                <%--@include file="pestotrosprov.jsp" --%>
                                            </div>                                
                                        </div><!--cajahoja2-->
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
                                                <td style="padding-right:0px" title ="Guardar">
                                                    <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
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
                %>
            }

            function PonerInactivo(total){
                for (i=1; i<=total; i++){
                    var pest = document.getElementById('pest'+i);
                    if (pest.className=='activo'){
                        pest.className='inactivo';
                        var cont = document.getElementById('pest'+i+'cont');
                        cont.style.display = 'none';
                    }
                }
            }
        
            function ClickPestana(numpest, total){
                PonerInactivo(total);                
                var pest = document.getElementById('pest'+numpest);
                pest.className = 'activo';
                var cont = document.getElementById('pest'+numpest+'cont');
                cont.style.display = '';
                if (numpest==1){
                    var razonProv = document.getElementById('razonProv');
                    razonProv.focus();                    
                } else {
                    var banco = document.getElementById('banco');
                    banco.focus();                    
                }
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoPro');
                    frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/gestionarproveedores.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '5';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '3';
                <%
                    }
                %>
                }
                frm.submit();
            }
            
            function ValidaRequeridos(){
                if (ValidaDatosGenerales())
                    if (ValidaOtros())
                        return true;

                return false;
            }
        
            function ValidaDatosGenerales(){
                //var tipoCli[] = document.getElementById('rdTipoCli');
                
                if (document.frmNuevoPro.rdTipoPro[0].checked){
                    var razonProv = document.getElementById('razonProv');
                    if (razonProv.value == ''){
                        Mensaje('El campo Razón Social del Proveedor está vacío');
                        ClickPestana(1,2);
                        razonProv.focus();
                        return false;
                    }
                    
                    var rfcPro = document.getElementById('rfcPro');
                    if (rfcPro.value == ''){
                        Mensaje('El campo RFC del Proveedore está vacío');
                        ClickPestana(1,2);
                        rfcPro.focus();
                        return false;
                    }
                    
                    var nombreRep = document.getElementById('nombreRepr');
                    if (nombreRep.value == ''){
                        Mensaje('El campo Nombre del Representante está vacío');
                        ClickPestana(1,2);
                        nombreRep.focus();
                        return false;
                    }

                    var paternoRep = document.getElementById('paternoRepr');
                    if (paternoRep.value == ''){
                        Mensaje('El campo Ap. Paterno del Representante está vacío');
                        ClickPestana(1,2);
                        paternoRep.focus();
                        return false;
                    }

                    var maternoRep = document.getElementById('maternoRepr');
                    if (maternoRep.value == ''){
                        Mensaje('El campo Ap. Materno del Representante está vacío');
                        ClickPestana(1,2);
                        maternoRep.focus();
                        return false;
                    }
                }
                else {
                    var rfcPro = document.getElementById('rfcProFis');
                    if (rfcPro.value == ''){
                        Mensaje('El campo RFC del Proveedor está vacío');
                        ClickPestana(1,2);
                        rfcPro.focus();
                        return false;
                    }

                    var nombreRep = document.getElementById('nombreReprFis');
                    if (nombreRep.value == ''){
                        Mensaje('El campo Nombre del Representante está vacío');
                        ClickPestana(1,2);
                        nombreRep.focus();
                        return false;
                    }

                    var paternoRep = document.getElementById('paternoReprFis');
                    if (paternoRep.value == ''){
                        Mensaje('El campo Ap. Paterno del Representante está vacío');
                        ClickPestana(1,2);
                        paternoRep.focus();
                        return false;
                    }

                    var maternoRep = document.getElementById('maternoReprFis');
                    if (maternoRep.value == ''){
                        Mensaje('El campo Ap. Materno del Representante está vacío');
                        ClickPestana(1,2);
                        maternoRep.focus();
                        return false;
                    }

                }
                
        
                var callePro = document.getElementById('callePro');
                if (callePro.value == ''){
                    Mensaje('El campo Calle y Número del Proveedor está vacío');
                    ClickPestana(1,2);
                    callePro.focus();
                    return false;
                }
                
                var colPro = document.getElementById('coloniaPro');
                if (colPro.value == ''){
                    Mensaje('El campo Colonia del Proveedor está vacío');
                    ClickPestana(1,2);
                    colPro.focus();
                    return false;
                }
                
                var edoPro = document.getElementById('estadoPro');
                if (edoPro.value == '0'){
                    Mensaje('El campo Estado del Cliente no ha sido establecido');
                    ClickPestana(1,2);
                    edoPro.focus();
                    return false;
                }
                
                var pobPro = document.getElementById('poblacionPro');
                if (pobPro.value == '0'){
                    Mensaje('El campo Población del Proveedor no ha sido establecido');
                    ClickPestana(1,2);
                    pobPro.focus();
                    return false;
                }
                                
                return true;
            }
            
            function ValidaOtros(){
                /*var agente = document.getElementById('agente');
                if (agente.value=='0'){
                    Mensaje('El campo Agente no ha sido establecido');
                    ClickPestana(2,2);
                    agente.focus();
                    return false;
                }
                
                var ruta = document.getElementById('ruta');
                if (ruta.value=='0'){
                    Mensaje('El campo Ruta no ha sido establecido');
                    ClickPestana(2,2);
                    ruta.focus();
                    return false;
                }
                
                var fech = document.getElementById('fechaAlta');
                if (fech.value==''){
                    Mensaje('El campo Fecha Alta no ha sido establecida');
                    ClickPestana(2,2);
                    fech.focus();
                    return false;
                }
                
                var desc1 = document.getElementById('descto1');
                if (desc1.value==''){
                    Mensaje('El campo Descuento 1 está vacío');
                    ClickPestana(2,2);
                    desc1.focus();
                    return false;
                }
                
                var desc2 = document.getElementById('descto2');
                if (desc2.value==''){
                    Mensaje('El campo Descuento 2 está vacío');
                    ClickPestana(2,2);
                    desc2.focus();
                    return false;
                }
                
                var desc3 = document.getElementById('descto3');
                if (desc3.value==''){
                    Mensaje('El campo Descuento 3 está vacío');
                    ClickPestana(2,2);
                    desc3.focus();
                    return false;
                }
                                
                var plazo = document.getElementById('plazo');
                if (plazo.value==''){
                    Mensaje('El campo Plazo del Crédito está vacío');
                    ClickPestana(2,2);
                    plazo.focus();
                    return false;
                }
                */
                return true;
            }

        </script>
    </body>
</html>