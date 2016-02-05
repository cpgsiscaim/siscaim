/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelos;

import Generales.Sesion;
import Modelo.Daos.AguinaldoDao;
import Modelo.Daos.Catalogos.QuincenaDao;
import Modelo.Daos.DetalleNominaDao;
import Modelo.Daos.HistorialIMSSDao;
import Modelo.Daos.NominaDao;
import Modelo.Daos.PersonaMedioDao;
import Modelo.Daos.SucursalDao;
import Modelo.Daos.UtilDao;
import Modelo.Entidades.Aguinaldo;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.DetalleNomina;
import Modelo.Entidades.HistorialIMSS;
import Modelo.Entidades.Nomina;
import Modelo.Entidades.PersonaMedio;
import Modelo.Entidades.Plaza;
import Modelo.Entidades.Sucursal;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author TEMOC
 */
public class TimbradoMod {
    int grupos = 0;
    public TimbradoMod(){}
    
    public Sesion GenerarTimbrado(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //cargar datos iniciales para el timbrado
                datos = ObtenerDatosInicio(datos);
                break;
            case -1: 
                //obtener quincenas de año
                datos = ObtenerQuincenasDeAnioSel(datos);
                break;
            case 1:
                //generar el archivo de timbrado
                datos = GenerarArchivoTimbradoSaefa(datos);//GenerarArchivoTimbrado(datos);
                break;
            case 2:
                datos = GeneraTimbradoAguinaldos(datos);
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);        
        return sesion;
    }        

    private HashMap ObtenerDatosInicio(HashMap datos) {
        //obtener las sucursales para mostrar los registros patronales
        SucursalDao sucDao = new SucursalDao();
        List<Sucursal> sucus = sucDao.obtenerListaSucYMatriz();
        datos.put("sucsel", sucus.get(0));
        datos.put("sucursales", sucus);
        NominaDao nomdao = new NominaDao();
        int idop = Integer.parseInt(datos.get("idoperacion").toString());
        if (idop==57){
            //obtener los años registrados de nóminas normales
            List<Integer> anioshis = nomdao.obtenerAniosHistoricos();
            List<Quincena> quinhis = nomdao.obtenerQuincenasHistoricasDeAnio(anioshis.get(0).intValue());
            /*//quitar la quincena activa
            for (int i=0; i < quinhis.size(); i++){
                Quincena quin = quinhis.get(i);
                if (quin.getEstatus()==1){
                    quinhis.remove(i);
                    break;
                }
            }*/

            datos.put("anioshis", anioshis);
            datos.put("quinhis", quinhis);
            datos.put("anioact", Integer.toString(anioshis.get(0).intValue()));
            datos.put("aniosel", Integer.toString(anioshis.get(0).intValue()));
        } else {
            //nomina de aguinaldos
            List<Integer> anioshis = nomdao.obtenerAniosHistoricosAguinaldos();
            datos.put("anioshis", anioshis);
        }
        return datos;
    }
    
    private HashMap ObtenerQuincenasDeAnioSel(HashMap datos) {
        int anioact = Integer.parseInt(datos.get("anioact").toString());
        int aniosel = Integer.parseInt(datos.get("aniosel").toString());
        //obtener años registrados en la base de datos
        NominaDao nomdao = new NominaDao();
        List<Quincena> quinhis = nomdao.obtenerQuincenasHistoricasDeAnio(aniosel);
        
        /////******* DEJAR LA QUINCENA ACTIVA *******////////
        /*if (aniosel==anioact){
            //quitar la quincena activa
            for (int i=0; i < quinhis.size(); i++){
                Quincena quin = quinhis.get(i);
                if (quin.getEstatus()==1){
                    quinhis.remove(i);
                    break;
                }
            }
        }*/
        datos.put("quinhis", quinhis);
        datos.put("aniosel", Integer.toString(aniosel));
        
        return datos;
    }

    private HashMap GenerarArchivoTimbrado(HashMap datos) {
        File timb = null;
        
        int idsuc = Integer.parseInt(datos.get("rpsel").toString());
        SucursalDao sucDao = new SucursalDao();
        Sucursal suc = sucDao.obtener(idsuc);
        
        String plantilla = datos.get("plantilla").toString();
        String ruta = datos.get("ruta").toString();
        int anio = Integer.parseInt(datos.get("aniosel").toString());
        int quincena = Integer.parseInt(datos.get("quincenas").toString());
        QuincenaDao qudao = new QuincenaDao();
        Quincena quin = qudao.obtener(quincena);
        //obtener nomina de la quincena seleccionada
        NominaDao nomdao = new NominaDao();
        Nomina nom = nomdao.obtenerNominaNormalDeQuincenaYSucursal(quincena, anio, suc.getId());
        DetalleNominaDao dndao = new DetalleNominaDao();
        List<Plaza> plazas = dndao.obtenerPlazasCotizaDeNomina(nom.getId());
        UtilMod utmod = new UtilMod();
        
        String descri = "PAGO DE NOMINA DEL "+Integer.toString(quin.getInicio())+" AL "+
                Integer.toString(quin.getFin())+ " DE "+quin.getMes();
        
        int diasquin = quin.getFin()-quin.getInicio()+1;
        //String filename = "test.xls";
        //List sheetData = new ArrayList();
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(plantilla);
            XSSFWorkbook  workbook = new XSSFWorkbook(fis);
            
                //obtener los datos
            
                //-------
                SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                
                //guardar los datos en la hoja
                XSSFSheet sheetDC = workbook.getSheetAt(1);
                XSSFSheet sheetRC = workbook.getSheetAt(4);
                XSSFSheet sheetDE = workbook.getSheetAt(5);
                XSSFSheet sheetCN = workbook.getSheetAt(6);
                XSSFSheet sheetMI = workbook.getSheetAt(10);
                XSSFSheet sheetCNE = workbook.getSheetAt(12);
                XSSFSheet sheetCNP = workbook.getSheetAt(13);
                XSSFSheet sheetNPD = workbook.getSheetAt(14);
                XSSFSheet sheetCND = workbook.getSheetAt(15);
                XSSFSheet sheetNDD = workbook.getSheetAt(16);
                int cont=1;
                int p=0;
                int fnpd = 6, fndd = 6;
                for (int f=6; f < plazas.size(); f++){
                    //el 10 deberá sustituirse por la cantidad de registros obtenidos de la nómina
                    Plaza plz = plazas.get(p);
                    
                    XSSFRow row = sheetDC.getRow(f);
                    XSSFRow rowRC = sheetRC.getRow(f);
                    XSSFRow rowDE = sheetDE.getRow(f);
                    XSSFRow rowCN = sheetCN.getRow(f);
                    XSSFRow rowMI = sheetMI.getRow(f);
                    XSSFRow rowCNE = sheetCNE.getRow(f);
                    XSSFRow rowCNP = sheetCNP.getRow(f);
                    XSSFRow rowCND = sheetCND.getRow(f);
                    if (row==null)
                        row = sheetDC.createRow(f);
                    if (rowRC==null)
                        rowRC = sheetRC.createRow(f);
                    if (rowDE==null)
                        rowDE = sheetDE.createRow(f);
                    if (rowCN==null)
                        rowCN = sheetCN.createRow(f);
                    if (rowMI==null)
                        rowMI = sheetMI.createRow(f);
                    if (rowCNE==null)
                        rowCNE = sheetCNE.createRow(f);
                    if (rowCNP==null)
                        rowCNP = sheetCNP.createRow(f);
                    if (rowCND==null)
                        rowCND = sheetCND.createRow(f);
                    //float factor = f/100.00f;
                    double percep = utmod.Redondear(dndao.obtenerTotalPercepcionesDePlazaEnNomina(plz.getId(), nom.getId()),2);// 1000.00f*(1+factor);
                    double deduc = utmod.Redondear(dndao.obtenerTotalDeduccionesDePlazaEnNomina(plz.getId(), nom.getId()),2);
                    //se recorren las celdas
                    for (int i=0; i < 19; i++){
                        
                        //LLENADO DE LA HOJA DC
                        if (row.getCell(i, Row.RETURN_NULL_AND_BLANK)==null)
                            row.createCell(i);
                        
                        XSSFCell cell = row.getCell(i);
                        switch (i){
                            case 0: 
                                cell.setCellValue(new XSSFRichTextString("NOM"));
                                break;
                            case 1:
                                cell.setCellValue(new XSSFRichTextString(Integer.toString(cont)));
                                break;
                            case 2:
                                Date hoy = new Date();
                                cell.setCellValue(ffecha.format(hoy));
                                break;
                            case 3:
                                cell.setCellValue(new XSSFRichTextString("PAGO EN UNA SOLA EXHIBICION"));
                                break;
                            case 4:
                                //aca va el total de percepciones pagado al empleado
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(percep);
                                break;
                            case 5:
                                //aca va el total de deducciones pagado al empleado
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(deduc);
                                break;
                            case 6:
                                //aca va el total de deducciones pagado al empleado
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(utmod.Redondear(percep-deduc, 2));
                                break;
                            case 7:
                                cell.setCellValue(new XSSFRichTextString("EFECTIVO"));
                                break;
                            case 8:
                                cell.setCellValue(new XSSFRichTextString("EGRESO"));
                                break;
                            case 10:
                                cell.setCellValue(new XSSFRichTextString("MXN"));
                                break;
                            case 11:
                                cell.setCellValue(new XSSFRichTextString("DEDUCCIONES"));
                                break;
                            case 13:
                                cell.setCellValue(new XSSFRichTextString("OAXACA DE JUAREZ, OAXACA"));
                                break;
                            case 14:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getCuenta()));
                                break;
                            default:
                                cell.setCellValue(new XSSFRichTextString(""));
                                break;
                        }
                        //FIN DE LLENADO DE LA HOJA DC
                    } //fin recorrido de columnas de hoja DC
                    
                    //LLENADO DE LA HOJA RC
                    if (rowRC.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                        rowRC.createCell(0);
                    XSSFCell cellRC = rowRC.getCell(0);
                    cellRC.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                    if (rowRC.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                        rowRC.createCell(1);
                    cellRC = rowRC.getCell(1);
                    cellRC.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getNombreCompleto()));
                    //FIN DE LLENADO DE LA HOJA RC
                    
                    //LLENADO DE LA HOJA DE
                    for (int i=0; i < 11; i++){
                        //recorrer columnas de la hoja DE
                        if (rowDE.getCell(i, Row.RETURN_NULL_AND_BLANK)==null)
                            rowDE.createCell(i);
                        
                        XSSFCell cell = rowDE.getCell(i);
                        switch (i){
                            case 0: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                                break;
                            case 1: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getDireccion().getCalle()));
                                break;
                            case 4: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getDireccion().getColonia()));
                                break;
                            case 5: case 7: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getDireccion().getPoblacion().getMunicipio()));
                                break;
                            case 8:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getDireccion().getPoblacion().getEstado().getEstado()));
                                break;
                            case 9:
                                cell.setCellValue(new XSSFRichTextString("MEXICO"));
                                break;
                            case 10:
                                cell.setCellValue(new XSSFRichTextString(Integer.toString(plz.getEmpleado().getPersona().getDireccion().getCp())));
                                break;
                            default:
                                cell.setCellValue(new XSSFRichTextString(""));
                                break;
                        }//switch
                    } //fin recorrido de columnas
                    //FIN LLENADO DE LA HOJA DE
                    
                    //LLENADO DE LA HOJA CN
                    if (rowCN.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(0);                    
                    XSSFCell cell = rowCN.getCell(0);
                    cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                    
                    if (rowCN.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(1);                    
                    cell = rowCN.getCell(1);
                    cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                    cell.setCellValue(1);
                    
                    if (rowCN.getCell(2, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(2);                    
                    cell = rowCN.getCell(2);
                    cell.setCellValue(new XSSFRichTextString("SERVICIO"));
                    
                    if (rowCN.getCell(3, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(3);                    
                    cell = rowCN.getCell(3);
                    cell.setCellValue(new XSSFRichTextString(""));
                    
                    if (rowCN.getCell(4, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(4);                    
                    cell = rowCN.getCell(4);
                    cell.setCellValue(new XSSFRichTextString(descri));
                    
                    if (rowCN.getCell(5, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(5);                    
                    cell = rowCN.getCell(5);
                    cell.setCellValue(utmod.Redondear((percep-deduc)/diasquin,2));

                    if (rowCN.getCell(6, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCN.createCell(6);                    
                    cell = rowCN.getCell(6);
                    cell.setCellValue(utmod.Redondear(percep-deduc,2));
                    //FIN LLENADO DE LA HOJA CN
                    
                    //LLENADO DE LA HOJA MI
                    if (rowMI.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                            rowMI.createCell(0);                    
                    cell = rowMI.getCell(0);
                    cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                    
                    if (rowMI.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                            rowMI.createCell(1);                    
                    cell = rowMI.getCell(1);
                                        
                    PersonaMedioDao pmdao = new PersonaMedioDao();
                    List<PersonaMedio> correos = pmdao.obtenerCorreosDePersona(plz.getEmpleado().getPersona().getIdpersona());
                    if (correos==null){
                        cell.setCellValue(new XSSFRichTextString(""));
                    } else {
                        String scorreos = "";
                        for (int c=0; c < correos.size(); c++){
                            PersonaMedio pm = correos.get(c);
                            if (scorreos.equals(""))
                                scorreos = pm.getMedio().getMedio();
                            else
                                scorreos += ";"+pm.getMedio().getMedio();
                        }
                        cell.setCellValue(new XSSFRichTextString(scorreos));
                    }
                    //FIN DE LLENADO DE LA HOJA MI
                    
                    //LLENADO DE LA HOJA CNE
                    ffecha = new SimpleDateFormat("dd/MM/yyyy");
                    String fpago = Integer.toString(anio)+"-"+String.format("%02d", quin.getNummes())+"-"+String.format("%02d", quin.getFin());
                    String finipago = Integer.toString(anio)+"-"+String.format("%02d", quin.getNummes())+"-"+String.format("%02d", quin.getInicio());;
                    
                    for (int i=0; i < 21; i++){
                        //recorrer columnas de la hoja CNE
                        if (rowCNE.getCell(i, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCNE.createCell(i);
                        
                        cell = rowCNE.getCell(i);
                        switch (i){
                            case 0: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                                break;
                            case 1: 
                                cell.setCellValue(new XSSFRichTextString(suc.getRegistropatronal()));
                                break;
                            case 2: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getClave()));
                                break;
                            case 3: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getCurp()));
                                break;
                            case 4: 
                                cell.setCellValue(new XSSFRichTextString("2"));
                                break;
                            case 5: 
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getNss()));
                                break;
                            case 6: case 7:
                                cell.setCellValue(new XSSFRichTextString(fpago));
                                break;
                            case 8:
                                cell.setCellValue(new XSSFRichTextString(finipago));
                                break;
                            case 9:
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(diasquin);
                                break;
                            case 10:
                                cell.setCellValue(new XSSFRichTextString("UNICO"));
                                break;
                            case 12:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getBanco()!=null?plz.getEmpleado().getBanco().getNombre():""));
                                break;
                            case 13:
                                cell.setCellValue(new XSSFRichTextString(ffecha.format(plz.getEmpleado().getFecha())));
                                break;
                            case 14:
                                Calendar cal1=Calendar.getInstance();
                                Calendar cal2=Calendar.getInstance();
                                cal1.setTime(plz.getEmpleado().getFecha());
                                try {
                                    Date ffpago = ffecha.parse(fpago);
                                    cal2.setTime(ffpago);
                                } catch (ParseException ex) {
                                    Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                                }
                                int anti = cal2.get(Calendar.YEAR) - cal1.get(Calendar.YEAR); 
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(anti);
                                break;
                            case 15:
                                cell.setCellValue(new XSSFRichTextString("SERVICIOS GENERALES"));
                                break;
                            case 17:
                                cell.setCellValue(new XSSFRichTextString("NORMAL"));
                                break;
                            case 18:
                                cell.setCellValue(new XSSFRichTextString(plz.getPeriodopago().getDescripcion()));
                                break;
                            case 19:
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(utmod.Redondear((percep-deduc)/diasquin,2));
                                break;
                            case 20:
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                cell.setCellValue(5);
                                break;
                            case 21:
                                cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                                double sueldodiario = utmod.Redondear(plz.getSueldo()/15,2);
                                if (plz.getPeriodopago().getDias().equals("30"))
                                    sueldodiario = utmod.Redondear(plz.getSueldo()/30,2);
                                cell.setCellValue(sueldodiario);
                                break;
                            default:
                                cell.setCellValue(new XSSFRichTextString(""));
                                break;
                        }
                    }
                    //FIN DE LLENADO DE LA HOJA CNE
                    
                    //LLENADO DE LA HOJA CNP
                    if (rowCNP.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCNP.createCell(0);                    
                    cell = rowCNP.getCell(0);
                    cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                    
                    if (rowCNP.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCNP.createCell(1);                    
                    cell = rowCNP.getCell(1);
                    cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                    cell.setCellValue(percep);
                    
                    if (rowCNP.getCell(2, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCNP.createCell(2);                    
                    cell = rowCNP.getCell(2);
                    cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                    cell.setCellValue(0);                    
                    //FIN DE LLENADO DE LA HOJA CNP
                    
                    //LLENADO DE LA HOJA NPD
                    List<DetalleNomina> perceps = dndao.obtenerPercepcionesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
                    for (int ps=0; ps < perceps.size(); ps++){
                        DetalleNomina detnom = perceps.get(ps);
                        XSSFRow rowNPD = sheetNPD.getRow(fnpd);
                        if (rowNPD==null)
                            rowNPD = sheetNPD.createRow(fnpd);

                        if (rowNPD.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNPD.createCell(0);                    
                        cell = rowNPD.getCell(0);
                        cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                        if (rowNPD.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNPD.createCell(1);                    
                        cell = rowNPD.getCell(1);
                        cell.setCellValue(new XSSFRichTextString(Integer.toString(detnom.getMovimiento().getIdPeryded())));
                        if (rowNPD.getCell(2, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNPD.createCell(2);                    
                        cell = rowNPD.getCell(2);
                        cell.setCellValue(new XSSFRichTextString(Integer.toString(detnom.getMovimiento().getIdPeryded())));
                        if (rowNPD.getCell(3, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNPD.createCell(3);                    
                        cell = rowNPD.getCell(3);
                        cell.setCellValue(new XSSFRichTextString(detnom.getMovimiento().getDescripcion()));
                        if (rowNPD.getCell(4, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNPD.createCell(4);                    
                        cell = rowNPD.getCell(4);
                        cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                        cell.setCellValue(utmod.Redondear(detnom.getMonto(),2));
                        if (rowNPD.getCell(5, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNPD.createCell(5);                    
                        cell = rowNPD.getCell(5);
                        cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                        cell.setCellValue(0);
                        
                        fnpd++;
                    }
                    //FIN DE LLENADO DE LA HOJA NPD

                    
                    //LLENADO DE LA HOJA CND
                    if (rowCND.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCND.createCell(0);                    
                    cell = rowCND.getCell(0);
                    cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                    
                    if (rowCND.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCND.createCell(1);                    
                    cell = rowCND.getCell(1);
                    cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                    cell.setCellValue(deduc);
                    
                    if (rowCND.getCell(2, Row.RETURN_NULL_AND_BLANK)==null)
                            rowCND.createCell(2);                    
                    cell = rowCND.getCell(2);
                    cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                    cell.setCellValue(0);                    
                    //FIN DE LLENADO DE LA HOJA CND
                    
                    //LLENADO DE LA HOJA NDD
                    List<DetalleNomina> deducs = dndao.obtenerDeduccionesDeNominaCotizaDePlaza(nom.getId(), plz.getId());
                    for (int ds=0; ds < deducs.size(); ds++){
                        DetalleNomina detnom = deducs.get(ds);
                        XSSFRow rowNDD = sheetNDD.getRow(fndd);
                        if (rowNDD==null)
                            rowNDD = sheetNDD.createRow(fndd);

                        if (rowNDD.getCell(0, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNDD.createCell(0);                    
                        cell = rowNDD.getCell(0);
                        cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                        if (rowNDD.getCell(1, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNDD.createCell(1);                    
                        cell = rowNDD.getCell(1);
                        cell.setCellValue(new XSSFRichTextString(Integer.toString(detnom.getMovimiento().getIdPeryded())));
                        if (rowNDD.getCell(2, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNDD.createCell(2);                    
                        cell = rowNDD.getCell(2);
                        cell.setCellValue(new XSSFRichTextString(Integer.toString(detnom.getMovimiento().getIdPeryded())));
                        if (rowNDD.getCell(3, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNDD.createCell(3);                    
                        cell = rowNDD.getCell(3);
                        cell.setCellValue(new XSSFRichTextString(detnom.getMovimiento().getDescripcion()));
                        if (rowNDD.getCell(4, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNDD.createCell(4);                    
                        cell = rowNDD.getCell(4);
                        cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                        cell.setCellValue(utmod.Redondear(detnom.getMonto(),2));
                        if (rowNDD.getCell(5, Row.RETURN_NULL_AND_BLANK)==null)
                                rowNDD.createCell(5);                    
                        cell = rowNDD.getCell(5);
                        cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                        cell.setCellValue(0);
                        
                        fndd++;
                    }
                    //FIN DE LLENADO DE LA HOJA NDD
                    cont++;
                    p++;
                } //fin recorrido de las plazas de la nomina
            
            
            //LLENADO DE LA HOJA EM
            XSSFSheet sheet = workbook.getSheetAt(2);
            XSSFRow row7 = sheet.getRow(6);
            XSSFCell cellA7 = row7.getCell(0);
            XSSFCell cellB7 = row7.getCell(1);            
            XSSFRichTextString texto = new XSSFRichTextString(suc.getDatosfis().getRfc());
            cellA7.setCellValue(texto);
            texto = new XSSFRichTextString(suc.getEmpresa().getNombre());
            cellB7.setCellValue(texto);
            //FIN LLENADO DE LA HOJA EM
            
            //LLENADO DE LA HOJA EE
            sheet = workbook.getSheetAt(3);
            row7 = sheet.getRow(6);
            XSSFCell cell = row7.getCell(0);
            cell.setCellValue(new XSSFRichTextString(suc.getDatosfis().getRfc()));
            cell = row7.getCell(1);
            cell.setCellValue(new XSSFRichTextString(suc.getDatosfis().getDireccion().getCalle()));
            cell = row7.getCell(2);
            cell.setCellValue(new XSSFRichTextString(""));
            cell = row7.getCell(3);
            cell.setCellValue(new XSSFRichTextString(""));
            cell = row7.getCell(4);
            cell.setCellValue(new XSSFRichTextString(suc.getDatosfis().getDireccion().getColonia()));
            cell = row7.getCell(5);
            cell.setCellValue(new XSSFRichTextString(suc.getDatosfis().getDireccion().getPoblacion().getMunicipio()));
            cell = row7.getCell(6);
            cell.setCellValue(new XSSFRichTextString(""));
            cell = row7.getCell(7);
            cell.setCellValue(new XSSFRichTextString(suc.getDatosfis().getDireccion().getPoblacion().getMunicipio()));
            cell = row7.getCell(8);
            cell.setCellValue(new XSSFRichTextString(suc.getDatosfis().getDireccion().getPoblacion().getEstado().getEstado()));
            cell = row7.getCell(9);
            cell.setCellValue(new XSSFRichTextString("MEXICO"));
            cell = row7.getCell(10);
            cell.setCellValue(new XSSFRichTextString(Integer.toString(suc.getDatosfis().getDireccion().getCp())));
            //FIN LLENADO DE LA HOJA EE
            
            FileOutputStream xlstim = new FileOutputStream(ruta+"\\timbradogenerado.xlsx");
            workbook.write(xlstim);
            xlstim.close();
            
            timb = new File(ruta+"\\timbradogenerado.xlsx");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException ex) {
                    Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        
        datos.put("timbrado", timb);
        return datos;
    }
    
    private HashMap GenerarArchivoTimbradoSaefa(HashMap datos) {
        File timb = null;
        
        int idsuc = Integer.parseInt(datos.get("rpsel").toString());
        SucursalDao sucDao = new SucursalDao();
        Sucursal suc = sucDao.obtener(idsuc);
        
        String plantilla = datos.get("plantilla").toString();
        String ruta = datos.get("ruta").toString();
        int anio = Integer.parseInt(datos.get("aniosel").toString());
        int quincena = Integer.parseInt(datos.get("quincenas").toString());
        QuincenaDao qudao = new QuincenaDao();
        Quincena quin = qudao.obtener(quincena);
        //obtener nomina de la quincena seleccionada
        NominaDao nomdao = new NominaDao();
        Nomina nom = nomdao.obtenerNominaNormalDeQuincenaYSucursal(quincena, anio, suc.getId());
        if (nom!=null){
        DetalleNominaDao dndao = new DetalleNominaDao();
        List<Plaza> plazas = dndao.obtenerPlazasCotizaDeNomina(nom.getId());
        UtilMod utmod = new UtilMod();
        
        String descri = "PAGO DE NOMINA DEL "+Integer.toString(quin.getInicio())+" AL "+
                Integer.toString(quin.getFin())+ " DE "+quin.getMes();
        
        //String filename = "test.xls";
        //List sheetData = new ArrayList();
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(plantilla);
            XSSFWorkbook  workbook = new XSSFWorkbook(fis);
            
                //obtener los datos
            
                //-------
                SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
                String fpago = Integer.toString(anio)+"-"+String.format("%02d", quin.getNummes())+"-"+String.format("%02d", quin.getFin());
                String finipago = Integer.toString(anio)+"-"+String.format("%02d", quin.getNummes())+"-"+String.format("%02d", quin.getInicio());
                //guardar los datos en la hoja
                XSSFSheet sheetForm = workbook.getSheetAt(1);
                int p=0;
                
                CellStyle number = workbook.createCellStyle();
                CreationHelper creationHelper = workbook.getCreationHelper();
                number.setDataFormat(creationHelper.createDataFormat().getFormat("#,##0.00"));                
                HistorialIMSSDao histdao = new HistorialIMSSDao();
                
                for (int f=2; f < (plazas.size()+2); f++){
                    int diasquin = quin.getFin()-quin.getInicio()+1;
                    Plaza plz = plazas.get(p);
                    /*double sueldodiario = utmod.Redondear(plz.getSueldo()/15,2);
                    if (plz.getPeriodopago().getDias().equals("30"))
                        sueldodiario = utmod.Redondear(plz.getSueldo()/30,2);*/
                    Date alta = plz.getEmpleado().getFecha();
                    Date finquin = null, iniquin = null;
                    try {
                        finquin = ffecha.parse(fpago);
                        iniquin = ffecha.parse(finipago);
                    } catch (ParseException ex) {
                        Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    int diasant = utmod.DiasEntreFechas(alta, finquin);
                    int aniosant = diasant / 365;
                    
                    
                    List<HistorialIMSS> histimss = histdao.obtenerHistorialDeEmpleado(plz.getEmpleado().getNumempleado());
                    HistorialIMSS hist = null;
                    String regpatronal = nom.getSucursal().getRegistropatronal();
                    if (histimss!=null && !histimss.isEmpty()){
                        hist = histimss.get(0);
                        regpatronal = hist.getRegistropatronal();
                        for (int hi=0; hi < histimss.size(); hi++){
                            hist = histimss.get(hi);
                            if (hist.getFechabaja()!=null && hist.getFechabaja().before(finquin) && hist.getFechabaja().after(iniquin)){
                                diasquin = utmod.DiasEntreFechas(iniquin, hist.getFechabaja())+1;
                                break;
                            }
                        }
                    }
                    
                    double sbc = hist!=null?hist.getSalariobase():77.0f;
                    double sdi = utmod.Redondear(sbc/1.0452,2);
                    double sq = utmod.Redondear(sdi*diasquin,2);
                    double premiopun = utmod.Redondear(sq*0.1,2);
                    double premioasis = utmod.Redondear(sq*0.1,2);
                    double cuotaimss = sbc*0.02375*diasquin;
                    double basegrav = sq+premiopun+premioasis;
                    
                    //determinar tarifa de impuesto quincenal
                    double cuotafija = 0.0f;
                    double porctarifa = 0.0192f;
                    double liminf = 0.01f;
                    if (basegrav>=244.81f && basegrav<=2077.5f){
                        cuotafija = 4.65f;
                        porctarifa = 0.064f;
                        liminf = 244.81f;
                    } else if (basegrav>=2077.51f && basegrav<=3651.0f) {
                        cuotafija = 121.95f;
                        porctarifa = 0.1088f;
                        liminf = 2077.51f;
                    } else if (basegrav>=3651.01f && basegrav<=4244.1f) {
                        cuotafija = 293.25f;
                        porctarifa = 0.16f;
                        liminf = 3651.01f;
                    } else if (basegrav>=4244.11f && basegrav<=5081.4f) {
                        cuotafija = 388.05f;
                        porctarifa = 0.1792f;
                        liminf = 4244.11f;
                    } else if (basegrav>=5081.41f && basegrav<=10248.45f) {
                        cuotafija = 538.2f;
                        porctarifa = 0.2136f;
                        liminf = 5081.41f;
                    } else if (basegrav>=10248.46f && basegrav<=16153.05f) {
                        cuotafija = 1641.75f;
                        porctarifa = 0.2352f;
                        liminf = 10248.46f;
                    } else if (basegrav>=16153.06f) {
                        cuotafija = 3030.6f;
                        porctarifa = 0.30f;
                        liminf = 16153.06f;
                    }
                    double impmarginal = ((basegrav-liminf)*porctarifa)+cuotafija;
                    
                    //calcular el valor del subsidio segun base gravable
                    double valorsubsidio = 200.85f;
                    if (basegrav>=872.86f && basegrav<=1309.2f){
                        valorsubsidio = 200.7f;
                    } else if (basegrav>=1309.21f && basegrav<=1713.6f) {
                        valorsubsidio = 200.7f;
                    } else if (basegrav>=1713.61f && basegrav<=1745.7f) {
                        valorsubsidio = 193.8f;
                    } else if (basegrav>=1745.71f && basegrav<=2193.75f) {
                        valorsubsidio = 188.70f;
                    } else if (basegrav>=2193.76f && basegrav<=2327.55f) {
                        valorsubsidio = 174.75f;
                    } else if (basegrav>=2327.56f && basegrav<=2632.65f) {
                        valorsubsidio = 160.35f;
                    } else if (basegrav>=2632.66f && basegrav<=3071.40f) {
                        valorsubsidio = 145.35f;
                    } else if (basegrav>=3071.41f && basegrav<=3510.15f) {
                        valorsubsidio = 125.10f;
                    } else if (basegrav>=3510.16f && basegrav<=3642.60f) {
                        valorsubsidio = 107.40f;
                    } else if (basegrav>=3642.61f) {
                        valorsubsidio = 0.0f;
                    }
                    
                    double subsidio = utmod.Redondear(Math.abs(impmarginal-valorsubsidio),2);
                    
                    XSSFRow row = sheetForm.getRow(f);
                    if (row==null)
                        row = sheetForm.createRow(f);
                    //float factor = f/100.00f;
                    /*double percep = utmod.Redondear(dndao.obtenerTotalPercepcionesDePlazaEnNomina(plz.getId(), nom.getId()),2);// 1000.00f*(1+factor);
                    double deduc = utmod.Redondear(dndao.obtenerTotalDeduccionesDePlazaEnNomina(plz.getId(), nom.getId()),2);*/
                    //se recorren las celdas
                    for (int i=0; i < 272; i++){
                        
                        //LLENADO DE LA HOJA form
                        if (row.getCell(i, Row.RETURN_NULL_AND_BLANK)==null)
                            row.createCell(i);
                        
                        XSSFCell cell = row.getCell(i);                        
                        switch (i){
                            case 0: //rfc
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                                break;
                            case 1:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getNombreCompletoPorApellidos()));
                                break;
                            case 2:
                                cell.setCellValue(new XSSFRichTextString(regpatronal));
                                break;
                            case 3:
                                cell.setCellValue(plz.getEmpleado().getNumempleado());
                                //cell.setCellValue(new XSSFRichTextString(Integer.toString(plz.getEmpleado().getNumempleado())));
                                break;
                            case 4:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getCurp()));
                                break;
                            case 5://
                                cell.setCellValue(new XSSFRichTextString("2 - Sueldos y salarios"));
                                break;
                            case 6:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getNss()));
                                break;
                            case 7:
                                cell.setCellValue(new XSSFRichTextString(fpago));
                                break;
                            case 8:
                                cell.setCellValue(new XSSFRichTextString(finipago));
                                break;
                            case 9:
                                cell.setCellValue(new XSSFRichTextString(fpago));
                                break;
                            case 10:
                                cell.setCellValue(diasquin);
                                //cell.setCellValue(new XSSFRichTextString(Integer.toString(diasquin)));
                                break;
                            case 11:
                                cell.setCellValue(new XSSFRichTextString("ADMINISTRATIVO"));
                                break;
                            case 14:
                                cell.setCellValue(new XSSFRichTextString(ffecha.format(plz.getEmpleado().getFecha())));
                                break;
                            case 15:
                                cell.setCellValue(aniosant);
                                //cell.setCellValue(new XSSFRichTextString(Integer.toString(aniosant)));
                                break;
                            case 16:
                                cell.setCellValue(new XSSFRichTextString("ADMINISTRATIVO"));
                                break;
                            case 17:
                                cell.setCellValue(new XSSFRichTextString("TIEMPO INDETERMINADO"));
                                break;
                            case 18:
                                cell.setCellValue(new XSSFRichTextString("DIURNA"));
                                break;
                            case 19:
                                cell.setCellValue(new XSSFRichTextString(plz.getPeriodopago().getDescripcion()));
                                break;
                            case 20:
                                cell.setCellStyle(number);
                                cell.setCellValue(sbc);
                                //cell.setCellValue(new XSSFRichTextString(Double.toString(sbc)));
                                break;
                            case 21:
                                cell.setCellValue(new XSSFRichTextString("4 - Clase IV"));
                                break;
                            case 22:
                                cell.setCellStyle(number);
                                cell.setCellValue(sdi);
                                break;
                            case 23:
                                cell.setCellValue(new XSSFRichTextString("1.0"));
                                break;
                            case 24:
                                cell.setCellValue(new XSSFRichTextString("MXN"));
                                break;
                            case 25:
                                cell.setCellValue(new XSSFRichTextString("EFECTIVO"));
                                break;
                            case 26:
                                cell.setCellValue(new XSSFRichTextString("OAXACA, OAXACA"));
                                break;
                            case 27:
                                cell.setCellValue(new XSSFRichTextString(descri));
                                break;
                            case 32:
                                cell.setCellValue(new XSSFRichTextString("001"));
                                break;
                            case 33:
                                cell.setCellValue(new XSSFRichTextString("SUELDO Y SALARIOS"));
                                break;
                            case 34:
                                cell.setCellStyle(number);
                                cell.setCellValue(sq);
                                break;
                            case 35:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 60:
                                cell.setCellValue(new XSSFRichTextString("010"));
                                break;
                            case 61:
                                cell.setCellValue(new XSSFRichTextString("PREMIOS POR PUNTUALIDAD"));
                                break;
                            case 62:
                                cell.setCellStyle(number);
                                cell.setCellValue(premiopun);
                                break;
                            case 63:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 84:
                                cell.setCellValue(new XSSFRichTextString("016"));
                                break;
                            case 85:
                                cell.setCellValue(new XSSFRichTextString("PREMIOS POR ASISTENCIA"));
                                break;
                            case 86:
                                cell.setCellStyle(number);
                                cell.setCellValue(premioasis);
                                break;
                            case 87:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 88:
                                cell.setCellValue(new XSSFRichTextString("017"));
                                break;
                            case 89:
                                cell.setCellValue(new XSSFRichTextString("SUBSIDIO PARA EL EMPLEO"));
                                break;
                            case 90:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 91:
                                cell.setCellStyle(number);
                                cell.setCellValue(subsidio);
                                break;
                            case 268:
                                cell.setCellValue(new XSSFRichTextString("021"));
                                break;
                            case 269:
                                cell.setCellValue(new XSSFRichTextString("CUOTAS IMSS"));
                                break;
                            case 270:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 271:
                                cell.setCellStyle(number);
                                cell.setCellValue(cuotaimss);
                                break;
                            default:
                                cell.setCellValue(new XSSFRichTextString(""));
                                break;
                        }
                        //FIN DE LLENADO DE LA HOJA DC
                    } //fin recorrido de columnas de hoja DC
                    
                    p++;
                }
            
            String squincena = nom.getQuincena().getMes()+Integer.toString(nom.getQuincena().getNumero())+"-"+Integer.toString(nom.getAnio());
            FileOutputStream xlstim = new FileOutputStream(ruta+"\\timbrado-"+squincena+".xlsx");
            workbook.write(xlstim);
            xlstim.close();
            
            timb = new File(ruta+"\\timbrado-"+squincena+".xlsx");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException ex) {
                    Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        } else {
            FileInputStream fis = null;
            try {
                fis = new FileInputStream(plantilla);
                XSSFWorkbook  workbook = new XSSFWorkbook(fis);
                String squincena = "NO GENERADO";
                FileOutputStream xlstim = new FileOutputStream(ruta+"\\timbrado-"+squincena+".xlsx");
                workbook.write(xlstim);
                xlstim.close();
                timb = new File(ruta+"\\timbrado-"+squincena+".xlsx");
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (fis != null) {
                    try {
                        fis.close();
                    } catch (IOException ex) {
                        Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        }
        
        datos.put("timbrado", timb);
        return datos;
    }

    private HashMap GeneraTimbradoAguinaldos(HashMap datos) {
		//cambio de prueba para git
        File timb = null;
        
        int idsuc = Integer.parseInt(datos.get("rpsel").toString());
        SucursalDao sucDao = new SucursalDao();
        Sucursal suc = sucDao.obtener(idsuc);
        
        String plantilla = datos.get("plantilla").toString();
        String ruta = datos.get("ruta").toString();
        int anio = Integer.parseInt(datos.get("aniosel").toString());
        //obtener nomina de aguinaldos del año seleccionado
        NominaDao nomdao = new NominaDao();
        Nomina nom = nomdao.obtenerNominaAguinaldoDeSucursalYAnio(suc.getId(), anio);
        
        DetalleNominaDao dndao = new DetalleNominaDao();
        List<DetalleNomina> detalles = dndao.obtenerDetallesDeNomina(nom.getId());
        UtilMod utmod = new UtilMod();
        
        String descri = "PAGO DE AGUINALDO DEL AÑO "+Integer.toString(anio);
        String regpatronal = nom.getSucursal().getRegistropatronal();
        
        FileInputStream fis = null;
        try {
            fis = new FileInputStream(plantilla);
            XSSFWorkbook  workbook = new XSSFWorkbook(fis);

            SimpleDateFormat ffecha = new SimpleDateFormat("yyyy-MM-dd");
                String fpago = Integer.toString(anio)+"-12-20";
                String finipago = Integer.toString(anio)+"-01-01";
                //guardar los datos en la hoja
                XSSFSheet sheetForm = workbook.getSheetAt(1);
                int p=0;
                
                CellStyle number = workbook.createCellStyle();
                CreationHelper creationHelper = workbook.getCreationHelper();
                number.setDataFormat(creationHelper.createDataFormat().getFormat("#,##0.00"));                
                
                AguinaldoDao agdao = new AguinaldoDao();
                
                for (int f=2; f < (detalles.size()+2); f++){
                    DetalleNomina det = detalles.get(p);
                    Plaza plz = det.getPlaza();
                    Date alta = plz.getEmpleado().getFecha();
                    Date finquin = null, iniquin = null;
                    try {
                        finquin = ffecha.parse(fpago);
                        iniquin = ffecha.parse(finipago);
                    } catch (ParseException ex) {
                        Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    int diasant = utmod.DiasEntreFechas(alta, finquin);
                    int aniosant = diasant / 365;
                    
                    Aguinaldo agui = agdao.obtenerAguinaldoDeEmpleadoEnElAnio(plz.getEmpleado().getNumempleado(), anio);
                    
                    XSSFRow row = sheetForm.getRow(f);
                    if (row==null)
                        row = sheetForm.createRow(f);
                    for (int i=0; i < 272; i++){
                        
                        //LLENADO DE LA HOJA form
                        if (row.getCell(i, Row.RETURN_NULL_AND_BLANK)==null)
                            row.createCell(i);
                        
                        XSSFCell cell = row.getCell(i);                        
                        switch (i){
                            case 0: //rfc
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getRfc()));
                                break;
                            case 1:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getNombreCompletoPorApellidos()));
                                break;
                            case 2:
                                cell.setCellValue(new XSSFRichTextString(regpatronal));
                                break;
                            case 3:
                                cell.setCellValue(plz.getEmpleado().getNumempleado());
                                break;
                            case 4:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getPersona().getCurp()));
                                break;
                            case 5://
                                cell.setCellValue(new XSSFRichTextString("2 - Sueldos y salarios"));
                                break;
                            case 6:
                                cell.setCellValue(new XSSFRichTextString(plz.getEmpleado().getNss()));
                                break;
                            case 7:
                                cell.setCellValue(new XSSFRichTextString(fpago));
                                break;
                            case 8:
                                cell.setCellValue(new XSSFRichTextString(finipago));
                                break;
                            case 9:
                                cell.setCellValue(new XSSFRichTextString(fpago));
                                break;
                            case 10:
                                cell.setCellValue(agui.getDiasaguinaldo());
                                //cell.setCellValue(new XSSFRichTextString(Integer.toString(diasquin)));
                                break;
                            case 11:
                                cell.setCellValue(new XSSFRichTextString("ADMINISTRATIVO"));
                                break;
                            case 14:
                                cell.setCellValue(new XSSFRichTextString(ffecha.format(plz.getEmpleado().getFecha())));
                                break;
                            case 15:
                                cell.setCellValue(aniosant);
                                break;
                            case 16:
                                cell.setCellValue(new XSSFRichTextString("ADMINISTRATIVO"));
                                break;
                            case 17:
                                cell.setCellValue(new XSSFRichTextString("TIEMPO INDETERMINADO"));
                                break;
                            case 18:
                                cell.setCellValue(new XSSFRichTextString("DIURNA"));
                                break;
                            case 19:
                                cell.setCellValue(new XSSFRichTextString("ANUAL"));
                                break;
                            /*case 20:
                                cell.setCellStyle(number);
                                cell.setCellValue(sbc);
                                //cell.setCellValue(new XSSFRichTextString(Double.toString(sbc)));
                                break;
                            case 21:
                                cell.setCellValue(new XSSFRichTextString("4 - Clase IV"));
                                break;
                            case 22:
                                cell.setCellStyle(number);
                                cell.setCellValue(sdi);
                                break;
                            case 23:
                                cell.setCellValue(new XSSFRichTextString("1.0"));
                                break;
                            case 24:
                                cell.setCellValue(new XSSFRichTextString("MXN"));
                                break;
                            case 25:
                                cell.setCellValue(new XSSFRichTextString("EFECTIVO"));
                                break;
                            case 26:
                                cell.setCellValue(new XSSFRichTextString("OAXACA, OAXACA"));
                                break;
                            case 27:
                                cell.setCellValue(new XSSFRichTextString(descri));
                                break;
                            case 32:
                                cell.setCellValue(new XSSFRichTextString("001"));
                                break;
                            case 33:
                                cell.setCellValue(new XSSFRichTextString("SUELDO Y SALARIOS"));
                                break;
                            case 34:
                                cell.setCellStyle(number);
                                cell.setCellValue(sq);
                                break;
                            case 35:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 60:
                                cell.setCellValue(new XSSFRichTextString("010"));
                                break;
                            case 61:
                                cell.setCellValue(new XSSFRichTextString("PREMIOS POR PUNTUALIDAD"));
                                break;
                            case 62:
                                cell.setCellStyle(number);
                                cell.setCellValue(premiopun);
                                break;
                            case 63:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 84:
                                cell.setCellValue(new XSSFRichTextString("016"));
                                break;
                            case 85:
                                cell.setCellValue(new XSSFRichTextString("PREMIOS POR ASISTENCIA"));
                                break;
                            case 86:
                                cell.setCellStyle(number);
                                cell.setCellValue(premioasis);
                                break;
                            case 87:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 88:
                                cell.setCellValue(new XSSFRichTextString("017"));
                                break;
                            case 89:
                                cell.setCellValue(new XSSFRichTextString("SUBSIDIO PARA EL EMPLEO"));
                                break;
                            case 90:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 91:
                                cell.setCellStyle(number);
                                cell.setCellValue(subsidio);
                                break;
                            case 268:
                                cell.setCellValue(new XSSFRichTextString("021"));
                                break;
                            case 269:
                                cell.setCellValue(new XSSFRichTextString("CUOTAS IMSS"));
                                break;
                            case 270:
                                cell.setCellValue(new XSSFRichTextString("0"));
                                break;
                            case 271:
                                cell.setCellStyle(number);
                                cell.setCellValue(cuotaimss);
                                break;*/
                            default:
                                cell.setCellValue(new XSSFRichTextString(""));
                                break;
                        }
                        //FIN DE LLENADO DE LA HOJA DC
                    } //fin recorrido de columnas de hoja DC
                    
                    p++;
                }
            
            String squincena = nom.getQuincena().getMes()+Integer.toString(nom.getQuincena().getNumero())+"-"+Integer.toString(nom.getAnio());
            FileOutputStream xlstim = new FileOutputStream(ruta+"\\timbrado-"+squincena+".xlsx");
            workbook.write(xlstim);
            xlstim.close();
            
            timb = new File(ruta+"\\timbrado-"+squincena+".xlsx");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException ex) {
                    Logger.getLogger(TimbradoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        
        datos.put("timbrado", timb);
                
                
                
                
        return datos;
    }
    
}
