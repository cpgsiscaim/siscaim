/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="ct_estados")
public class Estado {
    
    @Id
    private int idestado;
    private String estado;
    private int prioridad;
    
    @OneToMany (cascade=CascadeType.ALL, fetch=FetchType.EAGER, mappedBy="estado")
    private List<Municipio> municipios = new ArrayList<Municipio>();
    
    public Estado(){
        
    }

    /**
     * @return the idestado
     */
    public int getIdestado() {
        return idestado;
    }

    /**
     * @param idestado the idestado to set
     */
    public void setIdestado(int idestado) {
        this.idestado = idestado;
    }

    /**
     * @return the estado
     */
    public String getEstado() {
        return estado;
    }

    /**
     * @param estado the estado to set
     */
    public void setEstado(String estado) {
        this.estado = estado;
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
     * @return the municipios
     */
    public List<Municipio> getMunicipios() {
        return municipios;
    }

    /**
     * @param municipios the municipios to set
     */
    public void setMunicipios(List<Municipio> municipios) {
        this.municipios = municipios;
    }
    
}
