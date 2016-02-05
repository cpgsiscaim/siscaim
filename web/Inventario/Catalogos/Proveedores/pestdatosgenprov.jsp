<%@page import="Modelo.Entidades.Proveedor"%>
<%@page import="Modelo.Entidades.DatosFiscales, Modelo.Entidades.Catalogos.Estado"%>
<%@page import="java.util.List, Modelo.Entidades.Catalogos.Estado, Modelo.Entidades.Catalogos.Municipio"%>

<%
String razonProv = "", rfc = "", calle = "", colonia = "", nombreRepr = "", paternoRepr = "", maternoRepr = "", sCp = "";
int cp = 0, tipo = 0;
Municipio munActual = null;
Estado edoActual = null;
int nacional = 0;
if (datosS.get("accion").toString().equals("editar")){
    Proveedor prov = new Proveedor();
    prov = (Proveedor)datosS.get("proveedor");
    tipo = Integer.parseInt(prov.getTipo());
    razonProv = prov.getDatosfiscales().getRazonsocial();
    rfc = prov.getDatosfiscales().getRfc();
    calle = prov.getDatosfiscales().getDireccion().getCalle();
    colonia = prov.getDatosfiscales().getDireccion().getColonia();
    nombreRepr = prov.getDatosfiscales().getPersona().getNombre();
    paternoRepr = prov.getDatosfiscales().getPersona().getPaterno();
    maternoRepr = prov.getDatosfiscales().getPersona().getMaterno();
    cp = prov.getDatosfiscales().getDireccion().getCp();
    if (cp!=0)
        sCp = Integer.toString(prov.getDatosfiscales().getDireccion().getCp());
    munActual = prov.getDatosfiscales().getDireccion().getPoblacion();
    edoActual = prov.getDatosfiscales().getDireccion().getPoblacion().getEstado();
    nacional = prov.getNacional();
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="20%" align="left">
            <input id="rdTipoPro" name="rdTipoPro" type="radio" value="moral" 
                   <%if (tipo == 0){%>checked<%}%> onclick="MuestraTabla(this.value)"/>
            <span class="etiqueta">Persona Moral</span>
        </td>
        <td width="20%" align="left">
            <input id="rdTipoPro" name="rdTipoPro" type="radio" value="fisica" 
                   <%if (tipo == 1){%>checked<%}%> onclick="MuestraTabla(this.value)"/>
            <span class="etiqueta">Persona Física</span>
        </td>
        <td align="right" width="60%">
            <input id="nacional" name="nacional" type="checkbox" <%if (nacional==1){%>checked<%}%>>
            <span class="etiqueta">Proveedor Nacional</span>
        </td>        
    </tr>
</table>
<table id="tbPerMoral" width="100%" align="center" cellpadding="5px" <%if (tipo == 1){%>style="display: none"<%}%>>
    <tr>
        <td width="100%">
            <table width="100%" align="center" frame="box">
                <tr>
                    <td width="60%">
                        <span class="etiqueta">Razón Social:</span><br>
                        <input id="razonProv" name="razonProv" class="text" type="text" value="<%=razonProv%>" style="width: 500px"
                            onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                            maxlength="120"/>
                    </td>
                    <td width="40%">
                        <span class="etiqueta">RFC:</span><br>
                        <input id="rfcPro" name="rfcPro" class="text" type="text" value="<%=rfc%>" style="width: 260px"
                            onkeypress="return ValidaRFC(event, this.value)" onblur="Mayusculas(this)"
                            maxlength="15" title="Ej. CCCC-000000-AAA"/>                                                            
                    </td>
                </tr>
                <tr>
                    <td width="100%" colspan="2">
                        <table width="100%" align="center" cellpadding="5px">
                            <tr>
                                <td width="100%">
                                    <span class="etiqueta">Representante Legal:</span>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%">
                                    <table width="100%" align="center">
                                        <tr>
                                            <td width="34%" align="center">
                                                <input id="nombreRepr" name="nombreRepr" class="text" type="text" value="<%=nombreRepr%>" style="width: 250px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="30"/>

                                            </td>
                                            <td width="33%" align="center">
                                                <input id="paternoRepr" name="paternoRepr" class="text" type="text" value="<%=paternoRepr%>" style="width: 250px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="20"/>
                                            </td>
                                            <td width="33%" align="center">
                                                <input id="maternoRepr" name="maternoRepr" class="text" type="text" value="<%=maternoRepr%>" style="width: 250px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="20"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="34%" align="center">
                                                <span class="etiquetaC">Nombre(s)</span>
                                            </td>
                                            <td width="33%" align="center">
                                                <span class="etiquetaC">Ap. Paterno</span>
                                            </td>
                                            <td width="33%" align="center">
                                                <span class="etiquetaC">Ap. Materno</span>
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
<table id="tbPerFisica" width="100%" align="center" cellpadding="5px" <%if (tipo == 0){%>style="display: none"<%}%>>
    <tr>
    </tr>
    <tr>
        <td width="25%" align="left">
            <input id="rfcProFis" name="rfcProFis" class="text" type="text" value="<%=rfc%>" style="width: 200px"
                   onkeypress="return ValidaRFC(event, this.value)" onblur="Mayusculas(this)"
                   maxlength="15" title="Ej. CCCC-000000-AAA"/>                                                            
        </td>        
        <td width="25%" align="center">
            <input id="nombreReprFis" name="nombreReprFis" class="text" type="text" value="<%=nombreRepr%>" style="width: 200px"
                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                maxlength="30"/>

        </td>
        <td width="25%" align="center">
            <input id="paternoReprFis" name="paternoReprFis" class="text" type="text" value="<%=paternoRepr%>" style="width: 200px"
                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                maxlength="20"/>
        </td>
        <td width="25%" align="center">
            <input id="maternoReprFis" name="maternoReprFis" class="text" type="text" value="<%=maternoRepr%>" style="width: 200px"
                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                maxlength="20"/>
        </td>
    </tr>
    <tr>
        <td width="25%" align="center">
            <span class="etiquetaC">RFC</span>
        </td>
        <td width="25%" align="center">
            <span class="etiquetaC">Nombre(s)</span>
        </td>
        <td width="25%" align="center">
            <span class="etiquetaC">Ap. Paterno</span>
        </td>
        <td width="25%" align="center">
            <span class="etiquetaC">Ap. Materno</span>
        </td>
    </tr>
</table>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="100%">
            <span class="etiqueta">Domicilio:</span>
        </td>
    </tr> 
    <tr>
        <td width="100%">
            <table width="100%" frame="box" align="center">
                <tr>
                    <td width="60%" colspan="2">
                        <span class="etiqueta">Calle y Número:</span><br>
                        <input id="callePro" name="callePro" class="text" type="text" value="<%=calle%>" style="width: 500px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               maxlength="50"/>
                    </td>
                    <td width="40%">
                        <span class="etiqueta">Colonia:</span><br>
                        <input id="coloniaPro" name="coloniaPro" class="text" type="text" value="<%=colonia%>" style="width: 270px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               maxlength="50"/>
                    </td>
                </tr>
                <tr>
                    <td width="20%" align="left">
                        <span class="etiqueta">C.P.:</span><br>
                        <input id="cpPro" name="cpPro" class="text" type="text" value="<%=sCp%>" style="width: 150px"
                               onkeypress="return ValidaNums(event)" maxlength="5"/>
                    </td>
                    <td width="30%" align="left">
                        <span class="etiqueta">Estado:</span><br>
                        <select id="estadoPro" name="estadoPro" class="combo" style="width: 250px"
                                onchange="CargaMunicipios(this.value)">
                            <option value="0">Elija el Estado...</option>
                            <%
                                List<Estado> estados = (List<Estado>) datosS.get("estados");
                                for (int i=0; i < estados.size(); i++){
                                    Estado edo = (Estado) estados.get(i);
                                %>
                                <option value="<%=edo.getIdestado()%>"
                                        <%
                                        if (edoActual!=null && edo.getIdestado()==edoActual.getIdestado()){
                                        %>
                                        selected
                                        <%
                                        }
                                        %>
                                        >
                                    <%=edo.getEstado()%>
                                </option>
                                <%
                                }
                            %>
                        </select>
                    </td>
                    <td width="50%" align="left">
                        <span class="etiqueta">Población:</span><br>
                        <select id="poblacionPro" name="poblacionPro" class="combo" style="width: 280px">
                            <option value="0">Elija la Población...</option>
                            <%
                            if (munActual!=null && munActual.getIdmunicipio()!=0){
                                for (int p=2; p >= 0; p--){                               
                                    List<Municipio> municipios = edoActual.getMunicipios();
                                    for (int i=0; i < municipios.size(); i++){
                                        Municipio m = municipios.get(i);
                                        if (m.getPrioridad()==p){
                                    %>
                                            <option value="<%=m.getIdmunicipio()%>"
                                                    <%
                                                    if (m.getIdmunicipio()==munActual.getIdmunicipio()){
                                                    %>
                                                    selected
                                                    <%
                                                    }
                                                    %>
                                                    >
                                                <%=m.getMunicipio()%>
                                            </option>
                                    <%
                                        }
                                    }
                                }
                            }
                            %>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%">&nbsp;</td>
    </tr>
</table>
<script lang="javascript">
    function MuestraTabla(tabla){
        var tbMor = document.getElementById('tbPerMoral');
        var tbFis = document.getElementById('tbPerFisica');
        var razon = document.getElementById('razonProv');
        var rfcFis = document.getElementById('rfcProFis');
        if (tabla == 'moral'){
            tbMor.style.display = '';
            tbFis.style.display = 'none';
            razon.focus();
        }
        else {
            tbMor.style.display = 'none';
            tbFis.style.display = '';  
            rfcFis.focus();
        }
    }
    
    
    function CargaMunicipios(estado){
        var poblacion = document.getElementById("poblacionPro");
        poblacion.length = 0;
        poblacion.options[0] = new Option('Elija la Población...','0');
        k=1;
    <%
        for (int i=0; i < estados.size(); i++){
            Estado edo = (Estado) estados.get(i);
        %>
            if (<%=edo.getIdestado()%> == estado){
            <%
                List<Municipio> munis = edo.getMunicipios();
                for (int j=0; j < munis.size(); j++){
                    Municipio mun = munis.get(j);
                %>
                    poblacion.options[k] = new Option('<%=mun.getMunicipio()%>','<%=mun.getIdmunicipio()%>');
                    k++;
                <%
                }
            %>
            }
        <%
        }
    %>
    }
</script>