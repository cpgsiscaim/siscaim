/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function Mensaje(mensaje){
    newWindow('/siscaim/Utilerias/mensaje.jsp?mensaje='+mensaje,'SISCAIM',500,250,0,0,0,0,0,0,0);
    //window.open('/siscaim/Utilerias/mensaje.jsp?mensaje='+mensaje,'SISCAIM','dependent=1, resizable=0,width=400,height=200, toolbar=0, location=0, directories=0, status=0, menubar=0, scrollbars=0, titlebar= no');
}

function winConfirmar(){
    newWindow('/siscaim/Utilerias/confirmar.jsp','SISCAIM',400,200,0,0,0,0,0,0,0);
}

function newWindow(a_str_windowURL, a_str_windowName, a_int_windowWidth, a_int_windowHeight, a_bool_scrollbars, a_bool_resizable, a_bool_menubar, a_bool_toolbar, a_bool_addressbar, a_bool_statusbar, a_bool_fullscreen) {
    var int_windowLeft = (screen.width - a_int_windowWidth) / 2;
    var int_windowTop = (screen.height - a_int_windowHeight) / 2;
    var str_windowProperties = 'height=' + a_int_windowHeight + ',width=' + a_int_windowWidth + ',top=' + int_windowTop + ',left=' + int_windowLeft + ',scrollbars=' + a_bool_scrollbars + ',resizable=' + a_bool_resizable + ',menubar=' + a_bool_menubar + ',toolbar=' + a_bool_toolbar + ',location=' + a_bool_addressbar + ',statusbar=' + a_bool_statusbar + ',fullscreen=' + a_bool_fullscreen + '';
    var obj_window = window.open(a_str_windowURL, a_str_windowName, str_windowProperties)
    if (parseInt(navigator.appVersion) >= 4) {
        obj_window.window.focus();
    }
}

function ValidaAlfaNum(e){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    reg = /[a-zA-Z0-9]/;
    return reg.test(keychar);
}

function ValidaAlfa(e){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    reg = /[a-zA-Z]/;
    return reg.test(keychar);
}

function ValidaAlfaNumSignos(e){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    reg = /[a-zA-Z0-9\s\.\,ñÑ,áéíóúÁÉÍÓÚ-]/;
    return reg.test(keychar);    
}

function ValidaNums(e){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    reg = /[\d]/;
    return reg.test(keychar);
}

function ValidaRazonSocial(e, cadena){
    if (!ValidaAlfaNumSignos(e))
        return false;

    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);        
    if (cadena.length == 0 && (keychar == ' ' || keychar == '.' || keychar == ',' || keychar == '-'))
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == ' ' && keychar == ' ')
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == '.' && keychar == '.')
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == ',' && keychar == ',')
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == '-' && keychar == '-')
        return false;
        
    return true;
}

function Mayusculas(objeto){
    objeto.value = objeto.value.toUpperCase();
    objeto.value = objeto.value.trim();
}

function ValidaRFC(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length < 3){
        reg = /[a-zA-ZñÑ]/;
        return reg.test(keychar);
    }
    
    if (cadena.length == 3){
        reg = /[a-zA-ZñÑ-]/;
        return reg.test(keychar);
    }
    
    if (cadena.length == 4){
        if (cadena[cadena.length-1] == '-'){
            reg = /[\d]/;
        }
        else {
            reg = /[-]/;
        }
        return reg.test(keychar);
    }
    
    if ((cadena[3]=='-' && cadena.length >= 4 && cadena.length < 10)
        || (cadena[4]=='-' && cadena.length >= 5 && cadena.length < 11)){
        reg = /[\d]/;
        return reg.test(keychar);
    }
    
    if ((cadena[3]=='-' && cadena.length == 10)
        || (cadena[4]=='-' && cadena.length == 11)){
        reg = /[-]/;
        return reg.test(keychar);
    }

    if ((cadena[3]=='-' && cadena.length > 10 && cadena.length < 14)
        || (cadena[4]=='-' && cadena.length > 11 && cadena.length < 16)){
        reg = /[a-zA-ZñÑ\d]/;
        return reg.test(keychar);
    }
    
    if (cadena[3]=='-' && cadena.length == 14){
        return false;
    }
}

