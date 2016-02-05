<%@page import="Modelo.Entidades.CostoProducto, Modelo.Entidades.PrecioProducto"%>
<%@page import="Modelo.Entidades.Producto, Modelo.Entidades.Sucursal"%>
<%@page import="java.util.List, java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat, java.text.NumberFormat"%>

<%
String precio1 = "1", precio2 = "1.2", precio3 = "1.25", precio4 = "1.3", precio5 = "1.4";
String prcalc1 = "0", prcalc2 = "0", prcalc3 = "0", prcalc4 = "0", prcalc5 = "0";
String descto1 = "0", descto2 = "0", descto3 = "0", descto4 = "0", descto5 = "0", descMax = "0";
List<Sucursal> sucursales = (List<Sucursal>)datosS.get("sucursales");
List<CostoProducto> costos = new ArrayList();
List<PrecioProducto> precios = new ArrayList();
NumberFormat formato = new DecimalFormat("#,##0.00");
int aplicarcosto = 0, aplicarprecios = 1;
if (datosS.get("accion").toString().equals("editar")){
    Producto prod = (Producto)datosS.get("producto");
    costos = (List<CostoProducto>)datosS.get("costosact");
    precios = (List<PrecioProducto>)datosS.get("preciosact");
    aplicarcosto = prod.getAplicarcosto();
    aplicarprecios = prod.getAplicarprecios();
    
    descto1 = Float.toString(prod.getDescuento1());
    descto2 = Float.toString(prod.getDescuento2());
    descto3 = Float.toString(prod.getDescuento3());
    descto4 = Float.toString(prod.getDescuento4());
    descto5 = Float.toString(prod.getDescuento5());
    descMax = Float.toString(prod.getDescuentoMaximo());
}
%>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="100%">
            <span class="etiqueta">Costos:</span>
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="100%">
                        <!-- tabla de costos registrados -->
                        <table width="70%" class="tablaLista" align="center">
                            <thead>
                                <tr>
                                    <td align="center" width="40%">
                                        <span>Sucursal</span>
                                    </td>
                                    <td align="center" width="60%" colspan="2">
                                        <span>Costo</span>
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (int i=0; i < sucursales.size(); i++){
                                    Sucursal suc = sucursales.get(i);
                                    //obtener costo de sucursal
                                    String cos = "";
                                    if (datosS.get("accion").toString().equals("editar")){
                                        for (int c=0; c < costos.size(); c++){
                                            CostoProducto cc = costos.get(c);
                                            if (cc.getSucursal().getId()==suc.getId()){
                                                cos = formato.format(cc.getCosto());
                                            }
                                        }
                                    }
                                %>
                                    <tr>
                                        <td align="left" width="40%">
                                            <input id="tiposuccosto<%=i%>" name="tiposuccosto<%=i%>" type="hidden" value="<%=suc.getTipo()%>"/>
                                            <input id="sucursalcosto<%=i%>" name="sucursalcosto<%=i%>" type="hidden" value="<%=suc.getId()%>"/>
                                            <span><%=suc.getDatosfis().getRazonsocial()%></span>
                                        </td>
                                        <td align="center" width="40%">
                                            <input id="costo<%=i%>" name="costo<%=i%>" type="text" class="text" 
                                                   value="<%=cos%>" style="width: 100px; text-align: right;"
                                                   onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="VerificaCopia('<%=i%>')"
                                                   tabindex="<%=3000+i%>" title="COSTO DE <%=suc.getDatosfis().getRazonsocial()%>"
                                                   <%if(suc.getTipo()!=0 && aplicarcosto==1){%>readonly<%}%>/>
                                        </td>
                                        <td align="center" width="20%">
                                            <%if(suc.getTipo()==0){%>
                                            <div title="APLICAR EL COSTO A TODAS LAS SUCURSALES">
                                                <input id="aplicartodas" name="aplicartodas" type="checkbox" onclick="CopiaCostoMatriz('<%=i%>')"
                                                       <%if (aplicarcosto==1){%>checked<%}%>/>
                                                <span>Aplicar a todas</span>
                                            </div>
                                            <%}%> 
                                        </td>
                                    </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </td>
                </tr>    
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%">
            <span class="etiqueta">Precios (factor):</span>
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="100%">
                        <!-- tabla de costos registrados -->
                        <table width="95%" class="tablaLista" align="center">
                            <thead>
                                <tr>
                                    <td align="center" width="15%">
                                        <span>Sucursal</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Uno</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Dos</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Tres</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Cuatro</span>
                                    </td>
                                    <td align="center" width="15%">
                                        <span>Cinco</span>
                                    </td>
                                    <td align="center" width="10%">
                                        
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (int i=0; i < sucursales.size(); i++){
                                    Sucursal suc = sucursales.get(i);
                                    //obtener costo de sucursal
                                    if (datosS.get("accion").toString().equals("editar")){
                                        for (int p=0; p < precios.size(); p++){
                                            PrecioProducto pp = precios.get(p);
                                            if (pp.getSucursal().getId()==suc.getId()){
                                                switch(pp.getNum()){
                                                    case 1: precio1 = formato.format(pp.getFactor()); break;
                                                    case 2: precio2 = formato.format(pp.getFactor()); break;
                                                    case 3: precio3 = formato.format(pp.getFactor()); break;
                                                    case 4: precio4 = formato.format(pp.getFactor()); break;
                                                    case 5: precio5 = formato.format(pp.getFactor()); break;
                                                }
                                            }
                                        }
                                    }
                                %>
                                    <tr>
                                        <td align="left" width="15%">
                                            <input id="tiposucprecio<%=i%>" name="tiposucprecio<%=i%>" type="hidden" value="<%=suc.getTipo()%>"/>
                                            <input id="sucursalprecio<%=i%>" name="sucursalcosto<%=i%>" type="hidden" value="<%=suc.getId()%>"/>
                                            <span><%=suc.getDatosfis().getRazonsocial()%></span>
                                        </td>
                                        <td align="center" width="15%">
                                            <input id="precio1<%=i%>" name="precio1<%=i%>" type="text" class="text" value="<%=precio1%>" style="width: 50px; text-align: right;"
                                                   onkeypress="return ValidaCantidad2(event, this)" maxlength="10" onblur="VerificaCopiaPrecio('<%=i%>')"
                                                   tabindex="<%=3200+(i*100)+i%>" title="PRECIO 1 DE <%=suc.getDatosfis().getRazonsocial()%>"
                                                   <%if(suc.getTipo()!=0 && aplicarprecios==1){%>readonly<%}%>/>
                                            <input id="precio11<%=i%>" name="precio11<%=i%>" type="text" class="text" value="" style="width: 50px; text-align: right;"
                                                   readonly tabindex="<%=5000+(i*100)+i%>"/>
                                        </td>
                                        <td align="center" width="15%">
                                            <input id="precio2<%=i%>" name="precio2<%=i%>" type="text" class="text" value="<%=precio2%>" style="width: 50px; text-align: right;"
                                                   onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onblur="VerificaCopiaPrecio('<%=i%>')"
                                                   tabindex="<%=3200+(i*100)+(i+1)%>" title="PRECIO 2 DE <%=suc.getDatosfis().getRazonsocial()%>"
                                                   <%if(suc.getTipo()!=0 && aplicarprecios==1){%>readonly<%}%>/>
                                            <input id="precio21<%=i%>" name="precio21<%=i%>" type="text" class="text" value="" style="width: 50px; text-align: right;"
                                                   readonly tabindex="<%=5000+(i*100)+(i+1)%>"/>
                                        </td>
                                        <td align="center" width="15%">
                                            <input id="precio3<%=i%>" name="precio3<%=i%>" type="text" class="text" value="<%=precio3%>" style="width: 50px; text-align: right;"
                                                   onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onblur="VerificaCopiaPrecio('<%=i%>')"
                                                   tabindex="<%=3200+(i*100)+(i+2)%>" title="PRECIO 3 DE <%=suc.getDatosfis().getRazonsocial()%>"
                                                   <%if(suc.getTipo()!=0 && aplicarprecios==1){%>readonly<%}%>/>
                                            <input id="precio31<%=i%>" name="precio31<%=i%>" type="text" class="text" value="" style="width: 50px; text-align: right;"
                                                   readonly tabindex="<%=5000+(i*100)+(i+2)%>"/>
                                        </td>
                                        <td align="center" width="15%">
                                            <input id="precio4<%=i%>" name="precio4<%=i%>" type="text" class="text" value="<%=precio4%>" style="width: 50px; text-align: right;"
                                                   onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onblur="VerificaCopiaPrecio('<%=i%>')"
                                                   tabindex="<%=3200+(i*100)+(i+3)%>" title="PRECIO 4 DE <%=suc.getDatosfis().getRazonsocial()%>"
                                                   <%if(suc.getTipo()!=0 && aplicarprecios==1){%>readonly<%}%>/>
                                            <input id="precio41<%=i%>" name="precio41<%=i%>" type="text" class="text" value="" style="width: 50px; text-align: right;"
                                                   readonly tabindex="<%=5000+(i*100)+(i+3)%>"/>
                                        </td>
                                        <td align="center" width="15%">
                                            <input id="precio5<%=i%>" name="precio5<%=i%>" type="text" class="text" value="<%=precio5%>" style="width: 50px; text-align: right;"
                                                   onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onblur="VerificaCopiaPrecio('<%=i%>')"
                                                   tabindex="<%=3200+(i*100)+(i+4)%>" title="PRECIO 5 DE <%=suc.getDatosfis().getRazonsocial()%>"
                                                   <%if(suc.getTipo()!=0 && aplicarprecios==1){%>readonly<%}%>/>
                                            <input id="precio51<%=i%>" name="precio51<%=i%>" type="text" class="text" value="" style="width: 50px; text-align: right;"
                                                   readonly tabindex="<%=5000+(i*100)+(i+4)%>"/>
                                        </td>
                                        <td align="center" width="10%">
                                            <%if(suc.getTipo()==0){%>
                                            <div title="APLICAR LOS PRECIOS A TODAS LAS SUCURSALES">
                                                <input id="aplicarpreciotodas" name="aplicarpreciotodas" type="checkbox" 
                                                       onclick="CopiaPreciosMatriz('<%=i%>')" <%if (aplicarprecios==1){%>checked<%}%>/>
                                                <span>Aplicar a todas</span>
                                            </div>
                                            <%}%> 
                                        </td>
                                    </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </td>
                </tr>    
            </table>
            
            <%--
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="20%">
                        <span class="etiqueta">Uno:</span><br>
                        <input id="precio1" name="precio1" type="text" value="<%=precio1%>" style="width: 100px; text-align: right;"
                               onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onchange="CalculaPrecio(this)"/><br>
                        <input id="precio11" name="precio11" type="text" value="<%=prcalc1%>" style="width: 100px; text-align: right;" readonly/>
                    </td>
                    <td width="20%">
                        <span class="etiqueta">Dos:</span><br>
                        <input id="precio2" name="precio2" type="text" value="<%=precio2%>" style="width: 100px; text-align: right;"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onchange="CalculaPrecio(this)"/><br>
                        <input id="precio22" name="precio22" type="text" value="<%=prcalc2%>" style="width: 100px; text-align: right;" readonly/>
                    </td>
                    <td width="20%">
                        <span class="etiqueta">Tres:</span><br>
                        <input id="precio3" name="precio3" type="text" value="<%=precio3%>" style="width: 100px; text-align: right;"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onchange="CalculaPrecio(this)"/><br>
                        <input id="precio33" name="precio33" type="text" value="<%=prcalc3%>" style="width: 100px; text-align: right;" readonly/>
                    </td>
                    <td width="20%">
                        <span class="etiqueta">Cuatro:</span><br>
                        <input id="precio4" name="precio4" type="text" value="<%=precio4%>" style="width: 100px; text-align: right;"
                               onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onchange="CalculaPrecio(this)"/><br>
                        <input id="precio44" name="precio44" type="text" value="<%=prcalc4%>" style="width: 100px; text-align: right;" readonly/>
                    </td>
                    <td width="20%">
                        <span class="etiqueta">Cinco:</span><br>
                        <input id="precio5" name="precio5" type="text" value="<%=precio5%>" style="width: 100px; text-align: right;"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onchange="CalculaPrecio(this)"/><br>
                        <input id="precio55" name="precio55" type="text" value="<%=prcalc5%>" style="width: 100px; text-align: right;" readonly/>
                    </td>
                </tr>
            </table>
            --%>
        </td>
    </tr>
    <tr>
        <td width="100%">
            <span class="etiqueta">Descuentos (en %):</span>
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="16%">
                        <span class="etiqueta">Uno:</span><br>
                        <input id="descto1" name="descto1" type="text" class="text" value="<%=descto1%>" style="width: 100px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"
                            tabindex="4000" title="Porcentaje de descuento 1"/>
                    </td>
                    <td width="16%">
                        <span class="etiqueta">Dos:</span><br>
                        <input id="descto2" name="descto2" type="text" class="text" value="<%=descto2%>" style="width: 100px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"
                            tabindex="4001" title="Porcentaje de descuento 2"/>
                    </td>
                    <td width="16%">
                        <span class="etiqueta">Tres:</span><br>
                        <input id="descto3" name="descto3" type="text" class="text" value="<%=descto3%>" style="width: 100px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"
                            tabindex="4002" title="Porcentaje de descuento 3"/>
                    </td>
                    <td width="16%">
                        <span class="etiqueta">Cuatro:</span><br>
                        <input id="descto4" name="descto4" type="text" class="text" value="<%=descto4%>" style="width: 100px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"
                            tabindex="4003" title="Porcentaje de descuento 4"/>
                    </td>
                    <td width="16%">
                        <span class="etiqueta">Cinco:</span><br>
                        <input id="descto5" name="descto5" type="text" class="text" value="<%=descto5%>" style="width: 100px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"
                            tabindex="4004" title="Porcentaje de descuento 5"/>
                    </td>
                    <td width="20%">
                        <span class="etiqueta">Máximo:</span><br>
                        <input id="descmax" name="descmax" type="text" class="text" value="<%=descMax%>" style="width: 100px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"
                            tabindex="4005" title="Porcentaje de descuento máximo"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<script lang="javascript">
    /*function CalculaPrecio(factor){
        nomobj = factor.name;
        suf = nomobj.substr(nomobj.length-1);
        var pr = document.getElementById(nomobj+suf);
        pr.value = '';
        var cu = document.getElementById('costoultimo');
        if (cu.value != '' && factor.value != ''){
            nCu = parseFloat(cu.value);
            nFac = parseFloat(factor.value);
            nPre = nCu * nFac;
            pr.value = Math.round(nPre*Math.pow(10,2))/Math.pow(10,2);
        }
    }*/

    function VerificaCopia(fila){
        //si la sucursal de la fila es matriz verifica la casilla aplicar a todas
        var costo = document.getElementById('costo'+fila);
        costo.value = formato_numero(parseFloat(costo.value),2,'.',',');
        var tipo = document.getElementById('tiposuccosto'+fila);
        if (tipo.value == '0'){
            CopiaCostoMatriz(fila);
        } else {
            var suc = document.getElementById('sucursalcosto'+fila);
            CalculaPrecios(suc.value);
        }
        //CopiaPreciosMatriz(fila);
    }
    
    function VerificaCopiaPrecio(fila){
        //si la sucursal de la fila es matriz verifica la casilla aplicar a todas
        var tipo = document.getElementById('tiposucprecio'+fila);
        if (tipo.value == '0'){
            CopiaPreciosMatriz(fila);
        } else {
            var suc = document.getElementById('sucursalprecio'+fila);
            CalculaPrecios(suc.value);
        }
    }

    function CopiaCostoMatriz(fila){
        var chkaplicar = document.getElementById('aplicartodas');
        if (chkaplicar.checked){
            var costomatriz = document.getElementById('costo'+fila).value;
            <%for (int i=0; i < sucursales.size(); i++){%>
                if (fila!='<%=i%>'){
                    var costo = document.getElementById('costo<%=i%>');
                    costo.value = costomatriz;
                    costo.readOnly = true;
                }
                var suc = document.getElementById('sucursalcosto<%=i%>');
                CalculaPrecios(suc.value);
            <%}%>
        } else {
            <%for (int i=0; i < sucursales.size(); i++){%>
                if (fila!='<%=i%>'){
                    var costo = document.getElementById('costo'+<%=i%>);
                    costo.readOnly = false;
                }
            <%}%>
            var suc = document.getElementById('sucursalcosto'+fila);
            CalculaPrecios(suc.value);
        }
        
    }

    function CopiaPreciosMatriz(fila){
        var chkaplicar = document.getElementById('aplicarpreciotodas');
        if (chkaplicar.checked){
            var pre1matriz = document.getElementById('precio1'+fila).value;
            var pre2matriz = document.getElementById('precio2'+fila).value;
            var pre3matriz = document.getElementById('precio3'+fila).value;
            var pre4matriz = document.getElementById('precio4'+fila).value;
            var pre5matriz = document.getElementById('precio5'+fila).value;
            <%for (int i=0; i < sucursales.size(); i++){%>
                if (fila!='<%=i%>'){
                    var pre1 = document.getElementById('precio1'+<%=i%>);
                    pre1.value = pre1matriz;
                    pre1.readOnly = true;
                    var pre2 = document.getElementById('precio2'+<%=i%>);
                    pre2.value = pre2matriz;
                    pre2.readOnly = true;
                    var pre3 = document.getElementById('precio3'+<%=i%>);
                    pre3.value = pre3matriz;
                    pre3.readOnly = true;
                    var pre4 = document.getElementById('precio4'+<%=i%>);
                    pre4.value = pre4matriz;
                    pre4.readOnly = true;
                    var pre5 = document.getElementById('precio5'+<%=i%>);
                    pre5.value = pre5matriz;
                    pre5.readOnly = true;                    
                }
                var suc = document.getElementById('sucursalprecio<%=i%>');
                CalculaPrecios(suc.value);
            <%}%>
        } else {
            <%for (int i=0; i < sucursales.size(); i++){%>
                if (fila!='<%=i%>'){
                    var pre1 = document.getElementById('precio1'+<%=i%>);
                    pre1.readOnly = false;
                    var pre2 = document.getElementById('precio2'+<%=i%>);
                    pre2.readOnly = false;
                    var pre3 = document.getElementById('precio3'+<%=i%>);
                    pre3.readOnly = false;
                    var pre4 = document.getElementById('precio4'+<%=i%>);
                    pre4.readOnly = false;
                    var pre5 = document.getElementById('precio5'+<%=i%>);
                    pre5.readOnly = false;
                }
            <%}%>
            var suc = document.getElementById('sucursalprecio'+fila);
            CalculaPrecios(suc.value);
        }
        
    }

    function CalculaPrecios(suc){
        var costo = null, pre1 = null, pre2 = null, pre3 = null, pre4 = null, pre5 = null;
        var pre11 = null, pre21 = null, pre31 = null, pre41 = null, pre51 = null;
    <%
        for (int i=0; i < sucursales.size(); i++){
        %>
            var succosto = document.getElementById('sucursalcosto<%=i%>');
            if (succosto.value==suc){
                costo = document.getElementById('costo<%=i%>')
            }
            
            var sucprecio = document.getElementById('sucursalprecio<%=i%>');
            if (sucprecio.value==suc){
                pre1 = document.getElementById('precio1<%=i%>');
                pre11 = document.getElementById('precio11<%=i%>');
                pre2 = document.getElementById('precio2<%=i%>');
                pre21 = document.getElementById('precio21<%=i%>');
                pre3 = document.getElementById('precio3<%=i%>');
                pre31 = document.getElementById('precio31<%=i%>');
                pre4 = document.getElementById('precio4<%=i%>');
                pre41 = document.getElementById('precio41<%=i%>');
                pre5 = document.getElementById('precio5<%=i%>');
                pre51 = document.getElementById('precio51<%=i%>');
            }
        <%
        }
    %>
            if (costo.value != ''){
                cos = parseFloat(costo.value);
                if (pre1.value != ''){
                    pre = parseFloat(pre1.value);
                    imp = formato_numero(cos*pre,2,'.',',');
                    pre11.value = imp;
                } else { pre11.value==''; }
                if (pre2.value != ''){
                    pre = parseFloat(pre2.value);
                    imp = formato_numero(cos*pre,2,'.',',');
                    pre21.value = imp;
                } else { pre21.value==''; }
                if (pre3.value != ''){
                    pre = parseFloat(pre3.value);
                    imp = formato_numero(cos*pre,2,'.',',');
                    pre31.value = imp;
                } else { pre31.value==''; }
                if (pre4.value != ''){
                    pre = parseFloat(pre4.value);
                    imp = formato_numero(cos*pre,2,'.',',');
                    pre41.value = imp;
                } else { pre41.value==''; }
                if (pre5.value != ''){
                    pre = parseFloat(pre5.value);
                    imp = formato_numero(cos*pre,2,'.',',');
                    pre51.value = imp;
                } else { pre51.value==''; }
            } else {
                pre11.value=='';
                pre21.value=='';
                pre31.value=='';
                pre41.value=='';
                pre51.value=='';
            }
    }
</script>