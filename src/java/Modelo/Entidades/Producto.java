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
@Table (name="productos")
public class Producto {
    @Id
    @Column (name="prod_id")
    @GeneratedValue (strategy= GenerationType.IDENTITY)
    private int id;
    @Column (name="prod_clave")
    private String clave;
    @OneToOne (fetch=FetchType.EAGER)
    private Marca marca;
    @OneToOne (fetch=FetchType.EAGER)
    private Unidad unidad;
    @OneToOne (fetch=FetchType.EAGER)
    private Categoria categoria;
    @OneToOne (fetch=FetchType.EAGER)
    private Subcategoria subcategoria;
    @OneToOne (fetch=FetchType.LAZY)
    @Fetch(FetchMode.JOIN)
    private Proveedor proveedor;
    @Column (name="prod_descripcion")
    private String descripcion;
    /*
    @Column (name="prod_cultimo")
    private float costoUltimo;
    @Column (name="prod_cpromedio")
    private float costoPromedio;
    @Column (name="prod_cactualiza")
    private float costoActual;*/
    @Column (name="prod_maximo")
    private float stockMaximo;
    @Column (name="prod_minimo")
    private float stockMinimo;
    @Column (name="prod_iep")
    private float iep;
    @Column (name="prod_ivan")
    private float ivaNacional;
    @Column (name="prod_ivae")
    private float ivaExtranjero;
    /*@Column (name="prod_peso")
    private float peso;
    */
    @Column (name="prod_descmax")
    private float descuentoMaximo;
    @Column (name="prod_estatus")
    private int estatus;
    @Column (name="prod_alterno")
    private String codigoAlterno;
    @Column (name="prod_servicio")
    private int servicio;
    /*
    @Column (name="prod_precio1")
    private float precio1;
    @Column (name="prod_precio2")
    private float precio2;
    @Column (name="prod_precio3")
    private float precio3;
    @Column (name="prod_precio4")
    private float precio4;
    @Column (name="prod_precio5")
    private float precio5;
    */
    @Column (name="prod_desc1")
    private float descuento1;
    @Column (name="prod_desc2")
    private float descuento2;
    @Column (name="prod_desc3")
    private float descuento3;
    @Column (name="prod_desc4")
    private float descuento4;
    @Column (name="prod_desc5")
    private float descuento5;
    @Temporal(TemporalType.DATE)
    @Column (name="prod_fucompra")
    private Date fechaUltCompra;
    @Temporal(TemporalType.DATE)
    @Column (name="prod_fuventa")
    private Date fechaUltVenta;
    /*@OneToOne (fetch = FetchType.EAGER)
    private Sucursal sucursal;*/
    private int tipo;
    private int aplicarcosto;
    private int aplicarprecios;
    private int surtido; //1 en matriz, 2 en sucursales
    
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
     * @return the clave
     */
    public String getClave() {
        return clave;
    }

    /**
     * @param clave the clave to set
     */
    public void setClave(String clave) {
        this.clave = clave;
    }

    /**
     * @return the marca
     */
    public Marca getMarca() {
        return marca;
    }

    /**
     * @param marca the marca to set
     */
    public void setMarca(Marca marca) {
        this.marca = marca;
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
     * @return the categoria
     */
    public Categoria getCategoria() {
        return categoria;
    }

    /**
     * @param categoria the categoria to set
     */
    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }

    /**
     * @return the subcategoria
     */
    public Subcategoria getSubcategoria() {
        return subcategoria;
    }

    /**
     * @param subcategoria the subcategoria to set
     */
    public void setSubcategoria(Subcategoria subcategoria) {
        this.subcategoria = subcategoria;
    }

    /**
     * @return the proveedor
     */
    public Proveedor getProveedor() {
        return proveedor;
    }

