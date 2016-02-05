/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.PerPagos;
import Modelo.Entidades.Catalogos.Puestos;
import java.util.Date;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "plazas")
public class Plaza {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column (name = "plaz_id")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Sucursal sucursal;
    @OneToOne (fetch = FetchType.EAGER)
    private PerPagos periodopago;
    @OneToOne (fetch = FetchType.EAGER)
    private Empleado empleado;
    @OneToOne (fetch = FetchType.EAGER)
    private Puestos puesto;
    @OneToOne (fetch = FetchType.EAGER)
    private Contrato contrato;
    @OneToOne (fetch = FetchType.EAGER)
    private Cliente cliente;
    @OneToOne (fetch = FetchType.EAGER)
    private CentroDeTrabajo ctrabajo;
    @Column (name = "plaz_tpago")
    private int formapago;
    @Column (name = "plaz_sueldo")
    private float sueldo;
    @Column (name = "plaz_compensacion")
    private float compensacion;
    @Column (name = "plaz_estatus")
    private int estatus;
    @Temporal(TemporalType.DATE)
    private Date fechaalta;
    @Temporal(TemporalType.DATE)
    private Date fechabaja;
    private int nivel;
    private float sueldocotiza;
    private float compensacioncotiza;

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
     * @return the sucursal
     */
    public Sucursal getSucursal() {
        return sucursal;
    }

    /**
     * @param sucursal the sucursal to set
     */
    public void setSucursal(Sucursal sucursal) {
        this.sucursal = sucursal;
    }

    /**
     * @return the periodopago
     */
    public PerPagos getPeriodopago() {
        return periodopago;
    }

    /**
     * @param periodopago the periodopago to set
     */
    public void setPeriodopago(PerPagos periodopago) {
        this.periodopago = periodopago;
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
     * @return the puesto
     */
    public Puestos getPuesto() {
        return puesto;
    }

    /**
     * @param puesto the puesto to set
     */
    public void setPuesto(Puestos puesto) {
        this.puesto = puesto;
    }

    /**
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
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
     * @return the ctrabajo
     */
    public CentroDeTrabajo getCtrabajo() {
        return ctrabajo;
    }

    /**
     * @param ctrabajo the ctrabajo to set
     */
    public void setCtrabajo(CentroDeTrabajo ctrabajo) {
        this.ctrabajo = ctrabajo;
    }

    /**
     * @return the formapago
     */
    public int getFormapago() {
        return formapago;
    }

    /**
     * @param formapago the formapago to set
     */
    public void setFormapago(int formapago) {
        this.formapago = formapago;
    }

    /**
     * @return the sueldo
     */
    public float getSueldo() {
        return sueldo;
    }

    /**
     * @param sueldo the sueldo to set
     */
    public void setSueldo(float sueldo) {
        this.sueldo = sueldo;
    }

    /**
     * @return the compensacion
     */
    public float getCompensacion() {
        return compensacion;
    }

    /**
     * @param compensacion the compensacion to set
     */
    public void setCompensacion(float compensacion) {
        this.compensacion = compensacion;
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
     * @return the nivel
     */
    public int getNivel() {
        return nivel;
    }

    /**
     * @param nivel the nivel to set
     */
    public void setNivel(int nivel) {
        this.nivel = nivel;
    }

    /**
     * @return the sueldocotiza
     */
    public float getSueldocotiza() {
        return sueldocotiza;
    }

    /**
     * @param sueldocotiza the sueldocotiza to set
     */
    public void setSueldocotiza(float sueldocotiza) {
        this.sueldocotiza = sueldocotiza;
    }

    /**
     * @return the compesacioncotiza
     */
    public float getCompensacioncotiza() {
        return compensacioncotiza;
    }

    /**
     * @param compensacioncotiza the compesacioncotiza to set
     */
    public void setCompensacioncotiza(float compensacioncotiza) {
        this.compensacioncotiza = compensacioncotiza;
    }
}