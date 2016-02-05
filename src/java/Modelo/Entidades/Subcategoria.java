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
@Table (name="subcategorias")
public class Subcategoria {
    @Id
    @Column (name="scat_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)    
    private int id;
    @OneToOne (fetch=FetchType.EAGER)
    private Categoria categoria;
    @Column (name="scat_clave")
    private String clave;
    @Column (name="scat_descri")
    private String descripcion;
    @Column (name="scat_cccontado")
    private String cccontado;
    @Column (name="scat_cccredito")
    private String cccredito;
    @Column (name="scat_cvcontado")
    private String cvcontado;
    @Column (name="scat_cvcredito")
    private String cvcredito;
    @Temporal(TemporalType.DATE)
    @Column (name="scat_fecalta")
    private Date fechaAlta;
    @Column (name="estatus")
    private int estatus;

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
     * @return the cccontado
     */
    public String getCccontado() {
        return cccontado;
    }

    /**
     * @param cccontado the cccontado to set
     */
    public void setCccontado(String cccontado) {
        this.cccontado = cccontado;
    }

    /**
     * @return the cccredito
     */
    public String getCccredito() {
        return cccredito;
    }

    /**
     * @param cccredito the cccredito to set
     */
    public void setCccredito(String cccredito) {
        this.cccredito = cccredito;
    }

    /**
     * @return the cvcontado
     */
    public String getCvcontado() {
        return cvcontado;
    }

    /**
     * @param cvcontado the cvcontado to set
     */
    public void setCvcontado(String cvcontado) {
        this.cvcontado = cvcontado;
    }

    /**
     * @return the cvcredito
     */
    public String getCvcredito() {
        return cvcredito;
    }

    /**
     * @param cvcredito the cvcredito to set
     */
    public void setCvcredito(String cvcredito) {
        this.cvcredito = cvcredito;
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
}
