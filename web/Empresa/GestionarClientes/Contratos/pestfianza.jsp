<%@page import="Generales.Sesion"%>
<%@page import="java.text.SimpleDateFormat, java.util.Date, java.util.List, Modelo.Entidades.Catalogos.Municipio"%>

<%
SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
String numfianza = "", importe = "0", fecha = formato.format((Date)datosS.get("hoy")),
        fechaN = fecha.substring(8,10) + "-" + fecha.substring(5,7) + "-" + fecha.substring(0, 4), estatus = "1", obsFianza = "";

if (datosS.get("accion").toString().equals("editar") || sesion.isError()){
    tempo = (Contrato)datosS.get("editarContrato");
    if (sesion.isError())
        tempo = (Contrato)datosS.get("contrato");
    numfianza = tempo.getNumfianza();
    importe = Float.toString(tempo.getImporteFianza());
    //SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
    fecha = formato.format(tempo.getFechaFianza());
    fechaN = fecha.substring(8,10) + "-" + fecha.substring(5,7) + "-" + fecha.substring(0, 4);
    estatus = Integer.toString(tempo.getEstatusFianza());
    obsFianza = tempo.getObservacionFianza();
}
%>

<table width="100%" align="center" cellpadding="5px">
    <tr>
        <td width="30%" align="left">
            <span class="etiqueta">Núm. de Fianza:</span><br>
            <input id="numfianza" name="numfianza" class="text" type="text" value="<%=numfianza%>" style="width: 150px"
                   onkeypress="return ValidaNums(event)" maxlength="8" title="Ingrese el número de la fianza" <%if (banhis==1){%>readonly=""<%}%>/>                                                            
        </td>
        <td width="40%" align="left">
            <span class="etiqueta">Importe:</span><br>
            <input id="importe" name="importe" class="text" type="text" value="<%=importe%>" style="width: 200px"
                   onkeypress="return ValidaCantidad(event, this.value)" maxlength="10" title="Ingrese el importe de la fianza" <%if (banhis==1){%>readonly=""<%}%>/>                                                            
        </td>
        <td width="30%" align="left">
            <span class="etiqueta">Fecha:</span><br>
            <input id="fecha" name="fecha" type="text" class="text" readonly value="<%=fechaN%>"
                title="Ingrese la fecha de la fianza" <%if (banhis==1){%>readonly=""<%}%>/>
            <%--
            <input id="fecha" name="fecha" value="<%=fecha%>" type="hidden">
            <input id="rgFecha" name="rgFecha" class="cajaDatos" style="width:120px" type="text" value="<%=fechaN%>" onchange="cambiaFecha(this.value,'fecha')" readonly>&nbsp;
            <img src="/siscaim/Imagenes/Calendario/calendario02.png" width="25" height="25"
                onclick="displayCalendar(document.frmNuevoCon.rgFecha,'dd-mm-yyyy',document.frmNuevoCon.rgFecha)"
                title="Elija la fecha" onmouseover="this.style.cursor='pointer'"/>
            <img src="/siscaim/Imagenes/Calendario/limpiar01.png" width="25" height="25"
                onclick="limpiar('rgFecha', 'fecha')" title="Borrar la fecha" onmouseover="this.style.cursor='pointer'"/>
            --%>
        </td>
    </tr>
    <tr>
        <td width="30%" align="left">
            <span class="etiqueta">Estatus:</span><br>
            <input id="radioEstatusF" name="radioEstatusF" type="radio" value="1"
                   <%if (estatus.equals("1")){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>/>
            <span class="etiqueta">Activo</span> &nbsp;&nbsp;&nbsp;
            <input id="radioEstatusF" name="radioEstatusF" type="radio" value="0"
                   <%if (estatus.equals("0")){%>checked<%}%> <%if (banhis==1){%>disabled<%}%>/>
            <span class="etiqueta">Inactivo</span>
        </td>
        <td width="40%" align="left">
            <span class="etiqueta">Observaciones:</span><br>
            <textarea id="obsFianza" name="obsFianza" style="width: 400px" maxlength="200" rows="3" onblur="Mayusculas(this)" class="text" title="Ingrese las observaciones de la fianza" <%if (banhis==1){%>readonly=""<%}%>><%=obsFianza%></textarea>
        </td>
        <td width="30%" align="left">
            <%if (datosS.get("accion").toString().equals("editar")){%>
            <table width="100%">
                <tr>
                    <td width="20%"><span class="subtitulo">Documento:</span></td>&nbsp;
                    <td align="left">
                        <%if (tempo.getDocfianza()==0){%>
                            <span class="etiqueta">
                                <a id="btnAgregarDocFianza" href="javascript: SubirFianza()"
                                    style="width: 100px; font-weight: bold; color: #0B610B;" title="Subir documento de la fianza">
                                    Agregar
                                </a>
                            </span>
                        <%} else {%>
                            <a id="btnVerDocFianza" href="javascript: MostrarFianza('/siscaim/Imagenes/Contratos/Fianzas/<%=tempo.getId()%>.pdf')"
                                style="width: 100px; font-weight: bold; color: #0B610B;" title="Ver documento de la fianza">
                                Ver
                            </a>
                            <a id="btnBorrarDocFianza" href="javascript: BorrarDocFianza()"
                                style="width: 100px; font-weight: bold; color: #0B610B;" title="Borrar documento de la fianza">
                                Borrar
                            </a>
                        <%}%>
                    </td>
                </tr>
            </table>
            <%}%>
        </td>
    </tr>
</table>

<script lang="javascript">
    function MostrarFianza(doc){
        var pdf = document.getElementById('pdffianza');
        pdf.src = doc;
        $( "#dialog-fianza" ).dialog( "open" );
    }
    
    function SubirFianza(doc){
        $( "#dialog-loadfianza" ).dialog( "open" );
    }
    
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