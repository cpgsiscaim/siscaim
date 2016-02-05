/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "contactos_contrato")
public class ContactoContrato {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Contrato contrato;
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
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
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
