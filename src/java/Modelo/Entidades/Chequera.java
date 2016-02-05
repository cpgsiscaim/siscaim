package Modelo.Entidades;
/** @author germain  */
import javax.persistence.*;
import java.util.Date;
@Entity
@Table (name = "chequera")
public class Chequera {
  @Id
  @GeneratedValue
  @Column (name = "id_chequera")
  private int id;
  @OneToOne (fetch=FetchType.EAGER)
  private Sucursal sucursal;
  @Column (name = "estado")
  private String estado;
  @OneToOne (fetch=FetchType.EAGER)
  private Usuario user;  
  @Column (name = "saldo")
  private float saldo;
  @Column (name = "titular")
  private String titular;
  @Column (name = "cuenta")
  private String cuenta;
  @Column (name = "clabe")
  private String clabe;
  private int estatus;
  @OneToOne (fetch=FetchType.EAGER)
  private Usuario ustitular; 
  
  public int getId()  {
    return id;
  }
  public void setId(int id) {
    this.id = id;
  }
  public Sucursal getAlmacen() {
    return sucursal;
  }
  public void setAlmacen(Sucursal sucursal)  {
    this.sucursal = sucursal;
  }
  public String getEstado() {
    return estado;
  }
  public void setEstado(String estado) {
    this.estado = estado;
  }
  public Usuario getResponsable()  {
    return user;
  }
  public void setResponsable(Usuario user)  {
    this.user = user;
  }
  public float getSaldo() {
    return saldo;
  }
  public void setSaldo(float saldo)  {
    this.saldo = saldo;
  }
  public String getTitular()  {
    return titular;
  }
  public void setTitular(String titular)  {
    this.titular = titular;
  }
  public String getCuenta() {
    return cuenta;    
  }
  public void setCuenta(String cuenta) {
    this.cuenta = cuenta;
  }
  public String getClabe()  {
    return clabe;
  }
  public void setClabe(String clabe)  {
    this.clabe = clabe;
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
     * @return the ustitular
     */
    public Usuario getUstitular() {
        return ustitular;
    }

    /**
     * @param ustitular the ustitular to set
     */
    public void setUstitular(Usuario ustitular) {
        this.ustitular = ustitular;
    }
}