/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

import java.util.Date;
import javax.persistence.*;

/**
 *
 * @author usuario
 */
@Entity
@Table (name = "fechas_entrega")
public class FechasEntrega {
    @Id
    private int id;
    private int entidad;
    private int identidad;
    @Temporal(TemporalType.DATE)
    private Date fecha;

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
     * @return the entidad
     */
    public int getEntidad() {
        return entidad;
    }

    /**
     * @param entidad the entidad to set
     */
    public void setEntidad(int entidad) {
        this.entidad = entidad;
    }

    /**
     * @return the identidad
     */
    public int getIdentidad() {
        return identidad;
    }

    /**
     * @param identidad the identidad to set
     */
    public void setIdentidad(int identidad) {
        this.identidad = identidad;
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
}
