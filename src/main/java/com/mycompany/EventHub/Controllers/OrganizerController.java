package com.mycompany.EventHub.Controllers;

import com.mycompany.EventHub.DAO.EventDAO;
import com.mycompany.EventHub.DAO.OrganizerDAO;
import com.mycompany.EventHub.POJOs.Event;
import com.mycompany.EventHub.POJOs.Organizer;
import com.mycompany.EventHub.Validators.EventValidator;
import com.mycompany.EventHub.Validators.OrganizerValidator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/organizer")
public class OrganizerController {

    @Autowired
    private OrganizerDAO organizerDAO;
    
    @Autowired
    private EventDAO eventDAO;
    
    @Autowired
    private EventValidator eventValidator;
    
    @Autowired
    private OrganizerValidator organizerValidator;
    
    private boolean isOrganizer(HttpSession session) {
        return session.getAttribute("userType") != null && 
               session.getAttribute("userType").equals("organizer");
    }
    
    private Long getCurrentOrganizerId(HttpSession session) {
        return (Long) session.getAttribute("userId");
    }
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        
        List<Event> upcomingEvents = eventDAO.findByOrganizerId(organizerId);
        upcomingEvents = upcomingEvents.stream()
                .filter(event -> event.getEventDate().isAfter(LocalDateTime.now()))
                .sorted((e1, e2) -> e1.getEventDate().compareTo(e2.getEventDate()))
                .limit(3)
                .toList();
        
        List<Event> pastEvents = eventDAO.findByOrganizerId(organizerId);
        pastEvents = pastEvents.stream()
                .filter(event -> event.getEventDate().isBefore(LocalDateTime.now()))
                .sorted((e1, e2) -> e2.getEventDate().compareTo(e1.getEventDate()))
                .limit(3)
                .toList();
        
        int totalEvents = eventDAO.findByOrganizerId(organizerId).size();
        int totalParticipants = 0;
        for (Event event : eventDAO.findByOrganizerId(organizerId)) {
            totalParticipants += eventDAO.countRegisteredCustomers(event.getId());
        }
        
        model.addAttribute("upcomingEvents", upcomingEvents);
        model.addAttribute("pastEvents", pastEvents);
        model.addAttribute("totalEvents", totalEvents);
        model.addAttribute("totalParticipants", totalParticipants);
        
