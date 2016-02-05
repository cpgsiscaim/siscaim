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
@Table (name="series")
public class Serie {
    @Id
    @Column (name="seri_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column (name="seri_serie")
    private String serie;
    @Column (name="seri_folio")
    private Float folio;
    @Column (name="seri_descri")
    private String descripcion;
    @Column (name="seri_ftoimp")
    private String formato;
    @Column (name="seri_ptoimp")
    private String puerto;
    @Column (name="seri_estatus")
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
     * @return the folio
     */
    public Float getFolio() {
        return folio;
    }

    /**
     * @param folio the folio to set
     */
    public void setFolio(Float folio) {
        this.folio = folio;
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
     * @return the formato
     */
    public String getFormato() {
        return formato;
    }

    /**
     * @param formato the formato to set
     */
    public void setFormato(String formato) {
        this.formato = formato;
    }

    /**
     * @return the puerto
     */
    public String getPuerto() {
        return puerto;
    }

    /**
     * @param puerto the puerto to set
     */
    public void setPuerto(String puerto) {
        this.puerto = puerto;
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
