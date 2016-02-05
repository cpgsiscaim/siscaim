/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades.Catalogos;

import javax.persistence.*;

/**
 *
 * @author usuario
 */
@Entity
@Table (name= "cat_tipos_documentos")
public class TipoDocumento {
    @Id
    @Column (name = "idtipodoc")
    @GeneratedValue(strategy=GenerationType.IDENTITY)    
    private int id;
    private String descripcion;
    @OneToOne (fetch=FetchType.EAGER)
    private CategoriaDoc categoria;
    private int estatus;

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
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the categoria
     */
    public CategoriaDoc getCategoria() {
        return categoria;
    }

    /**
     * @param categoria the categoria to set
     */
    public void setCategoria(CategoriaDoc categoria) {
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
}
