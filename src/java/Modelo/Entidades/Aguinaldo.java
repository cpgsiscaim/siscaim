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
import javax.persistence.TemporalType;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "aguinaldo")
public class Aguinaldo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Empleado empleado;
    private int anio;
    private float sueldodiario;
    private int diastrabajadosbrutos;
    private int faltas;
    private float diasaguinaldo;
    private float montoaguinaldo;
    @Temporal(TemporalType.DATE)
    private Date fechapago;

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
     * @return the anio
     */
    public int getAnio() {
        return anio;
    }

    /**
     * @param anio the anio to set
     */
    public void setAnio(int anio) {
        this.anio = anio;
    }

    /**
     * @return the sueldodiario
     */
    public float getSueldodiario() {
        return sueldodiario;
    }

    /**
     * @param sueldodiario the sueldodiario to set
     */
    public void setSueldodiario(float sueldodiario) {
        this.sueldodiario = sueldodiario;
    }

    /**
     * @return the diastrabajadosbrutos
     */
    public int getDiastrabajadosbrutos() {
        return diastrabajadosbrutos;
    }

    /**
     * @param diastrabajadosbrutos the diastrabajadosbrutos to set
     */
    public void setDiastrabajadosbrutos(int diastrabajadosbrutos) {
        this.diastrabajadosbrutos = diastrabajadosbrutos;
    }

    /**
     * @return the faltas
     */
    public int getFaltas() {
        return faltas;
    }

    /**
     * @param faltas the faltas to set
     */
    public void setFaltas(int faltas) {
        this.faltas = faltas;
    }

    /**
     * @return the diasaguinaldo
     */
    public float getDiasaguinaldo() {
        return diasaguinaldo;
    }

    /**
     * @param diasaguinaldo the diasaguinaldo to set
     */
    public void setDiasaguinaldo(float diasaguinaldo) {
        this.diasaguinaldo = diasaguinaldo;
    }

    /**
     * @return the montoaguinaldo
     */
    public float getMontoaguinaldo() {
        return montoaguinaldo;
    }

    /**
     * @param montoaguinaldo the montoaguinaldo to set
     */
    public void setMontoaguinaldo(float montoaguinaldo) {
        this.montoaguinaldo = montoaguinaldo;
    }

    /**
     * @return the fechapago
     */
    public Date getFechapago() {
        return fechapago;
    }

    /**
     * @param fechapago the fechapago to set
     */
    public void setFechapago(Date fechapago) {
        this.fechapago = fechapago;
    }
}
