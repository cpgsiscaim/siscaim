<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>
    <%@page import="java.util.HashMap, java.util.List, java.util.ArrayList, Modelo.Entidades.Sucursal, Modelo.Entidades.Movimientos, Modelo.Entidades.Chequera, Modelo.Entidades.Cargo, Modelo.Entidades.Usuario, Modelo.Entidades.Empleado, Modelo.Entidades.Persona, java.text.NumberFormat, java.text.DecimalFormat"%>
<jsp:useBean id="sesion" class="Generales.Sesion" scope="session" />
<%
    //int opt = request.getParameter("opt")!=null?Integer.parseInt(request.getParameter("opt")):1;
  float saldoAcumulado =0;
  HashMap datosS = sesion.getDatos();  
  List<Movimientos> listado = (List<Movimientos>)datosS.get("listadoMov");  
  List<Chequera> liston = (List<Chequera>)datosS.get("listadoTar"); 
  
  Usuario user = sesion.getUsuario();
  Empleado emp = user.getEmpleado();
  Persona per = emp.getPersona();
  
  //List<HashMap> validaChequera = (List<HashMap>)datosS.get("hayChequera");
   // Revisamos si este usuario tiene alguna tarjeta
  boolean hayTarjeta = false;
  for (int i=0; i < liston.size(); i++){
      Chequera cheq = liston.get(i);
      if (cheq.getResponsable().getIdusuario()==user.getIdusuario()){
          hayTarjeta = true;
          break;
      }
  }
  
  List<HashMap> totales = (List<HashMap>)datosS.get("totalDeAbonos");
  NumberFormat formato = new DecimalFormat("$ #,###,##0.00");  
 %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Consulta de movimientos </title>
    <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
    <link type="text/css" href="/siscaim/Estilos/titulos.css" rel="stylesheet" />
    <script type="text/javascript" src="/siscaim/Utilerias/utilerias.js"></script>
        <!-- Archivos para los cuadros modales -->
    <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/normalize.css">
    <link rel="stylesheet" type="text/css" href="/siscaim/Estilos/main.css">
    <script src="/siscaim/Utilerias/jquery-1.4.3.min.js"></script>
    <script type='text/javascript' src='/siscaim/Utilerias/jquery.modal.js'></script>
    <script type='text/javascript' src='/siscaim/Utilerias/site.js'></script>
  </head>
  <body>
    <table width="100%">
      <tr>
        <td width="100%" class="tablaMenu">
          <div align="left">
              <%@include file="/Generales/IniciarSesion/menu.jsp" %>
          </div>
        </td>
      </tr>
    </table>
    <%if (!hayTarjeta){%>
    <br><br>
    <table width="100%">
        <tr>
            <td width="100%" align="center">
                <span class="subtitulo">Usted no tiene asignada ninguna tarjeta</span>
            </td>
        </tr>
    </table>
    <%} else {%>
        <table>	
          <tr>
              <td><img src="/siscaim/Imagenes/Empresa/cheque.png" width="140"></td>
              <td align="middle">
                  <h2>Consultar Movimientos de Tarjeta de <%=per.getNombre()%></h2>                  
              </td>
          </tr>
        </table>	    
    <hr>
    <form id="frmGestionarCheq" name="frmGestionarCheq" action="<%=CONTROLLER%>/Gestionar/Chequeramov" method="post">
      <!-- este input oculto es por si se quiere ir a otra jsp sin procesar nada -->
      <input id="paginaSig" name="paginaSig" type="hidden" value=""/>
      <!-- este input oculto es para enviar el paso del proceso que se ejecutara -->
      <input id="pasoSig" name="pasoSig" type="hidden" value=""/>
      <input id="idAlma" name="idAlma" type="hidden" value=""/>            
      <!-- inician los botones -->
      <table width="100%">
        <tr>          
          <td width="20%" align="left">
            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
              <tr>
                <td style="padding-right:0px" title ="Salir">
                  <a href="javascript: SalirClick()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/salir.png);width:150px;height:30px;display:block;"><br/></a>
                </td>
              </tr>
            </table>                                                    
          </td>
          <td width="20%" align="left">
            <style>#web-buttons-id1i6bq a{display:block;color:transparent;} #web-buttons-id1i6bq a:hover{background-position:left bottom;}a#web-buttons-id1i6bqa {display:none}</style>
            <table id="web-buttons-id1i6bq" width=0 cellpadding=0 cellspacing=0 border=0>
              <tr>
                <td style="padding-right:0px" title ="NuevaCh">
                  <a href="javascript: NuevoCargo()" title="" style="background-image:url(/siscaim/Estilos/imgsBotones/nuevo.png);width:150px;height:30px;display:block;"><br/></a>
                </td>
              </tr>
            </table>
          </td>
          <td width="20%" align="left">
              <table id="saldo" width=0 cellpadding=0 cellspacing=0 border=0>
                  <tr style="padding-top: 3px;">
                      <%
                        int id_user = user.getIdusuario(); //Obtenemos el id del usuario
                        int resultado = 0;
                        System.out.println(id_user); 
                        for(int i=0; i<liston.size();i++) {
                          Chequera che = liston.get(i);
                          if(che.getResponsable().getIdusuario()==id_user)  {
                            resultado = (che.getId()-1);
                            System.out.println("se encontro el valor deseado "+resultado);
                          }
                        }                        
                        HashMap tots = totales.get(resultado);
                      %>
                      <td style="padding-right:5px"><h3>Saldo actual</h3></td>
                      <td><h3><%=formato.format(Double.parseDouble(tots.get("totalsaldos").toString()))%>
                      </h3></td>
                  </tr>
              </table>
          </td>
        </tr>
      </table>
    </form>
      <center><h2><small>Movimientos de su tarjeta al   
          <script type="text/javascript">
          var dias_semana = new Array("Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado");
          var meses = new Array ("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre", "Diciembre");
          var fecha_actual = new Date();
          document.write(dias_semana[fecha_actual.getDay()] + " " + fecha_actual.getDate() + " de " + meses[fecha_actual.getMonth()] + " de " + fecha_actual.getFullYear());
          </script>
          </small>
        </h2></center>
  <table class="tablaLista" width="80%" align="center">
      <%
        if(listado.size()==0)   { 
      %>
      <tr>
        <td colspan="4" align="center">
            <span class="etiquetaB">
                 
            </span>
        </td>
      </tr>
      <%
         } else {
      %>
      <thead>
          <tr>
              <td align="center" width="3%">
                <span></span>
              </td> 
              <td align="center" width="8%">
                <span>Fecha</span>
              </td> 
              <td align="center" width="25%">
                <span>Proveedor</span>
              </td> 
              <td align="center" width="25%">
                <span>Concepto</span>
              </td>               
              <td align="center" width="10%">
                <span>Abono</span>
              </td>
              <td align="center" width="10%">
                <span>Cargo</span>
              </td>
              <td align="center" width="10%">
                  <span>Saldo</span>
              </td>
              <td align="center" width="5%">
                <span>Documento</span>
              </td> 
          </tr>
      </thead>
      <tbody> 
      <%         
        for(int i=0; i<listado.size();i++) { 
            Movimientos movi = listado.get(i);
            System.out.println("Propiedades del movi: "+movi.getId()+" Chequera: "+movi.getId_ch().getId()+" cargo: "+movi.getId_ca().getId()+"");
            if(movi.getId_ch().getId()==(resultado+1))  {
      %>
      <tr onclick="Activa(<%=i%>)">
          <td align="center" width="5%">
             <input id="radioMovi" name="radioMovi" type="radio" value="<%=movi.getId() %>"/>
          </td>
          <td align="center" width="10%">
            <span class="etiqueta"><%=movi.getFecha()%></span>
          </td>
          <% if(movi.getId_ca().getConcepto()==null) { %> <!-- Aqui se describe el abono-->
          <td>
              <span class="etiqueta"></span>
          </td>      
          <td>
              <span class="etiqueta"></span>
          </td>      
          <td align="right" width="10%">
              <span class="etiqueta" style="color: red;"><b><%=formato.format(movi.getId_ab().getCantidad())%></b></span>
          </td>       
          <td align="right" width="10%">
              <span class="etiqueta"></span>
          </td> 
          <td align="right" width="10%">
            <%
              saldoAcumulado = saldoAcumulado + movi.getId_ab().getCantidad();
            %>
            <span class="etiqueta"><%=formato.format(saldoAcumulado)%></span>
          </td>
            <td align="center" width="5%">
                <span class="etiqueta"> <!-- validamos si existe documento para mostrar el icono correspondiente -->
                  <a href="#">
                    <img src="/siscaim/Estilos/imgsBotones/doc_inactivo.png" width="26">
                  </a>
                </span>
            </td>
          <% } else { %>  <!-- Aqui se describe el cargo -->
          <td align="center" width="10%">
              <span class="etiqueta"><%=movi.getId_ca().getProveedor()%></span>
          </td>      
          <td align="center" width="10%">
              <span class="etiqueta"><%=movi.getId_ca().getConcepto()%></span>
          </td>   
          <td align="center" width="10%">
              <span class="etiqueta"></span>
          </td>  
          <td align="right" width="10%">
              <span class="etiqueta"><%=formato.format(movi.getId_ca().getCantidad()) %></span>
          </td>
          <td align="right" width="10%">
            <%
              saldoAcumulado = saldoAcumulado - movi.getId_ca().getCantidad();
            %>
              <span class="etiqueta"><%=formato.format(saldoAcumulado)%></span>
          </td>
          <td align="center" width="5%">
            <!-- validamos si existe documento para mostrar el icono correspondiente -->
              <a class="modalLink" href="#modal<%=i%>">
                <img src="/siscaim/Estilos/imgsBotones/doc_activo.png" width="26">
              </a>
            <div class="overlay"></div>
            <div id="modal<%=i%>" class="modal">
              <p class="closeBtn"><b>Cerrar</b></p>
              <table>
                <tr>
                  <td style="padding-top: 60px;">
                      <embed src="/siscaim/Imagenes/Comprobantes/<%=movi.getId_ca().getRutaComprobante()%>" width="500" height="650">                    
                  </td>
                  <td> <!-- detalles de nuestro movimiento-->
                    <table style="font-size: 12px;">
                      <tr>
                        <td colspan="2" style="text-align: center;">Detalles del Movimiento</td>
                      </tr>
                      <tr>
                        <td>Fecha:</td>
                        <td><%=movi.getFecha()%></td>
                      </tr>
                      <tr>
                        <td>Monto:</td>
                        <td><%=movi.getId_ca().getCantidad()%></td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </div>                                        
          </td>
          <% } %>          
      </tr>
      <% 
             }
      } %>
      </tbody>
      <% }   %>
  </table>
  <%}%>
<!-- Funciones JavaScript -->
    <script language="javascript">        
    function NuevoCargo(){
        var frm = document.getElementById('frmGestionarCheq');
        var pagina = document.getElementById('paginaSig');
        var paso = document.getElementById('pasoSig');
        //pagina.value = '/Empresa/GestionarChequera/subirPdf.jsp';
        pagina.value = '/Empresa/GestionarChequera/loadFile.jsp'; //nuevoCargo.jsp
        paso.value = '12'; //8
        frm.submit();                
    }
    function SalirClick(){
        var frm = document.getElementById('frmGestionarCheq');
        var pagina = document.getElementById('paginaSig');
        var paso = document.getElementById('pasoSig');
        pagina.value = '/Generales/IniciarSesion/bienvenida.jsp';
        paso.value = '1';
        frm.submit();                
    }
    </script>
  </body>
</html>
