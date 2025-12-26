<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.*, org.mindrot.jbcrypt.BCrypt" %>

<%

String managerName = (String) session.getAttribute("managerName");
String managerEmail = (String) session.getAttribute("managerEmail");
Integer managerId = (Integer) session.getAttribute("managerId");

if (managerName == null || managerEmail == null || managerId == null) {
    response.sendRedirect("unifiedLogin.jsp");
    return;
}

Connection conTailor = null;
Connection conShop = null;
Connection conSystem = null;
PreparedStatement ps = null;
ResultSet rs = null;

List<Map<String, Object>> admins = new ArrayList<>();
List<Map<String, Object>> tailors = new ArrayList<>();
List<Map<String, Object>> users = new ArrayList<>();
List<Map<String, Object>> suits = new ArrayList<>();
List<Map<String, Object>> alterations = new ArrayList<>();
List<Map<String, Object>> orders = new ArrayList<>();
List<Map<String, Object>> reviews = new ArrayList<>();

int totalAdmins = 0, totalTailors = 0, totalUsers = 0, totalSuits = 0;
int totalAlterations = 0, totalOrders = 0, totalReviews = 0;

int completedSuitRequests = 0;
int completedAlterationRequests = 0;
int completedOrdersCount = 0;
int pendingSuitRequests = 0;
int pendingAlterationRequests = 0;
int pendingOrdersCount = 0;

SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
SimpleDateFormat shortFormat = new SimpleDateFormat("dd-MMM-yyyy");

