package edu.cecyt9.model;
import java.util.Date;

public class User {
   String uname, password, email;
   Date registeredon;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getRegisteredon() {
        return registeredon;
    }

    public void setRegisteredon(Date registeredon) {
        this.registeredon = registeredon;
    }

    public String getUname() {
        return uname;
    }

    public void setUname(String uname) {
        this.uname = uname;
    }  
   
}
