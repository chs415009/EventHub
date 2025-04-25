package com.mycompany.EventHub.Validators;

import com.mycompany.EventHub.POJOs.Customer;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

@Component
public class CustomerValidator implements Validator {

    @Override
    public boolean supports(Class<?> type) {
        return Customer.class.isAssignableFrom(type);
    }

    @Override
    public void validate(Object command, Errors errors) {
        Customer customer = (Customer) command;
        
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "username", "empty-username", "Username cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "password", "empty-password", "Password cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "empty-email", "Email cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "fullName", "empty-fullName", "Full name cannot be empty");
        
        // Email format validation
        if (customer.getEmail() != null && !customer.getEmail().matches("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")) {
            errors.rejectValue("email", "invalid-email", "Please enter a valid email address");
        }
        
        // Password length validation
        if (customer.getPassword() != null && customer.getPassword().length() < 6) {
            errors.rejectValue("password", "short-password", "Password must be at least 6 characters long");
        }
    }
}