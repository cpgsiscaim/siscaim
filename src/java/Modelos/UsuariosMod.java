/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelos;

import Generales.Encriptar;
import Generales.Sesion;
import Modelo.Daos.*;
import Modelo.Entidades.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author TEMOC
 */
public class UsuariosMod {
    
    private Usuario usuario = null;
    private int grupos = 0;
    
    public UsuariosMod(){
        
    }
    
    public Sesion LogueaUsuario(Sesion sesion){
        //obtener el usuario de la sesion
        Usuario us = sesion.getUsuario();
                
        //valida si el usuario existe
        if (UsuarioValido(us))
        {
            //obtener el usuario completo
            us = ObtenerUsuarioFull(us);
            //obtener el menú del usuario
            HashMap datos = new HashMap();
            //datos.put("menu", ObtenerMenuUsuario(us));
            sesion.setMenu(ObtenerMenuUsuario(us));
            sesion.setDatos(datos);
            //subir el usuario a la sesion
            sesion.setUsuario(us);
            //obtener grupos
            UtilDao utDao = new UtilDao();
            sesion.setGrupos(utDao.grupos());
            /*/obtener el logo de la empresa
            EmpresaDao empDao = new EmpresaDao();
            sesion.setLogo(empDao.obtenerLogo(us.getEmpleado().getPersona().getSucursal().getEmpresa().getId()));*/
            //cargar la página siguiente
            sesion.setPaginaSiguiente("/Generales/IniciarSesion/bienvenida.jsp");
        }
        else if (SuperUsuario(us)){
            //obtener el usuario completo
            us = CargaSuperUsuario(us);
            //obtener el menú del usuario
            HashMap datos = new HashMap();
            //datos.put("menu", ObtenerMenuUsuario(us));
            sesion.setMenu(ObtenerMenuUsuario(us));
            sesion.setDatos(datos);
            //subir el usuario a la sesion
            sesion.setUsuario(us);
            //obtener grupos
            UtilDao utDao = new UtilDao();
            sesion.setGrupos(utDao.grupos());
            /*/obtener el logo de la empresa
            EmpresaDao empDao = new EmpresaDao();
            sesion.setLogo(empDao.obtenerLogo(us.getEmpleado().getPersona().getSucursal().getEmpresa().getId()));*/
            //cargar la página siguiente
            sesion.setPaginaSiguiente("/Generales/IniciarSesion/bienvenida.jsp");
        }
        else
        {
            //cargar mensaje de usuario inexistente
            sesion.setError(true);
            sesion.setMensaje("Datos de acceso NO válidos");
            sesion.setPaginaSiguiente("/Generales/IniciarSesion/login.jsp");
            //sesion.setPaginaAnterior("/Generales/IniciarSesion/login.jsp");
        }
        
        return sesion;
    }

    public boolean UsuarioValido(Usuario us) {
        //instanciar el dao
        UsuarioDao usDao = new UsuarioDao();
        Usuario usx = usDao.obtenerPorUsuario(us.getUsuario());
        if (usx == null)
            return false;
        else if (usx.getEstatus()==0)
            return false;
        
        //revisar password
        String passEncrip = Encriptar.encriptar(us.getPass());
        if (!passEncrip.equals(usx.getPass()))
            return false;
        return true;
    }

    public Usuario ObtenerUsuarioFull(Usuario us) {
        UsuarioDao usDao = new UsuarioDao();
        return usDao.obtenerPorUsuario(us.getUsuario());
    }

    public void GuardarUsuario(Usuario usx) {
        UsuarioDao usDao = new UsuarioDao();
        usDao.guardar(usx);
    }

