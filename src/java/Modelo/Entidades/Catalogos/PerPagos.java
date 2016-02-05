/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

/**
 *
 * @author roman
 */
import javax.persistence.*;

@Entity
@Table (name="perpagos")
public class PerPagos {

    @Id
    private int idPerPagos;    
    private String Descripcion;
    private String Dias;
    private int Estatus;

    public PerPagos(){
        
    }

    /**
     * @return the idPerPagos
     */
    public int getIdPerPagos() {
        return idPerPagos;
    }

    /**
     * @param idPerPagos the idPerPagos to set
     */
    public void setIdPerPagos(int idPerPagos) {
        this.idPerPagos = idPerPagos;
    }

    /**
     * @return the Descripcion
     */
    public String getDescripcion() {
        return Descripcion;
    }

    /**
     * @param Descripcion the Descripcion to set
     */
    public void setDescripcion(String Descripcion) {
        this.Descripcion = Descripcion;
    }

    /**
     * @return the Dias
     */
    public String getDias() {
        return Dias;
    }

    /**
     * @param Dias the Dias to set
     */
    public void setDias(String Dias) {
        this.Dias = Dias;
    }

    /**
     * @return the Estatus
     */
    public int getEstatus() {
        return Estatus;
    }

    /**
     * @param Estatus the Estatus to set
     */
    public void setEstatus(int Estatus) {
        this.Estatus = Estatus;
    }
}
