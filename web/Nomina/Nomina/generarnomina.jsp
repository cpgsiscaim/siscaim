<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.Catalogos.TipoNomina, Modelo.Entidades.Catalogos.Quincena"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
Quincena quinsel = (Quincena)datosS.get("quincenasel");
String anio = datosS.get("aniosel").toString();
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
                        Gestionar Nóminas - Generar
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarGen" name="frmGestionarGen" action="<%=CONTROLLER%>/Gestionar/Nominas" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="opcGen" name="opcGen" type="hidden" value="1"/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table>
                            <tr>
                                <td width="20%" align="center" valign="top">
                                    <!--aquí poner la imagen asociada con el proceso-->
                                    <img src="/siscaim/Imagenes/Catalogos/Nomina.jpg" align="center" width="300" height="250">
                                </td>
                                <td width="80%" valign="top">
                                    <table width="100%" align="center">
                                        <tr>
                                            <td width="35%" align="right">
                                                <span class="etiquetaB">Quincena: </span>
                                                <select id="quincena" name="quincena" class="combo" style="width: 250px">
                                                    <option value="">Elija la Quincena...</option>
                                                <%
                                                    List<Quincena> quincenas = (List<Quincena>)datosS.get("quincenas");
                                                    for (int i=0; i < quincenas.size(); i++){
                                                        Quincena quin = quincenas.get(i);
                                                    %>
                                                        <option value="<%=quin.getId()%>"
                                                            <%
                                                            if (quinsel.getId()==quin.getId()){
                                                            %>
                                                                selected
                                                            <%
                                                            }
                                                            %>
                                                            >
                                                            <%=quin.getMes()%> - <%=quin.getNumero()%>
                                                        </option>
                                                    <%
                                                    }
                                                %>
                                                </select>                                                
                                            </td>
                                            <td width="25%" align="center">
                                                <span class="etiquetaB">Año: </span>
                                                <input id="anio" name="anio" type="text" style="width: 50px; text-align: center" value="<%=anio%>"
                                                        maxlength="4" onkeypress="return ValidaNums(event)">
                                            </td>
                                            <td width="40%" align="left">
                                                <span class="etiquetaB">Tipo de Nómina: </span>
                                                <select id="tiponomina" name="tiponomina" class="combo" style="width: 250px">
                                                    <option value="">Elija el Tipo de Nómina...</option>
                                                <%
                                                    List<TipoNomina> tiposnominas = (List<TipoNomina>)datosS.get("tiposnominas");
                                                    for (int i=0; i < tiposnominas.size(); i++){
                                                        TipoNomina tiponom = tiposnominas.get(i);
                                                    %>
                                                        <option value="<%=tiponom.getIdTnomina()%>">
                                                            <%=tiponom.getDescripcion()%>
                                                        </option>
                                                    <%
                                                    }
                                                %>
                                                </select>                                                
                                            </td>
                                        </tr>
                                    </table><!-- fin tabla quincena y año -->
                                    <br>
                                    <table width="100%" align="center">
                                        <tr>
                                            <td width="33%" align="right">
                                                <input id="radioGen" name="radioGen" type="radio" value="1" onclick="OpcionGenerar(1)" checked/>
                                                <span class="etiquetaB">General</span>
                                            </td>
                                            <td width="34%" align="center">
                                                <input id="radioGen" name="radioGen" type="radio" value="2" onclick="OpcionGenerar(2)"/>
                                                <span class="etiquetaB">Por C.T.</span>
                                            </td>
                                            <td width="33%" align="left">
                                                <input id="radioGen" name="radioGen" type="radio" value="3" onclick="OpcionGenerar(3)"/>
                                                <span class="etiquetaB">Por Empleado</span>
                                            </td>
                                        </tr>
                                    </table>
                                    <br><br>
                                    <table width="100%" align="center">
                                        <tr>
                                            <td width="50%" align="right">
                                                <style>#btnGenerar a{display:block;color:transparent;} #btnGenerar a:hover{background-position:left bottom;}a#btnInactivosa {display:none}</style>
                                                <table id="btnGenerar" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Generar Nómina">
                                                            <a href="javascript: GenerarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/generar.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="50%" align="left">
                                                <style>#btnSalir a{display:block;color:transparent;} #btnSalir a:hover{background-position:left bottom;}a#btnSalira {display:none}</style>
                                                <table id="btnSalir" width=0 cellpadding=0 cellspacing=0 border=0>
                                                    <tr>
                                                        <td style="padding-right:0px" title ="Salir">
                                                            <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td><!--fin del contenido-->
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
            
            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
            }
            
            function OpcionGenerar(og){
                var opc = document.getElementById('opcGen');
                opc.value = og;
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarGen');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '99';
                frm.submit();                
            }
            
            function ValidaRequeridos(){
                var quin = document.getElementById('quincena');
                if (quin.value == ''){
                    Mensaje('La Quincena no ha sido establecida');
                    quin.focus();
                    return false;
                }
                
                var anio = document.getElementById('anio');
                if (anio.value == ''){
                    Mensaje('El Año está vacío');
                    anio.focus();
                    return false;
                }
                
                var tiponom = document.getElementById('tiponomina');
                if (tiponom.value == ''){
                    Mensaje('El Tipo de Nómina no ha sido establecido');
                    tiponom.focus();
                    return false;
                }
                
                return true;
            }
            
            function GenerarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmGestionarGen');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    var opc = document.getElementById('opcGen');
                    if (opc.value == '1')
                        pagina.value = '/Nomina/Nomina/nominageneral.jsp';
                    else if (opc.value == '2')
                        pagina.value = '/Nomina/Nomina/nominaxct.jsp';
                    else
                        pagina.value = '/Nomina/Nomina/nominaxempleado.jsp';
                    paso.value = '1';
                    frm.submit();
                }
            }
            
        </script>
    </body>
</html>
