<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Dashboard - EventHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/organizer/dashboard">EventHub</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/organizer/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/events">My Events</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/profile">My Profile</a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">Welcome, ${currentUser.fullName}!</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-3">
                                    <div class="card-body text-center">
                                        <h5>Total Events</h5>
                                        <h2>${totalEvents}</h2>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-3">
                                    <div class="card-body text-center">
                                        <h5>Total Participants</h5>
                                        <h2>${totalParticipants}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-success">
                                <i class="fas fa-plus"></i> Create New Event
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Upcoming Events</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty upcomingEvents}">
                            <p class="text-muted">No upcoming events. <a href="${pageContext.request.contextPath}/organizer/events/create">Create one now</a>.</p>
                        </c:if>
                        <c:if test="${not empty upcomingEvents}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Date</th>
                                            <th>Location</th>
                                            <th>Capacity</th>
                                            <th>Registrations</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="event" items="${upcomingEvents}">
                                            <tr>
                                                <td>${event.title}</td>
                                                <td>
                                                    <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                                </td>
                                                <td>${event.location}</td>
                                                <td>${event.maxCapacity}</td>
                                                <td>${event.registeredCustomers.size()}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/organizer/events/edit/${event.id}" class="btn btn-sm btn-primary">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/participants" class="btn btn-sm btn-info">
                                                        <i class="fas fa-users"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-outline-success">View All Events</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Past Events</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty pastEvents}">
                            <p class="text-muted">No past events.</p>
                        </c:if>
                        <c:if test="${not empty pastEvents}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Date</th>
                                            <th>Location</th>
                                            <th>Capacity</th>
                                            <th>Registrations</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="event" items="${pastEvents}">
                                            <tr>
                                                <td>${event.title}</td>
                                                <td>
                                                    <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                                </td>
                                                <td>${event.location}</td>
                                                <td>${event.maxCapacity}</td>
                                                <td>${event.registeredCustomers.size()}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/participants" class="btn btn-sm btn-info">
                                                        <i class="fas fa-users"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-outline-success">View All Events</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>