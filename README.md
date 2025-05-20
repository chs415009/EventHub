# EventHub - Containerized Event Management System

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Deployment Architecture](#deployment-architecture)
- [Screenshots](#screenshots)
- [Project Structure](#project-structure)
- [ORM Implementation](#orm-implementation)
- [Getting Started](#getting-started)
- [Implementation Highlights](#implementation-highlights)
- [DevOps Practices](#devops-practices)
- [Future Enhancements](#future-enhancements)

## Project Overview

EventHub is a comprehensive event management platform developed as a course project and enhanced with industry-standard containerization practices. This system allows organizations to create events, users to register for these events, and administrators to maintain the overall platform. Built on the Spring Boot framework with Hibernate ORM, EventHub demonstrates the implementation of a robust, containerized web application using modern Java technologies and DevOps principles.

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
- **Data Persistence**: Hibernate ORM with MySQL database
- **Pagination**: Efficient display of event lists with page navigation
- **Containerization**: Full Docker support for consistent deployment across environments

## Technology Stack

- **Backend**: Java 21 with Spring Boot framework
- **Frontend**: JSP, HTML, CSS, JavaScript
- **Database**: MySQL 8.0.36
- **ORM**: Hibernate
- **Build Tool**: Maven
- **Containerization**: Docker & Docker Compose
- **Design Pattern**: DAO pattern for data access
- **Time Management**: Configured timezone handling for global deployment

## Deployment Architecture

EventHub utilizes a modern containerized architecture, allowing for seamless deployment across different environments.

```
┌─────────────────────────────────────┐
│          Docker Environment         │
│                                     │
│  ┌─────────────┐     ┌───────────┐  │
│  │             │     │           │  │
│  │  Spring Boot│     │  MySQL    │  │
│  │  Application│─────│  Database │  │
│  │  Container  │     │  Container│  │
│  │             │     │           │  │
│  └─────────────┘     └───────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### Docker Configuration

The project includes a complete Docker setup for streamlined deployment:

#### Dockerfile
```dockerfile
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/EventHub-0.0.1-SNAPSHOT.war app.war

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.war"]
```

#### Docker Compose
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/eventhub?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
      - SPRING_DATASOURCE_USERNAME=root
      - SPRING_DATASOURCE_PASSWORD=Aa@8573547512
      - SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
      - SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.MySQL8Dialect
    depends_on:
      - db
    networks:
      - eventhub-network

  db:
    image: mysql:8.0.36
    environment:
      - MYSQL_ROOT_PASSWORD=Aa@8573547512
      - MYSQL_DATABASE=eventhub
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - eventhub-network

networks:
  eventhub-network:
    driver: bridge

volumes:
  mysql-data:
```

## Screenshots

### User Experience Journey

<div align="center">

#### 🔐 Authentication
<table>
  <tr>
    <td width="50%"><img src="images/login.png" alt="Login Interface" style="border-radius: 10px"/></td>
    <td width="50%"><img src="images/register.png" alt="Registration Form" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td><em>Streamlined login with role selection</em></td>
    <td><em>Intuitive registration process</em></td>
  </tr>
</table>

#### 👑 Administrator Experience
<table>
  <tr>
    <td colspan="2"><img src="images/admin_dashboard.png" alt="Admin Dashboard" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td colspan="2"><em>Comprehensive administrative dashboard for platform oversight</em></td>
  </tr>
  <tr>
    <td><img src="images/admin_customers.png" alt="Customer Management" style="border-radius: 10px"/></td>
    <td><img src="images/admin_organizers.png" alt="Organizer Management" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td><em>Customer management and monitoring</em></td>
    <td><em>Organizer approval and management</em></td>
  </tr>
  <tr>
    <td colspan="2"><img src="images/admin_events.png" alt="Event Administration" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td colspan="2"><em>Platform-wide event moderation capabilities</em></td>
  </tr>
</table>

#### 🎭 Organizer Portal
<table>
  <tr>
    <td width="50%"><img src="images/organizer_dashboard.png" alt="Organizer Dashboard" style="border-radius: 10px"/></td>
    <td width="50%"><img src="images/organizer_events.png" alt="Event Management" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td><em>Analytics-driven dashboard for event creators</em></td>
    <td><em>Comprehensive event management tools</em></td>
  </tr>
  <tr>
    <td><img src="images/organizer_create.png" alt="Event Creation" style="border-radius: 10px"/></td>
    <td><img src="images/event_participant.png" alt="Participant Management" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td><em>Intuitive event creation interface</em></td>
    <td><em>Attendee tracking and management</em></td>
  </tr>
  <tr>
    <td colspan="2"><img src="images/organizer_profile.png" alt="Organizer Profile" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td colspan="2"><em>Organizer profile customization</em></td>
  </tr>
</table>

#### 🧑‍💼 Customer Experience
<table>
  <tr>
    <td colspan="2"><img src="images/customer_dashboard.png" alt="Customer Dashboard" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td colspan="2"><em>Personalized customer dashboard highlighting upcoming events</em></td>
  </tr>
  <tr>
    <td><img src="images/customer_browse.png" alt="Event Discovery" style="border-radius: 10px"/></td>
    <td><img src="images/customer_registrations.png" alt="Registration Management" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td><em>Event discovery with filtering and search</em></td>
    <td><em>Registration tracking and management</em></td>
  </tr>
  <tr>
    <td><img src="images/customer_register.png" alt="Event Registration" style="border-radius: 10px"/></td>
    <td><img src="images/customer_unregister.png" alt="Registration Cancellation" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td><em>Seamless event registration process</em></td>
    <td><em>Hassle-free registration cancellation</em></td>
  </tr>
  <tr>
    <td colspan="2"><img src="images/customer_profile.png" alt="Customer Profile" style="border-radius: 10px"/></td>
  </tr>
  <tr>
    <td colspan="2"><em>User profile management and preferences</em></td>
  </tr>
</table>

</div>


## Project Structure

The application follows a standard layered architecture:

![Project Structure](images/program_structure.png)

The project is organized as follows:

1. **Controllers Layer**: Handles HTTP requests and manages user interaction flow
   - AdminController: Manages administrative tasks
   - HomeController: Handles authentication and common pages
   - OrganizerController: Manages event creation and organizer functions
   - CustomerController: Manages event browsing and registration

2. **DAO Layer**: Implements Data Access Object pattern
   - Abstract DAO base class with common methods
   - Specialized DAOs for each entity (AdminDAO, EventDAO, etc.)
   - Uses Hibernate/JPA for database operations

3. **POJOs Layer**: Plain Old Java Objects representing domain entities
   - User (abstract base class)
   - Admin, Organizer, Customer (extend User)
   - Event with relationships to other entities

4. **Validators**: Form validation for data integrity
   - Validates user input before processing

5. **Configuration**: System setup and initialization
   - DataInitializer for sample data generation
   - Environment-specific property configurations

This structure provides clear separation of concerns, making the codebase maintainable and extensible.

## ORM Implementation

EventHub utilizes Hibernate ORM for database operations, providing an abstraction layer between the application and the database. This implementation supports database portability as demonstrated by the migration from SQL Server to MySQL.

### Configuration

The application connects to MySQL through Hibernate, configured in `application.properties`:

```properties
# DataSource Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/eventhub?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=******
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# Hibernate Configuration
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

## Getting Started

### Prerequisites

- Docker and Docker Compose
- JDK 21 or higher (for development only)
- Maven (for development only)

### Setup Instructions

#### With Docker (Recommended)

1. Clone the repository
2. Build the application with Maven:
   ```
   mvn clean package
   ```
3. Launch the containerized application:
   ```
   docker-compose up -d
   ```
4. Access the application at `http://localhost:8080/eventhub`

#### For Development

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
    Optional<Event> findById(Long id);
    List<Event> findAll();
    List<Event> findByCategory(String category);
    List<Event> searchByKeyword(String keyword);
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
private Set<Event> registeredEvents = new HashSet<>();
```

## DevOps Practices

This project demonstrates several DevOps principles and best practices:

### Containerization

- **Platform Independence**: Application runs consistently across any environment with Docker support
- **Isolation**: System dependencies are encapsulated within containers
- **Resource Management**: Container-specific resource allocation and management
- **Easy Deployment**: Single command deployment with docker-compose

### Database Migration

- **Database Portability**: Successfully migrated from Microsoft SQL Server to MySQL
- **Dialect Configuration**: Automated adjustment of SQL dialect through Hibernate
- **Schema Management**: Auto-generating database schema regardless of database provider

### Environment Configuration

- **Externalized Configuration**: Environment variables for sensitive information
- **Service Discovery**: Container networking with automatic service discovery
- **Timezone Management**: Proper handling of timezone configuration
- **Volume Persistence**: Database data persists through container restarts

## Future Enhancements

Several areas for future development have been identified:

### Security Enhancements
* Implementation of Spring Security for more robust authentication
* Password encryption with bcrypt or similar algorithms
* Role-based access control with more granular permissions
* HTTPS configuration with SSL certificates

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
* CI/CD pipeline integration (GitHub Actions, Jenkins)
* Infrastructure as Code using Terraform or similar tools
* Kubernetes orchestration for enhanced scalability

### User Experience
* Advanced search filters (location, date range, price)
* Interactive event calendar view
* User dashboards with analytics
* Customizable event pages for organizers

These enhancements would transform EventHub from a course project into a production-ready system capable of serving real-world event management needs.