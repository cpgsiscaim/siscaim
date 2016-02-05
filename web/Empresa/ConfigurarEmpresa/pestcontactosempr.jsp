<%@page import="java.util.List, java.util.ArrayList, Modelo.Entidades.Persona"%>
<%
List<Persona> listaContactos = new ArrayList<Persona>();
List<Persona> actualesCon = new ArrayList<Persona>();
List<Persona> nuevosCon = new ArrayList<Persona>();
List<Persona> editadosCon = new ArrayList<Persona>();
List<Persona> borradosCon = new ArrayList<Persona>();
if (matriz != null)
    actualesCon = matriz.getContactos();
if (datosS.containsKey("contactosNuevos"))
    nuevosCon = (List<Persona>)datosS.get("contactosNuevos");
if (datosS.containsKey("contactosEditados"))
    editadosCon = (List<Persona>)datosS.get("contactosEditados");
if (datosS.containsKey("contactosBorrados"))
    borradosCon = (List<Persona>)datosS.get("contactosBorrados");


for (int i=0; i < actualesCon.size(); i++){
    Persona act = actualesCon.get(i);
    boolean borrado = false;
    for (int b=0; b < borradosCon.size(); b++){
        Persona bo = borradosCon.get(b);
        if (bo.getIdpersona()==act.getIdpersona()){
            borrado = true;
            break;
        }
    }
    if (!borrado){
        boolean editado = false;
        for (int j=0; j < editadosCon.size(); j++){
            Persona edit = editadosCon.get(j);
            if (edit.getIdpersona()==act.getIdpersona()){
                listaContactos.add(edit);
                editado = true;
                break;
            }
        }
        if (!editado)
            listaContactos.add(act);
    }
}
for (int j=0; j < nuevosCon.size(); j++){
    listaContactos.add(nuevosCon.get(j));
}
%>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="60%" valign="top" align="center" valign="center">
            <span class="etiqueta">Contactos:</span><br>
            <select id="contactosEmpr" name="contactosEmpr" size="6" style="width: 400px">
                <%
                for (int i=0; i < listaContactos.size(); i++){
                    Persona con = listaContactos.get(i);
                    %>
                    <option value="<%=con.getIdpersona()%>" title="<%=con.getTitulo()%> <%=con.getNombreCompleto()%> - <%=con.getCargo()%>">
                        <%=con.getTitulo()%> <%=con.getNombreCompleto()%> - <%=con.getCargo()%>
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
                                <td style="padding-right:0px" title ="Nuevo Contacto">
                                    <a href="javascript: NuevoContactoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
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
                                <td style="padding-right:0px" title ="Editar Contacto">
                                    <a href="javascript: EditarContactoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
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
                                <td style="padding-right:0px" title ="Borrar Contacto">
                                    <a href="javascript: BorrarContactoClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/borrar.png);width:150px;height:30px;display:block;"><br/></a>
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
    function NuevoContactoClick(){
        var paginaSig = document.getElementById('paginaSig');
        paginaSig.value = '/Empresa/ConfigurarEmpresa/nuevocontactoempr.jsp';
        var pasoSig = document.getElementById('pasoSig');
        pasoSig.value = '20';
        var frm = document.getElementById('frmConfigurarEmpr');
        frm.submit();
    }
    
    function EditarContactoClick(){
        var listaContactos = document.getElementById('contactosEmpr');
        if (listaContactos.length == 0){
            return;
        }
        if (listaContactos.selectedIndex==-1){
            Mensaje('Debe seleccionar el contacto que desea editar');
            return;
        }
        else {
            var paginaSig = document.getElementById('paginaSig');
            paginaSig.value = '/Empresa/ConfigurarEmpresa/nuevocontactoempr.jsp';
            var pasoSig = document.getElementById('pasoSig');
            pasoSig.value = '22';
            var frm = document.getElementById('frmConfigurarEmpr');
            frm.submit();            
        }
    }
    
    function BorrarContactoClick(){
        var listaContactos = document.getElementById('contactosEmpr');
        if (listaContactos.length == 0){
            return;
        }

        if (listaContactos.selectedIndex==-1){
            Mensaje('Debe seleccionar el Contacto que desea borrar');
            return;
        }
        else {
            var paginaSig = document.getElementById('paginaSig');
            paginaSig.value = '/Empresa/ConfigurarEmpresa/configurarempresa.jsp';
            var pasoSig = document.getElementById('pasoSig');
            pasoSig.value = '24';
            var frm = document.getElementById('frmConfigurarEmpr');
            frm.submit();            
        }
    }    
</script>