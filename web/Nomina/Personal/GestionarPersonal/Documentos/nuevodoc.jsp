<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.List, java.util.HashMap, Modelo.Entidades.Empleado, Modelo.Entidades.Documento, Modelo.Entidades.Catalogos.CategoriaDoc, Modelo.Entidades.Catalogos.TipoDocumento"%>

<%@include file="/IniciarSistema/Inicializa.jsp" %>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />

<%
HashMap datosS = sesion.getDatos();
int paso = Integer.parseInt(datosS.get("paso").toString());
Empleado empl = (Empleado)datosS.get("empleado");
List<CategoriaDoc> categorias = (List<CategoriaDoc>)datosS.get("categorias");
List<TipoDocumento> tiposdocs = (List<TipoDocumento>)datosS.get("tiposdocs");
String docsel = "default.png", descor = "", deslar = "", display = "none";
CategoriaDoc cats = datosS.get("categoria")!=null?(CategoriaDoc)datosS.get("categoria"):new CategoriaDoc();
TipoDocumento tipodocs = datosS.get("tipodoc")!=null?(TipoDocumento)datosS.get("tipodoc"):new TipoDocumento();
Documento doc = datosS.get("documento")!=null?(Documento)datosS.get("documento"):new Documento();
if (tipodocs.getEstatus()==2){
    descor = datosS.get("desccorta").toString();
    deslar = datosS.get("desclarga").toString();
    display = "";
}
if (paso == 2){
    docsel = datosS.get("docSel")!=null?"/Temp/"+datosS.get("docSel").toString():"default.png";
    //docsel = datosS.get("docSel")!=null?"/"+empl.getNumempleado()+"/"+cats.getDescripcion()+"/"+datosS.get("docSel").toString():"default.png";
} else if (paso == 3){
    docsel = "/"+doc.getImagen();
}

