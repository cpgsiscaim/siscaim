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
@Table (name="ct_titulos")
public class Titulo {
    @Id
    private int idtitulo;
    private String titulo;
    private int estatus;
    
    public Titulo(){
        
    }

    /**
     * @return the idtitulo
     */
    public int getIdtitulo() {
        return idtitulo;
    }

    /**
     * @param idtitulo the idtitulo to set
     */
    public void setIdtitulo(int idtitulo) {
        this.idtitulo = idtitulo;
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
