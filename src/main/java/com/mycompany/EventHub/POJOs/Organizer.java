package com.mycompany.EventHub.POJOs;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "organizers")
@DiscriminatorValue("ORGANIZER")
public class Organizer extends User  {
	
	@OneToMany(mappedBy = "organizer", cascade = CascadeType.ALL, orphanRemoval = true)
	private List<Event> events = new ArrayList<>();
	
	public Organizer() {
        super();
    }

	public Organizer(Long id, String username, String password, String email, Integer age, 
            String fullName, List<Event> events) {
		super(id, username, password, email, fullName);  
		this.events = events != null ? events : new ArrayList<>();
	}

	public List<Event> getEvents() {
		return events;
	}

	public void setEvents(List<Event> events) {
		this.events = events;
	}
	
	public void addEvent(Event event) {
        events.add(event);
        event.setOrganizer(this);
    }
	
	public void removeEvent(Event event) {
        events.remove(event);
        event.setOrganizer(null);
    }
    
    @Override
    public String toString() {
        return "Organizer{" +
                "id=" + getId() +
                ", username='" + getUsername() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", fullName='" + getFullName() + '\'' +
                '}';
    }
}
