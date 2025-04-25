package com.mycompany.EventHub.DAO;

import com.mycompany.EventHub.POJOs.Event;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface EventDAO {
	
    Event save(Event event);
    
    Optional<Event> findById(Long id);
    
    List<Event> findAll();
    
    List<Event> findByOrganizerId(Long organizerId);
    
    List<Event> findByCategory(String category);
    
    List<Event> findPastEvents(LocalDateTime now);
    
    List<Event> searchByKeyword(String keyword); //search by title, description, category

    int countRegisteredCustomers(Long eventId);

    void deleteById(Long id);    
}