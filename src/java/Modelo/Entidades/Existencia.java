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
@Table (name="existencia")
public class Existencia {
    @Id
    @GeneratedValue (strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch=FetchType.EAGER)
    private Producto producto;
    @OneToOne (fetch=FetchType.EAGER)
    private Almacen almacen;
    @Column (name="prod_existencia")
    private float existencia;

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
     * @return the producto
     */
    public Producto getProducto() {
        return producto;
    }

    /**
     * @param producto the producto to set
     */
    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    /**
     * @return the almacen
     */
    public Almacen getAlmacen() {
        return almacen;
    }

    /**
     * @param almacen the almacen to set
     */
    public void setAlmacen(Almacen almacen) {
        this.almacen = almacen;
    }

    /**
     * @return the existencia
     */
    public float getExistencia() {
        return existencia;
    }

    /**
     * @param existencia the existencia to set
     */
    public void setExistencia(float existencia) {
        this.existencia = existencia;
    }
}
