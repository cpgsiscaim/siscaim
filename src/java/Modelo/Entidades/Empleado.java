/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.Banco;
import java.util.Date;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table(name="empleados")
public class Empleado {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int numempleado;
    private String clave;
    private int estatus;
    private int cotiza;
    private String nss;
    private String cuenta;
    private String estudios;
    @Temporal(TemporalType.DATE)
    private Date fecha; //usar para fecha de registro en la empresa
    private String imagen;
    
    @OneToOne(cascade= CascadeType.ALL, fetch=FetchType.EAGER)
    private Persona persona;
    @OneToOne(fetch=FetchType.EAGER)
    private Banco banco;
    private int consecutivo;
    private int docestatus;
    @Temporal(TemporalType.DATE)
    private Date fechabaja;
    private int finiquito;
    private String registropatronal;
    private String firma;
    private int padecimiento;
    private String descripadecimiento;
    
    public Empleado(){
        
    }

    /**
     * @return the numempleado
     */
    public int getNumempleado() {
        return numempleado;
    }

    /**
     * @param numempleado the numempleado to set
     */
    public void setNumempleado(int numempleado) {
        this.numempleado = numempleado;
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
     * @return the cotiza
     */
    public int getCotiza() {
        return cotiza;
    }

    /**
     * @param cotiza the cotiza to set
     */
    public void setCotiza(int cotiza) {
        this.cotiza = cotiza;
    }

    /**
     * @return the nss
     */
    public String getNss() {
        return nss;
    }

    /**
     * @param nss the nss to set
     */
    public void setNss(String nss) {
        this.nss = nss;
    }

    /**
     * @return the cuenta
     */
    public String getCuenta() {
        return cuenta;
    }

    /**
     * @param cuenta the cuenta to set
     */
    public void setCuenta(String cuenta) {
        this.cuenta = cuenta;
    }

    /**
     * @return the estudios
     */
    public String getEstudios() {
        return estudios;
    }

    /**
     * @param estudios the estudios to set
     */
    public void setEstudios(String estudios) {
        this.estudios = estudios;
    }

    /**
     * @return the fecha
     */
    public Date getFecha() {
        return fecha;
    }

    /**
     * @param fecha the fecha to set
     */
    public void setFecha(Date fecha) {
        this.fecha = fecha;
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
     * @return the banco
     */
    public Banco getBanco() {
        return banco;
    }

    /**
     * @param banco the banco to set
     */
    public void setBanco(Banco banco) {
        this.banco = banco;
    }

    /**
     * @return the consecutivo
     */
    public int getConsecutivo() {
        return consecutivo;
    }

    /**
     * @param consecutivo the consecutivo to set
     */
    public void setConsecutivo(int consecutivo) {
        this.consecutivo = consecutivo;
    }

    /**
     * @return the docestatus
     */
    public int getDocestatus() {
        return docestatus;
    }

    /**
     * @param docestatus the docestatus to set
     */
    public void setDocestatus(int docestatus) {
        this.docestatus = docestatus;
    }

    /**
     * @return the fechabaja
     */
    public Date getFechabaja() {
        return fechabaja;
    }

    /**
     * @param fechabaja the fechabaja to set
     */
    public void setFechabaja(Date fechabaja) {
        this.fechabaja = fechabaja;
    }

    /**
     * @return the finiquito
     */
    public int getFiniquito() {
        return finiquito;
    }

    /**
     * @param finiquito the finiquito to set
     */
    public void setFiniquito(int finiquito) {
        this.finiquito = finiquito;
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

    /**
     * @return the firma
     */
    public String getFirma() {
        return firma;
    }

    /**
     * @param firma the firma to set
     */
    public void setFirma(String firma) {
        this.firma = firma;
    }

    /**
     * @return the padicimiento
     */
    public int getPadecimiento() {
        return padecimiento;
    }

    /**
     * @param padicimiento the padicimiento to set
     */
    public void setPadecimiento(int padecimiento) {
        this.padecimiento = padecimiento;
    }

    /**
     * @return the descripadecimiento
     */
    public String getDescripadecimiento() {
        return descripadecimiento;
    }

    /**
     * @param descripadecimiento the descripadecimiento to set
     */
    public void setDescripadecimiento(String descripadecimiento) {
        this.descripadecimiento = descripadecimiento;
    }

    /**
     * @return the id
     */
    /*
    public int getId() {
        return id;
    }

    /**
     * @param id the id to set
     *
    public void setId(int id) {
        this.id = id;
    }
    */
}
