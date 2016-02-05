<%@page import="java.lang.String"%>
<%
String logo = "";
if (matriz != null){
    logo = matriz.getEmpresa().getLogo();
}
int paso = Integer.parseInt(datosS.get("paso").toString());
if (logo == null || logo == "" || paso == 42){
    logo = "logodefault.png";
}
if (paso==41){
    logo = "Empresa/"+datosS.get("nuevoLogo").toString();
}

%>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="60%" valign="top" align="center" valign="center">
            <span class="etiqueta">Logotipo:</span><br>
            <input id="logoEmpr" name="logoEmpr" type="hidden" value="<%=logo%>"/>
            <img src="/siscaim/Imagenes/<%=logo%>" width="400" height="250" border="1"/>
        </td>
        <td width="50%" align="left" valign="center">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Cargar Logotipo">
                                    <a href="javascript: NuevoLogoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <%--
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Rotar Imagen 90° a la derecha">
                                    <a href="javascript: RotarClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/rotar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                --%>
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Borrar Logotipo">
                                    <a href="javascript: BorrarLogoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/borrar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
</table>
<script lang="javascript1.2">   
    function NuevoLogoClick(){
        var paginaSig = document.getElementById('paginaSig');
        paginaSig.value = '/Empresa/ConfigurarEmpresa/nuevologoempr.jsp';
        var pasoSig = document.getElementById('pasoSig');
        pasoSig.value = '40';
        var frm = document.getElementById('frmConfigurarEmpr');
        frm.submit();
    }
    
    function BorrarLogoClick(){
        var logoEmpr = document.getElementById('logoEmpr');
        if (logoEmpr.value == 'logodefault.png'){
            return;
        }
        var paginaSig = document.getElementById('paginaSig');
        paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
        var pasoSig = document.getElementById('pasoSig');
        pasoSig.value = '42';
        var frm = document.getElementById('frmConfigurarEmpr');
        frm.submit();        
    }
</script>