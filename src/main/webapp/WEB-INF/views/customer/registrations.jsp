<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Registrations - EventHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/customer/dashboard">EventHub</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/events">Browse Events</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/registrations">My Registrations</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/profile">My Profile</a>
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
        <div class="row mb-3">
            <div class="col">
                <h2>My Registrations</h2>
            </div>
        </div>

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
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Upcoming Events</h5>
                    </div>
                    <div class="card-body">
                        <c:set var="hasUpcomingEvents" value="false" />
                        
                        <c:if test="${not empty registeredEvents}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Date</th>
                                            <th>Location</th>
                                            <th>Organizer</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="event" items="${registeredEvents}">
                                            <c:if test="${event.eventDate != null && !event.eventDate.isBefore(currentDateTime)}">
                                                <c:set var="hasUpcomingEvents" value="true" />
                                                <tr>
                                                    <td>${event.title}</td>
                                                    <td>
                                                        <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                                    </td>
                                                    <td>${event.location}</td>
                                                    <td>${event.organizer.fullName}</td>
                                                    <td>
                                                        <span class="badge bg-success">Registered</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/customer/events/${event.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-info-circle"></i> Details
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/customer/events/${event.id}/unregister" method="post" class="d-inline">
                                                            <button type="submit" class="btn btn-sm btn-danger" 
                                                                    onclick="return confirm('Are you sure you want to cancel your registration?')">
                                                                <i class="fas fa-times"></i> Cancel
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        
                        <c:if test="${!hasUpcomingEvents}">
                            <p class="text-muted">You have no upcoming registered events. <a href="${pageContext.request.contextPath}/customer/events">Browse events</a> to register.</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Past Events</h5>
                    </div>
                    <div class="card-body">
                        <c:set var="hasPastEvents" value="false" />
                        
                        <c:if test="${not empty registeredEvents}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Date</th>
                                            <th>Location</th>
                                            <th>Organizer</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="event" items="${registeredEvents}">
                                            <c:if test="${event.eventDate != null && event.eventDate.isBefore(currentDateTime)}">
                                                <c:set var="hasPastEvents" value="true" />
                                                <tr>
                                                    <td>${event.title}</td>
                                                    <td>
                                                        <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                                    </td>
                                                    <td>${event.location}</td>
                                                    <td>${event.organizer.fullName}</td>
                                                    <td>
                                                        <span class="badge bg-secondary">Past</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/customer/events/${event.id}" class="btn btn-sm btn-info">
                                                            <i class="fas fa-info-circle"></i> Details
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        
                        <c:if test="${!hasPastEvents}">
                            <p class="text-muted">You haven't attended any past events yet.</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>