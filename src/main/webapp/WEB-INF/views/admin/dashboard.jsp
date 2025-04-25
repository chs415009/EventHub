<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EventHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3>Admin Dashboard</h3>
                    </div>
                    <div class="card-body">
                        <h5>Welcome, ${currentUser.fullName}!</h5>
                        <p>This is the administrator dashboard where you can manage the entire EventHub platform.</p>
                        
                        <div class="row mt-4">
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body text-center">
                                        <h5>Manage Customers</h5>
                                        <p>View and manage users</p>
                                        <a href="${pageContext.request.contextPath}/admin/customers" class="btn btn-outline-primary">View Users</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body text-center">
                                        <h5>Manage Events</h5>
                                        <p>View and manage events</p>
                                        <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-outline-primary">View Events</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body text-center">
                                        <h5>Manage Organizers</h5>
                                        <p>View and manage event organizers</p>
                                        <a href="${pageContext.request.contextPath}/admin/organizers" class="btn btn-outline-primary">View Organizers</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="card-footer">
					    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout</a>
					</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>