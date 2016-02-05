<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.List, java.util.ArrayList, java.util.HashMap, java.text.SimpleDateFormat, Modelo.Entidades.Empleado, Modelo.Entidades.Vacaciones, Modelo.Entidades.Catalogos.Quincena"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Empleado empl = (Empleado)datosS.get("empleado");
List<Quincena> quincenas = datosS.get("quincenas")!=null?(List<Quincena>)datosS.get("quincenas"):new ArrayList<Quincena>();
List<String> aniosanti = datosS.get("aniosanti")!=null?(List<String>)datosS.get("aniosanti"): new ArrayList<String>();
List<String> anios = datosS.get("anios")!=null?(List<String>)datosS.get("anios"):new ArrayList<String>();
String banvac = (String)datosS.get("banvac");
Vacaciones vac = datosS.get("vacaciones")!=null?(Vacaciones)datosS.get("vacaciones"):new Vacaciones();
SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
String fechaIni = vac.getFechainicial()!=null?formato.format(vac.getFechainicial()):"";
String fechaFin = (vac.getFechafinal()!=null && vac.getEstatus()==4)?formato.format(vac.getFechafinal()):"";
NumberFormat fmtnum = new DecimalFormat("#,##0.00");
Float sueldod = datosS.get("sueldodiario")!=null?(Float)datosS.get("sueldodiario"):new Float(0.0f);
String ssueldo = fmtnum.format(sueldod.floatValue());
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
        
        //CALENDARIOS
        $(function() {
            $( "#fechaini" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
                
        //BOTONES
        $(function() {
            $( "#btnCancelar" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnGuardar" ).button({
                icons: {
                    primary: "ui-icon-disk"
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
                    <img src="/siscaim/Imagenes/Personal/empleadosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="center">
                        REGISTRAR PAGO DE VACACIONES DE EMPLEADO
                    </div>
                    <div class="titulo" align="center">
                        EMPLEADO: <%=empl.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="fmrNuevaVacs" name="fmrNuevaVacs" action="<%=CONTROLLER%>/Gestionar/Vacaciones" method="post">
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <% if (banvac.equals("0")){%>
                <table id="tbmensaje" align="center" width="100%">
                    <tr>
                        <td width="100%" align="center">
                            <span class="subtitulo">
                                EL EMPLEADO NO TIENE DERECHO A NUEVAS VACACIONES
                            </span>
                        </td>
                    </tr>
                </table>
            <%} else {%>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">Antig&uuml;edad:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <select id="antiguedad" name="antiguedad" class="combo" style="width:100px" onchange="CambiaDias(this.value)">
                                            <% for (int a=0; a < aniosanti.size(); a++){
                                                String anti = aniosanti.get(a);%>
                                                <option value="<%=anti%>"><%=anti%></option>
                                            <%}%>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">A&ntilde;o:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <input id="anio" name="anio" type="text" class="text" value="<%=anios.get(0)%>" readonly/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">D&iacute;as:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <input id="dias" name="dias" type="text" class="text" value="6" readonly/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">D&iacute;as a cuenta:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <input id="diasacuenta" name="diasacuenta" type="number" class="text" value="0" min="0" max="5" onchange="CalculaMontos()"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">Sueldo diario:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <input id="sueldo" name="sueldo" type="text" class="text" value="<%=ssueldo%>" readonly style="text-align: right"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB"></span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <input id="chkgoce" name="chkgoce" type="checkbox" value="0" onclick="GoceVacaciones()"/><span class="etiquetaB">Vacaciones gozadas</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100%" colspan="2">
                                        <table id="montovacas" width="100%">
                                            <tr>
                                                <td width="40%" valign="center" align="right">
                                                    <span class="etiquetaB">Monto Vacaciones:</span>
                                                </td>
                                                <td width="60%" valign="center" align="left">
                                                    <input id="vacaciones" name="vacaciones" type="text" class="text" value="" readonly style="text-align: right"/>
                                                </td>
                                            </tr>
                                        </table>
                                        <table id="periodovacas" style="display:none" width="100%">
                                            <tr>
                                                <td width="40%" align="right">
                                                    <span class="etiqueta">Fecha Inicial del período:</span>
                                                </td>
                                                <td width="60%" align="left">
                                                    <input id="fechaini" name="fechaini" type="text" class="text" value="<%=fechaIni%>" readonly=""
                                                           title="Ingrese la fecha inicial del período vacacional" style="width: 150px;" onchange="CalculaFechaFinal()"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="40%" align="right">
                                                    <span class="etiqueta">Fecha Final del período:</span>
                                                </td>
                                                <td width="90%" align="left">
                                                    <input id="fechafin" name="fechafin" type="text" class="text" value="<%=fechaFin%>" readonly style="width: 150px;"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">Prima Vacacional:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <input id="prima" name="prima" type="text" class="text" value="" readonly style="text-align: right"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="40%" valign="center" align="right">
                                        <span class="etiquetaB">Quincena de pago:</span>
                                    </td>
                                    <td width="60%" valign="center" align="left">
                                        <select id="quincena" name="quincena" class="combo" style="width:200px">
                                            <option value="">Elija la quincena...</option>
                                            <% for (int q=0; q < quincenas.size(); q++){
                                                Quincena quin = quincenas.get(q);%>
                                                <option value="<%=quin.getId()%>"><%=quin.getMes()%> - <%=quin.getNumero()%></option>
                                            <%}%>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <%}%>
            <br><br>
            <table width="100%">
                <tr>
                    <td width="50%" align="right">&nbsp;</td>
                    <td width="25%" align="right">
                        <% if (banvac.equals("1")){%>
                        <a id="btnGuardar" href="javascript: GuardarClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Guardar">
                            Guardar
                        </a>
                        <%}%>
                    </td>
                    <td width="25%">
                        <a id="btnCancelar" href="javascript: CancelarClick()"
                            style="width: 150px; font-weight: bold; color: #FFFFFF;
                            background: indianred 50% bottom repeat-x;" title="Cancelar">
                            Cancelar
                        </a>
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
                }%>
                CambiaDias('<%=aniosanti!=null && !aniosanti.isEmpty()?aniosanti.get(0):0%>');
                CalculaMontos();
            }
            
            function CalculaFechaFinal(){
                var fechini = document.getElementById('fechaini');
                var fechfin = document.getElementById('fechafin');
                var dias = document.getElementById('dias');
                var dicta = document.getElementById('diasacuenta');
                if (dicta.value=='')
                    dicta.value = '0';
                var dn = parseInt(dias.value)-parseInt(dicta.value)
                fechfin.value = sumarFecha(dn-1, fechini.value);
            }
            
            function GoceVacaciones(){
                var chkgoce = document.getElementById('chkgoce');
                var tbmonto = document.getElementById('montovacas');
                var tbperiodo = document.getElementById('periodovacas');
                if (chkgoce.checked){
                    tbmonto.style.display = 'none';
                    tbperiodo.style.display = '';
                } else {
                    tbmonto.style.display = '';
                    tbperiodo.style.display = 'none';
                }
            }
            
            function CalculaMontos(){
                
                var dias = document.getElementById('dias');
                var dicta = document.getElementById('diasacuenta');
                if (dicta.value=='')
                    dicta.value = '0';
                var sueldo = document.getElementById('sueldo');
                var vacas = document.getElementById('vacaciones');
                var prima = document.getElementById('prima');
                var idias = parseInt(dias.value);
                var idc = parseInt(dicta.value);
                var idn = idias-idc;
                var fsueldo = parseFloat(sueldo.value.replace(',',''));
                var fvac = idn*fsueldo;
                var fprima = fvac*0.25;
                vacas.value = formato_numero(fvac,2,'.',',');
                prima.value = formato_numero(fprima,2,'.',',');
            }
            
            function CambiaDias(anti){
                var dias = document.getElementById('dias');
                var anio = document.getElementById('anio');
                var dicta = document.getElementById('diasacuenta');
                dicta.value = 0;
                var d = 6;
                var santi = document.getElementById('antiguedad');
                var iant = santi.selectedIndex;
                <% for (int a=0; a < anios.size(); a++){%>
                    if (iant==<%=a%>){
                        anio.value = '<%=anios.get(a)%>';
                    }
                <%}%>
                switch (parseInt(anti)){
                    case 2: d = 8; break;
                    case 3: d = 10; break;
                    case 4: d = 12; break;
                    case 5: case 6: case 7: case 8: case 9: d = 14; break;
                    case 10: case 11: case 12: case 13: case 14: d = 16; break;
                    case 15: case 16: case 17: case 18: case 19: d = 18; break;
                    case 20: case 21: case 22: case 23: case 24: d = 20; break;
                    case 25: case 26: case 27: case 28: case 29: d = 22; break;
                    case 30: case 31: case 32: case 33: case 34: d = 24; break;
                    case 35: case 36: case 37: case 38: case 39: d = 26; break;
                    case 40: case 41: case 42: case 43: case 44: d = 28; break;
                }
                dias.value = d;
                dicta.max = d-1;
                CalculaMontos();
            }
            
            function ValidaRequeridos(){
                var quincena = document.getElementById('quincena');
                if (quincena.value==''){
                    MostrarMensaje('No ha definido la quincena de pago');
                    return false;
                }
                
                var chkgoce = document.getElementById('chkgoce');
                if (chkgoce.checked){
                    var fini = document.getElementById('fechaini');
                    if (fini.value==''){
                        MostrarMensaje('No ha definido la fecha inicial del período de goce de vacaciones');
                        return false;
                    }
                }
                
                return true;
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('fmrNuevaVacs');
                    frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Vacaciones/listado.jsp';
                    frm.pasoSig.value = '2';
                    frm.submit();
                }
            }
                       
            function CancelarClick(){
                Espera();
                var frm = document.getElementById('fmrNuevaVacs');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Vacaciones/listado.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
        </script>
    </body>
</html>