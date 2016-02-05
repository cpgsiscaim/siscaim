<%@page import="Modelo.Entidades.Proveedor, Modelo.Entidades.Producto"%>
<%@page import="Modelo.Entidades.Marca, Modelo.Entidades.Unidad, Modelo.Entidades.UnidadProducto"%>
<%@page import="java.util.List, Modelo.Entidades.Categoria, Modelo.Entidades.Subcategoria"%>

<%
String clave = "", descrip = "", servicio = "", factor = "", costoUlt = "";//*, costoProm = "", costoAct = ""*/;
Marca marca = new Marca();
Unidad unidad = new Unidad();
UnidadProducto uniemp = new UnidadProducto();
Categoria cat = new Categoria();
Subcategoria scat = new Subcategoria();
Proveedor prov = new Proveedor();
int tipo = 0, surtido = 1;

if (datosS.get("accion").toString().equals("editar")){
    Producto prod = (Producto)datosS.get("producto");
    clave = prod.getClave();
    descrip = prod.getDescripcion();
    servicio = Integer.toString(prod.getServicio());
    //peso = Float.toString(prod.getPeso());
    //costoUlt = Float.toString(prod.getCostoUltimo());
    //costoProm = Float.toString(prod.getCostoPromedio());
    //costoAct = Float.toString(prod.getCostoActual());
    marca = prod.getMarca();
    unidad = prod.getUnidad();
    uniemp = datosS.get("unidadempaque")!=null?(UnidadProducto)datosS.get("unidadempaque"):new UnidadProducto();
    factor = datosS.get("unidadempaque")!=null?Float.toString(uniemp.getValor()):"";
    cat = prod.getCategoria();
    scat = prod.getSubcategoria()!=null?prod.getSubcategoria():new Subcategoria();
    prov = prod.getProveedor();
    tipo = prod.getTipo();
    surtido = prod.getSurtido();
}
%>
<script>
</script>
<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="30%">
            <span class="etiqueta">Clave*:</span><br>
            <input id="clave" name="clave" type="text" class="text" value="<%=clave%>" style="width: 150px"
                onkeypress="return ValidaAlfaNumSignos(event)" onblur="ValidaClave(this)"
                maxlength="20" title="Clave del Producto"/>
        </td>
        <td width="70%">
            <span class="etiqueta">Descripción*:</span><br>
            <input id="descripcion" name="descripcion" type="text" class="text" value="<%=descrip%>" style="width: 600px"
                onblur="Mayusculas(this)" maxlength="80" title="Nombre del producto"/>                                                            
        </td>
    </tr>
    <tr>
        <td width="100%" colspan="2">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="40%">
                        <span class="etiqueta">Marca*:</span><br>
                        <%--
                        <select id="marca" name="marca">
                            <option value=""></option>
                            <%
                            List<Marca> marcas = (List<Marca>)datosS.get("marcas");
                            for (int i=0; i < marcas.size(); i++){
                                Marca mar = marcas.get(i);
                            %>
                            <option value="<%=mar.getId()%>"
                                    <%
                                    if (marca.getId()==mar.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=mar.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>--%>
                        
                        <select id="marca" name="marca" class="combo" style="width: 250px"
                                title="Elija la marca del producto">
                            <option value="">ELIJA LA MARCA...</option>
                            <%
                            List<Marca> marcas = (List<Marca>)datosS.get("marcas");
                            for (int i=0; i < marcas.size(); i++){
                                Marca mar = marcas.get(i);
                            %>
                            <option value="<%=mar.getId()%>"
                                    <%
                                    if (marca.getId()==mar.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=mar.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>
                        
                    </td>
                    <td width="30%">
                        <span class="etiqueta">Categoría*:</span><br>
                        <%--
                        <select id="categoria" name="categoria">
                            <option value=""></option>
                            <%
                            List<Categoria> cats = (List<Categoria>)datosS.get("categorias");
                            for (int i=0; i < cats.size(); i++){
                                Categoria categ = cats.get(i);
                            %>
                            <option value="<%=categ.getId()%>"
                                    <%
                                    if (cat.getId()==categ.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=categ.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>--%>
                        
                        <select id="categoria" name="categoria" class="combo" style="width: 200px" onchange="CargaSubCats(this.value)"
                                title="Elija la categoría del producto">
                            <option value="">ELIJA LA CATEGORIA...</option>
                            <%
                            List<Categoria> cats = (List<Categoria>)datosS.get("categorias");
                            for (int i=0; i < cats.size(); i++){
                                Categoria categ = cats.get(i);
                            %>
                            <option value="<%=categ.getId()%>"
                                    <%
                                    if (cat.getId()==categ.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=categ.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>
                        
                    </td>
                    <td width="30%">
                        <span class="etiqueta">Subcategoría:</span><br>
                        <%--
                        <select id="subcategoria" name="subcategoria">
                            <option value=""></option>
                        </select>--%>
                        
                        <select id="subcategoria" name="subcategoria" class="combo" style="width: 200px"
                                title="Elija la subcategoría del producto">
                            <option value="">ELIJA LA SUBCATEGORIA...</option>
                        </select>
                        
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%" colspan="2">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="25%">
                        <span class="etiqueta">Unidad Mínima*:</span><br>
                        <%--
                        <select id="unidad" name="unidad">
                            <option value=""></option>
                            <%
                            List<Unidad> unidades = (List<Unidad>)datosS.get("unidades");
                            for (int i=0; i < unidades.size(); i++){
                                Unidad uni = unidades.get(i);
                            %>
                            <option value="<%=uni.getId()%>"
                                    <%
                                    if (unidad.getId()==uni.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=uni.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>--%>
                        
                        <select id="unidad" name="unidad" class="combo" style="width: 250px"
                                title="Elija la Unidad Mínima del producto">
                            <option value="">ELIJA LA UNIDAD...</option>
                            <%
                            List<Unidad> unidades = (List<Unidad>)datosS.get("unidades");
                            for (int i=0; i < unidades.size(); i++){
                                Unidad uni = unidades.get(i);
                            %>
                            <option value="<%=uni.getId()%>"
                                    <%
                                    if (unidad.getId()==uni.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=uni.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>
                        
                    </td>
                    <td width="25%">
                        <span class="etiqueta">Unidad de Empaque*:</span><br>
                        <%--
                        <select id="unidademp" name="unidademp">
                            <option value=""></option>
                            <%
                            //List<Unidad> unidades = (List<Unidad>)datosS.get("unidades");
                            for (int i=0; i < unidades.size(); i++){
                                Unidad uni = unidades.get(i);
                            %>
                            <option value="<%=uni.getId()%>"
                                    <%
                                    if (uniemp.getUnidad()!=null && uniemp.getUnidad().getId()==uni.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=uni.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>--%>
                        
                        <select id="unidademp" name="unidademp" class="combo" style="width: 250px"
                                title="Elija la Unidad de Empaque del producto">
                            <option value="">ELIJA LA UNIDAD DE EMPAQUE...</option>
                            <%
                            //List<Unidad> unidades = (List<Unidad>)datosS.get("unidades");
                            for (int i=0; i < unidades.size(); i++){
                                Unidad uni = unidades.get(i);
                            %>
                            <option value="<%=uni.getId()%>"
                                    <%
                                    if (uniemp.getUnidad()!=null && uniemp.getUnidad().getId()==uni.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=uni.getDescripcion()%></option>
                            <%
                            }
                            %>
                        </select>
                        
                    </td>
                    <td width="20%">
                        <span class="etiqueta">Piezas Empaque*:</span><br>
                        <input id="valor" name="valor" type="text" class="text" value="<%=factor%>"
                                onblur="Mayusculas(this)" maxlength="10" style="width: 120px; text-align: right"
                                onkeypress="return ValidaCantidad(event)" title="Piezas que conforman el empaque"/>
                    </td>
                    <td width="30%">
                        <span class="etiqueta">Tipo*:</span><br>
                        <%--
                        <select id="tipo" name="tipo">
                            <option value=""></option>
                            <option value="0" <%if (tipo==0){%>selected<%}%>>B&Aacute;SICO</option>
                            <option value="1" <%if (tipo==1){%>selected<%}%>>CAMBIO</option>
                        </select>--%>
                        
                        <select id="tipo" name="tipo" class="combo" style="width: 150px"
                                title="Elija el tipo de producto">
                            <option value="0" <%if (tipo==0){%>selected<%}%>>B&Aacute;SICO</option>
                            <option value="1" <%if (tipo==1){%>selected<%}%>>CAMBIO</option>
                        </select>
                        
                    </td>
                </tr>
            </table>   
        </td>
    </tr>
    <tr>
        <td width="100%" colspan="2">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="50%">
                        <span class="etiqueta">Proveedor*:</span><br>
                        <%--
                        <select id="proveedor" name="proveedor">
                            <option value=""></option>
                            <%
                            List<Proveedor> proveedores = (List<Proveedor>)datosS.get("proveedores");
                            for (int i=0; i < proveedores.size(); i++){
                                Proveedor pr = proveedores.get(i);
                            %>
                            <option value="<%=pr.getId()%>"
                                    <%
                                    if (prov.getId()==pr.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=pr.getTipo().equals("0")?pr.getDatosfiscales().getRazonsocial():pr.getDatosfiscales().getPersona().getNombreCompleto()%></option>
                            <%
                            }
                            %>
                        </select><br>
                        <input id="nomprov" type="text" class="etiq" style="width: 500px;" readonly
                               value="<%=prov.getDatosfiscales()!=null?
                                   (prov.getTipo().equals("0")?prov.getDatosfiscales().getRazonsocial():prov.getDatosfiscales().getPersona().getNombreCompleto()):
                                   ""%>"/>--%>
                        
                        <select id="proveedor" name="proveedor" class="combo" style="width: 400px"
                                title="Elija el proveedor del producto">
                            <option value="">ELIJA EL PROVEEDOR...</option>
                            <%
                            List<Proveedor> proveedores = (List<Proveedor>)datosS.get("proveedores");
                            for (int i=0; i < proveedores.size(); i++){
                                Proveedor pr = proveedores.get(i);
                            %>
                            <option value="<%=pr.getId()%>"
                                    <%
                                    if (prov.getId()==pr.getId()){
                                    %>
                                    selected
                                    <%
                                    }
                                    %>
                                    ><%=pr.getTipo().equals("0")?pr.getDatosfiscales().getRazonsocial():pr.getDatosfiscales().getPersona().getNombreCompleto()%></option>
                            <%
                            }
                            %>
                        </select>
                        
                    </td>
                    <td width="25%">
                        <span class="etiqueta">Servicio*:</span><br>
                        <%--
                        <select id="servicio" name="servicio">
                            <option value=""></option>
                            <option value="0"
                                    <%
                                    if (servicio.equals("0")){
                                    %>
                                    selected
                                    <% } %>
                                    >CONSUMO</option>
                            <option value="1"
                                    <%
                                    if (servicio.equals("1")){
                                    %>
                                    selected
                                    <% } %>                                    
                                    >SERVICIO</option>
                        </select>--%>
                        
                        <select id="servicio" name="servicio" class="combo" style="width: 200px"
                                title="Elija el uso que se le dará al producto">
                            <option value="">ELIJA EL SERVICIO...</option>
                            <option value="0"
                                    <%
                                    if (servicio.equals("0")){
                                    %>
                                    selected
                                    <% } %>
                                    >CONSUMO</option>
                            <option value="1"
                                    <%
                                    if (servicio.equals("1")){
                                    %>
                                    selected
                                    <% } %>                                    
                                    >SERVICIO</option>
                        </select>
                        
                    </td>
                    <td width="25%">
                        <span class="etiqueta">Tipo de surtido:</span><br>
                        <select id="surtido" name="surtido" class="combo" style="width: 180px"
                                title="Elija si el producto será surtido desde matriz o desde las sucursales">
                            <option value="1"
                                    <%
                                    if (surtido==1){
                                    %>
                                    selected
                                    <% } %>
                                    >DESDE MATRIZ</option>
                            <option value="2"
                                    <%
                                    if (surtido==2){
                                    %>
                                    selected
                                    <% } %>                                    
                                    >DESDE SUCURSALES</option>
                        </select>
                        <%--
                        <span class="etiqueta">Costo Último:</span><br>
                        <input id="costoultimo" name="costoultimo" type="text" value="<%=costoUlt%>" style="width: 150px"
                               onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" onchange="CalculaPrecios(this.value)"/>
                        <%--
                        <span class="etiqueta">Peso:</span><br>
                        <input id="peso" name="peso" type="text" value="<%=peso%>" style="width: 200px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"/>
                        --%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%--
    <tr>
        <td width="100%" colspan="2">
            <span class="etiqueta">Costos:</span>
            <table width="100%" align="center" cellpadding="5px" frame="box">
                <tr>
                    <td width="33%">
                        <span class="etiqueta">Último:</span><br>
                        <input id="costoultimo" name="costoultimo" type="text" value="<%=costoUlt%>" style="width: 150px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"/>
                    </td>
                    <td width="34%">
                        <span class="etiqueta">Promedio:</span><br>
                        <input id="costopromedio" name="costopromedio" type="text" value="<%=costoProm%>" style="width: 150px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"/>
                    </td>
                    <td width="33%">
                        <span class="etiqueta">Actualizado:</span><br>
                        <input id="costoactual" name="costoactual" type="text" value="<%=costoAct%>" style="width: 150px"
                            onkeypress="return ValidaCantidad(event, this.value)" maxlength="10"/>
                    </td>
                </tr>
            </table>
        </td>
    </tr>--%>
</table>

<script lang="javascript">
    <%
    if (datosS.get("accion").toString().equals("editar")){
    %>
        CargaSubCats();
    <%    
    }
    %>
    
    function ValidaClave(obj){
        var clave = obj.value;
    
    <% List<Producto> prods = (List<Producto>)datosS.get("prodsfull");
    if (datosS.get("accion").toString().equals("nuevo")){
        for (int i=0; i < prods.size(); i++){
            Producto pr = prods.get(i);
            %>
            if (clave == '<%=pr.getClave()%>'){
                MostrarMensaje('La clave del producto ya existe');
                obj.value = '';
                obj.focus();
                return;
            }
    <%
           }
    } else if (datosS.get("accion").toString().equals("editar")){
        String clvact = datosS.get("claveact").toString();
        //if (!clvact.equals(prod.getClave())
        %>
        if (clave!='<%=clvact%>'){
        <%
        for (int i=0; i < prods.size(); i++){
            Producto pr = prods.get(i);
            %>
            if (clave == '<%=pr.getClave()%>'){
                MostrarMensaje('La clave del producto ya existe');
                obj.value = '';
                obj.focus();
                return;
            }
        <%}%>
        }
    <%}%>
        Mayusculas(obj);
    }
    
    function MuestraProveedor(){
        var etprov = document.getElementById('nomprov');
        var proveedor = document.getElementById('proveedor');
        var i = proveedor.selectedIndex;
        var nomprov = proveedor.options[i].text;
        etprov.value=nomprov;
    }
    
    function CargaSubCats(){
        var cat = document.getElementById('categoria');
        var categoria = cat.value;
        var subcat = document.getElementById('subcategoria');
        subcat.length = 0;
        
        //subcat.options[0] = new Option('Elija la Subcategoría...','');
        
        if (cat.value!=''){
        k = 0;
        <%
        List<Subcategoria> subcats = (List<Subcategoria>)datosS.get("subcategorias");
        for (int i=0; i < subcats.size(); i++){
            Subcategoria sub = subcats.get(i);
        %>
            if (categoria == '<%=sub.getCategoria().getId()%>'){
                subcat.options[k] = new Option('<%=sub.getDescripcion()%>','<%=sub.getId()%>');
                <%
                if (scat.getId()==sub.getId()){
                %>
                    subcat.options[k].selected = true;
                <% } %>
                k++;
            }
        <%
        }
        %>
        }
    }
    
    function CalculaPrecios(costo){
        for (i=1; i < 6; i++){
            var pr = document.getElementById('precio'+i+''+i);
            pr.value = '';
        }
        if (costo != ''){
            for (i=1; i < 6; i++){
                var fac = document.getElementById('precio'+i);
                var pr = document.getElementById('precio'+i+''+i);
                if (fac.value != ''){
                    nCos = parseFloat(costo);
                    nFac = parseFloat(fac.value);
                    nPre = nCos*nFac;
                    pr.value = Math.round(nPre*Math.pow(10,2))/Math.pow(10,2);
                }
            }
        }
    }
</script>