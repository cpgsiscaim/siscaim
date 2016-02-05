<%@page import="Generales.Sesion"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
%>

<table width="90%" align="center" cellpadding="5px">
    <tr>
        <td width="70%" align="right">
            <a id="btnBajaContac" href="javascript: BajaContactoClick()"
                style="width: 180px; font-weight: bold; color: #0B610B;" title="Dar de baja Contacto del Cliente">
                Baja de Contacto
            </a>
        </td>
        <td width="15%" align="right">
            <a id="btnEditarContac" href="javascript: EditarContactoClick()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Editar Contacto del Cliente">
                Editar Contacto
            </a>
        </td>
        <td width="15%" align="right">
            <a id="btnNuevoContac" href="javascript: NuevoContactoClick()"
                style="width: 150px; font-weight: bold; color: #0B610B;" title="Agregar Contacto del Cliente">
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
                    ContactoCliente cc = contactos.get(i);
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
            
            <%--
            <select id="lstConNombres" name="lstConNombres" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoCliente cc = contactos.get(i);
                %>
                    <option value="<%=cc.getContacto().getNombre()%>">
                        <%=cc.getContacto().getNombre()%>
                    </option>
                <%}%>
            </select>
            <select id="lstConPaternos" name="lstConPaternos" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoCliente cc = contactos.get(i);
                %>
                    <option value="<%=cc.getContacto().getPaterno()%>">
                        <%=cc.getContacto().getPaterno()%>
                    </option>
                <%}%>
            </select>
            <select id="lstConMaternos" name="lstConMaternos" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoCliente cc = contactos.get(i);
                %>
                    <option value="<%=cc.getContacto().getMaterno().isEmpty()?"&":cc.getContacto().getMaterno()%>">
                        <%=cc.getContacto().getMaterno()%>
                    </option>
                <%}%>
            </select>
            <select id="lstConSexos" name="lstConSexos" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoCliente cc = contactos.get(i);
                %>
                    <option value="<%=cc.getContacto().getSexo()%>">
                        <%=cc.getContacto().getSexo()%>
                    </option>
                <%}%>
            </select>
            <select id="lstConTitulos" name="lstConTitulos" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoCliente cc = contactos.get(i);
                %>
                    <option value="<%=cc.getContacto().getTitulo()%>">
                        <%=cc.getContacto().getTitulo()%>
                    </option>
                <%}%>
            </select>
            <select id="lstConCargos" name="lstConCargos" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    ContactoCliente cc = contactos.get(i);
                %>
                    <option value="<%=cc.getContacto().getCargo().isEmpty()?"&":cc.getContacto().getCargo()%>">
                        <%=cc.getContacto().getCargo()%>
                    </option>
                <%}%>
            </select>
            <select id="lstConTels" name="lstConTels" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    boolean tiene = false;
                    ContactoCliente cc = contactos.get(i);
                    for (int j=0; j < medioscon.size(); j++){
                        PersonaMedio pm = medioscon.get(j);
                        if (pm.getPersona().getIdpersona()==cc.getContacto().getIdpersona()
                                && pm.getMedio().getTipo().getIdtipomedio()==1){
                            tiene = true;
                %>
                            <option value="<%=pm.getMedio().getMedio()%>">
                                <%=pm.getMedio().getMedio()%>
                            </option>
                <%
                        }
                    }
                    if (!tiene){%>
                        <option value="&"> </option>
                    <%}
                }%>
            </select>
            <select id="lstConCels" name="lstConCels" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    boolean tiene = false;
                    ContactoCliente cc = contactos.get(i);
                    for (int j=0; j < medioscon.size(); j++){
                        PersonaMedio pm = medioscon.get(j);
                        if (pm.getPersona().getIdpersona()==cc.getContacto().getIdpersona()
                                && pm.getMedio().getTipo().getIdtipomedio()==2){
                            tiene = true;
                %>
                            <option value="<%=pm.getMedio().getMedio()%>">
                                <%=pm.getMedio().getMedio()%>
                            </option>
                <%
                        }
                    }
                    if (!tiene){%>
                        <option value="&"> </option>
                    <%}
                }%>
            </select>
            <select id="lstConMails" name="lstConMails" class="lista" size="10"
                    style="width: 100px; display: none">
                <%for (int i=0; i < contactos.size(); i++){
                    boolean tiene = false;
                    ContactoCliente cc = contactos.get(i);
                    for (int j=0; j < medioscon.size(); j++){
                        PersonaMedio pm = medioscon.get(j);
                        if (pm.getPersona().getIdpersona()==cc.getContacto().getIdpersona()
                                && pm.getMedio().getTipo().getIdtipomedio()==3){
                            tiene = true;
                %>
                            <option value="<%=pm.getMedio().getMedio()%>">
                                <%=pm.getMedio().getMedio()%>
                            </option>
                <%
                        }
                    }
                    if (!tiene){%>
                        <option value="&"> </option>
                    <%}
                }%>
            </select>
            <select id="lstNuevos" name="lstNuevos" class="lista" size="10"
                    style="width: 100px; display: none">
            </select>
            <select id="lstEditados" name="lstEditados" class="lista" size="10"
                    style="width: 100px; display: none">
            </select>
            <select id="lstBajas" name="lstBajas" class="lista" size="10"
                    style="width: 100px; display: none">
            </select>
            
            
        </td>
    </tr>
    
    <tr>
        <td width="100%" align="center" colspan="3">
            <div id="medios" style="display: none">
                <table width="600px" align="center">
                    <tr>
                        <td width="34%">
                            <span class="etiquetaB">Tel&eacute;fono:</span><br>
                            <input id="txtTel" name="txtTel" class="text" type="text" value="" readonly
                                   style="width: 200px"/>
                        </td>
                        <td width="34%">
                            <span class="etiquetaB">Celular:</span><br>
                            <input id="txtCel" name="txtCel" class="text" type="text" value="" readonly
                                   style="width: 200px"/>
                        </td>
                        <td width="33%">
                            <span class="etiquetaB">Correo:</span><br>
                            <input id="txtMail" name="txtMail" class="text" type="text" value="" readonly
                                   style="width: 200px"/>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    
