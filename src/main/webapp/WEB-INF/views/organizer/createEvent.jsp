<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - EventHub</title>
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
                <h2>Create New Event</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/organizer/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/organizer/events">My Events</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Create Event</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Event Details</h5>
                    </div>
                    <div class="card-body">
                        <form:form action="${pageContext.request.contextPath}/organizer/events/create" method="post" modelAttribute="event">
                            <div class="mb-3">
                                <label for="title" class="form-label">Event Title</label>
                                <form:input path="title" class="form-control" required="required" />
                                <form:errors path="title" cssClass="text-danger" />
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <form:textarea path="description" class="form-control" rows="4" required="required" />
                                <form:errors path="description" cssClass="text-danger" />
                            </div>
                            
                            <div class="mb-3">
                                <label for="eventDate" class="form-label">Event Date</label>
                                <form:input type="datetime-local" path="eventDate" class="form-control" required="required" />
                                <form:errors path="eventDate" cssClass="text-danger" />
                            </div>
                            
                            <div class="mb-3">
                                <label for="location" class="form-label">Location</label>
                                <form:input path="location" class="form-control" required="required" />
                                <form:errors path="location" cssClass="text-danger" />
                            </div>
                            
                            <div class="mb-3">
                                <label for="category" class="form-label">Category</label>
                                <form:select path="category" class="form-select" required="required">
                                    <form:option value="Technology">Technology</form:option>
                                    <form:option value="Music">Music</form:option>
                                    <form:option value="Sports">Sports</form:option>
                                    <form:option value="Workshop">Workshop</form:option>
                                    <form:option value="Other">Other</form:option>
                                </form:select>
                                <form:errors path="category" cssClass="text-danger" />
                            </div>
                            
                            <div class="mb-3">
                                <label for="maxCapacity" class="form-label">Maximum Capacity</label>
                                <form:input type="number" path="maxCapacity" class="form-control" required="required" min="1" />
                                <form:errors path="maxCapacity" cssClass="text-danger" />
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Image URL (Optional)</label>
                                <form:input path="imageUrl" class="form-control" />
                                <form:errors path="imageUrl" cssClass="text-danger" />
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/organizer/events" class="btn btn-secondary me-md-2">Cancel</a>
                                <button type="submit" class="btn btn-success">Create Event</button>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>