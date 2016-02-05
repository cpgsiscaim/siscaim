/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

import javax.persistence.*;


/**
 *
 * @author usuario
 */
@Entity
@Table (name = "ct_bancos")
public class Banco {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "idbanco")
    private int id;
    private String nombre;
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
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
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
