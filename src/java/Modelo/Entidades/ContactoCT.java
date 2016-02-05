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
@Table (name = "contactos_ct")
public class ContactoCT {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private CentroDeTrabajo ct;
    @OneToOne (fetch = FetchType.EAGER)
    private Persona contacto;

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
     * @return the contrato
     */
    public CentroDeTrabajo getCt() {
        return ct;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setCt(CentroDeTrabajo ct) {
        this.ct = ct;
    }

    /**
     * @return the contacto
     */
    public Persona getContacto() {
        return contacto;
    }

    /**
     * @param contacto the contacto to set
     */
    public void setContacto(Persona contacto) {
        this.contacto = contacto;
    }
}
