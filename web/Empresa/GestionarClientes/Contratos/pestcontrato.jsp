<%@page import="Generales.Sesion"%>
<%@page import="java.text.SimpleDateFormat, java.util.List, java.util.ArrayList, Modelo.Entidades.Catalogos.FechasEntrega"%>

<%
List<FechasEntrega> listafechas = new ArrayList<FechasEntrega>();
String contrato = "", fechaIni = "", fechaIniN = "", fechaFin = "", fechaFinN = "", descrip = "", observacion = "";
int factxct=0, totper=0;
if (datosS.get("accion").toString().equals("editar") || sesion.isError()){
    tempo = (Contrato)datosS.get("editarContrato");
    if (sesion.isError())
        tempo = (Contrato)datosS.get("contrato");
    contrato = tempo.getContrato();
    SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
    fechaIni = formato.format(tempo.getFechaIni()); //tempo.getFechaIni().toString();
    fechaIniN = fechaIni.substring(8,10) + "-" + fechaIni.substring(5,7) + "-" + fechaIni.substring(0, 4);
    fechaFin = formato.format(tempo.getFechaFin());//tempo.getFechaFin().toString();
    fechaFinN = fechaFin.substring(8,10) + "-" + fechaFin.substring(5,7) + "-" + fechaFin.substring(0, 4);
    descrip = tempo.getDescripcion();
    observacion = tempo.getObservaciones();
    factxct = tempo.getFacturarCT();
    totper = tempo.getTotalpersonal();
    if (tempo.getTipoentrega()==1)
        listafechas = (List<FechasEntrega>)datosS.get("fechasent");
}
%>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="20%" align="center" valign="top">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">Núm. de Contrato:</span><br>
                        <input id="contrato" name="contrato" class="text" type="text" value="<%=contrato%>" style="width: 200px"
                               onkeypress="return ValidaAlfaNums(event)" maxlength="20" onblur="Mayusculas(this)" 
                               title="Ingrese el número de contrato" <%if (banhis==1){%>readonly=""<%}%>/>                                                            
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">Fecha Inicial:</span><br>
                        <input id="fechaIni" name="fechaIni" type="text" class="text" readonly value="<%=fechaIniN%>"
                               title="Ingrese la fecha inicial del contrato" style="width: 150px;" <%if (banhis==1){%>readonly=""<%}%>/>
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">Fecha Final:</span><br>
                        <input id="fechaFin" name="fechaFin" type="text" class="text" readonly value="<%=fechaFinN%>"
                            title="Ingrese la fecha final del contrato" style="width: 150px;" <%if (banhis==1){%>readonly=""<%}%>/>
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">Total de Personal:</span><br>
                        <input id="totalpersonal" name="totalpersonal" class="text" type="text" value="<%=totper%>" style="width: 200px"
                               onkeypress="return ValidaNums(event)" maxlength="2"
                               title="Ingrese el total del personal del contrato" <%if (banhis==1){%>readonly=""<%}%>/>                                                            
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <input id="facturarct" name="facturarct" type="checkbox" <%if (factxct==1){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>>
                        <span class="etiqueta">Facturar por CT</span>
                    </td>
                </tr>
            </table>
        </td>
        <td width="40%" align="center" valign="top">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">Descripción:</span><br>
                        <input id="descripcion" name="descripcion" class="text" type="text" value="<%=descrip%>" style="width: 400px"
                               onkeypress="return ValidaAlfaNumSignos(event)" maxlength="40" onblur="Mayusculas(this)" 
                               title="Ingrese el nombre o descripción del producto" <%if (banhis==1){%>readonly=""<%}%>/>                                                            
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <span class="etiqueta">Observación:</span><br>
                        <textarea id="observacion" name="observacion" style="width: 400px" maxlength="200" rows="5" onblur="Mayusculas(this)" class="text" title="Ingresa las observaciones del contrato" <%if (banhis==1){%>readonly=""<%}%>><%=observacion%></textarea>
                    </td>
                </tr>
            </table>
        </td>
        <td width="40%" align="center" valign="top">
            <table width="100%">
                <tr>
                    <td width="100%" align="left">
                        <span class="subtitulo">Configuración de las Entregas</span>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <input id="opcconfig" name="opcconfig" value="<%=tempo.getTipoentrega()%>" type="hidden">
                        <span class="etiquetaB">Elija una opción de Configuración:</span><br>
                            <input id="rdopcconfig" name="rdopcconfig" value="0" type="radio" onclick="ChecaConfigEntregas(this.value)"
                               <%if (tempo.getTipoentrega()==0){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>/><span class="etiqueta">Cada&nbsp;
                            <input id="numdias" name="numdias" class="text" type="text" value="<%=tempo.getDiasentrega()%>" 
                               <%if (tempo.getTipoentrega()!=0){%>disabled="true"<%}%> style="width: 70px"
                               maxlength="3" onkeypress="return ValidaNums(event)" <%if (banhis==1){%>disabled<%}%>/>&nbsp;
                            d&iacute;as
                        </span><br>
                        <input id="lstfechas" name="lstfechas" value="" type="hidden">
                        <input id="rdopcconfig" name="rdopcconfig" value="1" type="radio" onclick="ChecaConfigEntregas(this.value)"
                               <%if (tempo.getTipoentrega()==1){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>/>
                        <span class="etiqueta">Fechas espec&iacute;ficas:</span>
                        <div id="divfechas" <%if (tempo.getTipoentrega()!=1){%>style="display: none"<%}%>>
                            <input id="fechaesp" name="fechaesp" type="text" class="text" readonly value=""
                                title="Ingrese una fecha y luego de clic en el icono Agregar" style="width: 150px;" <%if (banhis==1){%>readonly=""<%}%>/>
                            <img src="/siscaim/Imagenes/Varias/mas01.png" width="25" height="25"
                                onclick="AgregaFecha()" title="Agrega la fecha" onmouseover="this.style.cursor='pointer'" <%if (banhis==1){%>readonly=""<%}%>/><br>
                            <select id="lsfechas" name="lsfechas" size="5" style="width: 200px" multiple <%if (banhis==1){%>readonly=""<%}%>>
                                <%SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
                                String sfecha = "";
                                for (int i=0; i < listafechas.size(); i++){
                                    FechasEntrega fe = listafechas.get(i);
                                    sfecha = form.format(fe.getFecha());
                                %>
                                    <option value="<%=fe.getFecha()%>"><%=sfecha%></option>
                                <%}%>
                            </select>
                            <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                onclick="QuitarFechas()" title="Quitar las fechas seleccionadas" onmouseover="this.style.cursor='pointer'"
                                <%if (banhis==1){%>readonly=""<%}%>/><br>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
            <table width="100%">
                <tr>
                    <td width="100%" align="left">
                        <span class="subtitulo">Especialidad:</span>
                    </td>                    
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <input id="chkjardin" name="chkjardin" type="checkbox" <%if(tempo.getEspecialidad()==1 || tempo.getEspecialidad()==4 || tempo.getEspecialidad()==5 || tempo.getEspecialidad()==7){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>>
                        <span class="etiqueta">Jardinería</span>
                        <input id="chklimpia" name="chklimpia" type="checkbox" <%if(tempo.getEspecialidad()==2 || tempo.getEspecialidad()==4 || tempo.getEspecialidad()==6 || tempo.getEspecialidad()==7){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>>
                        <span class="etiqueta">Limpieza</span>
                        <input id="chkfumiga" name="chkfumiga" type="checkbox" <%if(tempo.getEspecialidad()==3 || tempo.getEspecialidad()==5 || tempo.getEspecialidad()==6 || tempo.getEspecialidad()==7){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>>
                        <span class="etiqueta">Fumigación</span>
                    </td>                    
                </tr>
            </table>
            <br>
            <%if (datosS.get("accion").toString().equals("editar")){%>
            <table width="100%">
                <tr>
                    <td width="20%"><span class="subtitulo">Documento:</span></td>&nbsp;
                    <td align="left">
                        <%if (tempo.getDocumento()==0){%>
                            <span class="etiqueta">
                                <a id="btnAgregarDocCon" href="javascript: SubirContrato()"
                                    style="width: 100px; font-weight: bold; color: #0B610B;" title="Subir documento del contrato">
                                    Agregar
                                </a>
                            </span>
                        <%} else {%>
                            <a id="btnVerDocCon" href="javascript: MostrarContrato('/siscaim/Imagenes/Contratos/<%=tempo.getId()%>.pdf')"
                                style="width: 100px; font-weight: bold; color: #0B610B;" title="Ver documento del contrato">
                                Ver
                            </a>
                            <a id="btnBorrarDocCon" href="javascript: BorrarDocContrato()"
                                style="width: 100px; font-weight: bold; color: #0B610B;" title="Borrar documento del contrato">
                                Borrar
                            </a>
                        <%}%>
                    </td>
                </tr>
            </table>
            <%}%>
        </td>
    </tr>
</table>
<script lang="javascript">
    function MostrarContrato(doc){
        var pdf = document.getElementById('pdf');
        pdf.src = doc;
        $( "#dialog-contrato" ).dialog( "open" );
    }
    
    function SubirContrato(doc){
        $( "#dialog-loadcontrato" ).dialog( "open" );
    }
    
    function limpiar(nombreObj1, nombreObj2)
    {
        obj = document.getElementById(nombreObj1);
        obj.value='';
        obj = document.getElementById(nombreObj2);
        obj.value='';
    }

    function cambiaFecha(fecha, nombreObj)
    {
        d = fecha.substr(0,2);
        m = fecha.substr(3,2);
        y = fecha.substr(6,4);
        txtFecha = document.getElementById(nombreObj);
        txtFecha.value=y+'-'+m+'-'+d;
    }
    
    function ChecaConfigEntregas(opcion){
        var numdias = document.getElementById('numdias');
        var divfech = document.getElementById('divfechas');
        var opcconfig = document.getElementById('opcconfig');
        opcconfig.value = opcion;
        if (opcion==0){
            numdias.disabled = false;
            numdias.focus();
            divfech.style.display = 'none';
        } else {
            numdias.disabled = true;
            divfech.style.display = '';
        }
    }
    
    function AgregaFecha(){
        var fechai = document.getElementById('fechaIni');
        var fechaf = document.getElementById('fechaFin');
        if (fechai.value == '' || fechaf.value == ''){
            MostrarMensaje('Debe definir las fechas inicial y final del contrato antes de agregar fechas');
            return;
        }
        
        var fechaesp = document.getElementById('fechaesp');
        //var rgfechaesp = document.getElementById('rgFechaEsp');
        if (fechaesp.value == ''){
            MostrarMensaje('Debe especificar una fecha');
            return;
        }
        
        //validar que la fecha este dentro del periodo del contrato
        if (ComparaFechas(fechai.value, fechaesp.value)==1 || ComparaFechas(fechaf.value, fechaesp.value)==0){
            MostrarMensaje('La fecha especificada está fuera del período del contrato');
            return;
        }
        
        var lsfechas = document.getElementById('lsfechas');
        k = lsfechas.length;
        if (k>0){
            //checar si la fecha ya existe
            for (i=0; i < lsfechas.length; i++){
                if (lsfechas.options[i].value == fechaesp.value){
                    MostrarMensaje('La fecha ya fue agregada');
                    return;
                }
            }
        }
        lsfechas.options[k] = new Option(fechaesp.value,fechaesp.value);
        fechaesp.value = '';
        //rgfechaesp.value = '';
    }
    
    function QuitarFechas(){
        var lsfechas = document.getElementById('lsfechas');
        if (lsfechas.length==0){
            MostrarMensaje('La lista de fechas está vacía');
            return;
        }
        sel=0;
        indices = '';
        for (i=0; i<lsfechas.length; i++){
            if (lsfechas.options[i].selected){
                if (indices == '')
                    indices += lsfechas.options[i].value;
                else
                    indices += ','+lsfechas.options[i].value;
                sel++;
            }
        }
        if (sel==0){
            MostrarMensaje('Debe seleccionar al menos una fecha');
            return;
        }
        tokens = indices.split(',');
        for (i=0; i < tokens.length; i++){
            valor = tokens[i];
            for (j=0; j < lsfechas.length; j++){
                if (lsfechas.options[j].value==valor)
                    lsfechas.remove(j);
            }
        }
    }
    
    function ComparaFechas(f1, f2){
        var xMonth=f1.substring(3, 5);
        var xDay=f1.substring(0, 2);  
        var xYear=f1.substring(6,10);
        var yMonth=f2.substring(3, 5);  
        var yDay=f2.substring(0, 2);  
        var yYear=f2.substring(6,10);
        if (xYear> yYear)  
        {  
            return 1;  
        }  
        else  
        {  
            if (xYear == yYear)  
            {   
                if (xMonth> yMonth)  
                {  
                    return 1;  
                }  
                else  
                {   
                    if (xMonth == yMonth)  
                    {  
                        if (xDay> yDay)  
                            return 1;  
                        else {
                            if (xDay == yDay)
                                return -1;
                            else
                                return 0;
                        }
                    }  
                    else  
                        return 0;  
                }  
            }  
            else  
                return 0;  
        }
    }
</script>