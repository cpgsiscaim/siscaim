<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Cabecera"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliente = (Cliente)datosS.get("cliente");
    Contrato consel = datosS.get("contrato")!=null?(Contrato)datosS.get("contrato"):new Contrato();
    CentroDeTrabajo ctsel = datosS.get("ct")!=null?(CentroDeTrabajo)datosS.get("ct"):new CentroDeTrabajo();
    int paso = Integer.parseInt(datosS.get("paso").toString());
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
                        Resumen de Consumo<br>
                        CLIENTE:
                        <%if (cliente.getTipo()==0){%>
                        <%=cliente.getDatosFiscales().getRazonsocial()%><br>
                        <%}%>
                        <%if (cliente.getDatosFiscales().getPersona()!=null){%>
                        <%=cliente.getDatosFiscales().getPersona().getNombreCompleto()%>
                        <%}%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmConsumoCli" name="frmConsumoCli" action="<%=CONTROLLER%>/Gestionar/Clientes" method="post">
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
                                        <img src="/siscaim/Imagenes/Empresa/consumoA.png" align="center" width="300" height="250">
                                    </td>
                                    <td width="80%" valign="top">
                                        <table width="90%" align="right">
                                            <tr>
                                                <td width="20%" align="left">
                                                    <br>
                                                    <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                    <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Cancelar">
                                                                <a href="javascript: CancelarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/cancelar.png);width:150px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="40%" align="left">
                                                    <span class="etiquetaB">Contrato:</span><br>
                                                    <select id="contrato" name="contrato" class="combo" style="width: 350px"
                                                            onchange="CargaCentros(this.value)">
                                                        <option value="">Elija el Contrato...</option>
                                                        <option value="-1" <%if (consel.getId()==-1){%>selected<%}%>>TODOS</option>
                                                        <%
                                                        List<Contrato> contratos = (List<Contrato>)datosS.get("contratos");
                                                        for (int i=0; i < contratos.size(); i++){
                                                            Contrato con = contratos.get(i);
                                                        %>
                                                        <option value="<%=con.getId()%>"
                                                                <%if (con.getId()==consel.getId()){%>selected<%}%>>
                                                            <%=con.getContrato()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                                <td width="40%" align="left">
                                                    <span class="etiquetaB">C.T.:</span><br>
                                                    <select id="ct" name="ct" class="combo" style="width: 350px"
                                                            onchange="ObtenerMovimientos(this.value)">
                                                        <option value="">Elija el Centro de Trabajo...</option>
                                                        <option value="-1" <%if (ctsel.getId()==-1){%>selected<%}%>>TODOS</option>
                                                        <%
                                                        List<CentroDeTrabajo> centros = datosS.get("centros")!=null?(List<CentroDeTrabajo>)datosS.get("centros"):new ArrayList<CentroDeTrabajo>();
                                                        for (int i=0; i < centros.size(); i++){
                                                            CentroDeTrabajo ct = centros.get(i);
                                                        %>
                                                        <option value="<%=ct.getId()%>"
                                                                <%if (ct.getId()==ctsel.getId()){%>selected<%}%>>
                                                            <%=ct.getNombre()%>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                        <div id="contenido">
                                        <table id="listado" width="100%" align="center" class="tablaLista">
                                        <%
                                        List<Cabecera> movs = (List<Cabecera>)datosS.get("salidas");
                                        if ((movs==null || movs.isEmpty()) && paso == -2){
                                        %>
                                            <tr>
                                                <td colspan="4" align="center">
                                                    <span class="etiquetaB">
                                                        No se encontraron movimientos del Cliente
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                        <%
                                        } else if (paso == -2){
                                        %>
                                            <thead>
                                                <tr>
                                                    <td width="5%" align="center">
                                                        <span>Serie</span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span>Folio</span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span>Fecha</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Total</span>
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>Contrato</span>
                                                    </td>
                                                    <td width="25%" align="center">
                                                        <span>CT</span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span>Estatus</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                            List<String> tots = (List<String>)datosS.get("totales");
                                            for (int i=0; i < movs.size(); i++){
                                                Cabecera mov = movs.get(i);
                                                String tot = tots.get(i);
                                                String fecha = mov.getFechaCaptura().toString();
                                                String fechaN =fecha.substring(8,10) + "-" + fecha.substring(5,7) + "-" + fecha.substring(0, 4);
                                            %>
                                                <tr>
                                                    <td width="5%" align="center">
                                                        <span class="etiqueta">
                                                            <%=mov.getSerie().getSerie()%>
                                                        </span>
                                                    </td>
                                                    <td width="5%" align="center">
                                                        <span class="etiqueta">
                                                            <%=mov.getFolio()%>
                                                        </span>
                                                    </td>
                                                    <td width="10%" align="center">
                                                        <span class="etiqueta">
                                                            <%=fechaN%>
                                                        </span>
                                                    </td>
                                                    <td width="10%" align="right">
                                                        <span class="etiqueta">
                                                            <%=tot%>
                                                        </span>
                                                    </td>
                                                    <td width="20%" align="center">
                                                        <span class="etiqueta">
                                                            <%=mov.getContrato()!=null?mov.getContrato().getContrato():""%>
                                                        </span>
                                                    </td>
                                                    <td width="30%" align="left">
                                                        <span class="etiqueta">
                                                            <%=mov.getCentrotrabajo()!=null?mov.getCentrotrabajo().getNombre():""%>
                                                        </span>
                                                    </td>
                                                    <td width="15%" align="center">
                                                        <span class="etiqueta">
                                                            <%=mov.getEstatus()==1?"NO APLICADO":"APLICADO"%>
                                                        </span>
                                                    </td>
                                                </tr>

                                            <%
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                        <!-- botones siguiente anterior-->
                                        <%
                                        int grupos = Integer.parseInt(datosS.get("gruposcon").toString());
                                        if (grupos == 1){
                                            int sigs = Integer.parseInt(datosS.get("siguientescon").toString());
                                            int ants = Integer.parseInt(datosS.get("anteriorescon").toString());
                                        %>
                                        <hr id="lnDivDesplaz">
                                        <table id="tbDesplaz" width="100%">
                                            <tr>
                                                <td width="30%">&nbsp;</td>
                                                <td width="10%" align="center">
                                                    <style>#btnPrincipio a{display:block;color:transparent;} #btnPrincipio a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                    <table id="btnPrincipio" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ir al principio del listado">
                                                                <a href="javascript: PrincipioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/principio.png);width:70px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="10%" align="center">
                                                    <style>#btnAnterior a{display:block;color:transparent;} #btnAnterior a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                    <table id="btnAnterior" width=0 cellpadding=0 cellspacing=0 border=0 <%if (ants==0){%>style="display: none"<%}%>>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Anteriores">
                                                                <a href="javascript: AnteriorClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/anterior.png);width:70px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="10%" align="center">
                                                    <style>#btnSiguiente a{display:block;color:transparent;} #btnSiguiente a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                    <table id="btnSiguiente" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Siguientes">
                                                                <a href="javascript: SiguienteClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/siguiente.png);width:70px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="10%" align="center">
                                                    <style>#btnUltimo a{display:block;color:transparent;} #btnUltimo a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                    <table id="btnUltimo" width=0 cellpadding=0 cellspacing=0 border=0 <%if (sigs==0){%>style="display: none"<%}%>>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ir al final del listado">
                                                                <a href="javascript: FinalClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/final.png);width:70px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="30%">&nbsp;</td>
                                            </tr>
                                        </table>
                                        <%
                                        }
                                        %>
                                        <!--fin botones siguiente anterior-->
                                        <table id="tbTotalCon" width="100%" class="tablaLista">
                                            <thead>
                                                <tr>
                                                    <td width="100%" align="center">
                                                        <span>TOTAL CONSUMIDO: <%=datosS.get("totalcon").toString()%></span>
                                                    </td>
                                                </tr>
                                            </thead>
                                        </table>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="right">
                                                    <style>#btnResumen a{display:block;color:transparent;} #btnResumen a:hover{background-position:left bottom;}a#btnImprimira {display:none}</style>
                                                    <table id="btnResumen" width=0 cellpadding=0 cellspacing=0 border=0>
                                                        <tr>
                                                            <td style="padding-right:0px" title ="Ver Resumen por Mes">
                                                                <a href="javascript: ResumenClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/resumenmes.png);width:180px;height:30px;display:block;"><br/></a>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                                    <%--
                                        <hr id="lnDivAcum">
                                        <table id="tbAcum1" width="60%" class="tablaLista" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="100%" align="center" colspan="2">
                                                        <span>ACUMULADO MENSUAL</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td width="50%" align="right">
                                                        <span class="etiqueta">Año:</span>
                                                    </td>
                                                    <td width="50%" align="left">
                                                        <select id="anio" name="anio" class="combo" style="width: 150px">
                                                            <option value="0">TODOS</option>
                                                        <%
                                                        List<String> anios = (List<String>)datosS.get("anios");
                                                        for (int i=0; i < anios.size(); i++){
                                                            String anio = anios.get(i);
                                                        %>
                                                            <option value="<%=anio%>"><%=anio%></option>
                                                        <%
                                                        }
                                                        %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <table id="tbAcum2" width="60%" class="tablaLista" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="30%" align="center">
                                                        <span>AÑO</span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span>MESES</span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span>TOTAL</span>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <%
                                            List<HashMap> meses = (List<HashMap>)datosS.get("meses");
                                            for (int i=0; i < meses.size(); i++){
                                                HashMap mesanio = meses.get(i);
                                                String anio = mesanio.get("anio").toString();
                                                List<String> ms = (List<String>)mesanio.get("meses");
                                                List<String> totsm = (List<String>)mesanio.get("totalesmes");
                                                for (int m=0; m < ms.size(); m++){
                                                    int mes = Integer.parseInt(ms.get(m));
                                                    String nmes = "";
                                                    switch(mes){
                                                        case 0:
                                                            nmes = "ENERO";
                                                            break;
                                                        case 1:
                                                            nmes = "FEBRERO";
                                                            break;
                                                        case 2:
                                                            nmes = "MARZO";
                                                            break;
                                                        case 3:
                                                            nmes = "ABRIL";
                                                            break;
                                                        case 4:
                                                            nmes = "MAYO";
                                                            break;
                                                        case 5:
                                                            nmes = "JUNIO";
                                                            break;
                                                        case 6:
                                                            nmes = "JULIO";
                                                            break;
                                                        case 7:
                                                            nmes = "AGOSTO";
                                                            break;
                                                        case 8:
                                                            nmes = "SEPTIEMBRE";
                                                            break;
                                                        case 9:
                                                            nmes = "OCTUBRE";
                                                            break;
                                                        case 10:
                                                            nmes = "NOVIEMBRE";
                                                            break;
                                                        case 11:
                                                            nmes = "DICIEMBRE";
                                                            break;
                                                    }
                                            %>
                                                <tr>
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%=anio%></span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%=nmes%></span>
                                                    </td>
                                                    <td width="30%" align="right">
                                                        <span class="etiqueta"><%=totsm.get(m)%></span>
                                                    </td>
                                                </tr>
                                            <% 
                                                }
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                        --%>
                                        <%
                                        }
                                        %>
                                        </div>
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

            function CargaCentros(contrato){
                if (contrato!=''){
                    var frm = document.getElementById('frmConsumoCli');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                    frm.pasoSig.value = '-1';
                    frm.submit();
                } else {
                    var ct = document.getElementById('ct');
                    ct.length = 0;
                    ct.options[0] = new Option ('Elija el Centro de Trabajo...','');
                    var cont = document.getElementById('contenido');
                    cont.style.display = 'none';
                }
            }
            
            function ObtenerMovimientos(ct){
                if (ct!=''){
                    var frm = document.getElementById('frmConsumoCli');
                    frm.paginaSig.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                    frm.pasoSig.value = '-2';
                    frm.submit();
                } else {
                    var cont = document.getElementById('contenido');
                    cont.style.display = 'none';
                }
            }

            function CancelarClick(){
                var frm = document.getElementById('frmConsumoCli');
                frm.paginaSig.value = '/Empresa/GestionarClientes/gestionarclientes.jsp';
                frm.pasoSig.value = '95';
                frm.submit();
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmConsumoCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                paso.value = '62';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmConsumoCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                paso.value = '61';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmConsumoCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                paso.value = '60';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmConsumoCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                paso.value = '63';
                frm.submit();                
            }
            
            function ResumenClick(){
                var frm = document.getElementById('frmConsumoCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/resumenmens.jsp';
                paso.value = '15';
                frm.submit();                
            }
        </script>
    </body>
</html>