/*^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$*/
function ValidaMail(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    
    if (cadena.length == 0 && (keychar == '.'|| keychar == '@'))
        return false;
    
    //si ya tiene @ que no acepte otro
    arroba = false;
    for (i=0;i<cadena.length;i++){
        if (cadena[i]=='@'){
            arroba = true;
            break;
        }
    }
    
    if (arroba && keychar == '@')
        return false;
    
    reg = /[a-zA-Z0-9\.\-\_\@]/;
    return reg.test(keychar);
}

function ValidaNombrePropio(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);

    if (cadena.length == 0 && keychar == ' ')
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == ' ' && keychar == ' ')
        return false;
    
    reg = /[a-zA-Z\sáéíóúÁÉÍÓÚñÑ]/;
    return reg.test(keychar);
}

function ValidaNumsAfter(cadena){
    reg = /^([0-9])*$/;
    return reg.test(cadena);
}

function ValidaMailAfter(cadena){
    reg = /^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,3})$/;
    return reg.test(cadena);
}

function ValidaLetrasYPunto(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length == 0 && keychar == '.')
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == '.' && keychar == '.')
        return false;
    reg = /[a-zA-Z\.áéíóúÁÉÍÓÚñÑ]/;
    return reg.test(keychar);    
}


function ValidaLetrasAcenEspPun(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length == 0 && (keychar == '.' || keychar == ' '))
        return false;
    if (cadena.length > 0 && cadena[cadena.length-1] == '.' && keychar == '.')
        return false;
        if (cadena.length > 0 && cadena[cadena.length-1] == ' ' && keychar == ' ')
        return false;
    reg = /[a-zA-Z\s\.áéíóúÁÉÍÓÚñÑ]/;
    return reg.test(keychar);    
}

function ValidaPorcentaje(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length == 0 && keychar == '0')
        return false;
    reg = /\d/;
    p = 0;
    if (reg.test(keychar)){
        cadena=cadena+keychar;
        x = parseInt(cadena);
        if (x > 100)
            return false;
    }
    else
        return false;
    
    return true;
}

function ValidaNumsSinCeroInicial(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length == 0 && keychar == '0')
        return false;

    reg = /\d/;
    return reg.test(keychar);
}

function ValidaCantidad(e, cadena){
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (cadena.length == 0 && (keychar == '.'))
        return false;
    var punto = cadena.indexOf('.');
    if (punto != -1 && keychar == '.')
        return false;
    if (punto != -1){
        var sub = cadena.substr(punto+1,10);
        if (sub.length >= 2)
            return false;
    }
    if (cadena.length >= 8 && keychar == '.')
        return false;
    
    reg = /[0-9.]/;
    return reg.test(keychar);
}

function redondear(num)
{
    var original = parseFloat(num);
    var result = Math.round(original * 100) / 100;
    return result;
/*alert(num);
	var original=num;
	if ((original*100%100)>=0.5)
	{
		var result=Math.round(original*100)/100+0.01;
	}
	else
	{
		var result=Math.round(original*100)/100; 		
	}
        alert(result);
	return result;*/
}

function formato_numero(numero, decimales, separador_decimal, separador_miles){ // v2007-08-06
    numero=parseFloat(numero);
    if(isNaN(numero)){
        return "";
    }

    if(decimales!==undefined){
        // Redondeamos
        numero=numero.toFixed(decimales);
    }
    // Convertimos el punto en separador_decimal
    numero=numero.toString().replace(".", separador_decimal!=undefined ? separador_decimal : ".");
    if(separador_miles && parseFloat(numero)>=1000){
        // Añadimos los separadores de miles
        var miles=new RegExp("(-?[0-9]+)([0-9]{3})");
        while(miles.test(numero)) {
            numero=numero.replace(miles, "$1" + separador_miles + "$2");
        }
    }
    return numero;
}

