/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.cecyt9.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author EMMANUEL
 */
public class VerSession extends HttpServlet {
private static final long serialVersionUID = 1L;
 
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    HttpSession misession= (HttpSession) request.getSession();
    int miNumberSession= (Integer) misession.getAttribute("numberSession");
 
PrintWriter pw= response.getWriter();
pw.println("<html><body> Este es mi numero de sesion: "+ miNumberSession +"</body></html>");
pw.close();
}
}