package com.mycompany.EventHub.Controllers;

import com.mycompany.EventHub.DAO.CustomerDAO;
import com.mycompany.EventHub.DAO.EventDAO;
import com.mycompany.EventHub.DAO.OrganizerDAO;
import com.mycompany.EventHub.POJOs.Customer;
import com.mycompany.EventHub.POJOs.Event;
import com.mycompany.EventHub.POJOs.Organizer;
import com.mycompany.EventHub.Validators.CustomerValidator;
import com.mycompany.EventHub.Validators.EventValidator;
import com.mycompany.EventHub.Validators.OrganizerValidator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private CustomerDAO customerDAO;
    
    @Autowired
    private OrganizerDAO organizerDAO;
    
    @Autowired
    private EventDAO eventDAO;
    
    @Autowired
    private CustomerValidator customerValidator;
    
    @Autowired
    private OrganizerValidator organizerValidator;
    
    @Autowired
    private EventValidator eventValidator;
    
    
    // check if it is admin
    private boolean isAdmin(HttpSession session) {
        return session.getAttribute("userType") != null && 
               session.getAttribute("userType").equals("admin");
    }
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        return "admin/dashboard";
    }
    
    @GetMapping("/customers")
    public String listCustomers(HttpSession session, Model model, @RequestParam(required = false) String keyword) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        List<Customer> customers;
        if (keyword != null && !keyword.trim().isEmpty()) {
            customers = customerDAO.searchByKeyword(keyword);
            model.addAttribute("keyword", keyword); //keep the keyword shown in front end page
        } 
        else {
            customers = customerDAO.findAll();
        }
        
        model.addAttribute("customers", customers);
        return "admin/customers";
    }
    
    @GetMapping("/customers/edit/{id}")
    public String editCustomerForm(HttpSession session, @PathVariable Long id, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        Optional<Customer> customerOpt = customerDAO.findById(id);
        
        model.addAttribute("customer", customerOpt.get());
        return "admin/editCustomer";
    }
    
    @PostMapping("/customers/edit/{id}")
    public String updateCustomer(HttpSession session, @PathVariable Long id, @ModelAttribute Customer customer, 
    							BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        Optional<Customer> existingCustomerOpt = customerDAO.findById(id);       
        Customer existingCustomer = existingCustomerOpt.get();
        
        //fill in old password to validate
        if(customer.getPassword() == "") {
		    customer.setPassword(existingCustomer.getPassword());
    	}
		
    	customerValidator.validate(customer, result);
        if (result.hasErrors()) {
        	return "admin/editCustomer"; 
        }
        
        existingCustomer.setUsername(customer.getUsername());
        existingCustomer.setFullName(customer.getFullName());
        existingCustomer.setEmail(customer.getEmail());        
        existingCustomer.setPassword(customer.getPassword());
        
        customerDAO.save(existingCustomer);
        redirectAttributes.addFlashAttribute("success", "Customer updated successfully");
        return "redirect:/admin/customers";
    }
    
    @GetMapping("/customers/delete/{id}")
    public String deleteCustomer(HttpSession session, @PathVariable Long id, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        customerDAO.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "Customer deleted successfully");
        
        return "redirect:/admin/customers";
    }
    
    @GetMapping("/organizers")
    public String listOrganizers(HttpSession session, Model model, @RequestParam(required = false) String keyword) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        List<Organizer> organizers;
        if (keyword != null && !keyword.trim().isEmpty()) {
            organizers = organizerDAO.searchByKeyword(keyword);
            model.addAttribute("keyword", keyword);
        } else {
            organizers = organizerDAO.findAll();
        }
        
        model.addAttribute("organizers", organizers);
        return "admin/organizers";
    }
    
    @GetMapping("/organizers/edit/{id}")
    public String editOrganizerForm(HttpSession session, @PathVariable Long id, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        Optional<Organizer> organizerOpt = organizerDAO.findById(id);
        
        model.addAttribute("organizer", organizerOpt.get());
        return "admin/editOrganizer";
    }
    
    @PostMapping("/organizers/edit/{id}")
    public String updateOrganizer(HttpSession session, @PathVariable Long id, @ModelAttribute Organizer organizer,
                                 BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        Optional<Organizer> existingOrganizerOpt = organizerDAO.findById(id);
        Organizer existingOrganizer = existingOrganizerOpt.get();
        
        //fill in old password to validate
        if(organizer.getPassword() == "") {
		    organizer.setPassword(existingOrganizer.getPassword());
    	}
		
    	organizerValidator.validate(organizer, result);
        if (result.hasErrors()) {
        	return "admin/editOrganizer"; 
        }
        
        existingOrganizer.setUsername(organizer.getUsername());
        existingOrganizer.setFullName(organizer.getFullName());
        existingOrganizer.setEmail(organizer.getEmail());
        existingOrganizer.setPassword(organizer.getPassword());
        
        organizerDAO.save(existingOrganizer);
        redirectAttributes.addFlashAttribute("success", "Organizer updated successfully");
        return "redirect:/admin/organizers";
    }
    
    @GetMapping("/organizers/delete/{id}")
    public String deleteOrganizer(HttpSession session, @PathVariable Long id, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        System.out.println("here");
        
        if(!organizerDAO.hasEvents(id)) {
        	System.out.println("1111");
        	organizerDAO.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Organizer deleted successfully");
        }
        else {
        	System.out.println("2222");
        	redirectAttributes.addFlashAttribute("error", "Cannot delete organizers who own an event.");
        }
        
               
        return "redirect:/admin/organizers";
    }
    
    @GetMapping("/events")
    public String listEvents(HttpSession session, Model model, 
    						@RequestParam(required = false) String keyword, @RequestParam(required = false) String category) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        List<Event> events;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            events = eventDAO.searchByKeyword(keyword);
            model.addAttribute("keyword", keyword);
        } else if (category != null && !category.trim().isEmpty()) {
            events = eventDAO.findByCategory(category);
            model.addAttribute("category", category);
        } else {
        	events = eventDAO.findAll();
        }
                
        model.addAttribute("events", events);
        return "admin/events";
    }
    
    @GetMapping("/events/edit/{id}")
    public String editEventForm(HttpSession session, @PathVariable Long id, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        Optional<Event> eventOpt = eventDAO.findById(id);
        
        model.addAttribute("event", eventOpt.get());
        model.addAttribute("organizers", organizerDAO.findAll());
        return "admin/editEvent";
    }
    
    @PostMapping("/events/edit/{id}")
    public String updateEvent(HttpSession session, @PathVariable Long id, @ModelAttribute Event event,
                             BindingResult result, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        eventValidator.validate(event, result);
        if(result.hasErrors()) {
        	return "admin/editEvent";
        }
        
        Optional<Event> existingEventOpt = eventDAO.findById(id);       
        Event existingEvent = existingEventOpt.get();
               
        existingEvent.setTitle(event.getTitle());
        existingEvent.setDescription(event.getDescription());
        existingEvent.setLocation(event.getLocation());
        existingEvent.setEventDate(event.getEventDate());
        existingEvent.setMaxCapacity(event.getMaxCapacity());
        existingEvent.setCategory(event.getCategory());
        existingEvent.setImageUrl(event.getImageUrl());
        
        eventDAO.save(existingEvent);
        redirectAttributes.addFlashAttribute("success", "Event updated successfully");
        return "redirect:/admin/events";
    }
    
    @GetMapping("/events/delete/{id}")
    public String deleteEvent(HttpSession session, @PathVariable Long id, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/";
        }
        
        if(eventDAO.countRegisteredCustomers(id) == 0) {
        	eventDAO.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Event deleted successfully");
        }
        else {
        	redirectAttributes.addFlashAttribute("error", "Cannot delete events that have registrations");
        }
               
        return "redirect:/admin/events";
    }
}