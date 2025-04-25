package com.mycompany.EventHub.POJOs;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "customers")
@DiscriminatorValue("CUSTOMER")
public class Customer extends User {
    
    @ManyToMany
    @JoinTable(
        name = "customer_event_registrations",
        joinColumns = @JoinColumn(name = "customer_id"),
        inverseJoinColumns = @JoinColumn(name = "event_id")
    )
    private Set<Event> registeredEvents = new HashSet<>();
    
    public Customer() {
        super();
    }
    
    public Customer(Long id, String username, String password, String email, Integer age, 
            String fullName, Set<Event> registeredEvents) {
    	super(id, username, password, email, fullName);
    	this.registeredEvents = registeredEvents != null ? registeredEvents : new HashSet<>();
}
    
    public Set<Event> getRegisteredEvents() {
        return registeredEvents;
    }
    
    public void setRegisteredEvents(Set<Event> registeredEvents) {
        this.registeredEvents = registeredEvents;
    }
    
    public void registerEvent(Event event) {
        registeredEvents.add(event);
        event.getRegisteredCustomers().add(this);
    }
    
    public void dropEvent(Event event) {
        registeredEvents.remove(event);
        event.getRegisteredCustomers().remove(this);
    }
    
    @Override
    public String toString() {
        return "Customer{" +
                "id=" + getId() +
                ", username='" + getUsername() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", fullName='" + getFullName() + '\'' +
                '}';
    }
}