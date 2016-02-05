/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Modelo.Entidades;

import java.util.Date;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author TEMOC
 */
@Entity
@Table(name="contrato_trabajo")
public class ContratoTrabajo {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @OneToOne(cascade= CascadeType.ALL, fetch=FetchType.EAGER)
    private Empleado empleado;
    @Temporal(TemporalType.DATE)
    private Date fecha;
    private Integer jornada;
    private String entrada;
    private String salida;
    private String diainicio;
    private String diafin;
    private String diasdescanso;

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
     * @return the empleado
     */
    public Empleado getEmpleado() {
        return empleado;
    }

    /**
     * @param empleado the empleado to set
     */
    public void setEmpleado(Empleado empleado) {
        this.empleado = empleado;
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
     * @return the jornada
     */
    public Integer getJornada() {
        return jornada;
    }

    /**
     * @param jornada the jornada to set
     */
    public void setJornada(Integer jornada) {
        this.jornada = jornada;
    }

    /**
     * @return the entrada
     */
    public String getEntrada() {
        return entrada;
    }

    /**
     * @param entrada the entrada to set
     */
    public void setEntrada(String entrada) {
        this.entrada = entrada;
    }

    /**
     * @return the salida
     */
    public String getSalida() {
        return salida;
    }

    /**
     * @param salida the salida to set
     */
    public void setSalida(String salida) {
        this.salida = salida;
    }

    /**
     * @return the diainicio
     */
    public String getDiainicio() {
        return diainicio;
    }

    /**
     * @param diainicio the diainicio to set
     */
    public void setDiainicio(String diainicio) {
        this.diainicio = diainicio;
    }

    /**
     * @return the diafin
     */
    public String getDiafin() {
        return diafin;
    }

    /**
     * @param diafin the diafin to set
     */
    public void setDiafin(String diafin) {
        this.diafin = diafin;
    }

    /**
     * @return the diasdescanso
     */
    public String getDiasdescanso() {
        return diasdescanso;
    }

    /**
     * @param diasdescanso the diasdescanso to set
     */
    public void setDiasdescanso(String diasdescanso) {
        this.diasdescanso = diasdescanso;
    }
    
}
