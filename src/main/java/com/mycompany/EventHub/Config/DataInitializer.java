package com.mycompany.EventHub.Config;

import com.mycompany.EventHub.DAO.AdminDAO;
import com.mycompany.EventHub.DAO.OrganizerDAO;
import com.mycompany.EventHub.DAO.CustomerDAO;
import com.mycompany.EventHub.DAO.EventDAO;
import com.mycompany.EventHub.POJOs.Admin;
import com.mycompany.EventHub.POJOs.Organizer;
import com.mycompany.EventHub.POJOs.Customer;
import com.mycompany.EventHub.POJOs.Event;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Configuration
public class DataInitializer {

    @Bean
    @Transactional
    public CommandLineRunner initData(AdminDAO adminDAO, OrganizerDAO organizerDAO, 
                                     CustomerDAO customerDAO, EventDAO eventDAO) {
        return args -> {
            if (adminDAO.findAll().isEmpty()) {
                Admin admin = new Admin();
                admin.setUsername("aaa");
                admin.setPassword("aaa");
                admin.setFullName("System Administrator");

                adminDAO.save(admin);

                System.out.println("Admin Created!");
            }
            else {
                System.out.println("Admin Exists!");
            }
            
            if (organizerDAO.findAll().isEmpty()) {
                Organizer organizer1 = createOrganizer("o1", "ooo111", "tech@example.com", "Tech Events Inc");
                Organizer organizer2 = createOrganizer("o2", "ooo222", "music@example.com", "Music Festivals Ltd");
                Organizer organizer3 = createOrganizer("o3", "ooo333", "sports@example.com", "Sports Events Co");
                
                organizerDAO.save(organizer1);
                organizerDAO.save(organizer2);
                organizerDAO.save(organizer3);
                
                System.out.println("Organizers Created!");
                
                LocalDateTime now = LocalDateTime.now();
                
                Event event1 = createEvent("Tech Conference 2025", "Annual technology conference featuring the latest innovations", 
                                          now.plusMonths(-2), "Convention Center", 5, "Technology", organizer1);
                Event event2 = createEvent("Coding Bootcamp", "Intensive three-day coding workshop for beginners", 
                                          now.plusMonths(1), "Tech Hub", 5, "Workshop", organizer1);
                Event event3 = createEvent("Summer Music Festival", "Three days of live music performances", 
                                          now.plusMonths(-3), "City Park", 5, "Music", organizer2);
                Event event4 = createEvent("Jazz Night", "Evening of jazz music with renowned artists", 
                                          now.plusDays(14), "Jazz Club", 2, "Music", organizer2);
                Event event5 = createEvent("Marathon 2025", "Annual city marathon", 
                                          now.plusMonths(-5), "City Center", 5, "Sports", organizer3);
                Event event6 = createEvent("Basketball Tournament", "Regional basketball championship", 
                                          now.plusMonths(1).plusDays(15), "Sports Arena", 3, "Sports", organizer3);
                Event event7 = createEvent("Business Networking Summit", "Connect with professionals from various industries", 
                        				  now.plusDays(-1), "Grand Hotel Conference", 8, "Others", organizer1);
				Event event8 = createEvent("Food & Wine Festival", "Celebrate culinary excellence with top chefs and wine experts", 
				                          now.plusMonths(2), "Riverside Park", 10, "Others", organizer1);				
				Event event9 = createEvent("Yoga Retreat Weekend", "Relax, rejuvenate and reconnect with nature", 
				                          now.plusWeeks(6), "Mountain View Resort", 6, "Others", organizer1);
				Event event10 = createEvent("Test", "Relax, rejuvenate and reconnect with nature", 
                        now.plusWeeks(6), "Mountain View Resort", 1, "Others", organizer1);
				Event event11 = createEvent("Test", "Relax, rejuvenate and reconnect with nature", 
                        now.plusWeeks(6), "Mountain View Resort", 1, "Others", organizer1);
				Event event12 = createEvent("Test", "Relax, rejuvenate and reconnect with nature", 
                        now.plusWeeks(6), "Mountain View Resort", 1, "Others", organizer1);
				Event event13 = createEvent("Test", "Relax, rejuvenate and reconnect with nature", 
                        now.plusWeeks(6), "Mountain View Resort", 1, "Others", organizer1);
                
                eventDAO.save(event1);
                eventDAO.save(event2);
                eventDAO.save(event3);
                eventDAO.save(event4);
                eventDAO.save(event5);
                eventDAO.save(event6);
                eventDAO.save(event7);
                eventDAO.save(event8);
                eventDAO.save(event9);
                eventDAO.save(event10);
                eventDAO.save(event11);
                eventDAO.save(event12);
                eventDAO.save(event13);
                
                System.out.println("Events Created!");
                
                Customer customer1 = createCustomer("c1", "ccc111", "john@example.com", "John Smith");
                Customer customer2 = createCustomer("c2", "ccc222", "emma@example.com", "Emma Johnson");
                Customer customer3 = createCustomer("c3", "ccc333", "david@example.com", "David Wilson");
                
                customerDAO.save(customer1);
                customerDAO.save(customer2);
                customerDAO.save(customer3);
                
                System.out.println("Customers Created!");
                
                customer1.registerEvent(event1);
                customer1.registerEvent(event2);
                customer1.registerEvent(event4);
                customer1.registerEvent(event7);
                customer1.registerEvent(event8);
                customer1.registerEvent(event9);
                
                customer2.registerEvent(event3);
                customer2.registerEvent(event4);
                
                customer3.registerEvent(event5);
                customer3.registerEvent(event6);
                
                customerDAO.save(customer1);
                customerDAO.save(customer2);
                customerDAO.save(customer3);
                
                System.out.println("Event Registrations Completed!");
            }
            else {
                System.out.println("Test Data Already Exists!");
            }
        };
    }
    
    private Organizer createOrganizer(String username, String password, String email, String fullName) {
        Organizer organizer = new Organizer();
        organizer.setUsername(username);
        organizer.setPassword(password);
        organizer.setEmail(email);
        organizer.setFullName(fullName);
        return organizer;
    }
    
    private Event createEvent(String title, String description, LocalDateTime eventDate, String location, 
                             Integer maxCapacity, String category, Organizer organizer) {
        Event event = new Event();
        event.setTitle(title);
        event.setDescription(description);
        event.setEventDate(eventDate);
        event.setLocation(location);
        event.setMaxCapacity(maxCapacity);
        event.setCategory(category);
        event.setOrganizer(organizer);
        
        organizer.addEvent(event);
        
        return event;
    }
    
    private Customer createCustomer(String username, String password, String email, String fullName) {
        Customer customer = new Customer();
        customer.setUsername(username);
        customer.setPassword(password);
        customer.setEmail(email);
        customer.setFullName(fullName);
        return customer;
    }
}