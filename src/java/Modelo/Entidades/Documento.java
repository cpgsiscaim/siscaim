/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.TipoDocumento;
import javax.persistence.*;

/**
 *
 * @author usuario
 */
@Entity
@Table (name="documentos")
public class Documento {
    @Id
    @Column (name="iddocumento")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne (fetch= FetchType.EAGER)
    private Empleado empleado;
    @OneToOne (fetch= FetchType.EAGER)
    private TipoDocumento tipodoc;
    private String imagen;
    private int estatus;
    private String descri_corta;
    private String descri_larga;

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
     * @return the empleado
     */
    public Empleado getEmpleado() {
        return empleado;
    }

    /**
     * @param empleado the empleado to set
     */
    public void setEmpleado(Empleado empleado) {
        this.empleado = empleado;
    }

    /**
     * @return the tipodoc
     */
    public TipoDocumento getTipodoc() {
        return tipodoc;
    }

    /**
     * @param tipodoc the tipodoc to set
     */
    public void setTipodoc(TipoDocumento tipodoc) {
        this.tipodoc = tipodoc;
    }

    /**
     * @return the imagen
     */
    public String getImagen() {
        return imagen;
    }

    /**
     * @param imagen the imagen to set
     */
    public void setImagen(String imagen) {
        this.imagen = imagen;
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
     * @return the descri_corta
     */
    public String getDescri_corta() {
        return descri_corta;
    }

    /**
     * @param descri_corta the descri_corta to set
     */
    public void setDescri_corta(String descri_corta) {
        this.descri_corta = descri_corta;
    }

    /**
     * @return the descri_larga
     */
    public String getDescri_larga() {
        return descri_larga;
    }

    /**
     * @param descri_larga the descri_larga to set
     */
    public void setDescri_larga(String descri_larga) {
        this.descri_larga = descri_larga;
    }
}
