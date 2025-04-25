package com.mycompany.EventHub.DAO;

import com.mycompany.EventHub.POJOs.Organizer;
import java.util.List;
import java.util.Optional;

public interface OrganizerDAO {
	
    Organizer save(Organizer organizer);
    
    Optional<Organizer> findById(Long id);
    
    Optional<Organizer> findByUsername(String username);
    
    List<Organizer> findAll();
    
    List<Organizer> searchByKeyword(String keyword);
        
    boolean existsByUsername(String username);
    
    void deleteById(Long id);
}