package Modelo.Entidades;
/**  @author germain */

import javax.persistence.*;
import java.util.Date;
@Entity
@Table (name = "movimientos_ch")
public class Movimientos {
  @Id
  @Column (name = "id_movimiento")
  @GeneratedValue(strategy=GenerationType.IDENTITY)
  private int id;
  @OneToOne(fetch=FetchType.EAGER)
  private Chequera cheq;
  @OneToOne(cascade = CascadeType.ALL, fetch=FetchType.EAGER)
  private Abono abon;
  @OneToOne(cascade = CascadeType.ALL,fetch=FetchType.EAGER)
  private Cargo carg;  
  @Temporal(TemporalType.DATE)
  private Date fecha;
  @Column (name = "saldo")
  private float saldo;
  private int tipo;
  private String referencia;
  
  public int getId()  {
    return id;
  }
  public void setId(int id) {
    this.id = id;
  }
  public Chequera getId_ch() {
    return cheq;
  }
  public void setId_ch(Chequera cheq)  {
    this.cheq = cheq;
  }
  public Abono getId_ab() {
    return abon;
  }
  public void setId_ab(Abono abon)  {
    this.abon = abon;
  }
  public Cargo getId_ca() {
    return carg;
  }
  public void setId_ca(Cargo carg) {
    this.carg = carg;
  }
  public Date getFecha()  {
    return fecha;    
  }
  public void setFecha(Date fecha)  {
    this.fecha = fecha;
  }
  public float getSaldo() {
    return saldo;
  }
  public void setSaldo(float saldo) {
    this.saldo = saldo;
  }

    /**
     * @return the tipo
     */
    public int getTipo() {
        return tipo;
    }

    /**
     * @param tipo the tipo to set
     */
    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    /**
     * @return the referencia
     */
    public String getReferencia() {
        return referencia;
    }

    /**
     * @param referencia the referencia to set
     */
    public void setReferencia(String referencia) {
        this.referencia = referencia;
    }
}
