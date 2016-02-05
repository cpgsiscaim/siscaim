/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import Modelo.Entidades.Catalogos.TipoMedio;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table (name="medios")
public class Medio {
    @Id
    @Column (name="medi_id")
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    @Column (name="medi_medio")
    private String medio;
    private String extension;
    
    @OneToOne (fetch= FetchType.EAGER)
    private TipoMedio tipo;
    
    public Medio(){        
    }

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
     * @return the medio
     */
    public String getMedio() {
        return medio;
    }

    /**
     * @param medio the medio to set
     */
    public void setMedio(String medio) {
        this.medio = medio;
    }

    /**
     * @return the tipo
     */
    public TipoMedio getTipo() {
        return tipo;
    }

    /**
     * @param tipo the tipo to set
     */
    public void setTipo(TipoMedio tipo) {
        this.tipo = tipo;
    }
    
    public String getFormatoTelefono(){
        String formatTel = medio;
        if (medio.length()==10){
            formatTel = "";
            for (int i=0; i < medio.length(); i++){
                if(i==2 || i==5){
                  formatTel+=medio.charAt(i)+"-";
                }else{
                  formatTel+=medio.charAt(i);
                }
            }
        }
        
        return formatTel;
    }

    /**
     * @return the extension
     */
    public String getExtension() {
        return extension;
    }

    /**
     * @param extension the extension to set
     */
    public void setExtension(String extension) {
        this.extension = extension;
    }
    
    /*public String getTelefono() {
        String tel = medio;
        if (medio.length()==10){
            tel = "";
            for (int i=0; i < medio.length(); i++){
                if (i==2 || i==5)
                    tel+=medio.charAt(i)+"-";
                else
                    tel+=medio.charAt(i);
            }
        }
        return tel;
    }*/
    
}