        return "organizer/dashboard";
    }
    
    @GetMapping("/events")
    public String listEvents(HttpSession session, Model model, @RequestParam(required = false) String keyword) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        List<Event> events;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            events = eventDAO.searchByKeyword(keyword);
            events = events.stream()
                    .filter(event -> event.getOrganizer().getId().equals(organizerId))
                    .toList();
            model.addAttribute("keyword", keyword);
        } 
        else {
            events = eventDAO.findByOrganizerId(organizerId);
        }
        
        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentDateTime", now);
        
        model.addAttribute("events", events);
        return "organizer/events";
    }
    
    @GetMapping("/events/create")
    public String createEventForm(HttpSession session, Model model) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        model.addAttribute("event", new Event());
        return "organizer/createEvent";
    }
    
    @PostMapping("/events/create")
    public String createEvent(HttpSession session, @ModelAttribute Event event, 
                              BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Organizer> organizerOpt = organizerDAO.findById(organizerId);       
        event.setOrganizer(organizerOpt.get());
        
        eventValidator.validate(event, result);      
        if (result.hasErrors()) {
            return "organizer/createEvent";
        }
        
        eventDAO.save(event);
        redirectAttributes.addFlashAttribute("success", "Event created successfully");
        return "redirect:/organizer/events";
    }
    
    @GetMapping("/events/edit/{id}")
    public String editEventForm(HttpSession session, @PathVariable Long id, 
                                Model model, RedirectAttributes redirectAttributes) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Event> eventOpt = eventDAO.findById(id);
        Event event = eventOpt.get();
        
        //check if event belongs to organizer
        if (!event.getOrganizer().getId().equals(organizerId)) {
            redirectAttributes.addFlashAttribute("error", "You can only edit your own events");
            return "redirect:/organizer/events";
        }
        
        model.addAttribute("event", event);
        return "organizer/editEvent";
    }
    
    @PostMapping("/events/edit/{id}")
    public String updateEvent(HttpSession session, @PathVariable Long id, @ModelAttribute Event event, 
                              BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Optional<Event> existingEventOpt = eventDAO.findById(id);       
        Event existingEvent = existingEventOpt.get();
        
        eventValidator.validate(event, result);        
        if (result.hasErrors()) {
            return "organizer/editEvent";
        }
        
        existingEvent.setTitle(event.getTitle());
        existingEvent.setDescription(event.getDescription());
        existingEvent.setEventDate(event.getEventDate());
        existingEvent.setLocation(event.getLocation());
        existingEvent.setMaxCapacity(event.getMaxCapacity());
        existingEvent.setCategory(event.getCategory());
        existingEvent.setImageUrl(event.getImageUrl());
        
        eventDAO.save(existingEvent);
        redirectAttributes.addFlashAttribute("success", "Event updated successfully");
        return "redirect:/organizer/events";
    }
    
    @GetMapping("/events/delete/{id}")
    public String deleteEvent(HttpSession session, @PathVariable Long id, RedirectAttributes redirectAttributes) {
    	
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Event> eventOpt = eventDAO.findById(id);       
        Event event = eventOpt.get();
        
        //check if event belongs to organizer
        if (!event.getOrganizer().getId().equals(organizerId)) {
            redirectAttributes.addFlashAttribute("error", "You can only delete your own events");
            return "redirect:/organizer/events";
        }
        
        if(eventDAO.countRegisteredCustomers(id) == 0) {
        	eventDAO.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Event deleted successfully"); 
        }
        else {
        	redirectAttributes.addFlashAttribute("error", "Cannot delete events that have been registered");
        }
                      
        return "redirect:/organizer/events";
    }
    
    @GetMapping("/events/{id}/participants")
    public String viewParticipants(HttpSession session, @PathVariable Long id, 
                                   Model model, RedirectAttributes redirectAttributes) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Event> eventOpt = eventDAO.findById(id);
        Event event = eventOpt.get();
        
        //check if event belongs to organizer
        if (!event.getOrganizer().getId().equals(organizerId)) {
            redirectAttributes.addFlashAttribute("error", "You can only view participants of your own events");
            return "redirect:/organizer/events";
        }
        
        model.addAttribute("event", event);
        model.addAttribute("participants", event.getRegisteredCustomers());
        
        return "organizer/participants";
    }
    
    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Organizer> organizerOpt = organizerDAO.findById(organizerId);
        
        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentDateTime", now);
        
        model.addAttribute("organizer", organizerOpt.get());
        return "organizer/profile";
    }
    
    @GetMapping("/profile/edit")
    public String editProfileForm(HttpSession session, Model model) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
        
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Organizer> organizerOpt = organizerDAO.findById(organizerId);

        model.addAttribute("organizer", organizerOpt.get());
        return "organizer/editProfile";
    }
    
    @PostMapping("/profile/edit")
    public String updateProfile(HttpSession session, @ModelAttribute Organizer organizer,
                                BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isOrganizer(session)) {
            return "redirect:/";
        }
    	       
        Long organizerId = getCurrentOrganizerId(session);
        Optional<Organizer> existingOrganizerOpt = organizerDAO.findById(organizerId);        
        Organizer existingOrganizer = existingOrganizerOpt.get();
        
		if(organizer.getPassword() == "") {
		    organizer.setPassword(existingOrganizer.getPassword());
    	}
		
    	organizerValidator.validate(organizer, result);
        if (result.hasErrors()) {
            return "organizer/editProfile";
        }
        
        existingOrganizer.setFullName(organizer.getFullName());
        existingOrganizer.setEmail(organizer.getEmail());
        existingOrganizer.setPassword(organizer.getPassword());
                
        organizerDAO.save(existingOrganizer);
        redirectAttributes.addFlashAttribute("success", "Profile updated successfully");
        return "redirect:/organizer/profile";
    }
}