package com.mycompany.EventHub.Controllers;

import com.mycompany.EventHub.DAO.CustomerDAO;
import com.mycompany.EventHub.DAO.EventDAO;
import com.mycompany.EventHub.POJOs.Customer;
import com.mycompany.EventHub.POJOs.Event;
import com.mycompany.EventHub.Validators.CustomerValidator;

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
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerDAO customerDAO;
    
    @Autowired
    private EventDAO eventDAO;
    
    @Autowired
    private CustomerValidator customerValidator;
    
    private boolean isCustomer(HttpSession session) {
        return session.getAttribute("userType") != null && 
               session.getAttribute("userType").equals("customer");
    }
    
    //hide the ID in session instead of URL
    private Long getCurrentCustomerId(HttpSession session) {
        return (Long) session.getAttribute("userId");
    }
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Customer> customerOpt = customerDAO.findById(customerId);
        
        if (!customerOpt.isPresent()) {
            return "redirect:/logout";
        }
        
        Customer customer = customerOpt.get();      
        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentDateTime", now);
        
        // upcoming registered events
        List<Event> upcomingEvents = customer.getRegisteredEvents().stream()
                .filter(event -> event.getEventDate().isAfter(now) || event.getEventDate().equals(now))
                .sorted((e1, e2) -> e1.getEventDate().compareTo(e2.getEventDate()))
                .limit(3)
                .toList();
        
        // past registered events
        List<Event> pastEvents = customer.getRegisteredEvents().stream()
                .filter(event -> event.getEventDate().isBefore(now))
                .sorted((e1, e2) -> e2.getEventDate().compareTo(e1.getEventDate()))
                .limit(3)
                .toList();
        
        model.addAttribute("upcomingEvents", upcomingEvents);
        model.addAttribute("pastEvents", pastEvents);
        model.addAttribute("totalRegistrations", customer.getRegisteredEvents().size());
        
        return "customer/dashboard";
    }
    
    @GetMapping("/events")
    public String browseEvents(HttpSession session, Model model, @RequestParam(required = false) String keyword, 
    							@RequestParam(required = false) String category, @RequestParam(defaultValue = "0") int page) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        List<Event> events;
        
        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentDateTime", now);
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            events = eventDAO.searchByKeyword(keyword);
            model.addAttribute("keyword", keyword);
        } else if (category != null && !category.trim().isEmpty()) {
            events = eventDAO.findByCategory(category);
            model.addAttribute("category", category);
        } else {
        	events = eventDAO.findAll().stream()
                    .filter(event -> event.getEventDate().isAfter(now))
                    .toList();
        }
        
        //limit page size
        int pageSize = 6;
        int totalPages = (int) Math.ceil((double) events.size() / pageSize);
        List<Event> pagedEvents = events.stream()
        		.skip(page * pageSize)
        		.limit(pageSize)
        		.toList();
        
        model.addAttribute("events", pagedEvents);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalEvents", events.size());       
        return "customer/events";
    }
    
    @GetMapping("/events/{id}")
    public String eventDetails(HttpSession session, @PathVariable Long id, Model model) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Event> eventOpt = eventDAO.findById(id);
        Event event = eventOpt.get();
        
        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentDateTime", now);
        
        model.addAttribute("event", event);
        model.addAttribute("isRegistered", customerDAO.isCustomerRegisteredForEvent(customerId, id));
        model.addAttribute("isFull", event.isFull());
        model.addAttribute("isExpired", event.getEventDate().isBefore(now));
        model.addAttribute("remainingCapacity", event.getRemainingCapacity());
        
        return "customer/eventDetails";
    }
    
    @PostMapping("/events/{id}/register")
    public String registerEvent(HttpSession session, @PathVariable Long id, RedirectAttributes redirectAttributes) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Event> eventOpt = eventDAO.findById(id);
        Event event = eventOpt.get();
        
        //check availability
        if (event.getEventDate().isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Cannot register for past events");
            return "redirect:/customer/events/" + id;
        }
        if (event.isFull()) {
            redirectAttributes.addFlashAttribute("error", "Event is full");
            return "redirect:/customer/events/" + id;
        }
        if (customerDAO.isCustomerRegisteredForEvent(customerId, id)) {
            redirectAttributes.addFlashAttribute("error", "You are already registered for this event");
            return "redirect:/customer/events/" + id;
        }
        
        customerDAO.registerForEvent(customerId, id);      
        redirectAttributes.addFlashAttribute("success", "Successfully registered for the event");
        return "redirect:/customer/events/" + id;
    }
    
    @PostMapping("/events/{id}/unregister")
    public String unregisterEvent(HttpSession session, @PathVariable Long id, RedirectAttributes redirectAttributes) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Event> eventOpt = eventDAO.findById(id);
        Event event = eventOpt.get();
        
        //check availability
        if (!customerDAO.isCustomerRegisteredForEvent(customerId, id)) {
            redirectAttributes.addFlashAttribute("error", "You are not registered for this event");
            return "redirect:/customer/events/" + id;
        }
        if (event.getEventDate().isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Cannot unregister for past events");
            return "redirect:/customer/events/" + id;
        }
                
        customerDAO.unregisterFromEvent(customerId, id);       
        redirectAttributes.addFlashAttribute("success", "Successfully unregistered from the event");
        return "redirect:/customer/events/" + id;
    }
    
    @GetMapping("/registrations")
    public String myRegistrations(HttpSession session, Model model) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Customer> customerOpt = customerDAO.findById(customerId);       
        Customer customer = customerOpt.get();
        
        LocalDateTime now = LocalDateTime.now();
        model.addAttribute("currentDateTime", now);
        
        List<Event> registeredEvents = customer.getRegisteredEvents().stream().toList();
        model.addAttribute("registeredEvents", registeredEvents);       
        return "customer/registrations";
    }
    
    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Customer> customerOpt = customerDAO.findById(customerId);
        
        model.addAttribute("customer", customerOpt.get());
        return "customer/profile";
    }
    
    @GetMapping("/profile/edit")
    public String editProfileForm(HttpSession session, Model model) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Customer> customerOpt = customerDAO.findById(customerId);
        
        if (!customerOpt.isPresent()) {
            return "redirect:/logout";
        }
        
        model.addAttribute("customer", customerOpt.get());
        return "customer/editProfile";
    }
    
    @PostMapping("/profile/edit")
    public String updateProfile(HttpSession session, @ModelAttribute Customer customer,
                               BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isCustomer(session)) {
            return "redirect:/";
        }
        
        Long customerId = getCurrentCustomerId(session);
        Optional<Customer> existingCustomerOpt = customerDAO.findById(customerId);
        Customer existingCustomer = existingCustomerOpt.get();
        
        //fill in old password to validate
        if(customer.getPassword() == "") {
		    customer.setPassword(existingCustomer.getPassword());
    	}
		
    	customerValidator.validate(customer, result);
        if (result.hasErrors()) {
        	return "admin/editCustomer"; 
        }
              
        existingCustomer.setFullName(customer.getFullName());
        existingCustomer.setEmail(customer.getEmail());
        existingCustomer.setPassword(customer.getPassword());
               
        customerDAO.save(existingCustomer);
        redirectAttributes.addFlashAttribute("success", "Profile updated successfully");
        return "redirect:/customer/profile";
    }
}