/*if (datosS.get("accion").toString().equals("editar")){
    Documento doc = (Documento)datosS.get("documento");
    docsel = doc.getEmpleado().getNumempleado()+"/"+doc.getTipodoc().getCategoria().getDescripcion()+"/"+doc.getImagen();
}*/
//String ruta = datosS.get("rutafoto").toString()+"\\"+fotoSel;
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
                <td width="20%" align="center" valign="center">
                    <img src="/siscaim/Imagenes/Personal/docsA.png" align="center" width="180" height="100">
                </td>
                <td width="80%" align="center" valign="center">
                    <div class="bigtitulo" align="center">
                        <%if (datosS.get("accion").toString().equals("editar")){%>
                        EDITAR
                        <%}else{%>
                        NUEVO
                        <%}%>
                        DOCUMENTO DE EMPLEADO
                    </div>
                    <div class="titulo" align="center">
                        EMPLEADO: <%=empl.getPersona().getNombreCompletoPorApellidos()%>
                    </div>
                </td>
            </tr>
        </table>
        <hr>
        <form id="fmrNuevoDocAlt" name="fmrNuevoDocAlt" action="<%=CONTROLLER%>/Gestionar/Documentos" method="post">
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="docNuevo" name="docNuevo" type="hidden" value=""/>
            <input id="categoria" name="categoria" type="hidden" value=""/>
            <input id="tipodoc" name="tipodoc" type="hidden" value=""/>
            <input id="descripcorta" name="descripcorta" type="hidden" value=""/>
            <input id="descriplarga" name="descriplarga" type="hidden" value=""/>
        </form>
            
        <form id="fmrNuevoDoc" name="fmrNuevoDoc" action="<%=CONTROLLER%>/Nuevo/Documento" enctype="multipart/form-data" method="post">
            <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
            <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
            <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
            <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
            <input id="docNuevo" name="docNuevo" type="hidden" value=""/>
            <input id="banotro" name="banotro" type="hidden" value="0"/>
            <table width="100%">
                <tr>
                    <td width="100%">
                        <div class="titulo" align="center">
                            <table width="100%">
                                <tr>
                                    <td width="100%" valign="center">
                                        <table width="70%" align="center">
                                            <tr>
                                                <td width="100%">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="30%">
                                                                <span class="etiquetaB">Categor&iacute;a:</span><br>
                                                                <select id="categoria" name="categoria" class="combo" style="width: 250px"
                                                                        onchange="CargaTipos(this.value)">
                                                                    <option value="">Elija la Categor&iacute;a...</option>
                                                                    <%for (int i=0; i < categorias.size(); i++){ 
                                                                        CategoriaDoc cat = categorias.get(i);
                                                                    %>
                                                                    <option value="<%=cat.getId()%>" <%if (cats.getId()==cat.getId()){%>selected<%}%>>
                                                                        <%=cat.getDescripcion()%>
                                                                    </option>
                                                                    <%}%>
                                                                </select>
                                                            </td>
                                                            <td width="30%">
                                                                <span class="etiquetaB">Tipo de Documento:</span><br>
                                                                <select id="tipodoc" name="tipodoc" class="combo" style="width: 250px"
                                                                        onchange="MuestraDescripcion(this.value)">
                                                                    <option value="">Elija el Tipo de Documento...</option>
                                                                </select>
                                                            </td>
                                                            <td width="40%">
                                                                <div id="dvdescricorta" style="display: <%=display%>">
                                                                    <span class="etiquetaB">Descripci&oacute;n corta:</span><br>
                                                                    <input id="descripcorta" name="descripcorta" type="text" style="width: 120px"
                                                                           onblur="Mayusculas(this)" maxlength="20" value="<%=descor%>"/>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%" colspan="3">
                                                                <div id="dvdescrilarga" style="display: <%=display%>">
                                                                    <span class="etiquetaB">Descripci&oacute;n larga:</span><br>
                                                                    <input id="descriplarga" name="descriplarga" type="text" style="width: 670px"
                                                                           onblur="Mayusculas(this)" maxlength="100" value="<%=deslar%>"/>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" align="left">
                                                    <span class="etiqueta">Imagen:</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" align="left">
                                                    <input id="docFile" name="docFile" type="file" accept="images/*.png"
                                                           onchange="CargaImagen(this.value)" style="display: none">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="100%" align="center">
                                                    <table width="100%">
                                                        <tr>
                                                            <td width="70%" align="left">
                                                                <img id="previa" name="previa" src="/siscaim/Imagenes/Personal/Documentos/<%=docsel%>"
                                                                    align="center" width="300" height="250">
                                                            </td>
                                                            <td width="30%" align="center" valign="bottom">
                                                                <!--botones-->
                                                                <table width="100%">
                                                                    <tr>
                                                                        <td width="50%" align="right">
                                                                            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                                                                            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                                                                                <tr>
                                                                                    <td style="padding-right:0px" title ="Guardar">
                                                                                        <a href="javascript: GuardarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/guardar.png);width:150px;height:30px;display:block;"><br/></a>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td width="50%">
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
                                                            </td>
                                                        </tr>
                                                    </table>
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
                if (paso==2 || paso == 3){
                %>
                    CargaTipos('<%=cats.getId()%>');
                    MuestraDescripcion('<%=tipodocs.getId()%>');
                <%}
                %>
            }
            
            function ValidaRequeridos(){
                var frm = document.getElementById('fmrNuevoDoc');
                var categoria = frm.categoria;
                if (categoria.value == ''){
                    Mensaje('La Categoría del Documento no ha sido definida');
                    return false;
                }
                
                var tipodoc = frm.tipodoc;
                if (tipodoc.value == ''){
                    Mensaje('El Tipo de Documento no ha sido definido');
                    return false;
                }
                
                var banotro = document.getElementById('banotro');
                if (banotro.value == '1'){
                    var descor = frm.descripcorta;
                    if (descor.value == ''){
                        Mensaje('Debe escribir una descripción corta');
                        descor.focus();
                        return false;
                    }
                }
                
                return true;
            }
            
            function GuardarClick(){
                if (ValidaRequeridos()){
                    <%
                    if (datosS.get("docSel")==null){
                    %>
                            Mensaje('Debe seleccionar el archivo de la imagen del documento');
                            return;
                    <%
                    }
                    %>
                    //var frm = document.getElementById('fmrNuevoDocAlt');
                    var frm2 = document.getElementById('fmrNuevoDoc');
                    /*frm.docNuevo.value = '<%=docsel%>';
                    frm.categoria.value = frm2.categoria.value;
                    frm.tipodoc.value = frm2.tipodoc.value;
                    frm.descripcorta.value = frm2.descripcorta.value;
                    frm.descriplarga.value = frm2.descriplarga.value;*/
                    frm2.pasoSig.value = '4';
                    frm2.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                    frm2.submit();
                }
            }
            
            function CargaImagen(archivo){
                tokens = archivo.split('\\');
                nombreArch = tokens[tokens.length-1];
                tokensNom = nombreArch.split('.');
                exten = tokensNom[1];
                if (exten.toLowerCase().trim() != 'jpg'){
                    Mensaje('La extensión del archivo debe ser jpg');
                    return;
                }
                
                var frm = document.getElementById('fmrNuevoDoc');
                frm.docNuevo.value=nombreArch;
                frm.pasoSig.value = '2';
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Documentos/nuevodoc.jsp';
                frm.submit();
            }
            
            function CancelarClick(){
                var frm = document.getElementById('fmrNuevoDocAlt');
                frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/Documentos/documentos.jsp';
                frm.pasoSig.value = '97';
                frm.submit();
            }
            
            function CargaTipos(cate){
                var dvdescricorta = document.getElementById('dvdescricorta');
                dvdescricorta.style.display = 'none';
                var dvdescrilarga = document.getElementById('dvdescrilarga');
                dvdescrilarga.style.display = 'none';
                var frm = document.getElementById('fmrNuevoDoc');
                var tipodoc = frm.tipodoc;
                tipodoc.length = 0;
                tipodoc.options[0] = new Option('Elija el Tipo de Documento...','');
                k=1;
                if (cate != 0){
                <%for (int i=0; i < tiposdocs.size(); i++){
                    TipoDocumento tipo = tiposdocs.get(i);
                %>
                    if (cate == '<%=tipo.getCategoria().getId()%>'){
                        tipodoc.options[k] = new Option('<%=tipo.getDescripcion()%>','<%=tipo.getId()%>');
                        <%if (tipodocs.getId()==tipo.getId()){%>
                            tipodoc.options[k].selected = true;
                        <%}%>
                        k++;
                    }
                <%}%>
                }
                var docfile = document.getElementById('docFile');
                docfile.style.display = 'none';
                var docnvo = frm.docNuevo;
                docnvo.value = '';
            }
            
            function MuestraDescripcion(tipo){
                var dvdescricorta = document.getElementById('dvdescricorta');
                dvdescricorta.style.display = 'none';
                var dvdescrilarga = document.getElementById('dvdescrilarga');
                dvdescrilarga.style.display = 'none';
                var frm = document.getElementById('fmrNuevoDoc');
                var txtdescricorta = frm.descripcorta;
                var txtdescrilarga = frm.descriplarga;
                txtdescricorta.value = '';
                txtdescrilarga.value = '';
                var banotro = document.getElementById('banotro');
                banotro.value = '0';
                <%for (int i=0; i < tiposdocs.size(); i++){
                    TipoDocumento tipo = tiposdocs.get(i);
                %>
                    if (tipo == '<%=tipo.getId()%>' && '<%=tipo.getEstatus()%>' == '2'){
                        dvdescricorta.style.display = '';
                        dvdescrilarga.style.display = '';
                        banotro.value = '1';
                        txtdescricorta.value = '<%=descor%>';
                        txtdescrilarga.value = '<%=deslar%>';
                        txtdescricorta.focus();
                    }
                <%}%>
                var docfile = document.getElementById('docFile');
                docfile.style.display = 'none';
                if (tipo!='' && tipo!='0')
                    docfile.style.display = '';
            }
        </script>
    </body>
</html>