/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import java.util.Date;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="clientes")
public class Cliente {
    
    @Id
    @Column (name="clie_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    
    @OneToOne (cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private DatosFiscales datosFiscales;
    
    @OneToOne (fetch = FetchType.EAGER)
    private Sucursal sucursal;
    @OneToOne (fetch = FetchType.EAGER)
    private Agente agente;
    @OneToOne (fetch = FetchType.EAGER)
    private Ruta ruta;
    
    @Column (name="clie_desc1")
    private float descuento1;
    @Column (name="clie_desc2")
    private float descuento2;
    @Column (name="clie_desc3")
    private float descuento3;
    @Column (name="clie_plazo")
    private int plazo;
    @Column (name="clie_limitec")
    private float limite;
    @Temporal(TemporalType.DATE)
    @Column (name="clie_fecalta")
    private Date fechaAlta;
    @Column (name="clie_lprecio")
    private int listaPrecios;
    @Column (name="estatus")
    private int estatus;
    @Column (name="tipo")
    private int tipo;
    private int cglobal;
    private String prefijo;
    private String nombrecompleto;

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
     * @return the datosFiscales
     */
    public DatosFiscales getDatosFiscales() {
        return datosFiscales;
    }

    /**
     * @param datosFiscales the datosFiscales to set
     */
    public void setDatosFiscales(DatosFiscales datosFiscales) {
        this.datosFiscales = datosFiscales;
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
     * @return the descuento1
     */
    public float getDescuento1() {
        return descuento1;
    }

    /**
     * @param descuento1 the descuento1 to set
     */
    public void setDescuento1(float descuento1) {
        this.descuento1 = descuento1;
    }

    /**
     * @return the descuento2
     */
    public float getDescuento2() {
        return descuento2;
    }

    /**
     * @param descuento2 the descuento2 to set
     */
    public void setDescuento2(float descuento2) {
        this.descuento2 = descuento2;
    }

    /**
     * @return the descuento3
     */
    public float getDescuento3() {
        return descuento3;
    }

    /**
     * @param descuento3 the descuento3 to set
     */
    public void setDescuento3(float descuento3) {
        this.descuento3 = descuento3;
    }

    /**
     * @return the plazo
     */
    public int getPlazo() {
        return plazo;
    }

    /**
     * @param plazo the plazo to set
     */
    public void setPlazo(int plazo) {
        this.plazo = plazo;
    }

    /**
     * @return the limite
     */
    public float getLimite() {
        return limite;
    }

    /**
     * @param limite the limite to set
     */
    public void setLimite(float limite) {
        this.limite = limite;
    }

    /**
     * @return the fechaAlta
     */
    public Date getFechaAlta() {
        return fechaAlta;
    }

    /**
     * @param fechaAlta the fechaAlta to set
     */
    public void setFechaAlta(Date fechaAlta) {
        this.fechaAlta = fechaAlta;
    }

    /**
     * @return the listaPrecios
     */
    public int getListaPrecios() {
        return listaPrecios;
    }

    /**
     * @param listaPrecios the listaPrecios to set
     */
    public void setListaPrecios(int listaPrecios) {
        this.listaPrecios = listaPrecios;
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
     * @return the agente
     */
    public Agente getAgente() {
        return agente;
    }

    /**
     * @param agente the agente to set
     */
    public void setAgente(Agente agente) {
        this.agente = agente;
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
     * @return the tipo
     */
    public int getTipo() {
        return tipo;
    }

    /**
     * @param tipo the tipo to set
     */
    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    /**
     * @return the global
     */
    public int getCglobal() {
        return cglobal;
    }

    /**
     * @param global the global to set
     */
    public void setCglobal(int cglobal) {
        this.cglobal = cglobal;
    }

    /**
     * @return the prefijo
     */
    public String getPrefijo() {
        return prefijo;
    }

    /**
     * @param prefijo the prefijo to set
     */
    public void setPrefijo(String prefijo) {
        this.prefijo = prefijo;
    }

    /**
     * @return the nombrecompleto
     */
    public String getNombrecompleto() {
        return nombrecompleto;
    }

    /**
     * @param nombrecompleto the nombrecompleto to set
     */
    public void setNombrecompleto(String nombrecompleto) {
        this.nombrecompleto = nombrecompleto;
    }
    
}