function ShowSelection(obj)
{
  var textComponent = obj;
  var selectedText;
  // IE version
  if (document.selection != undefined)
  {
    textComponent.focus();
    var sel = document.selection.createRange();
    selectedText = sel.text;
  }
  // Mozilla version
  else if (textComponent.selectionStart != undefined)
  {
    var startPos = textComponent.selectionStart;
    var endPos = textComponent.selectionEnd;
    selectedText = textComponent.value.substring(startPos, endPos)
  }
  //alert("You selected: " + selectedText);
  return selectedText;
}

function ValidaCantidad2(e, obj){
    txtsel = ShowSelection(obj);
    if (txtsel !=''){
        if (obj.value == txtsel){
            obj.value = '';
            return ValidaCantidad(e, obj.value);
        } else {
            return ValidaCantidad(e, obj.value);
        }
    } else {
        return ValidaCantidad(e, obj.value);
    }
}

function Rellenar(cadena, caracter, cant, posicion){
    var i;
    if (caracter==' '){
        caracter = " ";
    }
    alert(cadena.length);
    var tope = cant-cadena.length;
    alert(tope);
    if (tope>0){
        for( i=0; i<tope; i++)
            if (posicion==0){
                cadena=caracter+cadena;
            } else {
                cadena=cadena+caracter;
            }
    }
    return cadena;
}

//RFC Y CURP
function obtenerCurp(paterno1st, materno1st, nombre, sexo, edo, fecha){
    paterno1st = paterno1st.replace("LAS","");
    paterno1st = paterno1st.replace("DEL","");
        
    var paterno  = paterno1st.replace("LA","");
    paterno = paterno.replace("DE","");
    paterno = paterno.replace("Y","");   
     
    while(paterno[0] == " "){
        paterno = paterno.substr(1, paterno.length - 1);
    }
    
    materno1st = materno1st.replace("LAS","");
    materno1st = materno1st.replace("DEL","");
    materno1st = materno1st.replace("DE","");
        
    var materno  = materno1st.replace("LA","");
    materno = materno.replace("Y","");
                
    while(materno[0] == " "){
        materno = materno.substr(1, materno.length - 1);
    }
    
    var op_paterno = paterno.length;
    var vocales = /^[aeiou]/i;
    var consonantes = /^[bcdfghjklmnñpqrstvwxyz]/i;
    
    var s1 = '';
    var s2 = '';
    var s8 = '';

    var i = 0;
    var x= true;
    var z = true;

    while(i < op_paterno){
        if((consonantes.test(paterno[i]) == true) & (x != false)){
            s1 = s1 + paterno[i];
            paterno = paterno.replace(paterno[i],"");
            x=false;
        }
        
        if((vocales.test(paterno[i]) == true) & (z != false)){
            s2 = s2 + paterno[i];
            paterno = paterno.replace(paterno[i],"");
            z=false;
        }
        i++;
    }

    var ix=0;
    var y = true;
    var nparteno = paterno.length;
    
    while(ix < nparteno){
        if((consonantes.test(paterno[ix]) == true) & (y != false)){
            s8 = s8 + paterno[ix];
            y=false;
        }
        ix++;
    }

    //calculos apellido materno
    var maternosize = materno.length;
    var j = 1;
    var s9 = '';
    var xm = true;
    var ym = true;
    
    while(j < maternosize){
        if((consonantes.test(materno[j]) == true) && (xm != false)){
            s9 = s9.replace(materno[j],"");
            xm = false;
        }
        
        if((consonantes.test(materno[j]) == true) && (ym != false)){
            s9 = s9 + materno[j];
            ym = false;
        }
        
        j++;
    }
    
    var nombresize = nombre.length;
    var im = 1;
    var s10= '';
    var wx = true;
    var wz = true;
    
    while(im < nombresize){
        
        if((consonantes.test(nombre[im]) == true)&& (wz != false)){
            s10 = s10 + nombre[im];
            nombre = nombre.replace(nombre[im],"");
            wz = false;
        }
        im++;
    }
    
    if( sexo == 'M'){ sexo = 'H';}else{ sexo ='M';}
       

    
    switch(edo){
        case "AGUASCALIENTES": edo="AS"; break;
        case "BAJA CALIFORNIA":edo="BC"; break;
        case "BAJA CALIFORNIA SUR": edo="BS"; break;
        case "CAMPECHE": edo="CC"; break;
        case "COAHUILA": edo="CL"; break;
        case "COLIMA": edo="CM"; break;
        case "CHIAPAS": edo="CS"; break;
        case "CHIHUAHUA": edo="CH"; break;
        case "DISTRITO FEDERAL": edo="DF"; break;
        case "DURANGO": edo="DG"; break;
        case "GUANAJUATO": edo="GT"; break;
        case "GUERRERO": edo="GR"; break;
        case "HIDALGO": edo="HG"; break;
        case "JALISCO": edo="JC"; break;
        case "ESTADO DE MEXICO": edo="MC"; break;
        case "MICHOACAN": edo="MN"; break;
        case "MORELOS": edo="MS"; break;
        case "NAYARIT": edo="NT"; break;
        case "NUEVO LEON": edo="NL"; break;
        case "OAXACA": edo="OC"; break;
        case "PUEBLA": edo="PL"; break;
        case "QUERETARO": edo="QT"; break;
        case "QUINTANA ROO": edo="QR"; break;
        case "SAN LUIS POTOSI": edo="SP"; break;
        case "SINALOA": edo="SL"; break;
        case "SONORA": edo="SR"; break;
        case "TABASCO": edo="TC"; break;
        case "TAMAULIPAS": edo="TS"; break;
        case "TLAXCALA": edo="TL"; break;
        case "VERACRUZ": edo="VZ"; break;
        case "YUCATAN": edo="YN"; break;
        case "ZACATECAS": edo="ZS"; break;
    }
    
    var s3 = materno[0];
    var s4 = nombre[0];
    
    var fechaSplit = fecha.split("-");
    
    var s5 = fechaSplit[2][2]+fechaSplit[2][3];
    var s6 = fechaSplit[1];
    var s7 = fechaSplit[0];
    
    return (s1+s2+s3+s4+s5+s6+s7+sexo+edo+s8+s9+s10).toUpperCase();
}

