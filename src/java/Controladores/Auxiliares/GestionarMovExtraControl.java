/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controladores.Auxiliares;

import Controlador.Maestro.Action;
import Generales.Sesion;
import Modelo.Entidades.Plaza;
import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Catalogos.TipoCambio;
import Modelo.Entidades.Catalogos.TipoNomina;
import Modelo.Entidades.MovimientoExtraordinario;
import Modelos.MovimientoExtraordinarioMod;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author TEMOC
 */
public class GestionarMovExtraControl extends Action{
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
        MovimientoExtraordinarioMod movextMod = new MovimientoExtraordinarioMod();
        sesion = movextMod.GestionarMovExtra(sesion);

        //cargar los datos en la sesion
        sesionHttp.setAttribute("sesion", sesion);
        
        //ir a la página siguiente
        RequestDispatcher rd = application.getRequestDispatcher(sesion.getPaginaSiguiente());
        /*if (sesion.getPaginaAnterior()!=null && !sesion.getPaginaAnterior().equals("")
                && paso.equals("99")){
            rd = application.getRequestDispatcher(sesion.getPaginaAnterior());
            sesion.setPaginaAnterior("");
        }*/
        if(rd == null)
            throw new ServletException ("No se pudo encontrar "+sesion.getPaginaSiguiente());
        
        rd.forward(request, response);        
    }

    @Override
    public void asignaParametros() {
        //obtener el paso del proceso
        paso = request.getParameter("pasoSig")!=null?request.getParameter("pasoSig"):"0";
        String paginaSig = "";
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
            /*case -1:
                //obtener clientes de sucursal
                Sucursal suc = new Sucursal();
                suc.setId(Integer.parseInt(request.getParameter("sucursal")));
                datos.put("sucursalSel", suc);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case -2:
                //obtener contratos de cliente
                Cliente cli = new Cliente();
                cli.setId(Integer.parseInt(request.getParameter("cliente")));
                datos.put("clienteSel", cli);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case -3:
                //obtener contratos de cliente
                Contrato con = new Contrato();
                con.setId(Integer.parseInt(request.getParameter("contrato")));
                datos.put("editarContrato", con);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;*/
            case 1:
                //obtener movs extras de plaza
                Quincena quinsel = new Quincena();
                quinsel.setId(Integer.parseInt(request.getParameter("quincena")));
                datos.put("quincenasel", quinsel);
                datos.put("aniosel", request.getParameter("anio"));
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 2: case 7: case 97: case 98: case 99:
                //ir a nuevo mov extra (2) || ir a inactivos (7) || cancelar inactivos (97) || cancelar nuevo mov extra(98) || cancelar de gestionar movs extras(99)
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 3: case 5:
                //guardar nuevo mov extra (3) | guarda mov extra editado (5)
                CargarMovExtra();
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
            case 4: case 6: case 8:
                //ir a editar mov extra (4) || baja de mov extra(6) || activar mov extra (8)
                MovimientoExtraordinario movext = new MovimientoExtraordinario();
                movext.setId(Integer.parseInt(request.getParameter("idMext")));
                datos.put("movext", movext);
                paginaSig = request.getParameter("paginaSig")!=null?request.getParameter("paginaSig"):"";
                sesion.setPaginaSiguiente(paginaSig);                
                break;
        }
        datos.put("paso", paso);
    }

    private void CargarMovExtra() {
        MovimientoExtraordinario movext = new MovimientoExtraordinario();
        movext.setPerded(new PeryDed());
        movext.setTipocambio(new TipoCambio());
        movext.setQuincena(new Quincena());
        movext.setPlaza(new Plaza());
        movext.setTiponomina(new TipoNomina());
        if (datos.get("accion").toString().equals("editar"))
            movext = (MovimientoExtraordinario)datos.get("movext");
        
        movext.getPerded().setIdPeryded(Integer.parseInt(request.getParameter("movimiento")));
        movext.getTiponomina().setIdTnomina(Integer.parseInt(request.getParameter("tiponomina")));
        movext.getTipocambio().setId(Integer.parseInt(request.getParameter("tipocambio")));
        movext.setImporte(Float.parseFloat(request.getParameter("importe")));
        movext.setNumero(Integer.parseInt(request.getParameter("quincenas")));
        movext.setTotal(Float.parseFloat(request.getParameter("total")));
        movext.setObservaciones(request.getParameter("observaciones"));
        movext.setCotiza(Integer.parseInt(request.getParameter("cotiza")));
        String fijo = request.getParameter("chkfijo");
        movext.setFijo(0);
        if (fijo!=null && fijo.equals("1"))
            movext.setFijo(1);
        String prestacion = request.getParameter("chkpresta");
        movext.setPrestacionimss(0);
        if (prestacion!=null && prestacion.equals("1"))
            movext.setPrestacionimss(1);
        datos.put("movext", movext);
    }

}
