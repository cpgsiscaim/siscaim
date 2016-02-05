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
@Table (name="contratos")
public class Contrato {
    @Id
    @Column (name="id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch=FetchType.EAGER)
    private Cliente cliente;
    @Column (name="contrato")
    private String contrato;
    @Column (name="fechaini")
    @Temporal(TemporalType.DATE)
    private Date fechaIni;
    @Column (name="fechafin")
    @Temporal(TemporalType.DATE)
    private Date fechaFin;
    @Column (name="estatus")
    private int estatus;
    @Column (name="descri")
    private String descripcion;
    @Column (name="observa")
    private String observaciones;
    @Column (name="numerof")
    private String numfianza;
    @Column (name="importef")
    private float importeFianza;
    @Column (name="fechaf")
    @Temporal(TemporalType.DATE)
    private Date fechaFianza;
    @Column (name="estatusf")
    private int estatusFianza;
    @Column (name="observaf")
    private String observacionFianza;
    @Column (name="facturarCT")
    private int facturarCT;
    @OneToOne (fetch=FetchType.EAGER)
    private Sucursal sucursal;
    private int tipoentrega;
    private int diasentrega;
    private int especialidad; //1=jardineria, 2=limpieza, 3=fumigacion, 4=jardineria y limpieza, 5=jardineria y fumigacion, 6=limpieza y fumigacion, 7=todos
    private int documento;
    private int totalpersonal;
    private int docfianza;
    
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
     * @return the contrato
     */
    public String getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(String contrato) {
        this.contrato = contrato;
    }

    /**
     * @return the fechaIni
     */
    public Date getFechaIni() {
        return fechaIni;
    }

    /**
     * @param fechaIni the fechaIni to set
     */
    public void setFechaIni(Date fechaIni) {
        this.fechaIni = fechaIni;
    }

    /**
     * @return the fechaFin
     */
    public Date getFechaFin() {
        return fechaFin;
    }

    /**
     * @param fechaFin the fechaFin to set
     */
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
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
     * @return the numfianza
     */
    public String getNumfianza() {
        return numfianza;
    }

    /**
     * @param numfianza the numfianza to set
     */
    public void setNumfianza(String numfianza) {
        this.numfianza = numfianza;
    }

    /**
     * @return the importeFianza
     */
    public float getImporteFianza() {
        return importeFianza;
    }

    /**
     * @param importeFianza the importeFianza to set
     */
    public void setImporteFianza(float importeFianza) {
        this.importeFianza = importeFianza;
    }

    /**
     * @return the fechaFianza
     */
    public Date getFechaFianza() {
        return fechaFianza;
    }

    /**
     * @param fechaFianza the fechaFianza to set
     */
    public void setFechaFianza(Date fechaFianza) {
        this.fechaFianza = fechaFianza;
    }

    /**
     * @return the estatusFianza
     */
    public int getEstatusFianza() {
        return estatusFianza;
    }

    /**
     * @param estatusFianza the estatusFianza to set
     */
    public void setEstatusFianza(int estatusFianza) {
        this.estatusFianza = estatusFianza;
    }

    /**
     * @return the observacionFianza
     */
    public String getObservacionFianza() {
        return observacionFianza;
    }

    /**
     * @param observacionFianza the observacionFianza to set
     */
    public void setObservacionFianza(String observacionFianza) {
        this.observacionFianza = observacionFianza;
    }

    /**
     * @return the facturarCT
     */
    public int getFacturarCT() {
        return facturarCT;
    }

    /**
     * @param facturarCT the facturarCT to set
     */
    public void setFacturarCT(int facturarCT) {
        this.facturarCT = facturarCT;
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
     * @return the especialidad
     */
    public int getEspecialidad() {
        return especialidad;
    }

    /**
     * @param especialidad the especialidad to set
     */
    public void setEspecialidad(int especialidad) {
        this.especialidad = especialidad;
    }

    /**
     * @return the documento
     */
    public int getDocumento() {
        return documento;
    }

    /**
     * @param documento the documento to set
     */
    public void setDocumento(int documento) {
        this.documento = documento;
    }

    /**
     * @return the totalpersonal
     */
    public int getTotalpersonal() {
        return totalpersonal;
    }

    /**
     * @param totalpersonal the totalpersonal to set
     */
    public void setTotalpersonal(int totalpersonal) {
        this.totalpersonal = totalpersonal;
    }

    /**
     * @return the docfianza
     */
    public int getDocfianza() {
        return docfianza;
    }

    /**
     * @param docfianza the docfianza to set
     */
    public void setDocfianza(int docfianza) {
        this.docfianza = docfianza;
    }
    
}
