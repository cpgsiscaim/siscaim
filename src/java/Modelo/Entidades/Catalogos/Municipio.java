/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="ct_municipios")
public class Municipio {
    @Id
    private int idmunicipio;
    private int clave;
    private String municipio;
    private int prioridad;
    
    @ManyToOne
    private Estado estado;
    
    public Municipio(){
        
    }

    /**
     * @return the idmunicipio
     */
    public int getIdmunicipio() {
        return idmunicipio;
    }

    /**
     * @param idmunicipio the idmunicipio to set
     */
    public void setIdmunicipio(int idmunicipio) {
        this.idmunicipio = idmunicipio;
    }

    /**
     * @return the municipio
     */
    public String getMunicipio() {
        return municipio;
    }

    /**
     * @param municipio the municipio to set
     */
    public void setMunicipio(String municipio) {
        this.municipio = municipio;
    }

    /**
     * @return the prioridad
     */
    public int getPrioridad() {
        return prioridad;
    }

    /**
     * @param prioridad the prioridad to set
     */
    public void setPrioridad(int prioridad) {
        this.prioridad = prioridad;
    }

    /**
     * @return the estado
     */
    public Estado getEstado() {
        return estado;
    }

    /**
     * @param estado the estado to set
     */
    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    /**
     * @return the clave
     */
    public int getClave() {
        return clave;
    }

    /**
     * @param clave the clave to set
     */
    public void setClave(int clave) {
        this.clave = clave;
    }
    
}