function obtenerRfc(paterno1st, materno1st, nombre, fecha){
    paterno1st = paterno1st.replace("LAS","");
    paterno1st = paterno1st.replace("DEL","");
        
    var paterno  = paterno1st.replace("LA","");
        paterno = paterno.replace("DE","");
        paterno = paterno.replace("Y","");   
     
    while(paterno[0] == " "){
        paterno = paterno.substr(1, paterno.length - 1);
    }
    
    materno1st = materno1st.replace("LAS","");
        materno1st = materno1st.replace("DEL","");
        materno1st = materno1st.replace("DE","");
        
    var materno  = materno1st.replace("LA","");
        materno = materno.replace("Y","");
                
    while(materno[0] == " "){
        materno = materno.substr(1, materno.length - 1);
    }
    
    var op_paterno = paterno.length;
    var vocales = /^[aeiou]/i;
    var consonantes = /^[bcdfghjklmnñpqrstvwxyz]/i;
    
    var s1 = '';
    var s2 = '';
    //var s8 = '';

    var i = 0;
    var x= true;
    var z = true;

    while(i < op_paterno){
        if((consonantes.test(paterno[i]) == true) & (x != false)){
            s1 = s1 + paterno[i];
            paterno = paterno.replace(paterno[i],"");
            x=false;
        }
        
        if((vocales.test(paterno[i]) == true) & (z != false)){
            s2 = s2 + paterno[i];
            paterno = paterno.replace(paterno[i],"");
            z=false;
        }
        i++;
    }

    /*var ix=0;
    var y = true;
    var nparteno = paterno.length;
    
    while(ix < nparteno){
        if((consonantes.test(paterno[ix]) == true) & (y != false)){
            s8 = s8 + paterno[ix];
            y=false;
        }
        ix++;
    }

    //calculos apellido materno
    var maternosize = materno.length;
    var j = 1;
    var s9 = '';
    var xm = true;
    var ym = true;
    
    while(j < maternosize){
        if((consonantes.test(materno[j]) == true) && (xm != false)){
            s9 = s9.replace(materno[j],"");
            xm = false;
        }
        
        if((consonantes.test(materno[j]) == true) && (ym != false)){
            s9 = s9 + materno[j];
            ym = false;
        }
        
        j++;
    }
    
    var nombresize = nombre.length;
    var im = 1;
    var s10= '';
    var wx = true;
    var wz = true;
    
    while(im < nombresize){
        
        if((consonantes.test(nombre[im]) == true)&& (wz != false)){
            s10 = s10 + nombre[im];
            nombre = nombre.replace(nombre[im],"");
            wz = false;
        }
        im++;
    }*/
    
    var s3 = materno[0];
    var s4 = nombre[0];
    
    var fechaSplit = fecha.split("-");
    
    var s5 = fechaSplit[2][2]+fechaSplit[2][3];
    var s6 = fechaSplit[1];
    var s7 = fechaSplit[0];
    
    return (s1+s2+s3+s4+s5+s6+s7).toUpperCase();
    //document.getElementById('txt_CURP').value = s1+s2+s3+s4+s5+s6+s7+sexo+edo+s8+s9+s10;
}

