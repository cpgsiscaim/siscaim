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
@Table (name="tipincidencia")
public class TipoIncidencia {
    @Id
    private int idTipincidencia;    
    private String Descripcion;    
    private int Calcula;    
    private int idPery;
    private int Estatus;
    
    public TipoIncidencia(){
        
    }

    /**
     * @return the idTipoincidencia
     */
    public int getIdTipoincidencia() {
        return idTipincidencia;
    }

    /**
     * @param idTipoincidencia the idTipoincidencia to set
     */
    public void setIdTipoincidencia(int idTipoincidencia) {
        this.idTipincidencia = idTipoincidencia;
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
     * @return the Calcula
     */
    public int getCalcula() {
        return Calcula;
    }

    /**
     * @param Calcula the Calcula to set
     */
    public void setCalcula(int Calcula) {
        this.Calcula = Calcula;
    }

    /**
     * @return the idPery
     */
    public int getIdPery() {
        return idPery;
    }

    /**
     * @param idPery the idPery to set
     */
    public void setIdPery(int idPery) {
        this.idPery = idPery;
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
