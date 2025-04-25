package com.mycompany.EventHub.DAO;

import com.mycompany.EventHub.POJOs.Customer;
import java.util.List;
import java.util.Optional;

public interface CustomerDAO {
	
    Customer save(Customer customer);
    
    Optional<Customer> findById(Long id);
    
    Optional<Customer> findByUsername(String username);
    
    List<Customer> findAll();
    
    List<Customer> findAllByEventId(Long eventId);
    
    List<Customer> searchByKeyword(String keyword);
    
    boolean existsByUsername(String username);
    
    boolean isCustomerRegisteredForEvent(Long customerId, Long eventId);
    
    int countCustomersByEventId(Long eventId);    
    
    void deleteById(Long id);
    
    void registerForEvent(Long customerId, Long eventId);
    
    void unregisterFromEvent(Long customerId, Long eventId);
}