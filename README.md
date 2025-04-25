# EventHub - Event Management System

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
  - [User Roles](#user-roles)
  - [Key Functionalities](#key-functionalities)
- [Technology Stack](#technology-stack)
- [Screenshots](#screenshots)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Hibernate Integration](#hibernate-integration)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup Instructions](#setup-instructions)
  - [Default Users](#default-users)
- [Implementation Highlights](#implementation-highlights)
  - [DAO Pattern Implementation](#dao-pattern-implementation)
  - [Session-Based Authentication](#session-based-authentication)
  - [JPA Entity Relationships](#jpa-entity-relationships)
- [Future Enhancements](#future-enhancements)
- [Acknowledgments](#acknowledgments)

## Project Overview

EventHub is a comprehensive event management platform developed as a course project. This system allows organizations to create events, users to register for these events, and administrators to maintain the overall platform. Built on the Spring Boot framework with Hibernate ORM, EventHub demonstrates the implementation of a robust web application using Java technologies.

## Features

### User Roles

EventHub implements a multi-role authorization system with three types of users:

1. **Administrators**
   - Complete system management
   - Monitor all events, organizers, and customers
   - Edit or remove content as needed

2. **Organizers**
   - Create and manage events
   - View registered participants
   - Update event details

3. **Customers**
   - Browse available events
   - Register for events
   - Manage event registrations
   - Update personal profile information

### Key Functionalities

- **User Authentication**: Secure login and registration system
- **Event Management**: Creation, editing, and deletion of events
- **Registration System**: Customers can register for events with capacity limits
- **Search & Filter**: Find events by keyword or category
- **Responsive UI**: Bootstrap-based interface that works across devices
- **Data Persistence**: Hibernate ORM with SQL Server database
- **Pagination**: Efficient display of event lists with page navigation

## Technology Stack

- **Backend**: Java with Spring Boot framework
- **Frontend**: JSP, HTML, CSS, JavaScript
- **Database**: Microsoft SQL Server
- **ORM**: Hibernate
- **Build Tool**: Maven
- **Design Pattern**: DAO pattern for data access

## Screenshots

### User Authentication
![Login Page](screenshots/login_page.png)
*Figure 1: Login page with role selection*

![Registration Page](screenshots/registration_page.png)
*Figure 2: User registration form*

### Administrator Dashboard
![Admin Dashboard](screenshots/admin_dashboard.png)
*Figure 3: Administrator dashboard overview*

![Admin Event Management](screenshots/admin_events.png)
*Figure 4: Admin event management interface*

### Organizer Features
![Organizer Dashboard](screenshots/organizer_dashboard.png)
*Figure 5: Organizer dashboard showing upcoming events*

![Event Creation](screenshots/create_event.png)
*Figure 6: Event creation form*

### Customer Interface
![Event Browsing](screenshots/customer_events.png)
*Figure 7: Event browsing page with pagination*

![Event Details](screenshots/event_details.png)
*Figure 8: Detailed event view with registration option*

## Project Structure

The application follows a standard layered architecture:



## Database Schema

The system uses the following main entities:
- User (abstract class extended by Customer and Organizer)
- Admin
- Event
- Relationships between entities (e.g., User-Event registrations)

![Database Schema](screenshots/db_schema.png)
*Figure 9: Entity-Relationship diagram of the database schema*

## Hibernate Integration

EventHub utilizes Hibernate ORM for database operations, providing an abstraction layer between the application and the database. This integration offers several advantages:

### Configuration

The application connects to Microsoft SQL Server through Hibernate, configured in `application.properties`:

```properties
# DataSource Configuration
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=EventHub;encrypt=true;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=******
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

# Hibernate Configuration
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.SQLServerDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

## Getting Started

### Prerequisites

- JDK 17 or higher
- Maven
- Microsoft SQL Server

### Setup Instructions

1. Clone the repository
2. Configure database connection in `application.properties`
3. Run the application using Spring Boot:
   ```
   mvn spring-boot:run
   ```
4. Access the application at `http://localhost:8080/eventhub`

### Default Users

The system is pre-populated with the following test accounts:

| Role      | Username | Password |
|-----------|----------|----------|
| Admin     | aaa      | aaa      |
| Organizer | o1       | ooo111   |
| Organizer | o2       | ooo222   |
| Organizer | o3       | ooo333   |
| Customer  | c1       | ccc111   |
| Customer  | c2       | ccc222   |
| Customer  | c3       | ccc333   |

## Implementation Highlights

### DAO Pattern Implementation

The project uses the Data Access Object pattern to separate business logic from data access.
This approach offers better maintainability and testability.

```java
// Example of DAO interface
public interface EventDAO {
    Event save(Event event);
    Optional findById(Long id);
    List findAll();
    List findByCategory(String category);
    List searchByKeyword(String keyword);
    // Other methods...
}
```

### Session-Based Authentication

User authentication is handled through session management:

```java
// Authentication method example
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
```

### JPA Entity Relationships

The system demonstrates various JPA relationship mappings:

```java
// Example of a many-to-many relationship
@ManyToMany
@JoinTable(
    name = "customer_event_registrations",
    joinColumns = @JoinColumn(name = "customer_id"),
    inverseJoinColumns = @JoinColumn(name = "event_id")
)
private Set registeredEvents = new HashSet<>();
```


## Future Enhancements

Several areas for future development have been identified:

### Security Enhancements
* Implementation of Spring Security for more robust authentication
* Password encryption with bcrypt or similar algorithms
* Role-based access control with more granular permissions

### Feature Expansions
* Email notifications for event reminders and updates
* Payment processing integration for paid events
* Social media sharing capabilities
* QR code generation for event tickets
* Rating and review system for past events

### Technical Improvements
* RESTful API for mobile application integration
* Implementation of caching for frequently accessed data
* Comprehensive unit and integration test suite
* Deployment to cloud platforms (AWS, Azure, etc.)
* Performance optimization for higher scalability

### User Experience
* Advanced search filters (location, date range, price)
* Interactive event calendar view
* User dashboards with analytics
* Customizable event pages for organizers

These enhancements would transform EventHub from a course project into a production-ready system capable of serving real-world event management needs.

## Acknowledgments

This project was developed as part of the [Course Name] at [University/Institution Name]. Special thanks to [Professor/Instructor Name] for guidance during the development process.
