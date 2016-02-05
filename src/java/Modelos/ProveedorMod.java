/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Configuracion.HibernateUtil;
import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Daos.Catalogos.EstadoDao;
import Modelo.Daos.Catalogos.TipoMedioDao;
import Modelo.Daos.Catalogos.TituloDao;
import Modelo.Entidades.Catalogos.TipoMedio;
import Modelo.Entidades.Cliente;
import Modelo.Entidades.ContactoProveedor;
import Modelo.Entidades.Medio;
import Modelo.Entidades.Persona;
import Modelo.Entidades.PersonaMedio;
import Modelo.Entidades.Proveedor;
import Modelo.Entidades.Proveedor;
import Modelo.Entidades.Ruta;
import Modelo.Entidades.Sucursal;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author TEMOC
 */
public class ProveedorMod {
    private int grupos = 0;
    public ProveedorMod(){
    }

    public Sesion GestionarProveedores(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 0:
                //obtener la lista de sucursales activas
                datos.put("sucursales", ObtenerSucursales());
                //cargar datos de sucursal del usuario
                datos.put("sucursalSel", sesion.getUsuario().getEmpleado().getPersona().getSucursal());
                if (sesion.getUsuario().getEmpleado().getPersona().getSucursal().getTipo()==0)
                    datos.put("matriz", "1");
                else
                    datos.put("matriz", "0");
                datos.put("paginador", "1");
                datos.put("elementos", Integer.toString(sesion.getGrupos()));
                datos = ObtenerProveedores(datos);
                break;
            case 1:
                //cargar sucursal
                datos = CargaSucursalSel(datos);
                //cargar clientes de la sucursal seleccionada
                datos = ObtenerProveedores(datos);
                break;
            case 2:
                //ir a nuevo proveedor
                datos = CargarCatalogosProveedor(datos);
                datos = ObtenerCatalogosContactos(datos);
                break;
            case 3: case 5:
                //guardar proveedor
                datos = GuardarProveedor(datos);
                break;
            case 4:
                //ir a editar proveedor
                datos = ObtenerProveedor(datos);
                datos = ObtenerContactos(datos);
                datos = ObtenerCatalogosContactos(datos);
                break;
            case 6:
                //baja del cliente
                datos = BajaDeProveedor(datos);
                break;
            case 7:
                datos = ObtenerInactivos(datos);
                break;
            case 8:
                datos = ActivarProveedor(datos);
                break;
            case 10:
                //aplicar filtros
                datos = FiltrarListado(datos);
                List<Proveedor> lista = (List<Proveedor>)datos.get("listadoFil");
                if (lista.size()>0){
                    datos.put("listado", lista);
                    datos.put("sinresultados", "0");
                    datos.put("filtro", "1");
                }
                else {
                    datos.put("sinresultados", "1");
                    sesion.setPaginaSiguiente("/Inventario/Catalogos/Proveedores/filtrarproveedores.jsp");
                    datos.remove("listadoFil");
                    datos.put("condiciones", "");
                }
                break;
            case 11:
                //quitar filtros
                datos = ObtenerProveedores(datos);
                datos.remove("listadoFil");
                datos.remove("filtro");                
                break;
            case 13:
                datos = GuardaContacto(datos);
                break;
            case 14:
                datos = EditarContacto(datos);
                break;
            case 15:
                datos = BorrarContacto(datos);
                break;
            case 16:
                //cambiar de sucursal
                datos = ObtenerProveedor(datos);
                break;
            case 17:
                datos = CambiarSucursalDeProveedor(datos);
                break;
            case 50:
                //ir al principio
                datos = CargarPrincipio(datos);
                break;
            case 51:
                //mostrar anteriores
                datos = CargarAnteriores(datos);
                break;
            case 52:
                //mostrar siguientes
                datos = CargarSiguientes(datos);
                break;
            case 53:
                //mostrar siguientes
                datos = CargarFinal(datos);
                break;
            case 94:
                datos.remove("proveedor");
                datos.remove("accion");
                datos.remove("estados");
                break;
            case 95:
                //cancelar nuevo contacto
                datos.remove("contacto");
                datos.remove("accionContacto");
                datos.put("pestaña","3");
                break;
            case 96:
                //cancelar filtrar
                datos = ObtenerProveedores(datos);
                break;
            case 97:
                //cancelar inactivos
                datos.remove("inactivos");
                break;
            case 98:
                //cancelar nuevo | editar proveedor
                datos.remove("accion");
                datos.remove("proveedor");
                datos.remove("pestaña");
                datos.remove("estados");
                datos.remove("contactos");
                datos.remove("medioscon");
                datos.remove("titulos");
                datos.remove("tiposmedios");                
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);
        return sesion;        
    }
    
    private HashMap ObtenerGrupo(HashMap datos) {
        List<Proveedor> provs = (List<Proveedor>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Proveedor> grupo = new ArrayList<Proveedor>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin >= provs.size()){
            fin = provs.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(provs.get(i));
        }
        datos.put("listado", grupo);
        return datos;
    }
    

    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }

    private HashMap CargaSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        if (sucSel.getId() != 0){
            SucursalDao sucDao = new SucursalDao();
            datos.put("sucursalSel", sucDao.obtener(sucSel.getId()));
        }
        return datos;
    }

    private HashMap ObtenerProveedores(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Proveedor> listado = new ArrayList<Proveedor>();
        if (sucSel.getId() != 0){
            ProveedorDao provDao = new ProveedorDao();
            listado = provDao.obtenerProveedoresDeSucursal(sucSel.getId());
        }
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompleta", listado);
            datos = ObtenerGrupo(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("listado", listado);
        }
        
        //datos.put("listado", listado);
        datos.put("condiciones", "");
        datos.remove("filtro");
        return datos;
    }

    private HashMap CargarCatalogosProveedor(HashMap datos) {
        datos.put("accion", "nuevo");
        //cargar estados
        EstadoDao edoDao = new EstadoDao();
        datos.put("estados", edoDao.obtenerListaPorPrioridad());
        return datos;
    }
    
    private HashMap GuardarProveedor(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        Proveedor nuevo = (Proveedor)datos.get("proveedor");
        ProveedorDao proDao = new ProveedorDao();
        nuevo.setDireccion(nuevo.getDatosfiscales().getDireccion());
        if (datos.get("accion").toString().equals("nuevo")){
            nuevo.setEstatus(1);
            nuevo.getDatosfiscales().getPersona().setSucursal(sucSel);
            proDao.guardar(nuevo);
        } else {
            proDao.actualizar(nuevo);
        }
        datos = ObtenerProveedores(datos);
        datos.remove("proveedor");
        datos.remove("accion");
        datos.remove("estados");
        datos.remove("contactos");
        datos.remove("medioscon");
        datos.remove("titulos");
        datos.remove("tiposmedios");
        return datos;
    }

    private HashMap ObtenerProveedor(HashMap datos) {
        ProveedorDao proDao = new ProveedorDao();
        Proveedor prov = (Proveedor) datos.get("proveedor");
        datos.put("proveedor", proDao.obtener(prov.getId()));
        datos = CargarCatalogosProveedor(datos);
        datos.put("accion", "editar");
        return datos;
    }

    private HashMap BajaDeProveedor(HashMap datos) {
        Proveedor prov = (Proveedor) datos.get("proveedor");
        ProveedorDao proDao = new ProveedorDao();
        proDao.actualizarEstatus(0, prov.getId());
        datos = ObtenerProveedores(datos);
        datos.remove("proveedor");
        return datos;
    }

    private HashMap ActivarProveedor(HashMap datos) {
        Proveedor prov = (Proveedor) datos.get("proveedor");
        ProveedorDao proDao = new ProveedorDao();
        proDao.actualizarEstatus(1, prov.getId());
        datos = ObtenerInactivos(datos);
        datos = ObtenerProveedores(datos);
        datos.remove("proveedor");
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Proveedor> listado = new ArrayList<Proveedor>();
        if (sucSel.getId() != 0){
            ProveedorDao proDao = new ProveedorDao();
            listado = proDao.obtenerInactivosDeSucursal(sucSel.getId());
        }
        datos.put("inactivos", listado);
        return datos;
    }

    private HashMap FiltrarListado(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        HashMap filtros = (HashMap) datos.get("filtros");
        //crear la consulta
        String consulta = "from Proveedor where estatus=1 and sucursal="+Integer.toString(sucSel.getId());
        String parametros = "";
        String fil1 = filtros.get("filtro1").toString();
        String fil2 = filtros.get("filtro2").toString();
        if (fil1.equals("on")){
            String param1 = filtros.get("razonSocial").toString();
            parametros += " and datosfiscales.razonsocial like '%"+param1+"%'";
        }
        if (fil2.equals("on")){
            String nom = filtros.get("nombre").toString();
            if (!nom.equals(""))
                parametros += " and datosfiscales.persona.nombre like '%"+nom+"%'";
            String pat = filtros.get("paterno").toString();
            if (!pat.equals(""))
                parametros += " and datosfiscales.persona.paterno like '%"+pat+"%'";
            String mat = filtros.get("materno").toString();
            if (!mat.equals(""))
                parametros += " and datosfiscales.persona.materno like '%"+mat+"%'";
        }
        
        consulta += parametros;
        
        ProveedorDao proDao = new ProveedorDao();
        datos.put("listadoFil", proDao.obtenerProveedoresDeSucursalFiltrado(consulta));
        datos.put("condiciones", parametros);
        return datos;
    }

    private HashMap CargarSiguientes(HashMap datos) {
        int fin = Integer.parseInt(datos.get("final").toString());
        datos.put("inicial", Integer.toString(fin+1));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap CargarAnteriores(HashMap datos) {
        int ini = Integer.parseInt(datos.get("inicial").toString())-grupos;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }

    private HashMap CargarPrincipio(HashMap datos) {
        datos.put("inicial", "1");
        datos = ObtenerGrupo(datos);        
        return datos;
    }

    private HashMap CargarFinal(HashMap datos) {
        List<Proveedor> listacom = (List<Proveedor>)datos.get("listacompleta");
        int total = listacom.size();
        int ini = total-grupos+1;
        if (total%grupos!=0)
            ini = ((total-(total%grupos)))+1;
        datos.put("inicial", Integer.toString(ini));
        datos = ObtenerGrupo(datos);
        return datos;
    }
    
    private HashMap ObtenerContactos(HashMap datos) {
        Proveedor prov = (Proveedor)datos.get("proveedor");
        ContactoProveedorDao ccdao = new ContactoProveedorDao();
        List<ContactoProveedor> contactos = ccdao.obtenerContactosDeProveedor(prov.getId());
        List<PersonaMedio> medioscon = new ArrayList<PersonaMedio>();
        datos.put("contactos", contactos);
        if (contactos.size()>0)
            medioscon = ccdao.obtenerMediosDeContactosDeProveedor(prov.getId());
        datos.put("medioscon", medioscon);
        return datos;
    }
    
    private HashMap ObtenerCatalogosContactos(HashMap datos) {
        TituloDao titdao = new TituloDao();
        datos.put("titulos", titdao.obtenerListaActivos());
        TipoMedioDao tmdao = new TipoMedioDao();
        datos.put("tiposmedios", tmdao.obtenerListaActivos());
        return datos;
    }
    
    private HashMap GuardaContacto(HashMap datos) {
        ContactoProveedor contac = (ContactoProveedor)datos.get("contacto");
        Proveedor prov = (Proveedor)datos.get("proveedor");
        String accion = datos.get("accionContacto")!=null?datos.get("accionContacto").toString():"nuevo";
        ContactoProveedorDao ccdao = new ContactoProveedorDao();
        PersonaDao perdao = new PersonaDao();
        TipoMedioDao tmdao = new TipoMedioDao();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        MedioDao meddao = new MedioDao();
        if (accion.equals("nuevo")){
            contac.setProveedor(prov);
            Persona per = contac.getContacto();
            perdao.guardar(per);
            ccdao.guardar(contac);
            //guardar los medios del contacto
            String[] tipos = (String[])datos.get("tipos");
            String[] medios = (String[])datos.get("medios");
            String[] extens = (String[])datos.get("extensiones");
            for (int i=0; i < tipos.length; i++){
                int idtipo = Integer.parseInt(tipos[i]);
                TipoMedio tm = tmdao.obtener(idtipo);
                String medio = "", ext = "";
                try {
                    medio = new String(medios[i].getBytes("ISO-8859-1"), "UTF-8");
                    ext = new String(extens[i].getBytes("ISO-8859-1"), "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(ContratoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
                Medio med = new Medio();
                med.setTipo(tm);
                med.setMedio(medio);
                med.setExtension(ext);
                meddao.guardar(med);
                PersonaMedio pm = new PersonaMedio();
                pm.setMedio(med);
                pm.setEstatus(1);
                pm.setPersona(contac.getContacto());
                pmdao.guardar(pm);
            }
        } else {
            Persona per = contac.getContacto();
            perdao.actualizar(per);
            ccdao.actualizar(contac);
            //eliminar los medios actuales
            List<PersonaMedio> mediosactuales = (List<PersonaMedio>)datos.get("medioscontacto");
            for (int i=0;i<mediosactuales.size(); i++){
                PersonaMedio pm = mediosactuales.get(i);
                Medio med = pm.getMedio();
                pmdao.eliminar(pm);
                meddao.eliminar(med);                
            }
            //guardar los medios del contacto
            String[] tipos = (String[])datos.get("tipos");
            String[] medios = (String[])datos.get("medios");
            String[] extens = (String[])datos.get("extensiones");
            for (int i=0; i < tipos.length; i++){
                int idtipo = Integer.parseInt(tipos[i]);
                TipoMedio tm = tmdao.obtener(idtipo);
                String medio = "", ext = "";
                try {
                    medio = new String(medios[i].getBytes("ISO-8859-1"), "UTF-8");
                    ext = new String(extens[i].getBytes("ISO-8859-1"), "UTF-8");
                } catch (UnsupportedEncodingException ex) {
                    Logger.getLogger(ContratoMod.class.getName()).log(Level.SEVERE, null, ex);
                }
                Medio med = new Medio();
                med.setTipo(tm);
                med.setMedio(medio);
                med.setExtension(ext);
                meddao.guardar(med);
                PersonaMedio pm = new PersonaMedio();
                pm.setMedio(med);
                pm.setEstatus(1);
                pm.setPersona(contac.getContacto());
                pmdao.guardar(pm);
            }            
        }
        datos = ObtenerContactos(datos);
        datos.put("pestaña","3");
        datos.remove("contacto");
        datos.remove("medioscontacto");
        datos.remove("accionContacto");
        return datos;
    }

    private HashMap EditarContacto(HashMap datos) {
        ContactoProveedor cc = (ContactoProveedor)datos.get("contacto");
        ContactoProveedorDao ccdao = new ContactoProveedorDao();
        cc = ccdao.obtener(cc.getId());
        datos.put("contacto", cc);
        PersonaMedioDao pmdao = new PersonaMedioDao();
        datos.put("medioscontacto", pmdao.obtenerActivosDePersona(cc.getContacto().getIdpersona()));
        return datos;
    }

    private HashMap BorrarContacto(HashMap datos) {
        ContactoProveedor cc = (ContactoProveedor)datos.get("contacto");
        ContactoProveedorDao ccdao = new ContactoProveedorDao();
        cc = ccdao.obtener(cc.getId());
        Persona per = cc.getContacto();
        PersonaMedioDao pmdao = new PersonaMedioDao();
        PersonaDao perdao = new PersonaDao();
        List<PersonaMedio> medios = pmdao.obtenerActivosDePersona(cc.getContacto().getIdpersona());
        
        //eliminar contacto
        ccdao.eliminar(cc);
        //eliminar medios
        MedioDao meddao = new MedioDao();
        for (int i=0; i < medios.size(); i++){
            PersonaMedio pm = medios.get(i);
            Medio med = pm.getMedio();
            pmdao.eliminar(pm);
            meddao.eliminar(med);                
        }
        //eliminar persona
        perdao.eliminar(per);
        
        datos = ObtenerContactos(datos);
        datos.put("pestaña","3");
        datos.remove("contacto");
        datos.remove("accionContacto");
        
        return datos;
    }

    private HashMap CambiarSucursalDeProveedor(HashMap datos) {
        Sucursal sucnva = (Sucursal)datos.get("sucursalNueva");
        Proveedor prov = (Proveedor)datos.get("proveedor");
        prov.setSucursal(sucnva);
        ProveedorDao provdao = new ProveedorDao();
        provdao.actualizar(prov);
        datos = ObtenerProveedores(datos);
        datos.remove("proveedor");
        datos.remove("sucursalNueva");
        return datos;
    }

}
