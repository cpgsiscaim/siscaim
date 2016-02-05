/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.PeryDed;
import Modelo.Entidades.Catalogos.Quincena;
import Modelo.Entidades.Catalogos.TipoCambio;
import Modelo.Entidades.Catalogos.TipoNomina;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name = "movpersonal")
public class MovimientoExtraordinario {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    @Column (name = "movi_id")
    private int id;
    @OneToOne (fetch = FetchType.EAGER)
    private PeryDed perded;
    @OneToOne (fetch = FetchType.EAGER)
    private TipoCambio tipocambio;
    @OneToOne (fetch = FetchType.EAGER)
    private Quincena quincena;
    @OneToOne (fetch = FetchType.EAGER)
    private Plaza plaza;
    @OneToOne (fetch = FetchType.EAGER)
    private TipoNomina tiponomina;
    @Column (name = "movi_anio")
    private int anio;
    @Column (name = "movi_importe")
    private float importe;
    @Column (name = "movi_periodo")
    private String periodo;
    @Column (name = "movi_numero")
    private int numero;
    @Column (name = "movi_total")
    private float total;
    @Column (name = "movi_estatus")
    private int estatus;
    private String observaciones;
    private int cotiza;
    private int fijo;
    private int prestacionimss;
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
     * @return the importe
     */
    public float getImporte() {
        return importe;
    }

    /**
     * @param importe the importe to set
     */
    public void setImporte(float importe) {
        this.importe = importe;
    }

    /**
     * @return the periodo
     */
    public String getPeriodo() {
        return periodo;
    }

    /**
     * @param periodo the periodo to set
     */
    public void setPeriodo(String periodo) {
        this.periodo = periodo;
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
     * @return the total
     */
    public float getTotal() {
        return total;
    }

    /**
     * @param total the total to set
     */
    public void setTotal(float total) {
        this.total = total;
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
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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
     * @return the fijo
     */
    public int getFijo() {
        return fijo;
    }

    /**
     * @param fijo the fijo to set
     */
    public void setFijo(int fijo) {
        this.fijo = fijo;
    }

    /**
     * @return the prestacionimss
     */
    public int getPrestacionimss() {
        return prestacionimss;
    }

    /**
     * @param prestacionimss the prestacionimss to set
     */
    public void setPrestacionimss(int prestacionimss) {
        this.prestacionimss = prestacionimss;
    }
}
