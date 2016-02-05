<%@page import="java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Medio, Modelo.Entidades.Catalogos.TipoMedio"%>
<%
List<Medio> listaMedios = new ArrayList<Medio>();
List<Medio> actuales = new ArrayList<Medio>();
List<Medio> nuevos = new ArrayList<Medio>();
List<Medio> editados = new ArrayList<Medio>();
List<Medio> borrados = new ArrayList<Medio>();
if (datosS.containsKey("editarSuc")){
    Sucursal edSuc = (Sucursal)datosS.get("editarSuc");
    actuales = edSuc.getMedios();
}
    
if (datosS.containsKey("mediosNuevos"))
    nuevos = (List<Medio>)datosS.get("mediosNuevos");
if (datosS.containsKey("mediosEditados"))
    editados = (List<Medio>)datosS.get("mediosEditados");
if (datosS.containsKey("mediosBorrados"))
    borrados = (List<Medio>)datosS.get("mediosBorrados");

for (int i=0; i < actuales.size(); i++){
    Medio act = actuales.get(i);
    boolean borrado = false;
    for (int b=0; b < borrados.size(); b++){
        Medio bo = borrados.get(b);
        if (bo.getId()==act.getId()){
            borrado = true;
            break;
        }
    }
    if (!borrado){
        boolean editado = false;
        for (int j=0; j < editados.size(); j++){
            Medio edit = editados.get(j);
            if (edit.getId()==act.getId()){
                listaMedios.add(edit);
                editado = true;
                break;
            }
        }
        if (!editado)
            listaMedios.add(act);
    }
}
for (int j=0; j < nuevos.size(); j++){
    listaMedios.add(nuevos.get(j));
}
%>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="60%" valign="top" align="center" valign="center">
            <span class="etiqueta">Medios:</span><br>
            <select id="mediosSuc" name="mediosSuc" size="6" style="width: 400px">
                <%
                for (int i=0; i < listaMedios.size(); i++){
                    Medio med = listaMedios.get(i);
                    %>
                    <option value="<%=med.getId()%>" title="(<%=med.getTipo().getTipomedio()%>) - <%=med.getMedio()%>">
                        (<%=med.getTipo().getTipomedio()%>) - <%=med.getMedio()%>
                    </option>
                    <%
                }
                %>
            </select>
        </td>
        <td width="50%" align="left" valign="bottom">
            <table width="100%">
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Nuevo Medio">
                                    <a href="javascript: NuevoMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Editar Medio">
                                    <a href="javascript: ModificarMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Borrar Medio">
                                    <a href="javascript: EliminarMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/borrar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<script lang="javascript1.2">   
    function NuevoMedioClick(){
        var paginaSig = document.getElementById('paginaSig');
        paginaSig.value = '/Empresa/GestionarSucursales/nuevomediosuc.jsp';
        var pasoSig = document.getElementById('pasoSig');
        pasoSig.value = '10';
        var frm = document.getElementById('frmNuevaSuc');
        frm.submit();
    }
    
    function ModificarMedioClick(){
        var listaMedios = document.getElementById('mediosSuc');
        if (listaMedios.length == 0){
            return;
        }
        if (listaMedios.selectedIndex==-1){
            Mensaje('Debe seleccionar el medio que desea editar');
            return;
        }
        else {
            var paginaSig = document.getElementById('paginaSig');
            paginaSig.value = '/Empresa/GestionarSucursales/nuevomediosuc.jsp';
            var pasoSig = document.getElementById('pasoSig');
            pasoSig.value = '12';
            var frm = document.getElementById('frmNuevaSuc');
            frm.submit();            
        }
    }
    
    function EliminarMedioClick(){
        var listaMedios = document.getElementById('mediosSuc');
        if (listaMedios.length == 0){
            return;
        }

        if (listaMedios.selectedIndex==-1){
            Mensaje('Debe seleccionar el medio que desea borrar');
            return;
        }
        else {
            var paginaSig = document.getElementById('paginaSig');
            paginaSig.value = '/Empresa/GestionarSucursales/nuevasucursal.jsp';
            var pasoSig = document.getElementById('pasoSig');
            pasoSig.value = '14';
            var frm = document.getElementById('frmNuevaSuc');
            frm.submit();            
        }
    }
</script>