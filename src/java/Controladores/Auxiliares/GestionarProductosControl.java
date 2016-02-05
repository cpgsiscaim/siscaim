/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.*;
import Modelos.ProductoMod;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarProductosControl extends Action{
    private Sesion sesion = new Sesion();
    private HashMap datos = new HashMap();
    private String paso = "0";

    @Override
    public void run() throws ServletException, IOException {
        //validar usuario logueado
        HttpSession sesionHttp = request.getSession(true);
        
        //validar si la sesion es valida
        sesion = (Sesion) sesionHttp.getAttribute("sesion");
        if (sesion==null || sesion.getUsuario()==null)
            throw new ServletException ("No existe una sesión válida");
        datos = sesion.getDatos();
        //obtener parámetros
        this.asignaParametros();
        sesion.setDatos(datos);
        
        //instanciar modelo y método de operación
        ProductoMod prodMod = new ProductoMod();
        sesion = prodMod.GestionarProductos(sesion);
        if (paso.equals("14") || paso.equals("15")){
            //imprimir
            datos = sesion.getDatos();
            byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            //response.sendRedirect(application.getRealPath("/Utilerias/imprimeReporte.jsp"));
            ServletOutputStream oustrm;
            try
            {
                oustrm = response.getOutputStream();
                oustrm.write(bytes, 0, bytes.length);
                oustrm.flush();
                oustrm.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        if (paso.equals("16")){
            //imprimir xls
            datos = sesion.getDatos();
            File f = (File)datos.get("reportexls");
            //byte[] bytes = (byte[])datos.get("bytes");
            response.setContentType("application/vnd.ms-excel");
            //response.setHeader("Content-Disposition", "attachment;filename=\""+);
            //response.setContentLength(bytes.length);
            InputStream in = new FileInputStream(f);
            ServletOutputStream oustrm;
            int bit = 256;
            try
            {
                oustrm = response.getOutputStream();
                while(bit>=0){
                    bit = in.read();
                    oustrm.write(bit);
                }
                oustrm.flush();
                oustrm.close();
                in.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }            
        }//imprimir xls
        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);
        
        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+sesion.getPaginaSiguiente());
        
        rd.forward(request, response);        
    }

    @Override
    public void asignaParametros() {
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig")!=null?request.getParameter("pasoSig"):"0";
        String paginaSig = "";
        HashMap param = new HashMap();
        switch (Integer.parseInt(paso)){
            case 0:
                //paso inicial: obtener la vista de los parametros
                datos.clear();
                String vista = request.getParameter("vista")!=null?request.getParameter("vista"):"";
                String idoperacion = request.getParameter("operacion")!=null?request.getParameter("operacion"):"";
                //cargar los parametros al hash de datos
                datos.put("idoperacion", idoperacion);
                sesion.setPaginaSiguiente(vista);
                break;
            case -1:
                //cargar productos de sucursal
                Sucursal sucSel = new Sucursal();
                sucSel.setId(Integer.parseInt(request.getParameter("sucursalsel")));
                datos.put("sucursalSel", sucSel);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 1: case 6: case 8: case 10: case 50: case 51: case 52: case 53:
            case 95: case 96: case 97: case 98: case 99:
                //ir a nuevo producto (1) || ir a inactivos (6) || ir a filtrar(8) || quitar filtros (10)
                //ir al principio de la lista (50) || mostrar anteriores (51) || mostrar siguiente grupo(52) || ir al final de la lista(53)
                //cancelar kardex (95)
                // cancelar filtrar (96) || cancelar inactivos (97) || cancelar nuevo producto(98) || salir de gestionar productos(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 4:
                //guardar producto nuevo (2) | editada (4)
                CargarProducto();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5: case 7: case 11: case 12:
                //ir a editar producto (3) || baja de producto(5) || activar producto (7) || ir a unidades de salida (11)
                //kardex (12)
                Producto prod = new Producto();
                prod.setId(Integer.parseInt(request.getParameter("idPro")));
                datos.put("producto", prod);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);
                break;
            case 9:
                //aplicar filtros
                CargaFiltros();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 13:
                //obtener el kardex
                datos.put("fechaini", request.getParameter("fechaini"));
                datos.put("fechafin", request.getParameter("fechafin"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 14:
                //imprimir kardex
                datos.put("reporte", application.getRealPath("/WEB-INF/Reportes/Inventario/kardex.jasper"));
                //parametros
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                Producto p = (Producto)datos.get("producto");
                String fechaini = datos.get("fechaini").toString();
                String fechafin = datos.get("fechafin").toString();
                param.put("PRODUCTO", new Integer(p.getId()));
                param.put("FECHAINI", fechaini);
                param.put("FECHAFIN", fechafin);
                datos.put("parametros", param);
                //paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente("/Inventario/Catalogos/Productos/kardexproducto.jsp");
                break;                
            case 15: case 16:
                //imprimir lista de precios
                datos.put("reporte", application.getRealPath("/WEB-INF/Reportes/Inventario/listapreciosxsuc.jasper"));
                //parametros
                param.put("LOGO", application.getRealPath("/Imagenes/"+datos.get("logo").toString()));
                //Sucursal suc = (Sucursal)datos.get("sucursalSel");
                //param.put("SUCURSAL", suc.getId());
                param.put("XLS", new Integer(1));
                if (Integer.parseInt(paso)==16){
                    param.put("XLS", new Integer(0));
                }
                param.put("SUBREPORTE", application.getRealPath("WEB-INF/Reportes/Inventario"));
                param.put("ENCABEZADO", application.getRealPath("WEB-INF/Reportes/Empresa"));
                param.put("SUCURSAL", new Integer(Integer.parseInt(request.getParameter("dato1"))));
                datos.put("parametros", param);
                datos.put("temp", application.getRealPath("WEB-INF/Reportes/Inventario"));
                //paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente("/Inventario/Catalogos/Productos/gestionarproductos.jsp");
                break;                
        }
        datos.put("paso", paso);
    }

    private void CargarProducto() {
        Producto prod = new Producto();
        prod.setMarca(new Marca());
        prod.setUnidad(new Unidad());
        prod.setCategoria(new Categoria());
        prod.setSubcategoria(new Subcategoria());
        prod.setProveedor(new Proveedor());
        //prod.setSucursal(new Sucursal());
        if (datos.get("accion").toString().equals("editar")){
            prod = (Producto)datos.get("producto");
            prod.setSubcategoria(new Subcategoria());            
        }
        try {
            prod.setClave(new String(request.getParameter("clave").getBytes("ISO-8859-1"), "UTF-8"));
            prod.setDescripcion(new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarProductosControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        prod.getMarca().setId(Integer.parseInt(request.getParameter("marca")));
        prod.getUnidad().setId(Integer.parseInt(request.getParameter("unidad")));
        prod.getCategoria().setId(Integer.parseInt(request.getParameter("categoria")));
        String subcat = request.getParameter("subcategoria");
        if (!subcat.equals(""))
            prod.getSubcategoria().setId(Integer.parseInt(request.getParameter("subcategoria")));
        else
            prod.setSubcategoria(null);
        prod.getProveedor().setId(Integer.parseInt(request.getParameter("proveedor")));
        prod.setServicio(Integer.parseInt(request.getParameter("servicio")));
        /*prod.setPeso(0);
        prod.setCostoUltimo(Float.parseFloat(request.getParameter("costoultimo")));
        prod.setCostoPromedio(prod.getCostoUltimo());
        prod.setCostoActual(prod.getCostoUltimo());*/
        
        //obtener los costos y los precios
        List<Sucursal> sucus = (List<Sucursal>)datos.get("sucursales");
        List<CostoProducto> costos = new ArrayList<CostoProducto>();
        List<PrecioProducto> precios = new ArrayList<PrecioProducto>();
        for (int i=0; i < sucus.size(); i++){
            Sucursal suc = sucus.get(i);
            float costo = Float.parseFloat(request.getParameter("costo"+Integer.toString(i)));
            CostoProducto cosp = new CostoProducto();
            cosp.setCosto(costo);
            cosp.setSucursal(suc);
            costos.add(cosp);
            
            float pre1 = Float.parseFloat(request.getParameter("precio1"+Integer.toString(i)));
            PrecioProducto prep1 = new PrecioProducto();
            prep1.setFactor(pre1);
            prep1.setNum(1);
            prep1.setSucursal(suc);
            precios.add(prep1);
            float pre2 = Float.parseFloat(request.getParameter("precio2"+Integer.toString(i)));
            PrecioProducto prep2 = new PrecioProducto();
            prep2.setFactor(pre2);
            prep2.setNum(2);
            prep2.setSucursal(suc);
            precios.add(prep2);
            float pre3 = Float.parseFloat(request.getParameter("precio3"+Integer.toString(i)));
            PrecioProducto prep3 = new PrecioProducto();
            prep3.setFactor(pre3);
            prep3.setNum(3);
            prep3.setSucursal(suc);
            precios.add(prep3);
            float pre4 = Float.parseFloat(request.getParameter("precio4"+Integer.toString(i)));
            PrecioProducto prep4 = new PrecioProducto();
            prep4.setFactor(pre4);
            prep4.setNum(4);
            prep4.setSucursal(suc);
            precios.add(prep4);
            float pre5 = Float.parseFloat(request.getParameter("precio5"+Integer.toString(i)));
            PrecioProducto prep5 = new PrecioProducto();
            prep5.setFactor(pre5);
            prep5.setNum(5);
            prep5.setSucursal(suc);
            precios.add(prep5);
        }
        datos.put("costos", costos);
        datos.put("precios", precios);
        
        prod.setAplicarcosto(0);
        String aplicarcosto = request.getParameter("aplicartodas")!=null?request.getParameter("aplicartodas"):"";
        if (aplicarcosto.equals("on"))
            prod.setAplicarcosto(1);
        
        prod.setAplicarprecios(0);
        String aplicarprecios = request.getParameter("aplicarpreciotodas")!=null?request.getParameter("aplicarpreciotodas"):"";
        if (aplicarprecios.equals("on"))
            prod.setAplicarprecios(1);
        
        /*04-oct-13:prod.setIep(Float.parseFloat(request.getParameter("iep")));
        prod.setIvaNacional(Float.parseFloat(request.getParameter("ivan")));
        prod.setIvaExtranjero(Float.parseFloat(request.getParameter("ivae")));
        prod.setStockMaximo(Float.parseFloat(request.getParameter("stockmax")));
        prod.setStockMinimo(Float.parseFloat(request.getParameter("stockmin")));*/
        
        /*prod.setPrecio1(Float.parseFloat(request.getParameter("precio1")));
        prod.setPrecio2(Float.parseFloat(request.getParameter("precio2")));
        prod.setPrecio3(Float.parseFloat(request.getParameter("precio3")));
        prod.setPrecio4(Float.parseFloat(request.getParameter("precio4")));
        prod.setPrecio5(Float.parseFloat(request.getParameter("precio5")));*/
        prod.setDescuento1(Float.parseFloat(request.getParameter("descto1")));
        prod.setDescuento2(Float.parseFloat(request.getParameter("descto2")));
        prod.setDescuento3(Float.parseFloat(request.getParameter("descto3")));
        prod.setDescuento4(Float.parseFloat(request.getParameter("descto4")));
        prod.setDescuento5(Float.parseFloat(request.getParameter("descto5")));
        prod.setDescuentoMaximo(Float.parseFloat(request.getParameter("descmax")));
        String fechaUC = request.getParameter("fechauc");
        String fechaUV = request.getParameter("fechauv");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date feUC = null;
        Date feUV = null;
        try {
            feUC = formatoDelTexto.parse(fechaUC);
            feUV = formatoDelTexto.parse(fechaUV);
        } catch (ParseException ex) {
        }            
        prod.setFechaUltCompra(feUC);
        prod.setFechaUltVenta(feUV);
        prod.setCodigoAlterno(request.getParameter("codalt"));
        
        /*Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        prod.setSucursal(sucSel);*/
        prod.setTipo(Integer.parseInt(request.getParameter("tipo")));
        prod.setSurtido(Integer.parseInt(request.getParameter("surtido")));
        
        datos.put("unidadempaque", request.getParameter("unidademp"));
        datos.put("factor", request.getParameter("valor"));
        
        datos.put("producto", prod);
    }

    private void CargaFiltros() {
        HashMap filtros = new HashMap();
        /*String filtro1 = request.getParameter("filtro1")!=null?request.getParameter("filtro1"):"";
        String filtro2 = request.getParameter("filtro2")!=null?request.getParameter("filtro2"):"";
        String filtro3 = request.getParameter("filtro3")!=null?request.getParameter("filtro3"):"";
        String filtro4 = request.getParameter("filtro4")!=null?request.getParameter("filtro4"):"";
        filtros.put("filtro1", filtro1);
        filtros.put("filtro2", filtro2);
        filtros.put("filtro3", filtro3);
        filtros.put("filtro4", filtro4);*/
        try {
            //if (!filtro1.equals("")){
                filtros.put("descripcion", new String(request.getParameter("descripcion").getBytes("ISO-8859-1"), "UTF-8"));
            //}
            //if (!filtro2.equals("")){
                Proveedor prov = new Proveedor();
                String idprov = request.getParameter("proveedor");
                if (!idprov.equals(""))
                    prov.setId(Integer.parseInt(idprov));
                filtros.put("proveedor", prov);
            /*}
            if (!filtro3.equals("")){*/
                Categoria cat = new Categoria();
                String idcat = request.getParameter("categoria");
                if (!idcat.equals(""))
                    cat.setId(Integer.parseInt(idcat));
                filtros.put("categoria", cat);
            /*}
            if (!filtro4.equals("")){*/
                Marca mar = new Marca();
                String idmar = request.getParameter("marca");
                if (!idmar.equals(""))
                    mar.setId(Integer.parseInt(idmar));
                filtros.put("marca", mar);
            //}
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(GestionarClientesControl.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        datos.put("filtros", filtros);
    }

}
