package com.mycompany.EventHub.DAO;

import com.mycompany.EventHub.POJOs.Admin;
import java.util.List;
import java.util.Optional;

public interface AdminDAO {
	
    Admin save(Admin admin);
    
    List<Admin> findAll();
    
    Optional<Admin> findByUsername(String username);
}
