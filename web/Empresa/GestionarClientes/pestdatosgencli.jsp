<%@page import="Modelo.Entidades.Cliente"%>
<%@page import="Modelo.Entidades.DatosFiscales, Modelo.Entidades.Catalogos.Estado"%>
<%@page import="java.util.List, Modelo.Entidades.Catalogos.Municipio"%>

<%
String razonCli = "", rfc = "", calle = "", colonia = "", nombreRepr = "", paternoRepr = "", maternoRepr = "", sCp = "";
String prefijo = "", nomlargo = "";
int cp = 0, tipo = 0;
Municipio munActual = null;
Estado edoActual = null;
int cglobal = 0;

if (datosS.containsKey("editarCliente")){
    Cliente tempo = new Cliente();
    tempo = (Cliente)datosS.get("editarCliente");
    tipo = tempo.getTipo();
    razonCli = tempo.getDatosFiscales().getRazonsocial();
    rfc = tempo.getDatosFiscales().getRfc();
    calle = tempo.getDatosFiscales().getDireccion().getCalle();
    colonia = tempo.getDatosFiscales().getDireccion().getColonia();
    if (tempo.getDatosFiscales().getPersona()!=null){
        nombreRepr = tempo.getDatosFiscales().getPersona().getNombre();
        paternoRepr = tempo.getDatosFiscales().getPersona().getPaterno();
        maternoRepr = tempo.getDatosFiscales().getPersona().getMaterno();
    }
    cp = tempo.getDatosFiscales().getDireccion().getCp();
    if (cp!=0)
        sCp = Integer.toString(tempo.getDatosFiscales().getDireccion().getCp());
    munActual = tempo.getDatosFiscales().getDireccion().getPoblacion();
    edoActual = tempo.getDatosFiscales().getDireccion().getPoblacion().getEstado();
    cglobal = tempo.getCglobal();
    prefijo = tempo.getPrefijo()!=null?tempo.getPrefijo():"";
    nomlargo = tempo.getNombrecompleto()!=null?tempo.getNombrecompleto():"";
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="20%" align="left">
            <input id="rdTipoCli" name="rdTipoCli" type="radio" value="moral" 
                   <%if (tipo == 0){%>checked<%}%> onclick="MuestraTabla(this.value)"/>
            <span class="etiqueta">Persona Moral</span>
        </td>
        <td width="20%" align="left">
            <input id="rdTipoCli" name="rdTipoCli" type="radio" value="fisica" 
                   <%if (tipo == 1){%>checked<%}%> onclick="MuestraTabla(this.value)"/>
            <span class="etiqueta">Persona Física</span>
        </td>
        <td align="right" width="60%">
            <input id="global" name="global" type="checkbox" <%if (cglobal==1){%>checked<%}%>>
            <span class="etiqueta">Cliente Nacional</span>
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
                        <input id="razonCli" name="razonCli" type="text" class="text" value="<%=razonCli%>" style="width: 500px"
                            onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                            maxlength="120"/>
                    </td>
                    <td width="40%">
                        <span class="etiqueta">RFC:</span><br>
                        <input id="rfcCli" name="rfcCli" type="text" class="text" value="<%=rfc%>" style="width: 260px"
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
                                                <input id="nombreRepr" name="nombreRepr" type="text" class="text" value="<%=nombreRepr%>" style="width: 250px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="30"/>

                                            </td>
                                            <td width="33%" align="center">
                                                <input id="paternoRepr" name="paternoRepr" type="text" class="text" value="<%=paternoRepr%>" style="width: 250px"
                                                    onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                                                    maxlength="20"/>
                                            </td>
                                            <td width="33%" align="center">
                                                <input id="maternoRepr" name="maternoRepr" type="text" class="text" value="<%=maternoRepr%>" style="width: 250px"
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
            <input id="rfcCliFis" name="rfcCliFis" type="text"text class="" value="<%=rfc%>" style="width: 200px"
                   onkeypress="return ValidaRFC(event, this.value)" onblur="Mayusculas(this)"
                   maxlength="15" title="Ej. CCCC-000000-AAA"/>                                                            
        </td>        
        <td width="25%" align="center">
            <input id="nombreReprFis" name="nombreReprFis" type="text" class="text" value="<%=nombreRepr%>" style="width: 200px"
                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                maxlength="30"/>

        </td>
        <td width="25%" align="center">
            <input id="paternoReprFis" name="paternoReprFis" type="text" class="text" value="<%=paternoRepr%>" style="width: 200px"
                onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                maxlength="20"/>
        </td>
        <td width="25%" align="center">
            <input id="maternoReprFis" name="maternoReprFis" type="text" class="text" value="<%=maternoRepr%>" style="width: 200px"
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
            <table width="100%">
                <tr>
                    <td width="30%">
                        <span class="etiqueta">Prefijo:</span><br>
                        <input id="prefijo" name="prefijo" type="text" class="text" value="<%=prefijo%>" style="width: 120px"
                               maxlength="20"/>
                    </td>
                    <td width="70%">
                        <span class="etiqueta">Nombre Completo:</span><br>
                        <input id="completo" name="completo" type="text" class="text" value="<%=nomlargo%>" style="width: 500px"
                            onblur="Mayusculas(this)" maxlength="120"/>
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
                        <input id="calleCli" name="calleCli" type="text" class="text" value="<%=calle%>" style="width: 500px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               maxlength="50"/>
                    </td>
                    <td width="40%">
                        <span class="etiqueta">Colonia:</span><br>
                        <input id="coloniaCli" name="coloniaCli" type="text" class="text" value="<%=colonia%>" style="width: 270px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               maxlength="50"/>
                    </td>
                </tr>
                <tr>
                    <td width="20%" align="left">
                        <span class="etiqueta">C.P.:</span><br>
                        <input id="cpCli" name="cpCli" type="text" class="text" value="<%=sCp%>" style="width: 150px"
                               onkeypress="return ValidaNums(event)" maxlength="5"/>
                    </td>
                    <td width="30%" align="left">
                        <span class="etiqueta">Estado:</span><br>
                        <select id="estadoCli" name="estadoCli" class="combo" style="width: 250px"
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
                        <select id="poblacionCli" name="poblacionCli" class="combo" style="width: 280px">
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
        var razon = document.getElementById('razonCli');
        var rfcFis = document.getElementById('rfcCliFis');
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
        var poblacion = document.getElementById("poblacionCli");
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