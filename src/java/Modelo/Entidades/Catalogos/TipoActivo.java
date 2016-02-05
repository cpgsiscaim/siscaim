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
@Table (name="ct_tipoactivo")
public class TipoActivo {
    @Id
    @GeneratedValue (strategy=GenerationType.IDENTITY)
    @Column (name="idtipoactivo")
    private int id;
    private String descripcion;    
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
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
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
