/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Sesion;
import Modelo.Daos.Catalogos.CategoriaDocDao;
import Modelo.Daos.Catalogos.TipoDocumentoDao;
import Modelo.Daos.DocumentoDao;
import Modelo.Daos.SucursalDao;
import Modelo.Entidades.Empleado;
import java.util.*;

/**
 *
 * @author TEMOC
 */
public class DocumentacionMod {
    public DocumentacionMod(){
    }
    
    public Sesion GestionarDocumentacion(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        switch (paso){
            case 0:
                //carga catalogos de documentos
                datos = ObtenerCatalogos(datos);
                break;
            case 1:
                datos = ObtenerEmpleados(datos);
                break;
            case 2:
                datos = ImprimirReporte(datos);
                break;
            case 3:
                datos.put("paso", "0");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);        
        return sesion;
      }

    private HashMap ObtenerCatalogos(HashMap datos) {
        SucursalDao sucDao = new SucursalDao();
        datos.put("sucursales", sucDao.obtenerListaSucYMatriz());
        CategoriaDocDao cddao = new CategoriaDocDao();
        datos.put("categorias", cddao.obtenerListaActivos());
        TipoDocumentoDao tddao = new TipoDocumentoDao();
        datos.put("tiposdoc", tddao.obtenerListaActivos());
        return datos;
    }

    private HashMap ObtenerEmpleados(HashMap datos) {
        HashMap filtros = (HashMap)datos.get("filtros");
        String docs = filtros.get("documentos").toString();
        String idsuc = filtros.get("sucursal").toString();
        String estatus = filtros.get("estatus").toString();
        String cotiza = filtros.get("cotiza").toString();
        if (estatus.equals("-1"))
            estatus = "0,1";
        if (cotiza.equals("-1"))
            cotiza = "0,1";
        DocumentoDao docdao = new DocumentoDao();
        List<Empleado> lista = docdao.obtenerEmpleadosConDocumentos(docs, idsuc, estatus, cotiza);
        //obtener solo aquellos que tengan todos los documentos seleccionados
        List<Empleado> emples = new ArrayList<Empleado>();
        StringTokenizer tksDocs = new StringTokenizer(docs,",");
        for (int i=0; i < lista.size(); i++){
            Empleado emp = lista.get(i);
            int countdocs = docdao.ContarDocumentosDeEmpleado(emp.getNumempleado(), docs);
            if (countdocs == tksDocs.countTokens())
                emples.add(emp);
        }
        datos.put("empleados", emples);
        
        return datos;
    }
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }

}