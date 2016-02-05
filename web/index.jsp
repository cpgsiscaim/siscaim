<%-- 
    Document   : index
    Created on : 13-abr-2012, 0:50:37
    Author     : TEMOC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="/siscaim/Estilos/estilos.css" rel="stylesheet" />
        <title>SISCAIM v1.0</title>
        <style type="text/css">
        <!--
        body {
                margin-left: 0px;
                margin-top: 0px;
                margin-right: 0px;
                margin-bottom: 0px;
                background-color: #2A876C;
        }
        -->
        </style>
    </head>
    <body>
        <table id="menu" style="width: 100%">
            <tr>
                <!--background-color: #317082 #03476F-->
                <td style="width: 30%; height: 100px;" align="left">
                    <img src="/siscaim/Imagenes/cabecera08.png" align="center" width="100%" height="100%">
                </td>
            </tr>
        </table>
        <table id="areatrab" style="width: 100%; height: 800px; background-color: #ffd891" BACKGROUND="/siscaim/Imagenes/fondos/fondosiscaim04.png"><!--#ffd891-->
            <tr>
                <td style="width: 100%">
                    <iframe id="frmAT" frameborder="0" width="100%" height="800" src="Generales/IniciarSesion/login.jsp"/>
                </td>
            </tr>
        </table>
    </body>
</html>