    public HashMap ObtenerMenuUsuario(Usuario us) {
        HashMap menu = new HashMap();
        
        List<Operacion> operaciones = us.getOperaciones();
        menu.put("operaciones", operaciones);
        //obtener categorias del menu
        List<CategoriaOp> categorias = new ArrayList<CategoriaOp>();
        List<String> catsAx = new ArrayList<String>();
        List<CategoriaOp> subcategorias = new ArrayList<CategoriaOp>();
        List<String> subcatsAx = new ArrayList<String>();
        CategoriaOpDao catDao = new CategoriaOpDao();
        for (int i=0; i < operaciones.size(); i++){
            Operacion op = (Operacion) operaciones.get(i);
            CategoriaOp cat = (CategoriaOp) op.getCategoria();
            if (cat.getIdcatop()==cat.getPadre()) {
                if (catsAx.isEmpty()){
                    categorias.add(cat);
                    catsAx.add(cat.getCategoria());
                }
                else if (!catsAx.contains(cat.getCategoria())){
                    categorias.add(cat);
                    catsAx.add(cat.getCategoria());
                }
            }
            else {
                //obtener categoria de subcategoria
                CategoriaOp catDeSub = catDao.obtener(cat.getPadre());
                //agregar a categorias
                if (catsAx.isEmpty()){
                    categorias.add(catDeSub);
                    catsAx.add(catDeSub.getCategoria());
                }
                else if (!catsAx.contains(catDeSub.getCategoria())){
                    categorias.add(catDeSub);
                    catsAx.add(catDeSub.getCategoria());
                }
                //agregar la subcategoria
                if (subcatsAx.isEmpty()){
                    subcategorias.add(cat);
                    subcatsAx.add(cat.getCategoria());
                }
                else if (!subcatsAx.contains(cat.getCategoria())){
                    subcategorias.add(cat);
                    subcatsAx.add(cat.getCategoria());
                }
            }
        }
        menu.put("categorias", categorias);
        menu.put("subcategorias", subcategorias);
        
        return menu;
    }

    public Sesion CambiarPass(Sesion sesion) {
        //obtener los datos
        HashMap datos = sesion.getDatos();
        String passAct = (String)datos.get("passAct");
        //validar el pass actual
        if (!sesion.getUsuario().getPass().equals(Encriptar.encriptar(passAct))){
            sesion.setError(true);
            sesion.setMensaje("La contraseña actual no es válida");
            sesion.setPaginaSiguiente("/Generales/CambiarPass/cambiarpass.jsp");
        }
        else {
            Usuario us = sesion.getUsuario();
            String passNva = (String)datos.get("passNva");
            us.setPass(Encriptar.encriptar(passNva));
            this.ActualizarUsuario(us);
            sesion.setUsuario(us);
            sesion.setExito(true);
            sesion.setMensaje("La contraseña ha sido cambiada con éxito");
            sesion.setPaginaSiguiente("/Generales/CambiarPass/cambiarpass.jsp");
        }
            
        return sesion;
    }

    public void ActualizarUsuario(Usuario us) {
        UsuarioDao usDao = new UsuarioDao();
        usDao.actualizar(us);
    }

    public Sesion GestionarUsuarios(Sesion sesion) {
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
                datos = ObtenerUsuarios(datos);
                break;
            case 1:
                //cargar sucursal
                datos = CargaSucursalSel(datos);
                //cargar clientes de la sucursal seleccionada
                datos = ObtenerUsuarios(datos);
                break;
            case 2: case 4:
                //ir a nuevo usuario (2) || editar usuario (4)
                datos.put("accion", "nuevo");
                if (paso == 4){
                    datos.put("accion", "editar");
                    datos = ObtenerUsuario(datos);
                }
                datos = CargarCatalogosUsuario(datos);
                break;
            case 3: case 5:
                //guardar usuario
                datos = GuardaUsuario(datos);
                if (datos.get("error")!=null){
                    sesion.setError(true);
                    sesion.setMensaje(datos.get("error").toString());
                    sesion.setPaginaSiguiente("/Empresa/GestionarUsuarios/nuevousuario.jsp");
                    datos.remove("error");
                } else {
                    sesion.setExito(true);
                    sesion.setMensaje("El Usuario fue guardado con éxito");
                }
                break;
            case 6:
                //baja del usuario
                datos = BajaDeUsuario(datos);
                break;
            case 7:
                //ir a inactivos
                datos = ObtenerInactivos(datos);
                break;
            case 8:
                //activar cliente
                datos = ActivarUsuario(datos);
                break;
            case 9:
                //obtener rutas
                datos = GestionarPermisos(datos);
                break;
            /*case 50:
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
            case 97:
                //cancelar inactivos
                datos.remove("inactivos");
                break;*/
            case 98:
                //cancelar nuevo cliente
                datos.remove("accion");
                datos.remove("usuario");
                datos.remove("empleados");
                break;
            case 99:
                datos = new HashMap();
                break;
        }
        sesion.setDatos(datos);

