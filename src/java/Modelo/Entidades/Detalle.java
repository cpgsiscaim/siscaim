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
@Table (name="detalle")
public class Detalle implements Cloneable{
    @Id
    @Column (name="deta_id")
    private int id;
    @OneToOne (fetch=FetchType.EAGER)
    private Cabecera cabecera;
    @OneToOne (fetch=FetchType.EAGER)
    private Almacen almacen;
    @OneToOne (fetch=FetchType.EAGER)
    private Sucursal sucursal;
    @OneToOne (fetch=FetchType.EAGER)
    private Categoria categoria;
    @OneToOne (fetch=FetchType.EAGER)
    private Subcategoria subcategoria;
    @OneToOne (fetch=FetchType.EAGER)
    private Ubicacion ubicacion;
    @OneToOne (fetch=FetchType.EAGER)
    private Producto producto;
    @OneToOne (fetch=FetchType.EAGER)
    private Unidad unidad;
    @Column (name="deta_descripcion")
    private String descripcion;
    @Column (name="deta_cantidad")
    private float cantidad;
    @Column (name="deta_precio")
    private float precio;
    @Column (name="deta_costo")
    private float costo;
    @Column (name="deta_cultimo")
    private float costoUltimo;
    @Column (name="deta_cpromedio")
    private float costoPromedio;
    @Column (name="deta_cactualiza")
    private float costoActual;
    @Column (name="deta_desc1")
    private float descuento1;
    @Column (name="deta_desc2")
    private float descuento2;
    @Column (name="deta_desc3")
    private float descuento3;
    @Column (name="deta_desc4")
    private float descuento4;
    @Column (name="deta_desc5")
    private float descuento5;
    @Column (name="deta_importe")
    private float importe;
    @Column (name="deta_descuento")
    private float descuento;
    @Column (name="deta_iva")
    private float iva;
    @Column (name="deta_ieps")
    private float ieps;
    @Column (name="deta_ivae")
    private float ivaExtranjero;
    @Column (name="deta_lprecio")
    private int listaPrecios;
    @Column (name="deta_invmov")
    private int invmov; //??
    @Column (name="deta_cantinv")
    private float cantidadInventario;
    @Column (name="estatus")
    private int estatus;
    private int cambio;
    private int auto;
    private int imprimir;

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
     * @return the cabecera
     */
    public Cabecera getCabecera() {
        return cabecera;
    }

    /**
     * @param cabecera the cabecera to set
     */
    public void setCabecera(Cabecera cabecera) {
        this.cabecera = cabecera;
    }

    /**
     * @return the almacen
     */
    public Almacen getAlmacen() {
        return almacen;
    }

    /**
     * @param almacen the almacen to set
     */
    public void setAlmacen(Almacen almacen) {
        this.almacen = almacen;
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
     * @return the ubicacion
     */
    public Ubicacion getUbicacion() {
        return ubicacion;
    }

    /**
     * @param ubicacion the ubicacion to set
     */
    public void setUbicacion(Ubicacion ubicacion) {
        this.ubicacion = ubicacion;
    }

    /**
     * @return the producto
     */
    public Producto getProducto() {
        return producto;
    }

    /**
     * @param producto the producto to set
     */
    public void setProducto(Producto producto) {
        this.producto = producto;
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
     * @return the cantidad
     */
    public float getCantidad() {
        return cantidad;
    }

    /**
     * @param cantidad the cantidad to set
     */
    public void setCantidad(float cantidad) {
        this.cantidad = cantidad;
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
     * @return the costo
     */
    public float getCosto() {
        return costo;
    }

    /**
     * @param costo the costo to set
     */
    public void setCosto(float costo) {
        this.costo = costo;
    }

    /**
     * @return the costoUltimo
     */
    public float getCostoUltimo() {
        return costoUltimo;
    }

    /**
     * @param costoUltimo the costoUltimo to set
     */
    public void setCostoUltimo(float costoUltimo) {
        this.costoUltimo = costoUltimo;
    }

    /**
     * @return the costoPromedio
     */
    public float getCostoPromedio() {
        return costoPromedio;
    }

    /**
     * @param costoPromedio the costoPromedio to set
     */
    public void setCostoPromedio(float costoPromedio) {
        this.costoPromedio = costoPromedio;
    }

    /**
     * @return the costoActual
     */
    public float getCostoActual() {
        return costoActual;
    }

    /**
     * @param costoActual the costoActual to set
     */
    public void setCostoActual(float costoActual) {
        this.costoActual = costoActual;
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
     * @return the importe
     */
    public float getImporte() {
        return importe;
    }

    /**
     * @param importe the importe to set
     */
    public void setImporte(float importe) {
        this.importe = importe;
    }

    /**
     * @return the descuento
     */
    public float getDescuento() {
        return descuento;
    }

    /**
     * @param descuento the descuento to set
     */
    public void setDescuento(float descuento) {
        this.descuento = descuento;
    }

    /**
     * @return the iva
     */
    public float getIva() {
        return iva;
    }

    /**
     * @param iva the iva to set
     */
    public void setIva(float iva) {
        this.iva = iva;
    }

    /**
     * @return the ieps
     */
    public float getIeps() {
        return ieps;
    }

    /**
     * @param ieps the ieps to set
     */
    public void setIeps(float ieps) {
        this.ieps = ieps;
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
     * @return the invmov
     */
    public int getInvmov() {
        return invmov;
    }

    /**
     * @param invmov the invmov to set
     */
    public void setInvmov(int invmov) {
        this.invmov = invmov;
    }

    /**
     * @return the cantidadInventario
     */
    public float getCantidadInventario() {
        return cantidadInventario;
    }

    /**
     * @param cantidadInventario the cantidadInventario to set
     */
    public void setCantidadInventario(float cantidadInventario) {
        this.cantidadInventario = cantidadInventario;
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
     * @return the cambio
     */
    public int getCambio() {
        return cambio;
    }

    /**
     * @param cambio the cambio to set
     */
    public void setCambio(int cambio) {
        this.cambio = cambio;
    }

    /**
     * @return the auto
     */
    public int getAuto() {
        return auto;
    }

    /**
     * @param auto the auto to set
     */
    public void setAuto(int auto) {
        this.auto = auto;
    }
    
    public Object clone()
    {
        Object clone = null;
        try
        {
            clone = super.clone();
        } 
        catch(CloneNotSupportedException e)
        {
            // No deberia ocurrir
        }
        return clone;
    }

    /**
     * @return the imprimir
     */
    public int getImprimir() {
        return imprimir;
    }

    /**
     * @param imprimir the imprimir to set
     */
    public void setImprimir(int imprimir) {
        this.imprimir = imprimir;
    }
}
