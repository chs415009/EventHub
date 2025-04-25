package com.mycompany.EventHub.Validators;

import com.mycompany.EventHub.POJOs.Event;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.time.LocalDateTime;

@Component
public class EventValidator implements Validator {

    @Override
    public boolean supports(Class<?> type) {
        return Event.class.isAssignableFrom(type);
    }

    @Override
    public void validate(Object command, Errors errors) {
        Event event = (Event) command;
        
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "title", "empty-title", "Event title cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "description", "empty-description", "Event description cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "location", "empty-location", "Event location cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "eventDate", "empty-eventDate", "Event date cannot be empty");
        ValidationUtils.rejectIfEmptyOrWhitespace(errors, "category", "empty-category", "Event category cannot be empty");
        
        // Check if organizer is set
        if (event.getOrganizer() == null) {
            errors.rejectValue("organizer", "no-organizer", "An organizer must be specified for this event");
        }
        
        // Date validation - event date must be in the future
        if (event.getEventDate() != null && event.getEventDate().isBefore(LocalDateTime.now())) {
            errors.rejectValue("eventDate", "past-date", "Event date must be in the future");
        }
        
        // Capacity validation
        if (event.getMaxCapacity() != null && event.getMaxCapacity() <= 0) {
            errors.rejectValue("maxCapacity", "invalid-capacity", "Maximum capacity must be greater than zero");
        }
        
        // Description length validation
        if (event.getDescription() != null && event.getDescription().length() > 2000) {
            errors.rejectValue("description", "long-description", "Description cannot exceed 2000 characters");
        }
    }
}