/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Entidades;

import Modelo.Entidades.Catalogos.Quincena;
import java.util.Date;
import javax.persistence.CascadeType;
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
@Table(name="vacaciones")
public class Vacaciones {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne(fetch=FetchType.EAGER)
    private Empleado empleado;
    private int antiguedad;
    private int anio;
    @OneToOne(fetch=FetchType.EAGER)
    private Nomina nomina;
    private int estatus; //0=cancelado, 1=por pagar, 2=pagada, 3=baja empleado, 4=goce de vacaciones, 5=pagadas o gozadas registro manual
    private int dias;
    @Temporal(TemporalType.DATE)
    private Date fechainicial;
    @Temporal(TemporalType.DATE)
    private Date fechafinal;
    @OneToOne(fetch=FetchType.EAGER)
    private Quincena quincena;
    private float montovacaciones;
    private float montoprima;    
    private int diasacuenta;

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
     * @return the antiguedad
     */
    public int getAntiguedad() {
        return antiguedad;
    }

    /**
     * @param antiguedad the antiguedad to set
     */
    public void setAntiguedad(int antiguedad) {
        this.antiguedad = antiguedad;
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
     * @return the nomina
     */
    public Nomina getNomina() {
        return nomina;
    }

    /**
     * @param nomina the nomina to set
     */
    public void setNomina(Nomina nomina) {
        this.nomina = nomina;
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
     * @return the dias
     */
    public int getDias() {
        return dias;
    }

    /**
     * @param dias the dias to set
     */
    public void setDias(int dias) {
        this.dias = dias;
    }

    /**
     * @return the fechainicial
     */
    public Date getFechainicial() {
        return fechainicial;
    }

    /**
     * @param fechainicial the fechainicial to set
     */
    public void setFechainicial(Date fechainicial) {
        this.fechainicial = fechainicial;
    }

    /**
     * @return the fechafinal
     */
    public Date getFechafinal() {
        return fechafinal;
    }

    /**
     * @param fechafinal the fechafinal to set
     */
    public void setFechafinal(Date fechafinal) {
        this.fechafinal = fechafinal;
    }

    /**
     * @return the quincena
     */
    public Quincena getQuincena() {
        return quincena;
    }

    /**
     * @param quincena the quincena to set
     */
    public void setQuincena(Quincena quincena) {
        this.quincena = quincena;
    }

    /**
     * @return the montovacaciones
     */
    public float getMontovacaciones() {
        return montovacaciones;
    }

    /**
     * @param montovacaciones the montovacaciones to set
     */
    public void setMontovacaciones(float montovacaciones) {
        this.montovacaciones = montovacaciones;
    }

    /**
     * @return the montoprima
     */
    public float getMontoprima() {
        return montoprima;
    }

    /**
     * @param montoprima the montoprima to set
     */
    public void setMontoprima(float montoprima) {
        this.montoprima = montoprima;
    }

    /**
     * @return the diasacuenta
     */
    public int getDiasacuenta() {
        return diasacuenta;
    }

    /**
     * @param diasacuenta the diasacuenta to set
     */
    public void setDiasacuenta(int diasacuenta) {
        this.diasacuenta = diasacuenta;
    }
}
