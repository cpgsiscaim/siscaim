<%-- 
    Document   : genera contrato trabajo
    Created on : Ago 18, 2015, 09:46:00 AM
    Author     : temoc
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%-- aqui poner los imports--%>
<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, Modelo.Entidades.Persona, Modelo.Entidades.Empleado, Modelo.Entidades.Sucursal"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat, java.util.Date, Modelo.Entidades.ContratoTrabajo"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
    HashMap datosS = sesion.getDatos();
    // List<Cliente> listado = new ArrayList<Cliente>();//(List<Cliente>)datosS.get("listado");
    Sucursal sucSel = (Sucursal)datosS.get("sucursal");
    SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
    NumberFormat fnum = new DecimalFormat("#,##0.00");
    Empleado empl = (Empleado)datosS.get("empleado");
    int nuevo = Integer.parseInt(datosS.get("nuevo").toString());
    int jornada = 8;
    String hrentrada = "09:00", hrsalida = "17:00", inisem = "LUNES", finsem = "SABADO", diasdescanso = "DOMINGO";
    if (nuevo==0){
        ContratoTrabajo contrab = (ContratoTrabajo)datosS.get("contratotrabajo");
        jornada = contrab.getJornada().intValue();
        hrentrada = contrab.getEntrada();
        hrsalida = contrab.getSalida();
        inisem = contrab.getDiainicio();
        finsem = contrab.getDiafin();
        diasdescanso = contrab.getDiasdescanso();
    }
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
        
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnGenerar" ).button({
                icons: {
                    primary: "ui-icon-arrowreturnthick-1-w"
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
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/empleadosD.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR PERSONAL
                    </div>
                    <div class="titulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <div class="subtitulo" align="left">
                        CONTRATO INDIVIDUAL DE TRABAJO
                    </div>
                    <div class="subtitulo" align="left">
                        EMPLEADO: <%=empl.getPersona().getNombreCompleto()%>
                    </div>
                    
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmContratoTrabajo" name="frmContratoTrabajo" action="<%=CONTROLLER%>/Gestionar/Personal" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="sdiasdesc" name="sdiasdesc" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">                                
                <tr>
                    <td width="100%" valign="top">
                        <!--aquí poner el contenido de la jsp --> 
                        <table width="100%">
                            <tr>
                                <%-- Boton Cancelar --%>
                                <td width="50%">
                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                        background: indianred 50% bottom repeat-x;" title="Cancelar">
                                        Cancelar
                                    </a>
                                </td>
                                <td width="30%" align="right">
                                    &nbsp;
                                </td>
                                <td width="15%" align="right">
                                </td>
                                <td width="15%" align="right">
                                    <a id="btnGenerar" href="javascript: GenerarClick()"
                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Generar contrato">
                                        Generar
                                    </a>
                                </td>
                            </tr>
                        </table>
                        <hr>
                        <table width="60%" align="center" frame="box">
                            <tr>
                                <td width="40%">
                                    <span class="etiqueta">JORNADA DE TRABAJO (HRS.):</span>
                                </td>
                                <td width="60%">
                                    <input id="jornada" name="jornada" type="number" min="1" max="12" class="text" value="<%=jornada%>" style="width:150px; text-align: right"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="40%">
                                    <span class="etiqueta">HORA DE ENTRADA:</span>
                                </td>
                                <td width="60%">
                                    <input id="hrentrada" name="hrentrada" type="time" class="text" value="<%=hrentrada%>" style="width:150px; text-align: right"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="40%">
                                    <span class="etiqueta">HORA DE SALIDA:</span>
                                </td>
                                <td width="60%">
                                    <input id="hrsalida" name="hrsalida" type="time" class="text" value="<%=hrsalida%>" style="width:150px; text-align: right"/>
                                </td>
                            </tr>
                            
                            <tr>
                                <td width="40%">
                                    <span class="etiqueta">INICIO DE SEMANA:</span>
                                </td>
                                <td width="60%">
                                    <select id="inisemana" name="inisemana" class="combo" onchange="ActualizaDiasDescanso(this.value, 1)" style="width:150px">
                                        <option value="LUNES" <%if (inisem.equals("LUNES")){%>selected<%}%>>LUNES</option>
                                        <option value="MARTES" <%if (inisem.equals("MARTES")){%>selected<%}%>>MARTES</option>
                                        <option value="MIERCOLES" <%if (inisem.equals("MIERCOLES")){%>selected<%}%>>MIERCOLES</option>
                                        <option value="JUEVES" <%if (inisem.equals("JUEVES")){%>selected<%}%>>JUEVES</option>
                                        <option value="VIERNES" <%if (inisem.equals("VIERNES")){%>selected<%}%>>VIERNES</option>
                                        <option value="SABADO" <%if (inisem.equals("SABADO")){%>selected<%}%>>SABADO</option>
                                        <option value="DOMINGO" <%if (inisem.equals("DOMINGO")){%>selected<%}%>>DOMINGO</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width="40%">
                                    <span class="etiqueta">FIN DE SEMANA:</span>
                                </td>
                                <td width="60%">
                                    <select id="finsemana" name="finsemana" class="combo" onchange="ActualizaDiasDescanso(this.value, 2)" style="width:150px">
                                        <option value="LUNES" <%if (finsem.equals("LUNES")){%>selected<%}%>>LUNES</option>
                                        <option value="MARTES" <%if (finsem.equals("MARTES")){%>selected<%}%>>MARTES</option>
                                        <option value="MIERCOLES" <%if (finsem.equals("MIERCOLES")){%>selected<%}%>>MIERCOLES</option>
                                        <option value="JUEVES" <%if (finsem.equals("JUEVES")){%>selected<%}%>>JUEVES</option>
                                        <option value="VIERNES" <%if (finsem.equals("VIERNES")){%>selected<%}%>>VIERNES</option>
                                        <option value="SABADO" <%if (finsem.equals("SABADO")){%>selected<%}%>>SABADO</option>
                                        <option value="DOMINGO" <%if (finsem.equals("DOMINGO")){%>selected<%}%>>DOMINGO</option>
                                    </select>
                                </td>
                            </tr>
                            <%--
                            <tr>
                                <td width="40%">
                                    <span class="etiqueta">D&Iacute;AS DE DESCANSO:</span>
                                </td>
                                <td width="60%">
                                    <select id="diasdescanso" name="diasdescanso" multiple style="width:150px">
                                        <option value="LUNES" <%if (diasdescanso.contains("LUNES")){%>selected<%}%>>LUNES</option>
                                        <option value="MARTES" <%if (diasdescanso.contains("MARTES")){%>selected<%}%>>MARTES</option>
                                        <option value="MIERCOLES" <%if (diasdescanso.contains("MIERCOLES")){%>selected<%}%>>MIERCOLES</option>
                                        <option value="JUEVES" <%if (diasdescanso.contains("JUEVES")){%>selected<%}%>>JUEVES</option>
                                        <option value="VIERNES" <%if (diasdescanso.contains("VIERNES")){%>selected<%}%>>VIERNES</option>
                                        <option value="SABADO" <%if (diasdescanso.contains("SABADO")){%>selected<%}%>>SABADO</option>
                                        <option value="DOMINGO" <%if (diasdescanso.contains("DOMINGO")){%>selected<%}%>>DOMINGO</option>
                                    </select>
                                </td>
                            </tr>
                            --%>
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

            function Espera(){
                var mens = document.getElementById('procesando');
                mens.style.display = '';
                var datos = document.getElementById('datos');
                datos.style.display = 'none';                
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
                %>
                ActualizaDiasDescanso('<%=inisem%>',1);
                ActualizaDiasDescanso('<%=finsem%>',2);
            }
            
            function CancelarClick(){
                var frm = document.getElementById('frmContratoTrabajo');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/gestionapersonal.jsp';
                frm.pasoSig.value = '89';
                frm.submit();
            }
            
            function GenerarClick(){
                if (ValidaDatos()){
                    var jor = document.getElementById('jornada');
                    var he = document.getElementById('hrentrada');
                    var hs = document.getElementById('hrsalida');
                    var is = document.getElementById('inisemana');
                    var fs = document.getElementById('finsemana');
                    
                    window.open('http://<%=servidor%>/siscaim/Utilerias/imprimeReporte.jsp?control='+'<%=CONTROLLER%>/Gestionar/Personal'+'&paso=39&dato1='+jor.value+
                            '&dato2='+he.value+'&dato3='+hs.value+'&dato4='+is.value+'&dato5='+fs.value,'','width =800, height=600, left=0, top = 0, resizable= yes');                
                    
                    /*var frm = document.getElementById('frmContratoTrabajo');
                    frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/imprimircontrato.jsp';
                    frm.pasoSig.value = '39';
                    frm.submit();*/
                }
            }
            
            function ValidaDatos(){
                var jor = document.getElementById('jornada');
                if (jor.value==''){
                    jor.focus();
                    MostrarMensaje('Debe indicar las horas de la jornada de trabajo');
                    return false;
                }
                
                var hre = document.getElementById('hrentrada');
                if (hre.value==''){
                    hre.focus();
                    MostrarMensaje('Debe indicar la hora de entrada');
                    return false;
                }
                
                var hrs = document.getElementById('hrsalida');
                if (hrs.value==''){
                    hrs.focus();
                    MostrarMensaje('Debe indicar la hora de salida');
                    return false;
                }
                
                /*
                var ds = document.getElementById('diasdescanso');
                var sds = document.getElementById('sdiasdesc');
                sds.value = '';
                for (f=0; f < ds.length; f++){
                    if (ds.options[f].selected){
                       if (sds.value=='')
                           sds.value = ds.options[f].value;
                       else
                           sds.value += ','+ds.options[f].value;
                    }
                }
                
                if (sds.value==''){
                    //validar sin dias de descanso
                    var sindias = true;
                    for (f=0; f < ds.length; f++){
                        if (!ds.options[f].disabled)
                            sindias = false;
                    }
                    if (!sindias){
                        MostrarMensaje('Debe elegir al menos un día de descanso');
                        return false;
                    } else {
                        sds.value = "SIN DÍAS DE DESCANSO";
                    }
                }
                */
                return true;
            }
            
            function ActualizaDiasDescanso(valor, origen){
                var sinisem = document.getElementById('inisemana');
                var sfinsem = document.getElementById('finsemana');
                
                if (origen==1){
                    for (f=0; f < sfinsem.length; f++){
                        sfinsem.options[f].disabled = false;
                    }
                    //recorrer sfinsem
                    for (f=0; f < sfinsem.length; f++){
                        if (sfinsem.options[f].value==valor){
                            sfinsem.options[f].disabled = true;
                        }
                    }
                }else{
                    for (f=0; f < sinisem.length; f++){
                        sinisem.options[f].disabled = false;
                    }
                    //recorrer sinisem
                    for (f=0; f < sinisem.length; f++){
                        if (sinisem.options[f].value==valor){
                            sinisem.options[f].disabled = true;
                        }
                    }
                }
                
                //DesactivaDiasDescanso();
            }
            
            function DesactivaDiasDescanso(){
                var sdiasdes = document.getElementById('diasdescanso');
                var sinisem = document.getElementById('inisemana');
                var sfinsem = document.getElementById('finsemana');
                
                sdiasdes.selectedIndex = -1;
                for (f=0; f < sdiasdes.length; f++){
                    sdiasdes.options[f].disabled = false;
                }
                
                var sis = sinisem.options[sinisem.selectedIndex].value;
                var sfs = sfinsem.options[sfinsem.selectedIndex].value;
                
                var idi = sinisem.selectedIndex;
                var idf = sfinsem.selectedIndex;
                
                if (idi<idf){
                    for (f=idi; f<=idf; f++){
                        sdiasdes.options[f].disabled = true;
                    }
                } else {
                    for (f=idf; f>=idi; f--){
                        sdiasdes.options[f].disabled = true;
                    }
                }                
            }
        </script>
    </body>
</html>
