/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Entidades;

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
@Table(name="finiquitos")
public class Finiquito {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne(cascade= CascadeType.ALL, fetch=FetchType.EAGER)
    private Empleado empleado;
    private int antdias;
    private float antanios;
    private float sueldodia;
    @Temporal(TemporalType.DATE)
    private Date fvacaciones;
    @Temporal(TemporalType.DATE)
    private Date faguinaldo;
    private int diasaguianio;
    private float porcprimavac;
    private int diasvacpend;
    private int diasvactomadas;
    private int diasvacanteriores;
    private float diasagui;
    private float impagui;
    private float diasvac;
    private float impvac;
    private float diasprimavac;
    private float impprimavac;
    @Temporal(TemporalType.DATE)
    private Date fecharegistro;

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
     * @return the antdias
     */
    public int getAntdias() {
        return antdias;
    }

    /**
     * @param antdias the antdias to set
     */
    public void setAntdias(int antdias) {
        this.antdias = antdias;
    }

    /**
     * @return the antanios
     */
    public float getAntanios() {
        return antanios;
    }

    /**
     * @param antanios the antanios to set
     */
    public void setAntanios(float antanios) {
        this.antanios = antanios;
    }

    /**
     * @return the sueldodia
     */
    public float getSueldodia() {
        return sueldodia;
    }

    /**
     * @param sueldodia the sueldodia to set
     */
    public void setSueldodia(float sueldodia) {
        this.sueldodia = sueldodia;
    }

    /**
     * @return the fvacaciones
     */
    public Date getFvacaciones() {
        return fvacaciones;
    }

    /**
     * @param fvacaciones the fvacaciones to set
     */
    public void setFvacaciones(Date fvacaciones) {
        this.fvacaciones = fvacaciones;
    }

    /**
     * @return the faguinaldo
     */
    public Date getFaguinaldo() {
        return faguinaldo;
    }

    /**
     * @param faguinaldo the faguinaldo to set
     */
    public void setFaguinaldo(Date faguinaldo) {
        this.faguinaldo = faguinaldo;
    }

    /**
     * @return the diasaguianio
     */
    public int getDiasaguianio() {
        return diasaguianio;
    }

    /**
     * @param diasaguianio the diasaguianio to set
     */
    public void setDiasaguianio(int diasaguianio) {
        this.diasaguianio = diasaguianio;
    }

    /**
     * @return the porcprimavac
     */
    public float getPorcprimavac() {
        return porcprimavac;
    }

    /**
     * @param porcprimavac the porcprimavac to set
     */
    public void setPorcprimavac(float porcprimavac) {
        this.porcprimavac = porcprimavac;
    }

    /**
     * @return the diasvacpend
     */
    public int getDiasvacpend() {
        return diasvacpend;
    }

    /**
     * @param diasvacpend the diasvacpend to set
     */
    public void setDiasvacpend(int diasvacpend) {
        this.diasvacpend = diasvacpend;
    }

    /**
     * @return the diasvactomadas
     */
    public int getDiasvactomadas() {
        return diasvactomadas;
    }

    /**
     * @param diasvactomadas the diasvactomadas to set
     */
    public void setDiasvactomadas(int diasvactomadas) {
        this.diasvactomadas = diasvactomadas;
    }

    /**
     * @return the diasvacanteriores
     */
    public int getDiasvacanteriores() {
        return diasvacanteriores;
    }

    /**
     * @param diasvacanteriores the diasvacanteriores to set
     */
    public void setDiasvacanteriores(int diasvacanteriores) {
        this.diasvacanteriores = diasvacanteriores;
    }

    /**
     * @return the diasagui
     */
    public float getDiasagui() {
        return diasagui;
    }

    /**
     * @param diasagui the diasagui to set
     */
    public void setDiasagui(float diasagui) {
        this.diasagui = diasagui;
    }

    /**
     * @return the impagui
     */
    public float getImpagui() {
        return impagui;
    }

    /**
     * @param impagui the impagui to set
     */
    public void setImpagui(float impagui) {
        this.impagui = impagui;
    }

    /**
     * @return the diasvac
     */
    public float getDiasvac() {
        return diasvac;
    }

    /**
     * @param diasvac the diasvac to set
     */
    public void setDiasvac(float diasvac) {
        this.diasvac = diasvac;
    }

    /**
     * @return the impvac
     */
    public float getImpvac() {
        return impvac;
    }

    /**
     * @param impvac the impvac to set
     */
    public void setImpvac(float impvac) {
        this.impvac = impvac;
    }

    /**
     * @return the diasprimavac
     */
    public float getDiasprimavac() {
        return diasprimavac;
    }

    /**
     * @param diasprimavac the diasprimavac to set
     */
    public void setDiasprimavac(float diasprimavac) {
        this.diasprimavac = diasprimavac;
    }

    /**
     * @return the impprimavac
     */
    public float getImpprimavac() {
        return impprimavac;
    }

    /**
     * @param impprimavac the impprimavac to set
     */
    public void setImpprimavac(float impprimavac) {
        this.impprimavac = impprimavac;
    }

    /**
     * @return the fecharegistro
     */
    public Date getFecharegistro() {
        return fecharegistro;
    }

    /**
     * @param fecharegistro the fecharegistro to set
     */
    public void setFecharegistro(Date fecharegistro) {
        this.fecharegistro = fecharegistro;
    }
}
