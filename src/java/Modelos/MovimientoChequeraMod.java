package Modelos;

import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Entidades.Movimientos;
import Modelo.Entidades.Abono;
import Modelo.Entidades.Cargo;
import Modelo.Entidades.Chequera;
import Modelo.Entidades.Cliente;
import Modelo.Entidades.Usuario;
import Modelo.Entidades.Sucursal;
import Modelo.Entidades.Persona;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.*;

public class MovimientoChequeraMod {
  public MovimientoChequeraMod()  {    
  }
    public Sesion GestionarMovimientos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());    
        switch(paso)  {
            case 0:
                int op = Integer.parseInt(datos.get("idoperacion").toString());
                if (op==9){
                    datos.put("listadoTar", ObtenerTarjetas());
                    datos = ObtenerTotalAbonos(datos);
                    datos.put("admin", "1");
                    datos.put("listado", "1");
                } else if (op==10){
                    datos.put("usuario", sesion.getUsuario());
                    datos = ObtenerDatosRegistrarGastos(datos);
                    if (datos.get("error")==null){
                        datos.put("admin", "0");
                        if (datos.get("listado").toString().equals("1"))
                            sesion.setPaginaSiguiente("/Empresa/GestionarChequera/gestionarchequera.jsp");
                    }
                } else if (op==12){
                    datos.put("usuario", sesion.getUsuario());
                    datos = ObtenerDatosConsultarGastos(datos);
                    if (datos.get("error")==null){
                        datos.put("admin", "0");
                        if (datos.get("listado").toString().equals("1"))
                            sesion.setPaginaSiguiente("/Empresa/GestionarChequera/tarjetasdetitular.jsp");
                    }
                }
                
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Generales/IniciarSesion/bienvenida.jsp");
                    datos.remove("error");
                } else {
                    if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                        datos.put("matriz", "1");
                    else
                        datos.put("matriz", "0");

                    datos.put("empresa", Integer.toString(sesion.getUsuario().getEmpleado().getPersona().getSucursal().getEmpresa().getId()));
                    datos = ObtenerLogotipo(datos);
                }
                break;
            case 1:
                datos.put("listadoSuc", ObtenerMovSucursales());
                datos.put("listadoUsu", ObtenerUsuarios());
                datos.put("accion", "nueva");
                break;
            case 2:
                datos = NuevoDeposito(datos);
                datos.put("accion", "nuevo");
                break;
            case 3:
                datos = GuardarMovNuevo(datos);
                if (datos.get("accion").toString().equals("editar"))
                    sesion.setPaginaSiguiente("/Empresa/GestionarChequera/gestionarMovimientos.jsp");
                break;
            case 4:
                datos = GuardarChequera(datos);
                break;
            case 5:   //editar movimientos de la chequera
                datos = CargarMovimientoAEditar(datos);
                datos.put("accion", "editar");
                Movimientos mov = (Movimientos)datos.get("editarMovimiento");
                if (mov.getId_ab().getId()!=1)
                    sesion.setPaginaSiguiente("/Empresa/GestionarChequera/nuevoMovimiento.jsp");
                break;
            case 6:
                datos = GuardarCargoNuevo(datos);
                break;
            case 7:   //carga movimientos de tarjeta
                datos = ObtenerPeriodo(datos);
                datos.put("tipo", "0");
                datos = CargarMovimientos(datos);
                break;
            case 8:
                datos = CargarMovimientos(datos);
                break;
            case 9: // elimina movimiento seleccionado
                datos = EliminarMovimiento(datos);
                break;
            case 10:
                datos = ModificaMovimiento(datos);
                break;
            case 11:
                datos = EliminarCargo(datos);
                break;
            case 12:
                //datos = ObtenerMovimientos(datos);
                datos.put("accion", "nuevo");
                if (datos.get("matriz").toString().equals("1")){
                    sesion.setPaginaSiguiente("/Empresa/GestionarChequera/nuevoCargo.jsp");
                    datos.put("archivoCargo", "");
                    UtilDao utdao = new UtilDao();
                    datos.put("hoy", utdao.hoy());                    
                }
                break;
            case 13:
                if (datos.get("listado").toString().equals("0")){
                    sesion.setPaginaSiguiente("/Generales/IniciarSesion/bienvenida.jsp");
                } else {
                datos = ObtenerTotalAbonos(datos);
                }
                break;
            case 14:
                datos = EliminarAbono(datos);
                break;
            case 15:
                datos = ModificaMovimientoAbono(datos);
                break;
            case 16:
                datos = CargaFechas(datos);
                datos = CargarMovimientos(datos);
                break;
            case 17:
                datos = ImprimirReporte(datos);
                break;
            case 18:
                //editar tarjeta
                datos = ObtenerTarjeta(datos);
                break;
            case 19:
                //baja de tarjeta
                datos = BajaDeTarjeta(datos);
                break;
            case 20:
                datos = MostrarInactivas(datos);
                break;
            case 21:
                datos = ActivaTarjeta(datos);
                break;
            case 22:
                datos = ObtenerPeriodo(datos);
                datos.put("tipo", "0");
                datos = CargarMovimientos(datos);
                break;
            case 96:
                datos.put("listadoTar", ObtenerTarjetas());
                datos = ObtenerTotalAbonos(datos);
                break;
            case 97:
                datos.remove("accion");
                datos.remove("tarjetaSel");
                break;
            case 98:
                if (datos.get("accion").toString().equals("editar"))
                    sesion.setPaginaSiguiente("/Empresa/GestionarChequera/gestionarMovimientos.jsp");
                break;
            case 99:
                datos = new HashMap(datos);
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }
  
  private HashMap ModificaMovimientoAbono(HashMap datos) {
      int idMov = Integer.parseInt(datos.get("idActualiza").toString());
      int idM = Integer.parseInt(datos.get("elMovimiento").toString());
      String cF = datos.get("cFecha").toString();
      String cC = datos.get("cConcepto").toString(); 
      float cM = Float.parseFloat(datos.get("cMonto").toString());
      MovimientoChequeraDao mDao = new MovimientoChequeraDao();
      mDao.updateAbono(idMov, cM, cC);
      MovimientoChequeraDao m_Dao = new MovimientoChequeraDao();
      m_Dao.updateFecha(idM, cF);
      datos = ObtenerMovimientos(datos);
      datos = CargarMovimientos(datos);
      datos.remove("idActualiza");
      datos.remove("cFecha");
      datos.remove("cConcepto");
      datos.remove("cMonto");
      datos.remove("elMovimiento");
      return datos;
  }
  private HashMap ModificaMovimiento(HashMap datos) {
      int idMov = Integer.parseInt(datos.get("idActualiza").toString());
      int idM = Integer.parseInt(datos.get("elMovimiento").toString());
      String cF = datos.get("cFecha").toString();
      String cC = datos.get("cConcepto").toString();
      float cM = Float.parseFloat(datos.get("cMonto").toString());      
      MovimientoChequeraDao movDao = new MovimientoChequeraDao();
      movDao.updateCargo(idMov, cM, cC);      
      MovimientoChequeraDao moDao = new MovimientoChequeraDao();
      moDao.updateFecha(idM, cF);
      datos = ObtenerMovimientos(datos);
      datos = CargarMovimientos(datos);
      datos.remove("idActualiza");
      datos.remove("cFecha");
      datos.remove("cConcepto");
      datos.remove("cMonto");
      return datos;
  }
  
  private HashMap EliminarMovimiento(HashMap datos) {
      Movimientos baja = (Movimientos) datos.get("borrarMovimiento");
      //int tipo = Integer.parseInt(datos.get("tipoMovimiento").toString());
      MovimientoChequeraDao moviDao = new MovimientoChequeraDao();
      baja = moviDao.obtener(baja.getId());
      if (baja.getId_ab().getId()!=1){
          datos.put("borrarAbono", baja.getId_ab());
          EliminarAbono(datos);
      } else {
          datos.put("borrarCargo", baja.getId_ca());
          EliminarCargo(datos);
      }
      moviDao.borraMovimiento(baja.getId());      
      datos = CargarMovimientos(datos);
      datos.remove("borrarMovimiento");
      return datos;
  } 
  
  private HashMap EliminarCargo(HashMap datos)  {
      Cargo baja = (Cargo) datos.get("borrarCargo");
      CargoDao cargoDao = new CargoDao();
      cargoDao.borraCargo(baja.getId());
      datos = ObtenerTotalAbonos(datos);
      datos.remove("borrarCargo");
      return datos;
  }
  private HashMap EliminarAbono(HashMap datos)  {
    Abono abn = (Abono) datos.get("borrarAbono");
    AbonoDao abnDao = new AbonoDao();
    abnDao.borrarAbono(abn.getId());
    datos = ObtenerTotalAbonos(datos);
    datos.remove("borrarAbono");
    return datos;
  }
  private HashMap CargarMovimientoAEditar(HashMap datos)       {
      MovimientoChequeraDao moviDao = new MovimientoChequeraDao();
      Movimientos edita = (Movimientos) datos.get("editarMovimiento");
      datos.put("editarMovimiento", moviDao.obtener(edita.getId()));
      return datos;      
  }
  
  private HashMap validarChequera(HashMap datos)    {
      ChequeraDao cheDao = new ChequeraDao();
      Usuario us = (Usuario)datos.get("totalSel");
      List<Chequera> tarj = cheDao.validacion(us.getIdusuario());
      datos.put("validacionChequeras", tarj);
      List<HashMap> hashequera = new ArrayList<HashMap>();
      datos.put("hayChequera", tarj);
      return datos;
  }
  private HashMap ObtenerTotalAbonos(HashMap datos)  {
    AbonoDao abDao = new AbonoDao();
    CargoDao cardao = new CargoDao();
    //ChequeraDao cheDao = new ChequeraDao();
    List<Chequera> tarjetas = (List<Chequera>)datos.get("listadoTar");
    //datos.put("tarjetaz", tarjetas);
    List<HashMap> totales = new ArrayList<HashMap>();
    for (int i=0; i < tarjetas.size(); i++){
      Chequera che = tarjetas.get(i);
      //obtener el saldo en tarjeta
      Double totalAbono = abDao.obtenerTotalTar(che.getId());
      if(totalAbono==null) totalAbono=0.0;
      Double totalCargo = cardao.obtenerTotalCargosTar(che.getId());
      if(totalCargo==null) totalCargo=0.0;
      Double saldoTar = totalAbono-totalCargo;
      //obtener el saldo en efectivo
      totalAbono = abDao.obtenerTotalEfe(che.getId());
      if(totalAbono==null) totalAbono=0.0;
       totalCargo = cardao.obtenerTotalCargosEfe(che.getId());
      if(totalCargo==null) totalCargo=0.0;
      Double saldoEfe = totalAbono-totalCargo;
      //calculamos saldo y demas
      HashMap tots = new HashMap();
      tots.put("totsaldotar", saldoTar);
      tots.put("totsaldoefe", saldoEfe);
      //tots.put("totalsaldos", totalSaldo);
      totales.add(tots);
    }
    datos.put("totales", totales);
    return datos;
  }
  private List<Persona> ObtenerPersonas()    {
      PersonaDao perDao = new PersonaDao();
      return perDao.obtenerLista();
  }
  private List<Sucursal> ObtenerSucursales() {
      SucursalDao sucDao = new SucursalDao();
      return sucDao.obtenerLista();
  }
  private List<Usuario> ObtenerUsuarios()   {
      UsuarioDao userDao = new UsuarioDao();
      return userDao.obtenerListaActivos();
  }
  private List<Movimientos> ObtenerMovimientos() {
    MovimientoChequeraDao movDao = new MovimientoChequeraDao();
    return movDao.obtenerLista();
  }
  private List<Chequera> ObtenerTarjetas()  {
      ChequeraDao movDao = new ChequeraDao();
      return movDao.obtenerLista();
  }
  private List<Cargo> ObtenerCargos()   {
      CargoDao carDao = new CargoDao();
      return carDao.obtenerLista();
  }
  private HashMap CargarTotales(HashMap datos)  {
      Abono ab = (Abono)datos.get("totalSel");
      AbonoDao abDao = new AbonoDao();
      //datos.put("totalSel", abDao.obtenerTotal(ab.getChe())); //obtenemos el id de la chequera a sacar el total de abonos
      
      return datos;
  }
  private HashMap ObtenerMovimientos(HashMap datos) {
      MovimientoChequeraDao movDao = new MovimientoChequeraDao();
      datos.put("listaMovimientos", movDao.obtenerLista());
      return datos;
  }
  private HashMap ObtenerMovs(HashMap datos)    {
      MovimientoChequeraDao movDao = new MovimientoChequeraDao();
      datos.put("listadoMov", movDao.obtenerLista());
      return datos;
  }
  
  private HashMap CargarMovimientos(HashMap datos) {
      Chequera tarjeta = (Chequera)datos.get("tarjetaSel");
      ChequeraDao cheDao = new ChequeraDao();
      datos.put("tarjetaSel", cheDao.obtener(tarjeta.getId()) );
      MovimientoChequeraDao movDao = new MovimientoChequeraDao();
      //datos.put("listaMovimientos", movDao.obtenerMovimientosDeTarjeta(tarjeta.getId()));
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
        String fechaI = "", fechaF = "";
        fechaI = formatoDelTexto.format((Date)datos.get("fechai"));
        fechaF = formatoDelTexto.format((Date)datos.get("fechaf"));
        int tipo = Integer.parseInt(datos.get("tipo").toString());
      datos.put("listaMovimientos", movDao.obtenerMovimientosDeTarjetaDeTipoYDelPeriodo(tarjeta.getId(), tipo, fechaI, fechaF));
      datos = ObtenerSaldoAnterior(datos);
      return datos;
  }
  
  private List<Sucursal> ObtenerMovSucursales()  {
      SucursalDao sucdao = new SucursalDao();
      return sucdao.obtenerListaSucYMatriz();
    //MovimientoChequeraDao movDao = new MovimientoChequeraDao();
    //return movDao.obtenerMovimientosDeSucursal(idSucSel);
    //return null;
  }
  
  private HashMap GuardarChequera(HashMap datos) {
      Chequera nueva = (Chequera)datos.get("nuevaChequera");
      SucursalDao sucdao = new SucursalDao();
      nueva.setAlmacen(sucdao.obtener(nueva.getAlmacen().getId()));
      nueva.setEstado(nueva.getAlmacen().getDatosfis().getDireccion().getPoblacion().getEstado().getEstado());
      nueva.setEstatus(1);
      ChequeraDao cheDao = new ChequeraDao();
      if (datos.get("accion").toString().equals("nueva"))
         cheDao.guardar(nueva);
      else
         cheDao.actualizar(nueva);
      datos.remove("nuevaChequera");
      datos.remove("accion");
      datos.remove("tarjetaSel");
      datos.put("listadoTar", ObtenerTarjetas());
      datos = ObtenerTotalAbonos(datos);
      return datos;
  }

  private HashMap GuardarMovNuevo(HashMap datos) {
        Movimientos nuevo = (Movimientos)datos.get("nuevoMov");
        MovimientoChequeraDao moviDao = new MovimientoChequeraDao();
        if (datos.get("accion").toString().equals("editar")){
            moviDao.actualizar(nuevo);
            datos = CargarMovimientos(datos);
        } else {
            moviDao.guardar(nuevo);
            datos = ObtenerTotalAbonos(datos);
        }
        datos.remove("nuevoMov");        
        return datos;
  }
  
  private HashMap GuardarCargoNuevo(HashMap datos)  {
    Movimientos nuevo = (Movimientos)datos.get("nuevoCargo");
    MovimientoChequeraDao moviDao = new MovimientoChequeraDao();
    if (datos.get("accion").toString().equals("editar"))
        moviDao.actualizar(nuevo);
    else
        moviDao.guardar(nuevo);
    datos = CargarMovimientos(datos);
    /*if (datos.get("listado").toString().equals("1"))
        datos = ObtenerTotalAbonos(datos);*/
    datos.remove("nuevoCargo");
    datos.remove("accion");
    return datos;
  }

    public Sesion ConsultarGastos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());    
        switch(paso)  {
            case 0:
                datos.put("listadoTar", ObtenerTarjetas());
                break;
            case 1:
                datos = ObtenerGastosDeTarjeta(datos);
                break;
            case 98:
                datos.remove("cargos");
                datos.remove("tarjeta");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }

    private HashMap ObtenerGastosDeTarjeta(HashMap datos) {
        Chequera tar = (Chequera)datos.get("tarjeta");
        ChequeraDao chdao = new ChequeraDao();
        tar = chdao.obtener(tar.getId());
        datos.put("tarjeta", tar);
        MovimientoChequeraDao moviDao = new MovimientoChequeraDao();
        datos.put("cargos", moviDao.obtenerCargosDeTarjeta(tar.getId()));
        return datos;
    }
    
    private HashMap ObtenerPeriodo(HashMap datos) {
        UtilDao udao = new UtilDao();
        Calendar cale = Calendar.getInstance();
        cale.setTime(udao.hoy());
        Calendar feci = Calendar.getInstance();
        feci.set(cale.get(cale.YEAR), cale.get(cale.MONTH), 1);
        datos.put("fechai", feci.getTime());
        
        Calendar fecf = Calendar.getInstance();
        int mes = cale.get(cale.MONTH)+1;
        int df = 30;
        switch (mes){
            case 1: case 3: case 5: case 7: case 8: case 10: case 12: df = 31; break;
            case 2: 
                if ((cale.get(cale.YEAR) % 4 == 0) && ((cale.get(cale.YEAR) % 100 != 0) || (cale.get(cale.YEAR) % 400 == 0)))
                    df = 29;
                else
                    df = 28;
                break;
        }
        fecf.set(cale.get(cale.YEAR), cale.get(cale.MONTH), df);
        datos.put("fechaf", fecf.getTime());
        return datos;
    }

    private HashMap CargaFechas(HashMap datos) {
        String fechaini = datos.get("fechaini").toString();
        String fechafin = datos.get("fechafin").toString();
        
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("dd-MM-yyyy");
        Date fechaDI = null, fechaDF = null;
        try {
            fechaDI = formatoDelTexto.parse(fechaini);
            fechaDF = formatoDelTexto.parse(fechafin);
        } catch (ParseException ex) {
        }
        datos.put("fechai", fechaDI);
        datos.put("fechaf", fechaDF);
        
        return datos;
    }

    private HashMap NuevoDeposito(HashMap datos) {
        UtilDao utdao = new UtilDao();
        datos.put("hoy", utdao.hoy());
        return datos;
    }

    private HashMap ObtenerSaldoAnterior(HashMap datos) {
        Chequera tarjeta = (Chequera)datos.get("tarjetaSel");
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy-MM-dd");
        String fechaI = "", fechaF = "";
        fechaI = formatoDelTexto.format((Date)datos.get("fechai"));
        fechaF = formatoDelTexto.format((Date)datos.get("fechaf"));
        int tipo = Integer.parseInt(datos.get("tipo").toString());
        //obtener el saldo en tarjeta
        AbonoDao abDao = new AbonoDao();
        CargoDao cardao = new CargoDao();
        Double totalAbono = abDao.obtenerTotalDeTipoAntesDeFecha(tarjeta.getId(), tipo, fechaI);
        if(totalAbono==null) totalAbono=0.0;
        Double totalCargo = cardao.obtenerTotalDeTipoAntesDeFecha(tarjeta.getId(), tipo, fechaI);
        if(totalCargo==null) totalCargo=0.0;
        Double saldoTar = totalAbono-totalCargo;
        datos.put("saldoant", saldoTar);
        return datos;
    }

    private HashMap ObtenerDatosRegistrarGastos(HashMap datos) {
        Usuario us = (Usuario) datos.get("usuario");
        ChequeraDao chedao = new ChequeraDao();
        List<Chequera> tars = chedao.obtenerTarjetasAdministradasPorUsuario(us.getIdusuario());
        datos.put("listado", "0");
        if (tars.size()>1){
            datos.put("listadoTar", tars);
            datos = ObtenerTotalAbonos(datos);
            datos.put("listado", "1");
        } else if (tars.size()==1){
            datos.put("tarjetaSel", tars.get(0));
            datos = ObtenerPeriodo(datos);
            datos.put("tipo", "0");
            datos = CargarMovimientos(datos);            
        } else {
            //el usuario no tiene tarjetas asignadas para administrar
            datos.put("error", "Usted no tiene tarjetas asignadas para administrar");
        }
        
        return datos;
    }
    
    private HashMap ObtenerLogotipo(HashMap datos) {
        int idempr = Integer.parseInt(datos.get("empresa").toString());
        EmpresaDao empDao = new EmpresaDao();
        datos.put("logo", empDao.obtenerLogo(idempr));
        return datos;
    }
    
    private HashMap ImprimirReporte(HashMap datos) {
        UtilMod util = new UtilMod();
        datos.put("bytes", util.generarPDF(datos.get("reporte").toString(), (Map)datos.get("parametros")));
        return datos;
    }

    private HashMap ObtenerTarjeta(HashMap datos) {
        Chequera tarjeta = (Chequera)datos.get("tarjetaSel");
        ChequeraDao cheDao = new ChequeraDao();
        tarjeta = cheDao.obtener(tarjeta.getId());
        Usuario admin = tarjeta.getResponsable();
        Usuario tit = tarjeta.getUstitular();
        if (tit!=null && admin.getIdusuario()==tit.getIdusuario()){
            Usuario ntit = new Usuario();
            UsuarioDao usdao = new UsuarioDao();
            ntit = usdao.obtener(tit.getIdusuario());
            tarjeta.setUstitular(ntit);
        }
        datos.put("tarjetaSel",  tarjeta);
        datos.put("listadoSuc", ObtenerMovSucursales());
        datos.put("listadoUsu", ObtenerUsuarios());
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeTarjeta(HashMap datos) {
        Chequera tarjeta = (Chequera)datos.get("tarjetaSel");
        ChequeraDao cheDao = new ChequeraDao();
        datos.put("tarjetaSel", cheDao.obtener(tarjeta.getId()) );
        cheDao.actualizarEstatus(tarjeta.getId(), 0);
        datos.put("listadoTar", ObtenerTarjetas());
        datos = ObtenerTotalAbonos(datos);
        datos.remove("tarjetaSel");
        return datos;
    }

    private HashMap MostrarInactivas(HashMap datos) {
        ChequeraDao cheDao = new ChequeraDao();
        datos.put("listadoTar", cheDao.obtenerListaBaja());
        datos = ObtenerTotalAbonos(datos);
        return datos;
    }

    private HashMap ActivaTarjeta(HashMap datos) {
        Chequera tarjeta = (Chequera)datos.get("tarjetaSel");
        ChequeraDao cheDao = new ChequeraDao();
        datos.put("tarjetaSel", cheDao.obtener(tarjeta.getId()) );
        cheDao.actualizarEstatus(tarjeta.getId(), 1);
        datos.put("listadoTar", cheDao.obtenerListaBaja());
        datos = ObtenerTotalAbonos(datos);
        datos.remove("tarjetaSel");
        return datos;
    }

    private HashMap ObtenerDatosConsultarGastos(HashMap datos) {
        Usuario us = (Usuario) datos.get("usuario");
        ChequeraDao chedao = new ChequeraDao();
        List<Chequera> tars = chedao.obtenerTarjetasDeTitular(us.getIdusuario());
        datos.put("listado", "0");
        if (tars.size()>1){
            datos.put("listadoTar", tars);
            datos = ObtenerTotalAbonos(datos);
            datos.put("listado", "1");
        } else if (tars.size()==1){
            datos.put("tarjetaSel", tars.get(0));
            datos = ObtenerPeriodo(datos);
            datos.put("tipo", "0");
            datos = CargarMovimientos(datos);            
        } else {
            //el usuario no tiene tarjetas asignadas para administrar
            datos.put("error", "Usted no es titular de ninguna tarjeta");
        }
        
        return datos;
    }
}
