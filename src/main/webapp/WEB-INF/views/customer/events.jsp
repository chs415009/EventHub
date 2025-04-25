<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Events - EventHub</title>
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
                <h2>Browse Events</h2>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <h5 class="mb-0">Upcoming Events</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex" action="${pageContext.request.contextPath}/customer/events" method="get">
                                    <input type="hidden" name="page" value="0">
                                    <input class="form-control me-2" type="search" name="keyword" placeholder="Search by title or description" value="${keyword}" aria-label="Search">
                                    <button class="btn btn-light" type="submit">Search</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col">
                                <div class="btn-group" role="group">
                                    <a href="${pageContext.request.contextPath}/customer/events?page=0" class="btn btn-outline-info ${empty category ? 'active' : ''}">All</a>
                                    <a href="${pageContext.request.contextPath}/customer/events?category=Technology&page=0" class="btn btn-outline-info ${category == 'Technology' ? 'active' : ''}">Technology</a>
                                    <a href="${pageContext.request.contextPath}/customer/events?category=Music&page=0" class="btn btn-outline-info ${category == 'Music' ? 'active' : ''}">Music</a>
                                    <a href="${pageContext.request.contextPath}/customer/events?category=Sports&page=0" class="btn btn-outline-info ${category == 'Sports' ? 'active' : ''}">Sports</a>
                                    <a href="${pageContext.request.contextPath}/customer/events?category=Workshop&page=0" class="btn btn-outline-info ${category == 'Workshop' ? 'active' : ''}">Workshop</a>
									<a href="${pageContext.request.contextPath}/customer/events?category=Others&page=0" class="btn btn-outline-info ${category == 'Others' ? 'active' : ''}">Others</a>
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${empty events}">
                            <p class="text-muted">No events found matching your criteria.</p>
                        </c:if>
                        
                        <c:if test="${not empty events}">
                            <div class="row">
                                <c:forEach var="event" items="${events}">
                                    <div class="col-md-4 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header">
                                                <h5 class="card-title">${event.title}</h5>
                                            </div>
                                            <div class="card-body">
                                                <p>
                                                    <i class="fas fa-calendar-alt me-2"></i>
                                                    <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                                </p>
                                                <p><i class="fas fa-map-marker-alt me-2"></i> ${event.location}</p>
                                                <p><i class="fas fa-tag me-2"></i> ${event.category}</p>
                                                <p><i class="fas fa-user-tie me-2"></i> ${event.organizer.fullName}</p>
                                                <p><i class="fas fa-users me-2"></i> ${event.registeredCustomers.size()} / ${event.maxCapacity}</p>
                                                <p class="card-text">${event.description.length() > 100 ? event.description.substring(0, 100).concat('...') : event.description}</p>
                                            </div>
                                            <div class="card-footer bg-transparent">
                                                <a href="${pageContext.request.contextPath}/customer/events/${event.id}" class="btn btn-outline-info w-100">View Details</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <div class="mt-3 text-center">
                                <p class="text-muted">
                                    Showing ${events.size()} of ${totalEvents} events
                                    <c:if test="${totalPages > 1}">
                                        (Page ${currentPage + 1} of ${totalPages})
                                    </c:if>
                                </p>
                            </div>
                            
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Event pagination">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/customer/events?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty category ? '&category='.concat(category) : ''}" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        
                                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/customer/events?page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty category ? '&category='.concat(category) : ''}">
                                                    ${i + 1}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        
                                        <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/customer/events?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty category ? '&category='.concat(category) : ''}" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>