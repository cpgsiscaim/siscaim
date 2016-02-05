<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.Sucursal"%>
<%@page import="java.lang.String, java.text.SimpleDateFormat, javax.servlet.http.HttpSession" %>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
HashMap datosS = sesion.getDatos();
SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
Sucursal sucSel = datosS.get("sucursalSel")!=null?(Sucursal)datosS.get("sucursalSel"):new Sucursal();
Cliente clisel = datosS.get("clienteSel")!=null?(Cliente)datosS.get("clienteSel"):new Cliente();
String sespec = datosS.get("especialidad")!=null?datosS.get("especialidad").toString():"0";
String stotper = datosS.get("totper")!=null?datosS.get("totper").toString():"0";
String sfini = datosS.get("fechaini")!=null?datosS.get("fechaini").toString():"";
String sffin = datosS.get("fechafin")!=null?datosS.get("fechafin").toString():"";
int paso = Integer.parseInt(datosS.get("paso").toString());
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
        
        //Ventana modal del contrato
        $(function() {
            $( "#dialog-contrato" ).dialog({
                autoOpen: false,
                modal: true,
                width:900,
                height:640
            });
        });
        
        //Ventana modal de la fianza
        $(function() {
            $( "#dialog-fianza" ).dialog({
                autoOpen: false,
                modal: true,
                width:900,
                height:640
            });
        });        
        
        //CALENDARIOS
        $(function() {
            $( "#fechaIni" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        $(function() {
            $( "#fechaFin" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        
        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnMostrar" ).button({
                icons: {
                    primary: "ui-icon-zoomin"
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
        <div id="dialog-contrato" title="Documento del Contrato">
            <embed id="pdf" src="" width="870" height="580" align="center" valign="center">
        </div>
        <div id="dialog-fianza" title="Documento de la Fianza">
            <embed id="pdffianza" src="" width="870" height="580" align="center" valign="center">
        </div>        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Empresa/contratosA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        CONSULTAR CONTRATOS
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmGestionarCon" name="frmGestionarCon" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <table width="100%">
                            <tr>
                                <td width="100%" valign="top">
                                    <table id="acciones1" width="100%">
                                        <tr>
                                            <td width="50%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                   style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                   background: indianred 50% bottom repeat-x;" title="Salir de Gestionar Contratos">
                                                    Salir
                                                </a>
                                            </td>
                                            <td width="50%" align="right">
                                                <a id="btnMostrar" href="javascript: MostrarClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Mostrar">
                                                    Mostrar
                                                </a>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="filtros" width="100%">
                                        <tr>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Sucursal:</span><br>
                                                <select id="sucursalsel" name="sucursalsel" class="combo" style="width: 200px" onchange="CargaClientes(this.value)">
                                                    <option value="0">TODAS</option>
                                                <%
                                                    List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
                                                    if (sucursales!=null){
                                                        if (sucursales.size()!=0){
                                                            for (int i=0; i < sucursales.size(); i++){
                                                                Sucursal suc = sucursales.get(i);
                                                            %>
                                                                <option value="<%=suc.getId()%>"<%if (sucSel.getId()==suc.getId()){%>selected<%}%>>
                                                                    <%=suc.getDatosfis().getRazonsocial()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="30%" align="center">
                                                <span class="etiquetaB">Cliente:</span><br>
                                                <select id="cliente" name="cliente" class="combo" style="width: 300px">
                                                    <option value="0">Todos los clientes</option>
                                                <%
                                                    List<Cliente> clientes = (List<Cliente>)datosS.get("clientes");
                                                    if (clientes!=null){
                                                        if (clientes.size()!=0){
                                                            for (int i=0; i < clientes.size(); i++){
                                                                Cliente cli = clientes.get(i);
                                                            %>
                                                            <option value="<%=cli.getId()%>" <%if (cli.getId()==clisel.getId()){%>selected<%}%>>
                                                                    <%=cli.getTipo()==0?cli.getDatosFiscales().getRazonsocial():cli.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                                </option>
                                                            <%
                                                            }
                                                        }
                                                    }
                                                %>
                                                </select>
                                            </td>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Especialidad:</span><br>
                                                <select id="especialidad" name="especialidad" class="combo" style="width: 200px">
                                                    <option value="0" <%if(sespec.equals("0")){%>selected<%}%>>CUALQUIERA</option>
                                                    <option value="7" <%if(sespec.equals("7")){%>selected<%}%>>TODAS</option>
                                                    <option value="1" <%if(sespec.equals("1")){%>selected<%}%>>JARDINERÍA</option>
                                                    <option value="2" <%if(sespec.equals("2")){%>selected<%}%>>LIMPIEZA</option>
                                                    <option value="3" <%if(sespec.equals("3")){%>selected<%}%>>FUMIGACIÓN</option>
                                                    <option value="4" <%if(sespec.equals("4")){%>selected<%}%>>JARDINERÍA Y LIMPIEZA</option>
                                                    <option value="5" <%if(sespec.equals("5")){%>selected<%}%>>JARDINERÍA Y FUMIGACIÓN</option>
                                                    <option value="6" <%if(sespec.equals("6")){%>selected<%}%>>LIMPIEZA Y FUMIGACIÓN</option>
                                                </select>
                                            </td>
                                            <td width="10%" align="center">
                                                <span class="etiquetaB">Total de personal:</span><br>
                                                <input id="totalpersonal" name="totalpersonal" class="text" type="number" value="<%=stotper%>" style="width: 120px" min="1" max="999" title="0 para cualquier cantidad"/>                                                            
                                            </td>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Fecha Inicial:</span><br>
                                                <input id="fechaIni" name="fechaIni" type="text" class="text" readonly value="<%=sfini%>"
                                                       title="Ingrese la fecha inicial (deje vacío si es cualquier fecha)" style="width: 150px;"/>
                                            </td>
                                            <td width="15%" align="center">
                                                <span class="etiquetaB">Fecha Final:</span><br>
                                                <input id="fechaFin" name="fechaFin" type="text" class="text" readonly value="<%=sffin%>"
                                                       title="Ingrese la fecha final (deje vacío si es cualquier fecha)" style="width: 150px;" />
                                            </td>
                                        </tr>
                                    </table>
                                    <hr>
                                    <%if (paso==25){%>
                                        <table class="tablaLista" width="100%">
                                            
                                        <%List<Contrato> contratos = (List<Contrato>)datosS.get("contratos");
                                        if (contratos.isEmpty()){%>
                                            <tr>
                                                <td align="center">
                                                    <span class="etiquetaB">
                                                        No se encontraron Contratos que cumplan los criterios
                                                    </span>
                                                </td>
                                            </tr>
                                        <%} else {%>
                                                <thead>
                                                <tr>
                                                    <td align="center" width="15%">
                                                        <span>SUCURSAL</span>
                                                    </td>
                                                    <td align="center" width="15%">
                                                        <span>CLIENTE</span>
                                                    </td>
                                                    <td align="center" width="20%">
                                                        <span>CONTRATO</span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span>PERSONAL</span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span>ESPECIALIDAD</span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span>FECHA INICIO</span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span>FECHA FIN</span>
                                                    </td>
                                                    <td align="center" width="10%">
                                                        <span>DOCUMENTOS</span>
                                                    </td>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <%for (int i=0; i < contratos.size(); i++){
                                                    Contrato con = contratos.get(i);
                                                    String espe = "SIN ESPECIALIDAD";
                                                    switch(con.getEspecialidad()){
                                                        case 1: espe = "JARDINERÍA";break;
                                                        case 2: espe = "LIMPIEZA";break;
                                                        case 3: espe = "FUMIGACIÓN";break;
                                                        case 4: espe = "JARDINERÍA Y LIMPIEZA";break;
                                                        case 5: espe = "JARDINERÍA Y FUMIGACIÓN";break;
                                                        case 6: espe = "LIMPIEZA Y FUMIGACIÓN";break;
                                                        case 7: espe = "JARDINERÍA, LIMPIEZA Y FUMIGACIÓN";break;
                                                    }%>
                                                    <tr>
                                                        <td align="left" width="15%">
                                                            <span class="etiquetaD">
                                                                <%=con.getSucursal().getDatosfis().getRazonsocial()%>
                                                            </span>
                                                        </td>
                                                        <td align="left" width="15%">
                                                            <span class="etiquetaD">
                                                                <%=con.getCliente().getDatosFiscales().getRazonsocial()%>
                                                            </span>
                                                        </td>
                                                        <td align="left" width="20%">
                                                            <span class="etiquetaD">
                                                                <%=con.getContrato()%> - <%=con.getDescripcion()%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiquetaD">
                                                                <%=con.getTotalpersonal()%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiquetaD">
                                                                <%=espe%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiquetaD">
                                                                <%=ffecha.format(con.getFechaIni())%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <span class="etiquetaD">
                                                                <%=ffecha.format(con.getFechaFin())%>
                                                            </span>
                                                        </td>
                                                        <td align="center" width="10%">
                                                            <%if (con.getDocumento()==0 && con.getDocfianza()==0){%>
                                                                <span class="etiquetaD">Sin documentos</span>
                                                            <%}%>
                                                            <%if (con.getDocumento()==1){%>
                                                            <a href="javascript: MostrarContrato('/siscaim/Imagenes/Contratos/<%=con.getId()%>.pdf')" title="CONTRATO">
                                                                  <img src="/siscaim/Estilos/imgsBotones/doc_activo.png" width="26">
                                                                </a>
                                                            <%}%>
                                                            <%if (con.getDocfianza()==1){%>
                                                            <a href="javascript: MostrarFianza('/siscaim/Imagenes/Contratos/Fianzas/<%=con.getId()%>.pdf')" title="FIANZA">
                                                                  <img src="/siscaim/Estilos/imgsBotones/doc_activo.png" width="26">
                                                                </a>
                                                            <%}%>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                <%}
                                        }%> 
                                        </table>
                                    <%}%>
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
                <%}%>
            }
            
            function SalirClick(){
                var frm = document.getElementById('frmGestionarCon');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
                paso.value = '92';
                frm.submit();                
            }
            
            function CargaClientes(sucsel){
                if (sucsel!='0'){
                    Espera();
                    var frm = document.getElementById('frmGestionarCon');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/consultarcontratos.jsp';
                    paso.value = '-1';
                    frm.submit();
                }
            }            
            
            function ValidaRequeridos(){
                var totper = document.getElementById('totalpersonal');
                if (totper.value==''){
                    MostrarMensaje('El total de personal no puede estar vacío');
                    return false;
                }
                
                var ntotper = parseInt(totper.value);
                if (isNaN(ntotper)){
                    MostrarMensaje('El total de personal no es válido');
                    return false;
                }
                
                if (ntotper<0){
                    MostrarMensaje('El total de personal no es válido');
                    return false;
                }
                
                return true;
            }
            
            function MostrarClick(){
                if (ValidaRequeridos()){
                    Espera();
                    var frm = document.getElementById('frmGestionarCon');
                    var pagina = document.getElementById('paginaSig');
                    var paso = document.getElementById('pasoSig');
                    pagina.value = '/Empresa/GestionarClientes/Contratos/consultarcontratos.jsp';
                    paso.value = '25';
                    frm.submit();
                }
            }
            
            function MostrarContrato(doc){
                var pdf = document.getElementById('pdf');
                pdf.src = doc;
                $( "#dialog-contrato" ).dialog( "open" );
            }
            
            function MostrarFianza(doc){
                var pdf = document.getElementById('pdffianza');
                pdf.src = doc;
                $( "#dialog-fianza" ).dialog( "open" );
            }
            
        </script>
    </body>
</html>