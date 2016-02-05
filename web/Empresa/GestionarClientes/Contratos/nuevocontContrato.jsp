<%-- 
    Document   : nuevocontContrato
    Created on : Oct 26, 2013, 12:15:15 PM
    Author     : marba
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
<%@page import="java.util.HashMap, Modelo.Entidades.Contrato"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<!DOCTYPE html>
<%
    HashMap datosS = sesion.getDatos();
    Contrato aa = (Contrato)datosS.get("clienteSel");
    int bb = (Integer)datosS.get("tipoContact");
 %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <link type="text/css" href="/siscaim/Estilos/formValidado.css" rel="stylesheet" />
        <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <title>Agregar un nuevo contacto</title>
    </head>
    <body>
        <table width="100%">
            <tr>
                <td width="20%">
                    <img src="/siscaim/Imagenes/Empresa/nuevo_contacto.png" width="80">
                </td>
                <td width="80%">
                    <div class="titulo" align="center">
                        NUEVO CONTACTO EN CONTRATO <%=aa.getContrato()%>                    
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form class="contact_form" id="frmNuevoContCliente" name="frmNuevoContCliente" action="<%=CONTROLLER%>/Gestionar/Contratos" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="idCli" name="idCli" type="hidden" value="<%=aa.getId()%>"/>
            <input id="tipoCont" name="tipoCont" type="hidden" value="<%=bb%>"/>
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
            <table  id="tablon">
                <tr>
                  <td width="60%">
                    Nombre (s):<br>
                    <input id="nombre" type="text" name="nombre" placeholder="Nombre(s)" required="asa" onblur="Mayusculas(this)" />
                    <br><br>
                    Apellidos :<br>
                    <input id="ap_paterno" type="text" name="ap_paterno" placeholder="Paterno" required="" onblur="Mayusculas(this)" />
                    <input id="ap_materno" type="text" name="ap_materno" placeholder="Materno" required="" onblur="Mayusculas(this)" />
                    <br><br>
                    <table>
                        <tr id="encabeza">
                            <td>E Mail :</td>
                            <td>Codigo Postal :</td>
                        </tr>
                        <td>
                            <input type="email" name="email" placeholder="ej. juan@example.com" required />
                            <span class="form_hint">Introduce un correo valido</span>
                        </td>
                        <td>
                            <input type="cp" name="cp" placeholder="" required />                            
                        </td>
                        </tr>
                    </table>
                    <table>
                        <tr id="encabeza">
                            <td>Calle y numero :</td>
                            <td>Colonia :</td>
                        </tr>
                        <td>
                            <input type="street" name="street" placeholder="calle #111" required onblur="Mayusculas(this)" />
                        </td>
                        <td>
                            <input type="colonia" name="colonia" placeholder="" required onblur="Mayusculas(this)" />                            
                        </td>
                        </tr>
                    </table>
                    <br>
                    <table>
                        <tr id="encabeza">
                            <td>Poblacion o Municipio :</td>
                            <td>Estado:</td>
                        </tr>
                        <td>
                            <input type="poblacion" name="poblacion" placeholder="" required onblur="Mayusculas(this)" />
                        </td>
                        <td>
                            <input type="estado" name="estado" placeholder="" required onblur="Mayusculas(this)" />                            
                        </td>
                        </tr>
                    </table>
                    <br>                    
                  </td>  
                  <td width="40%">
                    Celular :<br>  
                    <input id="celular" type="text" name="celular" placeholder="" required="" onblur="Mayusculas(this)" />
                    <span class="form_hint">Numero de movil personal</span>
                    <br><br>
                    Telefono 1:<br>
                    <input id="tel1" type="text" name="tel1" placeholder="" onblur="Mayusculas(this)" />
                    <span class="form_hint">Numero local</span>
                    <br><br>
                    Telefono 2:<br>
                    <input id="tel2" type="text" name="tel2" placeholder="" onblur="Mayusculas(this)" />
                    <span class="form_hint">Numero alternativo</span>
                    <br><br>
                    Notas :<br>
                    <textarea type="text" name="notas" placeholder="" rows="3" onblur="Mayusculas(this)"></textarea>
                    <span class="form_hint">Agrega informacion adicional</span>
                  </td>
                </tr>
            </table>
        </form>
    <script language="javascript">
        function CancelarClick(){
                var frm = document.getElementById('frmNuevoContCliente');
                frm.paginaSig.value = '/Empresa/GestionarClientes/contactoscliente.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
        }
        function GuardarClick()     {
            var resp = confirm('¿Está seguro de ingresar esta informacion?','SISCAIM');
            if(resp)    {
                var frm = document.getElementById('frmNuevoContCliente');
                frm.paginaSig.value = '/Empresa/GestionarClientes/Contratos/contactoscontrato.jsp';
                frm.pasoSig.value= '19';
                frm.submit();
            }
        }
    </script>    
    </body>
</html>
