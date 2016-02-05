/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.TipoFamiliar;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "familiares")
public class Familiar {
    @Id
    @Column (name = "fami_id")
    @GeneratedValue (strategy=GenerationType.IDENTITY)    
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Empleado empleado;
    @OneToOne (cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Persona persona;
    @OneToOne (fetch = FetchType.EAGER)
    private TipoFamiliar tipofamiliar;
    private String observacion;
    private int estatus;

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * @return the empleado
     */
    public Empleado getEmpleado() {
        return empleado;
    }

    /**
     * @param empleado the empleado to set
     */
    public void setEmpleado(Empleado empleado) {
        this.empleado = empleado;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the tipofamiliar
     */
    public TipoFamiliar getTipofamiliar() {
        return tipofamiliar;
    }

    /**
     * @param tipofamiliar the tipofamiliar to set
     */
    public void setTipofamiliar(TipoFamiliar tipofamiliar) {
        this.tipofamiliar = tipofamiliar;
    }

    /**
     * @return the observacion
     */
    public String getObservacion() {
        return observacion;
    }

    /**
     * @param observacion the observacion to set
     */
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    /**
     * @return the estatus
     */
    public int getEstatus() {
        return estatus;
    }

    /**
     * @param estatus the estatus to set
     */
    public void setEstatus(int estatus) {
        this.estatus = estatus;
    }
}
