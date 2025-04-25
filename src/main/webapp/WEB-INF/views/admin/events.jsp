<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - EventHub Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">	
</head>
<body>
    <div class="container mt-4">
        <div class="row mb-3">
            <div class="col">
                <h2>Manage Events</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Events</li>
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

        <div class="row mb-3">
            <div class="col">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <h5 class="mb-0">Event List</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex" action="${pageContext.request.contextPath}/admin/events" method="get">
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
                                    <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline-primary ${empty category ? 'active' : ''}">All</a>
                                    <a href="${pageContext.request.contextPath}/admin/events?category=Technology" class="btn btn-outline-primary ${category == 'Technology' ? 'active' : ''}">Technology</a>
                                    <a href="${pageContext.request.contextPath}/admin/events?category=Music" class="btn btn-outline-primary ${category == 'Music' ? 'active' : ''}">Music</a>
                                    <a href="${pageContext.request.contextPath}/admin/events?category=Sports" class="btn btn-outline-primary ${category == 'Sports' ? 'active' : ''}">Sports</a>
                                    <a href="${pageContext.request.contextPath}/admin/events?category=Workshop" class="btn btn-outline-primary ${category == 'Workshop' ? 'active' : ''}">Workshop</a>
									<a href="${pageContext.request.contextPath}/admin/events?category=Others" class="btn btn-outline-primary ${category == 'Others' ? 'active' : ''}">Others</a>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Title</th>
                                        <th>Organizer</th>
                                        <th>Date</th>
                                        <th>Location</th>
                                        <th>Category</th>
                                        <th>Capacity</th>
                                        <th>Registrations</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="event" items="${events}">
                                        <tr>
                                            <td>${event.id}</td>
                                            <td>${event.title}</td>
                                            <td>${event.organizer.fullName}</td>
                                            <td>
                                                <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="MM/dd/yyyy HH:mm" />
                                            </td>
                                            <td>${event.location}</td>
                                            <td>${event.category}</td>
                                            <td>${event.maxCapacity}</td>
                                            <td>${event.registeredCustomers.size()}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/events/edit/${event.id}" class="btn btn-sm btn-primary">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/events/delete/${event.id}" class="btn btn-sm btn-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this event?')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>