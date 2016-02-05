<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Cliente, Modelo.Entidades.Contrato, Modelo.Entidades.CentroDeTrabajo, Modelo.Entidades.Cabecera"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Cliente cliente = (Cliente)datosS.get("cliente");
    Contrato consel = (Contrato)datosS.get("contrato");
    CentroDeTrabajo ctsel = (CentroDeTrabajo)datosS.get("ct");
    String aniosel = datosS.get("aniores")!=null?datosS.get("aniores").toString():"0";
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
                        Resumen Mensual de Consumo<br>
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
        <form id="frmResumenCli" name="frmResumenCli" action="<%=CONTROLLER%>/Gestionar/Clientes" method="post">
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
                                                <td width="20%">
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
                                                    <span class="subtitulo">CONTRATO:</span>
                                                    <span class="subtitulo"><%=consel.getId()!=-1?consel.getContrato():"TODOS"%></span>
                                                </td>
                                                <td width="40%" align="left">
                                                    <span class="subtitulo">C.T.:</span>
                                                    <span class="subtitulo"><%=ctsel.getId()!=-1?ctsel.getNombre():"TODOS"%></span>
                                                </td>
                                            </tr>
                                        </table>
                                        <hr>
                                        <div id="contenido">
                                        <table id="tbAcum1" width="60%" class="tablaLista" align="center">
                                            <thead>
                                                <tr>
                                                    <td width="50%" align="right">
                                                        <span>Año:</span>
                                                    </td>
                                                    <td width="50%" align="left">
                                                        <select id="aniores" name="aniores" class="combo" style="width: 150px"
                                                                onchange="MostrarAnio()">
                                                        <%
                                                        List<String> anios = (List<String>)datosS.get("anios");
                                                        if (anios.size()>1){
                                                        %>
                                                        <option value="0"<%if (aniosel.equals("0")){%>selected<%}%>>TODOS</option>
                                                        <%
                                                        }
                                                        for (int i=0; i < anios.size(); i++){
                                                            String anio = anios.get(i);
                                                        %>
                                                            <option value="<%=anio%>"<%if (aniosel.equals(anio)){%>selected<%}%>><%=anio%></option>
                                                        <%
                                                        }
                                                        %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </thead>
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
                                            List<HashMap> meses = (List<HashMap>)datosS.get("resumen");
                                            for (int i=0; i < meses.size(); i++){
                                                HashMap item = meses.get(i);
                                                String anio = item.get("anio").toString();
                                                int mes = Integer.parseInt(item.get("mes").toString());
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
                                                String tot = item.get("total").toString();
                                            %>
                                                <tr>
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%=anio%></span>
                                                    </td>
                                                    <td width="30%" align="center">
                                                        <span class="etiqueta"><%=nmes%></span>
                                                    </td>
                                                    <td width="30%" align="right">
                                                        <span class="etiqueta"><%=tot%></span>
                                                    </td>
                                                </tr>
                                            <% 
                                            }
                                            %>
                                            </tbody>
                                        </table>
                                            
                                        <!-- botones siguiente anterior-->
                                        <%
                                        int grupos = Integer.parseInt(datosS.get("gruposres").toString());
                                        if (grupos == 1){
                                            int sigs = Integer.parseInt(datosS.get("siguientesres").toString());
                                            int ants = Integer.parseInt(datosS.get("anterioresres").toString());
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

            function CancelarClick(){
                var frm = document.getElementById('frmResumenCli');
                frm.paginaSig.value = '/Empresa/GestionarClientes/consumocliente.jsp';
                frm.pasoSig.value = '94';
                frm.submit();
            }
            
            function SiguienteClick(){
                var frm = document.getElementById('frmResumenCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/resumenmens.jsp';
                paso.value = '72';
                frm.submit();                
            }

            function AnteriorClick(){
                var frm = document.getElementById('frmResumenCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/resumenmens.jsp';
                paso.value = '71';
                frm.submit();                
            }

            function PrincipioClick(){
                var frm = document.getElementById('frmResumenCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/resumenmens.jsp';
                paso.value = '70';
                frm.submit();                
            }

            function FinalClick(){
                var frm = document.getElementById('frmResumenCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/resumenmens.jsp';
                paso.value = '73';
                frm.submit();                
            }
            
            function MostrarAnio(){
                var frm = document.getElementById('frmResumenCli');
                var pagina = document.getElementById('paginaSig');
                var paso = document.getElementById('pasoSig');
                pagina.value = '/Empresa/GestionarClientes/resumenmens.jsp';
                paso.value = '16';
                frm.submit();                
            }
            
        </script>
    </body>
</html>