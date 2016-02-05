<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Plaza"%>
<%@page import="Modelo.Entidades.Nomina, Modelo.Entidades.Catalogos.TipoNomina, Modelo.Entidades.Catalogos.Quincena"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
//Sucursal sucusu = sesion.getUsuario().getEmpleado().getPersona().getSucursal();
HashMap datosS = sesion.getDatos();
Quincena quinsel = (Quincena)datosS.get("quincenasel");
String anio = datosS.get("aniosel").toString();
TipoNomina tiponom = (TipoNomina)datosS.get("tiponominasel");
List<CentroDeTrabajo> centros = (List<CentroDeTrabajo>)datosS.get("centros");
List<Plaza> plazas = (List<Plaza>)datosS.get("plazas");
List<Nomina> listado = (List<Nomina>)datosS.get("listado");
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
                        NÓMINA <%=tiponom.getDescripcion()%><br>
                        QUINCENA: <%=quinsel.getMes()%> - <%=quinsel.getNumero()%> / <%=anio%>
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
            <input id="idNom" name="idNom" type="hidden" value="1"/>
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
                                    <%
                                    if (listado.size()==0){
                                    %>
                                        <table class="tablaLista" width="100%">
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No se generaron registros de la Nómina definida
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    <%
                                    } else {
                                        //para cada centro de trabajo
                                        for (int ct=0; ct < centros.size(); ct++){
                                            CentroDeTrabajo ctrab = centros.get(ct);
                                        %>
                                            <table width="100%">
                                                <tr>
                                                    <td width="100%" align="left">
                                                        <span class="titulo">
                                                            C.T.: <%=ctrab.getNombre()%>
                                                        </span><br>
                                                        <span class="subtitulo">
                                                            CLIENTE: <%=ctrab.getCliente().getTipo()==0?ctrab.getCliente().getDatosFiscales().getRazonsocial():ctrab.getCliente().getDatosFiscales().getPersona().getNombreCompleto()%>
                                                        </span><br>
                                                        <span class="subtitulo">
                                                            CONTRATO: <%=ctrab.getContrato().getDescripcion()%>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>
                                            <hr>
                                        <%
                                            //imprimir las plazas del ct actual
                                            for (int pz=0; pz < plazas.size(); pz++){
                                                Plaza plz = plazas.get(pz);
                                                if (plz.getCtrabajo().getId()==ctrab.getId()){
                                                    float totalp = 0, totald = 0, neto = 0;                                                    
                                            %>
                                                    <table width="90%" align="right">
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="subtitulo">
                                                                    EMPLEADO: <%=plz.getEmpleado().getPersona().getNombreCompleto()%>
                                                                </span><br>
                                                                <span class="subtitulo">
                                                                    PUESTO: <%=plz.getPuesto().getDescripcion()%>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br>
                                                    <table class="tablaLista" width="80%" align="right">
                                                        <thead>
                                                            <tr>
                                                                <td align="center" width="40%">
                                                                    <span>Percepciones</span>
                                                                </td>
                                                                <td align="center" width="40%">
                                                                    <span>Deducciones</span>
                                                                </td>
                                                                <td align="center" width="20%">
                                                                    <span>Neto</span>
                                                                </td>
                                                            </tr>
                                                        </thead>
                                                    </table>
                                                    <table width="80%" align="right">
                                                        <tr>
                                                            <td align="center" width="40%" valign="top">
                                                                <!--percepciones-->
                                                                <table class="tablaLista" width="100%">
                                                                    <tbody>
                                                                    <%
                                                                    for (int d=0; d < listado.size(); d++){
                                                                        Nomina dnom = listado.get(d);
                                                                        if (dnom.getPlaza().getId()==plz.getId()
                                                                                && dnom.getMovimiento().getPeroDed()==1){
                                                                            totalp+=dnom.getMonto();
                                                                        %>
                                                                        <tr>
                                                                            <td width="5%" align="center">
                                                                                <input id="radioDet" name="radioDet" type="radio"/>
                                                                            </td>
                                                                            <td width="55%" align="left">
                                                                                <span class="etiqueta">
                                                                                    <%=dnom.getMovimiento().getDescripcion()%>
                                                                                </span>
                                                                            </td>
                                                                            <td width="40%" align="right">
                                                                                <span class="etiqueta">
                                                                                    <%=dnom.getMonto()%>
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                        <%
                                                                        }
                                                                    }//for detalle nom percepciones
                                                                    %>
                                                                    </tbody>
                                                                </table>
                                                                <table width="100%" class="tablaSubtotal"
                                                                       style="background:#61B16A; border:1px solid gray; border-collapse:collapse; color:#fff; font:bold 12px verdana, arial, helvetica, sans-serif;">
                                                                    <tr>
                                                                        <td width="60%" align="right">
                                                                            <span>
                                                                                Total Percepciones:
                                                                            </span>
                                                                        </td>
                                                                        <td width="40%" align="right">
                                                                            <span>
                                                                                <%=totalp%>
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td align="center" width="40%" valign="top">
                                                                <!--deducciones-->
                                                                <table class="tablaLista" width="100%">
                                                                    <tbody>
                                                                    <%
                                                                    for (int d=0; d < listado.size(); d++){
                                                                        Nomina dnom = listado.get(d);
                                                                        if (dnom.getPlaza().getId()==plz.getId()
                                                                                && dnom.getMovimiento().getPeroDed()==2){
                                                                            totald+=dnom.getMonto();
                                                                        %>
                                                                        <tr>
                                                                            <td width="5%" align="center">
                                                                                <input id="radioDet" name="radioDet" type="radio"/>
                                                                            </td>
                                                                            <td width="55%" align="left">
                                                                                <span class="etiqueta">
                                                                                    <%=dnom.getMovimiento().getDescripcion()%>
                                                                                </span>
                                                                            </td>
                                                                            <td width="40%" align="right">
                                                                                <span class="etiqueta">
                                                                                    <%=dnom.getMonto()%>
                                                                                </span>
                                                                            </td>
                                                                        </tr>
                                                                        <%
                                                                        }
                                                                    }//for detalle nom deducciones
                                                                    %>
                                                                    </tbody>
                                                                </table>
                                                                <table width="100%" class="tablaSubtotal" 
                                                                       style="background:#61B16A; border:1px solid gray; border-collapse:collapse; color:#fff; font:bold 12px verdana, arial, helvetica, sans-serif;">
                                                                    <tr>
                                                                        <td width="60%" align="right">
                                                                            <span>
                                                                                Total Deducciones:
                                                                            </span>
                                                                        </td>
                                                                        <td width="40%" align="right">
                                                                            <span>
                                                                                <%=totald%>
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td align="center" width="20%" valign="top">
                                                                <!--neto-->
                                                                <span class="titulo">
                                                                    <%=totalp-totald%>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                            <%                                                    
                                                }//if ct de plaza actual = ctrab actual
                                            }//for pz
                                        }//for ct
                                    %>
                                    <%
                                    }//if listado=0
                                    %>
                                    <!--fin listado-->
                                </td><!--fin del contenido-->
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

