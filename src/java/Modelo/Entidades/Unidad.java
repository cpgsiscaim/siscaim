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
@Table (name="unidades")
public class Unidad {
    @Id
    @Column (name="unid_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column (name="unid_clave")
    private String clave;
    @Column (name="unid_descri")
    private String descripcion;
    @Column (name="unid_entero")
    private float entero;
    @Column (name="unid_fraccion")
    private float fraccion;
    @Column (name="estatus")
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
     * @return the clave
     */
    public String getClave() {
        return clave;
    }

    /**
     * @param clave the clave to set
     */
    public void setClave(String clave) {
        this.clave = clave;
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
     * @return the entero
     */
    public float getEntero() {
        return entero;
    }

    /**
     * @param entero the entero to set
     */
    public void setEntero(float entero) {
        this.entero = entero;
    }

    /**
     * @return the fraccion
     */
    public float getFraccion() {
        return fraccion;
    }

    /**
     * @param fraccion the fraccion to set
     */
    public void setFraccion(float fraccion) {
        this.fraccion = fraccion;
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
