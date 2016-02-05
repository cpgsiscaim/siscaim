<%-- 
    Document   : pesteditaremp
    Created on : Jun 6, 2012, 11:38:28 PM
    Author     : roman
--%>

<%@page import="java.util.List, java.text.SimpleDateFormat, Modelo.Entidades.Empleado, Modelo.Entidades.Persona, Modelo.Entidades.Catalogos.Civil, Modelo.Entidades.Catalogos.GpoSanguineo, Modelo.Entidades.Catalogos.Estado, Modelo.Entidades.Catalogos.Municipio, Modelo.Entidades.Sucursal, Modelo.Entidades.Catalogos.Titulo"%>
<%
//HashMap datosS = sesion.getDatos();
//Civil edoCivActual = null;

Municipio munActual = null;
Estado edoActual = null;
//GpoSanguineo gpoSangActual = null;

String nombre= "", paterno= "", materno= "", curp= "", fnaci= "", dian= "", mesn= "", telefono= "", rfc= "";
String calle = "", numero = "", fechaAlta = "", fechaNac = "", colonia="", sexo="", clave = "", nombreEdoNac = "";
int cp = 0, edoNac = 0;
List<Estado> estados = (List<Estado>) datosS.get("estados");

if (datosS.containsKey("editarEmpleado") || datosS.containsKey("nuevoEmpleado")){
    //Empleado tempo = new Empleado();
    if (datosS.containsKey("editarEmpleado"))
        tempo = (Empleado)datosS.get("editarEmpleado");
    else
        tempo = (Empleado)datosS.get("nuevoEmpleado");
    clave = tempo.getClave();
    nombre = tempo.getPersona().getNombre();
    paterno = tempo.getPersona().getPaterno();
    materno = tempo.getPersona().getMaterno();
    sexo = tempo.getPersona().getSexo();
    curp = tempo.getPersona().getCurp()!=null?tempo.getPersona().getCurp():"";
    rfc = tempo.getPersona().getRfc()!=null?tempo.getPersona().getRfc():"";
    telefono = tempo.getPersona().getDireccion().getTelefono()!=null?tempo.getPersona().getDireccion().getTelefono():"";
    SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
    fechaNac = formato.format(tempo.getPersona().getFnaci());//!=null?tempo.getPersona().getFnaci().toString():"");
    fechaAlta = formato.format(tempo.getFecha());
    //fechaNormal = fechaAlta.substring(8,10) + "-" + fechaAlta.substring(5,7) + "-" + fechaAlta.substring(0, 4);
    //fechaAlta = tempo.getPersona().getFnaci()!=null?tempo.getPersona().getFnaci().toString():"";
    //fechaNormal =!fechaAlta.equals("")?fechaAlta.substring(8,10) + "-" + fechaAlta.substring(5,7) + "-" + fechaAlta.substring(0, 4):"";
    calle = tempo.getPersona().getDireccion().getCalle();
    numero = tempo.getPersona().getDireccion().getNumero()!=null?tempo.getPersona().getDireccion().getNumero():"";
    munActual = tempo.getPersona().getDireccion().getPoblacion();
    edoActual = tempo.getPersona().getDireccion().getPoblacion().getEstado();
    colonia = tempo.getPersona().getDireccion().getColonia();
    cp = tempo.getPersona().getDireccion().getCp();
    edoNac = tempo.getPersona().getLugarn();
    for (int e=0; e < estados.size(); e++){
        Estado ed = estados.get(e);
        if (ed.getIdestado()==edoNac)
            nombreEdoNac = ed.getEstado();
    }
}

