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
@Table (name="datosfis")
public class DatosFiscales {
    @Id
    @Column(name="datf_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column(name="datf_tipo")
    private String tipo;
    @Column(name="datf_rfc")
    private String rfc;
    @Column(name="datf_razons")
    private String razonsocial;
    @Column(name="datf_nombrec")
    private String nombrec;
    @Column(name="datf_regiep")
    private String regiep;
    
    @OneToOne (cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Persona persona;
    
    @OneToOne (cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Direccion direccion;
    
    public DatosFiscales(){
    }

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
     * @return the tipo
     */
    public String getTipo() {
        return tipo;
    }

    /**
     * @param tipo the tipo to set
     */
    public void setTipo(String tipo) {
        this.tipo = tipo;
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
     * @return the razonsocial
     */
    public String getRazonsocial() {
        return razonsocial;
    }

    /**
     * @param razonsocial the razonsocial to set
     */
    public void setRazonsocial(String razonsocial) {
        this.razonsocial = razonsocial;
    }

    /**
     * @return the nombrec
     */
    public String getNombrec() {
        return nombrec;
    }

    /**
     * @param nombrec the nombrec to set
     */
    public void setNombrec(String nombrec) {
        this.nombrec = nombrec;
    }

    /**
     * @return the regiep
     */
    public String getRegiep() {
        return regiep;
    }

    /**
     * @param regiep the regiep to set
     */
    public void setRegiep(String regiep) {
        this.regiep = regiep;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the direccion
     */
    public Direccion getDireccion() {
        return direccion;
    }

    /**
     * @param direccion the direccion to set
     */
    public void setDireccion(Direccion direccion) {
        this.direccion = direccion;
    }
}
