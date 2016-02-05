/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import java.util.Date;
import javax.persistence.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="proveedores")
public class Proveedor {
    @Id
    @Column (name="prov_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne(fetch=FetchType.LAZY)
    @Fetch(FetchMode.JOIN)
    private Sucursal sucursal;
    @OneToOne(cascade = CascadeType.ALL, fetch=FetchType.EAGER)
    private DatosFiscales datosfiscales;
    @OneToOne(fetch=FetchType.EAGER)
    private Direccion direccion;
    @Column (name="prov_banco")
    private String banco;
    @Column (name="prov_ctadep")
    private String cuentaBanco;
    @Column (name="prov_sucursal")
    private String sucursalBanco;
    @Column (name="prov_tipo")
    private String tipo;
    @Column (name="prov_desc1")
    private float descuento1;
    @Column (name="prov_desc2")
    private float descuento2;
    @Column (name="prov_desc3")
    private float descuento3;
    @Column (name="prov_plazo")
    private int plazo;
    @Column (name="prov_iva")
    private int iva;
    @Column (name="prov_lprecio")
    private int listaPrecio;
    @Column (name="prov_observa")
    private String observaciones;
    @Column (name="prov_fecalta")
    @Temporal(TemporalType.DATE)
    private Date fechaAlta;
    @Column (name="prov_cuenta")
    private String cuenta;
    @Column (name="estatus")
    private int estatus;
    private int nacional; //define si el proveedor es nacional o local
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
     * @return the banco
     */
    public String getBanco() {
        return banco;
    }

    /**
     * @param banco the banco to set
     */
    public void setBanco(String banco) {
        this.banco = banco;
    }

    /**
     * @return the cuentaBanco
     */
    public String getCuentaBanco() {
        return cuentaBanco;
    }

    /**
     * @param cuentaBanco the cuentaBanco to set
     */
    public void setCuentaBanco(String cuentaBanco) {
        this.cuentaBanco = cuentaBanco;
    }

    /**
     * @return the sucursalBanco
     */
    public String getSucursalBanco() {
        return sucursalBanco;
    }

    /**
     * @param sucursalBanco the sucursalBanco to set
     */
    public void setSucursalBanco(String sucursalBanco) {
        this.sucursalBanco = sucursalBanco;
    }

    /**
     * @return the tipo
     */
    public String getTipo() {
        return tipo;
    }

    /**
     * @param tipo the tipo to set
     */
    public void setTipo(String tipo) {
        this.tipo = tipo;
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
     * @return the iva
     */
    public int getIva() {
        return iva;
    }

    /**
     * @param iva the iva to set
     */
    public void setIva(int iva) {
        this.iva = iva;
    }

    /**
     * @return the lprecio
     */
    public int getListaPrecio() {
        return listaPrecio;
    }

    /**
     * @param lprecio the lprecio to set
     */
    public void setListaPrecio(int lprecio) {
        this.listaPrecio = lprecio;
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
     * @return the cuenta
     */
    public String getCuenta() {
        return cuenta;
    }

    /**
     * @param cuenta the cuenta to set
     */
    public void setCuenta(String cuenta) {
        this.cuenta = cuenta;
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
     * @return the nacional
     */
    public int getNacional() {
        return nacional;
    }

    /**
     * @param nacional the nacional to set
     */
    public void setNacional(int nacional) {
        this.nacional = nacional;
    }
}
