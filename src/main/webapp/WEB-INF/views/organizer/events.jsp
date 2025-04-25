<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Events - EventHub</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/dashboard">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/organizer/events">My Events</a>
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
        <div class="row mb-3">
            <div class="col">
                <h2>My Events</h2>
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

        <div class="row mb-3">
            <div class="col">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <h5 class="mb-0">Event List</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex" action="${pageContext.request.contextPath}/organizer/events" method="get">
                                    <input class="form-control me-2" type="search" name="keyword" placeholder="Search by title or description" value="${keyword}" aria-label="Search">
                                    <button class="btn btn-light" type="submit">Search</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-success">
                                <i class="fas fa-plus"></i> Create New Event
                            </a>
                        </div>
                        
                        <c:if test="${empty events}">
                            <p class="text-muted">No events found. <a href="${pageContext.request.contextPath}/organizer/events/create">Create one now</a>.</p>
                        </c:if>
                        
                        <c:if test="${not empty events}">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Date</th>
                                            <th>Location</th>
                                            <th>Category</th>
                                            <th>Capacity</th>
                                            <th>Registrations</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="event" items="${events}">
                                            <tr>
                                                <td>${event.title}</td>
                                                <td>
                                                    <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                                </td>
                                                <td>${event.location}</td>
                                                <td>${event.category}</td>
                                                <td>${event.maxCapacity}</td>
                                                <td>${event.registeredCustomers.size()}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${event.eventDate.isBefore(currentDateTime)}">
                                                            <span class="badge bg-secondary">Past</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">Upcoming</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${!event.eventDate.isBefore(currentDateTime)}">
                                                        <a href="${pageContext.request.contextPath}/organizer/events/edit/${event.id}" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/organizer/events/${event.id}/participants" class="btn btn-sm btn-info">
                                                        <i class="fas fa-users"></i> Participants
                                                    </a>
                                                    <c:if test="${!event.eventDate.isBefore(currentDateTime)}">
                                                        <a href="${pageContext.request.contextPath}/organizer/events/delete/${event.id}" class="btn btn-sm btn-danger" 
                                                           onclick="return confirm('Are you sure you want to delete this event?')">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </a>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>