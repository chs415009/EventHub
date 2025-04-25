package com.mycompany.EventHub.POJOs;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "events")
public class Event {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(length = 2000)
    private String description;
    
    @Column(name = "event_date", nullable = false)
    @Basic(fetch = FetchType.EAGER)
    private LocalDateTime eventDate;
    
    @Column
    private String location;
    
    @Column
    private String category;
    
    @Column(name = "max_capacity")
    private Integer maxCapacity;
    
    @Column(name = "image_url")
    private String imageUrl;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "organizer_id", nullable = false)
    private Organizer organizer;
    
    @ManyToMany(mappedBy = "registeredEvents")
    private Set<Customer> registeredCustomers = new HashSet<>();
    
    public Event() {
    }
    
    public Event(String title, String description, LocalDateTime eventDate, String location, Integer maxCapacity, Organizer organizer) {
        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.location = location;
        this.maxCapacity = maxCapacity;
        this.organizer = organizer;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public LocalDateTime getEventDate() {
        return eventDate;
    }
    
    public void setEventDate(LocalDateTime eventDate) {
        this.eventDate = eventDate;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public Integer getMaxCapacity() {
        return maxCapacity;
    }
    
    public void setMaxCapacity(Integer maxCapacity) {
        this.maxCapacity = maxCapacity;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public Organizer getOrganizer() {
        return organizer;
    }
    
    public void setOrganizer(Organizer organizer) {
        this.organizer = organizer;
    }
    
    public Set<Customer> getRegisteredCustomers() {
        return registeredCustomers;
    }
    
    public void setRegisteredCustomers(Set<Customer> registeredCustomers) {
        this.registeredCustomers = registeredCustomers;
    }
    
    public boolean isFull() {
        return maxCapacity != null && registeredCustomers.size() >= maxCapacity;
    }
    
    public int getRemainingCapacity() {
        if (maxCapacity == null) {
            return Integer.MAX_VALUE; // 無限制
        }
        return maxCapacity - registeredCustomers.size();
    }
    
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(eventDate);
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Event event = (Event) o;
        return Objects.equals(id, event.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", eventDate=" + eventDate +
                ", location='" + location + '\'' +
                ", maxCapacity=" + maxCapacity +
                ", organizerId=" + (organizer != null ? organizer.getId() : null) +
                ", registeredCustomers=" + registeredCustomers.size() +
                '}';
    }
}
