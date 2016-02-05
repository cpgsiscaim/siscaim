package Modelos;
/* @author germain */

import Generales.Sesion;
import Modelo.Daos.ChequeraDao;
import Modelo.Daos.MovimientoChequeraDao;
import Modelo.Entidades.Movimientos;
import Modelo.Entidades.Chequera;
import java.util.HashMap;
import java.util.*;

public class ChequeraMod {
  public ChequeraMod()  {    
  }
  
  public Sesion GestionarChequeras(Sesion sesion) {
    HashMap datos = sesion.getDatos();
    int paso = Integer.parseInt(datos.get("paso").toString());    
    switch (paso) {
      case 0: //carga los datos       
        datos.put("listadoTar", ObtenerChequeras()); //obtener la lista de sucursales activas        
        break;
      case 1: //Cargar chequeras de la sucursal seleccionada
        //datos = ObtenerChequeras(datos); 
        break;
      case 2: //ir a nuevo movimiento
        datos.put("accion", "nueva");
        //datos = CargarMovimientoSel(datos);
        break;
      case 3: case 5: // guarda los datos
        //datos = GuardarNuevoMovimiento(datos);
        break;
      case 66:
        System.out.println("estas entrado hasta el MOD");
        break;
    }
    sesion.setDatos(datos);
    return sesion;
  }
    private List<Chequera> ObtenerChequeras() {
      ChequeraDao tarj = new ChequeraDao();
      return tarj.obtenerLista();
    }
}
