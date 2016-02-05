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
                background-color: #0B6121;
        }
        -->
        </style>
    </head>
    <body>
        <table id="menu" style="width: 100%" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <!--#9FF781, peachpuff background-color: #317082-->
                <td width="100%" align="left" background="./Imagenes/fondos/barrasverdes.png">
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="25%">
                                <img src="/siscaim/Imagenes/cabecera01.png" align="left" width="400" height="75">
                            </td>
                            <td width="75%" align="center">
                                <table width="100%">
                                    <tr>
                                        <td width="100%" align="center">
                                            <span class="bigtitulo">SISTEMA DE CONTROL ADMINISTRATIVO INTEGRAL v1.0</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="100%" align="center">
                                            <div>
                                            <iframe id="frmMenu" frameborder="0" width="100%" height="100" src=""/>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table id="areatrab" style="width: 100%; height: 800px; background-color: #ffd891"><!--#ffd891-->
            <tr>
                <td style="width: 100%">
                    <div>
                    <iframe id="frmAT" frameborder="0" width="100%" height="700" src="Generales/IniciarSesion/login.jsp"/>
                    </div>
                </td>
            </tr>
        </table>
    </body>
</html>