%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="100%">
            <table width="100%" align="center" frame="box">
                <tr>
                    <td width="34%" align="left">
                        <span class="etiqueta">Clave:</span>
                        <input id="clave" name="clave" type="text" class="text" value="<%=clave%>" style="width: 100px"
                            onkeypress="return ValidaAlfaNum(event)" onblur="Mayusculas(this)" onchange="CambiaClase(this, 'text')"
                            maxlength="5"/>
                    </td>
                    <td width="33%" align="left">
                        <span class="etiqueta">CURP:</span>
                        <input id="curpPer" name="curpPer" type="text" class="text" value="<%=curp%>" style="width: 250px"
                               maxlength="20" onblur="Mayusculas(this)"/>
                    </td>
                    <td width="33%" align="left">
                        <span class="etiqueta">RFC:</span>
                        <input id="rfcPer" name="rfcPer" type="text" class="text" value="<%=rfc%>" style="width: 200px"
                               maxlength="15" onblur="Mayusculas(this)"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%">
            <table width="100%" align="center" frame="box">
                <tr>
                    <td width="34%">
                        <span class="etiqueta">Nombre(s):</span><br>
                        <input id="nombrePer" name="nombrePer" type="text" class="text" value="<%=nombre%>" style="width: 300px"
                            onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                            onchange="CalculaCurpRfc(this, 'text')" maxlength="30"/>
                    </td>
                    <td width="33%">
                        <span class="etiqueta">Ap. Paterno:</span><br>
                        <input id="paternoPer" name="paternoPer" type="text" class="text" value="<%=paterno%>" style="width: 300px"
                            onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                            onchange="CalculaCurpRfc(this, 'text')" maxlength="20"/>
                    </td>
                    <td width="33%">
                        <span class="etiqueta">Ap. Materno:</span><br>
                        <input id="maternoPer" name="maternoPer" type="text" class="text" value="<%=materno%>" style="width: 300px"
                            onkeypress="return ValidaNombrePropio(event, this.value)" onblur="Mayusculas(this)"
                            onchange="CalculaCurpRfc(this, 'text')" maxlength="20"/>
                    </td>                    
                </tr>
                <tr>
                    <td width="100%" colspan="3">
                        <table width="100%">
                            <tr>
                                <td width="30%">
                                    <span class="etiqueta">Estado de Nacimiento:</span><br>
                                    <input id="edoNacNom" name="edoNacNom" type="hidden" value="<%=nombreEdoNac%>"/>
                                    <select id="estadoNac" name="estadoNac" class="combo" style="width: 250px"
                                            onchange="CargaNombreEstado(this, 'combo')">
                                        <option value="0">Elija el Estado...</option>
                                        <%
                                            for (int i = 0; i < estados.size(); i++) {
                                                Estado edo = (Estado) estados.get(i);
                                        %>
                                        <option value="<%=edo.getIdestado()%>"
                                                <%if (edo.getIdestado() == edoNac) {%>
                                                selected
                                                <%}%>
                                                >
                                            <%=edo.getEstado()%>
                                        </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">Sexo:</span><br>
                                    <select id="sexoPer" name="sexoPer" class="combo" style="width: 146px"
                                            onchange="CalculaCurpRfc(this, 'combo')">
                                        <option value="">Sexo...</option>
                                        <option value="M"
                                            <% if (sexo.equals("M")){%>
                                            selected <% } %>>
                                            MASCULINO
                                        </option>
                                        <option value="F"
                                            <% if (sexo.equals("F")){%>
                                            selected <% } %>>                                
                                            FEMENINO
                                        </option>
                                    </select>
                                </td>
                                <td width="25%">
                                    <span class="etiqueta">Fecha de Nacimiento:</span><br>
                                    <input id="fechaNac" name="fechaNac" type="text" class="text" readonly value="<%=fechaNac%>"
                                        title="Ingrese la fecha de nacimiento" onchange="CalculaCurpRfc(this, 'text')"/>
                                </td>
                                <td width="25%">
                                    <span class="etiqueta">Fecha de Ingreso:</span><br>
                                    <input id="fechaAlta" name="fechaAlta" type="text" class="text" readonly value="<%=fechaAlta%>"
                                        title="Ingrese la fecha de ingreso a la empresa" onchange="CambiaClase(this, 'text')"/>
                                    <%--
                                    <input id="fechaAlta" name="fechaAlta" value="<%=fechaAlta%>" type="hidden">
                                    <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechaNormal%>"
                                        onfocus="displayCalendar(document.frmNuevoEmp.rgFecha,'dd-mm-yyyy',document.frmNuevoEmp.rgFecha)"
                                        onchange="cambiaFecha(this.value,'fechaAlta')" readonly>&nbsp;
                                    <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                                        onclick="displayCalendar(document.frmNuevoEmp.rgFecha,'dd-mm-yyyy',document.frmNuevoEmp.rgFecha)"
                                        title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
                                    <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                                        onclick="limpiar('rgFecha', 'fechaAlta')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
                                    --%>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
       </td>       
    </tr>
    <tr>
        <td width="100%">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="100%">
                        <span class="etiqueta">Domicilio:</span>
                    </td>
                </tr>     
            </table>            
        </td>
    </tr>
    <tr>
        <td width="100%">
            <table width="100%" frame="box" align="center" cellpadding="5px">
                <tr>
                    <td width="50%">
                        <span class="etiqueta">Calle y Número:</span><br>
                        <input id="callenumPer" name="callenumPer" type="text" class="text" value="<%=calle%>" style="width: 300px"
                               onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                               onchange="CambiaClase(this, 'text')" maxlength="50"/>
                        <input id="numero" name="numero" type="text" class="text" value="<%=numero%>" style="width: 80px; text-align: right"
                               onblur="Mayusculas(this)" onchange="CambiaClase(this, 'text')" maxlength="15"/>
                    </td>
                    <td width="25%">
                        <span class="etiqueta">Colonia:</span><br>
                        <input id="coloniaPer" name="coloniaPer" type="text" class="text" value="<%=colonia%>"  style="width: 250px"
                               onkeypress="return ValidaRazonSocial(event, this.value)"
                               onblur="Mayusculas(this)" maxlength="50" onchange="CambiaClase(this, 'text')"/>
                    </td>
                    <td width="25%">
                        <span class="etiqueta">C.P. :</span><br>
                        <input id="codigopPer" name="codigopPer" type="text" value="<%=cp==0?"":cp%>" style="width: 140px"
                               onkeypress="return ValidaNums(event)"
                               onblur="Mayusculas(this)" maxlength="5"/>
                    </td>        
                </tr>    
                <tr>
                    <td width="50%">
                        <span class="etiqueta">Estado:</span><br>
                        <select id="estadoPer" name="estadoPer" class="combo" style="width: 350px"
                                onchange="CargaMunicipios(this.value)">
                            <option value="0">Elija el Estado...</option>
                            <%
                                for (int i = 0; i < estados.size(); i++) {
                                    Estado edo = (Estado) estados.get(i);
                            %>
                            <option value="<%=edo.getIdestado()%>"
                                    <%
                                        if (edoActual != null && edo.getIdestado() == edoActual.getIdestado()) {
                                    %>
                                    selected
                                    <%                                            }
                                    %>
                                    >
                                <%=edo.getEstado()%>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </td>
                    <td width="50%" colspan="2">
                        <span class="etiqueta">Población:</span><br>
                        <select id="poblacionPer" name="poblacionPer" class="combo" style="width: 350px"
                                onchange="CambiaClase(this, 'combo')">
                            <option value="0">Elija la Población...</option>
                            <%
                                if (munActual != null) {
                                    for (int p = 2; p >= 0; p--) {
                                        List<Municipio> municipios = edoActual.getMunicipios();
                                        for (int i = 0; i < municipios.size(); i++) {
                                            Municipio m = municipios.get(i);
                                            if (m.getPrioridad() == p) {
                            %>
                            <option value="<%=m.getIdmunicipio()%>"
                                    <%
                                        if (m.getIdmunicipio() == munActual.getIdmunicipio()) {
                                    %>
                                    selected
                                    <%                                                        }
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
</table>

<script type="text/javascript">
    function CargaNombreEstado(obj, clase){
        CambiaClase(obj, clase);
        var edoNacNom = document.getElementById('edoNacNom');
        edoNacNom.value = '';
        if (obj.value!='0'){
            edoNacNom.value = obj.options[obj.selectedIndex].text;
        }
        CalculaCurpRfc(obj, clase);
    }
    
    function CalculaCurpRfc(obj, clase){
        CambiaClase(obj, clase);
        //validar los campos
        var nombre = document.getElementById('nombrePer');
        var paterno = document.getElementById('paternoPer');
        var materno = document.getElementById('maternoPer');
        var mat = 'X';
        if (materno.value!='')
            mat = materno.value;
        var edonac = document.getElementById('estadoNac');
        var nombreEdo = document.getElementById('edoNacNom');
        var sexo = document.getElementById('sexoPer');
        var fnac = document.getElementById('fechaNac');
        var curp = document.getElementById('curpPer');
        curp.value = '';
        var rfc = document.getElementById('rfcPer');
        rfc.value = '';
        if (nombre.value != '' && paterno.value != '' && edonac.value!='0'
            && sexo.value != '' && fnac.value != ''){
            curp.value = obtenerCurp(paterno.value, mat, nombre.value, sexo.value, nombreEdo.value, fnac.value);
            rfc.value = obtenerRfc(paterno.value, mat, nombre.value, fnac.value);
        }
    }
</script>
