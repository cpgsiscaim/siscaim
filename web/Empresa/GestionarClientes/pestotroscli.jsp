<%@page import="java.util.List, java.text.SimpleDateFormat, Modelo.Entidades.Cliente, Modelo.Entidades.Agente, Modelo.Entidades.Ruta"%>

<%
Agente agCli = new Agente();
//Ruta rutaCli = new Ruta();
String fechaAlta = "", fechaNormal = "", descto1 = "0", descto2 = "0", descto3 = "0", plazo = "0", limite = "0",  lista = "1";
SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
if (datosS.containsKey("editarCliente")){
    Cliente tempo = new Cliente();
    tempo = (Cliente)datosS.get("editarCliente");
    
    agCli = tempo.getAgente();
    //rutaCli = tempo.getRuta();
    fechaAlta = formato.format(tempo.getFechaAlta());
    //fechaAlta = tempo.getFechaAlta().toString();
    //fechaNormal =fechaAlta.substring(8,10) + "-" + fechaAlta.substring(5,7) + "-" + fechaAlta.substring(0, 4);
    descto1 = Float.toString(tempo.getDescuento1()).substring(0, Float.toString(tempo.getDescuento1()).indexOf("."));
    descto2 = Float.toString(tempo.getDescuento2()).substring(0, Float.toString(tempo.getDescuento2()).indexOf("."));
    descto3 = Float.toString(tempo.getDescuento3()).substring(0, Float.toString(tempo.getDescuento3()).indexOf("."));
    plazo = Integer.toString(tempo.getPlazo());
    limite = Float.toString(tempo.getLimite());
    lista = Integer.toString(tempo.getListaPrecios());
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="40%">
            <span class="etiqueta">Agente:</span><br>
            <select id="agente" name="agente" class="combo" style="width: 350px">
                <option value="0">Elija el Agente...</option>
            <%
                List<Agente> agentes = (List<Agente>)datosS.get("agentes");
                for (int i=0; i < agentes.size(); i++){
                    Agente ag = agentes.get(i);
                %>
                <option value="<%=ag.getId()%>"
                    <%
                    if (agCli.getId()!=0 && agCli.getId()==ag.getId()){
                    %>
                    selected
                    <%
                    }
                    %>
                    >
                    <%=ag.getEmpleado().getPersona().getNombreCompletoPorApellidos()%>
                </option>
                <%
                }
            %>
            </select>
        </td>
        <td width="30%">
            &nbsp;
        </td>
        <td width="30%">
            <span class="etiqueta">Fecha de Alta:</span><br>
            <input id="fechaAlta" name="fechaAlta" type="text" class="text" readonly value="<%=fechaAlta%>"
                    title="Ingrese la fecha de alta del cliente" style="width: 150px;"/>
            <%--<input id="fechaAlta" name="fechaAlta" value="<%=fechaAlta%>" type="hidden">
            <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechaNormal%>" onchange="cambiaFecha(this.value,'fechaAlta')" readonly>&nbsp;
            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                 onclick="displayCalendar(document.frmNuevoCli.rgFecha,'dd-mm-yyyy',document.frmNuevoCli.rgFecha)"
                 title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                 onclick="limpiar('rgFecha', 'fechaAlta')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>--%>
        </td>
    </tr>
    <tr>
        <td align="center" width="100%" colspan="3">
            <table width="100%">
                <tr>
                    <td width="50%" align="left">
                        <span class="etiqueta">Descuentos (en %):</span>
                    </td>
                    <td width="50%" align="left">
                        <span class="etiqueta">Crédito:</span>
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="left">
                        <table width="100%" frame="box">
                            <tr>
                                <td width="34%" align="center">
                                    <span class="etiqueta">Uno:</span><br>
                                    <input id="descto1" name="descto1" value="<%=descto1%>" type="text" class="text" style="width: 50px"
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">Dos:</span><br>
                                    <input id="descto2" name="descto2" value="<%=descto2%>" type="text" class="text" style="width: 50px"
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">Tres:</span><br>
                                    <input id="descto3" name="descto3" value="<%=descto3%>" type="text" class="text" style="width: 50px"
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="50%" align="left">
                        <table width="100%" frame="box">
                            <tr>
                                <td width="50%" align="center">
                                    <span class="etiqueta">Plazo (en días):</span><br>
                                    <input id="plazo" name="plazo" value="<%=plazo%>" type="text" class="text" style="width: 150px"
                                           maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="50%" align="center">
                                    <span class="etiqueta">Límite:</span><br>
                                    <input id="limite" name="limite" value="<%=limite%>" type="text" class="text" style="width: 150px"
                                           maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left" width="100%" colspan="3">
            <span class="etiqueta">Lista de Precios:</span><br>
            <input id="listap" name="listap" value="<%=lista%>" type="text" class="text" style="width: 150px"
                   maxlength="1" onkeypress="return ValidaCantidad(event, this.value)" title="Valor entre 1 y 5"/>            
        </td>
    </tr>
    <tr>
        <td width="100%" align="center" colspan="3">
        </td>
    </tr>
    <tr><td colspan="3">&nbsp;</td></tr>
</table>

<script type="text/javascript">
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
</script>