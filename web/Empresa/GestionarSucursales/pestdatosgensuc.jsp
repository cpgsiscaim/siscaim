<%@page import="Modelo.Entidades.Sucursal"%>
<%@page import="Modelo.Entidades.DatosFiscales, Modelo.Entidades.Catalogos.Estado"%>
<%@page import="java.util.List, Modelo.Entidades.Catalogos.Estado, Modelo.Entidades.Catalogos.Municipio"%>

<%
String nombreSuc = "", rfc = "", calle = "", colonia = "", nombreRepr = "", paternoRepr = "", maternoRepr = "", sCp = "", regpatr="";
int cp = 0;
Municipio munActual = null;
Estado edoActual = null;

if (datosS.containsKey("sucTempo") || datosS.containsKey("editarSuc")){
    Sucursal tempo = new Sucursal();
    if (datosS.containsKey("sucTempo"))
        tempo = (Sucursal)datosS.get("sucTempo");
    else
        tempo = (Sucursal)datosS.get("editarSuc");
    nombreSuc = tempo.getDatosfis().getRazonsocial();
    rfc = tempo.getDatosfis().getRfc();
    calle = tempo.getDatosfis().getDireccion().getCalle();
    colonia = tempo.getDatosfis().getDireccion().getColonia();
    nombreRepr = tempo.getDatosfis().getPersona().getNombre();
    paternoRepr = tempo.getDatosfis().getPersona().getPaterno();
    maternoRepr = tempo.getDatosfis().getPersona().getMaterno();
    cp = tempo.getDatosfis().getDireccion().getCp();
    if (cp!=0)
        sCp = Integer.toString(tempo.getDatosfis().getDireccion().getCp());
    munActual = tempo.getDatosfis().getDireccion().getPoblacion();
    edoActual = tempo.getDatosfis().getDireccion().getPoblacion().getEstado();
    regpatr = tempo.getRegistropatronal();
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="40%">
            <span class="etiqueta">Nombre:</span><br>
            <input id="nombreSuc" name="nombreSuc" class="text" type="text" value="<%=nombreSuc%>" style="width: 300px"
                   onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                   maxlength="120"/>
        </td>
        <td width="30%">
            <span class="etiqueta">RFC:</span><br>
            <input id="rfcSuc" name="rfcSuc" class="text" type="text" value="<%=rfc%>" style="width: 200px"
                   onkeypress="return ValidaRFC(event, this.value)" onblur="Mayusculas(this)"
                   maxlength="15" title="Ej. CCCC-000000-AAA"/>                                                            
        </td>
        <td width="30%">
            <span class="etiqueta">Registro Patronal:</span><br>
            <input id="registropatronal" name="registropatronal" class="text" type="text" value="<%=regpatr%>" style="width: 200px"
                onblur="Mayusculas(this)" maxlength="20"/>
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
                        <input id="calleSuc" name="calleSuc" class="text" type="text" value="<%=calle%>" style="width: 500px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               maxlength="50"/>
                    </td>
                    <td width="40%">
                        <span class="etiqueta">Colonia:</span><br>
                        <input id="coloniaSuc" name="coloniaSuc" class="text" type="text" value="<%=colonia%>" style="width: 270px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               maxlength="50"/>
                    </td>
                </tr>
                <tr>
                    <td width="20%" align="left">
                        <span class="etiqueta">C.P.:</span><br>
                        <input id="cpSuc" name="cpSuc" class="text" type="text" value="<%=sCp%>" style="width: 150px"
                               onkeypress="return ValidaNums(event)" maxlength="5"/>
                    </td>
                    <td width="30%" align="left">
                        <span class="etiqueta">Estado:</span><br>
                        <select id="estadoSuc" name="estadoSuc" class="combo" style="width: 250px"
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
                        <select id="poblacionSuc" name="poblacionSuc" class="combo" style="width: 280px">
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
    <tr>
        <td width="100%">
            &nbsp;
        </td>
    </tr>
</table>
<script lang="javascript">
    function CargaMunicipios(estado){
        var poblacion = document.getElementById("poblacionSuc");
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