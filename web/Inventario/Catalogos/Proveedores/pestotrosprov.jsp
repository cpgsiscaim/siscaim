<%@page import="net.sf.jasperreports.components.barbecue.BarcodeProviders.Int2of5Provider"%>
<%@page import="java.util.List, Modelo.Entidades.Proveedor, java.text.SimpleDateFormat"%>

<%
String banco = "", cuentaDeposito = "", sucBanco = "", descto1 = "0", descto2 = "0", descto3 = "0", plazo = "0", listaPrecios = "1";
String fechaAlta = "", fechaNormal = "", observacion = "", iva = "16";

if (datosS.get("accion").toString().equals("editar")){
    Proveedor prov = new Proveedor();
    prov = (Proveedor)datosS.get("proveedor");
    
    banco = prov.getBanco();
    cuentaDeposito = prov.getCuentaBanco();
    sucBanco = prov.getSucursalBanco();
    descto1 = Float.toString(prov.getDescuento1()).substring(0, Float.toString(prov.getDescuento1()).indexOf("."));
    descto2 = Float.toString(prov.getDescuento2()).substring(0, Float.toString(prov.getDescuento2()).indexOf("."));
    descto3 = Float.toString(prov.getDescuento3()).substring(0, Float.toString(prov.getDescuento3()).indexOf("."));
    plazo = Integer.toString(prov.getPlazo());
    listaPrecios = Integer.toString(prov.getListaPrecio());
    iva = Integer.toString(prov.getIva());
    SimpleDateFormat formato = new SimpleDateFormat("dd-MM-yyyy");
    if (prov.getFechaAlta()!=null){
        fechaAlta = formato.format(prov.getFechaAlta());
        //fechaAlta = prov.getFechaAlta().toString();
        //fechaNormal =fechaAlta.substring(8,10) + "-" + fechaAlta.substring(5,7) + "-" + fechaAlta.substring(0, 4);
    }
    observacion = prov.getObservaciones();
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="34%">
            <span class="etiqueta">Banco:</span><br>
            <input id="banco" name="banco" class="text" type="text" value="<%=banco%>" style="width: 260px"
                onkeypress="return ValidaAlfaNumSignos(event)" onblur="Mayusculas(this)"
                maxlength="80"/>                                                            
            
        </td>
        <td width="33%">
            <span class="etiqueta">Sucursal:</span><br>
            <input id="sucbanco" name="sucbanco" class="text" type="text" value="<%=sucBanco%>" style="width: 260px"
                onkeypress="return ValidaAlfaNumSignos(event)" onblur="Mayusculas(this)"
                maxlength="35"/>                                                            
        </td>
        <td width="33%">
            <span class="etiqueta">Cuenta de Depósito:</span><br>
            <input id="cuentaDep" name="cuentaDep" class="text" type="text" value="<%=cuentaDeposito%>" style="width: 260px"
                onkeypress="return ValidaAlfaNumSignos(event)" onblur="Mayusculas(this)"
                maxlength="35"/>                                                            
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
                        <span class="etiqueta"></span>
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="left">
                        <table width="100%" frame="box">
                            <tr>
                                <td width="34%" align="center">
                                    <span class="etiqueta">Uno:</span><br>
                                    <input id="descto1" name="descto1" value="<%=descto1%>" class="text" type="text" style="width: 50px"
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">Dos:</span><br>
                                    <input id="descto2" name="descto2" value="<%=descto2%>" class="text" type="text" style="width: 50px"
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">Tres:</span><br>
                                    <input id="descto3" name="descto3" value="<%=descto3%>" class="text" type="text" style="width: 50px"
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width="50%" align="left">
                        <table width="100%" frame="box">
                            <tr>
                                <td width="34%" align="center">
                                    <span class="etiqueta">Plazo (en días):</span><br>
                                    <input id="plazo" name="plazo" value="<%=plazo%>" class="text" type="text" style="width: 50px"
                                           maxlength="3" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">IVA:</span><br>
                                    <input id="iva" name="iva" value="<%=iva%>" class="text" type="text" style="width: 50px"
                                           maxlength="2" onkeypress="return ValidaNums(event)"/>
                                </td>
                                <td width="33%" align="center">
                                    <span class="etiqueta">Lista de Precios:</span><br>
                                    <input id="lista" name="lista" value="<%=listaPrecios%>" class="text" type="text" style="width: 50px"
                                           maxlength="2" onkeypress="return ValidaNums(event)"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="35%" align="center">
            <span class="etiqueta">Fecha de Alta:</span><br>
            <input id="fechaAlta" name="fechaAlta" type="text" class="text" readonly value="<%=fechaAlta%>"
                    title="Ingrese la fecha de alta del proveedor" style="width: 150px;"/>
            <%--<input id="fechaAlta" name="fechaAlta" value="<%=fechaAlta%>" type="hidden">
            <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechaNormal%>" onchange="cambiaFecha(this.value,'fechaAlta')" readonly>&nbsp;
            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                 onclick="displayCalendar(document.frmNuevoPro.rgFecha,'dd-mm-yyyy',document.frmNuevoPro.rgFecha)"
                 title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                 onclick="limpiar('rgFecha', 'fechaAlta')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>--%>
        </td>        
        <td width="65%" align="center" colspan="2">
            <span class="etiqueta">Observaciones:</span><br>
            <textarea id="observacion" name="observacion" class="text" style="width: 600px" rows="3"
                      onblur="Mayusculas(this)" maxlength="200"><%=observacion%></textarea>
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