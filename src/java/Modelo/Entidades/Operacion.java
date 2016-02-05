/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo.Entidades;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

/**
 *
 * @author TEMOC
 */
@Entity
@Table(name="operaciones")
public class Operacion {
    
    @Id
    private int idoperacion;
    private String operacion;
    private int estatus;
    private String controlador;
    private String vista;
   
    @OneToOne(fetch=FetchType.EAGER)
    private CategoriaOp categoria;
    
    public Operacion(){
        
    }

    /**
     * @return the idoperacion
     */
    public int getIdoperacion() {
        return idoperacion;
    }

    /**
     * @param idoperacion the idoperacion to set
     */
    public void setIdoperacion(int idoperacion) {
        this.idoperacion = idoperacion;
    }

    /**
     * @return the operacion
     */
    public String getOperacion() {
        return operacion;
    }

    /**
     * @param operacion the operacion to set
     */
    public void setOperacion(String operacion) {
        this.operacion = operacion;
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
     * @return the controlador
     */
    public String getControlador() {
        return controlador;
    }

    /**
     * @param controlador the controlador to set
     */
    public void setControlador(String controlador) {
        this.controlador = controlador;
    }

    /**
     * @return the vista
     */
    public String getVista() {
        return vista;
    }

    /**
     * @param vista the vista to set
     */
    public void setVista(String vista) {
        this.vista = vista;
    }

    /**
     * @return the categoria
     */
    public CategoriaOp getCategoria() {
        return categoria;
    }

    /**
     * @param categoria the categoria to set
     */
    public void setCategoria(CategoriaOp categoria) {
        this.categoria = categoria;
    }


}
