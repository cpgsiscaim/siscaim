/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.TipoActivo;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="equipos")
public class Equipo {
    @Id
    @GeneratedValue (strategy=GenerationType.IDENTITY)
    @Column (name="equi_id")
    private int id;
    @Column (name="equi_codigo")
    private String codigo;
    @Column (name="equi_descri")
    private String descripcion;
    @Column (name="equi_placa")
    private String placa;
    @Column (name="equi_serie")
    private String serie;
    @Column (name="equi_motor")
    private String motor;
    @Column (name="equi_modelo")
    private String modelo;
    @Column (name="equi_factura")
    private String factura;
    @Column (name="equi_precio")
    private float precio;
    @Column (name="equi_caracteristicas")
    private String caracteristicas;
    @OneToOne (fetch=FetchType.EAGER)
    private TipoActivo tipoactivo;
    private int estatus;
    @OneToOne (fetch=FetchType.EAGER)
    private Sucursal sucursal;
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
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the placa
     */
    public String getPlaca() {
        return placa;
    }

    /**
     * @param placa the placa to set
     */
    public void setPlaca(String placa) {
        this.placa = placa;
    }

    /**
     * @return the serie
     */
    public String getSerie() {
        return serie;
    }

    /**
     * @param serie the serie to set
     */
    public void setSerie(String serie) {
        this.serie = serie;
    }

    /**
     * @return the motor
     */
    public String getMotor() {
        return motor;
    }

    /**
     * @param motor the motor to set
     */
    public void setMotor(String motor) {
        this.motor = motor;
    }

    /**
     * @return the modelo
     */
    public String getModelo() {
        return modelo;
    }

    /**
     * @param modelo the modelo to set
     */
    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    /**
     * @return the factura
     */
    public String getFactura() {
        return factura;
    }

    /**
     * @param factura the factura to set
     */
    public void setFactura(String factura) {
        this.factura = factura;
    }

    /**
     * @return the precio
     */
    public float getPrecio() {
        return precio;
    }

    /**
     * @param precio the precio to set
     */
    public void setPrecio(float precio) {
        this.precio = precio;
    }

    /**
     * @return the caracteristicas
     */
    public String getCaracteristicas() {
        return caracteristicas;
    }

    /**
     * @param caracteristicas the caracteristicas to set
     */
    public void setCaracteristicas(String caracteristicas) {
        this.caracteristicas = caracteristicas;
    }

    /**
     * @return the tipoactivo
     */
    public TipoActivo getTipoactivo() {
        return tipoactivo;
    }

    /**
     * @param tipoactivo the tipoactivo to set
     */
    public void setTipoactivo(TipoActivo tipoactivo) {
        this.tipoactivo = tipoactivo;
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
}
