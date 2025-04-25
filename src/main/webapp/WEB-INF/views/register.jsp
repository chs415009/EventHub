<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EventHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .register-container {
            max-width: 500px;
            margin: 50px auto;
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
        .register-form label {
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
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .organizer-fields, .customer-fields {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <div class="logo-area">
                <div class="logo">EventHub</div>
                <p class="text-muted">Create your account</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>
            
            <form class="register-form" action="register" method="post">
                <div class="mb-3">
                    <label for="userType" class="form-label">Select Account Type</label>
                    <div class="role-selector">
                        <div class="role-item" data-value="customer" data-target="customer-fields">
                            <i class="fas fa-user"></i> Customer
                        </div>
                        <div class="role-item" data-value="organizer" data-target="organizer-fields">
                            <i class="fas fa-handshake"></i> Organizer
                        </div>
                    </div>
                    <input type="hidden" id="userType" name="userType" value="customer">
                </div>
                
                <!-- Common fields -->
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="fullName" class="form-label">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>
                
                <!-- Customer specific fields 
                <div class="customer-fields">
                    <div class="mb-3">
                        <label for="age" class="form-label">Age</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-birthday-cake"></i></span>
                            <input type="number" class="form-control" id="age" name="age" min="18">
                        </div>
                    </div>
                </div>
                
                Organizer specific fields
                <div class="organizer-fields">
                    <div class="mb-3">
                        <label for="contactPhone" class="form-label">Contact Phone</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                            <input type="text" class="form-control" id="contactPhone" name="contactPhone">
                        </div>
                    </div>
                </div>-->
                
                <button type="submit" class="btn btn-primary btn-register">Create Account</button>
            </form>
            
            <div class="login-link">
                <p>Already have an account? <a href="/eventhub/">Sign in here</a></p>
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
                
                // Hide all role-specific fields
                document.querySelector('.organizer-fields').style.display = 'none';
                document.querySelector('.customer-fields').style.display = 'none';
                
                // Show fields for selected role
                const targetFields = this.getAttribute('data-target');
                if (targetFields) {
                    document.querySelector('.' + targetFields).style.display = 'block';
                }
            });
        });
        
        // Set customer as default selected role
        document.querySelector('.role-item[data-value="customer"]').click();
        
        // Password confirmation check
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html>