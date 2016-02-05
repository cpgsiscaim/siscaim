<%@page import="Modelo.Entidades.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Empleado, Modelo.Entidades.Catalogos.TipoMedio,
        Modelo.Entidades.Medio, Modelo.Entidades.PersonaMedio"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    String titulo = "Nuevo Medio";
    String imagen = "mediosB.png";
    Empleado empl = (Empleado)datosS.get("empleado");
    PersonaMedio pmedio = new PersonaMedio();
    Medio medio = new Medio();
    medio.setTipo(new TipoMedio());
    String obs = "";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Medio";
        imagen = "editarMedio.png";
        pmedio = (PersonaMedio)datosS.get("pmedio");
        medio = pmedio.getMedio();
        obs = pmedio.getObservaciones();
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
                <td width="100%">
                    <div class="titulo" align="center">
                        Gestionar Personal - Medios<br>
                        EMPLEADO: <%=empl.getPersona().getNombreCompletoPorApellidos()%><br>
                        <%=titulo%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMed" name="frmNuevoMed" action="<%=CONTROLLER%>/Gestionar/MediosPersona" method="post">
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
                                    <td width="30%" align="center" valign="top">
                                        <!--aquí poner la imagen asociada con el proceso-->
                                        <img src="/siscaim/Imagenes/Medios/<%=imagen%>" align="center" width="300" height="250">
                                    </td>
                                    <td width="70%" valign="top">
                                        <table width="100%" cellpadding="5px">
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Tipo:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <select id="tipomedio" name="tipomedio" class="combo"
                                                            style="width: 300px" onchange="ActivaMedio(this.value)">
                                                        <option value="0">Elija el tipo de medio...</option>
                                                        <%
                                                        List<TipoMedio> tiposMed = (List<TipoMedio>) datosS.get("tiposmedios");
                                                        for (int i=0; i < tiposMed.size(); i++){
                                                            TipoMedio tipo = tiposMed.get(i);
                                                            %>
                                                            <option value="<%=tipo.getIdtipomedio()%>"
                                                                <%if (tipo.getIdtipomedio()==medio.getTipo().getIdtipomedio()){%>
                                                                selected<%}%>
                                                            >
                                                                <%=tipo.getTipomedio()%>
                                                            </option>
                                                            <%    
                                                            }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Medio:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="medio" name="medio" type="text" value="<%=medio.getMedio()!=null?medio.getMedio():""%>" 
                                                           style="width: 300px" onkeypress="return ValidaSegunTipo(event, this.value)" maxlength=""/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="leyenda" class="etiquetaC" style="display: none">
                                                        (10 dígitos)
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="etiqueta">Observación:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="observacion" name="observacion" type="text" value="<%=obs%>" 
                                                           style="width: 700px" maxlength="200"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <br>
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
                    Mensaje('<%=sesion.getMensaje()%>');
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

            function ValidaSegunTipo(e, cadena){
                var tipomedio = document.getElementById('tipomedio');
                var medio = document.getElementById('medio');
                if(tipomedio.value=='3'){
                    medio.maxLength = 50;
                    medio.title = '';
                    return ValidaMail(e, cadena);
                }
                else if (tipomedio.value=='1' || tipomedio.value=='2'){
                    medio.maxLength = 10;
                    medio.title = '10 dígitos';                    
                    return ValidaNums(e);
                }
                else
                    return false;
            }
            
            function ActivaMedio(tipo){
                var medio = document.getElementById('medio');
                var leyenda = document.getElementById('leyenda');
                if (tipo == 1 || tipo == 2)
                    leyenda.style.display = '';
                else
                    leyenda.style.display = 'none';
                medio.focus();
                medio.value = '';
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMed');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Medios/mediosempleado.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoMed');
                    frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Medios/mediosempleado.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '4';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '2';
                <%
                    }
                %>
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var tipom = document.getElementById('tipomedio');
                if (tipom.value == '0'){
                    Mensaje('Debe especificar el tipo de medio');
                    tipom.focus();
                    return false;
                }
                
                var medio = document.getElementById("medio");
                if (medio.value == ''){
                    Mensaje('Debe establecer el medio');
                    medio.focus();
                    return false;
                }
                
                if (tipom.value=='1' || tipom.value=='2'){
                    if (medio.value.length<10){
                        Mensaje('El número debe ser de 10 dígitos exactamente');
                        medio.focus();
                        return false;
                    }
                    
                    //validar que si sea numero
                    if (!ValidaNumsAfter(medio.value)){
                        Mensaje('El número del medio no es válido');
                        medio.focus();
                        return false;
                    }
                    
                }
                
                if (tipom.value == '3'){
                    if (!ValidaMailAfter(medio.value)){
                        Mensaje('El correo ingresado no es válido');
                        medio.focus();
                        return false;
                    }
                }
                
                return true;
            }
        </script>
    </body>
</html>