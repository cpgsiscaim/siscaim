/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;
/**
 *
 * @author roman
 */
import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

@Entity
@Table (name="ct_edocivil")
public class Civil {
    
    @Id
    private int idEdoCivil;    
    private String EdoCivil;
    private int Estatus;
    
    public Civil(){
        
    }

    /**
     * @return the idEdoCivil
     */
    public int getIdEdoCivil() {
        return idEdoCivil;
    }

    /**
     * @param idEdoCivil the idEdoCivil to set
     */
    public void setIdEdoCivil(int idEdoCivil) {
        this.idEdoCivil = idEdoCivil;
    }

    /**
     * @return the EdoCivil
     */
    public String getEdoCivil() {
        return EdoCivil;
    }

    /**
     * @param EdoCivil the EdoCivil to set
     */
    public void setEdoCivil(String EdoCivil) {
        this.EdoCivil = EdoCivil;
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
