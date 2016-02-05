/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Catalogos.TipoNomina;
import java.util.Date;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "nomina")
public class Nomina {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "idnomina")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private TipoNomina tiponomina;
    private int anio;
    @OneToOne (fetch = FetchType.EAGER)
    private Quincena quincena;
    private int estatus;
    @Temporal(TemporalType.DATE)
    private Date fecha;
    @Temporal(TemporalType.DATE)
    private Date fechacierre;
    @OneToOne (fetch = FetchType.EAGER)
    private Sucursal sucursal;

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
     * @return the anio
     */
    public int getAnio() {
        return anio;
    }

    /**
     * @param anio the anio to set
     */
    public void setAnio(int anio) {
        this.anio = anio;
    }

    /**
     * @return the tiponomina
     */
    public TipoNomina getTiponomina() {
        return tiponomina;
    }

    /**
     * @param tiponomina the tiponomina to set
     */
    public void setTiponomina(TipoNomina tiponomina) {
        this.tiponomina = tiponomina;
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
     * @return the fechacierre
     */
    public Date getFechacierre() {
        return fechacierre;
    }

    /**
     * @param fechacierre the fechacierre to set
     */
    public void setFechacierre(Date fechacierre) {
        this.fechacierre = fechacierre;
    }

    /**
     * @return the quincena
     */
    public Quincena getQuincena() {
        return quincena;
    }

    /**
     * @param quincena the quincena to set
     */
    public void setQuincena(Quincena quincena) {
        this.quincena = quincena;
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
