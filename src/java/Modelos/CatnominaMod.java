/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

/**
 *
 * @author roman
 */
import Generales.Sesion;
import java.util.HashMap;
import Modelo.Entidades.Catalogos.PerPagos;
import Modelo.Entidades.Catalogos.Puestos;
import Modelo.Entidades.Catalogos.TipoNomina;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.TipoIncidencia;
import Modelo.Daos.Catalogos.CatNominaDao;
import Modelo.Daos.Catalogos.TipoCambioPyDDao;

public class CatnominaMod {
    
    public CatnominaMod(){
        
    }
    
    public Sesion GestionarCatalogos(Sesion sesion){
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        
        switch (paso){
                case 0: CatNominaDao catDao = new CatNominaDao();
                        datos.put("lista", catDao.obtenerListaPerPagos());                                                
                        datos.put("listapuesto", catDao.obtenerListaPuestos());
                        datos.put("listaperyded", catDao.obtenerListaPeryDed());
                        datos.put("listatipoinc", catDao.obtenerListaTipoIncidencia());
                        datos.put("listatiponom", catDao.obtenerListaTipoNomina());
                break;
                case 1: // CARGAR DATOS PARA NUEVO PAGO
                    //datos = CargaDatosNuvEmp(datos);                                        
                    datos = CargaDatosNuvPago(datos);                    
                break;
                case 2: // GuardarDatos   nuevo pago                                                          
                    PerPagos pPagoLoad = (PerPagos) datos.get("nuevoPagos");
                    CatNominaDao pPagoSave = new CatNominaDao();
                    pPagoSave.guardarPerPago(pPagoLoad);
                    //                    
                    datos.remove("nuevoPagos");
                    CatNominaDao catDaopN = new CatNominaDao();
                    datos.put("lista", catDaopN.obtenerListaPerPagos());                                                

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron guardados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/PeriodosPago/periodospago.jsp");
                break;
                case 3: // CARGAR DATOS PAGO EDITADO
                    PerPagos pPagoEditar = (PerPagos) datos.get("editarPagos");
                    CatNominaDao pPagoSaveEd = new CatNominaDao();
                    pPagoSaveEd.actualizarPerPago(pPagoEditar);
                    //                    
                    datos.remove("editarPagos");
                    CatNominaDao catDaopE = new CatNominaDao();
                    datos.put("lista", catDaopE.obtenerListaPerPagos());

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/PeriodosPago/periodospago.jsp");
                break;
                case 4: // CARGAR DATOS PARA EDITAR PAGO
                    datos = CargaDatosNuvPago(datos);                    
                    datos = CargarPagoAEditar(datos);
                break;
                case 5: //Baja PAGOS
                    PerPagos pagoBaja = (PerPagos) datos.get("bajaPagos");
                    CatNominaDao pagobajaDao = new CatNominaDao();
                    pagobajaDao.actualizarEstatusPerPago(0, pagoBaja.getIdPerPagos());

                    datos.remove("bajaPagos");
                    CatNominaDao catDaopB = new CatNominaDao();
                    datos.put("lista", catDaopB.obtenerListaPerPagos());

                    sesion.setExito(true);                    
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/PeriodosPago/periodospago.jsp");
                break;
                case 7: // CARGAR DATOS PARA NUEVO PUESTO                    
                    datos = CargaDatosNuvPuesto(datos);    
                    break;
                case 8: // GuardarDatos   nuevo puesto                                                          
                    Puestos pPuestoLoad = (Puestos) datos.get("nuevoPuesto");
                    CatNominaDao pPuestoSave = new CatNominaDao();
                    pPuestoSave.guardarPuesto(pPuestoLoad);//.guardarPerPago(pPagoLoad);
                    //                    
                    datos.remove("nuevoPuesto");
                    CatNominaDao catDaopuesto = new CatNominaDao();
                    datos.put("listapuesto", catDaopuesto.obtenerListaPuestos());                                                

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron guardados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/Puestos/puestos.jsp");
                break;
                case 9: // guarda DATOS Puesto EDITADO
                    Puestos puestoEditar = (Puestos) datos.get("editarPuesto");
                    CatNominaDao puestoSaveEd = new CatNominaDao();
                    puestoSaveEd.actualizarPuesto(puestoEditar);
                    //                    
                    datos.remove("editarPuesto");
                    CatNominaDao catDaopuestoEd = new CatNominaDao();
                    datos.put("listapuesto", catDaopuestoEd.obtenerListaPuestos());

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/Puestos/puestos.jsp");
                    break;    
                case 10: // CARGAR DATOS PARA EDITAR PUESTO
                    datos = CargaDatosNuvPuesto(datos);                    
                    datos = CargarPuestoAEditar(datos);
                break;
                case 11: //Baja Puesto
                    Puestos puestoBaja = (Puestos) datos.get("bajaPuesto");
                    CatNominaDao puestobajaDao = new CatNominaDao();
                    puestobajaDao.actualizarEstatusPuesto(0, puestoBaja.getIdPuestos());

                    datos.remove("bajaPuesto");
                    CatNominaDao catDaopuestoB = new CatNominaDao();
                    datos.put("listapuesto", catDaopuestoB.obtenerListaPuestos());

                    sesion.setExito(true);                    
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/Puestos/puestos.jsp");
                break;
                case 13: // CARGAR DATOS PARA NUEVO PUESTO                    
                    datos = CargaDatosNuvTnomina(datos);    
                    break;
                case 14: // GuardarDatos   nuevo puesto                                                          
                    TipoNomina tNominaLoad = (TipoNomina) datos.get("nuevoTnomina");
                    CatNominaDao tNominaSave = new CatNominaDao();
                    tNominaSave.guardarTnomina(tNominaLoad);//.guardarPuesto(tNominaLoad);
                    //                    
                    datos.remove("nuevoTnomina");
                    CatNominaDao catDaoTnomina = new CatNominaDao();
                    //datos.put("listapuesto", catDaoTnomina.obtenerListaPuestos());                                                
                    datos.put("listatiponom", catDaoTnomina.obtenerListaTipoNomina());

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron guardados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/TiposNomina/tiponomina.jsp");
                    break;
                case 15: // guarda DATOS Puesto EDITADO
                    TipoNomina tNominaEditar = (TipoNomina) datos.get("editarTnomina");
                    CatNominaDao tNominaSaveEd = new CatNominaDao();
                    tNominaSaveEd.actualizarTnomina(tNominaEditar);
                    //                    
                    datos.remove("editarTnomina");
                    CatNominaDao catDaoTnominaEd = new CatNominaDao();
                    datos.put("listatiponom", catDaoTnominaEd.obtenerListaTipoNomina());                    

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/TiposNomina/tiponomina.jsp");
                    break;    
               case 16: // CARGAR DATOS PARA EDITAR PUESTO
                    datos = CargaDatosNuvTnomina(datos);                    
                    datos = CargarTnominaAEditar(datos);
                    break;
               case 17: // baja tipo de nomina
                    TipoNomina tNominaBaja = (TipoNomina) datos.get("bajaTnomina");
                    CatNominaDao tNominaSaveBa = new CatNominaDao();
                    tNominaSaveBa.actualizarEstatusTnomina(0, tNominaBaja.getIdTnomina());
                    //tNominaSaveBa.actualizarTnomina(tNominaBaja);
                    //                    
                    datos.remove("bajaTnomina");
                    CatNominaDao catDaoTnominaB = new CatNominaDao();
                    datos.put("listatiponom", catDaoTnominaB.obtenerListaTipoNomina());                    

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/TiposNomina/tiponomina.jsp");
                    break;    
                case 19: // CARGAR DATOS PARA NUEVO PERYDED
                    datos = CargaDatosNuvPeryDed(datos);    
                    break; 
                case 20: // guarda DATOS PARA NUEVO PERYDED
                     PeryDed PeryDedLoad = (PeryDed) datos.get("nuevoPeryDed");
                    CatNominaDao PeryDedSave = new CatNominaDao();
                    PeryDedSave.guardarPeryDed(PeryDedLoad);//.guardarPuesto(tNominaLoad);
                    //                    
                    datos.remove("nuevoPeryDed");
                    CatNominaDao catDaoPeryDed = new CatNominaDao();
                    datos.put("listaperyded", catDaoPeryDed.obtenerListaPeryDed());
                    //datos.put("listatiponom", catDaoPeryDed.obtenerListaTipoNomina());

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron guardados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp");
                    break;
              case 21: // guarda DATOS PARA PERYDED editado
                     PeryDed PeryDedLoadEd = (PeryDed) datos.get("editarPeryDed");
                    CatNominaDao PeryDedSaveEd = new CatNominaDao();
                    PeryDedSaveEd.actualizarPeryDed(PeryDedLoadEd);//.guardarPeryDed(PeryDedLoadEd);
                    //                    
                    datos.remove("editarPeryDed");
                    CatNominaDao catDaoPeryDedEd = new CatNominaDao();
                    datos.put("listaperyded", catDaoPeryDedEd.obtenerListaPeryDed());
                    //datos.put("listatiponom", catDaoPeryDed.obtenerListaTipoNomina());

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp");
                    break;
                case 22: // CARGAR DATOS PARA EDITAR PERYDED
                    datos = CargaDatosNuvPeryDed(datos);                    
                    datos = CargarPeryDedAEditar(datos);
                    break;
                case 23: // dar de baja  PERYDED 
                     PeryDed PeryDedLoadB = (PeryDed) datos.get("bajaPeryDed");
                    CatNominaDao PeryDedSaveB = new CatNominaDao();
                    PeryDedSaveB.actualizarEstatusPeryDed(0, PeryDedLoadB.getIdPeryded());//actualizarEstatusTnomina(0, tNominaBaja.getIdTnomina());//.actualizarPeryDed(PeryDedLoadEd);
                    //                    
                    datos.remove("editarPeryDed");
                    CatNominaDao catDaoPeryDedB = new CatNominaDao();
                    datos.put("listaperyded", catDaoPeryDedB.obtenerListaPeryDed());
                    //datos.put("listatiponom", catDaoPeryDed.obtenerListaTipoNomina());

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/PercepcionesyDeducciones/peryded.jsp");
                    break;
                case 25: // CARGAR DATOS PARA NUEVO TINCIDENC
                    datos = CargaDatosNuvTincidencia(datos);    
                    break; 
                case 26: // guarda DATOS PARA NUEVO TINCIDENC
                    TipoIncidencia tincLoad = (TipoIncidencia) datos.get("nuevoTincidencia");
                    CatNominaDao tincSave = new CatNominaDao();
                    tincSave.guardarTincidencia(tincLoad);//.guardarPuesto(tNominaLoad);
                    //                    
                    datos.remove("nuevoTincidencia");
                    CatNominaDao catDaoTinci = new CatNominaDao();
                    datos.put("listatipoinc", catDaoTinci.obtenerListaTipoIncidencia());
                    

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron guardados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/tipoincidencia.jsp");
                    break;
                case 27: // guarda DATOS PARA NUEVO TINCIDENC
                    TipoIncidencia tincLoadEd = (TipoIncidencia) datos.get("editarTincidencia");
                    CatNominaDao tincSaveEd = new CatNominaDao();
                    tincSaveEd.actualizarTincidencia(tincLoadEd);
                    //tincSave.guardarTincidencia(tincLoad);//.guardarPuesto(tNominaLoad);                    
                    datos.remove("editarTincidencia");
                    CatNominaDao catDaoTinciEd = new CatNominaDao();
                    datos.put("listatipoinc", catDaoTinciEd.obtenerListaTipoIncidencia());
                    

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/tipoincidencia.jsp");
                    break;
                case 28: // CARGAR DATOS PARA EDITAR TINCIDENCIA
                    datos = CargaDatosNuvTincidencia(datos);    
                    datos = CargarTincidenciaAEditar(datos);
                    break;                    
                case 29: // baja PARA NUEVO TINCIDENC
                    TipoIncidencia tincLoadB = (TipoIncidencia) datos.get("bajaTincidencia");
                    CatNominaDao tincSaveB = new CatNominaDao();
                    //tincSaveB.actualizarTincidencia(tincLoadB);
                    tincSaveB.actualizarEstatusTincidenia(0, tincLoadB.getIdTipoincidencia());
                    
                    datos.remove("bajaTincidencia");
                    CatNominaDao catDaoTinciB = new CatNominaDao();
                    datos.put("listatipoinc", catDaoTinciB.obtenerListaTipoIncidencia());
                    

                    sesion.setExito(true);
                    sesion.setMensaje("Los datos fueron actualizados con éxito");
                    sesion.setPaginaSiguiente("/Nomina/Catalogos/GestionarCatalogos/TiposIncidencias/tipoincidencia.jsp");
                    break;
                case 40:
                    //ir a tipos de cambios
                    datos = CargarPeryDed(datos);
                    break;
                case 94:
                    //cancelar nuevo tipoincidencia
                    datos.remove("accion");
                    datos.remove("nuevoTincidencia");
                    datos.remove("editarTincidencia");
                    break;
                case 95:
                    //cancelar nuevo peryded
                    datos.remove("accion");
                    datos.remove("nuevoPeryDed");
                    datos.remove("editarPeryDed");
                    break;
               case 96:
                    //cancelar nuevo tnomina
                    datos.remove("accion");
                    datos.remove("nuevoTnomina");
                    datos.remove("editarTnomina");
                    break;
                case 97:
                    //cancelar nuevo puesto
                    datos.remove("accion");
                    datos.remove("nuevoPuesto");
                    datos.remove("editarPuesto");
                    break;
                case 98:
                    //cancelar nuevo perpago
                    datos.remove("accion");
                    datos.remove("nuevoPagos");
                    datos.remove("editarPagos");
                break;
                case 99:
                    datos = new HashMap();
                break;
        }    
        //
        sesion.setDatos(datos);        
        return sesion;
    }
    // tnomina
    private HashMap CargarTnominaAEditar(HashMap datos) {
        CatNominaDao tNominaDao = new CatNominaDao();//ClienteDao cliDao = new ClienteDao();
        TipoNomina editar = (TipoNomina) datos.get("editarTnomina");//Cliente editar = (Cliente) datos.get("editarCliente");        
        datos.put("editarTnomina", tNominaDao.obtenerTnomina(editar.getIdTnomina()));
        return datos;
       }
    private HashMap CargaDatosNuvTnomina(HashMap datos) 
      {
          int paso = Integer.parseInt(datos.get("paso").toString());
          datos.put("accion", "nuevo");
          if (paso == 16)
              datos.put("accion", "editar");
          
          return datos;
      }
    // puestos
    private HashMap CargaDatosNuvPuesto(HashMap datos) 
      {
          int paso = Integer.parseInt(datos.get("paso").toString());
          datos.put("accion", "nuevo");
          if (paso == 10)
              datos.put("accion", "editar");
          
          return datos;
      }      
    private HashMap CargarPuestoAEditar(HashMap datos) {
        CatNominaDao puestoDao = new CatNominaDao();//ClienteDao cliDao = new ClienteDao();
        Puestos editar = (Puestos) datos.get("editarPuesto");//Cliente editar = (Cliente) datos.get("editarCliente");        
        datos.put("editarPuesto", puestoDao.obtenerPuesto(editar.getIdPuestos()));
        return datos;
       }
     // per pagos
    private HashMap CargaDatosNuvPago(HashMap datos) 
      {
          int paso = Integer.parseInt(datos.get("paso").toString());
          datos.put("accion", "nuevo");
          if (paso == 4)
              datos.put("accion", "editar");
          //obtener lista de Edo. Civil                    
          return datos;
      }
      private HashMap CargarPagoAEditar(HashMap datos) {
        CatNominaDao pagosDao = new CatNominaDao();//ClienteDao cliDao = new ClienteDao();
        PerPagos editar = (PerPagos) datos.get("editarPagos");//Cliente editar = (Cliente) datos.get("editarCliente");        
        datos.put("editarPagos", pagosDao.obtenerPerPago(editar.getIdPerPagos()));
        return datos;
       }
      // peryded
      private HashMap CargaDatosNuvPeryDed(HashMap datos) 
      {
          int paso = Integer.parseInt(datos.get("paso").toString());
          datos.put("accion", "nuevo");
          if (paso == 22)
              datos.put("accion", "editar");
          
          return datos;
      }
    private HashMap CargarPeryDedAEditar(HashMap datos) {
        CatNominaDao perydedDao = new CatNominaDao();//ClienteDao cliDao = new ClienteDao();
        PeryDed editar = (PeryDed) datos.get("editarPeryDed");//Cliente editar = (Cliente) datos.get("editarCliente");        
        datos.put("editarPeryDed", perydedDao.obtenerPeryDed(editar.getIdPeryded()));
        return datos;
       }
    //incidencias
    private HashMap CargaDatosNuvTincidencia(HashMap datos) 
      {
          int paso = Integer.parseInt(datos.get("paso").toString());
          datos.put("accion", "nuevo");
          if (paso == 28)
              datos.put("accion", "editar");
          
          return datos;
      }
    private HashMap CargarTincidenciaAEditar(HashMap datos) {
        CatNominaDao tinciDao = new CatNominaDao();//ClienteDao cliDao = new ClienteDao();
        TipoIncidencia editar = (TipoIncidencia) datos.get("editarTincidencia");//Cliente editar = (Cliente) datos.get("editarCliente");        
        datos.put("editarTincidencia", tinciDao.obtenerTincidencia(editar.getIdTipoincidencia()));
        return datos;
       }

    private HashMap CargarPeryDed(HashMap datos) {
        PeryDed pyd = (PeryDed)datos.get("perded");
        CatNominaDao catnomDao = new CatNominaDao();
        datos.put("perded", catnomDao.obtenerPeryDed(pyd.getIdPeryded()));
        TipoCambioPyDDao tcpydDao = new TipoCambioPyDDao();
        datos.put("listatcpyd", tcpydDao.obtenerListaActivos(pyd.getIdPeryded()));
        return datos;
    }
}