try {
    
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    conTailor = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_db", "root", "12345");
    conShop = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_shop", "root", "12345");
    conSystem = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_db", "root", "12345");
    
    String sql = "SELECT * FROM admin_users ORDER BY created_at DESC";
    ps = conSystem.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("name", rs.getString("name"));
        row.put("email", rs.getString("email"));
        row.put("admin_key", rs.getString("admin_key"));
        row.put("created_at", rs.getTimestamp("created_at"));
        admins.add(row);
    }
    totalAdmins = admins.size();
    rs.close();
    ps.close();
    
    sql = "SELECT * FROM tailors ORDER BY created_at DESC";
    ps = conTailor.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("name", rs.getString("name"));
        row.put("phone", rs.getString("phone"));
        row.put("email", rs.getString("email"));
        row.put("specialty", rs.getString("specialty"));
        row.put("experience", rs.getInt("experience"));
        row.put("verified", rs.getInt("verified"));
        row.put("status", rs.getString("status"));
        row.put("picture_path", rs.getString("picture_path"));
        row.put("created_at", rs.getTimestamp("created_at"));
        row.put("approval_time", rs.getTimestamp("approval_time"));
        tailors.add(row);
    }
    totalTailors = tailors.size();
    rs.close();
    ps.close();
    
    sql = "SELECT * FROM signup_login ORDER BY created_at DESC";
    ps = conTailor.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("username", rs.getString("username"));
        row.put("email", rs.getString("email"));
        row.put("password", rs.getString("password"));
        row.put("created_at", rs.getTimestamp("created_at"));
        users.add(row);
    }
    totalUsers = users.size();
    rs.close();
    ps.close();
    
    sql = "SELECT * FROM suit_requests ORDER BY created_at DESC";
    ps = conTailor.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("request_id", rs.getString("request_id"));
        row.put("garment", rs.getString("garment"));
        row.put("slai", rs.getString("slai"));
        row.put("customer_name", rs.getString("customer_name"));
        row.put("customer_phone", rs.getString("customer_phone"));
        row.put("tailor_name", rs.getString("tailor_name"));
        row.put("status", rs.getString("status"));
        row.put("deadline", rs.getDate("deadline"));
        row.put("created_at", rs.getTimestamp("created_at"));
        suits.add(row);
        
        String status = rs.getString("status");
        if ("completed".equals(status) || "delivered".equals(status)) {
            completedSuitRequests++;
        } else if ("pending".equals(status)) {
            pendingSuitRequests++;
        }
    }
    totalSuits = suits.size();
    rs.close();
    ps.close();
    
    sql = "SELECT * FROM alteration_requests ORDER BY created_at DESC";
    ps = conTailor.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("request_id", rs.getString("request_id"));
        row.put("garment", rs.getString("garment"));
        row.put("alteration_type", rs.getString("alteration_type"));
        row.put("customer_name", rs.getString("customer_name"));
        row.put("customer_phone", rs.getString("customer_phone"));
        row.put("tailor_name", rs.getString("tailor_name"));
        row.put("status", rs.getString("status"));
        row.put("created_at", rs.getTimestamp("created_at"));
        alterations.add(row);
        
        String status = rs.getString("status");
        if ("completed".equals(status) || "delivered".equals(status)) {
            completedAlterationRequests++;
        } else if ("pending".equals(status)) {
            pendingAlterationRequests++;
        }
    }
    totalAlterations = alterations.size();
    rs.close();
    ps.close();
    
    sql = "SELECT * FROM orders ORDER BY id DESC";
    ps = conShop.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("name", rs.getString("name"));
        row.put("phone", rs.getString("phone"));
        row.put("product_name", rs.getString("product_name"));
        row.put("price", rs.getDouble("price"));
        row.put("payment_method", rs.getString("payment_method"));
        row.put("order_id", rs.getString("order_id"));
        row.put("status", rs.getString("status"));
        row.put("approval_date", rs.getTimestamp("approval_date"));
        orders.add(row);
        
        String status = rs.getString("status");
        if ("delivered".equals(status) || "completed".equals(status)) {
            completedOrdersCount++;
        } else if ("pending".equals(status) || "processing".equals(status)) {
            pendingOrdersCount++;
        }
    }
    totalOrders = orders.size();
    rs.close();
    ps.close();
    
    sql = "SELECT * FROM reviews ORDER BY created_at DESC";
    ps = conShop.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("name", rs.getString("name"));
        row.put("review", rs.getString("review"));
        row.put("created_at", rs.getTimestamp("created_at"));
        reviews.add(row);
    }
    totalReviews = reviews.size();
    rs.close();
    ps.close();
    
} catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('Error fetching data: " + e.getMessage() + "');</script>");
} finally {
    
    if (rs != null) try { rs.close(); } catch(SQLException e) {}
    if (ps != null) try { ps.close(); } catch(SQLException e) {}
    if (conTailor != null) try { conTailor.close(); } catch(SQLException e) {}
    if (conShop != null) try { conShop.close(); } catch(SQLException e) {}
    if (conSystem != null) try { conSystem.close(); } catch(SQLException e) {}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e40af;
            --secondary: #059669;
            --danger: #dc2626;
            --warning: #d97706;
            --info: #2563eb;
            --dark: #0f172a;
            --darker: #020617;
            --light: #e2e8f0;
            --card-bg: #1e293b;
            --header-bg: #020617;
            --success: #10b981;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--dark);
            color: var(--light);
            line-height: 1.6;
        }

        .manager-header {
            background: linear-gradient(135deg, var(--header-bg), #1e293b);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(30, 64, 175, 0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .manager-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--primary);
            font-size: 1.8rem;
            font-weight: bold;
        }

        .manager-info {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 20px;
            background: rgba(30, 64, 175, 0.1);
            border-radius: 10px;
            border: 1px solid var(--primary);
        }

        .manager-details h3 {
            color: var(--light);
            margin-bottom: 5px;
            font-size: 1.2rem;
        }

        .manager-details p {
            color: var(--secondary);
            font-size: 0.9rem;
        }

        .header-right {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--info));
            color: white;
            box-shadow: 0 0 15px rgba(30, 64, 175, 0.4);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
            box-shadow: 0 0 15px rgba(220, 38, 38, 0.4);
        }

        .btn-success {
            background: var(--success);
            color: white;
            box-shadow: 0 0 15px rgba(16, 185, 129, 0.4);
        }

        .btn-warning {
            background: var(--warning);
            color: white;
            box-shadow: 0 0 15px rgba(217, 119, 6, 0.4);
        }

        .btn-info {
            background: var(--info);
            color: white;
            box-shadow: 0 0 15px rgba(37, 99, 235, 0.4);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px currentColor;
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .nav-tabs {
            background: var(--header-bg);
            padding: 15px 30px;
            display: flex;
            gap: 10px;
            overflow-x: auto;
            border-bottom: 2px solid var(--card-bg);
        }

        .nav-tabs::-webkit-scrollbar {
            display: none;
        }

        .tab-btn {
            padding: 12px 25px;
            background: transparent;
            border: 2px solid var(--primary);
            color: var(--primary);
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            white-space: nowrap;
            transition: all 0.3s ease;
        }

        .tab-btn:hover, .tab-btn.active {
            background: var(--primary);
            color: white;
            box-shadow: 0 0 20px var(--primary);
        }

        .dashboard-container {
            max-width: 1800px;
            margin: 0 auto;
            padding: 20px;
        }

        .section {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(30, 64, 175, 0.1);
            display: none;
        }

        .section.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--primary);
        }

        .section-title {
            color: var(--primary);
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-actions {
            display: flex;
            gap: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, var(--card-bg), #2d3748);
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(30, 64, 175, 0.3);
            border-color: var(--primary);
        }

        .stat-card i {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--primary);
            margin: 10px 0;
        }

        .stat-label {
            color: var(--light);
            opacity: 0.8;
            font-size: 1.1rem;
        }

        .stat-subtext {
            font-size: 0.9rem;
            color: var(--secondary);
            margin-top: 5px;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
            background: rgba(2, 6, 23, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .table-container {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        .table-container th {
            background: var(--darker);
            color: var(--primary);
            padding: 15px 12px;
            text-align: left;
            font-weight: bold;
            border-bottom: 2px solid var(--primary);
            position: sticky;
            top: 0;
            font-size: 0.95rem;
        }

        .table-container td {
            padding: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .table-container tbody tr:hover {
            background: rgba(30, 64, 175, 0.05);
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
            display: inline-block;
            min-width: 90px;
            text-align: center;
        }

        .status-pending { background: rgba(245, 158, 11, 0.2); color: #f59e0b; }
        .status-approved { background: rgba(16, 185, 129, 0.2); color: #10b981; }
        .status-complete { background: rgba(34, 197, 94, 0.2); color: #22c55e; }
        .status-processing { background: rgba(59, 130, 246, 0.2); color: #3b82f6; }
        .status-dispatched { background: rgba(147, 51, 234, 0.2); color: #9333ea; }
        .status-delivered { background: rgba(34, 197, 94, 0.2); color: #22c55e; }
        .status-rejected { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
        .status-hold { background: rgba(156, 163, 175, 0.2); color: #9ca3af; }

        .action-group {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            font-size: 0.85rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .action-btn i { font-size: 0.9rem; }

        .btn-view { background: rgba(59, 130, 246, 0.2); color: #3b82f6; }
        .btn-delete { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
        .btn-truncate { background: rgba(245, 158, 11, 0.2); color: #f59e0b; }

        .action-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 0 8px currentColor;
        }

        .action-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: var(--card-bg);
            padding: 25px;
            border-radius: 15px;
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 0 50px var(--primary);
            border: 1px solid var(--primary);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--primary);
        }

        .modal-header h3 {
            color: var(--primary);
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .close-modal {
            background: none;
            border: none;
            color: var(--light);
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .close-modal:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--primary);
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(2, 6, 23, 0.5);
            color: var(--light);
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.2);
        }

        .password-strength {
            height: 5px;
            background: #374151;
            border-radius: 3px;
            margin-top: 5px;
            overflow: hidden;
        }

        .password-strength-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease;
        }

        .strength-weak { background: #ef4444; }
        .strength-medium { background: #f59e0b; }
        .strength-strong { background: #10b981; }

        .loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.95);
            z-index: 9999;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .spinner {
            border: 4px solid rgba(30, 64, 175, 0.2);
            border-top: 4px solid var(--primary);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin-bottom: 15px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            z-index: 10000;
            animation: slideIn 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            min-width: 300px;
            max-width: 400px;
        }

        .notification.success {
            background: linear-gradient(135deg, var(--success), var(--primary));
        }

        .notification.error {
            background: linear-gradient(135deg, var(--danger), #ff6b6b);
        }

        .notification.info {
            background: linear-gradient(135deg, var(--info), #6366f1);
        }

        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }

        @media (max-width: 1200px) {
            .charts-container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .dashboard-container {
                padding: 10px;
            }

            .section {
                padding: 15px;
            }

            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }

            .stat-number {
                font-size: 2rem;
            }

            .table-container th,
            .table-container td {
                padding: 8px 6px;
                font-size: 0.85rem;
            }

            .action-group {
                flex-direction: column;
                gap: 4px;
            }

            .action-btn {
                padding: 4px 8px;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>

<header class="manager-header">
    <div class="header-left">
        <div class="manager-logo">
            <i class="fas fa-chart-line"></i>
            <span>Manager Dashboard</span>
        </div>
    </div>

    <div class="manager-info">
        <div class="manager-details">
            <h3><%= managerName %></h3>
            <p><%= managerEmail %></p>
        </div>
        <button class="btn btn-primary" onclick="openEditManagerModal()">
            <i class="fas fa-edit"></i> Edit
        </button>
    </div>

    <div class="header-right">
        <button class="btn btn-warning" onclick="location.reload()">
            <i class="fas fa-sync-alt"></i> Refresh
        </button>
        <a href="managerLogout.jsp" class="btn btn-danger">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>

<nav class="nav-tabs">
    <button class="tab-btn active" onclick="showSection('overview', this)">
        <i class="fas fa-tachometer-alt"></i> Overview
    </button>
    <button class="tab-btn" onclick="showSection('admins', this)">
        <i class="fas fa-user-shield"></i> Admins (<%= totalAdmins %>)
    </button>
    <button class="tab-btn" onclick="showSection('tailors', this)">
        <i class="fas fa-user-tie"></i> Tailors (<%= totalTailors %>)
    </button>
    <button class="tab-btn" onclick="showSection('users', this)">
        <i class="fas fa-users"></i> Users (<%= totalUsers %>)
    </button>
    <button class="tab-btn" onclick="showSection('suits', this)">
        <i class="fas fa-suitcase"></i> Suits (<%= totalSuits %>)
    </button>
    <button class="tab-btn" onclick="showSection('alterations', this)">
        <i class="fas fa-cut"></i> Alterations (<%= totalAlterations %>)
    </button>
    <button class="tab-btn" onclick="showSection('orders', this)">
        <i class="fas fa-shopping-cart"></i> Orders (<%= totalOrders %>)
    </button>
    <button class="tab-btn" onclick="showSection('reviews', this)">
        <i class="fas fa-star"></i> Reviews (<%= totalReviews %>)
    </button>
</nav>

<div class="dashboard-container">

    <section id="overview" class="section active">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-tachometer-alt"></i> Dashboard Overview
            </h2>
        </div>

        <div class="stats-grid">
            <div class="stat-card" onclick="showSection('admins', document.querySelectorAll('.tab-btn')[1])">
                <i class="fas fa-user-shield" style="color: var(--primary);"></i>
                <div class="stat-number"><%= totalAdmins %></div>
                <div class="stat-label">Admins</div>
                <div class="stat-subtext">System Administrators</div>
            </div>
            
            <div class="stat-card" onclick="showSection('tailors', document.querySelectorAll('.tab-btn')[2])">
                <i class="fas fa-user-tie" style="color: var(--info);"></i>
                <div class="stat-number"><%= totalTailors %></div>
                <div class="stat-label">Tailors</div>
                <div class="stat-subtext">Service Providers</div>
            </div>
            
            <div class="stat-card" onclick="showSection('users', document.querySelectorAll('.tab-btn')[3])">
                <i class="fas fa-users" style="color: var(--success);"></i>
                <div class="stat-number"><%= totalUsers %></div>
                <div class="stat-label">Customers</div>
                <div class="stat-subtext">Registered Users</div>
            </div>
            
            <div class="stat-card" onclick="showSection('suits', document.querySelectorAll('.tab-btn')[4])">
                <i class="fas fa-suitcase" style="color: #9333ea;"></i>
                <div class="stat-number"><%= totalSuits %></div>
                <div class="stat-label">Suit Requests</div>
                <div class="stat-subtext">Total Requests</div>
            </div>
            
            <div class="stat-card" onclick="showSection('alterations', document.querySelectorAll('.tab-btn')[5])">
                <i class="fas fa-cut" style="color: var(--warning);"></i>
                <div class="stat-number"><%= totalAlterations %></div>
                <div class="stat-label">Alterations</div>
                <div class="stat-subtext">Garment Modifications</div>
            </div>
            
            <div class="stat-card" onclick="showSection('orders', document.querySelectorAll('.tab-btn')[6])">
                <i class="fas fa-shopping-cart" style="color: #f59e0b;"></i>
                <div class="stat-number"><%= totalOrders %></div>
                <div class="stat-label">Product Orders</div>
                <div class="stat-subtext">Shop Sales</div>
            </div>
            
            <div class="stat-card" onclick="showSection('reviews', document.querySelectorAll('.tab-btn')[7])">
                <i class="fas fa-star" style="color: #fbbf24;"></i>
                <div class="stat-number"><%= totalReviews %></div>
                <div class="stat-label">Reviews</div>
                <div class="stat-subtext">Customer Feedback</div>
            </div>
            
            <div class="stat-card">
                <i class="fas fa-check-circle" style="color: #10b981;"></i>
                <div class="stat-number"><%= completedSuitRequests + completedAlterationRequests + completedOrdersCount %></div>
                <div class="stat-label">Completed</div>
                <div class="stat-subtext">Total Delivered</div>
            </div>
        </div>

        <div class="table-responsive" style="margin-top: 30px;">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>System Metrics</th>
                        <th>Count</th>
                        <th>Last Updated</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                  
                    int activeTailorsCount = 0;
                    for (Map<String, Object> tailor : tailors) {
                        if ("approved".equals(tailor.get("status"))) {
                            activeTailorsCount++;
                        }
                    }
                    
                    java.util.Date currentDate = new java.util.Date();
                    %>
                    <tr>
                        <td>Active Tailors</td>
                        <td><%= activeTailorsCount %></td>
                        <td><%= dateFormat.format(currentDate) %></td>
                        <td><span class="status-badge status-approved">ACTIVE</span></td>
                    </tr>
                    <tr>
                        <td>Pending Requests</td>
                        <td><%= pendingSuitRequests + pendingAlterationRequests + pendingOrdersCount %></td>
                        <td><%= dateFormat.format(currentDate) %></td>
                        <td><span class="status-badge status-pending">PENDING</span></td>
                    </tr>
                    <tr>
                        <td>Completed Orders</td>
                        <td><%= completedSuitRequests + completedAlterationRequests + completedOrdersCount %></td>
                        <td><%= dateFormat.format(currentDate) %></td>
                        <td><span class="status-badge status-delivered">COMPLETED</span></td>
                    </tr>
                    <tr>
                        <td>System Uptime</td>
                        <td>100%</td>
                        <td><%= dateFormat.format(currentDate) %></td>
                        <td><span class="status-badge status-approved">STABLE</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>

    <section id="admins" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-user-shield"></i> Admin Management (<%= totalAdmins %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-success" onclick="openAddAdminModal()">
                    <i class="fas fa-plus-circle"></i> Add New Admin
                </button>
                <button class="btn btn-danger" onclick="confirmTruncateAdmins()" 
                        <%= totalAdmins == 0 ? "disabled" : "" %>>
                    <i class="fas fa-trash"></i> Truncate All
                </button>
            </div>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Admin Key</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (admins.isEmpty()) { %>
                    <tr>
                        <td colspan="6" class="no-records">
                            <i class="fas fa-user-shield"></i>
                            <h3>No Admins Found</h3>
                            <p>Click "Add New Admin" to create the first admin account.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> admin : admins) { 
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) admin.get("created_at");
                            String createdDate = createdAt != null ? dateFormat.format(createdAt) : "";
                    %>
                    <tr id="admin-row-<%= admin.get("id") %>">
                        <td><%= admin.get("id") %></td>
                        <td><%= admin.get("name") %></td>
                        <td><%= admin.get("email") %></td>
                        <td>
                            <span style="font-family: monospace; background: rgba(255,255,255,0.1); padding: 2px 6px; border-radius: 4px;">
                                <%= admin.get("admin_key") != null ? admin.get("admin_key") : "N/A" %>
                            </span>
                        </td>
                        <td><%= createdDate %></td>
                        <td>
                            <div class="action-group">
                                <button class="action-btn btn-delete" onclick="deleteAdmin(<%= admin.get("id") %>, this)">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="tailors" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-user-tie"></i> Tailors Management (<%= totalTailors %>)
            </h2>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Specialty</th>
                        <th>Experience</th>
                        <th>Status</th>
                        <th>Verified</th>
                        <th>Created</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (tailors.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="no-records">
                            <i class="fas fa-user-tie"></i>
                            <h3>No Tailors Found</h3>
                            <p>No tailors registered yet.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> tailor : tailors) { 
                            String status = (String) tailor.get("status");
                            String statusClass = "status-" + status.toLowerCase();
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) tailor.get("created_at");
                            String createdDate = createdAt != null ? shortFormat.format(createdAt) : "";
                            Integer verifiedInt = (Integer) tailor.get("verified");
                            int verified = verifiedInt != null ? verifiedInt : 0;
                    %>
                    <tr>
                        <td><%= tailor.get("id") %></td>
                        <td><%= tailor.get("name") %></td>
                        <td><%= tailor.get("phone") %></td>
                        <td><%= tailor.get("email") %></td>
                        <td><%= tailor.get("specialty") %></td>
                        <td><%= tailor.get("experience") %> years</td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td>
                            <% if (verified == 1) { %>
                                <span class="status-badge status-approved">VERIFIED</span>
                            <% } else { %>
                                <span class="status-badge status-pending">NOT VERIFIED</span>
                            <% } %>
                        </td>
                        <td><%= createdDate %></td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="users" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-users"></i> Users Management (<%= totalUsers %>)
            </h2>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Password Hash</th>
                        <th>Created At</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users.isEmpty()) { %>
                    <tr>
                        <td colspan="5" class="no-records">
                            <i class="fas fa-users"></i>
                            <h3>No Users Found</h3>
                            <p>No users registered yet.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> user : users) { 
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) user.get("created_at");
                            String createdDate = createdAt != null ? dateFormat.format(createdAt) : "";
                            String password = (String) user.get("password");
                            String passwordPreview = password != null && password.length() > 15 ? 
                                password.substring(0, 15) + "..." : password;
                    %>
                    <tr>
                        <td><%= user.get("id") %></td>
                        <td><%= user.get("username") %></td>
                        <td><%= user.get("email") %></td>
                        <td>
                            <span title="<%= password %>" style="font-family: monospace; background: rgba(255,255,255,0.1); padding: 2px 6px; border-radius: 4px;">
                                <%= passwordPreview %>
                            </span>
                        </td>
                        <td><%= createdDate %></td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="suits" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-suitcase"></i> Suit Requests (<%= totalSuits %>)
            </h2>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Request ID</th>
                        <th>Garment</th>
                        <th>Customer</th>
                        <th>Phone</th>
                        <th>Tailor</th>
                        <th>Deadline</th>
                        <th>Status</th>
                        <th>Created</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (suits.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="no-records">
                            <i class="fas fa-suitcase"></i>
                            <h3>No Suit Requests Found</h3>
                            <p>No suit tailoring requests yet.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> suit : suits) { 
                            String status = (String) suit.get("status");
                            String statusClass = "status-" + status.toLowerCase();
                            java.sql.Date deadline = (java.sql.Date) suit.get("deadline");
                            String deadlineStr = deadline != null ? shortFormat.format(deadline) : "Not set";
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) suit.get("created_at");
                            String createdDate = createdAt != null ? shortFormat.format(createdAt) : "";
                    %>
                    <tr>
                        <td><%= suit.get("id") %></td>
                        <td><%= suit.get("request_id") %></td>
                        <td><%= suit.get("garment") %></td>
                        <td><%= suit.get("customer_name") %></td>
                        <td><%= suit.get("customer_phone") %></td>
                        <td><%= suit.get("tailor_name") %></td>
                        <td><%= deadlineStr %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= createdDate %></td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="alterations" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-cut"></i> Alteration Requests (<%= totalAlterations %>)
            </h2>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Request ID</th>
                        <th>Garment</th>
                        <th>Alteration Type</th>
                        <th>Customer</th>
                        <th>Phone</th>
                        <th>Tailor</th>
                        <th>Status</th>
                        <th>Created</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (alterations.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="no-records">
                            <i class="fas fa-cut"></i>
                            <h3>No Alteration Requests Found</h3>
                            <p>No alteration requests yet.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> alteration : alterations) { 
                            String status = (String) alteration.get("status");
                            String statusClass = "status-" + status.toLowerCase();
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) alteration.get("created_at");
                            String createdDate = createdAt != null ? shortFormat.format(createdAt) : "";
                    %>
                    <tr>
                        <td><%= alteration.get("id") %></td>
                        <td><%= alteration.get("request_id") %></td>
                        <td><%= alteration.get("garment") %></td>
                        <td><%= alteration.get("alteration_type") %></td>
                        <td><%= alteration.get("customer_name") %></td>
                        <td><%= alteration.get("customer_phone") %></td>
                        <td><%= alteration.get("tailor_name") %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= createdDate %></td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="orders" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-shopping-cart"></i> Orders Management (<%= totalOrders %>)
            </h2>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Phone</th>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th>Approval Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="no-records">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>No Orders Found</h3>
                            <p>No product orders yet.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> order : orders) { 
                            String status = (String) order.get("status");
                            String statusClass = "status-" + status.toLowerCase();
                            java.sql.Timestamp approvalDate = (java.sql.Timestamp) order.get("approval_date");
                            String approvalDateStr = approvalDate != null ? shortFormat.format(approvalDate) : "Not approved";
                    %>
                    <tr>
                        <td><%= order.get("id") %></td>
                        <td><%= order.get("order_id") %></td>
                        <td><%= order.get("name") %></td>
                        <td><%= order.get("phone") %></td>
                        <td><%= order.get("product_name") %></td>
                        <td>₹<%= order.get("price") %></td>
                        <td><%= order.get("payment_method") %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= approvalDateStr %></td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="reviews" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-star"></i> Customer Reviews (<%= totalReviews %>)
            </h2>
        </div>
        
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Review</th>
                        <th>Created</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (reviews.isEmpty()) { %>
                    <tr>
                        <td colspan="4" class="no-records">
                            <i class="fas fa-star"></i>
                            <h3>No Reviews Found</h3>
                            <p>No customer reviews yet.</p>
                        </td>
                    </tr>
                    <% } else { 
                        for (Map<String, Object> review : reviews) { 
                            java.sql.Timestamp createdAt = (java.sql.Timestamp) review.get("created_at");
                            String createdDate = createdAt != null ? dateFormat.format(createdAt) : "";
                            String reviewText = (String) review.get("review");
                            String reviewPreview = reviewText != null && reviewText.length() > 100 ? 
                                reviewText.substring(0, 100) + "..." : reviewText;
                    %>
                    <tr>
                        <td><%= review.get("id") %></td>
                        <td><%= review.get("name") %></td>
                        <td>
                            <div style="max-width: 400px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" 
                                 title="<%= reviewText %>">
                                <%= reviewPreview %>
                            </div>
                        </td>
                        <td><%= createdDate %></td>
                    </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
    </section>

</div>

<div id="addAdminModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-user-plus"></i> Add New Admin</h3>
            <button class="close-modal" onclick="closeModal('addAdminModal')">&times;</button>
        </div>
        <div class="modal-body">
            <form id="addAdminForm" onsubmit="addNewAdmin(event)">
                <div class="form-group">
                    <label for="adminName">Full Name</label>
                    <input type="text" id="adminName" class="form-control" required 
                           placeholder="Enter admin's full name">
                </div>
                
                <div class="form-group">
                    <label for="adminEmail">Email Address</label>
                    <input type="email" id="adminEmail" class="form-control" required 
                           placeholder="Enter admin's email address">
                </div>
                
                <div class="form-group">
                    <label for="adminPassword">Password</label>
                    <input type="password" id="adminPassword" class="form-control" required 
                           placeholder="Enter a strong password" 
                           onkeyup="checkPasswordStrength(this.value)">
                    <div class="password-strength">
                        <div id="passwordStrengthFill" class="password-strength-fill"></div>
                    </div>
                    <small style="color: #94a3b8; display: block; margin-top: 5px;">
                        Password must be at least 8 characters with uppercase, lowercase, numbers, and special characters
                    </small>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" class="form-control" required 
                           placeholder="Confirm the password">
                    <div id="passwordMatch" style="color: #ef4444; font-size: 0.9rem; margin-top: 5px; display: none;">
                        Passwords do not match!
                    </div>
                </div>
                
                <button type="submit" class="btn btn-success" style="width: 100%; padding: 12px;">
                    <i class="fas fa-user-plus"></i> Create Admin Account
                </button>
            </form>
        </div>
    </div>
</div>

<div id="editManagerModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-user-edit"></i> Edit Manager Details</h3>
            <button class="close-modal" onclick="closeModal('editManagerModal')">&times;</button>
        </div>
        <div class="modal-body">
            <form id="editManagerForm" onsubmit="updateManagerDetails(event)">
                <input type="hidden" id="managerId" value="<%= managerId %>">
                
                <div class="form-group">
                    <label for="editName">Full Name</label>
                    <input type="text" id="editName" class="form-control" required 
                           value="<%= managerName %>"
                           placeholder="Enter your full name">
                </div>
                
                <div class="form-group">
                    <label for="editEmail">Email Address (Cannot be changed)</label>
                    <input type="email" id="editEmail" class="form-control" 
                           value="<%= managerEmail %>" readonly
                           style="background: rgba(255,255,255,0.1); cursor: not-allowed;">
                </div>
                
                <div class="form-group">
                    <label for="editPassword">New Password (Optional)</label>
                    <input type="password" id="editPassword" class="form-control" 
                           placeholder="Enter new password (optional)">
                </div>
                
                <button type="submit" class="btn btn-success" style="width: 100%; padding: 12px;">
                    <i class="fas fa-save"></i> Update Details
                </button>
            </form>
        </div>
    </div>
</div>

<div id="confirmTruncateModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-exclamation-triangle"></i> Confirm Action</h3>
            <button class="close-modal" onclick="closeModal('confirmTruncateModal')">&times;</button>
        </div>
        <div class="modal-body">
            <p style="color: #fbbf24; font-size: 1.1rem; margin-bottom: 20px;">
                <i class="fas fa-exclamation-circle"></i> WARNING: This action cannot be undone!
            </p>
            <p>Are you sure you want to truncate the entire admin_users table? This will delete ALL admin accounts.</p>
            
            <div style="display: flex; gap: 10px; margin-top: 25px;">
                <button class="btn btn-danger" style="flex: 1;" onclick="truncateAdmins()">
                    <i class="fas fa-trash"></i> Yes, Truncate All
                </button>
                <button class="btn btn-primary" style="flex: 1;" onclick="closeModal('confirmTruncateModal')">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        </div>
    </div>
</div>

<div id="loading" class="loading">
    <div class="spinner"></div>
    <p style="color: var(--primary); font-size: 1.1rem;">Processing...</p>
</div>

<script>

function showSection(sectionId, clickedButton) {
    
    var sections = document.querySelectorAll('.section');
    sections.forEach(function(section) {
        section.classList.remove('active');
    });
    
    var tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach(function(tab) {
        tab.classList.remove('active');
    });
    
    document.getElementById(sectionId).classList.add('active');
    
    if (clickedButton) {
        clickedButton.classList.add('active');
    }
    
    document.getElementById(sectionId).scrollIntoView({behavior: 'smooth'});
}

function openModal(modalId) {
    document.getElementById(modalId).style.display = 'flex';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

function openAddAdminModal() {
    document.getElementById('addAdminModal').style.display = 'flex';
    
    document.getElementById('addAdminForm').reset();
    document.getElementById('passwordMatch').style.display = 'none';
    document.getElementById('passwordStrengthFill').style.width = '0%';
    document.getElementById('passwordStrengthFill').className = 'password-strength-fill';
}

function openEditManagerModal() {
    document.getElementById('editManagerModal').style.display = 'flex';
    
    document.getElementById('editPassword').value = '';
}

function confirmTruncateAdmins() {
    document.getElementById('confirmTruncateModal').style.display = 'flex';
}

function checkPasswordStrength(password) {
    const strengthBar = document.getElementById('passwordStrengthFill');
    let strength = 0;
    
    if (password.length >= 8) strength += 25;
    if (/[A-Z]/.test(password)) strength += 25;
    if (/[0-9]/.test(password)) strength += 25;
    if (/[^A-Za-z0-9]/.test(password)) strength += 25;
    
    strengthBar.style.width = strength + '%';
    
    if (strength < 50) {
        strengthBar.className = 'password-strength-fill strength-weak';
    } else if (strength < 75) {
        strengthBar.className = 'password-strength-fill strength-medium';
    } else {
        strengthBar.className = 'password-strength-fill strength-strong';
    }
}

function addNewAdmin(event) {
    event.preventDefault();
    
    const name = document.getElementById('adminName').value;
    const email = document.getElementById('adminEmail').value;
    const password = document.getElementById('adminPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    if (password !== confirmPassword) {
        document.getElementById('passwordMatch').style.display = 'block';
        return;
    }
    
    document.getElementById('passwordMatch').style.display = 'none';
    
    const adminKey = Math.floor(10000 + Math.random() * 90000).toString();
    
    document.getElementById('loading').style.display = 'flex';
    
    const formData = new FormData();
    formData.append('action', 'addAdmin');
    formData.append('manager_id', '<%= managerId %>');
    formData.append('name', name);
    formData.append('email', email);
    formData.append('password', password);
    formData.append('admin_key', adminKey);
    
    fetch('ManagerServlet', {
        method: 'POST',
        body: formData
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        document.getElementById('loading').style.display = 'none';
        
        if (data.success) {
            showNotification('Admin created successfully! Admin Key: ' + adminKey, 'success');
            closeModal('addAdminModal');
            
            setTimeout(function() {
                location.reload();
            }, 1500);
        } else {
            showNotification(data.message, 'error');
        }
    })
    .catch(function(error) {
        document.getElementById('loading').style.display = 'none';
        showNotification('Error creating admin: ' + error.message, 'error');
    });
}

function deleteAdmin(adminId, button) {
    if (!confirm('Are you sure you want to delete this admin?')) {
        return;
    }
    
    button.disabled = true;
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
    
    const formData = new FormData();
    formData.append('action', 'deleteAdmin');
    formData.append('manager_id', '<%= managerId %>');
    formData.append('admin_id', adminId);
    
    fetch('ManagerServlet', {
        method: 'POST',
        body: formData
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            showNotification(data.message, 'success');
          
            const row = document.getElementById('admin-row-' + adminId);
            if (row) {
                row.style.transition = 'all 0.3s ease';
                row.style.opacity = '0';
                row.style.transform = 'translateX(-100%)';
                setTimeout(function() {
                    row.remove();
                   
                    const adminTab = document.querySelector('.tab-btn:nth-child(2)');
                    if (adminTab) {
                        const match = adminTab.textContent.match(/\((\d+)\)/);
                        if (match) {
                            const currentCount = parseInt(match[1]);
                            adminTab.innerHTML = '<i class="fas fa-user-shield"></i> Admins (' + (currentCount - 1) + ')';
                        }
                    }
                }, 300);
            }
        } else {
            showNotification(data.message, 'error');
            button.disabled = false;
            button.innerHTML = '<i class="fas fa-trash"></i> Delete';
        }
    })
    .catch(function(error) {
        showNotification('Error deleting admin: ' + error.message, 'error');
        button.disabled = false;
        button.innerHTML = '<i class="fas fa-trash"></i> Delete';
    });
}

function truncateAdmins() {
    closeModal('confirmTruncateModal');
    document.getElementById('loading').style.display = 'flex';
    
    const formData = new FormData();
    formData.append('action', 'truncateAdmins');
    formData.append('manager_id', '<%= managerId %>');
    
    fetch('ManagerServlet', {
        method: 'POST',
        body: formData
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        document.getElementById('loading').style.display = 'none';
        
        if (data.success) {
            showNotification(data.message, 'success');
           
            setTimeout(function() {
                location.reload();
            }, 1500);
        } else {
            showNotification(data.message, 'error');
        }
    })
    .catch(function(error) {
        document.getElementById('loading').style.display = 'none';
        showNotification('Error truncating admins: ' + error.message, 'error');
    });
}

function updateManagerDetails(event) {
    event.preventDefault();
    
    const managerId = document.getElementById('managerId').value;
    const name = document.getElementById('editName').value;
    const password = document.getElementById('editPassword').value;
    
    document.getElementById('loading').style.display = 'flex';
    
    const formData = new FormData();
    formData.append('action', 'updateManager');
    formData.append('manager_id', managerId);
    formData.append('name', name);
    if (password && password.trim() !== '') {
        formData.append('password', password);
    }
    
    fetch('ManagerServlet', {
        method: 'POST',
        body: formData
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        document.getElementById('loading').style.display = 'none';
        
        if (data.success) {
            showNotification(data.message, 'success');
            closeModal('editManagerModal');
            
            setTimeout(function() {
                location.reload();
            }, 1500);
        } else {
            showNotification(data.message, 'error');
        }
    })
    .catch(function(error) {
        document.getElementById('loading').style.display = 'none';
        showNotification('Error updating details: ' + error.message, 'error');
    });
}

function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = 'notification ' + type;
    
    let iconClass;
    if (type === 'success') {
        iconClass = 'check-circle';
    } else if (type === 'error') {
        iconClass = 'exclamation-circle';
    } else {
        iconClass = 'info-circle';
    }
    
    notification.innerHTML = 
        '<i class="fas fa-' + iconClass + '"></i> ' + 
        message;
    
    document.body.appendChild(notification);
    
    setTimeout(function() {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(function() {
            document.body.removeChild(notification);
        }, 300);
    }, 5000);
}

document.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
});

var confirmPasswordInput = document.getElementById('confirmPassword');
if (confirmPasswordInput) {
    confirmPasswordInput.addEventListener('input', function() {
        const password = document.getElementById('adminPassword').value;
        const confirmPassword = this.value;
        const matchDiv = document.getElementById('passwordMatch');
        
        if (password && confirmPassword && password !== confirmPassword) {
            matchDiv.style.display = 'block';
        } else {
            matchDiv.style.display = 'none';
        }
    });
}
</script>

</body>
</html>