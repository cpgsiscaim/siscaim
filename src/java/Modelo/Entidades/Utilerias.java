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
@Table (name = "utilerias")
public class Utilerias {
    @Id
    private int id;
    private int grupos;

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
     * @return the grupos
     */
    public int getGrupos() {
        return grupos;
    }

    /**
     * @param grupos the grupos to set
     */
    public void setGrupos(int grupos) {
        this.grupos = grupos;
    }
}
