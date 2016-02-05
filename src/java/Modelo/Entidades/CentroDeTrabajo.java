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
@Table (name="ctrabajo")
public class CentroDeTrabajo {
    @Id
    @Column (name="ctra_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch=FetchType.EAGER)
    private Contrato contrato;
    @OneToOne (fetch=FetchType.EAGER)
    private Cliente cliente;
    @Column (name="ctra_nombre")
    private String nombre;
    @Column (name="ctra_personal")
    private float personal;
    @Column (name="ctra_diase")
    private int diasEntrega;
    @Column (name="ctra_topep")
    private float topeSueldos;
    @Column (name="ctra_topei")
    private float topeInsumos;
    @OneToOne (fetch=FetchType.EAGER)
    private Ruta ruta;
    @Column (name="ctra_observa")
    private String observaciones;
    @Column (name="estatus")
    private int estatus;
    @OneToOne (cascade=CascadeType.ALL, fetch=FetchType.EAGER)
    private DatosFiscales datosfiscales;
    @OneToOne (fetch=FetchType.EAGER)
    private Sucursal sucalterna;
    @OneToOne (fetch=FetchType.EAGER)
    private Ruta rutaalterna;
    private int surtidoexterno;
    @OneToOne (cascade=CascadeType.ALL, fetch=FetchType.EAGER)
    private Direccion direccion;
    private int configentrega;
    private int tipoentrega;

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
     * @return the personal
     */
    public float getPersonal() {
        return personal;
    }

    /**
     * @param personal the personal to set
     */
    public void setPersonal(float personal) {
        this.personal = personal;
    }

    /**
     * @return the diasEntrega
     */
    public int getDiasEntrega() {
        return diasEntrega;
    }

    /**
     * @param diasEntrega the diasEntrega to set
     */
    public void setDiasEntrega(int diasEntrega) {
        this.diasEntrega = diasEntrega;
    }

    /**
     * @return the topeSueldos
     */
    public float getTopeSueldos() {
        return topeSueldos;
    }

    /**
     * @param topeSueldos the topeSueldos to set
     */
    public void setTopeSueldos(float topeSueldos) {
        this.topeSueldos = topeSueldos;
    }

    /**
     * @return the topeInsumos
     */
    public float getTopeInsumos() {
        return topeInsumos;
    }

    /**
     * @param topeInsumos the topeInsumos to set
     */
    public void setTopeInsumos(float topeInsumos) {
        this.topeInsumos = topeInsumos;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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

    /**
     * @return the datosfiscales
     */
    public DatosFiscales getDatosfiscales() {
        return datosfiscales;
    }

    /**
     * @param datosfiscales the datosfiscales to set
     */
    public void setDatosfiscales(DatosFiscales datosfiscales) {
        this.datosfiscales = datosfiscales;
    }

    /**
     * @return the ruta
     */
    public Ruta getRuta() {
        return ruta;
    }

    /**
     * @param ruta the ruta to set
     */
    public void setRuta(Ruta ruta) {
        this.ruta = ruta;
    }

    /**
     * @return the sucalterna
     */
    public Sucursal getSucalterna() {
        return sucalterna;
    }

    /**
     * @param sucalterna the sucalterna to set
     */
    public void setSucalterna(Sucursal sucalterna) {
        this.sucalterna = sucalterna;
    }

    /**
     * @return the rutaalterna
     */
    public Ruta getRutaalterna() {
        return rutaalterna;
    }

    /**
     * @param rutaalterna the rutaalterna to set
     */
    public void setRutaalterna(Ruta rutaalterna) {
        this.rutaalterna = rutaalterna;
    }

    /**
     * @return the surtidoexterno
     */
    public int getSurtidoexterno() {
        return surtidoexterno;
    }

    /**
     * @param surtidoexterno the surtidoexterno to set
     */
    public void setSurtidoexterno(int surtidoexterno) {
        this.surtidoexterno = surtidoexterno;
    }

    /**
     * @return the direccion
     */
    public Direccion getDireccion() {
        return direccion;
    }

    /**
     * @param direccion the direccion to set
     */
    public void setDireccion(Direccion direccion) {
        this.direccion = direccion;
    }

    /**
     * @return the configentrega
     */
    public int getConfigentrega() {
        return configentrega;
    }

    /**
     * @param configentrega the configentrega to set
     */
    public void setConfigentrega(int configentrega) {
        this.configentrega = configentrega;
    }

    /**
     * @return the tipoentrega
     */
    public int getTipoentrega() {
        return tipoentrega;
    }

    /**
     * @param tipoentrega the tipoentrega to set
     */
    public void setTipoentrega(int tipoentrega) {
        this.tipoentrega = tipoentrega;
    }
}
