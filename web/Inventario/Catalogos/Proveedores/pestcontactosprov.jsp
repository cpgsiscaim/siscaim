<%@page import="Generales.Sesion"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
%>

<table width="90%" align="center" cellpadding="5px">
    <tr>
        <td width="70%" align="right">
            <a id="btnBajaContac" href="javascript: BajaContactoClick()"
                style="width: 180px; font-weight: bold; color: #0B610B;" title="Dar de baja Contacto del Proveedor">
                Baja de Contacto
            </a>
        </td>
        <td width="15%" align="right">
            <a id="btnEditarContac" href="javascript: EditarContactoClick()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar Contacto del Proveedor">
                Editar Contacto
            </a>
        </td>
        <td width="15%" align="right">
            <a id="btnNuevoContac" href="javascript: NuevoContactoClick()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Agregar Contacto del Proveedor">
                Nuevo Contacto
            </a>
        </td>
    </tr>
</table>
<table width="90%" align="center" cellpadding="5px">
    <tr>
        <td width="40%" align="left">
            <span class="etiquetaB">Contactos:</span>
        </td>
        <td width="15%" align="left">
            <span class="etiquetaB">Teléfonos fijos:</span>
        </td>
        <td width="10%" align="left">
            <span class="etiquetaB">Extensiones:</span>
        </td>
        <td width="15%" align="left">
            <span class="etiquetaB">Celulares:</span>
        </td>
        <td width="20%" align="left">
            <span class="etiquetaB">Correos:</span>
        </td>
    </tr>
    <tr>
        <td width="40%" align="center">
            <select id="lstContactos" name="lstContactos" class="lista" size="10"
                    style="width: 500px" onclick="MostrarAcciones(this.value)">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoProveedor cc = contactos.get(i);
                %>
                    <option value="<%=cc.getId()%>">
                        <%=cc.getContacto().getTitulo()+" "+cc.getContacto().getNombreCompletoPorApellidos()+" - "+cc.getContacto().getCargo()%>
                    </option>
                <%}%>
            </select>
        </td>
        <td width="15%" align="center">
            <select id="lstTels" name="lstTels" class="lista" size="10"
                    style="width: 150px" onclick="Selecciona(this)">
            </select>
        </td>
        <td width="10%" align="center">
            <select id="lstExtens" name="lstExtens" class="lista" size="10"
                    style="width: 80px" onclick="Selecciona(this)">
            </select>
        </td>
        <td width="15%" align="center">
            <select id="lstCels" name="lstCels" class="lista" size="10"
                    style="width: 150px" onclick="Selecciona(this)">
            </select>
        </td>
        <td width="20%" align="center">
            <select id="lstMails" name="lstMails" class="lista" size="10"
                    style="width: 150px" onclick="Selecciona(this)">
            </select>
        </td>
    </tr>
    <tr>
        <td width="40%" align="center">
        <td width="60%" align="left" colspan="3">
            <input id="datomedio" name="datomedio" disabled="" class="text" type="text" value="" style="width:400px"/>
        </td>
    </tr>
</table>
<script lang="javascript">
    function Selecciona(lista){
        var lstels = document.getElementById('lstTels');
        var lscels = document.getElementById('lstCels');
        var lsexts = document.getElementById('lstExtens');
        var lsmails = document.getElementById('lstMails');
        var pos = lista.selectedIndex;
        var dato = document.getElementById('datomedio');
        //var tipo = lstipos.options[pos].value;
        if (lista.name=='lstTels' || lista.name=='lstCels')
            dato.value = telefono(lista.options[pos].text);
        else
            dato.value = lista.options[pos].text;
        
        if (lista.name=='lstTels' || lista.name=='lstExtens'){
            lstels.selectedIndex = -1;
            lsexts.selectedIndex = -1;
            
            lstels.options[pos].selected = true;
            lsexts.options[pos].selected = true;
        }
    }
    
    
    function BajaContactoClick(){
        Espera();
        var frm = document.getElementById('frmNuevoPro');
        frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/nuevoproveedor.jsp';
        frm.pasoSig.value = '15';
        frm.submit();
    }
    
    function EditarContactoClick(){
        Espera();
        var frm = document.getElementById('frmNuevoPro');
        frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/nuevocontactoprov.jsp';
        frm.pasoSig.value = '14';
        frm.submit();
    }
    
    function NuevoContactoClick(){
        Espera();
        var frm = document.getElementById('frmNuevoPro');
        frm.paginaSig.value = '/Inventario/Catalogos/Proveedores/nuevocontactoprov.jsp';
        frm.pasoSig.value = '12';
        frm.submit();
    }
    
    function MostrarAcciones(idcon){
        var lista = document.getElementById('lstContactos');
        if (lista.selectedIndex>=0){
            var btnBaja = document.getElementById('btnBajaContac');
            btnBaja.style.display='';
            var btnEditar = document.getElementById('btnEditarContac');
            btnEditar.style.display='';
            var idpersona = '';
            <%
            for (int c=0; c < contactos.size(); c++){
                ContactoProveedor cc = contactos.get(c);
            %>
                if (idcon=='<%=cc.getId()%>'){
                    idpersona = '<%=cc.getContacto().getIdpersona()%>';
                }
            <%}%>
            
            var lstels = document.getElementById('lstTels');
            var lsexts = document.getElementById('lstExtens');
            var lscels = document.getElementById('lstCels');
            var lsmails = document.getElementById('lstMails');
            lstels.length = 0;
            lsexts.length = 0;
            lscels.length = 0;
            lsmails.length = 0;
            var t=0;
            var c=0;
            var m=0;
            <%for (int i=0; i < medioscon.size(); i++){
                PersonaMedio pm = medioscon.get(i);
            %>
                if (idpersona=='<%=pm.getPersona().getIdpersona()%>'){
                    var color = '#FFFFFF';
                    if ('<%=pm.getMedio().getTipo().getIdtipomedio()%>'=='1'){
                        if (t%2==0)
                            color = '#99FF66';
                        lstels.options[t] = new Option(telefono('<%=pm.getMedio().getMedio()%>'),'<%=pm.getMedio().getMedio()%>');
                        lstels.options[t].style.backgroundColor = color;
                        lsexts.options[t] = new Option('<%=pm.getMedio().getExtension()%>','<%=pm.getMedio().getExtension()%>');
                        lsexts.options[t].style.backgroundColor = color;
                        t++;
                    } else if ('<%=pm.getMedio().getTipo().getIdtipomedio()%>'=='2'){
                        if (c%2==0)
                            color = '#99FF66';                        
                        lscels.options[c] = new Option(telefono('<%=pm.getMedio().getMedio()%>'),'<%=pm.getMedio().getMedio()%>');
                        lscels.options[c].style.backgroundColor = color;
                        c++;
                    } else {
                        if (m%2==0)
                            color = '#99FF66';
                        lsmails.options[m] = new Option('<%=pm.getMedio().getMedio()%>','<%=pm.getMedio().getMedio()%>');
                        lsmails.options[m].style.backgroundColor = color;
                        m++;
                    }
                }
            <%}%>
        }
    }
</script>