package Modelo.Entidades;
/* @author germain */
import javax.persistence.*;
@Entity
@Table (name = "abono")
public class Abono {
  @Id
  @GeneratedValue
  @Column (name = "id_abono")
  private int id;
  @Column (name = "cantidad")
  private float cantidad;
  @Column (name = "concepto")
  private String concepto;
  @Column (name = "comprobante")
  private String comprobante;
  @Column (name  ="banco")
  private String banco;
  @Column (name="no_tarjeta")
  private String no_tarjeta;
  private int tipo;
  
  @Column (name = "che")
  private int che;
  public int getChe()   {
      return che;
  }
  public void setChe(int che)  {
      this.che = che;
  }
  public int getId()  {
    return id;   
  }
  public void setId(int id) {
    this.id = id;
  }
  public float getCantidad()  {
    return cantidad;
  }
  public void setCantidad(float cantidad) {
    this.cantidad = cantidad;
  }
  public String getConcepto() {
    return concepto;
  }
  public void setConcepto(String concepto)   {
    this.concepto = concepto;
  }
  public String getComprobante() {
    return comprobante;
  }
  public void setComprobante(String comprobante)   {
    this.comprobante = comprobante;
  }
  public String getBanco() {
    return banco;
  }
  public void setBanco(String banco)   {
    this.banco = banco;
  }
  public String getTarjeta() {
    return no_tarjeta;
  }
  public void setTarjeta(String no_tarjeta)   {
    this.no_tarjeta= no_tarjeta;
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
}
