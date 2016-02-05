<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, Modelo.Entidades.Cabecera, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    String paganterior = sesion.getPaginaAnterior()!=null?sesion.getPaginaAnterior():"";
    Cabecera cab = (Cabecera)datosS.get("cabecera");
    //int paso = Integer.parseInt(datosS.get("paso").toString());
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
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/formatosempA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS
                    </div>
                    <div class="titulo" align="left">
                        IMPRIMIR MOVIMIENTO
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmImprimirMov" name="frmImprimirMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="dato1" name="dato1" type="hidden" value=""/>
            <input id="dato2" name="dato2" type="hidden" value=""/>
            <input id="dato3" name="dato3" type="hidden" value=""/>
            <input id="dato4" name="dato4" type="hidden" value=""/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="70%" align="center">
                                <tr>
                                    <td width="100%" valign="top">
                                        <table width="100%">
                                            <tr>
                                                <td width="20%" align="right">
                                                    <span class="etiqueta">MOVIMIENTO:</span>
                                                </td>
                                                <td width="80%" align="left">
                                                    <span class="etiquetaB"><%=cab.getTipomov().getDescripcion()%></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="right">
                                                    <span class="etiqueta">FOLIO:</span>
                                                </td>
                                                <td width="80%" align="left">
                                                    <span class="etiquetaB"><%=cab.getSerie().getSerie()%> - <%=cab.getFolio()%></span>
                                                </td>
                                            </tr>
                                        </table>
                                        <table width="100%">
                                            <tr>
                                                <td width="20%" align="right">
                                                    <span class="etiqueta">OBSERVACIÓN 1:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <input id="obs1" name="obs1" class="text" type="text" value="" style="width: 450px" maxlength="100"
                                                           onblur="Mayusculas(this)"/>
                                                </td>
                                                <td width="15%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="right">
                                                    <span class="etiqueta">OBSERVACIÓN 2:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <input id="obs2" name="obs2" class="text" type="text" value="" style="width: 450px" maxlength="100"
                                                           onblur="Mayusculas(this)"/>
                                                </td>
                                                <td width="15%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td width="20%" align="right">
                                                    <span class="etiqueta">OBSERVACIÓN 3:</span>
                                                </td>
                                                <td width="65%" align="left">
                                                    <input id="obs3" name="obs3" class="text" type="text" value="" style="width: 450px" maxlength="100"
                                                           onblur="Mayusculas(this)"/>
                                                </td>
                                                <td width="15%">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td width="20%">&nbsp;</td>
                                                <td width="80%" align="left" colspan="2">
                                                    <input id="xls" name="xls" type="checkbox">
                                                    <span class="etiqueta">Imprimir en formato de Excel</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="70%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                            <tr>
                                                <td style="padding-right:0px" title ="Imprimir">
                                                    <a href="javascript: ImprimirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/imprimir.png);width:150px;height:30px;display:block;"><br/></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="30%">
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
                var obs1 = document.getElementById('obs1');
                obs1.focus();
            }
            
            function ImprimirClick(){
                var xls = document.getElementById('xls');
                var obs1 = document.getElementById('obs1');
                var obs2 = document.getElementById('obs2');
                var obs3 = document.getElementById('obs3');
                if (xls.checked){
                    var dat1 = document.getElementById('dato1');
                    var dat2 = document.getElementById('dato2');
                    var dat3 = document.getElementById('dato3');
                    var dat4 = document.getElementById('dato4');
                    var paso = document.getElementById('pasoSig');
                    var frm = document.getElementById('frmImprimirMov');
                    dat1.value = '<%=cab.getId()%>';
                    dat2.value = obs1.value;
                    dat3.value = obs2.value;
                    dat4.value = obs3.value;
                    paso.value = '31';
                    frm.submit();
                } else {
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Movimientos'+'&paso=27&dato1='+<%=cab.getId()%>+
                            '&dato2='+obs1.value+'&dato3='+obs2.value+'&dato4='+obs3.value,
                            '','width =800, height=600, left=0, top = 0, resizable= yes');
                }
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmImprimirMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                <%if (paganterior!=null && !paganterior.equals("")){%>
                     frm.paginaSig.value = '<%=paganterior%>';
                <%}%>
                frm.pasoSig.value = '89';
                frm.submit();
            }
        </script>
    </body>
</html>