</table>--%>

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

        /*lstipos.selectedIndex = -1;
        lstels.selectedIndex = -1;
        lsexts.selectedIndex = -1;

        lstipos.options[pos].selected = true;
        lstels.options[pos].selected = true;
        lsexts.options[pos].selected = true;*/
    }
    
    
    function BajaContactoClick(){
        Espera();
        var frm = document.getElementById('frmNuevoCli');
        frm.paginaSig.value = '/Empresa/GestionarClientes/nuevocliente.jsp';
        frm.pasoSig.value = '20';
        frm.submit();
    }
    
    function EditarContactoClick(){
        Espera();
        var frm = document.getElementById('frmNuevoCli');
        frm.paginaSig.value = '/Empresa/GestionarClientes/nuevocontactocliente.jsp';
        frm.pasoSig.value = '19';
        frm.submit();
    }
    
    function NuevoContactoClick(){
        Espera();
        var frm = document.getElementById('frmNuevoCli');
        frm.paginaSig.value = '/Empresa/GestionarClientes/nuevocontactocliente.jsp';
        frm.pasoSig.value = '17';
        frm.submit();
    }
    
    /*function ContactoClick(opcion){
        var titvent = "NUEVO CONTACTO";
        if (opcion==1)
            titvent='EDITAR CONTACTO';
        Contacto(titvent, opcion);
    }*/
    
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
                ContactoCliente cc = contactos.get(c);
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
                    <%--lstipos.options[k] = new Option('<%=pm.getMedio().getTipo().getTipomedio()%>','<%=pm.getMedio().getTipo().getIdtipomedio()%>');
                    lstipos.options[k].style.backgroundColor = color;
                    if ('<%=pm.getMedio().getTipo().getIdtipomedio()%>'!='3')
                        lsmedios.options[k] = new Option(telefono('<%=pm.getMedio().getMedio()%>'),'<%=pm.getMedio().getMedio()%>');
                    else
                        lsmedios.options[k] = new Option('<%=pm.getMedio().getMedio()%>','<%=pm.getMedio().getMedio()%>');
                    lsmedios.options[k].style.backgroundColor = color;
                    lsexts.options[k] = new Option('<%=pm.getMedio().getExtension()%>','<%=pm.getMedio().getExtension()%>');
                    lsexts.options[k].style.backgroundColor = color;
                    k++;--%>
                }
            <%}%>
            /*var medios = document.getElementById('medios');
            medios.style.display='';*/
            
            /*/carga los medios del contacto seleccionado
            var txtTel = document.getElementById('txtTel');
            var txtCel = document.getElementById('txtCel');
            var txtMail = document.getElementById('txtMail');
            var lsTel = document.getElementById('lstConTels');
            var lsCel = document.getElementById('lstConCels');
            var lsMails = document.getElementById('lstConMails');
            var lsCon = document.getElementById('lstContactos');
            var sel = lsCon.selectedIndex;
            txtTel.value = lsTel.options[sel].value!='&'?lsTel.options[sel].value:'';
            txtCel.value = lsCel.options[sel].value!='&'?lsCel.options[sel].value:'';
            txtMail.value = lsMails.options[sel].value!='&'?lsMails.options[sel].value:'';*/
        }
    }
    
    /*function BajaContactoClick(){
        var lsCon = document.getElementById('lstContactos');
        var sel = lsCon.selectedIndex;
        var lsNom = document.getElementById('lstConNombres');
        var lsPat = document.getElementById('lstConPaternos');
        var lsMat = document.getElementById('lstConMaternos');
        var lsSex = document.getElementById('lstConSexos');
        var lsTit = document.getElementById('lstConTitulos');
        var lsCar = document.getElementById('lstConCargos');
        var lsTel = document.getElementById('lstConTels');
        var lsCel = document.getElementById('lstConCels');
        var lsMails = document.getElementById('lstConMails');
        //checar si el contacto está en nuevos
        var lsNue = document.getElementById('lstNuevos');
        var esnue = false;
        for (i=0; i < lsNue.length; i++){
            if (lsNue.options[i].value==sel)
                esnue = true;
        }
        if (esnue){
            var pos = 0;
            for (i=0; i < lsNue.length; i++){
                if (lsNue.options[i].value==sel)
                    pos=i;
            }
            //borrar de la lista de nuevos el contacto seleccionado            
            lsNue.remove(pos);
            lsCon.remove(sel);
            lsNom.remove(sel);
            lsPat.remove(sel);
            lsMat.remove(sel);
            lsSex.remove(sel);
            lsTit.remove(sel);
            lsCar.remove(sel);
            lsTel.remove(sel);
            lsCel.remove(sel);
            lsMails.remove(sel);
            //decrementar las posiciones mayores a la que se eliminará
            for (i=0; i < lsNue.length; i++){
                if (lsNue.options[i].value>sel){
                    lsNue.options[i] = new Option(lsNue.options[i].value-1,lsNue.options[i].value-1);
                }
            }
        } else {
            //agregar id del contacto a la lista de bajas
            var lsBaja = document.getElementById('lstBajas');
            var idcon = lsCon.options[sel].value;
            lsBaja.options[lsBaja.length] = new Option(idcon, idcon);
            //checar si esta en la lista de editados y quitar
            var lsEdi = document.getElementById('lstEditados');
            var posed = -1;
            for (i=0; i < lsEdi.length; i++){
                if (lsEdi.options[i].value==idcon){
                    posed = i;
                }
            }
            if (posed!=-1){
                lsEdi.remove(posed);
            }
            
            //eliminar de las listas
            lsCon.remove(sel);
            lsNom.remove(sel);
            lsPat.remove(sel);
            lsMat.remove(sel);
            lsSex.remove(sel);
            lsTit.remove(sel);
            lsCar.remove(sel);
            lsTel.remove(sel);
            lsCel.remove(sel);
            lsMails.remove(sel);
            //decrementar las posiciones mayores a la que se eliminará
            for (i=0; i < lsNue.length; i++){
                if (lsNue.options[i].value>sel){
                    lsNue.options[i] = new Option(lsNue.options[i].value-1,lsNue.options[i].value-1);
                }
            }
            
        }
        
        if (lsCon.length==0){
            var btnBaja = document.getElementById('btnBajaContac');
            var btnEdit = document.getElementById('btnEditarContac');
            var med = document.getElementById('medios');
            btnBaja.style.display = 'none';
            btnEdit.style.display = 'none';
            med.style.display = 'none';
        }
        
        var txtTel = document.getElementById('txtTel');
        txtTel.value = '';
        var txtCel = document.getElementById('txtCel');
        txtCel.value = '';
        var txtMail = document.getElementById('txtMail');
        txtMail.value = '';
    }*/
</script>