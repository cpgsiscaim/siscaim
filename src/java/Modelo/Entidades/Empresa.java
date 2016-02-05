/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="empresa")
public class Empresa {
    @Id
    @Column (name="empr_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column (name="empr_serie")
    private String serie;
    @Column (name="empr_clave")
    private String clave;
    @Column (name="empr_nosuc")
    private int nosuc;
    @Column (name="empr_nombre")
    private String nombre;
    @Column (name="empr_logotipo")
    private String logo;
    
    @OneToMany(cascade=CascadeType.ALL, fetch= FetchType.EAGER, mappedBy="empresa")
    private List<Sucursal> sucursales = new ArrayList<Sucursal>();
    
    public Empresa(){
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
     * @return the nosuc
     */
    public int getNosuc() {
        return nosuc;
    }

    /**
     * @param nosuc the nosuc to set
     */
    public void setNosuc(int nosuc) {
        this.nosuc = nosuc;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the sucursales
     */
    public List<Sucursal> getSucursales() {
        return sucursales;
    }

    /**
     * @param sucursales the sucursales to set
     */
    public void setSucursales(List<Sucursal> sucursales) {
        this.sucursales = sucursales;
    }
    
    public void addSucursal(Sucursal suc){
        this.sucursales.add(suc);
    }

    /**
     * @return the logo
     */
    public String getLogo() {
        return logo;
    }

    /**
     * @param logo the logo to set
     */
    public void setLogo(String logo) {
        this.logo = logo;
    }
    
}
