/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "quincenas")
public class Quincena {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "quin_id")
    private int id;
    @Column (name = "quin_mes")
    private String mes;
    private int numero;
    private int inicio;
    private int fin;
    private int nummes;
    private int estatus;//1=activa, 0=cerrada
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
     * @return the quincena
     */
    public String getMes() {
        return mes;
    }

    /**
     * @param quincena the quincena to set
     */
    public void setMes(String m) {
        this.mes = m;
    }

    /**
     * @return the numero
     */
    public int getNumero() {
        return numero;
    }

    /**
     * @param numero the numero to set
     */
    public void setNumero(int numero) {
        this.numero = numero;
    }

    /**
     * @return the inicio
     */
    public int getInicio() {
        return inicio;
    }

    /**
     * @param inicio the inicio to set
     */
    public void setInicio(int inicio) {
        this.inicio = inicio;
    }

    /**
     * @return the fin
     */
    public int getFin() {
        return fin;
    }

    /**
     * @param fin the fin to set
     */
    public void setFin(int fin) {
        this.fin = fin;
    }

    /**
     * @return the nummes
     */
    public int getNummes() {
        return nummes;
    }

    /**
     * @param nummes the nummes to set
     */
    public void setNummes(int nummes) {
        this.nummes = nummes;
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
