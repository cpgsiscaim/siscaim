<%@page import="Generales.Sesion"%>
<%@page import="java.text.SimpleDateFormat, java.util.List, java.util.ArrayList, Modelo.Entidades.Catalogos.FechasEntrega"%>

<%
%>
<table width="80%" align="center">
    <tr>
        <td width="100%" valign="top">
            <table width="100%" align="center" cellpadding="5px">
                <tr>
                    <td width="100%">
                        <span class="etiqueta">Nombre:</span><br>
                        <input id="nombre" name="nombre" type="text" style="width: 400px" value="<%=nombre%>"
                               maxlength="120" onblur="Mayusculas(this)"/>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <span class="etiqueta">Domicilio:</span><br>
                        <table width="100%" frame="box" align="center">
                            <tr>
                                <td width="60%" colspan="2">
                                    <span class="etiqueta">Calle y Número*:</span><br>
                                    <input id="callect" name="callect" type="text" class="text" value="<%=direc!=null?direc.getCalle():""%>" style="width: 300px"
                                        onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="50"/>
                                    <input id="numero" name="numero" type="text" class="text" value="<%=direc!=null?direc.getNumero():""%>" style="width: 80px; text-align: right"
                                           onblur="Mayusculas(this)" onchange="CambiaClase(this, 'text')" maxlength="15"/>
                                </td>
                                <td width="40%">
                                    <span class="etiqueta">Colonia*:</span><br>
                                    <input id="coloniact" name="coloniact" type="text" class="text" value="<%=direc!=null?direc.getColonia():""%>" style="width: 300px" 
                                        onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="50"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%" align="left">
                                    <span class="etiqueta">C.P.:</span><br>
                                    <input id="cpct" name="cpct" type="text" class="text" value="<%=direc!=null?direc.getCp():""%>" style="width: 100px; text-align: right"
                                        onkeypress="return ValidaNums(event)" maxlength="5"/>
                                </td>
                                <td width="30%" align="left">
                                    <span class="etiqueta">Estado*:</span><br>
                                    <select id="estadoct" name="estadoct" class="combo" style="width: 200px"
                                            onchange="CargaMunicipiosCt(this.value)">
                                        <option value="">Elija el Estado...</option>
                                        <%
                                            List<Estado> estadosct = (List<Estado>) datosS.get("estados");
                                            for (int i=0; i < estadosct.size(); i++){
                                                Estado edo = (Estado) estadosct.get(i);
                                            %>
                                            <option value="<%=edo.getIdestado()%>"
                                                    <%
                                                    if (direc!=null && edo.getIdestado()==direc.getPoblacion().getEstado().getIdestado()){
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
                                    <span class="etiqueta">Población*:</span><br>
                                    <select id="poblacionct" name="poblacionct" class="combo" style="width: 300px">
                                        <option value="">Elija la Población...</option>
                                        <%
                                        if (direc!=null && direc.getPoblacion().getIdmunicipio()!=0){
                                            for (int p=2; p >= 0; p--){                               
                                                List<Municipio> municipios = direc.getPoblacion().getEstado().getMunicipios();
                                                for (int i=0; i < municipios.size(); i++){
                                                    Municipio m = municipios.get(i);
                                                    if (m.getPrioridad()==p){
                                                %>
                                                        <option value="<%=m.getIdmunicipio()%>"
                                                                <%
                                                                if (m.getIdmunicipio()==direc.getPoblacion().getIdmunicipio()){
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
                        <table width="100%">
                            <tr>
                                <td width="40%">
                                    <div id="rutanormal">
                                        <span class="etiqueta">Ruta:</span><br>
                                        <select id="ruta" name="ruta" class="combo" style="width: 200px">
                                            <option value="">Elija la Ruta...</option>
                                        <%
                                        List<Ruta> rutas = (List<Ruta>)datosS.get("rutas");
                                        for (int i = 0; i < rutas.size(); i++){
                                            Ruta ru = rutas.get(i);
                                        %>
                                            <option value="<%=ru.getId()%>"
                                                    <%if(rutActual != null && ru.getId()==rutActual.getId()){%>
                                                    selected
                                                    <%}%>
                                                    ><%=ru.getDescripcion()%>
                                            </option>
                                        <%
                                        }
                                        %>
                                        </select><br>
                                    </div>
                                    <input id="surtidoexterno" name="surtidoexterno" type="checkbox" <%if (surtidoexterno==1){%>checked<%}%>
                                        onclick="SurtidoExterno()">
                                    <span class="etiqueta">Surtir desde otra Sucursal</span><br>
                                    <div id="divsurext" style="display: none">
                                        <span class="etiqueta">Sucursal:</span><br>
                                        <select id="sucursalext" name="sucursalext" class="combo" style="width: 200px"
                                                onchange="CargaRutasExt(this.value)">
                                            <option value="">Elija la Sucursal...</option>
                                        <%
                                        List<Sucursal> sucs = (List<Sucursal>)datosS.get("sucursales");
                                        for (int i = 0; i < sucs.size(); i++){
                                            Sucursal su = sucs.get(i);
                                            if (cliSel.getSucursal().getId()!=su.getId()){
                                        %>
                                            <option value="<%=su.getId()%>"
                                                    <%if(sucalt != null && su.getId()==sucalt.getId()){%>
                                                    selected
                                                    <%}%>
                                                    ><%=su.getDatosfis().getRazonsocial()%>
                                            </option>
                                        <%
                                            }
                                        }
                                        %>
                                        </select><br>
                                        <span class="etiqueta">Ruta:</span><br>
                                        <select id="rutaext" name="rutaext" class="combo" style="width: 200px">
                                            <option value="">Elija la Ruta...</option>
                                        </select>
                                    </div>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">Personal:</span><br>
                                    <input id="personal" name="personal" type="text" class="text" style="width: 100px; text-align: right" value="<%=personal%>"
                                        maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"/>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">Tope de Sueldos:</span><br>
                                    <input id="topes" name="topes" type="text" class="text" style="width: 100px; text-align: right" value="<%=topes%>"
                                        maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"/>
                                </td>
                                <td width="20%">
                                    <span class="etiqueta">Tope de Insumos:</span><br>
                                    <input id="topei" name="topei" type="text" class="text" style="width: 100px; text-align: right" value="<%=topei%>"
                                        maxlength="10" onkeypress="return ValidaCantidad(event, this.value)"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%" align="left">
                        <table width="100%">
                            <tr>
                                <td width="30%" align="left">
                                    <span class="subtitulo">Configuraci&oacute;n de las Entregas:</span>
                                </td>
                                <td width="35%" align="left">
                                    <input id="opcconfig" name="opcconfig" value="0" type="radio" onclick="ChecaConfigEntrega(this.value)"
                                           <%if (disconfcon==0){%>disabled<%}%> <%if (chkconfcon==1){%>checked<%}%>/>
                                    <span class="etiquetaB">Obtener del Contrato</span>
                                </td>
                                <td width="35%" align="left">
                                    <input id="opcconfig" name="opcconfig" value="1" type="radio" onclick="ChecaConfigEntrega(this.value)"
                                           <%if (disconfper==0){%>disabled<%}%> <%if (chkconfper==1){%>checked<%}%>/>
                                    <span class="etiquetaB">Configuración personalizada</span>
                                </td>
                            </tr>
                        </table>
                        <table id="opcentrega" width="100%">
                            <tr>
                                <td width="30%" align="left" valign="top">
                                    <input id="opctipoe" name="opctipoe" value="0" type="radio" onclick="ChecaTipoEntrega(this.value)"
                                           <%if (chktipodias==1){%>checked<%}%>/>
                                    <span class="etiqueta">Cada&nbsp;
                                        <input id="numdias" name="numdias" type="text" value="<%=dias%>" style="width: 70px" disabled
                                        maxlength="3" onkeypress="return ValidaNums(event)"/>&nbsp;
                                        d&iacute;as
                                    </span>
                                </td>
                                <td width="35%" align="left" valign="top">
                                    <input id="lstfechas" name="lstfechas" value="" type="hidden">
                                    <input id="opctipoe" name="opctipoe" value="1" type="radio" onclick="ChecaTipoEntrega(this.value)"
                                           <%if (chktipofechas==1){%>checked<%}%>/>
                                    <span class="etiqueta">Fechas espec&iacute;ficas:</span>
                                </td>
                                <td width="35%" align="left" valign="top">
                                    <div id="divfechas" style="display: none">
                                        <%if(conSel.getTipoentrega()==1){%>
                                        <select id="fechascon" name="fechascon" class="combo" style="width: 200px;">
                                            <%//if(conSel.getTipoentrega()==1){
                                                List<FechasEntrega> fechasent = (List<FechasEntrega>)datosS.get("fechascon");
                                                SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
                                                String sfecha = "";
                                                for (int i=0; i < fechasent.size(); i++){
                                                    FechasEntrega fe = fechasent.get(i);
                                                    sfecha = form.format(fe.getFecha());
                                            %>
                                                    <option value="<%=sfecha%>"><%=sfecha%></option>
                                            <%
                                                }
                                            //}
                                            %>
                                        </select>
                                        <img src="/siscaim/Imagenes/Varias/mas01.png" width="25" height="25"
                                            onclick="AgregaFecha()" title="Agrega la fecha" onmouseover="this.style.cursor='pointer'"/><br>
                                        <select id="lsfechas" name="lsfechas" size="5" style="width: 200px" multiple>
                                            <%if (datosS.get("accion").toString().equals("editar") && ct.getConfigentrega()==1 && ct.getTipoentrega()==1){
                                                List<FechasEntrega> fechasct = (List<FechasEntrega>)datosS.get("fechasentct");
                                                SimpleDateFormat forma = new SimpleDateFormat("dd-MM-yyyy");
                                                String sfech = "";
                                                for (int i=0; i < fechasct.size(); i++){
                                                    FechasEntrega fect = fechasct.get(i);
                                                    sfech = forma.format(fect.getFecha());
                                                %>
                                                    <option value="<%=fect.getFecha()%>"><%=sfech%></option>
                                                <%
                                                }
                                            }%>
                                        </select>
                                        <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                            onclick="QuitarFechas()" title="Quitar las fechas seleccionadas" onmouseover="this.style.cursor='pointer'"/><br>
                                        <%} else {%>
                                            <input id="fechaesp" name="fechaesp" type="text" class="text" readonly value=""
                                                    title="Ingrese la fecha" style="width: 150px;"/>
                                            <img src="/siscaim/Imagenes/Varias/mas01.png" width="25" height="25"
                                                onclick="AgregaFecha2()" title="Agrega la fecha" onmouseover="this.style.cursor='pointer'"/><br>
                                            <select id="lsfechas" name="lsfechas" size="5" style="width: 200px" multiple>
                                                <%if (datosS.get("accion").toString().equals("editar") && ct.getConfigentrega()==1 && ct.getTipoentrega()==1){
                                                SimpleDateFormat form = new SimpleDateFormat("dd-MM-yyyy");
                                                List<FechasEntrega> listafechas = (List<FechasEntrega>)datosS.get("fechasentct");
                                                String sfecha = "";
                                                for (int i=0; i < listafechas.size(); i++){
                                                    FechasEntrega fe = listafechas.get(i);
                                                    sfecha = form.format(fe.getFecha());
                                                %>
                                                    <option value="<%=fe.getFecha()%>"><%=sfecha%></option>
                                                <%}
                                                }%>
                                            </select>
                                            <img src="/siscaim/Imagenes/Varias/menos02.png" width="25" height="25"
                                                onclick="QuitarFechas2()" title="Quitar las fechas seleccionadas" onmouseover="this.style.cursor='pointer'"/><br>
                                        <%}%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <span class="etiqueta">Observaciones:</span><br>
                        <textarea id="observacion" name="observacion" class="text" style="width: 700px" maxlength="250" rows="3" onblur="Mayusculas(this)"><%=observacion%></textarea>
                    </td>
                </tr>
                <tr>
                </tr>
            </table>
            <div id="datosfiscales" style="display: <%=datosfis%>">
                <span class="etiqueta">DATOS FISCALES:</span><br>
            <table id="datosfiscales" width="100%" align="center" frame="box">
                <tr>
                    <td width="5%">
                    </td>
                    <td width="30%" colspan="2">
                        <span class="etiqueta">RFC:</span><br>
                        <input id="rfc" name="rfc" type="text" value="<%=rfc%>" style="width: 260px"
                            onkeypress="return ValidaRFC(event, this.value)" onblur="Mayusculas(this)"
                            maxlength="15" title="Ej. CCCC-000000-AAA"/>                                                            
                    </td>
                    <td width="60%" colspan="2">
                        <span class="etiqueta">Razón Social:</span><br>
                        <input id="razonsoc" name="razonsoc" type="text" value="<%=razonsoc%>" style="width: 500px"
                            onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                            maxlength="120"/>
                    </td>
                    <td width="5%">
                    </td>                                                
                </tr>
                <tr>
                    <td width="100%" colspan="4">
                        <span class="etiqueta">Domicilio:</span>
                    </td>
                </tr> 
                <tr>
                    <td width="100%" colspan="4">
                        <table width="100%" frame="box" align="center">
                            <tr>
                                <td width="60%" colspan="2">
                                    <span class="etiqueta">Calle y Número:</span><br>
                                    <input id="calle" name="calle" type="text" value="<%=calle%>" style="width: 500px"
                                        onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="50"/>
                                </td>
                                <td width="40%">
                                    <span class="etiqueta">Colonia:</span><br>
                                    <input id="colonia" name="colonia" type="text" value="<%=colonia%>" style="width: 270px"
                                        onkeypress="return ValidaRazonSocial(event, this.value)" onblur="Mayusculas(this)"
                                        maxlength="50"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="20%" align="left">
                                    <span class="etiqueta">C.P.:</span><br>
                                    <input id="cp" name="cp" type="text" value="<%=sCp%>" style="width: 150px"
                                        onkeypress="return ValidaNums(event)" maxlength="5"/>
                                </td>
                                <td width="30%" align="left">
                                    <span class="etiqueta">Estado:</span><br>
                                    <select id="estado" name="estado" class="combo" style="width: 250px"
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
                                    <select id="poblacion" name="poblacion" class="combo" style="width: 280px">
                                        <option value="">Elija la Población...</option>
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
            </table>
            </div>
        </td>
    </tr>
</table>
