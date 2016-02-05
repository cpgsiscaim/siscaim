<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.HashMap"%>
<%@include file="/IniciarSistema/Inicializa.jsp" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
    </head>
    <body>
        <form id="frmImprimeReporte" name="frmImprimeReporte" action="<%=(request.getParameter("control")!=null)?request.getParameter("control"):""%>">
            <input name="pasoSig" type="hidden" value="<%=(request.getParameter("paso")!=null)?request.getParameter("paso"):""%>">
            <input name="dato1" type="hidden" value="<%=(request.getParameter("dato1")!=null)?request.getParameter("dato1"):""%>">
            <input name="dato2" type="hidden" value="<%=(request.getParameter("dato2")!=null)?request.getParameter("dato2"):""%>">
            <input name="dato3" type="hidden" value="<%=(request.getParameter("dato3")!=null)?request.getParameter("dato3"):""%>">
            <input name="dato4" type="hidden" value="<%=(request.getParameter("dato4")!=null)?request.getParameter("dato4"):""%>">
            <input name="dato5" type="hidden" value="<%=(request.getParameter("dato5")!=null)?request.getParameter("dato5"):""%>">
            <input name="dato6" type="hidden" value="<%=(request.getParameter("dato6")!=null)?request.getParameter("dato6"):""%>">
            <input name="dato7" type="hidden" value="<%=(request.getParameter("dato7")!=null)?request.getParameter("dato7"):""%>">
            <input name="dato8" type="hidden" value="<%=(request.getParameter("dato8")!=null)?request.getParameter("dato8"):""%>">
        </form>
    </body>
    <script>
        document.frmImprimeReporte.submit();
    </script>
</html>
