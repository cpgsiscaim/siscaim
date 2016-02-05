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
@Table (name = "prodxct")
public class ProductosCt {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "prodct_id")
    private int id;
    @OneToOne (fetch = FetchType.LAZY)
    private Contrato contrato;
    @OneToOne (fetch = FetchType.LAZY)
    private Cliente cliente;
    @OneToOne (fetch = FetchType.EAGER)
    private Producto producto;
    @Column (name = "prod_tipo")
    private int tipo;
    @Column (name = "prod_descripcion")
    private String descripcion;
    @Column (name = "prod_lprecio")
    private int listaprecios;
    @Column (name = "prod_cantidad")
    private float cantidad;
    @OneToOne (fetch = FetchType.LAZY)
    private CentroDeTrabajo centrotrab;
    @Column (name = "prod_categoria")
    private int categoria;
    @Column (name = "prod_estatus")
    private int estatus;
    @OneToOne (fetch = FetchType.EAGER)
    private Unidad unidad;
    @OneToOne (fetch = FetchType.EAGER)
    private Almacen almacen;
    @Column (name = "prod_precio")
    private float precio;
    private int configentrega;
    private int tipoentrega;
    private int diasentrega;
    private int imprimir;//0=no se imprime en reporte de prods x ct, 1=sí se imprime
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
     * @return the listaprecios
     */
    public int getListaprecios() {
        return listaprecios;
    }

    /**
     * @param listaprecios the listaprecios to set
     */
    public void setListaprecios(int listaprecios) {
        this.listaprecios = listaprecios;
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
     * @return the centrotrab
     */
    public CentroDeTrabajo getCentrotrab() {
        return centrotrab;
    }

    /**
     * @param centrotrab the centrotrab to set
     */
    public void setCentrotrab(CentroDeTrabajo centrotrab) {
        this.centrotrab = centrotrab;
    }

    /**
     * @return the categoria
     */
    public int getCategoria() {
        return categoria;
    }

    /**
     * @param categoria the categoria to set
     */
    public void setCategoria(int categoria) {
        this.categoria = categoria;
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

    /**
     * @return the diasentrega
     */
    public int getDiasentrega() {
        return diasentrega;
    }

    /**
     * @param diasentrega the diasentrega to set
     */
    public void setDiasentrega(int diasentrega) {
        this.diasentrega = diasentrega;
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
