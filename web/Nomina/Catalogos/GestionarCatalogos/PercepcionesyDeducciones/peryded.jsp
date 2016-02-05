<%-- 
    Document   : puestos
    Created on : Jun 19, 2012, 2:24:51 AM
    Author     : roman

    Document   : peryded, modificación
    Created on : Jul 29, 2015
    Author     : temoc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.HashMap, java.util.ArrayList, java.util.List,  Modelo.Entidades.Catalogos.PeryDed, Modelo.Entidades.Empleado"%>
<%-- aqui poner los imports
<%@page import=""%>
--%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
List<PeryDed> PeryDedLst = new ArrayList<PeryDed>();
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

        //BOTONES
        $(function() {
            $( "#btnSalir" ).button({
                icons: {
                    primary: "ui-icon-close"
		}
            });
            $( "#btnEditar" ).button({
                icons: {
                    primary: "ui-icon-pencil"
		}
            });
            $( "#btnNuevo" ).button({
                icons: {
                    primary: "ui-icon-document"
		}
            });
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
		}
            });
            $( "#btnTipoCambio" ).button({
                icons: {
                    primary: "ui-icon-note"
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
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Nomina/Catalogos/pydA.png" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        CAT&Aacute;LOGO DE PERCEPCIONES Y DEDUCCIONES
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmPeryDed" name="frmPeryDed" action="<%=CONTROLLER%>/Gestionar/Catalogos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <input id="idPeryDed" name="idPeryDed" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top">
                                        <!--aquí poner contenido-->
                                        <table width="100%">
                                            <tr>
                                                <%-- Boton Salir --%>
                                                <td width="35%" align="left">
                                                <a id="btnSalir" href="javascript: SalirClick()"
                                                    style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                    background: indianred 50% bottom repeat-x;" title="Salir">
                                                    Salir
                                                </a>
                                                </td>
                                                <td width="50%" align="right">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="55%" align="right">&nbsp;</td>
                                                            <td width="15%" align="right">
                                                                <a id="btnTipoCambio" href="javascript: TiposCambioClick()"
                                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Tipos de Cambio">
                                                                    Tipos de Cambio
                                                                </a>
                                                            </td>
                                                            <td width="15%" align="right">
                                                                <a id="btnBaja" href="javascript: BajaPeryDedClick()"
                                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja">
                                                                    Baja
                                                                </a>
                                                            </td>
                                                            <td width="15%" align="right">
                                                                <a id="btnEditar" href="javascript: EditarPeryDedClick()"
                                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar">
                                                                    Editar
                                                                </a>
                                                            </td>
                                                        </tr>        
                                                    </table>
                                                </td>                                                                        
                                                <%-- Boton Nuevo --%>
                                                <td width="15%" align="right">
                                                    <a id="btnNuevo" href="javascript: NuevaPeryDedClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B;" title="Nueva">
                                                        Nueva
                                                    </a>
                                                </td>                                                                        
                                            </tr>
                                        </table> 
                                        <hr>                                
                                        <table class="tablaLista" width="100%">
                                            <thead>
                                                <tr>
                                                      <td width="10%" align="center">
                                                        <span>Id</span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span>Descripción</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Gra o ExE</span>
                                                    </td>                                    
                                                    <td width="15%" align="center">
                                                        <span>Orden</span>
                                                    </td>              
                                                    <td width="15%" align="center">
                                                        <span>Per. o Ded.</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Factor</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                    
                                            <%                                                
                                                PeryDedLst = (List<PeryDed>) datosS.get("listaperyded");
                                            %>
                                            <tbody> 
                                                <%
                                                    int nper = PeryDedLst.size();
                                                    for (int i = 0; i < nper; i++) {
                                                        PeryDed p = (PeryDed) PeryDedLst.get(i);
                                                %>
                                                
                                                <tr onclick="Activa(<%=i%>)">
                                                    <td align="center" width="10%">
                                                        <input id="radioPeryDed" name="radioPeryDed" type="radio" value="<%= p.getIdPeryded() %>" />
                                                    </td>                                                                                                         
                                                    <td width="30%" align="left">
                                                        <span class="etiqueta"><%= p.getDescripcion() %></span>                                                        
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%= p.getGraoExe()==1?"SI":"NO" %></span>                                                        
                                                    </td>                                    
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%= p.getOrden() %></span>                                                        
                                                    </td>              
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%= p.getPeroDed()==1?"PERCEP":"DEDUC" %></span>                                                        
                                                    </td>                                                    
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta"><%= p.getFactor() %></span>                                                        
                                                    </td>                                                    
                                                </tr>
                                                <%
                                                    } //Fin for
                                                %> 
                                            </tbody>
                                        </table>  
                                        
                                    </td>
                               </tr>
                           </table>
                        </div>
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
        
            function EjecutarProceso(){
                var boton = document.getElementById('boton');
                if (boton.value=='1')
                    EjecutarBaja();
            }
        
            function Confirmar(mensaje){
                var mens = document.getElementById('confirm');
                mens.textContent = mensaje;
                $( "#dialog-confirm" ).dialog( "open" );
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
            
            %>
        }

        function NuevaPeryDedClick(){
            Espera();
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/nuevoperyded.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "1";
            var frm = document.getElementById('frmPeryDed');
            frm.submit();
        }
        function EditarPeryDedClick(){
            Espera();
            var paginaSig = document.getElementById("paginaSig");
            paginaSig.value = "/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/nuevoperyded.jsp";
            var pasoSig = document.getElementById("pasoSig");
            pasoSig.value = "22";
            var frm = document.getElementById('frmPeryDed');
            frm.submit();
        }
        
        function EjecutarBaja(){
            Espera();
            var frm = document.getElementById('frmPeryDed');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = "/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp";
            paso.value = '23';
            frm.submit();
        }
        
        function BajaPeryDedClick(){
            var boton = document.getElementById('boton');
            boton.value = '1';                
            Confirmar('¿Está seguro en dar de baja el elemento seleccionado?');
        }

        function SalirClick(){
            var frm = document.getElementById('frmPeryDed');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
            paso.value = '99';
            frm.submit();                
        }

        function Activa(fila){
            var idPeryDed = document.getElementById('idPeryDed');
            var borrarEdit = document.getElementById('borrarEdit');
            borrarEdit.style.display = '';
            <%
                if (PeryDedLst.size() == 1) {
            %>
                    document.frmPeryDed.radioPeryDed.checked = true;
                    idPeryDed.value = document.frmPeryDed.radioPeryDed.value;
            <%    }else {
            %>
                    var radio = document.frmPeryDed.radioPeryDed[fila];
                    radio.checked = true;
                    idPeryDed.value = radio.value;
            <% }%>
        }
        
        
        function TiposCambioClick(){
            Espera();
            var frm = document.getElementById('frmPeryDed');
            var pagina = document.getElementById('paginaSig');
            var paso = document.getElementById('pasoSig');
            pagina.value = '/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/TiposCambios/tiposcambiospyd.jsp';
            paso.value = '40';
            frm.submit();            
        }
</script>
</body>
</html>

