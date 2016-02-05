
<%@page import="java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, Modelo.Entidades.Empleado"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>
<%
String nss = "";//, rpe = "";
int cotiza = 0;


if (datosS.containsKey("editarEmpleado") || datosS.containsKey("nuevoEmpleado")){
    if (datosS.containsKey("editarEmpleado")){
        tempo = (Empleado)datosS.get("editarEmpleado");
    } else
        tempo = (Empleado)datosS.get("nuevoEmpleado");
}
nss =  tempo.getNss()!=null?tempo.getNss():"";
//rpe = tempo.getRegistropatronal();
cotiza = tempo.getCotiza();
String min = datosS.get("min").toString();
String max = datosS.get("max").toString();
SimpleDateFormat ffecha = new SimpleDateFormat("dd-MM-yyyy");
int banalta = Integer.parseInt(datosS.get("banalta").toString());
NumberFormat formato = new DecimalFormat("#,##0.00");

%>


<table width="100%" align="center" cellpadding="5px">
<tr>
<td>
<table width="100%" align="center" cellpadding="5px" frame="box">
    <tr>
        <td width="60%" valign="top">
            <span class="etiqueta">Historial:</span><br>
            <table width="100%" class="tablaLista">
                <thead>
                <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="22%">
                        <span class="etiqueta">Alta</span>
                    </td>
                    <td width="22%">
                        <span class="etiqueta">Baja</span>
                    </td>
                    <td width="26%">
                        <span class="etiqueta">Reg. Patr.</span>
                    </td>
                    <td width="25%">
                        <span class="etiqueta">Salario Base</span>
                    </td>
                </tr>
                </thead>
                <tbody>
                    <%for (int i=0; i < historial.size(); i++){
                        HistorialIMSS hist = historial.get(i); 
                        String faltaimss = ffecha.format(hist.getFechaalta());
                        String fbajaimss = hist.getFechabaja()!=null?ffecha.format(hist.getFechabaja()):"";
                    %>
                <tr>
                    <td width="5%" align="center">
                        <input id="hist<%=i%>" name="hist<%=i%>" type="checkbox" onclick="ActivaBorrar()"/>
                    </td>
                    <td width="22%" align="center">
                        <span class="etiqueta"><%=faltaimss%></span>
                    </td>
                    <td width="22%" align="center">
                        <span class="etiqueta"><%=fbajaimss%></span>
                    </td>
                    <td width="26%" align="center">
                        <span class="etiqueta"><%=hist.getRegistropatronal()%></span>
                    </td>
                    <td width="25%" align="center">
                        <span class="etiqueta"><%=formato.format(hist.getSalariobase())%></span>
                    </td>
                </tr>
                    <%}%>
                </tbody>
            </table>
        </td>
        <td width="40%" align="center">
            <table>
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">NSS:</span><br>
                        <input id="nssEmpPer" name="nssEmpPer" type="text" class="text" value="<%=nss%>" style="width: 200px"                   
                            onkeypress="return ValidaNums(event)"
                            onblur="ActivaRP(this)" maxlength="11"/>                        
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td align="center">
                        <%if (banalta==1){%>
                        <a id="btnAlta" href="javascript: AltaClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Alta">
                            Alta
                        </a>
                        <%} else {%>
                        <a id="btnBaja" href="javascript: BajaClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B;" title="Baja">
                            Baja
                        </a>
                        <%}%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a id="btnBorrarHist" href="javascript: BorrarClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Borrar Historial seleccionado">
                            Borrar
                        </a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a id="btnEditarHist" href="javascript: EditarClick()"
                            style="width: 150px; font-weight: bold; color: #0B610B; display: none" title="Editar Historial seleccionado">
                            Editar
                        </a>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
                        
