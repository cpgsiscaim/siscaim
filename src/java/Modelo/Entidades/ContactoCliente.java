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
@Table (name = "contactos_clientes")
public class ContactoCliente {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Cliente cliente;
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
     * @return the cliente
     */
    public Cliente getCliente() {
        return cliente;
    }

    /**
     * @param cliente the cliente to set
     */
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
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
