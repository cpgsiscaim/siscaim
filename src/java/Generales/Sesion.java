/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Generales;

import Modelo.Entidades.Usuario;
import java.util.Date;
import java.util.HashMap;

/**
 *
 * @author TEMOC
 */
public class Sesion {
    private HashMap datos;
    private Usuario usuario;
    private String paginaSiguiente;
    private boolean error;
    private boolean exito;
    private String mensaje;
    private String paginaAnterior;
    private HashMap menu;
    private int grupos;
    
    public Sesion(){
        
    }
    
    public void Limpiar(){
        this.setDatos(null);
        this.setUsuario(null);
        this.setPaginaSiguiente(null);
        this.setError(false);
        this.setMensaje(null);
        this.setPaginaAnterior(null);
    }

    /**
     * @return the datos
     */
    public HashMap getDatos() {
        return datos;
    }

    /**
     * @param datos the datos to set
     */
    public void setDatos(HashMap datos) {
        this.datos = datos;
    }

    /**
     * @return the usuario
     */
    public Usuario getUsuario() {
        return usuario;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    /**
     * @return the paginaSiguiente
     */
    public String getPaginaSiguiente() {
        return paginaSiguiente;
    }

    /**
     * @param paginaSiguiente the paginaSiguiente to set
     */
    public void setPaginaSiguiente(String paginaSiguiente) {
        this.paginaSiguiente = paginaSiguiente;
    }

    /**
     * @return the error
     */
    public boolean isError() {
        return error;
    }

    /**
     * @param error the error to set
     */
    public void setError(boolean error) {
        this.error = error;
    }

    /**
     * @return the mensaje
     */
    public String getMensaje() {
        return mensaje;
    }

    /**
     * @param mensaje the mensaje to set
     */
    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    /**
     * @return the paginaAnterior
     */
    public String getPaginaAnterior() {
        return paginaAnterior;
    }

    /**
     * @param paginaAnterior the paginaAnterior to set
     */
    public void setPaginaAnterior(String paginaAnterior) {
        this.paginaAnterior = paginaAnterior;
    }

    /**
     * @return the exito
     */
    public boolean isExito() {
        return exito;
    }

    /**
     * @param exito the exito to set
     */
    public void setExito(boolean exito) {
        this.exito = exito;
    }

    /**
     * @return the menu
     */
    public HashMap getMenu() {
        return menu;
    }

    /**
     * @param menu the menu to set
     */
    public void setMenu(HashMap menu) {
        this.menu = menu;
    }

    /**
     * @return the grupos
     */
    public int getGrupos() {
        return grupos;
    }

    /**
     * @param grupos the grupos to set
     */
    public void setGrupos(int grupos) {
        this.grupos = grupos;
    }

}
