<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EventHub</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            max-width: 450px;
            margin: 100px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        .logo-area {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo {
            font-size: 2.5rem;
            font-weight: bold;
            color: #4e73df;
        }
        .login-form label {
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        .role-selector {
            margin-bottom: 20px;
        }
        .role-item {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
            margin: 5px 0;
            cursor: pointer;
            transition: all 0.3s;
        }
        .role-item:hover, .role-item.active {
            background-color: #e8f0fe;
            border-color: #4e73df;
        }
        .role-item i {
            color: #4e73df;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
            width: 100%;
            padding: 10px;
        }
        .btn-primary:hover {
            background-color: #3a5ec1;
            border-color: #3a5ec1;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .error-message {
            color: #dc3545;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="logo-area">
                <div class="logo">EventHub</div>
                <p class="text-muted">Sign in to access your account</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>
			
			<c:if test="${not empty success}">
			    <div class="alert alert-success" role="alert">
			        ${success}
			    </div>
			</c:if>
            
            <form class="login-form" action="login" method="post">
                <div class="mb-3">
                    <label for="userType" class="form-label">Select User Type</label>
                    <div class="role-selector">
                        <div class="role-item" data-value="customer">
                            <i class="fas fa-user"></i> Customer
                        </div>
                        <div class="role-item" data-value="organizer">
                            <i class="fas fa-handshake"></i> Organizer
                        </div>
                        <div class="role-item" data-value="admin">
                            <i class="fas fa-user-shield"></i> Administrator
                        </div>
                    </div>
                    <input type="hidden" id="userType" name="userType" value="customer">
                </div>
                
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-login">Sign In</button>
            </form>
            
            <div class="register-link">
                <p>Don't have an account? <a href="register">Create one now</a></p>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Role selection logic
        document.querySelectorAll('.role-item').forEach(item => {
            item.addEventListener('click', function() {
                // Remove active class from all items
                document.querySelectorAll('.role-item').forEach(el => {
                    el.classList.remove('active');
                });
                
                // Add active class to clicked item
                this.classList.add('active');
                
                // Update hidden input value
                document.getElementById('userType').value = this.getAttribute('data-value');
            });
        });
        
        // Set customer as default selected role
        document.querySelector('.role-item[data-value="customer"]').classList.add('active');
    </script>
</body>
</html>