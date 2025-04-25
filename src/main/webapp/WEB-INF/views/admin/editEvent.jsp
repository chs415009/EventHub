<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event - EventHub Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container mt-4">
        <div class="row mb-3">
            <div class="col">
                <h2>Edit Event</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/events">Events</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Edit Event</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Edit Event Details</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/events/edit/${event.id}" method="post">
                            <div class="mb-3">
                                <label for="title" class="form-label">Event Title</label>
                                <input type="text" class="form-control" id="title" name="title" value="${event.title}" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="organizer.id" class="form-label">Organizer</label>
                                <select class="form-select" id="organizer.id" name="organizer.id" required>
                                    <c:forEach var="organizer" items="${organizers}">
                                        <option value="${organizer.id}" ${event.organizer.id == organizer.id ? 'selected' : ''}>
                                            ${organizer.fullName} (${organizer.username})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="4" required>${event.description}</textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="eventDate" class="form-label">Event Date</label>
                                <fmt:parseDate value="${event.eventDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <input type="datetime-local" class="form-control" id="eventDate" name="eventDate" 
                                       value="<fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="location" class="form-label">Location</label>
                                <input type="text" class="form-control" id="location" name="location" value="${event.location}" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="Technology" ${event.category == 'Technology' ? 'selected' : ''}>Technology</option>
                                    <option value="Music" ${event.category == 'Music' ? 'selected' : ''}>Music</option>
                                    <option value="Sports" ${event.category == 'Sports' ? 'selected' : ''}>Sports</option>
                                    <option value="Workshop" ${event.category == 'Workshop' ? 'selected' : ''}>Workshop</option>
                                    <option value="Other" ${event.category == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="maxCapacity" class="form-label">Maximum Capacity</label>
                                <input type="number" class="form-control" id="maxCapacity" name="maxCapacity" value="${event.maxCapacity}" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Image URL (Optional)</label>
                                <input type="text" class="form-control" id="imageUrl" name="imageUrl" value="${event.imageUrl}">
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-secondary me-md-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>