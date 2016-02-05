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
@Table (name="ct_gposang")
public class GpoSanguineo {

    @Id
    private int idGpoSang;    
    private String GpoSang;
    private int Estatus;
    
    public GpoSanguineo(){
        
    }

    /**
     * @return the idGpoSang
     */
    public int getIdGpoSang() {
        return idGpoSang;
    }

    /**
     * @param idGpoSang the idGpoSang to set
     */
    public void setIdGpoSang(int idGpoSang) {
        this.idGpoSang = idGpoSang;
    }

    /**
     * @return the GpoSang
     */
    public String getGpoSang() {
        return GpoSang;
    }

    /**
     * @param GpoSang the GpoSang to set
     */
    public void setGpoSang(String GpoSang) {
        this.GpoSang = GpoSang;
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
