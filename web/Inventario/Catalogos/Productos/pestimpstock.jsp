<%@page import="Modelo.Entidades.Producto"%>
<%@page import="java.util.List"%>

<%
String iep = "0", ivan = "16", ivae = "11", max = "", min = "";
if (datosS.get("accion").toString().equals("editar")){
    Producto prod = (Producto)datosS.get("producto");
    iep = Float.toString(prod.getIep());
    ivan = Float.toString(prod.getIvaNacional());
    ivae = Float.toString(prod.getIvaExtranjero());
    max = Float.toString(prod.getStockMaximo());
    min = Float.toString(prod.getStockMinimo());
}
%>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="100%">
            <span class="etiqueta">Impuestos:</span>
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="33%">
                        <span class="etiqueta">IEP*:</span><br>
                        <input id="iep" name="iep" type="text" class="text" value="<%=iep%>" style="width: 150px"
                               onkeypress="return ValidaCantidad(event)" maxlength="10" title="Ingrese el valor del IEP"/>
                    </td>
                    <td width="34%">
                        <span class="etiqueta">IVA Nacional*:</span><br>
                        <input id="ivan" name="ivan" type="text" class="text" value="<%=ivan%>" style="width: 150px"
                               onkeypress="return ValidaCantidad(event)" maxlength="10" title="ingrese el valor del IVA nacional"/>
                    </td>
                    <td width="33%">
                        <span class="etiqueta">IVA Extranjero*:</span><br>
                        <input id="ivae" name="ivae" type="text" class="text" value="<%=ivae%>" style="width: 150px"
                               onkeypress="return ValidaCantidad(event)" maxlength="10" title="ingrese el valor del iva extranjero"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%">
            <span class="etiqueta">Stock:</span>
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="50%" align="center">
                        <span class="etiqueta">Máximo*:</span><br>
                        <input id="stockmax" name="stockmax" type="text" class="text" value="<%=max%>" style="width: 150px"
                               onkeypress="return ValidaCantidad(event)" maxlength="10" title="ingrese el valor máximo de stock"/>
                    </td>
                    <td width="50%" align="center">
                        <span class="etiqueta">Mínimo*:</span><br>
                        <input id="stockmin" name="stockmin" type="text" class="text" value="<%=min%>" style="width: 150px"
                               onkeypress="return ValidaCantidad(event)" maxlength="10" title="ingrese el valor mínimo de stock"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<script lang="javascript">
</script>