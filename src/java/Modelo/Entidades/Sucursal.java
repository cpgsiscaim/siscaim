/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="sucursales")
public class Sucursal {
    @Id
    @Column (name="sucu_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column (name="sucu_tipo")
    private int tipo;
    @Column (name="estatus")
    private int estatus;
    
    @ManyToOne
    private Empresa empresa;
    
    @OneToOne (cascade= CascadeType.ALL, fetch= FetchType.EAGER)
    private DatosFiscales datosfis;
    
    @ManyToMany(cascade=CascadeType.ALL, fetch= FetchType.EAGER)
    @JoinTable(name = "mediossuc", joinColumns = {
        @JoinColumn(name = "sucursal_sucu_id", nullable = false, updatable = false)}, inverseJoinColumns = {
        @JoinColumn(name = "medio_medi_id", nullable = false, updatable = false)})
    @Fetch(FetchMode.SUBSELECT)
    private List<Medio> medios = new ArrayList<Medio>();
    
    @ManyToMany(cascade=CascadeType.ALL, fetch= FetchType.EAGER)
    @JoinTable(name = "contacsuc", joinColumns = {
        @JoinColumn(name = "sucursal_sucu_id", nullable = false, updatable = false)}, inverseJoinColumns = {
        @JoinColumn(name = "persona_pers_id", nullable = false, updatable = false)})
    @Fetch(FetchMode.SUBSELECT)
    private List<Persona> contactos = new ArrayList<Persona>();
    
    private String registropatronal;
    
    public Sucursal(){
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
     * @return the empresa
     */
    public Empresa getEmpresa() {
        return empresa;
    }

    /**
     * @param empresa the empresa to set
     */
    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }

    /**
     * @return the medios
     */
    public List<Medio> getMedios() {
        return medios;
    }

    /**
     * @param medios the medios to set
     */
    public void setMedios(List<Medio> medios) {
        this.setMedios(medios);
    }
    
    public void addMedio(Medio medio){
        this.medios.add(medio);
    }

    public void removeMedio(Medio medio){
        this.medios.remove(medio);
    }    
    /**
     * @return the datosfis
     */
    public DatosFiscales getDatosfis() {
        return datosfis;
    }

    /**
     * @param datosfis the datosfis to set
     */
    public void setDatosfis(DatosFiscales datosfis) {
        this.datosfis = datosfis;
    }

    /**
     * @return the contactos
     */
    public List<Persona> getContactos() {
        return contactos;
    }

    /**
     * @param contactos the contactos to set
     */
    public void setContactos(List<Persona> contactos) {
        this.contactos = contactos;
    }

    public void addContacto(Persona con){
        this.contactos.add(con);
    }

    public void removeContacto(Persona con){
        this.contactos.remove(con);
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
     * @return the registropatronal
     */
    public String getRegistropatronal() {
        return registropatronal;
    }

    /**
     * @param registropatronal the registropatronal to set
     */
    public void setRegistropatronal(String registropatronal) {
        this.registropatronal = registropatronal;
    }
}
