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
@Table (name="puestos")
public class Puestos {
    @Id
    private int idPuestos;    
    private String Descripcion;    
    private Double salario;
    private int Estatus;

    public Puestos(){
        
    }

    /**
     * @return the idPuestos
     */
    public int getIdPuestos() {
        return idPuestos;
    }

    /**
     * @param idPuestos the idPuestos to set
     */
    public void setIdPuestos(int idPuestos) {
        this.idPuestos = idPuestos;
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
     * @return the salario
     */
    public Double getSalario() {
        return salario;
    }

    /**
     * @param salario the salario to set
     */
    public void setSalario(Double salario) {
        this.salario = salario;
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
