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
@Table (name="peryded")
public class PeryDed {
    @Id
    private int idPeryded;    
    private String Descripcion;    
    private int GraoExe;
    private String Orden;    
    private int PeroDed;
    private int Estatus;
    private float factor;
    
    public PeryDed(){
        
    }

    /**
     * @return the idPeryded
     */
    public int getIdPeryded() {
        return idPeryded;
    }

    /**
     * @param idPeryded the idPeryded to set
     */
    public void setIdPeryded(int idPeryded) {
        this.idPeryded = idPeryded;
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
     * @return the GraoExe
     */
    public int getGraoExe() {
        return GraoExe;
    }

    /**
     * @param GraoExe the GraoExe to set
     */
    public void setGraoExe(int GraoExe) {
        this.GraoExe = GraoExe;
    }

    /**
     * @return the Orden
     */
    public String getOrden() {
        return Orden;
    }

    /**
     * @param Orden the Orden to set
     */
    public void setOrden(String Orden) {
        this.Orden = Orden;
    }

    /**
     * @return the PeroDed
     */
    public int getPeroDed() {
        return PeroDed;
    }

    /**
     * @param PeroDed the PeroDed to set
     */
    public void setPeroDed(int PeroDed) {
        this.PeroDed = PeroDed;
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

    /**
     * @return the factor
     */
    public float getFactor() {
        return factor;
    }

    /**
     * @param factor the factor to set
     */
    public void setFactor(float factor) {
        this.factor = factor;
    }
}
