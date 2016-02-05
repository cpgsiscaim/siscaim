<%-- 
    Document   : pestnuevoemp
    Created on : Jun 6, 2012, 11:19:17 PM
    Author     : roman
--%>
<%@page import="java.util.List,  Modelo.Entidades.Empleado,  Modelo.Entidades.Persona, 
        Modelo.Entidades.Catalogos.Civil, Modelo.Entidades.Catalogos.GpoSanguineo, 
        Modelo.Entidades.Catalogos.Estado, Modelo.Entidades.Catalogos.Municipio, 
        Modelo.Entidades.Sucursal, Modelo.Entidades.Catalogos.Titulo, Modelo.Entidades.Catalogos.Banco"%>

<%
Sucursal sucActual = null;
int edoCivActualInt = 0;
int gpoSangActualInt = 0;
String tituActual = "", cargo = "", banemp="0", cbanca="", estudios="", tit = "0", observacion= "", despad="";
int sucact=0, consec=0, docest=3, pad=0;
Sucursal sucsel = (Sucursal)datosS.get("sucursal");
if (datosS.containsKey("editarEmpleado") || datosS.containsKey("nuevoEmpleado")){
    //Empleado tempo = new Empleado();
    if (datosS.containsKey("editarEmpleado"))
        tempo = (Empleado)datosS.get("editarEmpleado");
    else
        tempo = (Empleado)datosS.get("nuevoEmpleado");
    
    sucActual = tempo.getPersona().getSucursal();
    tituActual = tempo.getPersona().getTitulo();    
    cargo = tempo.getPersona().getCargo()!=null?tempo.getPersona().getCargo():"";
    //cotiza = tempo.getCotiza();
    
    cbanca =  tempo.getCuenta()!=null?tempo.getCuenta():"";
    estudios=  tempo.getEstudios()!=null?tempo.getEstudios():"";
    tit = tempo.getPersona().getTitulo()!=null?tempo.getPersona().getTitulo():"0";
    
    gpoSangActualInt = tempo.getPersona().getGposang();
    edoCivActualInt = tempo.getPersona().getCivil();
    observacion= tempo.getPersona().getObservacion()!=null?tempo.getPersona().getObservacion():"";
    banemp = tempo.getBanco()!=null?Integer.toString(tempo.getBanco().getId()):"0";
    consec = tempo.getConsecutivo();
    docest = tempo.getDocestatus();
    pad = tempo.getPadecimiento();
    despad = tempo.getDescripadecimiento();
}
%>


