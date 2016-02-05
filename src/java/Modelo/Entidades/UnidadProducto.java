/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import javax.persistence.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
//import org.hibernate.FetchMode;
//import org.hibernate.annotations.Fetch;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "unidxprod")
public class UnidadProducto {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "univ_id")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Producto producto;
    @OneToOne (fetch = FetchType.EAGER)
    private Unidad unidad;
    @Column (name = "univ_valor")
    private float valor;
    private int estatus;
    private int minima;
    private int empaque;

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
     * @return the unidad
     */
    public Unidad getUnidad() {
        return unidad;
    }

    /**
     * @param unidad the unidad to set
     */
    public void setUnidad(Unidad unidad) {
        this.unidad = unidad;
    }

    /**
     * @return the valor
     */
    public float getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(float valor) {
        this.valor = valor;
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

    /**
     * @return the minima
     */
    public int getMinima() {
        return minima;
    }

    /**
     * @param minima the minima to set
     */
    public void setMinima(int minima) {
        this.minima = minima;
    }

    /**
     * @return the empaque
     */
    public int getEmpaque() {
        return empaque;
    }

    /**
     * @param empaque the empaque to set
     */
    public void setEmpaque(int empaque) {
        this.empaque = empaque;
    }
}
