package com.mycompany.EventHub.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mycompany.EventHub.DAO.AdminDAO;
import com.mycompany.EventHub.DAO.CustomerDAO;
import com.mycompany.EventHub.DAO.OrganizerDAO;
import com.mycompany.EventHub.POJOs.Customer;
import com.mycompany.EventHub.POJOs.Organizer;
import com.mycompany.EventHub.Validators.CustomerValidator;
import com.mycompany.EventHub.Validators.OrganizerValidator;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
	
	@Autowired
    private AdminDAO adminDAO;
    
    @Autowired
    private OrganizerDAO organizerDAO;
    
    @Autowired
    private CustomerDAO customerDAO;
    
    @Autowired
    private OrganizerValidator organizerValidator;
    
    @Autowired
    private CustomerValidator customerValidator;

    @GetMapping("/")
    public String home() {
        return "login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, @RequestParam String userType,
                        HttpSession session, RedirectAttributes redirectAttributes) {
        
        boolean authenticated = false;
        String redirectUrl = "redirect:/";
        
        //based on the selected user type
        switch(userType) {
            case "admin":
                authenticated = authenticateAdmin(username, password, session);
                if (authenticated) redirectUrl = "redirect:/admin/dashboard";
                break;
                
            case "organizer":
                authenticated = authenticateOrganizer(username, password, session);
                if (authenticated) redirectUrl = "redirect:/organizer/dashboard";
                break;
                
            case "customer":
                authenticated = authenticateCustomer(username, password, session);
                if (authenticated) redirectUrl = "redirect:/customer/dashboard";
                break;
        }
        
        if (!authenticated) {
            redirectAttributes.addFlashAttribute("error", "Invalid username or password");
            return "redirect:/";
        }
        
        return redirectUrl;
    }

    private boolean authenticateAdmin(String username, String password, HttpSession session) {
        adminDAO.findByUsername(username).ifPresent(admin -> {
            if (admin.getPassword().equals(password)) {
                session.setAttribute("currentUser", admin);
                session.setAttribute("userType", "admin");
                session.setAttribute("userId", admin.getId());
            }
        });
        
        return session.getAttribute("currentUser") != null;
    }

    private boolean authenticateOrganizer(String username, String password, HttpSession session) {
        organizerDAO.findByUsername(username).ifPresent(organizer -> {
            if (organizer.getPassword().equals(password)) {
                session.setAttribute("currentUser", organizer);
                session.setAttribute("userType", "organizer");
                session.setAttribute("userId", organizer.getId());
            }
        });
        
        return session.getAttribute("currentUser") != null;
    }

    private boolean authenticateCustomer(String username, String password, HttpSession session) {
        customerDAO.findByUsername(username).ifPresent(customer -> {
            if (customer.getPassword().equals(password)) {
                session.setAttribute("currentUser", customer);
                session.setAttribute("userType", "customer");
                session.setAttribute("userId", customer.getId());
            }
        });
        
        return session.getAttribute("currentUser") != null;
    } 
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // clear all session attributes
        session.invalidate();
        return "redirect:/";
    }
    
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }
    
    @PostMapping("/register")
    public String register(@RequestParam String userType, @RequestParam String username, @RequestParam String email,
                          @RequestParam String fullName, @RequestParam String password, 
                          RedirectAttributes redirectAttributes) {
        
        //check if username existed
        if (userType.equals("customer")) {
            if (customerDAO.existsByUsername(username)) {
                redirectAttributes.addFlashAttribute("error", "Username already exists. Please choose another one.");
                return "redirect:/register";
            }
        } else if (userType.equals("organizer")) {
            if (organizerDAO.existsByUsername(username)) {
                redirectAttributes.addFlashAttribute("error", "Username already exists. Please choose another one.");
                return "redirect:/register";
            }
        }
        
        //check validations
        if (userType.equals("customer")) {
            Customer customer = new Customer();
            customer.setUsername(username);
            customer.setPassword(password);
            customer.setEmail(email);
            customer.setFullName(fullName);
            
            BeanPropertyBindingResult errors = new BeanPropertyBindingResult(customer, "customer");              
            customerValidator.validate(customer, errors);          
            if (errors.hasErrors()) {
                redirectAttributes.addFlashAttribute("error", errors.getAllErrors());
                redirectAttributes.addFlashAttribute("customer", customer);
                return "redirect:/register";
            }
            
            customerDAO.save(customer);               
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login with your new account.");
        } 
        else if (userType.equals("organizer")) {
            Organizer organizer = new Organizer();
            organizer.setUsername(username);
            organizer.setPassword(password);
            organizer.setEmail(email);
            organizer.setFullName(fullName);
            
            BeanPropertyBindingResult errors = new BeanPropertyBindingResult(organizer, "organizer");              
            organizerValidator.validate(organizer, errors);           
            if (errors.hasErrors()) {
                redirectAttributes.addFlashAttribute("error", errors.getAllErrors());
                redirectAttributes.addFlashAttribute("organizer", organizer);
                return "redirect:/register";
            }
            
            organizerDAO.save(organizer);               
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login with your new account.");
        }       
        return "redirect:/";
    }
}