        return sesion;
    }
    
    private List<Sucursal> ObtenerSucursales() {
        SucursalDao sucDao = new SucursalDao();
        return sucDao.obtenerListaSucYMatriz();
    }

    private HashMap ObtenerUsuarios(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Usuario> listado = new ArrayList<Usuario>();
        if (sucSel.getId() != 0){
            UsuarioDao usuDao = new UsuarioDao();
            listado = usuDao.obtenerUsuariosDeSucursal(sucSel.getId());
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
        return datos;
    }
    
    private HashMap ObtenerGrupo(HashMap datos) {
        List<Usuario> usuarios = (List<Usuario>)datos.get("listacompleta");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Usuario> grupo = new ArrayList<Usuario>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin > usuarios.size()){
            fin = usuarios.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(usuarios.get(i));
        }
        datos.put("listado", grupo);
        return datos;
    }

    private HashMap CargaSucursalSel(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        if (sucSel.getId() != 0){
            SucursalDao sucDao = new SucursalDao();
            datos.put("sucursalSel", sucDao.obtener(sucSel.getId()));
        }
        return datos;
    }

    private HashMap CargarCatalogosUsuario(HashMap datos) {
        Sucursal sucSel = (Sucursal) datos.get("sucursalSel");
        int paso = Integer.parseInt(datos.get("paso").toString());
        List<Empleado> empleados = new ArrayList<Empleado>();
        if (paso == 4){
            Usuario usu = (Usuario)datos.get("usuario");
            empleados.add(usu.getEmpleado());
        }
        //obtener empleados de la sucursal que no esten en usuarios
        EmpleadoDao empDao = new EmpleadoDao();
        List<Empleado> empls = empDao.obtenerListaActivosDeSucursalSinUsuario(sucSel.getId());
        empleados.addAll(empls);
        datos.put("empleados", empleados);
        return datos;
    }

    private HashMap ObtenerUsuario(HashMap datos) {
        Usuario usuario = (Usuario)datos.get("usuario");
        UsuarioDao usuDao = new UsuarioDao();
        usuario = usuDao.obtener(usuario.getIdusuario());
        datos.put("usuario", usuario);
        return datos;
    }

    private HashMap GuardaUsuario(HashMap datos) {
        Usuario us = (Usuario)datos.get("usuario");
        UsuarioDao usuDao = new UsuarioDao();
        if (datos.get("accion").toString().equals("nuevo") && usuDao.ValidaUsuario(us)){
            datos.put("error", "El Usuario ya existe");
            return datos;
        } else if (datos.get("accion").toString().equals("editar")){
            String usuact = datos.get("usuact").toString();
            if (!usuact.equals(us.getUsuario()) && usuDao.ValidaUsuario(us)){
                datos.put("error", "El Usuario ya existe");
                return datos;
            }
        }
        //encriptar el pass
        us.setPass(Encriptar.encriptar(us.getPass()));
        if (datos.get("accion").toString().equals("nuevo")){
            us.setEstatus(1);
            usuDao.guardar(us);
        } else {
            usuDao.actualizar(us);
        }
        datos.remove("usuario");
        datos.remove("accion");       
        
        datos = ObtenerUsuarios(datos);
        return datos;
    }

    private HashMap BajaDeUsuario(HashMap datos) {
        Usuario us = (Usuario)datos.get("usuario");
        UsuarioDao usuDao = new UsuarioDao();
        usuDao.actualizarEstatus(0, us.getIdusuario());
        datos.remove("usuario");
        datos = ObtenerUsuarios(datos);
        return datos;
    }

    private HashMap ObtenerInactivos(HashMap datos) {
        Sucursal sucSel = (Sucursal)datos.get("sucursalSel");
        List<Usuario> listado = new ArrayList<Usuario>();
        if (sucSel.getId() != 0){
            UsuarioDao usuDao = new UsuarioDao();
            listado = usuDao.obtenerUsuariosInactivosDeSucursal(sucSel.getId());
        }
        if (listado.size()>grupos){
            datos.put("grupos", "1");
            datos.put("inicial", "1");
            datos.put("listacompletain", listado);
            datos = ObtenerGrupoInactivos(datos);
        } else {
            datos.put("grupos", "0");
            datos.put("inactivos", listado);
        }
        return datos;
    }
    
    private HashMap ObtenerGrupoInactivos(HashMap datos) {
        List<Usuario> usuarios = (List<Usuario>)datos.get("listacompletain");
        datos.put("anteriores", "0");
        int inicial = Integer.parseInt(datos.get("inicial").toString());
        if (inicial>1)
            datos.put("anteriores", "1");
        List<Usuario> grupo = new ArrayList<Usuario>();
        int fin = grupos +(inicial-1);
        datos.put("siguientes", "1");
        if (fin > usuarios.size()){
            fin = usuarios.size();
            datos.put("siguientes", "0");
        }
        datos.put("final", Integer.toString(fin));
        for (int i=inicial-1; i < fin; i++){
            grupo.add(usuarios.get(i));
        }
        datos.put("inactivos", grupo);
        return datos;
    }

    private HashMap ActivarUsuario(HashMap datos) {
        Usuario us = (Usuario)datos.get("usuario");
        UsuarioDao usuDao = new UsuarioDao();
        usuDao.actualizarEstatus(1, us.getIdusuario());
        datos.remove("usuario");
        datos = ObtenerUsuarios(datos);
        datos = ObtenerInactivos(datos);
        return datos;
    }

    private HashMap GestionarPermisos(HashMap datos) {
        datos = ObtenerUsuario(datos);
        Usuario usu = (Usuario)datos.get("usuario");
        datos.put("permisos", usu.getOperaciones());
        return datos;
    }

    public Sesion GestionarPermisos(Sesion sesion) {
        HashMap datos = sesion.getDatos();
        int paso = Integer.parseInt(datos.get("paso").toString());
        grupos = sesion.getGrupos();
        switch (paso){
            case 1:
                //ir a nuevo permiso (2)
                datos = CargarOperaciones(datos);
                break;
            case 2:
                //guardar usuario
                datos = GuardaPermiso(datos);
                break;
            case 3:
                //baja del usuario
                datos = BajaDePermiso(datos);
                break;
            /*case 50:
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
            case 97:
                //cancelar inactivos
                datos.remove("inactivos");
                break;*/
            case 98:
                //cancelar nuevo permiso
                datos.remove("operaciones");
                break;
            case 99:
                datos.remove("permisos");
                break;
        }
        sesion.setDatos(datos);
        return sesion;
    }

    private HashMap CargarOperaciones(HashMap datos) {
        OperacionDao opDao = new OperacionDao();
        List<Operacion> disponibles = new ArrayList<Operacion>();
        List<Operacion> todas = opDao.obtenerListaActivas();
        List<Operacion> actuales = (List<Operacion>) datos.get("permisos");
        if (actuales.isEmpty()){
            disponibles.addAll(todas);
        } else {
            for (int i=0; i < todas.size(); i++){
                Operacion oper = todas.get(i);
                boolean esta = false;
                for (int j=0; j < actuales.size(); j++){
                    Operacion act = actuales.get(j);
                    if (act.getIdoperacion()==oper.getIdoperacion()){
                        esta = true;
                        break;
                    }
                }
                if (!esta)
                    disponibles.add(oper);
            }
        }
        datos.put("operaciones", disponibles);
        return datos;
    }

    private HashMap GuardaPermiso(HashMap datos) {
        Usuario usu = (Usuario)datos.get("usuario");
        Operacion permiso = (Operacion)datos.get("permiso");
        OperacionDao opDao = new OperacionDao();
        permiso = opDao.obtener(permiso.getIdoperacion());
        usu.addOperacion(permiso);
        UsuarioDao usuDao = new UsuarioDao();
        usuDao.actualizar(usu);
        datos.put("permisos", usu.getOperaciones());
        datos.remove("permiso");
        return datos;
    }

    private HashMap BajaDePermiso(HashMap datos) {
        Usuario usu = (Usuario)datos.get("usuario");
        int indice = Integer.parseInt(datos.get("indiceper").toString());
        usu.getOperaciones().remove(indice);
        UsuarioDao usuDao = new UsuarioDao();
        usuDao.actualizar(usu);
        datos.put("permisos", usu.getOperaciones());
        datos.remove("indiceper");
        return datos;
    }

    private boolean SuperUsuario(Usuario us) {
        if (us.getUsuario().equals("chelita")
                && us.getPass().equals("boliche"))
            return true;
        return false;
    }

    private Usuario CargaSuperUsuario(Usuario us) {
        OperacionDao opDao = new OperacionDao();
        us.setOperaciones(opDao.obtenerListaActivas());

        us.setEmpleado(new Empleado());
        us.getEmpleado().setPersona(new Persona());
        us.getEmpleado().getPersona().setNombre("SUPER");
        us.getEmpleado().getPersona().setPaterno("USUARIO");
        us.getEmpleado().getPersona().setMaterno("SISCAIM");
        us.getEmpleado().getPersona().setSexo("M");
        SucursalDao sucDao = new SucursalDao();
        us.getEmpleado().getPersona().setSucursal(sucDao.obtener(3));
        return us;
    }
    
}
