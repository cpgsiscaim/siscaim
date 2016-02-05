<%-- 
    Document   : Menu1
    Created on : 13-abr-2012, 10:01:05
    Author     : TEMOC
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.List, java.util.HashMap, java.lang.String, Modelo.Entidades.Operacion, Modelo.Entidades.CategoriaOp, Modelo.Entidades.Usuario"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/menu_style_bk.css" rel="stylesheet" />
        <title></title>
    </head>
    <body>
        <form id="frmMenu" name="frmMenu" action="">
            <input id="vista" name="vista" type="hidden" value=""/>
            <input id="control" name="control" type="hidden" value=""/>
            <input id="pagina" name="pagina" type="hidden" value="menu"/>
            <input id="operacion" name="operacion" type="hidden" value=""/>
        </form>        
        <%
            //Usuario usM = sesion.getUsuario();
            //List<Operacion> opersM = usM.getOperaciones();
            //HashMap datos = (HashMap)sesion.getDatos();
            HashMap menu = (HashMap)sesion.getMenu();
            List<CategoriaOp> categorias = (List<CategoriaOp>)menu.get("categorias");
        %>
        <table>
            <tr>
                <td align="center">
        <div align="center"><!--#03476F-->
            <ul id="navigation-1" style="background-color: #2A876C">
            <%
            for (int c=0; c < categorias.size(); c++){
                CategoriaOp cat = categorias.get(c);
                %>
                    <li>
                        <a href="#"> <%--title="<%=cat.getCategoria()%>"--%>
                            <%=cat.getCategoria().toUpperCase()%>
                        </a>
                <%
                //cargar las subcategorias de la categoria actual
                int submenu = 0;
                List<CategoriaOp> subcategorias = (List<CategoriaOp>)menu.get("subcategorias");
                for (int sc=0; sc < subcategorias.size(); sc++){
                    CategoriaOp subcat = subcategorias.get(sc);
                    if (subcat.getPadre()==cat.getIdcatop()){
                        if (submenu==0){
                            submenu=1;
                        %>
                        <ul class="navigation-2">
                        <%
                        }
                    %>
                                <li>
                                    <a href="#" ><%--title="<%=subcat.getCategoria()%>"--%>
                                        &nbsp;&nbsp;&nbsp;<%=subcat.getCategoria().toUpperCase()%><span>&raquo;</span>
                                    </a>
                                
                    <%
                        //cargar las operaciones de la subcategoria actual
                        int subop = 0;
                        List<Operacion> opsSub = (List<Operacion>)menu.get("operaciones");
                        for(int os=0; os < opsSub.size(); os++){
                            Operacion op = opsSub.get(os);
                            if (op.getCategoria().getIdcatop()==subcat.getIdcatop()){
                                if (subop==0){
                                    subop=1;
                                %>
                                    <ul class="navigation-3">
                                <%
                                }
                                %>
                                        <li>
                                            <a href="javascript: envia('<%=op.getControlador()%>','<%=op.getVista()%>','<%=op.getIdoperacion()%>')" ><%--title="<%=op.getOperacion()%>"--%>
                                                &nbsp;&nbsp;&nbsp;<%=op.getOperacion()%>
                                            </a>
                                        </li>
                                <%
                            }
                        }//for operaciones
                        if (subop==1){
                        %>
                                    </ul>
                        <%
                        }
                        %>
                        </li>
                    <%    
                    }//if hay subcategoria
                }//for subcategorias
                
                List<Operacion> opsCat = (List<Operacion>)menu.get("operaciones");
                for(int os=0; os < opsCat.size(); os++){
                    Operacion op = opsCat.get(os);
                    if (op.getCategoria().getIdcatop()==cat.getIdcatop()){
                        if (submenu==0){
                            submenu=1;
                        %>
                        <ul class="navigation-2">
                        <%
                        }
                        %>
                                <li>
                                    <a href="javascript: envia('<%=op.getControlador()!=null?op.getControlador():""%>','<%=op.getVista()%>','<%=op.getIdoperacion()%>')" ><%--title="<%=op.getOperacion()%>"--%>
                                        &nbsp;&nbsp;&nbsp;<%=op.getOperacion()%>
                                    </a>
                                </li>
                        <%
                    }
                }//for operaciones
                if (submenu==1){
                %>
                            </ul>
            <%
                }                
            %>
                </li>
            <%
            }//for categorias
            %>
            </ul>
            
            
            <%--
            <ul id="navigation-1">
                    <li><a href="#" title="Home">Home</a></li>
                    <li><a href="#" title="Products">Products</a>
                            <ul class="navigation-2">
                                    <li><a href="#" title="Electric Guitars">Electric Guitars</a></li>
                                    <li><a href="#" title="Acoustic Guitars">Acoustic Guitars <span>&raquo;</span></a>
                                            <ul class="navigation-3">
                                                    <li><a href="#" title="Six String">Six String</a></li>
                                                    <li><a href="#" title="Twelve String">Twelve String</a></li>
                                            </ul>
                                    </li>
                                    <li><a href="#" title="Bass Guitars">Bass Guitars</a></li>
                                    <li><a href="#" title="Accessories">Accessories <span>&raquo;</span></a>
                                            <ul class="navigation-3">
                                                    <li><a href="#" title="Guitar Stands">Guitar Stands</a></li>
                                                    <li><a href="#" title="Strings">Strings</a></li>
                                                    <li><a href="#" title="Tuners">Tuners</a></li>
                                                    <li><a href="#" title="Plectrums">Plectrums</a></li>
                                                    <li><a href="#" title="Capos">Capos</a></li>
                                                    <li><a href="#" title="Cases">Cases</a></li>
                                                    <li><a href="#" title="Straps">Straps</a></li>
                                            </ul>
                                    </li>
                            </ul>
                    </li>
                    <li><a href="#" title="Your Account">Your Account</a>
                            <ul class="navigation-2">
                                    <li><a href="#" title="Log In">Log In</a></li>
                                    <li><a href="#" title="Register">Register</a></li>
                            </ul>
                    </li>
                    <!--
                    <li><a href="#" title="Help">Help</a>
                            <ul class="navigation-2">
                                    <li><a href="#" title="FAQs">FAQs</a></li>
                                    <li><a href="#" title="Forum">Forum</a></li>
                                    <li><a href="#" title="Contact Us">Contact Us</a></li>
                            </ul>
                    </li>
                    <li><a href="#" title="Blah">Links</a>
                            <ul class="navigation-2">
                                    <li><a href="#" title="Taylor Guitars">Taylor Guitars</a></li>
                                    <li><a href="#" title="AER Amplifiers">AER Amplifiers</a></li>
                                    <li><a href="#" title="Shure Microphones">Shure Microphones</a></li>
                                    <li><a href="#" title="International">International <span>&raquo;</span></a>
                                            <ul class="navigation-3">
                                                    <li><a href="#" title="Musican's Friend">Musican's Friend</a></li>
                                                    <li><a href="#" title="Thomann Music">Thomann Music</a></li>
                                                    <li><a href="#" title="Turnkey">Turnkey</a></li>
                                            </ul>
                                    </li>
                            </ul>
                    </li>
                    -->
            </ul>--%>
        </div>
                </td>
            </tr>
        </table>
        
        <script language="javascript1.2">
            function envia(control, jsp, oper)
            {
                if (control == null || control == ''){
                    alert('La operación no está definida');
                    return;
                }                    
                vista = document.getElementById('vista');
                vista.value = jsp;
                ctrl = document.getElementById('control');
                ctrl.value = control;
                op = document.getElementById('operacion');
                op.value = oper;
                document.frmMenu.action = '<%=CONTROLLER%>'+control;
                document.frmMenu.submit();
            }
        </script>

    </body>
</html>
