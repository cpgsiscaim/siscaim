/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.PeryDed;
import java.util.Date;
import javax.persistence.*;

/**
 *
 * @author usuario
 */
@Entity
@Table (name = "detallenomina")
public class DetalleNomina {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "iddetallenomina")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private Nomina nomina;
    @OneToOne (fetch = FetchType.EAGER)
    private Plaza plaza;
    @OneToOne (fetch = FetchType.EAGER)
    private PeryDed movimiento;
    private float monto;
    private int exento;
    private int estatus;
    @Temporal(TemporalType.DATE)
    private Date fechaaplicacion;
    private int cotiza;

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
     * @return the nomina
     */
    public Nomina getNomina() {
        return nomina;
    }

    /**
     * @param nomina the nomina to set
     */
    public void setNomina(Nomina nomina) {
        this.nomina = nomina;
    }

    /**
     * @return the plaza
     */
    public Plaza getPlaza() {
        return plaza;
    }

    /**
     * @param plaza the plaza to set
     */
    public void setPlaza(Plaza plaza) {
        this.plaza = plaza;
    }

    /**
     * @return the movimiento
     */
    public PeryDed getMovimiento() {
        return movimiento;
    }

    /**
     * @param movimiento the movimiento to set
     */
    public void setMovimiento(PeryDed movimiento) {
        this.movimiento = movimiento;
    }

    /**
     * @return the monto
     */
    public float getMonto() {
        return monto;
    }

    /**
     * @param monto the monto to set
     */
    public void setMonto(float monto) {
        this.monto = monto;
    }

    /**
     * @return the exento
     */
    public int getExento() {
        return exento;
    }

    /**
     * @param exento the exento to set
     */
    public void setExento(int exento) {
        this.exento = exento;
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
     * @return the fechaaplicacion
     */
    public Date getFechaaplicacion() {
        return fechaaplicacion;
    }

    /**
     * @param fechaaplicacion the fechaaplicacion to set
     */
    public void setFechaaplicacion(Date fechaaplicacion) {
        this.fechaaplicacion = fechaaplicacion;
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
}
