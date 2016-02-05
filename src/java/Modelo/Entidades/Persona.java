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
@Table(name="personas")
public class Persona {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int idpersona;
    private String nombre;
    private String paterno;
    private String materno;
    private String sexo;
    private String rfc;
    private String curp;
    private int gposang;
    private int civil;
    @Temporal(TemporalType.DATE)
    @Column (name="fnaci")    
    private Date fnaci;
    private String dian;
    private String mesn;
    private String observacion;
    private String cargo;
    private String titulo;
    private int lugarn;
    
    @OneToOne (cascade = CascadeType.ALL, fetch= FetchType.EAGER)
    private Direccion direccion;
    
    @OneToOne (fetch = FetchType.EAGER)
    private Sucursal sucursal;
    
    public Persona(){
        
    }

    /**
     * @return the idpersona
     */
    public int getIdpersona() {
        return idpersona;
    }

    /**
     * @param idpersona the idpersona to set
     */
    public void setIdpersona(int idpersona) {
        this.idpersona = idpersona;
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
     * @return the paterno
     */
    public String getPaterno() {
        return paterno;
    }

    /**
     * @param paterno the paterno to set
     */
    public void setPaterno(String paterno) {
        this.paterno = paterno;
    }

    /**
     * @return the materno
     */
    public String getMaterno() {
        return materno;
    }

    /**
     * @param materno the materno to set
     */
    public void setMaterno(String materno) {
        this.materno = materno;
    }

    /**
     * @return the sexo
     */
    public String getSexo() {
        return sexo;
    }

    /**
     * @param sexo the sexo to set
     */
    public void setSexo(String sexo) {
        this.sexo = sexo;
    }
    
    public String getNombreCompleto(){
        return this.nombre+" "+this.paterno+" "+this.materno;
    }

    public String getNombreCompletoPorApellidos(){
        return this.paterno +" "+ this.materno +" "+ this.nombre;
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
     * @return the curp
     */
    public String getCurp() {
        return curp;
    }

    /**
     * @param curp the curp to set
     */
    public void setCurp(String curp) {
        this.curp = curp;
    }

    /**
     * @return the gposang
     */
    public int getGposang() {
        return gposang;
    }

    /**
     * @param gposang the gposang to set
     */
    public void setGposang(int gposang) {
        this.gposang = gposang;
    }

    /**
     * @return the civil
     */
    public int getCivil() {
        return civil;
    }

    /**
     * @param civil the civil to set
     */
    public void setCivil(int civil) {
        this.civil = civil;
    }

    /**
     * @return the fnaci
     */
    public Date getFnaci() {
        return fnaci;
    }

    /**
     * @param fnaci the fnaci to set
     */
    public void setFnaci(Date fnaci) {
        this.fnaci = fnaci;
    }

    /**
     * @return the dian
     */
    public String getDian() {
        return dian;
    }

    /**
     * @param dian the dian to set
     */
    public void setDian(String dian) {
        this.dian = dian;
    }

    /**
     * @return the mesn
     */
    public String getMesn() {
        return mesn;
    }

    /**
     * @param mesn the mesn to set
     */
    public void setMesn(String mesn) {
        this.mesn = mesn;
    }

    /**
     * @return the observacion
     */
    public String getObservacion() {
        return observacion;
    }

    /**
     * @param observacion the observacion to set
     */
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    /**
     * @return the cargo
     */
    public String getCargo() {
        return cargo;
    }

    /**
     * @param cargo the cargo to set
     */
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    /**
     * @return the titulo
     */
    public String getTitulo() {
        return titulo;
    }

    /**
     * @param titulo the titulo to set
     */
    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    /**
     * @return the lugarn
     */
    public int getLugarn() {
        return lugarn;
    }

    /**
     * @param lugarn the lugarn to set
     */
    public void setLugarn(int lugarn) {
        this.lugarn = lugarn;
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
}
