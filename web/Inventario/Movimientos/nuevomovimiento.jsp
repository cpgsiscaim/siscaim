<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, java.util.Date, Modelo.Entidades.Sucursal, Modelo.Entidades.TipoMov, Modelo.Entidades.Cabecera, Modelo.Entidades.Detalle"%>
<%@page import="Modelo.Entidades.Proveedor, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo"%>
<%@page import="java.text.SimpleDateFormat, Modelos.UtilMod, java.text.DecimalFormat, java.text.NumberFormat"%>


<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    TipoMov tmovSel = (TipoMov)datosS.get("tipomovSel");
    String titulo = datosS.get("titulo").toString().toUpperCase();
    String imagen = "inventarioB.png";
    Cabecera cab = new Cabecera();
    TipoMov tipoMov = new TipoMov();
    SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
    Date dhoy = (Date)datosS.get("hoy");
    String shoy = form.format(dhoy);//dhoy.toString();
    //String hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
    String sdhoy = dhoy.toString();
    String dhoyN = sdhoy.substring(8,10) + "-" + sdhoy.substring(5,7) + "-" + sdhoy.substring(0, 4);
    Proveedor pr = new Proveedor();
    Cliente cli = new Cliente();
    UtilMod uMod = new UtilMod();   
    String subtotal = "0.00", descto = "0.00", iva = "0.00", total = "0.00", sfolorig = "", sserorig = "", sserie = "", sfolio="";
    int bandet = Integer.parseInt(datosS.get("bandet")!=null?datosS.get("bandet").toString():"0");
    int bancon = Integer.parseInt(datosS.get("bancon")!=null?datosS.get("bancon").toString():"0");
    List<Detalle> detalle = datosS.get("detalles")!=null?(List<Detalle>)datosS.get("detalles"):new ArrayList<Detalle>();
    Contrato scon = new Contrato();
    CentroDeTrabajo sct = new CentroDeTrabajo();
    NumberFormat formato = new DecimalFormat("#,##0.00");
    String descrip = "";
    if (datosS.get("accion").toString().equals("editar") ||
            bandet == 1 || bancon == 1 || bancon == 2){
        cab = (Cabecera)datosS.get("cabecera");
        if (tmovSel.getId()==25){
            descrip = cab.getDescripcion();
        }
        if (datosS.get("accion").toString().equals("editar")){
            imagen = "inventarioC.png";
            sserie = cab.getSerie().getSerie();
            sfolio = Integer.toString(cab.getFolio());
        }
        tipoMov = cab.getTipomov();
        pr = cab.getProveedor();
        cli = cab.getCliente();
        if (tipoMov.getId()==20 || tipoMov.getId()==21){
            if (bancon > 0 || datosS.get("accion").toString().equals("editar"))
                scon = cab.getContrato();
            if (bancon == 2 || datosS.get("accion").toString().equals("editar"))
                sct = cab.getCentrotrabajo();
        }
        if (tipoMov.getId()==6){
            sfolorig = cab.getFolioOriginal()!=0?Integer.toString(cab.getFolioOriginal()):"";
            sserorig = cab.getSerieOriginal()!=null?cab.getSerieOriginal():"";
        }
        shoy = form.format(cab.getFechaCaptura()!=null?cab.getFechaCaptura():dhoy);
        //hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
        subtotal = datosS.get("totalmov")!=null?formato.format(Float.parseFloat(datosS.get("totalmov").toString())):"0.00";
        descto = datosS.get("totaldesc")!=null?formato.format(Float.parseFloat(datosS.get("totaldesc").toString())):"0.00";
        double fiva = uMod.Redondear((Float.parseFloat(datosS.get("totalmov")!=null?datosS.get("totalmov").toString():"0.00"))*(float)0.16,2);
        double ftotal = uMod.Redondear(Float.parseFloat(datosS.get("totalmov")!=null?datosS.get("totalmov").toString():"0.00")+fiva,2);
        iva = formato.format(fiva);
        total = formato.format(ftotal);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <!--<link type="text/css" href="/siscaim/Estilos/menupestanas.css" rel="stylesheet" />-->
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        
        <!--<link type="text/css" rel="stylesheet" href="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
	<SCRIPT type="text/javascript" src="/siscaim/Estilos/calendario/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js?random=20060118"></script>
        -->
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
        
        //CALENDARIOS
        $(function() {
            $( "#fecha" ).datepicker({
            changeMonth: true,
            changeYear: true
            });
        });
        $(function() {
            $( "#fechaInv" ).datepicker({
            changeMonth: true,
            changeYear: true
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
            $( "#btnBaja" ).button({
                icons: {
                    primary: "ui-icon-trash"
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
            $( "#btnAgregar" ).button({
                icons: {
                    primary: "ui-icon-plus"
		}
            });
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
        <div id="dialog-confirm" title="SISCAIM - Confirmar">
            <p id="confirm" class="error"></p>
        </div>
        
        <table width="100%">
            <tr>
                <td width="5%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Inventario/Catalogos/<%=imagen%>" align="center" width="50" height="40">
                </td>
                <td width="95%" align="left" valign="center">
                    <div class="bigtitulo" align="left">
                        GESTIONAR MOVIMIENTOS
                    </div>
                    <div class="titulo" align="left">
                        <%=titulo%>
                    </div>
                    <div class="subtitulo" align="left">
                        SUCURSAL <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                    <%if (datosS.get("accion").toString().equals("editar")){%>
                    <div class="subtitulo">Movimiento: <%=sserie%> - <%=sfolio%></div>
                    <%}%>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoMov" name="frmNuevoMov" action="<%=CONTROLLER%>/Gestionar/Movimientos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idDet" name="idDet" type="hidden" value=""/>
            <input id="variosdet" name="variosdet" type="hidden" value="0"/>
            <input id="boton" name="boton" type="hidden" value=""/>
            <div id="datos">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="top" align="right">
                                        <!-- cabecera -->
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="70%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="100%" align="left">
                                                                <span class="etiqueta">Fecha:</span>
                                                                <input id="fecha" name="fecha" type="text" class="text" readonly value="<%=shoy%>"
                                                                    title="Ingrese la fecha del movimiento"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%">
                                                                <% if (tmovSel.getId()==7 || tmovSel.getId()==8){%>
                                                                    <span class="etiquetaB">Movimiento:</span>
                                                                    <select id="movimiento" name="movimiento" class="combo" style="width: 400px"
                                                                            title="Elija el Movimiento">
                                                                        <option value="">Elija el Movimiento...</option>
                                                                        <%
                                                                        List<TipoMov> tiposmovs = (List<TipoMov>)datosS.get("otrostiposmovs");
                                                                        for (int i=0; i < tiposmovs.size(); i++){
                                                                            TipoMov tm = tiposmovs.get(i);
                                                                        %>
                                                                        <option value="<%=tm.getId()%>" 
                                                                                <%if (tm.getId()==tipoMov.getId()){%>selected<%}%>>
                                                                            <%=tm.getDescripcion()%>
                                                                        </option>
                                                                        <%
                                                                        }
                                                                        %>
                                                                    </select>
                                                                <% } else if (tmovSel.getCategoria()==1) {%>
                                                                    <span class="etiqueta">Proveedor:</span>
                                                                    <select id="proveedor" name="proveedor" class="combo" style="width: 600px"
                                                                            onchange="CargaProveedor(this.value)" title="Elija el proveedor">
                                                                        <option value="">Elija el Proveedor...</option>
                                                                        <%
                                                                        List<Proveedor> proveedores = (List<Proveedor>)datosS.get("proveedores");
                                                                        for (int i=0; i < proveedores.size(); i++){
                                                                            Proveedor prov = proveedores.get(i);
                                                                        %>
                                                                        <option value="<%=prov.getId()%>" <%if (prov.getId()==pr.getId()){%>selected<%}%>>
                                                                            <%=prov.getTipo().equals("0")?prov.getDatosfiscales().getRazonsocial():prov.getDatosfiscales().getPersona().getNombreCompleto()%>
                                                                        </option>
                                                                        <%
                                                                        }
                                                                        %>
                                                                    </select>
                                                                <% } else if (tmovSel.getCategoria()==2){%>
                                                                    <span class="etiqueta">Cliente:</span>
                                                                    <select id="cliente" name="cliente" class="combo" style="width: 600px"
                                                                            onchange="CargaCliente(this.value)" title="Elija el cliente">
                                                                        <option value="">Elija el Cliente...</option>
                                                                        <%
                                                                        List<Cliente> clientes = (List<Cliente>)datosS.get("clientes");
                                                                        for (int i=0; i < clientes.size(); i++){
                                                                            Cliente cl = clientes.get(i);
                                                                        %>
                                                                        <option value="<%=cl.getId()%>" <%if (cl.getId()==cli.getId()){%>selected<%}%>>
                                                                            <%=cl.getTipo()==0?cl.getDatosFiscales().getRazonsocial():cl.getDatosFiscales().getPersona().getNombreCompleto()%>
                                                                        </option>
                                                                        <%
                                                                        }
                                                                        %>
                                                                    </select>
                                                                 <%} else if (tmovSel.getId()==25){%>
                                                                    <span class="etiqueta">Descripción:</span>
                                                                    <input id="descripcion" name="descripcion" class="text" type="text" maxlength="100" value="<%=descrip%>"
                                                                           onblur="Mayusculas(this)" style="width:500px" autofocus="" tabindex="1999"/>
                                                                 <%}%>
                                                            </td>
                                                        </tr>
                                                        <% if (tmovSel.getId()==20 || tmovSel.getId()==21) {%>
                                                        <tr>
                                                            <td width="100%">
                                                                <table width="100%" align="center">
                                                                    <tr>
                                                                        <td width="100%" align="left">
                                                                            <span class="etiqueta">Contrato:</span>
                                                                            <select id="contrato" name="contrato" class="combo" style="width: 500px"
                                                                                    onchange="CargaCt(this.value)" title="Elija el contrato">
                                                                                <option value="">Elija el Contrato...</option>
                                                                                <%
                                                                                List<Contrato> contratos = datosS.get("contratos")!=null?(List<Contrato>)datosS.get("contratos"):new ArrayList<Contrato>();
                                                                                for (int i=0; i < contratos.size(); i++){
                                                                                    Contrato con = contratos.get(i);
                                                                                %>
                                                                                <option value="<%=con.getId()%>" <%if (con.getId()==scon.getId()){%>selected<%}%>>
                                                                                    <%=con.getContrato()%> - <%=con.getDescripcion()%>
                                                                                </option>
                                                                                <%
                                                                                }
                                                                                %>
                                                                            </select>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width="100%" align="left">
                                                                            <span class="etiqueta">C.T.:</span>
                                                                            <select id="ct" name="ct" class="combo" style="width: 500px" title="Elija el Centro de Trabajo">
                                                                                <option value="">Elija el Centro de Trabajo...</option>
                                                                                <%
                                                                                List<CentroDeTrabajo> centros = datosS.get("centros")!=null?(List<CentroDeTrabajo>)datosS.get("centros"):new ArrayList<CentroDeTrabajo>();
                                                                                for (int i=0; i < centros.size(); i++){
                                                                                    CentroDeTrabajo ct = centros.get(i);
                                                                                %>
                                                                                <option value="<%=ct.getId()%>" <%if (ct.getId()==sct.getId()){%>selected<%}%>>
                                                                                    <%=ct.getNombre()%>
                                                                                </option>
                                                                                <%
                                                                                }
                                                                                %>
                                                                            </select>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%} else if (tmovSel.getId()==6){%>
                                                        <tr>
                                                            <td width="100%">
                                                                <table width="100%">
                                                                    <tr>
                                                                        <td width="30%" align="left">
                                                                            <span class="etiqueta">Serie Original:</span>
                                                                            <input id="serieorig" name="serieorig" class="text" type="text" value="<%=sserorig%>" maxlength="3" style="width: 80px; text-align: center"
                                                                                onkeypress="return ValidaAlfa(event)" onblur="Mayusculas(this)"/>                                                                
                                                                        </td>
                                                                        <td width="30%" align="left">
                                                                            <span class="etiqueta">Folio Original:</span>
                                                                            <input id="folioorig" name="folioorig" class="text" type="text" value="<%=sfolorig%>" maxlength="10" style="width: 150px; text-align: right"
                                                                                onkeypress="return ValidaNums(event)"/>                                                                
                                                                        </td>
                                                                        <td width="40%" align="left">
                                                                            <!--Costo de flete-->
                                                                            <table id="tbflete" width="100%" style="display: none">
                                                                                <tr>
                                                                                    <td width="30%">
                                                                                        <span class="etiqueta">Costo de Flete:</span>
                                                                                        <input id="flete" name="flete" class="text" type="text" value="<%=formato.format(cab.getFlete())%>" 
                                                                                            maxlength="10" onblur="Formatea(this)" style="width: 70px; text-align: right"
                                                                                            onkeypress="return ValidaCantidad2(event, this)"/>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                            <!-- fin costo de flete -->
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%}%> 
                                                    </table> 
                                                </td> 
                                                <td width="30%">
                                                    <%if (tmovSel.getId()!=25){%>
                                                    <table width="100%" class="tablaSubtotal">
                                                        <% if ((tmovSel.getId()==20 || tmovSel.getId()==21) &&
                                                            datosS.get("accion").toString().equals("editar")) {%>
                                                        <tr bgcolor="red">
                                                            <td width="50%" align="right">
                                                               <span>TOPE:</span> 
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <span id="subt"><%=formato.format(cab.getCentrotrabajo().getTopeInsumos())%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%" colspan="2">&nbsp;</td>
                                                        </tr>
                                                        <%}%>
                                                        <tr>
                                                            <td width="50%" align="right">
                                                               <span>SUBTOTAL:</span> 
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <span id="subt"><%=subtotal%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="50%" align="right">
                                                               <span>DESCUENTO:</span> 
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <span id="descto"><%=descto%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="50%" align="right">
                                                               <span>IVA:</span> 
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <span id="iva"><%=iva%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="50%" align="right">
                                                               <span>TOTAL:</span> 
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <span id="tot"><%=total%></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <%}%>
                                                </td>
                                            </tr>
                                        </table>
                                        <br>
                                        <!-- detalle -->
                                        <table width="100%" align="center" style="background-color: #0B610B">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="subtituloblanco" style="color: #ffffff;">DETALLE</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- acciones del detalle -->
                                        <table width="100%" align="center">
                                            <tr>
                                                <td width="40%" align="left">
                                                </td>
                                                <td width="40%" align="right">
                                                    <table id="borrarEdit" width="100%" style="display: none">
                                                        <tr>
                                                            <td width="50%" align="right">
                                                                <a id="btnBaja" href="javascript: BajaClick()"
                                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Dar de baja los registros seleccionados">
                                                                    Baja
                                                                </a>
                                                            </td>
                                                            <td width="50%" align="right">
                                                                <a id="btnEditar" href="javascript: EditarClick()"
                                                                    style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar el registro seleccionado">
                                                                    Editar
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="20%" align="right">
                                                    <%if (tmovSel.getId()!=25){%>
                                                    <a id="btnAgregar" href="javascript: NuevoClick()"
                                                    style="width: 150px; font-weight: bold; color: #0B610B;"
                                                    title="Agregar conceptos">
                                                        Agregar
                                                    </a>
                                                    <%}%>
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- fin acciones del detalle -->
                                        <hr>
                                        <!-- listado del detalle -->
                                        <%
                                        int anchoProd = 22, anchoUnid = 8, anchoCant = 8, cols = 8;
                                        if (tmovSel.getId()==7 || tmovSel.getId()==8){
                                            anchoProd = 30; anchoUnid = 16; anchoCant = 16;
                                        } else if (tmovSel.getId()==20 || tmovSel.getId()==21){
                                            anchoUnid = 5; anchoCant = 5; cols = 9;
                                        } else if (tmovSel.getId()==25){
                                            anchoProd = 35;
                                        }
                                        %>
                                        <table width="100%" align="center" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <%if (tmovSel.getId()!=25){%>
                                                    <td width="5%"></td>
                                                    <%}%>
                                                    <td width="5%" align="center"><span>Clave</span></td>
                                                    <td width="<%=anchoProd%>%" align="center"><span>Producto</span></td>
                                                    <%if (tmovSel.getId()!=25){%>
                                                    <% if (tmovSel.getId()==20 || tmovSel.getId()==21){ %>
                                                    <td width="6%" align="center"><span>Tipo</span></td>
                                                    <%}%>
                                                    <td width="<%=anchoUnid%>%" align="center"><span>Unid</span></td>
                                                    <td width="<%=anchoCant%>%" align="center"><span>Cant</span></td>
                                                    <% if (tmovSel.getId()!=7 && tmovSel.getId()!=8){ %>
                                                    <td width="8%" align="center">
                                                        <span>
                                                            <% if (tmovSel.getCategoria()==1){%>Costo<%} else {%> Precio <%}%>
                                                        </span>
                                                    </td>
                                                    <td width="8%" align="center"><span>Descto.</span></td>
                                                    <td width="8%" align="center"><span>Importe</span></td>
                                                    <% } if (tmovSel.getId()==20 || tmovSel.getId()==21){ %>
                                                    <td width="8%" align="center"><span>Imprimir</span></td>
                                                    <%}
                                                    } else {%>
                                                        <td width="20%" align="center"><span>Unidad</span></td>
                                                        <td width="20%" align="center"><span>Exis. Actual</span></td>
                                                        <td width="20%" align="center"><span>Exis. Física</span></td>
                                                    <%}%>
                                                </tr>                                                
                                            </thead>
                                            <tbody>
                                            <%
                                                if (detalle.size()==0){
                                            %>
                                                <tr>
                                                    <td colspan="<%=cols%>" width="100%" align="center">
                                                        <span class="etiqueta">No hay detalle registrado del movimiento</span>
                                                    </td>
                                                </tr>
                                            <%
                                                } else {
                                                    /*if(tmovSel.getId()==25){
                                                        List<Float> exis = (List<Float>)datosS.get("existencias");
                                                    }*/
                                                
                                                for (int i=0; i < detalle.size(); i++){
                                                    Detalle det = detalle.get(i);
                                                    double descdet = uMod.Redondear((det.getCantidad()*det.getCosto()*(det.getDescuento()/100)),2);
                                                    if (tmovSel.getCategoria()==2)
                                                        descdet = uMod.Redondear((det.getCantidad()*det.getPrecio()*(det.getDescuento()/100)),2);
                                                %>
                                                <tr onclick="Activa(<%=i%>)">
                                                    <%if(tmovSel.getId()!=25){%>
                                                    <td width="5%">
                                                        <input id="chkdet<%=i%>" name="chkdet<%=i%>" type="checkbox" value="<%=i%>">
                                                        <input id="radioDet" name="radioDet" type="radio" value="<%=i%>"/>
                                                    </td>
                                                    <%}%>
                                                    <td width="5%" align="center">
                                                        <%=det.getProducto().getClave()%>
                                                    </td>
                                                    <td width="<%=anchoProd%>%" align="left">
                                                        <%=det.getProducto().getDescripcion()%>
                                                    </td>
                                                    <%if (tmovSel.getId()!=25){%>
                                                    <% if (tmovSel.getId()==20){ %>
                                                    <td width="6%" align="center">
                                                        <%=det.getCambio()==0?"BÁSICO":"CAMBIO"%>
                                                    </td>
                                                    <%}%>
                                                    <td width="<%=anchoUnid%>%" align="center">
                                                        <%=det.getUnidad().getClave()%>
                                                    </td>
                                                    <td width="<%=anchoCant%>%" align="right">
                                                        <input id="cantidad<%=i%>" name="cantidad<%=i%>" class="text" type="text" value="<%=formato.format(det.getCantidad())%>" 
                                                                maxlength="10" onblur="CalculaImporte('<%=i%>')" style="width: 70px; text-align: right"
                                                                onkeypress="return ValidaCantidad2(event, this)" tabindex="<%=i+1000%>"/>
                                                    </td>
                                                    <% if (tmovSel.getId()!=7 && tmovSel.getId()!=8){ %>
                                                    <td width="8%" align="right">
                                                        <%
                                                        if (tmovSel.getCategoria()==1){
                                                        %>
                                                            <input id="costo<%=i%>" name="costo<%=i%>" class="text" type="text" value="<%=formato.format(det.getCosto())%>" 
                                                                maxlength="10" onblur="CalculaImporte('<%=i%>')" style="width: 70px; text-align: right"
                                                                onkeypress="return ValidaCantidad2(event, this)" tabindex="<%=i+2000%>"/>
                                                            
                                                        <%} else {%>
                                                            <span id="pu<%=i%>">
                                                                <%=formato.format(det.getPrecio())%>
                                                            </span>
                                                        <%}%>
                                                    </td>
                                                    <td width="8%" align="right">
                                                        <span id="descto<%=i%>">
                                                        <%=formato.format(descdet)%>
                                                        </span>
                                                    </td>                                                    
                                                    <td width="8%" align="right">
                                                        <input id="txtimporte<%=i%>" name="txtimporte<%=i%>" type="hidden" value="<%=formato.format(det.getImporte())%>"/>
                                                        <span id="importe<%=i%>">
                                                        <%=formato.format(det.getImporte())%>
                                                        </span>
                                                    </td>
                                                    <% } if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                                                    <td width="8%" align="center">
                                                        <%=det.getImprimir()==1?"SÍ":"NO"%>
                                                    </td>
                                                    <%}
                                                    } else { %>
                                                        <td width="20%" align="center">
                                                            <%=det.getUnidad().getDescripcion()%>
                                                        </td>
                                                        <td width="20%" align="center">
                                                            <%=formato.format(det.getCantidad())%>
                                                        </td>
                                                        <td width="20%" align="center">
                                                            <input id="exfisica<%=i%>" name="exfisica<%=i%>" class="text" type="text" value="<%=formato.format(det.getImporte())%>"
                                                                   onkeypress="return ValidaCantidad2(event, this)" style="width: 150px; text-align: right" maxlength="10"
                                                                   tabindex="<%=i+2000%>"/>
                                                        </td>
                                                    <%}%>
                                                </tr>
                                                <%
                                                }
                                                }
                                            %>
                                            </tbody>
                                        </table>
                                        <!-- fin listado del detalle -->
                                        <br>
                                        <!--botones-->
                                        <table width="100%">
                                            <tr>
                                                <td width="35%" align="left">
                                                    &nbsp;
                                                </td>
                                                <td width="15%" align="left">
                                                    <div id="dvchkaplicacion" style="display: none">
                                                        <input id="aplicarinv" name="aplicarinv" type="checkbox" onclick="SolicitaFechaApli()">
                                                        <span class="etiqueta">Aplicar al Inventario</span>
                                                    </div>
                                                </td>
                                                <td width="25%" align="left"
                                                    <div id="dvfechaaplicacion" style="display: none">
                                                        <span class="etiqueta">Fecha de aplicación:</span>
                                                        <input id="fechaInv" name="fechaInv" type="text" class="text" readonly value="<%=shoy%>"
                                                            title="Ingrese la fecha de aplicación al inventario"/>
                                                    </div>
                                                </td>
                                                <td width="12%" align="right">
                                                    <a id="btnGuardar" href="javascript: GuardarClick()"
                                                        style="width: 150px; font-weight: bold; color: #0B610B; <%if (detalle.size()==0){%>display: none<%}%>" title="Guardar Movimiento">
                                                        Guardar
                                                    </a>
                                                    <!--
                                                    <style>#btnGuardar a{display:block;color:transparent;} #btnGuardar a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="btnGuardar" width=0 cellpadding=0 cellspacing=0 border=0 <%if (detalle.size()==0){%>style="display:none"<%}%>>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Guardar">
                                                                <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>-->
                                                </td>
                                                <td width="13%" align="right">
                                                    <a id="btnCancelar" href="javascript: CancelarClick()"
                                                        style="width: 150px; font-weight: bold; color: #FFFFFF;
                                                        background: indianred 50% bottom repeat-x;" title="Cancelar">
                                                        Cancelar
                                                    </a>
                                                    <!--
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>-->
                                                </td>
                                            </tr>
                                        </table><!-- fin botones -->
                                    </td> <!-- fin contenido -->
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
            
            function Confirmar(mensaje){
                var mens = document.getElementById('confirm');
                mens.textContent = mensaje;
                $( "#dialog-confirm" ).dialog( "open" );
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

            function Formatea(obj){
                obj.value = formato_numero(parseFloat(obj.value),2,'.',',');
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
                <%--
                if (tmovSel.getId()!=7 && tmovSel.getId()!=8){
                    if (datosS.get("accion").toString().equals("editar") || 
                        bandet == 1){
                        if (tmovSel.getCategoria()==1){
                    %>
                            CargaProveedor('<%=pr.getId()%>');
                    <%
                        } else {
                    %>
                            CargaCliente('<%=cli.getId()%>');
                    <%
                        }
                    }
                }--%>
                <%
                HttpSession sesionHttp = request.getSession();
                if (sesion.isError())
                    sesion.setError(false);
                if (sesion.isExito())
                    sesion.setExito(false);
                sesionHttp.setAttribute("sesion", sesion);
                
                if (datosS.get("accion").toString().equals("editar")
                    || detalle.size()>0){
                %>
                    var guardar = document.getElementById('btnGuardar');
                    guardar.style.display = '';
                    <%if (tmovSel.getId()>=6 && tmovSel.getId()<=8 || tmovSel.getId()==10
                            || tmovSel.getId()==20 || tmovSel.getId()==21 || tmovSel.getId()==25){%>
                        var divchk = document.getElementById('dvchkaplicacion');
                        divchk.style.display = '';
                <%
                    }
                }
                if (tmovSel.getId()==6){
                %>
                    var tbflete = document.getElementById('tbflete');
                    tbflete.style.display = '';
                <%}%>
            }
            
            function limpiar(nombreObj1, nombreObj2){
                obj = document.getElementById(nombreObj1);
                obj.value='';
                obj = document.getElementById(nombreObj2);
                obj.value='';
            }

            function cambiaFecha(fecha, nombreObj){
                d = fecha.substr(0,2);
                m = fecha.substr(3,2);
                y = fecha.substr(6,4);
                txtFecha = document.getElementById(nombreObj);
                txtFecha.value=y+'-'+m+'-'+d;
            }
            
            function CargaProveedor(prov){
                <%--
                if (tmovSel.getCategoria()==1 && tmovSel.getId()!=7 && tmovSel.getId()!=8){
                %>
                /*
                var datos = document.getElementById('datos');
                datos.style.display = 'none';
                var dir = document.getElementById('direccion');
                dir.value = '';
                var pob = document.getElementById('poblacion');
                pob.value = '';
                var rfc = document.getElementById('rfc');
                rfc.value = '';*/
                if (prov != ''){
                    datos.style.display = '';
                    <%
                    List<Proveedor> provs = (List<Proveedor>)datosS.get("proveedores");
                    for (int i=0; i < provs.size(); i++){
                        Proveedor prv = provs.get(i);
                    %>
                        if (prov == '<%=prv.getId()%>'){
                            dir.value = '<%=prv.getDatosfiscales().getDireccion().getCalle()%>, <%=prv.getDatosfiscales().getDireccion().getColonia()%>';
                            pob.value = '<%=prv.getDatosfiscales().getDireccion().getPoblacion().getMunicipio()%>, <%=prv.getDatosfiscales().getDireccion().getPoblacion().getEstado().getEstado()%>';
                            rfc.value = '<%=prv.getDatosfiscales().getRfc()%>';
                        }
                    <%
                    }
                    %>
                }
                <% } --%>
            }
            
            function CargaCliente(cliente){
                <%--
                if (tmovSel.getCategoria()==2 && tmovSel.getId()!=7 && tmovSel.getId()!=8
                    && (tmovSel.getId()!=20 || (tmovSel.getId()==20 && (bandet == 1 || bancon > 0 ||
                    datosS.get("accion").toString().equals("editar")))) &&
                    (tmovSel.getId()!=21 || (tmovSel.getId()==21 && (bandet == 1 || bancon > 0 ||
                    datosS.get("accion").toString().equals("editar"))))){
                %>
                /*
                var datos = document.getElementById('datos');
                datos.style.display = 'none';
                var dir = document.getElementById('direccion');
                dir.value = '';
                var pob = document.getElementById('poblacion');
                pob.value = '';
                var rfc = document.getElementById('rfc');
                rfc.value = '';*/
                if (cliente != ''){
                    datos.style.display = '';
                    <%
                    List<Cliente> clis = (List<Cliente>)datosS.get("clientes");
                    for (int i=0; i < clis.size(); i++){
                        Cliente cte = clis.get(i);
                    %>
                        if (cliente == '<%=cte.getId()%>'){
                            dir.value = '<%=cte.getDatosFiscales().getDireccion().getCalle()%>, <%=cte.getDatosFiscales().getDireccion().getColonia()%>';
                            pob.value = '<%=cte.getDatosFiscales().getDireccion().getPoblacion().getMunicipio()%>, <%=cte.getDatosFiscales().getDireccion().getPoblacion().getEstado().getEstado()%>';
                            rfc.value = '<%=cte.getDatosFiscales().getRfc()%>';
                        }
                    <%
                    }
                    %>
                }
                <% } else --%><%if (tmovSel.getId()==20 || tmovSel.getId()==21) {%>
                    //obtener los contratos del cliente
                    if (cliente != ''){
                        var frm = document.getElementById('frmNuevoMov');
                        frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                        frm.pasoSig.value = '-2';
                        frm.submit();                        
                    }
                <% } %>
            }
            
            function CargaCt(contrato){
                if(contrato != ''){
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                    frm.pasoSig.value = '-3';
                    frm.submit();                    
                }
            }

            function CancelarClick(){
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }

            function ValidaCabecera(){
                <%if (tmovSel.getId()==7 || tmovSel.getId()==8){%>
                     var mov = document.getElementById('movimiento');
                     if (mov.value == ''){
                         MostrarMensaje('El Movimiento no ha sido establecido');
                         return false;
                     }
                <%} else if (tmovSel.getCategoria()==1){%>
                     var prov = document.getElementById('proveedor');
                     if (prov.value == ''){
                         MostrarMensaje('El Proveedor no ha sido establecido');
                         return false;
                     }
                <%} else if (tmovSel.getCategoria()==2){%>
                     var cli = document.getElementById('cliente');
                     if (cli.value == ''){
                         MostrarMensaje('El Cliente no ha sido establecido');
                         return false;
                     }
                     <% if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                         var con = document.getElementById('contrato');
                         if (con.value == ''){
                             MostrarMensaje ('El Contrato no ha sido establecido');
                             return false;
                         }
                         var ct = document.getElementById('ct');
                         if (ct.value == ''){
                             MostrarMensaje ('El Centro de Trabajo no ha sido establecido');
                             return false;
                         }
                     <% } %>
                <% }
                if (tmovSel.getId()==6){%>
                        var folorig = document.getElementById('folioorig');
                        if (folorig.value == ''){
                            MostrarMensaje('El Folio Original está vacío');
                            return false;
                        }
                        
                        var flete = document.getElementById('flete');
                        if (flete.value == ''){
                            MostrarMensaje('El monto de flete está vacío');
                            return false;
                        }
                <%}
                if (tmovSel.getId()==25){%>
                    var descr = document.getElementById('descripcion');
                    if (descr.value == ''){
                        MostrarMensaje('La descripción del Levantamiento no ha sido escrita');
                        return false;
                    }
                <%}%>
                    var fecha = document.getElementById('fecha');
                    if (fecha.value == ''){
                        MostrarMensaje('La Fecha no ha sido establecida');
                        return false;
                    }
                return true;
            }
            
            function Activa(fila){
                <%if (tmovSel.getId()!=25){%>
                var acciones = document.getElementById('borrarEdit');
                acciones.style.display = '';
                <%}%>
                var idDet = document.getElementById('idDet');
                <%
                if (detalle.size()==1){
                %>
                    document.frmNuevoMov.radioDet.checked = true;
                    idDet.value = document.frmNuevoMov.radioDet.value;
                <%
                } else {
                %>
                    var radio = document.frmNuevoMov.radioDet[fila];
                    radio.checked = true;
                    idDet.value = radio.value;
                <% } %>
            }
            
            function NuevoClick(){
                if (ValidaCabecera()){
                    Espera();
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/agregardetalle.jsp';//nuevomovimientodet.jsp';
                    frm.pasoSig.value = '10';
                    frm.submit();
                }
            }

            function EditarClick(){
                Espera();
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimientodet.jsp';
                frm.pasoSig.value = '12';
                frm.submit();                
            }
            
            function EjecutarBaja(){
                Espera();
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                frm.pasoSig.value = '14';
                frm.submit();
            }

            function BajaClick(){
                mens = '¿Está seguro en dar de baja el producto seleccionado?';
                sels = 0;
                movs = '';
                <%for (int i=0; i < detalle.size(); i++){%>
                     var chk = document.getElementById('chkdet<%=i%>');
                     if (chk.checked){
                         sels++;
                         if (movs == '')
                             movs = chk.value;
                         else
                             movs += ','+chk.value;
                     }
                <%}%>
                var varios = document.getElementById('variosdet');
                if (sels>1){
                    mens = '¿Está seguro en dar de baja los productos seleccionados?';
                    varios.value = movs;
                } else if (sels==1){
                    //desmarca el chk que haya quedado activado
                    <%for (int i=0; i < detalle.size(); i++){%>
                        var chk = document.getElementById('chkdet<%=i%>');
                        if (chk.checked){
                            chk.checked = false;
                        }
                    <%}%>
                }
                var boton = document.getElementById('boton');
                boton.value = '1';
                Confirmar(mens);
                /*
                var frm = document.getElementById('frmNuevoMov');
                frm.paginaSig.value = '/Inventario/Movimientos/nuevomovimiento.jsp';
                frm.pasoSig.value = '14';
                frm.submit();*/
            }
            
            function ValidaMovimiento(){
                if (!ValidaCabecera())
                    return false;
                //valida cantidades del detalle
                <%if(tmovSel.getId()!=25){%>
                <%for (int i=0; i < detalle.size(); i++){%>
                    var cant = document.getElementById('cantidad<%=i%>');
                    if (cant.value==''){
                        MostrarMensaje('La cantidad del concepto <%=i+1%> no es válida');
                        return false;
                    }
                    
                    nCan = parseFloat(cant.value);
                    if (isNaN(nCan)){
                        MostrarMensaje('La cantidad del concepto <%=i+1%> no es válida');
                        return false;
                    }
                    
                    if (nCan<=0){
                        MostrarMensaje('La cantidad del concepto <%=i+1%> no es válida');
                        return false;
                    }
                <%}%>
                <%}%>
                
                <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8 && tmovSel.getId()!=25){%>
                nSubt = 0;               
                <%for (int i=0; i < detalle.size(); i++){
                    Detalle dt = detalle.get(i);
                    if (dt.getImprimir()==1){
                %>
                        var imp = document.getElementById('importe<%=i%>');
                        nImp = parseFloat(imp.firstChild.nodeValue.replace(',',''));
                        nSubt += nImp;
                <%  }
                }%>
                nSubt = Math.round(nSubt*100)/100
                <%if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                    //valida el tope de insumos
                    nTope = parseFloat('<%=sct.getTopeInsumos()%>');
                    if (nSubt>nTope){
                        MostrarMensaje ('El tope de insumos del CT actual ha sido excedido');
                        return false;
                    }
                <%}
                }%>
                //valida si fecha aplicacion inventario si esta activada
                var chkaplicar = document.getElementById('aplicarinv');
                if (chkaplicar.checked){
                    var fechainv = document.getElementById('fechaInv');
                    if (fechainv.value==''){
                        MostrarMensaje('No ha definido la fecha de aplicación al inventario');
                        return false;
                    }
                }
                
                <%if (tmovSel.getCategoria()==1 && tmovSel.getId()!=8){
                    for (int i=0; i < detalle.size(); i++){
                %>
                    var cos = document.getElementById('costo<%=i%>');
                    if (cos.value==''){
                        MostrarMensaje('El costo del concepto <%=i+1%> no es válido');
                        return false;
                    }
                    
                    nCan = parseFloat(cos.value);
                    if (isNaN(nCan)){
                        MostrarMensaje('El costo del concepto <%=i+1%> no es válido');
                        return false;
                    }
                    
                    if (nCan<=0){
                        MostrarMensaje('El costo del concepto <%=i+1%> no es válido');
                        return false;
                    }
                <%
                    }
                }
                %>
                
                <%if (tmovSel.getId()==25){
                    for (int i=0; i < detalle.size(); i++){%>
                        var exfis = document.getElementById('exfisica<%=i%>');
                        
                        if (exfis.value==''){
                            exfis.focus();
                            MostrarMensaje('La existencia ingresada del producto <%=i+1%> no es válida');
                            return false;
                        }
                        
                        nEx = parseFloat(exfis.value);
                        if (isNaN(nEx)){
                            exfis.focus();
                            MostrarMensaje('La existencia ingresada del producto <%=i+1%> no es válida');
                            return false;
                        }
                        
                        if (nEx<0){
                            exfis.focus();
                            MostrarMensaje('La existencia ingresada del producto <%=i+1%> no puede ser menor a cero');
                            return false;
                        }
                    <%}
                }%>
                
                return true;
            }

            function GuardarClick(){
                if (ValidaMovimiento()){
                    Espera();
                    var frm = document.getElementById('frmNuevoMov');
                    frm.paginaSig.value = '/Inventario/Movimientos/gestionarmovimientos.jsp';
                    frm.pasoSig.value = '3';
                    frm.submit();                
                }
            }
            
            function EditarCantsClick(){
                <%
                if (detalle.size()>0){
                    for (int i=0; i < detalle.size(); i++){
                %>
                        var etcant = document.getElementById('etcant<%=i%>');
                        var txtcant = document.getElementById('txtcant<%=i%>');
                        etcant.style.display = 'none';
                        txtcant.style.display = '';
                <%
                    }
                %>
                    var txt = document.getElementById('txtcant0');
                    txt.focus();
                    var btneditcant = document.getElementById('btnEditCant');
                    btneditcant.style.display = 'none';
                    var btnactcant = document.getElementById('btnActCant');
                    btnactcant.style.display = '';
                <% } %>
            }
            
            function SolicitaFechaApli(){
                var chkapli = document.getElementById('aplicarinv');
                var divfecha = document.getElementById('dvfechaaplicacion');
                divfecha.style.display = 'none';
                if (chkapli.checked)
                    divfecha.style.display = '';
            }
            
            function CalculaImporte(fila){
                <%if (tmovSel.getId()!=7 && tmovSel.getId()!=8){%>
                nf = parseInt(fila)+1;
                var cant = document.getElementById('cantidad'+fila);
                cant.value = formato_numero(parseFloat(cant.value),2,'.',',');
                <%if (tmovSel.getCategoria()==1){%>
                    var pu = document.getElementById('costo'+fila);
                <%}else{%>
                    var pu = document.getElementById('pu'+fila);
                <%}%>
                pu.value = formato_numero(parseFloat(pu.value),2,'.',',');
                var desc = document.getElementById('descto'+fila);
                var importe = document.getElementById('importe'+fila);
                var txtimp = document.getElementById('txtimporte'+fila);
                //valida la cantidad
                if (cant.value==''){
                    MostrarMensaje('La cantidad del concepto '+nf+' no es válida');
                    cant.focus();
                    return false;
                }
                nCan = parseFloat(cant.value.replace(',',''));
                if (isNaN(nCan)){
                    MostrarMensaje('La cantidad del concepto '+nf+' no es válida');
                    cant.focus();
                    return false;
                }

                if (nCan<=0){
                    MostrarMensaje('La cantidad del concepto '+nf+' no es válida');
                    cant.focus();
                    return false;
                }
                
                <%if (tmovSel.getCategoria()==1){%>
                    //valida costo
                    if (pu.value==''){
                        MostrarMensaje('El costo del concepto '+nf+' no es válido');
                        pu.focus();
                        return false;
                    }
                    nCos = parseFloat(pu.value);
                    if (isNaN(nCos)){
                        MostrarMensaje('El costo del concepto '+nf+' no es válido');
                        pu.focus();
                        return false;
                    }

                    if (nCos<=0){
                        MostrarMensaje('El costo del concepto '+nf+' no es válido');
                        pu.focus();
                        return false;
                    }
                <%}%>
                //calcula el importe
                <%if (tmovSel.getCategoria()==1){%>
                    nPu = parseFloat(pu.value.replace(',',''));
                <%} else {%>
                    nPu = parseFloat(pu.firstChild.nodeValue.replace(',',''));
                <%}%>
                ndes = parseFloat(desc.firstChild.nodeValue.replace(',',''));
                nImp = (nCan*nPu)-ndes;
                //innerHTML="newtext";
                importe.firstChild.nodeValue = formato_numero(nImp,2,'.',',');//Math.round(nImp*100)/100;
                txtimp.value = formato_numero(nImp,2,'.',',');//Math.round(nImp*100)/100;
                CalculaTotales(fila);
                <%}%>
            }
            
            function CalculaTotales(fila){
                nSubt = 0;
                nIva = 0;
                nDesc = 0;
                //nTot = 0;
                <%for (int i=0; i < detalle.size(); i++){%>
                        var imp = document.getElementById('importe<%=i%>');
                        var des = document.getElementById('descto<%=i%>');
                        nImp = parseFloat(imp.firstChild.nodeValue.replace(',',''));
                        nDes = parseFloat(des.firstChild.nodeValue.replace(',',''));
                        nSubt += nImp;
                        nDesc += nDes;
                <%}%>
                nIva = nSubt*0.16;
                var subt = document.getElementById('subt');
                var des = document.getElementById('descto');
                var iva = document.getElementById('iva');
                var tot = document.getElementById('tot');
                subt.firstChild.nodeValue = formato_numero(nSubt,2,'.',',');//Math.round(nSubt*100)/100;
                des.firstChild.nodeValue = formato_numero(nDesc,2,'.',',');//Math.round(nDesc*100)/100;
                iva.firstChild.nodeValue = formato_numero(nIva,2,'.',',');//Math.round(nIva*100)/100;
                tot.firstChild.nodeValue = formato_numero(nSubt+nIva,2,'.',',');//Math.round((nSubt+nIva)*100)/100;
                <%if (tmovSel.getId()==20 || tmovSel.getId()==21){%>
                    //valida el tope de insumos
                    
                    nTope = parseFloat('<%=sct.getTopeInsumos()%>');
                    if (nSubt>nTope){
                        var cant = document.getElementById('cantidad'+fila);
                        MostrarMensaje ('El tope de insumos del CT actual ha sido excedido, corrija la cantidad del concepto '+(parseInt(fila)+1));
                        cant.focus();
                    }
                <%}%>
            }
            
/*function ShowSelection(obj)
{
  var textComponent = obj;
  var selectedText;
  // IE version
  if (document.selection != undefined)
  {
    textComponent.focus();
    var sel = document.selection.createRange();
    selectedText = sel.text;
  }
  // Mozilla version
  else if (textComponent.selectionStart != undefined)
  {
    var startPos = textComponent.selectionStart;
    var endPos = textComponent.selectionEnd;
    selectedText = textComponent.value.substring(startPos, endPos)
  }
  //alert("You selected: " + selectedText);
  return selectedText;
}

function ValidaCantidad2(e, obj){
    txtsel = ShowSelection(obj);
    if (txtsel !=''){
        if (obj.value == txtsel){
            obj.value = '';
            return ValidaCantidad(e, obj.value);
        } else {
            return ValidaCantidad(e, obj.value);
        }
    } else {
        return ValidaCantidad(e, obj.value);
    }
}

function ValidaCantidad3(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length == 0 && (keychar == '.'))
        return false;
    var punto = cadena.indexOf('.');
    if (punto != -1 && keychar == '.')
        return false;
    if (punto != -1){
        var sub = cadena.substr(punto+1,10);
        if (sub.length >= 2)
            return false;
    }
    if (cadena.length >= 8 && keychar == '.')
        return false;
    
    reg = /[0-9.]/;
    return reg.test(keychar);
}*/
        </script>
    </body>
</html>