    /**
     * @param proveedor the proveedor to set
     */
    public void setProveedor(Proveedor proveedor) {
        this.proveedor = proveedor;
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
     * @return the costoUltimo
     */
    /*public float getCostoUltimo() {
        return costoUltimo;
    }*/

    /**
     * @param costoUltimo the costoUltimo to set
     */
    /*public void setCostoUltimo(float costoUltimo) {
        this.costoUltimo = costoUltimo;
    }*/

    /**
     * @return the costoPromedio
     */
    /*public float getCostoPromedio() {
        return costoPromedio;
    }*/

    /**
     * @param costoPromedio the costoPromedio to set
     */
    /*public void setCostoPromedio(float costoPromedio) {
        this.costoPromedio = costoPromedio;
    }*/

    /**
     * @return the costoActual
     */
    /*public float getCostoActual() {
        return costoActual;
    }*/

    /**
     * @param costoActual the costoActual to set
     */
    /*public void setCostoActual(float costoActual) {
        this.costoActual = costoActual;
    }*/

    /**
     * @return the stockMaximo
     */
    public float getStockMaximo() {
        return stockMaximo;
    }

    /**
     * @param stockMaximo the stockMaximo to set
     */
    public void setStockMaximo(float stockMaximo) {
        this.stockMaximo = stockMaximo;
    }

    /**
     * @return the stockMinimo
     */
    public float getStockMinimo() {
        return stockMinimo;
    }

    /**
     * @param stockMinimo the stockMinimo to set
     */
    public void setStockMinimo(float stockMinimo) {
        this.stockMinimo = stockMinimo;
    }

    /**
     * @return the iep
     */
    public float getIep() {
        return iep;
    }

    /**
     * @param iep the iep to set
     */
    public void setIep(float iep) {
        this.iep = iep;
    }

    /**
     * @return the ivaNacional
     */
    public float getIvaNacional() {
        return ivaNacional;
    }

    /**
     * @param ivaNacional the ivaNacional to set
     */
    public void setIvaNacional(float ivaNacional) {
        this.ivaNacional = ivaNacional;
    }

    /**
     * @return the ivaExtranjero
     */
    public float getIvaExtranjero() {
        return ivaExtranjero;
    }

    /**
     * @param ivaExtranjero the ivaExtranjero to set
     */
    public void setIvaExtranjero(float ivaExtranjero) {
        this.ivaExtranjero = ivaExtranjero;
    }

    /**
     * @return the peso
     */
    /*public float getPeso() {
        return peso;
    }*/

    /**
     * @param peso the peso to set
     */
    /*public void setPeso(float peso) {
        this.peso = peso;
    }*/

    /**
     * @return the descuentoMaximo
     */
    public float getDescuentoMaximo() {
        return descuentoMaximo;
    }

    /**
     * @param descuentoMaximo the descuentoMaximo to set
     */
    public void setDescuentoMaximo(float descuentoMaximo) {
        this.descuentoMaximo = descuentoMaximo;
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
     * @return the codigoAlterno
     */
    public String getCodigoAlterno() {
        return codigoAlterno;
    }

    /**
     * @param codigoAlterno the codigoAlterno to set
     */
    public void setCodigoAlterno(String codigoAlterno) {
        this.codigoAlterno = codigoAlterno;
    }

    /**
     * @return the servicio
     */
    public int getServicio() {
        return servicio;
    }

    /**
     * @param servicio the servicio to set
     */
    public void setServicio(int servicio) {
        this.servicio = servicio;
    }

    /**
     * @return the precio1
     */
    /*public float getPrecio1() {
        return precio1;
    }*/

    /**
     * @param precio1 the precio1 to set
     */
    /*public void setPrecio1(float precio1) {
        this.precio1 = precio1;
    }*/

    /**
     * @return the precio2
     */
    /*public float getPrecio2() {
        return precio2;
    }*/

    /**
     * @param precio2 the precio2 to set
     */
    /*public void setPrecio2(float precio2) {
        this.precio2 = precio2;
    }*/

    /**
     * @return the precio3
     */
    /*public float getPrecio3() {
        return precio3;
    }*/

    /**
     * @param precio3 the precio3 to set
     */
    /*public void setPrecio3(float precio3) {
        this.precio3 = precio3;
    }*/

    /**
     * @return the precio4
     */
    /*public float getPrecio4() {
        return precio4;
    }*/

    /**
     * @param precio4 the precio4 to set
     */
    /*public void setPrecio4(float precio4) {
        this.precio4 = precio4;
    }*/

    /**
     * @return the precio5
     */
    /*public float getPrecio5() {
        return precio5;
    }*/

    /**
     * @param precio5 the precio5 to set
     */
    /*public void setPrecio5(float precio5) {
        this.precio5 = precio5;
    }*/

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
     * @return the descuento4
     */
    public float getDescuento4() {
        return descuento4;
    }

    /**
     * @param descuento4 the descuento4 to set
     */
    public void setDescuento4(float descuento4) {
        this.descuento4 = descuento4;
    }

    /**
     * @return the descuento5
     */
    public float getDescuento5() {
        return descuento5;
    }

    /**
     * @param descuento5 the descuento5 to set
     */
    public void setDescuento5(float descuento5) {
        this.descuento5 = descuento5;
    }

    /**
     * @return the fechaUltCompra
     */
    public Date getFechaUltCompra() {
        return fechaUltCompra;
    }

    /**
     * @param fechaUltCompra the fechaUltCompra to set
     */
    public void setFechaUltCompra(Date fechaUltCompra) {
        this.fechaUltCompra = fechaUltCompra;
    }

    /**
     * @return the fechaUltVenta
     */
    public Date getFechaUltVenta() {
        return fechaUltVenta;
    }

    /**
     * @param fechaUltVenta the fechaUltVenta to set
     */
    public void setFechaUltVenta(Date fechaUltVenta) {
        this.fechaUltVenta = fechaUltVenta;
    }

    /**
     * @return the sucursal
     *
    public Sucursal getSucursal() {
        return sucursal;
    }

    /**
     * @param sucursal the sucursal to set
     *
    public void setSucursal(Sucursal sucursal) {
        this.sucursal = sucursal;
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
     * @return the aplicarcosto
     */
    public int getAplicarcosto() {
        return aplicarcosto;
    }

    /**
     * @param aplicarcosto the aplicarcosto to set
     */
    public void setAplicarcosto(int aplicarcosto) {
        this.aplicarcosto = aplicarcosto;
    }

    /**
     * @return the aplicarprecios
     */
    public int getAplicarprecios() {
        return aplicarprecios;
    }

    /**
     * @param aplicarprecios the aplicarprecios to set
     */
    public void setAplicarprecios(int aplicarprecios) {
        this.aplicarprecios = aplicarprecios;
    }

    /**
     * @return the surtido
     */
    public int getSurtido() {
        return surtido;
    }

    /**
     * @param surtido the surtido to set
     */
    public void setSurtido(int surtido) {
        this.surtido = surtido;
    }
}