function telefono(numero){
    var long = numero.length;
    if(long==10){
      var nuevos_numeritos="";
      for(i=0; i<long; i++){
        if(i==2 || i==5){
          nuevos_numeritos+=numero.charAt(i)+"-";
        }else{
          nuevos_numeritos+=numero.charAt(i);
        }
      }
      numero = nuevos_numeritos;
    }
    return numero;
}

function LLamadaAjax(){
    // Llama objeto XMLHttpRequest
     if (window.XMLHttpRequest) {
       req = new XMLHttpRequest();    

     // Si no funciona intenta utiliar el objeto IE/Windows ActiveX 
     } else if (window.ActiveXObject) {
       req = new ActiveXObject("Microsoft.XMLHTTP"); 
     }
     return req;
 }
 
 function nuevoAjax()
{ 
	/* Crea el objeto AJAX. Esta funcion es generica para cualquier utilidad de este tipo, por
	lo que se puede copiar tal como esta aqui */
	var xmlhttp=false;
	try
	{
		// Creacion del objeto AJAX para navegadores no IE
		xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(e)
	{
		try
		{
			// Creacion del objet AJAX para IE
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		catch(E)
		{
			if (!xmlhttp && typeof XMLHttpRequest!='undefined') xmlhttp=new XMLHttpRequest();
		}
	}
	return xmlhttp; 
}

function redondear2(numero, decimales)
{
    var flotante = parseFloat(numero);
    var resultado = Math.round(flotante*Math.pow(10,decimales))/Math.pow(10,decimales);
    return resultado;
}

function sumarFecha(d, fecha)
{
    var Fecha = new Date();
    var sFecha = fecha || (Fecha.getDate() + "/" + (Fecha.getMonth() +1) + "/" + Fecha.getFullYear());
    var sep = sFecha.indexOf('/') != -1 ? '/' : '-'; 
    var aFecha = sFecha.split(sep);
    var fecha = aFecha[2]+'/'+aFecha[1]+'/'+aFecha[0];
    fecha= new Date(fecha);
    fecha.setDate(fecha.getDate()+parseInt(d));
    var anno=fecha.getFullYear();
    var mes= fecha.getMonth()+1;
    var dia= fecha.getDate();
    mes = (mes < 10) ? ("0" + mes) : mes;
    dia = (dia < 10) ? ("0" + dia) : dia;
    var fechaFinal = dia+sep+mes+sep+anno;
    return (fechaFinal);
 }