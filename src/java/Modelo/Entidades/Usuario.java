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
@Table(name="usuarios")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idusuario;
    private String usuario;
    private String pass;
    private String mailrecuperacion;
    private int estatus;
    
    @OneToOne(fetch=FetchType.EAGER)
    private Empleado empleado;
    
    @ManyToMany(cascade = CascadeType.ALL, fetch=FetchType.EAGER)
    private List<Operacion> operaciones = new ArrayList<Operacion>();
    
    public Usuario(){
        
    }

    public Usuario (String us, String pas){
        this.usuario = us;
        this.pass = pas;
    }
    
    public Usuario (String us, String pas, String mail, int est){
        this.usuario = us;
        this.pass = pas;
        this.mailrecuperacion = mail;
        this.estatus = est;
    }

    /**
     * @return the idusuario
     */
    public int getIdusuario() {
        return idusuario;
    }

    /**
     * @param idusuario the idusuario to set
     */
    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    /**
     * @return the pass
     */
    public String getPass() {
        return pass;
    }

    /**
     * @param pass the pass to set
     */
    public void setPass(String pass) {
        this.pass = pass;
    }

    /**
     * @return the mailrecuperacion
     */
    public String getMailrecuperacion() {
        return mailrecuperacion;
    }

    /**
     * @param mailrecuperacion the mailrecuperacion to set
     */
    public void setMailrecuperacion(String mailrecuperacion) {
        this.mailrecuperacion = mailrecuperacion;
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
     * @return the empleado
     */
    public Empleado getEmpleado() {
        return empleado;
    }

    /**
     * @param empleado the empleado to set
     */
    public void setEmpleado(Empleado empleado) {
        this.empleado = empleado;
    }

    /**
     * @return the menu
     */
    
    public List<Operacion> getOperaciones() {
        return operaciones;
    }
    
    /**
     * @param menu the menu to set
     */
    
    public void setOperaciones(List<Operacion> operaciones) {
        this.operaciones = operaciones;
    }
    
    public void addOperacion(Operacion op){
        this.operaciones.add(op);
    }

    /**
     * @return the usuario
     */
    public String getUsuario() {
        return usuario;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }
}
