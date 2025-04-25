<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.title} - EventHub</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/events">Browse Events</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/registrations">My Registrations</a>
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
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/events">Events</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${event.title}</li>
                    </ol>
                </nav>
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
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0">${event.title}</h4>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <h5>Event Description</h5>
                            <p>${event.description}</p>
                        </div>
                        
                        <div class="mb-4">
                            <h5>Event Details</h5>
                            <div class="row mb-2">
                                <div class="col-md-3 fw-bold">Date & Time:</div>
                                <div class="col-md-9">
                                    <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="EEEE, MMMM d, yyyy 'at' h:mm a" />
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-3 fw-bold">Location:</div>
                                <div class="col-md-9">${event.location}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-3 fw-bold">Category:</div>
                                <div class="col-md-9">${event.category}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-3 fw-bold">Organizer:</div>
                                <div class="col-md-9">${event.organizer.fullName}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-3 fw-bold">Capacity:</div>
                                <div class="col-md-9">${event.registeredCustomers.size()} / ${event.maxCapacity}</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-3 fw-bold">Status:</div>
                                <div class="col-md-9">
                                    <c:choose>
                                        <c:when test="${isExpired}">
                                            <span class="badge bg-secondary">Past Event</span>
                                        </c:when>
                                        <c:when test="${isFull}">
                                            <span class="badge bg-danger">Sold Out</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">Open for Registration</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${!isExpired && !isFull && !isRegistered}">
                            <div class="alert alert-info" role="alert">
                                <h5 class="alert-heading">Join This Event!</h5>
                                <p>There are ${event.maxCapacity - event.registeredCustomers.size()} spots remaining. Register now to secure your place.</p>
                                <hr>
                                <form action="${pageContext.request.contextPath}/customer/events/${event.id}/register" method="post">
                                    <button type="submit" class="btn btn-info">Register Now</button>
                                </form>
                            </div>
                        </c:if>
                        
                        <c:if test="${isRegistered}">
                            <div class="alert alert-success" role="alert">
                                <h5 class="alert-heading">You're Registered!</h5>
                                <p>You are already registered for this event. We look forward to seeing you there!</p>
                                <hr>
                                <form action="${pageContext.request.contextPath}/customer/events/${event.id}/unregister" method="post">
                                    <button type="submit" class="btn btn-outline-danger" 
                                            onclick="return confirm('Are you sure you want to cancel your registration?')">
                                        Cancel Registration
                                    </button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Registration Status</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Current Registrations</h6>
                            <div class="progress">
                                <div class="progress-bar bg-info" role="progressbar" 
                                     style="width: ${(event.registeredCustomers.size() / event.maxCapacity) * 100}%;" 
                                     aria-valuenow="${event.registeredCustomers.size()}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="${event.maxCapacity}">
                                    ${event.registeredCustomers.size()} / ${event.maxCapacity}
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${isExpired}">
                                    <div class="alert alert-secondary">
                                        This event has already taken place.
                                    </div>
                                </c:when>
                                <c:when test="${isFull}">
                                    <div class="alert alert-danger">
                                        This event is sold out.
                                    </div>
                                </c:when>
                                <c:when test="${isRegistered}">
                                    <div class="alert alert-success">
                                        You are registered for this event.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">
                                        ${event.maxCapacity - event.registeredCustomers.size()} spots remaining!
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Countdown</h5>
                    </div>
                    <div class="card-body">
                        <div id="countdown">
                            <div class="row text-center">
                                <div class="col-3">
                                    <h3 id="days">00</h3>
                                    <span>Days</span>
                                </div>
                                <div class="col-3">
                                    <h3 id="hours">00</h3>
                                    <span>Hours</span>
                                </div>
                                <div class="col-3">
                                    <h3 id="minutes">00</h3>
                                    <span>Minutes</span>
                                </div>
                                <div class="col-3">
                                    <h3 id="seconds">00</h3>
                                    <span>Seconds</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Countdown timer
        <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
        <fmt:formatDate value="${parsedDate}" pattern="yyyy, MM-1, dd, HH, mm, ss" var="eventDateJs" />
        
        const eventDate = new Date(${eventDateJs}).getTime();
        
        const countdownTimer = setInterval(function() {
            const now = new Date().getTime();
            const timeLeft = eventDate - now;
            
            if (timeLeft < 0) {
                clearInterval(countdownTimer);
                document.getElementById("countdown").innerHTML = "<h4 class='text-center'>Event has started/ended</h4>";
                return;
            }
            
            const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
            const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);
            
            document.getElementById("days").innerHTML = days.toString().padStart(2, '0');
            document.getElementById("hours").innerHTML = hours.toString().padStart(2, '0');
            document.getElementById("minutes").innerHTML = minutes.toString().padStart(2, '0');
            document.getElementById("seconds").innerHTML = seconds.toString().padStart(2, '0');
        }, 1000);
    </script>
</body>
</html>