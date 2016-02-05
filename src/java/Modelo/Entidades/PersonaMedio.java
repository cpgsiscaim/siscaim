/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "mediosper")
public class PersonaMedio {
    @Id
    @Column (name="idmedioper")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Persona persona;
    @OneToOne (fetch = FetchType.EAGER)
    private Medio medio;
    @Column (name="medi_observa")
    private String observaciones;
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
     * @return the medio
     */
    public Medio getMedio() {
        return medio;
    }

    /**
     * @param medio the medio to set
     */
    public void setMedio(Medio medio) {
        this.medio = medio;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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
