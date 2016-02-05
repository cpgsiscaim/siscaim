<%@page import="Modelo.Entidades.Producto"%>
<%@page import="java.util.List, java.util.Date"%>

<%
String fechaUltCom = "", fechaUltComN = "", fechaUltVen = "", fechaUltVenN = "", codAlterno = "";
Date dhoy = (Date)datosS.get("hoy");
String shoy = dhoy.toString();
String hoyN = shoy.substring(8,10) + "-" + shoy.substring(5,7) + "-" + shoy.substring(0, 4);
fechaUltCom = shoy; fechaUltComN = hoyN; fechaUltVen = shoy; fechaUltVenN = hoyN;
if (datosS.get("accion").toString().equals("editar")){
    Producto prod = (Producto)datosS.get("producto");
    if (prod.getFechaUltCompra()!=null){
        fechaUltCom = prod.getFechaUltCompra().toString();
        fechaUltComN =fechaUltCom.substring(8,10) + "-" + fechaUltCom.substring(5,7) + "-" + fechaUltCom.substring(0, 4);
    }
    if (prod.getFechaUltVenta()!=null){
        fechaUltVen = prod.getFechaUltVenta().toString();
        fechaUltVenN =fechaUltVen.substring(8,10) + "-" + fechaUltVen.substring(5,7) + "-" + fechaUltVen.substring(0, 4);
    }
    if (prod.getCodigoAlterno()!=null)
        codAlterno = prod.getCodigoAlterno();
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="35%">
            <span class="etiqueta">Fecha Última Compra:</span><br>
            <input id="fechauc" name="fechauc" type="text" class="text" readonly value="<%=fechaUltComN%>"
                   title="Ingrese la fecha de la última vez que se compró el producto"/>
            <%--
            <input id="fechauc" name="fechauc" value="<%=fechaUltCom%>" type="hidden">
            <input id="rgFechaUc" name="rgFechaUc" class="cajaDatos" style="width:120px" type="text" value="<%=fechaUltComN%>" onchange="cambiaFecha(this.value,'fechauc')" readonly>&nbsp;
            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                 onclick="displayCalendar(document.frmNuevoPro.rgFechaUc,'dd-mm-yyyy',document.frmNuevoPro.rgFechaUc)"
                 title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                 onclick="limpiar('rgFechaUc', 'fechauc')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
            --%>
        </td>
        <td width="35%">
            <span class="etiqueta">Fecha Última Venta:</span><br>
            <input id="fechauv" name="fechauv" type="text" class="text" readonly value="<%=fechaUltVenN%>"
                   title="Ingrese la fecha de la última vez que se vendió el producto"/>
            <%--
            <input id="fechauv" name="fechauv" value="<%=fechaUltVen%>" type="hidden">
            <input id="rgFechaUv" name="rgFechaUv" class="cajaDatos" style="width:120px" type="text" value="<%=fechaUltVenN%>" onchange="cambiaFecha(this.value,'fechauv')" readonly>&nbsp;
            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                 onclick="displayCalendar(document.frmNuevoPro.rgFechaUv,'dd-mm-yyyy',document.frmNuevoPro.rgFechaUv)"
                 title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                 onclick="limpiar('rgFechaUv', 'fechauv')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
            --%>
        </td>
        <td width="30%">
            <span class="etiqueta">Código Alterno:</span><br>
            <input id="codalt" name="codalt" type="text" class="text" value="<%=codAlterno%>" style="width: 200px"
                onkeypress="return ValidaAlfaNumSignos(event)" onblur="Mayusculas(this)" maxlength="20"
                title="Ingrese el código alterno del producto"/>
        </td>
    </tr>
</table>


<script lang="javascript">
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