</td>            
</tr>    
</table>
<script lang="javascript">
    
    function EjecutarBaja(){
        var ids = document.getElementById('idssel');
        ids.value = '';
        <%for (int i=0; i < historial.size(); i++){
            HistorialIMSS hi = historial.get(i);
        %>
             var chk = document.getElementById('hist<%=i%>');
             if (chk.checked){
                 if (ids.value=='')
                     ids.value = '<%=hi.getId()%>';
                 else
                     ids.value += ','+'<%=hi.getId()%>';
             }
        <%}%>
        var frm = document.getElementById('frmNuevoEmp');
        frm.paginaSig.value = '/Nomina/Personal/GestionarPersonal/nuevoempleado.jsp';
        frm.pasoSig.value = '33';                    
        frm.submit();
    }
    
    function BorrarClick(){
        var boton = document.getElementById('boton');
        boton.value = '1';
        Confirmar('¿Está seguro en dar de baja los registros seleccionados?');
    }
    
    function AltaClick(){
        var nss = document.getElementById('nssEmpPer');
        if (nss.value == ''){
            MostrarMensaje('Debe ingresar el NSS del empleado');
            return;
        }
        
        var tit = document.getElementById('movtitulo');
        var movi = document.getElementById('movi');
        var etrp = document.getElementById('etRp');
        var rp = document.getElementById('regpatr');
        var etsbc = document.getElementById('etSbc');
        var sbc = document.getElementById('sbc');
        rp.style.display = '';
        etrp.style.display = '';
        etsbc.style.display = '';
        sbc.style.display = '';
        sbc.value = formato_numero('77',2,'.',',');
        tit.textContent = 'ALTA DE EMPLEADO AL IMSS';
        movi.value = '1';
        $( "#fechamov" ).datepicker( "option", "maxDate", "<%=max%>" );
        <%if (!min.equals("")){%>
            $( "#fechamov" ).datepicker( "option", "minDate", "<%=min%>" );
        <%}%>
        $( "#dialog-movimiento" ).dialog( "open" );
    }
    
    function BajaClick(){
        var tit = document.getElementById('movtitulo');
        var movi = document.getElementById('movi');
        var rp = document.getElementById('regpatr');
        var etrp = document.getElementById('etRp');
        var etsbc = document.getElementById('etSbc');
        var sbc = document.getElementById('sbc');
        rp.style.display = 'none';
        etrp.style.display = 'none';
        etsbc.style.display = 'none';
        sbc.style.display = 'none';
        tit.textContent = 'BAJA DE EMPLEADO DEL IMSS';
        movi.value = '0';
        $( "#fechamov" ).datepicker( "option", "maxDate", "<%=max%>" );
        $( "#fechamov" ).datepicker( "option", "minDate", "<%=min%>" );
        $( "#dialog-movimiento" ).dialog( "open" );
    }
    
    function EditarClick(){
        var tit = document.getElementById('movtitulo');
        var movi = document.getElementById('movi');
        var rp = document.getElementById('regpatr');
        var etrp = document.getElementById('etRp');
        rp.style.display = '';
        etrp.style.display = '';
        var etsbc = document.getElementById('etSbc');
        var sbc = document.getElementById('sbc');
        tit.textContent = 'EDITAR REGISTRO DEL IMSS';
        movi.value = '2';
        //obtener mov actual
        var ids = document.getElementById('idssel');
        ids.value = '';
        var faact = '', fbact = '', rpact = '', sbcact = '';
        <%for (int i=0; i < historial.size(); i++){
            HistorialIMSS hi = historial.get(i);
        %>
             var chk = document.getElementById('hist<%=i%>');
             if (chk.checked){
                 if (ids.value=='')
                     ids.value = '<%=hi.getId()%>';
                 else
                     ids.value += ','+'<%=hi.getId()%>';
                 faact = '<%=ffecha.format(hi.getFechaalta())%>';
                 fbact = '<%=hi.getFechabaja()!=null?ffecha.format(hi.getFechabaja()):""%>';
                 rpact = '<%=hi.getRegistropatronal()%>';
                 sbcact = '<%=formato.format(hi.getSalariobase())%>';
             }
        <%}%>
        //obtener mov anterior
        //obtener mov siguiente
        
        var fa = document.getElementById('fechamovalta');
        var fb = document.getElementById('fechamovbaja');
        var rp = document.getElementById('regpatredit');
        var sb = document.getElementById('sbcedit');
        fa.value = faact;
        fb.value = fbact;
        sb.value = sbcact;
        if (fbact=='')
            fb.disabled = 'true';
        for (i=0; i < rp.length; i++){
            if (rp[i].value==rpact){
                rp[i].selected = 'true';
            }
        }
        //$( "#fechamovalta" ).datepicker( "option", "maxDate", "" );
        //$( "#fechamovbaja" ).datepicker( "option", "minDate", "" );
        $( "#dialog-editarmovimss" ).dialog( "open" );
    }
    
    function ActivaBorrar(){
        var btnBorrar = document.getElementById('btnBorrarHist');
        var btnEditar = document.getElementById('btnEditarHist');
        var show = 0, cont=0;
        <%for (int i=0; i < historial.size(); i++){%>
             var chk = document.getElementById('hist<%=i%>');
             if (chk.checked){
                 show = 1;
                 cont++;
             }
        <%}%>
        if (show==1)
            btnBorrar.style.display='';
        else
            btnBorrar.style.display='none';
        
        if (show==1 && cont==1){
            btnEditar.style.display = '';
        } else {
            btnEditar.style.display = 'none';
        }
    }
    
    function ActivaRP(obj){
        var rp = document.getElementById('regpatr');
        rp.options[0].selected = true;
        rp.disabled = true;
        if (obj.value!='')
            rp.disabled = false;
        Mayusculas(obj);
    }
</script>