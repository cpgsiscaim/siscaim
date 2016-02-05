/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Entidades;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "historial_imss")
public class HistorialIMSS {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "idhistorial")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Empleado empleado;
    @Temporal(javax.persistence.TemporalType.DATE)
    private Date fechaalta;
    @Temporal(javax.persistence.TemporalType.DATE)
    private Date fechabaja;
    private String registropatronal;
    private float salariobase;

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
     * @return the fechaalta
     */
    public Date getFechaalta() {
        return fechaalta;
    }

    /**
     * @param fechaalta the fechaalta to set
     */
    public void setFechaalta(Date fechaalta) {
        this.fechaalta = fechaalta;
    }

    /**
     * @return the fechabaja
     */
    public Date getFechabaja() {
        return fechabaja;
    }

    /**
     * @param fechabaja the fechabaja to set
     */
    public void setFechabaja(Date fechabaja) {
        this.fechabaja = fechabaja;
    }

    /**
     * @return the registropatronal
     */
    public String getRegistropatronal() {
        return registropatronal;
    }

    /**
     * @param registropatronal the registropatronal to set
     */
    public void setRegistropatronal(String registropatronal) {
        this.registropatronal = registropatronal;
    }

    /**
     * @return the salariobase
     */
    public float getSalariobase() {
        return salariobase;
    }

    /**
     * @param salariobase the salariobase to set
     */
    public void setSalariobase(float salariobase) {
        this.salariobase = salariobase;
    }
}
