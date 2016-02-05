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
@Table (name="categorias")
public class Categoria {
    @Id
    @Column (name="cate_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column (name="clave")
    private String clave;
    @Column (name="cate_descri")
    private String descripcion;
    @Column (name="cate_cccontado")
    private String cccontado;
    @Column (name="cate_cccredito")
    private String cccredito;
    @Column (name="cate_cvcontado")
    private String cvcontado;
    @Column (name="cate_cvcredito")
    private String cvcredito;
    @Temporal(TemporalType.DATE)
    @Column (name="cate_fecalta")
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
}
