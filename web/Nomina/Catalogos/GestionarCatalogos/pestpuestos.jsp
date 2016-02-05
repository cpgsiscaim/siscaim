<%-- 
    Document   : pestpuestos
    Created on : Jun 15, 2012, 10:11:36 AM
    Author     : roman
--%>
<%@page import="java.util.List,  Modelo.Entidades.Empleado,  Modelo.Entidades.Persona, Modelo.Entidades.Catalogos.Civil, Modelo.Entidades.Catalogos.GpoSanguineo, Modelo.Entidades.Catalogos.Estado, Modelo.Entidades.Catalogos.Municipio, Modelo.Entidades.Sucursal, Modelo.Entidades.Catalogos.Titulo"%>

<%


%>


<table width="100%" align="center" cellpadding="5px">
<tr>
<td>            
<table width="100%" align="center" cellpadding="5px" frame="box">         
    <tr>
        <td align="center">
                <span class="etiqueta">Puestos:</span>                
        </td>
    </tr>
    <tr>
        <td width="70%">
                                <table class="tablaLista" width="100%">
                                <thead>
                                <tr>
                                    <td width="10%" align="center">
                                        <span>Id</span>
                                    </td>
                                    <td width="45%" align="center">
                                        <span>Descripción</span>
                                    </td>
                                    <td width="45%" align="center">
                                        <span>Salario</span>
                                    </td>                                    
                                </tr>
                                </thead>
                                
                                <tbody>                                            
                                    <tr>
                                        <td align="center" width="10%">
                                            <input id="radioEmp" name="radioEmp" type="radio"/>
                                        </td>
                                        <td width="50%" align="center">
                                            <span>Tipo pago A</span>
                                        </td>
                                        <td width="50%" align="center">
                                            <span>$ 5,000</span>
                                        </td>                                                                                       
                                    </tr>
                                </tbody>
                               </table>     
        </td>
        <td width="30%" align="center">             
            <table width="100%">
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Nuevo Medio">
                                    <a href="javascript: NuevoMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Editar Medio">
                                    <a href="javascript: ModificarMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/editar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
                        <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
                            <tr>
                                <td style="padding-right:0px" title ="Borrar Medio">
                                    <a href="javascript: EliminarMedioClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/borrar.png);width:150px;height:30px;display:block;"><br/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>        
        </td>    
    </tr>    
</table>                        
</td>            
</tr>    
</table>
<script lang="javascript">

</script>