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
@Table (name = "pydtipc")
public class TipoCambioPyD {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "pydtipc_id")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private PeryDed perded;
    @OneToOne (fetch = FetchType.EAGER)
    private TipoCambio tipocambio;
    private int estatus;

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
     * @return the perded
     */
    public PeryDed getPerded() {
        return perded;
    }

    /**
     * @param perded the perded to set
     */
    public void setPerded(PeryDed perded) {
        this.perded = perded;
    }

    /**
     * @return the tipocambio
     */
    public TipoCambio getTipocambio() {
        return tipocambio;
    }

    /**
     * @param tipocambio the tipocambio to set
     */
    public void setTipocambio(TipoCambio tipocambio) {
        this.tipocambio = tipocambio;
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
