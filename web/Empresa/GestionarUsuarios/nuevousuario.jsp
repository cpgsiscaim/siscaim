<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.HashMap, java.util.List, Modelo.Entidades.Usuario, Modelo.Entidades.Sucursal, Modelo.Entidades.Empleado"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    HashMap datosS = sesion.getDatos();
    Sucursal sucSel = (Sucursal)datosS.get("sucursalSel");
    List<Empleado> empleados = (List<Empleado>)datosS.get("empleados");
    String titulo = "Nuevo Usuario";
    String imagen = "usuariosB.png";
    Usuario usu = new Usuario();
    Empleado semp = new Empleado();
    String susu = "", mail = "";
    if (datosS.get("accion").toString().equals("editar")){
        titulo = "Editar Usuario";
        imagen = "usuariosC.png";
        usu = (Usuario) datosS.get("usuario");
        semp = usu.getEmpleado();
        susu = usu.getUsuario();
        mail = usu.getMailrecuperacion();
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
                        Gestionar Usuarios - <%=titulo%><br>
                        SUCURSAL: <%=sucSel.getDatosfis().getRazonsocial()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="frmNuevoUsu" name="frmNuevoUsu" action="<%=CONTROLLER%>/Gestionar/Usuarios" method="post">
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
                                        <img src="/siscaim/Imagenes/Empresa/<%=imagen%>" align="center" width="280" height="200">
                                    </td>
                                    <td width="70%" valign="top">
                                        <%if (empleados.isEmpty()){%>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%" align="center">
                                                    <span class="etiquetaB">
                                                        No hay Empleados disponibles para crear usuario
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                        <%} else {%>
                                        <table width="100%">
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Empleado:</span><br>
                                                    <select id="empleado" name="empleado" class="combo" style="width: 500px">
                                                        <option value="">Elija el Empleado...</option>
                                                    <%
                                                        for (int i=0; i < empleados.size(); i++){
                                                            Empleado emp = empleados.get(i);
                                                    %>
                                                            <option value="<%=emp.getNumempleado()%>"
                                                                <%if (emp.getNumempleado()==semp.getNumempleado()){%>
                                                                     selected
                                                                <%}%>>
                                                                <%=emp.getPersona().getNombreCompleto()%>
                                                            </option>
                                                    <%
                                                    }
                                                    %>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Usuario:</span><br>
                                                    <input id="usuario" name="usuario" type="text" value="<%=susu%>" style="width: 200px" maxlength="20"
                                                        onkeypress="return ValidaAlfaNum(event)"/> 
                                                    <span class="etiquetaC">Mínimo 8 caracteres, letras y/o números</span> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Contraseña:</span><br> 
                                                    <input id="pass" name="pass" type="password" value="" style="width: 200px" maxlength="20"
                                                        onkeypress="return ValidaAlfaNum(event)"/>
                                                    <span class="etiquetaC">Mínimo 8 caracteres, letras y/o números</span> 
                                                </td> 
                                            </tr>
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Confirmar Contraseña:</span><br> 
                                                    <input id="passconfirm" name="passconfirm" type="password" value="" style="width: 200px" maxlength="20"
                                                        onkeypress="return ValidaAlfaNum(event)"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%">
                                                    <span class="etiqueta">Correo Electrónico:</span><br> 
                                                    <input id="mail" name="mail" type="text" value="<%=mail%>" style="width: 200px" maxlength="20"
                                                        onkeypress="return ValidaMail(event, this.value)"/>
                                                    <span class="etiquetaC">Este correo será utilizado para recuperar sus datos de acceso</span> 
                                                </td>
                                            </tr>
                                        </table>
                                        <% } %>
                                    </td>
                                </tr>
                            </table>
                            <br><br>
                            <!--botones-->
                            <table width="100%">
                                <tr>
                                    <td width="80%" align="right">
                                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0 <%if (empleados.isEmpty()){%>style="display: none"<%}%>>
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
                var frm = document.getElementById('frmNuevoUsu');
                frm.paginaSig.value = '/Empresa/GestionarUsuarios/gestionarusuarios.jsp';
                frm.pasoSig.value = '98';
                frm.submit();
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    var frm = document.getElementById('frmNuevoUsu');
                    frm.paginaSig.value = '/Empresa/GestionarUsuarios/gestionarusuarios.jsp';
                <%
                    if (datosS.get("accion").toString().equals("editar")){
                %>
                        frm.pasoSig.value = '5';
                <%
                    } else {
                %>
                        frm.pasoSig.value = '3';
                <%
                    }
                %>
                    frm.submit();
                }
            }
            
            function ValidaRequeridos(){
                var empleado = document.getElementById('empleado');
                if (empleado.value == ''){
                    Mensaje('El campo Empleado no ha sido establecido');
                    return false;
                }
                
                var usuario = document.getElementById('usuario');
                if (usuario.value == ''){
                    Mensaje('El campo Usuario está vacío');
                    usuario.focus();
                    return false;
                }
                
                if (usuario.value.length < 8){
                    Mensaje('El número de caracteres mínimo no se cumple en el campo Usuario');
                    usuario.focus();
                    return false;
                }
                
                var pass = document.getElementById('pass');
                if (pass.value == ''){
                    Mensaje('El campo Contraseña está vacío');
                    pass.focus();
                    return false;
                }
                
                var passconf = document.getElementById('passconfirm');
                if (passconf.value == ''){
                    Mensaje('El campo Confirmar Contraseña está vacío');
                    passconf.focus();
                    return false;
                }
                
                if (pass.value != passconfirm.value){
                    Mensaje('La Confirmación de la Contraseña no coincide');
                    pass.value = '';
                    passconf.value = '';
                    pass.focus();
                    return false;
                }
                
                if (pass.value.length < 8){
                    Mensaje('El número de caracteres mínimo no se cumple en el campo Contraseña');
                    pass.focus();
                    return false;                    
                }

                var mail = document.getElementById('mail');
                if (mail.value == ''){
                    Mensaje('El campo Correo Electrónico está vacío');
                    mail.focus();
                    return false;
                }
                
                return true;
            }
        
        </script>
    </body>
</html>