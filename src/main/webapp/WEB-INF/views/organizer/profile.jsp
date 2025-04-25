<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - EventHub</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/events">My Events</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/organizer/profile">My Profile</a>
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
                <h2>My Profile</h2>
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

        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Profile Information</h5>
                        <a href="${pageContext.request.contextPath}/organizer/profile/edit" class="btn btn-light btn-sm">
                            <i class="fas fa-edit"></i> Edit Profile
                        </a>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Username:</div>
                            <div class="col-md-8">${organizer.username}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Full Name:</div>
                            <div class="col-md-8">${organizer.fullName}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Email:</div>
                            <div class="col-md-8">${organizer.email}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Events Created:</div>
                            <div class="col-md-8">${organizer.events.size()}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Account Security</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Change Password</h6>
                            <p class="text-muted">You can change your password by editing your profile.</p>
                            <a href="${pageContext.request.contextPath}/organizer/profile/edit" class="btn btn-outline-success">
                                <i class="fas fa-key"></i> Change Password
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Event Statistics</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <div class="border rounded p-3 mb-2">
                                    <h3>${organizer.events.size()}</h3>
                                    <p class="mb-0">Total Events</p>
                                </div>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="border rounded p-3 mb-2">
                                    <h3>
                                        <c:set var="totalRegistrations" value="0" />
                                        <c:forEach var="event" items="${organizer.events}">
                                            <c:set var="totalRegistrations" value="${totalRegistrations + event.registeredCustomers.size()}" />
                                        </c:forEach>
                                        ${totalRegistrations}
                                    </h3>
                                    <p class="mb-0">Total Registrations</p>
                                </div>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="border rounded p-3 mb-2">
                                    <h3>
                                        <c:set var="upcomingEvents" value="0" />
                                        <c:forEach var="event" items="${organizer.events}">
                                            <c:if test="${!event.eventDate.isBefore(currentDateTime)}">
                                                <c:set var="upcomingEvents" value="${upcomingEvents + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${upcomingEvents}
                                    </h3>
                                    <p class="mb-0">Upcoming Events</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-outline-success">
                                <i class="fas fa-list"></i> View All Events
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>