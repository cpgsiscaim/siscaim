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
@Table (name="tnomina")
public class TipoNomina {
    
    @Id
    private int idTnomina;    
    private String Descripcion;
    private int Estatus;
    

    public TipoNomina(){
        
    }

    /**
     * @return the idTnomina
     */
    public int getIdTnomina() {
        return idTnomina;
    }

    /**
     * @param idTnomina the idTnomina to set
     */
    public void setIdTnomina(int idTnomina) {
        this.idTnomina = idTnomina;
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
