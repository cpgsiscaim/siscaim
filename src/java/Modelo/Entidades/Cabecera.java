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
@Table (name="cabecera")
public class Cabecera {
    @Id
    @Column (name="cabe_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch=FetchType.EAGER)
    private Agente agente;
    @OneToOne (fetch=FetchType.EAGER)
    private Serie serie;
    @Column (name="cabe_folio")
    private int folio;
    @OneToOne (fetch=FetchType.EAGER)
    private TipoMov tipomov;
    @OneToOne (fetch=FetchType.EAGER)
    private Cliente cliente;
    @OneToOne (fetch=FetchType.EAGER)
    private Proveedor proveedor;
    @OneToOne (fetch=FetchType.EAGER)
    private Contrato contrato;
    @OneToOne (fetch=FetchType.EAGER)
    private Sucursal sucursal;
    @OneToOne (fetch=FetchType.EAGER)
    private CentroDeTrabajo centrotrabajo;
    @Column (name="cabe_fecinv")
    @Temporal(TemporalType.DATE)
    private Date fechaInventario;
    @Column (name="cabe_fecrec")
    @Temporal(TemporalType.DATE)
    private Date fechaRecepcion;
    @Column (name="cabe_fecha")
    @Temporal(TemporalType.DATE)
    private Date fechaCaptura;
    @Column (name="cabe_estatus")
    private int estatus;
    @Column (name="cabe_serori")
    private String serieOriginal;
    @Column (name="cabe_folori")
    private int folioOriginal;
    @Column (name="cabe_fecori")
    @Temporal(TemporalType.DATE)
    private Date fechaDocumento;
    @Column (name="cabe_fecvto")
    @Temporal(TemporalType.DATE)
    private Date fechaVencimiento;
    @Column (name="cabe_plazo")
    private int plazo;
    @Column (name="cabe_anio")
    private int año;
    @Column (name="cabe_mes")
    private int mes;
    @Column (name="cabe_dia")
    private int dia;
    @Column (name="cabe_ley1")
    private String ley1;
    @Column (name="cabe_ley2")
    private String ley2;
    @Column (name="cabe_ley3")
    private String ley3;
    @Column (name="cabe_razons")
    private String razonSocial;
    @Column (name="cabe_calle")
    private String calle;
    @Column (name="cabe_colonia")
    private String colonia;
    @Column (name="cabe_poblacion")
    private String poblacion;
    @Column (name="cabe_estado")
    private String estado;
    @Column (name="cabe_rfc")
    private String rfc;
    @Column (name="cabe_telefono")
    private String telefono;
    @Column (name="cabe_cp")
    private int cp;
    private float flete;
    private String descripcion;

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
     * @return the serie
     */
    public Serie getSerie() {
        return serie;
    }

    /**
     * @param serie the serie to set
     */
    public void setSerie(Serie serie) {
        this.serie = serie;
    }

    /**
     * @return the folio
     */
    public int getFolio() {
        return folio;
    }

    /**
     * @param folio the folio to set
     */
    public void setFolio(int folio) {
        this.folio = folio;
    }

    /**
     * @return the tipomov
     */
    public TipoMov getTipomov() {
        return tipomov;
    }

    /**
     * @param tipomov the tipomov to set
     */
    public void setTipomov(TipoMov tipomov) {
        this.tipomov = tipomov;
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
     * @return the fechaInventario
     */
    public Date getFechaInventario() {
        return fechaInventario;
    }

    /**
     * @param fechaInventario the fechaInventario to set
     */
    public void setFechaInventario(Date fechaInventario) {
        this.fechaInventario = fechaInventario;
    }

    /**
     * @return the fechaRecepcion
     */
    public Date getFechaRecepcion() {
        return fechaRecepcion;
    }

    /**
     * @param fechaRecepcion the fechaRecepcion to set
     */
    public void setFechaRecepcion(Date fechaRecepcion) {
        this.fechaRecepcion = fechaRecepcion;
    }

    /**
     * @return the fechaCaptura
     */
    public Date getFechaCaptura() {
        return fechaCaptura;
    }

    /**
     * @param fechaCaptura the fechaCaptura to set
     */
    public void setFechaCaptura(Date fechaCaptura) {
        this.fechaCaptura = fechaCaptura;
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
     * @return the serieOriginal
     */
    public String getSerieOriginal() {
        return serieOriginal;
    }

    /**
     * @param serieOriginal the serieOriginal to set
     */
    public void setSerieOriginal(String serieOriginal) {
        this.serieOriginal = serieOriginal;
    }

    /**
     * @return the folioOriginal
     */
    public int getFolioOriginal() {
        return folioOriginal;
    }

    /**
     * @param folioOriginal the folioOriginal to set
     */
    public void setFolioOriginal(int folioOriginal) {
        this.folioOriginal = folioOriginal;
    }

    /**
     * @return the fechaDocumento
     */
    public Date getFechaDocumento() {
        return fechaDocumento;
    }

    /**
     * @param fechaDocumento the fechaDocumento to set
     */
    public void setFechaDocumento(Date fechaDocumento) {
        this.fechaDocumento = fechaDocumento;
    }

    /**
     * @return the fechaVencimiento
     */
    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    /**
     * @param fechaVencimiento the fechaVencimiento to set
     */
    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
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
     * @return the año
     */
    public int getAño() {
        return año;
    }

    /**
     * @param año the año to set
     */
    public void setAño(int año) {
        this.año = año;
    }

    /**
     * @return the mes
     */
    public int getMes() {
        return mes;
    }

    /**
     * @param mes the mes to set
     */
    public void setMes(int mes) {
        this.mes = mes;
    }

    /**
     * @return the dia
     */
    public int getDia() {
        return dia;
    }

    /**
     * @param dia the dia to set
     */
    public void setDia(int dia) {
        this.dia = dia;
    }

    /**
     * @return the ley1
     */
    public String getLey1() {
        return ley1;
    }

    /**
     * @param ley1 the ley1 to set
     */
    public void setLey1(String ley1) {
        this.ley1 = ley1;
    }

    /**
     * @return the ley2
     */
    public String getLey2() {
        return ley2;
    }

    /**
     * @param ley2 the ley2 to set
     */
    public void setLey2(String ley2) {
        this.ley2 = ley2;
    }

    /**
     * @return the ley3
     */
    public String getLey3() {
        return ley3;
    }

    /**
     * @param ley3 the ley3 to set
     */
    public void setLey3(String ley3) {
        this.ley3 = ley3;
    }

    /**
     * @return the razonSocial
     */
    public String getRazonSocial() {
        return razonSocial;
    }

    /**
     * @param razonSocial the razonSocial to set
     */
    public void setRazonSocial(String razonSocial) {
        this.razonSocial = razonSocial;
    }

    /**
     * @return the calle
     */
    public String getCalle() {
        return calle;
    }

    /**
     * @param calle the calle to set
     */
    public void setCalle(String calle) {
        this.calle = calle;
    }

    /**
     * @return the colonia
     */
    public String getColonia() {
        return colonia;
    }

    /**
     * @param colonia the colonia to set
     */
    public void setColonia(String colonia) {
        this.colonia = colonia;
    }

    /**
     * @return the poblacion
     */
    public String getPoblacion() {
        return poblacion;
    }

    /**
     * @param poblacion the poblacion to set
     */
    public void setPoblacion(String poblacion) {
        this.poblacion = poblacion;
    }

    /**
     * @return the estado
     */
    public String getEstado() {
        return estado;
    }

    /**
     * @param estado the estado to set
     */
    public void setEstado(String estado) {
        this.estado = estado;
    }

    /**
     * @return the rfc
     */
    public String getRfc() {
        return rfc;
    }

    /**
     * @param rfc the rfc to set
     */
    public void setRfc(String rfc) {
        this.rfc = rfc;
    }

    /**
     * @return the telefono
     */
    public String getTelefono() {
        return telefono;
    }

    /**
     * @param telefono the telefono to set
     */
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    /**
     * @return the cp
     */
    public int getCp() {
        return cp;
    }

    /**
     * @param cp the cp to set
     */
    public void setCp(int cp) {
        this.cp = cp;
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
     * @return the centrotrabajo
     */
    public CentroDeTrabajo getCentrotrabajo() {
        return centrotrabajo;
    }

    /**
     * @param centrotrabajo the centrotrabajo to set
     */
    public void setCentrotrabajo(CentroDeTrabajo centrotrabajo) {
        this.centrotrabajo = centrotrabajo;
    }

    /**
     * @return the flete
     */
    public float getFlete() {
        return flete;
    }

    /**
     * @param flete the flete to set
     */
    public void setFlete(float flete) {
        this.flete = flete;
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
    
}
