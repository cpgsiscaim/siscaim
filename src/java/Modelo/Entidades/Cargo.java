package Modelo.Entidades;
/* @author germain */
import javax.persistence.*;
@Entity
@Table (name = "cargo")
public class Cargo {
  @Id
  @GeneratedValue
  @Column (name = "id_cargo")
  private int id;
  @Column (name = "cantidad")
  private float cantidad;
  @Column (name = "concepto")
  private String concepto;
  @Column (name = "comprobante")
  private String comprobante;
  @Column (name = "proveedor")
  private String proveedor;
  @Column (name = "t_pago")
  private int t_pago;
  @Column (name = "ruta_comp")
  private String ruta;
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
  public String getConcepto()   {
    return concepto;
  }
  public void setConcepto(String concepto)  {
    this.concepto = concepto;
  }
  public String getComprobante()  {
    return comprobante;
  }
  public void setComprobante(String comp) {
    this.comprobante = comp;
  }
  public String getProveedor()  {
    return proveedor;
  }
  public void setProveedor(String proveedor)  {
    this.proveedor = proveedor;
  }
  public int getT_pago() {
    return t_pago;
  }
  public void setT_pago(int t_pago)  {
    this.t_pago = t_pago;
  }
  public String getRutaComprobante()  {
    return ruta;
  }
  public void setRutaComprobante(String ruta)  {
    this.ruta = ruta;
  }
}
