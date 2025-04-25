<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - EventHub</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/registrations">My Registrations</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/customer/profile">My Profile</a>
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
	                <h2>Edit Profile</h2>
	                <nav aria-label="breadcrumb">
	                    <ol class="breadcrumb">
	                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
	                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/profile">My Profile</a></li>
	                        <li class="breadcrumb-item active" aria-current="page">Edit Profile</li>
	                    </ol>
	                </nav>
	            </div>
	        </div>

	        <div class="row">
	            <div class="col-md-8 offset-md-2">
	                <div class="card">
	                    <div class="card-header bg-info text-white">
	                        <h5 class="mb-0">Edit Profile Information</h5>
	                    </div>
	                    <div class="card-body">
	                        <form action="${pageContext.request.contextPath}/customer/profile/edit" method="post">
	                            <input type="hidden" name="id" value="${customer.id}" />
	                            
	                            <div class="mb-3">
	                                <label for="username" class="form-label">Username</label>
	                                <input type="text" class="form-control" id="username" name="username" value="${customer.username}" readonly>
	                                <div class="form-text">Username cannot be changed.</div>
	                            </div>
	                            
	                            <div class="mb-3">
	                                <label for="fullName" class="form-label">Full Name</label>
	                                <input type="text" class="form-control" id="fullName" name="fullName" value="${customer.fullName}" required>
	                            </div>
	                            
	                            <div class="mb-3">
	                                <label for="email" class="form-label">Email</label>
	                                <input type="email" class="form-control" id="email" name="email" value="${customer.email}" required>
	                            </div>
	                            
	                            
	                            <div class="mb-3">
	                                <label for="password" class="form-label">Password</label>
	                                <input type="password" class="form-control" id="password" name="password">
	                                <div class="form-text">Leave blank to keep your current password.</div>
	                            </div>
	                            
	                            <div class="mb-3">
	                                <label for="confirmPassword" class="form-label">Confirm Password</label>
	                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
	                                <div class="form-text">Re-enter your new password.</div>
	                            </div>
	                            
	                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
	                                <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-secondary me-md-2">Cancel</a>
	                                <button type="submit" class="btn btn-info">Save Changes</button>
	                            </div>
	                        </form>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>

	    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
	    <script>
	        // 添加密碼確認驗證
	        document.querySelector('form').addEventListener('submit', function(e) {
	            const password = document.getElementById('password').value;
	            const confirmPassword = document.getElementById('confirmPassword').value;
	            
	            if (password !== '' && password !== confirmPassword) {
	                e.preventDefault();
	                alert('Passwords do not match!');
	            }
	        });
	    </script>
	</body>
	</html>