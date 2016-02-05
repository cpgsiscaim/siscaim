<%@page import="java.util.List, Modelo.Entidades.Cliente, Modelo.Entidades.Agente, Modelo.Entidades.Ruta"%>

<%
Agente agCli = new Agente();
Ruta rutaCli = new Ruta();
String fechaAlta = "", descto1 = "", descto2 = "", descto3 = "", plazo = "", limite = "";

if (datosS.containsKey("cliTempo") || datosS.containsKey("editarCli")){
    Cliente tempo = new Cliente();
    if (datosS.containsKey("sucTempo"))
        tempo = (Cliente)datosS.get("cliTempo");
    else
        tempo = (Cliente)datosS.get("editarCli");
    
    agCli = tempo.getAgente();
    rutaCli = tempo.getRuta();
    fechaAlta = tempo.getFechaAlta().toString();
    descto1 = Float.toString(tempo.getDescuento1());
    descto2 = Float.toString(tempo.getDescuento2());
    descto3 = Float.toString(tempo.getDescuento3());
    plazo = Integer.toString(tempo.getPlazo());
    limite = Float.toString(tempo.getLimite());
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="40%">
            <span class="etiqueta">Agente:</span><br>
            <select id="agente" name="agente" class="combo" style="width: 350px">
                <option value="0">Elija el Agente...</option>
            </select>
        </td>
        <td width="30%">
            <span class="etiqueta">Ruta:</span><br>
            <select id="ruta" name="ruta" class="combo" style="width: 250px">
                <option value="0">Elija la Ruta...</option>
            </select>
        </td>
        <td width="30%">
            <span class="etiqueta">Fecha de Alta:</span><br>
            <input id="fechaAlta" name="fechaAlta" value="" type="hidden">
            <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" onchange="cambiaFecha(this.value,'fechaAlta')" readonly>&nbsp;
            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                 onclick="displayCalendar(document.frmNuevoCli.rgFecha,'dd-mm-yyyy',document.frmNuevoCli.rgFecha)"
                 title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                 onclick="limpiar('rgFecha', 'fechaAlta')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
        </td>
    </tr>
    <tr>
        <td colspan="3" align="left">
            <span class="etiqueta">Descuentos:</span>
        </td>
    </tr>
    <tr>
        <td width="100%" align="center" colspan="3">
            <table width="100%" frame="box">
                <tr>
                    <td width="34%" align="center">
                        <span class="etiqueta">Uno:</span><br>
                        <input id="descto1" name="descto1" value="" type="text" style="width: 250px"/>
                    </td>
                    <td width="33%" align="center">
                        <span class="etiqueta">Dos:</span><br>
                        <input id="descto2" name="descto2" value="" type="text" style="width: 250px"/>
                    </td>
                    <td width="33%" align="center">
                        <span class="etiqueta">Tres:</span><br>
                        <input id="descto3" name="descto3" value="" type="text" style="width: 250px"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="3" align="left">
            <span class="etiqueta">Crédito:</span>
        </td>
    </tr>
    <tr>
        <td width="100%" align="center" colspan="3">
            <table width="100%" frame="box">
                <tr>
                    <td width="50%" align="center">
                        <span class="etiqueta">Plazo:</span><br>
                        <input id="plazo" name="plazo" value="" type="text" style="width: 250px"/>
                    </td>
                    <td width="50%" align="center">
                        <span class="etiqueta">Límite:</span><br>
                        <input id="limite" name="limite" value="" type="text" style="width: 250px"/>
                    </td>
                </tr>
            </table>
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