<%--
        for (int c=0; c < centros.size(); c++){
            CentroDeTrabajo ct = centros.get(c);
    %>
            <table width="100%">
                <tr>
                    <td width="100%" align="center">
                        <span class="etiquetaB">C.T. <%=ct.getNombre()%></span>
                    </td>
                </tr>
            </table>
    <%
            for (int i=0; i < listado.size(); i++){
                Nomina nom = listado.get(i);
                if (nom.getPlaza().getCtrabajo().getId()==ct.getId()){
            %>
                    <table width="100%">
                        <tr>
                            <td width="50%" align="left">
                                <span class="etiquetaB">
                                    EMPLEADO: <%=nom.getPlaza().getEmpleado().getPersona().getNombreCompleto()%>
                                </span>
                            </td>
                            <td width="50%" align="left">
                                <span class="etiquetaB">
                                    PUESTO: <%=nom.getPlaza().getPuesto().getDescripcion()%>
                                </span>
                            </td>
                        </tr>
                    </table>
                    <table width="80%" align="center">
                        <tr>
                            <td width="50%">
                                <!--percepciones-->
                                <table class="tablaLista" width="100%" align="center">
                                    <thead>
                                        <tr>
                                            <td align="center" width="100%" colspan="3">
                                                <span>Percepciones</span>
                                            </td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                <%
                                float totalpercep = 0;
                                for (int p=0; p < listado.size(); p++){
                                    Nomina per = listado.get(p);
                                    if (per.getPlaza().getCtrabajo().getId()==ct.getId()
                                            && per.getPlaza().getEmpleado()==nom.getPlaza().getEmpleado()
                                            && per.getMovimiento().getPeroDed()==1){
                                        totalpercep += per.getMonto();
                                    %>
                                        <tr onclick="Activa(<%=p%>)">
                                            <td align="center" width="5%">
                                                <input id="radioNom" name="radioNom" type="radio" value="<%=per.getId()%>"/>
                                            </td>
                                            <td align="left" width="50%">
                                                <span class="etiqueta"><%=per.getMovimiento().getDescripcion()%></span>
                                            </td>
                                            <td align="right" width="45%">
                                                <span class="etiqueta"><%=per.getMonto()%></span>
                                            </td>
                                        </tr>
                                    <%
                                    }
                                }
                                %>
                                    </tbody>
                                </table>
                                <table width="100%" align="center">
                                    <tr>
                                        <td width="55%" align="right">
                                            <span class="etiquetaB">Total Percepciones: </span>
                                        </td>
                                        <td width="45%" align="right">
                                            <span class="etiquetaB"><%=totalpercep%></span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="50%">
                                <!--deducciones-->
                                <table class="tablaLista" width="100%" align="center">
                                    <thead>
                                        <tr>
                                            <td align="center" width="100%" colspan="3">
                                                <span>Deducciones</span>
                                            </td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                <%
                                float totalded = 0;
                                for (int d=0; d < listado.size(); d++){
                                    Nomina ded = listado.get(d);
                                    if (ded.getPlaza().getCtrabajo().getId()==ct.getId()
                                            && ded.getPlaza().getEmpleado()==nom.getPlaza().getEmpleado()
                                            && ded.getMovimiento().getPeroDed()==2){
                                        totalded += ded.getMonto();
                                    %>
                                        <tr onclick="Activa(<%=d%>)">
                                            <td align="center" width="5%">
                                                <input id="radioNom" name="radioNom" type="radio" value="<%=ded.getId()%>"/>
                                            </td>
                                            <td align="left" width="50%">
                                                <span class="etiqueta"><%=ded.getMovimiento().getDescripcion()%></span>
                                            </td>
                                            <td align="right" width="45%">
                                                <span class="etiqueta"><%=ded.getMonto()%></span>
                                            </td>
                                        </tr>
                                    <%
                                    }
                                }
                                %>
                                    </tbody>
                                </table>
                                <table width="100%" align="center">
                                    <tr>
                                        <td width="55%" align="right">
                                            <span class="etiquetaB">Total Deducciones: </span>
                                        </td>
                                        <td width="45%" align="right">
                                            <span class="etiquetaB"><%=totalded%></span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
            <%
                }//if ct actual = ct nomina
            }//for listado
    %>
    <%
    }//for centros
--%>