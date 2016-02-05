/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table(name="categorias_operaciones")
public class CategoriaOp {
    
    @Id
    private int idcatop;
    private String categoria;
    private int estatus;    
    private int padre;
    
    public CategoriaOp(){
        
    }

    /**
     * @return the idcatop
     */
    public int getIdcatop() {
        return idcatop;
    }

    /**
     * @param idcatop the idcatop to set
     */
    public void setIdcatop(int idcatop) {
        this.idcatop = idcatop;
    }

    /**
     * @return the categoria
     */
    public String getCategoria() {
        return categoria;
    }

    /**
     * @param categoria the categoria to set
     */
    public void setCategoria(String categoria) {
        this.categoria = categoria;
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
     * @return the padre
     */
    public int getPadre() {
        return padre;
    }

    /**
     * @param padre the padre to set
     */
    public void setPadre(int padre) {
        this.padre = padre;
    }
    
}