<table width="100%" align="center" cellpadding="5px">
<tr>
<td>
<table width="100%" align="center" cellpadding="5px" frame="box">
    <tr>
        <td width="15%">
            <span class="etiqueta">Gpo. Sanguineo:</span><br>                                                    
            <select id="gposangPer" name="gposangPer" class="combo" style="width: 150px">
                <option value="0">Gpo. Sanguineo...</option>
                <%
                    List<GpoSanguineo> sanguineos = (List<GpoSanguineo>) datosS.get("sanguineo");
                    for (int i = 0; i < sanguineos.size(); i++) {
                        GpoSanguineo gpoSang = (GpoSanguineo) sanguineos.get(i);
                %>
                <option value="<%=gpoSang.getIdGpoSang()%>"
                        <%
                            if (gpoSang.getIdGpoSang() == gpoSangActualInt) {
                        %>
                        selected
                        <%                                            }
                        %>
                        >
                    <%=gpoSang.getGpoSang()%>
                </option>
                <%
                    }
                %>
            </select>

        </td>
        <td width="15%">
            <span class="etiqueta">Edo. Civil:</span><br>                                                 
            <select id="edocivilPer" name="edocivilPer" class="combo" style="width: 150px">
                <option value="0">Estado Civil...</option>
                <%
                    List<Civil> edociviles = (List<Civil>) datosS.get("civiles");
                    for (int i = 0; i < edociviles.size(); i++) {
                        Civil edoCiv = (Civil) edociviles.get(i);
                %>
                <option value="<%=edoCiv.getIdEdoCivil()%>"
                        <%
                            if (edoCiv.getIdEdoCivil() == edoCivActualInt) {
                        %>
                        selected
                        <%                                            }
                        %>
                        >
                    <%=edoCiv.getEdoCivil()%>
                </option>
                <%
                    }
                %>
            </select>                                                                                                                                                  
        </td>
        <td width="25%">
            <span class="etiqueta">Cargo :</span><br> 
            <input id="cargoPer" name="cargoPer" type="text" class="text" value="<%=cargo%>"  style="width: 200px"
                onkeypress="return ValidaNombrePropio(event, this.value)"
                onblur="Mayusculas(this)" maxlength="35"/>
        </td>
        <td width="20%">
            <span class="etiqueta">¿Tiene algún padecimiento? :</span><br>
            <input id="padecimiento" name="padecimiento" type="hidden" value="<%=pad%>"/>
            <input id="opcpadec" name="opcpadec" type="radio" value="1" onclick="CheckPadecimiento(this.value)"
                   <%if(pad==1){%>checked<%}%>/>
            <span class="etiqueta">Sí</span>
            <input id="opcpadec" name="opcpadec" type="radio" value="0" onclick="CheckPadecimiento(this.value)"
                   <%if(pad==0){%>checked<%}%>/>
            <span class="etiqueta">No</span>
        </td>
        <td width="25%">
            <span class="etiqueta">Padecimiento:</span><br>
            <input id="descripadecimiento" name="descripadecimiento" type="text" class="text" value="<%=despad%>" style="width: 300px"                   
                   onblur="Mayusculas(this)" maxlength="50" disabled=""/>
        </td>
    </tr>
    <tr>
        <td width="100%" colspan="5">
            <table width="100%">
                <tr>
                    <td width="15%" align="left">
                        <span class="etiqueta">Título :</span><br>
                        <select id="tituloPer" name="tituloPer" class="combo" style="width: 100px">
                            <option value="0">Título...</option>
                            <%
                                List<Titulo> titulos = (List<Titulo>) datosS.get("titulos");
                                for (int i = 0; i < titulos.size(); i++) {
                                    Titulo titu = (Titulo) titulos.get(i);
                            %>
                            <option value="<%=titu.getIdtitulo()%>"
                                    <%
                                        if (titu.getIdtitulo()==Integer.parseInt(tit) ) {
                                    %>
                                    selected
                                    <%                                            }
                                    %>
                                    >
                                <%=titu.getTitulo()%>
                            </option>
                            <%
                                }
                            %>
                        </select>                                                                                                                                                  
                    </td>
                    <td width="20%" align="left">
                        <span class="etiqueta">Nivel de Estudios:</span><br>
                        <select id="estudiosEmpPer" name="estudiosEmpPer" class="combo" style="width: 150px">
                            <option value="">Nivel de Estudios...</option>
                            <option value="PRIMARIA" <%if (estudios.equals("PRIMARIA")){%>selected<%}%>>
                                PRIMARIA</option>
                            <option value="SECUNDARIA" <%if (estudios.equals("SECUNDARIA")){%>selected<%}%>>
                                SECUNDARIA</option>
                            <option value="MEDIO SUPERIOR" <%if (estudios.equals("MEDIO SUPERIOR")){%>selected<%}%>>
                                MEDIO SUPERIOR</option>
                            <option value="LICENCIATURA" <%if (estudios.equals("LICENCIATURA")){%>selected<%}%>>
                                LICENCIATURA</option>
                        </select>
                    </td>
                    <td width="25%" align="left">
                        <span class="etiqueta">Banco:</span><br>
                        <select id="banco" name="banco" class="combo" style="width: 180px" onchange="ValidaBanco(this.value)">
                            <option value="">Banco...</option>
                            <%
                                List<Banco> bancos = (List<Banco>) datosS.get("bancos");
                                for (int i = 0; i < bancos.size(); i++) {
                                    Banco bank = (Banco) bancos.get(i);
                            %>
                            <option value="<%=bank.getId()%>"
                                    <%
                                        if (bank.getId()==Integer.parseInt(banemp) ) {
                                    %>
                                    selected
                                    <%                                            }
                                    %>
                                    >
                                <%=bank.getNombre()%>
                            </option>
                            <%
                                }
                            %>
                        </select>                                                                                                                                                  
                    </td>
                    <td width="15%" align="left">
                        <div id="dvconsec" style="display: <%if (Integer.parseInt(banemp)!=2){%>none<%}%>">
                        <span class="etiqueta">Consecutivo:</span><br>
                        <input id="consecutivo" name="consecutivo" type="text" class="text" value="<%=consec%>" style="width: 100px"
                            onkeypress="return ValidaNums(event)" onchange="CambiaClase(this, 'text')"
                            onblur="Mayusculas(this)" maxlength="3"/>
                        </div>
                    </td>
                    <td width="25%" align="left">
                        <span class="etiqueta">Cuenta Bancaria:</span><br>
                        <input id="cuentaEmpPer" name="cuentaEmpPer" type="text" class="text" value="<%=cbanca%>" style="width: 200px"
                            onkeypress="return ValidaNums(event)" onchange="CambiaClase(this, 'text')"
                            onblur="Mayusculas(this)" maxlength="16"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="75%" colspan="4">
            <span class="etiqueta">Observaciones:</span><br>
            <textarea id="observacionDirPer" name="observacionDirPer" class="text" style="width: 600px;"
                      onblur="Mayusculas(this)" maxlength="50"  rows="3"><%=observacion%></textarea>
            <%--<textarea id="observacionDirPer" name="observacionDirPer" onblur="Mayusculas(this)" style="width: 95%" rows="3"><%=observacion%></textarea>--%>
        </td>
        <td width="25%" valing="top">
            <span class="etiqueta">Estatus documentaci&oacute;n:</span><br>
            <select id="docestatus" name="docestatus" class="combo"
                    style="width: 200px">
                <option value="1" <%if(docest==1){%>selected<%}%>>COMPLETA</option>
                <option value="2" <%if(docest==2){%>selected<%}%>>PENDIENTES</option>
                <option value="3" <%if(docest==3){%>selected<%}%>>SIN DOCUMENTACION</option>
            </select>
        </td>
    </tr>
</table>
                        
</td>            
</tr>    
</table>
<script lang="javascript">
    function CheckPadecimiento(valor){
        $('#padecimiento').val(valor);
        if (valor==1){
            $("#descripadecimiento").prop("disabled", false);
            $("#descripadecimiento").focus();
        } else {
            $("#descripadecimiento").val("");
            $("#descripadecimiento").prop("disabled", true);
        }
    }
    
    function HabilitaNSS(cotiza){
        var nss = document.getElementById('nssEmpPer');
        nss.value = '';
        var cot = document.getElementById('cotiza');
        cot.value = '';
        if (cotiza.checked){
            nss.disabled = false;
            cot.value = 1;
        } else {
            nss.disabled = true;
            cot.value = 0;
        }
    }
    
    function ValidaBanco(valor){
        var cuenta = document.getElementById('cuentaEmpPer');
        if (valor == ''){
            cuenta.value = '';
        } else {
            cuenta.focus();
        }
        //si banco=2 (banorte)
        var dvconsec = document.getElementById('dvconsec');
        var consec = document.getElementById('consecutivo');
        if (valor==2){
            dvconsec.style.display='';
            consec.focus();
        } else {
            dvconsec.style.display='none';
        }
    }
</script>