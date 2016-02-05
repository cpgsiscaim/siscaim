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
@Table (name="ct_tiposmedios")
public class TipoMedio {
    @Id
    private int idtipomedio;
    private String tipomedio;
    private int estatus;
    
    public TipoMedio(){
        
    }

    /**
     * @return the idtipomedio
     */
    public int getIdtipomedio() {
        return idtipomedio;
    }

    /**
     * @param idtipomedio the idtipomedio to set
     */
    public void setIdtipomedio(int idtipomedio) {
        this.idtipomedio = idtipomedio;
    }

    /**
     * @return the tipomedio
     */
    public String getTipomedio() {
        return tipomedio;
    }

    /**
     * @param tipomedio the tipomedio to set
     */
    public void setTipomedio(String tipomedio) {
        this.tipomedio = tipomedio;
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
