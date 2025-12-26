<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>

<%
String adminName = (String) session.getAttribute("adminName");
String adminEmail = (String) session.getAttribute("adminEmail");
Integer adminIdInt = (Integer) session.getAttribute("adminId");
String adminId = adminIdInt != null ? adminIdInt.toString() : "";

if (adminName == null || adminEmail == null) {
    response.sendRedirect("unifiedLogin.jsp");
    return;
}

Connection conTailor = null;
Connection conShop = null;
PreparedStatement ps = null;
ResultSet rs = null;

List<Map<String, Object>> suitRequests = new ArrayList<>();
List<Map<String, Object>> alterationRequests = new ArrayList<>();
List<Map<String, Object>> tailors = new ArrayList<>();
List<Map<String, Object>> orders = new ArrayList<>();
List<Map<String, Object>> users = new ArrayList<>();
List<Map<String, Object>> reviews = new ArrayList<>();

int suitCount = 0, alterationCount = 0, tailorsCount = 0, ordersCount = 0, usersCount = 0, reviewsCount = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conTailor = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_db", "root", "12345");
    conShop = DriverManager.getConnection("jdbc:mysql://localhost:3306/tailor_shop", "root", "12345");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    SimpleDateFormat shortFormat = new SimpleDateFormat("yyyy-MM-dd");
    
    String sql = "SELECT * FROM suit_requests ORDER BY created_at DESC";
    ps = conTailor.prepareStatement(sql);
    rs = ps.executeQuery();
    while(rs.next()) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", rs.getInt("id"));
        row.put("request_id", rs.getString("request_id"));
        row.put("garment", rs.getString("garment"));
        row.put("slai", rs.getString("slai"));
        row.put("deadline", rs.getDate("deadline"));
        row.put("customer_name", rs.getString("customer_name"));
        row.put("customer_phone", rs.getString("customer_phone"));
        row.put("customer_whatsapp", rs.getString("customer_whatsapp"));
        row.put("customer_address", rs.getString("customer_address"));
        row.put("tailor_name", rs.getString("tailor_name"));
        row.put("cloth_image", rs.getString("cloth_image"));
        row.put("client_image", rs.getString("client_image"));
        row.put("measurements", rs.getString("measurements"));
        row.put("additional_notes", rs.getString("additional_notes"));
        row.put("status", rs.getString("status") != null ? rs.getString("status") : "pending");
        row.put("created_at", rs.getTimestamp("created_at"));
        row.put("approval_date", rs.getTimestamp("approval_date"));
        suitRequests.add(row);
    }
    suitCount = suitRequests.size();
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
        row.put("deadline", rs.getDate("deadline"));
        row.put("customer_name", rs.getString("customer_name"));
        row.put("customer_phone", rs.getString("customer_phone"));
        row.put("customer_whatsapp", rs.getString("customer_whatsapp"));
        row.put("customer_address", rs.getString("customer_address"));
        row.put("tailor_name", rs.getString("tailor_name"));
        row.put("cloth_image", rs.getString("cloth_image"));
        row.put("additional_notes", rs.getString("additional_notes"));
        row.put("status", rs.getString("status") != null ? rs.getString("status") : "pending");
        row.put("created_at", rs.getTimestamp("created_at"));
        row.put("approval_date", rs.getTimestamp("approval_date"));
        alterationRequests.add(row);
    }
    alterationCount = alterationRequests.size();
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
        row.put("address", rs.getString("address"));
        row.put("specialty", rs.getString("specialty"));
        row.put("experience", rs.getInt("experience"));
        row.put("picture_path", rs.getString("picture_path"));
        row.put("username", rs.getString("username"));
        row.put("verified", rs.getInt("verified"));
        row.put("status", rs.getString("status") != null ? rs.getString("status") : "pending");
        row.put("created_at", rs.getTimestamp("created_at"));
        row.put("approval_time", rs.getTimestamp("approval_time"));
        tailors.add(row);
    }
    tailorsCount = tailors.size();
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
    usersCount = users.size();
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
        row.put("address", rs.getString("address"));
        row.put("product_name", rs.getString("product_name"));
        row.put("price", rs.getDouble("price"));
        row.put("payment_method", rs.getString("payment_method"));
        row.put("order_id", rs.getString("order_id"));
        row.put("status", rs.getString("status") != null ? rs.getString("status") : "pending");
        row.put("approval_date", rs.getTimestamp("approval_date"));
        orders.add(row);
    }
    ordersCount = orders.size();
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
    reviewsCount = reviews.size();
    rs.close();
    ps.close();
    
}
catch(Exception e) {
    e.printStackTrace();
    out.println("<script>alert('Database data Fetching error: " + e.getMessage() + "');</script>");
} 
finally {
    if (rs != null) try { rs.close(); } catch(SQLException e) {}
    if (ps != null) try { ps.close(); } catch(SQLException e) {}
    if (conTailor != null) try { conTailor.close(); } catch(SQLException e) {}
    if (conShop != null) try { conShop.close(); } catch(SQLException e) {}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary: #2563eb;
            --secondary: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #3b82f6;
            --dark: #0f172a;
            --darker: #020617;
            --light: #e5e7eb;
            --card-bg: #1e293b;
            --header-bg: #020617;
              }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--dark);
            color: var(--light);
            line-height: 1.6;
            }

        .admin-header {
            background: linear-gradient(135deg, var(--header-bg), #1e293b);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(37, 99, 235, 0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
            }

        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .admin-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--primary);
            font-size: 1.8rem;
            font-weight: bold;
        }

        .admin-logo i {
            font-size: 2rem;
            color: var(--secondary);
        }

        .admin-info {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 20px;
            background: rgba(37, 99, 235, 0.1);
            border-radius: 10px;
            border: 1px solid var(--primary);
        }

        .admin-details h3 {
            color: var(--light);
            margin-bottom: 5px;
            font-size: 1.2rem;
        }

        .admin-details p {
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
            box-shadow: 0 0 15px rgba(37, 99, 235, 0.4);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
            box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);
        }

        .btn-warning {
            background: var(--warning);
            color: var(--dark);
            box-shadow: 0 0 15px rgba(245, 158, 11, 0.4);
        }

        .btn-info {
            background: var(--info);
            color: white;
            box-shadow: 0 0 15px rgba(59, 130, 246, 0.4);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px currentColor;
        }

        .nav-tabs {
            background: var(--header-bg);
            padding: 15px 30px;
            display: flex;
            gap: 10px;
            overflow-x: auto;
            scrollbar-width: none;
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

        .tab-btn:hover {
            background: var(--primary);
            color: white;
            box-shadow: 0 0 20px var(--primary);
        }

        .tab-btn.active {
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
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.1);
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
            background: var(--card-bg);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
            cursor: pointer;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.2);
        }

        .stat-card i {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary);
            margin: 10px 0;
        }

        .stat-label {
            color: var(--light);
            opacity: 0.8;
        }

        .table-responsive {
            overflow-x: auto;
            border-radius: 10px;
            background: rgba(2, 6, 23, 0.5);
        }

        .table-container {
            width: 100%;
            border-collapse: collapse;
        }

        .table-container th {
            background: var(--darker);
            color: var(--primary);
            padding: 12px 10px;
            text-align: left;
            font-weight: bold;
            border-bottom: 2px solid var(--primary);
            position: sticky;
            top: 0;
            font-size: 0.9rem;
        }

        .table-container td {
            padding: 10px;
            border-bottom: 1px solid rgba(37, 99, 235, 0.1);
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .table-container tbody tr:hover {
            background: rgba(37, 99, 235, 0.05);
        }

        .status-badge {
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }

        .status-pending { background: rgba(245, 158, 11, 0.2); color: var(--warning); }
        .status-approved { background: rgba(16, 185, 129, 0.2); color: var(--secondary); }
        .status-complete { background: rgba(255, 250, 180, 0.1); color:white; }
        .status-rejected { background: rgba(239, 68, 68, 0.2); color: var(--danger); }
        .status-processing { background: rgba(59, 130, 246, 0.2); color: var(--info); }
        .status-dispatched { background: rgba(147, 51, 234, 0.2); color: #9333ea; }
        .status-delivered { background: rgba(34, 197, 94, 0.2); color: #22c55e; }
        .status-hold { background: rgba(156, 163, 175, 0.2); color: #9ca3af; }
        .status-active { background: rgba(16, 185, 129, 0.2); color: var(--secondary); }
        .status-inactive { background: rgba(156, 163, 175, 0.2); color: #9ca3af; }

        .action-group {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            font-size: 0.8rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .action-btn i { font-size: 0.8rem; }

        .btn-approve { background: rgba(16, 185, 129, 0.2); color: var(--secondary); }
        .btn-reject { background: rgba(239, 68, 68, 0.2); color: var(--danger); }
        .btn-delete { background: rgba(245, 158, 11, 0.2); color: var(--warning); }
        .btn-process { background: rgba(59, 130, 246, 0.2); color: var(--info); }
        .btn-dispatch { background: rgba(147, 51, 234, 0.2); color: #9333ea; }
        .btn-deliver { background: rgba(34, 197, 94, 0.2); color: #22c55e; }
        .btn-reset { background: rgba(156, 163, 175, 0.2); color: #9ca3af; }
        .btn-edit { background: rgba(59, 130, 246, 0.2); color: #3b82f6; }
        .btn-hold { background: rgba(251, 191, 36, 0.2); color: #fbbf24; }
        .btn-view { background: rgba(139, 92, 246, 0.2); color: #8b5cf6; }

        .action-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 0 8px currentColor;
        }
        
.status-delivered ~ .action-group .action-btn:not(.btn-reset):not(.btn-view) {
    display: none !important;
}

.status-delivered ~ .action-group .action-btn:not(.btn-reset):not(.btn-view) {
    opacity: 0.5;
    cursor: not-allowed;
    pointer-events: none;
}

        .image-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            border: 2px solid var(--primary);
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .image-preview:hover {
            transform: scale(1.8);
            z-index: 100;
            position: relative;
        }

        .text-preview {
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .text-preview:hover {
            white-space: normal;
            overflow: visible;
            position: relative;
            z-index: 10;
            background: var(--card-bg);
            padding: 5px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
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
            max-width: 800px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 0 50px var(--primary);
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
        }

        .modal-body {
            margin-bottom: 20px;
        }

        .loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.9);
            z-index: 9999;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .spinner {
            border: 4px solid rgba(37, 99, 235, 0.2);
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
            background: linear-gradient(135deg, var(--secondary), var(--primary));
        }

        .notification.error {
            background: linear-gradient(135deg, var(--danger), #ff758f);
        }

        .notification.info {
            background: linear-gradient(135deg, var(--info), #6c8eff);
        }

        .notification.warning {
            background: linear-gradient(135deg, var(--warning), #ffeb3b);
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
            .admin-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .header-left, .header-right {
                width: 100%;
                justify-content: center;
            }

            .nav-tabs {
                flex-wrap: wrap;
            }
        }

        @media (max-width: 768px) {
            .dashboard-container {
                padding: 10px;
            }

            .section {
                padding: 15px;
            }

            .table-container th,
            .table-container td {
                padding: 6px 4px;
                font-size: 0.8rem;
            }

            .action-group {
                flex-direction: column;
            }

            .btn {
                padding: 8px 12px;
                font-size: 0.85rem;
            }
            
            .action-btn {
                padding: 4px 8px;
                font-size: 0.75rem;
            }
            
            .status-badge {
                font-size: 0.7rem;
                padding: 3px 8px;
                min-width: 70px;
            }
            
            .image-preview {
                width: 50px;
                height: 50px;
            }
        }
    </style>
</head>
<body>

<header class="admin-header">
    <div class="header-left">
        <div class="admin-logo">
            <i class="fas fa-user-shield"></i>
            <span>Tailor Pro Admin</span>
        </div>
    </div>

    <div class="admin-info">
        <div class="admin-details">
            <h3><%= adminName %></h3>
            <p><%= adminEmail %></p>
        </div>
        <button class="btn btn-edit" onclick="openAdminEditModal()">
            <i class="fas fa-edit"></i> Edit
        </button>
    </div>

    <div class="header-right">
        <button class="btn btn-warning" onclick="testAction()">
            <i class="fas fa-bug"></i> Test Action
        </button>
        <a href="adminLogout.jsp" class="btn btn-danger">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>

<nav class="nav-tabs">
    <button class="tab-btn active" onclick="showSection('dashboard', this)">
        <i class="fas fa-tachometer-alt"></i> Dashboard
    </button>
    <button class="tab-btn" onclick="showSection('suit-requests', this)">
        <i class="fas fa-suitcase"></i> Suit Requests (<%= suitCount %>)
    </button>
    <button class="tab-btn" onclick="showSection('alteration-requests', this)">
        <i class="fas fa-cut"></i> Alterations (<%= alterationCount %>)
    </button>
    <button class="tab-btn" onclick="showSection('tailors', this)">
        <i class="fas fa-user-tie"></i> Tailors (<%= tailorsCount %>)
    </button>
    <button class="tab-btn" onclick="showSection('orders', this)">
        <i class="fas fa-shopping-cart"></i> Orders (<%= ordersCount %>)
    </button>
    <button class="tab-btn" onclick="showSection('users', this)">
        <i class="fas fa-users"></i> Users (<%= usersCount %>)
    </button>
    <button class="tab-btn" onclick="showSection('reviews', this)">
        <i class="fas fa-star"></i> Reviews (<%= reviewsCount %>)
    </button>
</nav>

<div class="dashboard-container">

    <div class="stats-grid" id="dashboard-stats">
        <div class="stat-card" onclick="showSection('suit-requests', document.querySelectorAll('.tab-btn')[1])">
            <i class="fas fa-suitcase" style="color: var(--primary);"></i>
            <div class="stat-number"><%= suitCount %></div>
            <div class="stat-label">Suit Requests</div>
        </div>
        <div class="stat-card" onclick="showSection('alteration-requests', document.querySelectorAll('.tab-btn')[2])">
            <i class="fas fa-cut" style="color: var(--secondary);"></i>
            <div class="stat-number"><%= alterationCount %></div>
            <div class="stat-label">Alterations</div>
        </div>
        <div class="stat-card" onclick="showSection('tailors', document.querySelectorAll('.tab-btn')[3])">
            <i class="fas fa-user-tie" style="color: var(--info);"></i>
            <div class="stat-number"><%= tailorsCount %></div>
            <div class="stat-label">Tailors</div>
        </div>
        <div class="stat-card" onclick="showSection('orders', document.querySelectorAll('.tab-btn')[4])">
            <i class="fas fa-shopping-cart" style="color: var(--warning);"></i>
            <div class="stat-number"><%= ordersCount %></div>
            <div class="stat-label">Orders</div>
        </div>
        <div class="stat-card" onclick="showSection('users', document.querySelectorAll('.tab-btn')[5])">
            <i class="fas fa-users" style="color: #ff6b8b;"></i>
            <div class="stat-number"><%= usersCount %></div>
            <div class="stat-label">Users</div>
        </div>
        <div class="stat-card" onclick="showSection('reviews', document.querySelectorAll('.tab-btn')[6])">
            <i class="fas fa-star" style="color: #ffd93d;"></i>
            <div class="stat-number"><%= reviewsCount %></div>
            <div class="stat-label">Reviews</div>
        </div>
    </div>

    <section id="dashboard" class="section active">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-tachometer-alt"></i> Dashboard Overview
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshDashboard()">
                    <i class="fas fa-sync-alt"></i> Refresh All Data
                </button>
            </div>
        </div>
        <div class="table-responsive">
            <div style="padding: 20px; text-align: center;">
                <h3 style="color: var(--primary); margin-bottom: 15px;">Welcome, <%= adminName %>!</h3>
                <p style="margin-bottom: 20px;">You are currently managing <%= suitCount + alterationCount + tailorsCount + ordersCount + usersCount + reviewsCount %> total records across all sections.</p>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 30px;">
                    <div style="background: rgba(37, 99, 235, 0.1); padding: 15px; border-radius: 10px;">
                        <h4 style="color: var(--secondary); margin-bottom: 10px;"><i class="fas fa-database"></i> Database Connections</h4>
                        <p><strong>tailor_db:</strong> Suits, Alterations, Tailors, Users</p>
                        <p><strong>tailor_shop:</strong> Orders, Reviews</p>
                    </div>
                    
                    <div style="background: rgba(16, 185, 129, 0.1); padding: 15px; border-radius: 10px;">
                        <h4 style="color: var(--secondary); margin-bottom: 10px;"><i class="fas fa-cogs"></i> Quick Actions</h4>
                        <p> Click stat cards to navigate</p>
                        <p> Use action buttons in tables</p>
                        <p> Refresh data with button above</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="suit-requests" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-suitcase"></i> Suit Tailoring Requests (<%= suitCount %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshSection('suit')">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button class="btn btn-danger" onclick="deleteAllRecords('suit_requests', 'tailor_db', 'suit')">
                    <i class="fas fa-trash"></i> Delete All
                </button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Request ID</th>
                        <th>Garment</th>
                        <th>Slai</th>
                        <th>Customer</th>
                        <th>Phone</th>
                        <th>Tailor</th>
                        <th>Deadline</th>
                        <th>Image</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Approval Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> suitRequest : suitRequests) { 
                        String clothImage = (String) suitRequest.get("cloth_image");
                        String clientImage = (String) suitRequest.get("client_image");
                        String status = (String) suitRequest.get("status");
                        String statusClass = "status-" + status.toLowerCase();
                        java.sql.Date deadline = (java.sql.Date) suitRequest.get("deadline");
                        Timestamp approvalDate = (Timestamp) suitRequest.get("approval_date");
                        Timestamp createdAt = (Timestamp) suitRequest.get("created_at");
                    %>
                    <tr id="suit-row-<%= suitRequest.get("id") %>">
                        <td><%= suitRequest.get("id") %></td>
                        <td><%= suitRequest.get("request_id") %></td>
                        <td><%= suitRequest.get("garment") %></td>
                        <td class="text-preview"><%= suitRequest.get("slai") != null ? suitRequest.get("slai") : "" %></td>
                        <td><%= suitRequest.get("customer_name") %></td>
                        <td><%= suitRequest.get("customer_phone") %></td>
                        <td><%= suitRequest.get("tailor_name") %></td>
                        <td><%= deadline != null ? deadline : "Not set" %></td>
                        <td>
                            <% if (clothImage != null && !clothImage.isEmpty()) { %>
                            <img src="uploads/custom_tailor/clothPicture/<%= clothImage %>" 
                                 class="image-preview" 
                                 onclick="showImage(this.src)"
                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHJ4PSI2IiBmaWxsPSIjMWUyOTNiIi8+PHBhdGggZD0iTTIwIDIwSDQwVjQwSDIwVjIwWiIgZmlsbD0iIzI1NjNlYiIvPjwvc3ZnPg=='">
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:0.8rem;">No Image</span>
                            <% } %>
                        </td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= createdAt != null ? new SimpleDateFormat("MMM dd, yyyy").format(createdAt) : "" %></td>
                        <td><%= approvalDate != null ? new SimpleDateFormat("MMM dd, yyyy").format(approvalDate) : "Not approved" %></td>
                        
 <td>
 <div class="action-group">
    <% if ("complete".equals(status)) { %>                               
    <button class="action-btn btn-process" onclick="updateStatus(<%= suitRequest.get("id") %>, 'suit_requests', 'processing', 'tailor_db')">
    <i class="fas fa-cog"></i> Process
    </button>
     <button class="action-btn btn-view" onclick="viewDetails(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
    <i class="fas fa-eye"></i> View
    </button>
                              
   <% } else if ("processing".equals(status)) { %>
   <button class="action-btn btn-dispatch" onclick="updateStatus(<%= suitRequest.get("id") %>, 'suit_requests', 'dispatched', 'tailor_db')">
   <i class="fas fa-shipping-fast"></i> Dispatch
   </button>
    <button class="action-btn btn-delete" onclick="deleteRecord(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-trash"></i> Delete
   </button>

   <button class="action-btn btn-hold" onclick="updateStatus(<%= suitRequest.get("id") %>, 'suit_requests','hold', 'tailor_db')">
   <i class="fas fa-pause"></i> Hold
   </button>
     <button class="action-btn btn-view" onclick="viewDetails(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-eye"></i> View
   </button>
                                
   <% } else if ("dispatched".equals(status)) { %>
   <button class="action-btn btn-deliver" onclick="updateStatus(<%= suitRequest.get("id") %>, 'suit_requests', 'delivered', 'tailor_db')">
   <i class="fas fa-check-circle"></i> Deliver
   </button>
      <button class="action-btn btn-reset" onclick="resetStatus(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-undo"></i> Reset
   </button>
                                                        
   <%} else if ("hold".equals(status)) { %>
   <button class="action-btn btn-reset" onclick="resetStatus(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-undo"></i> Reset
   </button>
    <% } else if ("delivered".equals(status)) { %>
       <button class="action-btn btn-view" onclick="viewDetails(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-eye"></i> View
   </button>
    <button class="action-btn btn-reset" onclick="resetStatus(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-undo"></i> Reset
     </button>
       <button class="action-btn btn-delete" onclick="deleteRecord(<%= suitRequest.get("id") %>, 'suit_requests', 'tailor_db')">
   <i class="fas fa-trash"></i> Delete
   </button>
 
   <% } %>
                                
   </div>
    </td>
       </tr>
          <% } %>
          
                    <% if (suitRequests.isEmpty()) { %>
                    <tr>
                        <td colspan="13" style="text-align: center; padding: 20px;">
                            <i class="fas fa-suitcase" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>No suit requests found</p>
                        </td>
                    </tr>
                    <% } %>
                    
                </tbody>
            </table>
        </div>
    </section>

    <section id="alteration-requests" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-cut"></i> Alteration Requests (<%= alterationCount %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshSection('alteration')">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button class="btn btn-danger" onclick="deleteAllRecords('alteration_requests', 'tailor_db', 'alteration')">
                    <i class="fas fa-trash"></i> Delete All
                </button>
            </div>
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
                        <th>Deadline</th>
                        <th>Image</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Approval Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> alterationRequest : alterationRequests) { 
                        String clothImage = (String) alterationRequest.get("cloth_image");
                        String status = (String) alterationRequest.get("status");
                        String statusClass = "status-" + status.toLowerCase();
                        java.sql.Date deadline = (java.sql.Date) alterationRequest.get("deadline");
                        Timestamp approvalDate = (Timestamp) alterationRequest.get("approval_date");
                        Timestamp createdAt = (Timestamp) alterationRequest.get("created_at");
                    %>
                    <tr id="alteration-row-<%= alterationRequest.get("id") %>">
                        <td><%= alterationRequest.get("id") %></td>
                        <td><%= alterationRequest.get("request_id") %></td>
                        <td><%= alterationRequest.get("garment") %></td>
                        <td class="text-preview"><%= alterationRequest.get("alteration_type") != null ? alterationRequest.get("alteration_type") : "" %></td>
                        <td><%= alterationRequest.get("customer_name") %></td>
                        <td><%= alterationRequest.get("customer_phone") %></td>
                        <td><%= alterationRequest.get("tailor_name") %></td>
                        <td><%= deadline != null ? deadline : "Not set" %></td>
                        <td>
                            <% if (clothImage != null && !clothImage.isEmpty()) { %>
                            <img src="uploads/alteration/<%= clothImage %>"
                             
                                 class="image-preview" 
                                 onclick="showImage(this.src)"
                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHJ4PSI2IiBmaWxsPSIjMWUyOTNiIi8+PHBhdGggZD0iTTIwIDIwSDQwVjQwSDIwVjIwWiIgZmlsbD0iIzI1NjNlYiIvPjwvc3ZnPg=='">
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:0.8rem;">No Image</span>
                            <% } %>
                        </td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= createdAt != null ? new SimpleDateFormat("MMM dd, yyyy").format(createdAt) : "" %></td>
                        <td><%= approvalDate != null ? new SimpleDateFormat("MMM dd, yyyy").format(approvalDate) : "Not approved" %></td>
                        <td>
<div class="action-group">
 <% if ("complete".equals(status)) { %>                               
   <button class="action-btn btn-process" onclick="updateStatus(<%= alterationRequest.get("id") %>, 'alteration_requests', 'processing', 'tailor_db')">
   <i class="fas fa-cog"></i> Process
    </button>
    <button class="action-btn btn-view" onclick="viewDetails(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-eye"></i> View
   </button>
                              
   <% } else if ("processing".equals(status)) { %>
   
   <button class="action-btn btn-view" onclick="viewDetails(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-eye"></i> View
   </button>
   <button class="action-btn btn-dispatch" onclick="updateStatus(<%= alterationRequest.get("id") %>, 'alteration_requests', 'dispatched', 'tailor_db')">
   <i class="fas fa-shipping-fast"></i> Dispatch
   </button>
   <button class="action-btn btn-hold" onclick="updateStatus(<%= alterationRequest.get("id") %>, 'alteration_requests','hold', 'tailor_db')">
   <i class="fas fa-pause"></i> Hold
   </button>
      <button class="action-btn btn-delete" onclick="deleteRecord(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-trash"></i> Delete
   </button>
                                
   <% } else if ("dispatched".equals(status)) { %>
   <button class="action-btn btn-deliver" onclick="updateStatus(<%= alterationRequest.get("id") %>, 'alteration_requests', 'delivered', 'tailor_db')">
   <i class="fas fa-check-circle"></i> Deliver
   </button>
    <button class="action-btn btn-reset" onclick="resetStatus(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-undo"></i> Reset
   </button>
                                                        
   <% } else if ("hold".equals(status)) { %>
   <button class="action-btn btn-reset" onclick="resetStatus(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-undo"></i> Reset
   </button>
   <button class="action-btn btn-view" onclick="viewDetails(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-eye"></i> View
   </button>
   
   <% } else if ("delivered".equals(status)) { %>
      <button class="action-btn btn-reset" onclick="resetStatus(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-undo"></i> Reset
   </button>
   <button class="action-btn btn-view" onclick="viewDetails(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-eye"></i> View
   </button>
    <button class="action-btn btn-delete" onclick="deleteRecord(<%= alterationRequest.get("id") %>, 'alteration_requests', 'tailor_db')">
   <i class="fas fa-trash"></i> Delete
   </button>
      
   <% } %>
                                   
     </div>
      </td>
       </tr>
         <% } %>
         
                    <% if (alterationRequests.isEmpty()) { %>
                    <tr>
                        <td colspan="13" style="text-align: center; padding: 20px;">
                            <i class="fas fa-cut" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>No alteration requests found</p>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="tailors" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-user-tie"></i> Tailors Management (<%= tailorsCount %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshSection('tailor')">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button class="btn btn-danger" onclick="deleteAllRecords('tailors', 'tailor_db', 'tailor')">
                    <i class="fas fa-trash"></i> Delete All
                </button>
            </div>
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
                        <th>Address</th>
                        <th>Picture</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Approval Time</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> tailor : tailors) { 
                        String picturePath = (String) tailor.get("picture_path");
                        String status = (String) tailor.get("status");
                        String statusClass = "status-" + status.toLowerCase();
                        Timestamp approvalTime = (Timestamp) tailor.get("approval_time");
                        Timestamp createdAt = (Timestamp) tailor.get("created_at");
                    %>
                    <tr id="tailor-row-<%= tailor.get("id") %>">
                        <td><%= tailor.get("id") %></td>
                        <td><%= tailor.get("name") %></td>
                        <td><%= tailor.get("phone") %></td>
                        <td class="text-preview"><%= tailor.get("email") %></td>
                        <td><%= tailor.get("specialty") %></td>
                        <td><%= tailor.get("experience") %> years</td>
                        <td class="text-preview"><%= tailor.get("address") != null ? tailor.get("address") : "" %></td>
                        <td>
                            <% if (picturePath != null && !picturePath.isEmpty()) { %>
                            <img src="uploads/TailorPictures/<%= picturePath %>" 
                                 class="image-preview" 
                                 onclick="showImage(this.src)"
                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIzMCIgY3k9IjMwIiByPSIzMCIgZmlsbD0iIzFlMjkzYiIvPjxjaXJjbGUgY3g9IjMwIiBjeT0iMjAiIHI9IjgiIGZpbGw9IiMyNTYzZWIiLz48Y2lyY2xlIGN4PSIzMCIgY3k9IjQwIiByPSIxMiIgZmlsbD0iIzI1NjNlYiIvPjwvc3ZnPg=='">
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:0.8rem;">No Image</span>
                            <% } %>
                        </td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= createdAt != null ? new SimpleDateFormat("MMM dd, yyyy").format(createdAt) : "" %></td>
                        <td><%= approvalTime != null ? new SimpleDateFormat("MMM dd, yyyy HH:mm").format(approvalTime) : "Not approved" %></td>
 <td>
 <div class="action-group">
                            
 <% if ("pending".equals(status)) { %>
  <button class="action-btn btn-process" onclick="updateStatus(<%= tailor.get("id") %>, 'tailors', 'processing', 'tailor_db')">
   <i class="fas fa-cog"></i> Process
      </button>
                             
   <% } else if ("processing".equals(status)) { %>
                                
     <button class="action-btn btn-approve" onclick="updateStatus(<%= tailor.get("id") %>, 'tailors', 'approved', 'tailor_db')">
     <i class="fas fa-check"></i> Approve
     </button>
      <button class="action-btn btn-reject" onclick="updateStatus(<%= tailor.get("id") %>, 'tailors', 'rejected', 'tailor_db')">
       <i class="fas fa-times"></i> Reject
      </button>
                                
      <button class="action-btn btn-hold" onclick="updateStatus(<%= tailor.get("id") %>, 'tailors', 'hold', 'tailor_db')">
      <i class="fas fa-pause"></i> Hold
     </button>
     <button class="action-btn btn-edit" onclick="editTailor(<%= tailor.get("id") %>)">
     <i class="fas fa-edit"></i> Edit
     </button>
                                
     <% } else if ("approved".equals(status)) { %>
      <button class="action-btn btn-reset" onclick="resetStatus(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
      <i class="fas fa-undo"></i> Reset
     </button>
      <button class="action-btn btn-view" onclick="viewDetails(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
       <i class="fas fa-eye"></i> View
       </button>
                              
        <% } else if ("rejected".equals(status)) { %>
        
        <button class="action-btn btn-view" onclick="viewDetails(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
       <i class="fas fa-eye"></i> View
       </button>                  
       <button class="action-btn btn-reset" onclick="resetStatus(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
       <i class="fas fa-undo"></i> Reset
       </button>
       <button class="action-btn btn-delete" onclick="deleteRecord(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
       <i class="fas fa-trash"></i> Delete
        </button>
        
        <% } else if ("hold".equals(status)) { %>
        <button class="action-btn btn-reset" onclick="resetStatus(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
        <i class="fas fa-undo"></i> Reset
        </button>
        <button class="action-btn btn-view" onclick="viewDetails(<%= tailor.get("id") %>, 'tailors', 'tailor_db')">
        <i class="fas fa-eye"></i> View
         </button>                                                                
       <% } %>
         </div>
            </td>
           </tr>
             <% } %>
                        
                    <% if (tailors.isEmpty()) { %>
                    <tr>
                        <td colspan="12" style="text-align: center; padding: 20px;">
                            <i class="fas fa-user-tie" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>No tailors found</p>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="orders" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-shopping-cart"></i> Orders Management (<%= ordersCount %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshSection('order')">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button class="btn btn-danger" onclick="deleteAllRecords('orders', 'tailor_shop', 'order')">
                    <i class="fas fa-trash"></i> Delete All
                </button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Address</th>
                        <th>Payment</th>
                        <th>Order ID</th>
                        <th>Status</th>
                        <th>Approval Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> order : orders) { 
                        String status = (String) order.get("status");
                        String statusClass = "status-" + status.toLowerCase();
                        Timestamp approvalDate = (Timestamp) order.get("approval_date");
                      
                    %>
                    <tr id="order-row-<%= order.get("id") %>">
                        <td><%= order.get("id") %></td>
                        <td><%= order.get("name") %></td>
                        <td><%= order.get("phone") %></td>
                        <td><%= order.get("product_name") %></td>
                        <td>Rs  <%= order.get("price") %></td>
                        <td class="text-preview"><%= order.get("address") %></td>
                        <td><%= order.get("payment_method") %></td>
                        <td><%= order.get("order_id") %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                        <td><%= approvalDate != null ? new SimpleDateFormat("MMM dd, yyyy").format(approvalDate) : "Not approved" %></td>
                     
  <td>
    <div class="action-group">
     <% if ("pending".equals(status)) { %>

     <button class="action-btn btn-process" onclick="updateStatus(<%= order.get("id") %>, 'orders', 'processing', 'tailor_shop')">
     <i class="fas fa-cog"></i> Process
     </button>
                                     
     <% } else if ("processing".equals(status)) { %>

     <button class="action-btn btn-dispatch" onclick="updateStatus(<%= order.get("id") %>, 'orders', 'dispatched', 'tailor_shop')">
     <i class="fas fa-shipping-fast"></i> Dispatch
     </button>
     <button class="action-btn btn-hold" onclick="updateStatus(<%= order.get("id") %>, 'orders', 'hold', 'tailor_shop')">
      <i class="fas fa-pause"></i> Hold
     </button>
     <button class="action-btn btn-delete" onclick="deleteRecord(<%= order.get("id") %>, 'orders', 'tailor_shop')">
     <i class="fas fa-trash"></i> Delete
      </button>
      <button class="action-btn btn-view" onclick="viewDetails(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-eye"></i> View
       </button>

      <% } else if ("hold".equals(status)) { %>
      <button class="action-btn btn-reset" onclick="resetStatus(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-undo"></i> Reset
      </button>
      <button class="action-btn btn-view" onclick="viewDetails(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-eye"></i> View
       </button>
                                                               
      <% } else if ("dispatched".equals(status)) { %>
      <button class="action-btn btn-deliver" onclick="updateStatus(<%= order.get("id") %>, 'orders', 'delivered', 'tailor_shop')">
      <i class="fas fa-check-circle"></i> Deliver
      </button>                               
      <button class="action-btn btn-reset" onclick="resetStatus(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-undo"></i> Reset
      </button>
      
      <% } else if ("delivered".equals(status)) { %>
       <button class="action-btn btn-reset" onclick="resetStatus(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-undo"></i> Reset
      </button>
      <button class="action-btn btn-view" onclick="viewDetails(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-eye"></i> View
       </button>
       <button class="action-btn btn-delete" onclick="deleteRecord(<%= order.get("id") %>, 'orders', 'tailor_shop')">
      <i class="fas fa-trash"></i> Delete
      </button>
      
    <% } %>
        </div>
           </td>
             </tr>
              <% } %>
              
                    <% if (orders.isEmpty()) { %>
                    <tr>
                        <td colspan="12" style="text-align: center; padding: 20px;">
                            <i class="fas fa-shopping-cart" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>No orders found</p>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </section>


    <section id="users" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-users"></i> User Management (<%= usersCount %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshSection('user')">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button class="btn btn-danger" onclick="deleteAllRecords('signup_login', 'tailor_db', 'user')">
                    <i class="fas fa-trash"></i> Delete All
                </button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Password</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> user : users) { 
                        Timestamp createdAt = (Timestamp) user.get("created_at");
                    %>
                    <tr id="user-row-<%= user.get("id") %>">
                        <td><%= user.get("id") %></td>
                        <td><%= user.get("username") %></td>
                        <td class="text-preview"><%= user.get("email") %></td>
                        <td class="text-preview" title="<%= user.get("password") %>">
                            <%= ((String) user.get("password")).substring(0, Math.min(10, ((String) user.get("password")).length())) %>...
                        </td>
                        <td><%= createdAt != null ? new SimpleDateFormat("MMM dd, yyyy").format(createdAt) : "" %></td>
                        <td>
                            <div class="action-group">
                                <button class="action-btn btn-edit" onclick="editUser(<%= user.get("id") %>)">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="action-btn btn-delete" onclick="deleteRecord(<%= user.get("id") %>, 'signup_login', 'tailor_db')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                                <button class="action-btn btn-view" onclick="viewDetails(<%= user.get("id") %>, 'signup_login', 'tailor_db')">
                                    <i class="fas fa-eye"></i> View
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    <% if (users.isEmpty()) { %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 20px;">
                            <i class="fas fa-users" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>No users found</p>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section id="reviews" class="section">
        <div class="section-header">
            <h2 class="section-title">
                <i class="fas fa-star"></i> Customer Reviews (<%= reviewsCount %>)
            </h2>
            <div class="section-actions">
                <button class="btn btn-primary" onclick="refreshSection('review')">
                    <i class="fas fa-sync-alt"></i> Refresh
                </button>
                <button class="btn btn-danger" onclick="deleteAllRecords('reviews', 'tailor_shop', 'review')">
                    <i class="fas fa-trash"></i> Delete All
                </button>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table-container">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Review</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> review : reviews) { 
                        Timestamp createdAt = (Timestamp) review.get("created_at");
                    %>
                    <tr id="review-row-<%= review.get("id") %>">
                        <td><%= review.get("id") %></td>
                        <td><%= review.get("name") %></td>
                        <td class="text-preview"><%= review.get("review") %></td>
                        <td><%= createdAt != null ? new SimpleDateFormat("MMM dd, yyyy").format(createdAt) : "" %></td>
                        <td>
                            <div class="action-group">
                                <button class="action-btn btn-delete" onclick="deleteRecord(<%= review.get("id") %>, 'reviews', 'tailor_shop')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                                <button class="action-btn btn-view" onclick="viewDetails(<%= review.get("id") %>, 'reviews', 'tailor_shop')">
                                    <i class="fas fa-eye"></i> View
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    <% if (reviews.isEmpty()) { %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 20px;">
                            <i class="fas fa-star" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>No reviews found</p>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </section>

</div>

<div id="imageModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Image Preview</h3>
            <button class="close-modal" onclick="closeModal('imageModal')">&times;</button>
        </div>
        <div class="modal-body">
            <img id="modalImage" src="" alt="Preview" style="width:100%; border-radius:8px;">
        </div>
    </div>
</div>

<div id="adminEditModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3><i class="fas fa-user-cog"></i> Edit Admin Profile</h3>
            <button class="close-modal" onclick="closeModal('adminEditModal')">&times;</button>
        </div>
        <div class="modal-body">
            <form id="adminEditForm" onsubmit="updateAdminProfile(event)">
                <input type="hidden" id="adminId" value="<%= adminId %>">
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Name:</label>
                    <input type="text" id="adminName" value="<%= adminName %>"
                           style="width:100%; padding:10px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);"
                           required>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Email:</label>
                    <input type="email" id="adminEmail" value="<%= adminEmail %>"
                           style="width:100%; padding:10px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);"
                           readonly>
                    <small style="color:var(--warning);">Email cannot be changed</small>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Admin Key:</label>
                    <input type="text" id="adminKey"
                           placeholder="Leave blank to keep current admin key"
                           style="width:100%; padding:10px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);">
                </div>
                
                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fas fa-save"></i> Update Profile
                </button>
            </form>
            
            <hr style="margin:20px 0; border-color:var(--primary); opacity:0.3;">
            
            <div style="margin-top: 20px;">
                <h4 style="color:var(--secondary); margin-bottom:15px;"><i class="fas fa-key"></i> Security Settings</h4>
                
                <div style="display: flex; gap: 10px;">
                    <button type="button" class="btn btn-danger" onclick="location.href='adminPasswordChange.jsp'">
                        <i class="fas fa-lock"></i> Change Password
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="detailsModal" class="modal">
    <div class="modal-content" style="max-width: 800px;">
        <div class="modal-header">
            <h3 id="detailsTitle"><i class="fas fa-info-circle"></i> Details</h3>
            <button class="close-modal" onclick="closeModal('detailsModal')">&times;</button>
        </div>
        <div class="modal-body" id="detailsContent">
            
        </div>
    </div>
</div>

<div id="editTailorModal" class="modal">
    <div class="modal-content" style="max-width: 600px;">
        <div class="modal-header">
            <h3><i class="fas fa-user-edit"></i> Edit Tailor Details</h3>
            <button class="close-modal" onclick="closeModal('editTailorModal')">&times;</button>
        </div>
        <div class="modal-body">
            <form id="editTailorForm" onsubmit="saveTailorChanges(event)">
                <input type="hidden" id="editTailorId">
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                    <div>
                        <label style="display:block; margin-bottom:5px; color:var(--primary);">Name:</label>
                        <input type="text" id="editTailorName" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                    </div>
                    <div>
                        <label style="display:block; margin-bottom:5px; color:var(--primary);">Phone:</label>
                        <input type="text" id="editTailorPhone" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                    </div>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Email:</label>
                    <input type="email" id="editTailorEmail" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Specialty:</label>
                    <input type="text" id="editTailorSpecialty" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                    <div>
                        <label style="display:block; margin-bottom:5px; color:var(--primary);">Experience (years):</label>
                        <input type="number" id="editTailorExperience" min="0" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                    </div>
                    <div>
                        <label style="display:block; margin-bottom:5px; color:var(--primary);">Status:</label>
                        <select id="editTailorStatus" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);">
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                            <option value="hold">Hold</option>
                            <option value="processing">Processing</option>
                        </select>
                    </div>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Address:</label>
                    <textarea id="editTailorAddress" rows="3" style="width:100%; padding:8px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>
        </div>
    </div>
</div>

<div id="editUserModal" class="modal">
    <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header">
            <h3><i class="fas fa-user-edit"></i> Edit User Details</h3>
            <button class="close-modal" onclick="closeModal('editUserModal')">&times;</button>
        </div>
        <div class="modal-body">
            <form id="editUserForm" onsubmit="saveUserChanges(event)">
                <input type="hidden" id="editUserId">
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Username:</label>
                    <input type="text" id="editUserUsername" style="width:100%; padding:10px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">Email:</label>
                    <input type="email" id="editUserEmail" style="width:100%; padding:10px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);" required>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <label style="display:block; margin-bottom:5px; color:var(--primary);">New Password:</label>
                    <input type="password" id="editUserPassword" placeholder="Leave blank to keep current password"
                           style="width:100%; padding:10px; border-radius:5px; border:1px solid var(--primary); background:var(--darker); color:var(--light);">
                </div>
                
                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>
        </div>
    </div>
</div>

<div id="loading" class="loading">
    <div class="spinner"></div>
    <p>Loading...</p>
</div>

<script>

let currentSection = 'dashboard';

function showSection(sectionId, clickedButton) {
    currentSection = sectionId;
    
    document.querySelectorAll('.section').forEach(section => {
        section.classList.remove('active');
    });
    
    document.querySelectorAll('.tab-btn').forEach(tab => {
        tab.classList.remove('active');
    });
    
    document.getElementById(sectionId).classList.add('active');
    
    if (clickedButton) {
        clickedButton.classList.add('active');
    }
    
    document.getElementById(sectionId).scrollIntoView({behavior: 'smooth'});
}

function showImage(src) {
    document.getElementById('modalImage').src = src;
    document.getElementById('imageModal').style.display = 'flex';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}


function refreshDashboard() {
    showLoading();
    setTimeout(() => {
        location.reload();
    }, 500);
}

function refreshSection(sectionType) {
    showLoading();
    setTimeout(() => {
        location.reload();
    }, 500);
}

function getRowId(table, id) {

    const tableMap = {
        'suit_requests': 'suit',
        'alteration_requests': 'alteration',
        'tailors': 'tailor',
        'orders': 'order',
        'signup_login': 'user',
        'reviews': 'review'
    };
    
    const prefix = tableMap[table] || table.replace('_', '-');
    return `${prefix}-row-${id}`;
}

async function updateStatus(id, table, status, database, buttonElement) {
    if (!confirm(`Are you sure you want to change status to ${status.toUpperCase()}?`)) return;
    
    if (buttonElement) {
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        buttonElement.disabled = true;
        
        const actionGroup = buttonElement.closest('.action-group');
        if (actionGroup) {
            actionGroup.querySelectorAll('button').forEach(btn => {
                btn.disabled = true;
            });
        }
    }
    
    showLoading();
    
    try {
       
        const params = new URLSearchParams();
        params.append('action', 'updateStatus');
        params.append('table', table);
        params.append('id', id);
        params.append('status', status);
        params.append('database', database);
        
        console.log('DEBUG: Sending update request with params:', params.toString());
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();
        console.log('DEBUG: Server response:', result);
        
        if (result.success) {
            showNotification(`Status updated to ${status} successfully!`, 'success');
            
            const rowId = getRowId(table, id);
            console.log('DEBUG: Row ID for update:', rowId);
            
            const row = document.getElementById(rowId);
            if (row) {
                const statusBadge = row.querySelector('.status-badge');
                if (statusBadge) {

                    statusBadge.className = 'status-badge';
                    statusBadge.classList.add(`status-${status.toLowerCase()}`);
                    statusBadge.textContent = status.toUpperCase();
                }
            }
            
            setTimeout(() => {
                location.reload();
            }, 1500);
        } else {
            showNotification(result.message || 'Error updating status', 'error');
            
            if (buttonElement && buttonElement.closest('.action-group')) {
                buttonElement.closest('.action-group').querySelectorAll('button').forEach(btn => {
                    btn.disabled = false;
                });
            }
        }
    } catch (error) {
        console.error('Error updating status:', error);
        showNotification('Error updating status: ' + error.message, 'error');
       
        if (buttonElement && buttonElement.closest('.action-group')) {
            buttonElement.closest('.action-group').querySelectorAll('button').forEach(btn => {
                btn.disabled = false;
            });
        }
    } finally {
        hideLoading();
    }
}

async function deleteRecord(id, table, database, buttonElement) {
    if (!confirm('Are you sure you want to delete this record? This action cannot be undone.')) return;
    
    if (buttonElement) {
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
        buttonElement.disabled = true;
        
        const actionGroup = buttonElement.closest('.action-group');
        if (actionGroup) {
            actionGroup.querySelectorAll('button').forEach(btn => {
                btn.disabled = true;
            });
        }
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'delete');
        params.append('table', table);
        params.append('id', id);
        params.append('database', database);
        
        console.log('DEBUG: Sending delete request with params:', params.toString());
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();
        console.log('DEBUG: Server response:', result);
        
        if (result.success) {
            showNotification('Record deleted successfully!', 'success');
            
            const rowId = getRowId(table, id);
            const row = document.getElementById(rowId);
            if (row) {
                row.remove();
            }
            
            setTimeout(() => {
                location.reload();
            }, 1000);
        } else {
            showNotification(result.message || 'Error deleting record', 'error');
        }
    } catch (error) {
        console.error('Error deleting record:', error);
        showNotification('Error deleting record: ' + error.message, 'error');
    } finally {
        hideLoading();
    }
}

async function resetStatus(id, table, database, buttonElement) {
    if (!confirm('Are you sure you want to reset status?')) return;
    
    if (buttonElement) {
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Resetting...';
        buttonElement.disabled = true;
        
        const actionGroup = buttonElement.closest('.action-group');
        if (actionGroup) {
            actionGroup.querySelectorAll('button').forEach(btn => {
                btn.disabled = true;
            });
        }
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'resetStatus');
        params.append('table', table);
        params.append('id', id);
        params.append('database', database);
        
        console.log('DEBUG: Sending reset request with params:', params.toString());
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();
        console.log('DEBUG: Server response:', result);
        
        if (result.success) {
            showNotification('Status reset successfully!', 'success');
            
            const rowId = getRowId(table, id);
            
            const row = document.getElementById(rowId);
            if (row) {
                const statusBadge = row.querySelector('.status-badge');
                if (statusBadge) {
                    statusBadge.className = 'status-badge status-pending';
                    statusBadge.textContent = 'PENDING';
                }
            }
            
            setTimeout(() => {
                location.reload();
            }, 1000);
        } else {
            showNotification(result.message || 'Error resetting status', 'error');
        }
    } catch (error) {
        console.error('Error resetting status:', error);
        showNotification('Error resetting status: ' + error.message, 'error');
    } finally {
        hideLoading();
    }
}

async function viewDetails(id, table, database, buttonElement) {
 
    if (buttonElement) {
        buttonElement.disabled = true;
        setTimeout(() => {
            buttonElement.disabled = false;
        }, 1000);
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'viewDetails');
        params.append('table', table);
        params.append('id', id);
        params.append('database', database);
        
        console.log('DEBUG: Sending view request with params:', params.toString());
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();
        console.log('DEBUG: Server response:', result);
        
        if (result.success) {
            const data = result.data;
            let detailsHtml = '';
            let title = '';
            
            switch(table) {
                case 'suit_requests':
                    title = 'Suit Request Details';
                    detailsHtml = 
                        '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Customer Information</h4>' +
                                '<p><strong>ID:</strong> ' + data.id + '</p>' +
                                '<p><strong>Request ID:</strong> ' + data.request_id + '</p>' +
                                '<p><strong>Customer:</strong> ' + data.customer_name + '</p>' +
                                '<p><strong>Phone:</strong> ' + data.customer_phone + '</p>' +
                                '<p><strong>WhatsApp:</strong> ' + (data.customer_whatsapp || 'N/A') + '</p>' +
                                '<p><strong>Address:</strong> ' + data.customer_address + '</p>' +
                            '</div>' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Order Details</h4>' +
                                '<p><strong>Garment:</strong> ' + data.garment + '</p>' +
                                '<p><strong>SLAI:</strong> ' + (data.slai || 'N/A') + '</p>' +
                                '<p><strong>Deadline:</strong> ' + (data.deadline || 'Not set') + '</p>' +
                                '<p><strong>Tailor:</strong> ' + data.tailor_name + '</p>' +
                                '<p><strong>Status:</strong> <span class="status-badge status-' + data.status.toLowerCase() + '">' + data.status.toUpperCase() + '</span></p>' +
                                '<p><strong>Created:</strong> ' + data.created_at + '</p>' +
                                '<p><strong>Approved:</strong> ' + (data.approval_date || 'Not approved') + '</p>' +
                            '</div>' +
                        '</div>' +
                        '<div style="margin-top: 20px;">' +
                            '<h4 style="color: var(--primary); margin-bottom: 10px;">Additional Information</h4>' +
                            '<p><strong>Measurements:</strong> ' + (data.measurements || 'N/A') + '</p>' +
                            '<p><strong>Notes:</strong> ' + (data.additional_notes || 'N/A') + '</p>' +
                        '</div>';
                    
                    if (data.cloth_image) {
                        detailsHtml += 
                            '<div style="margin-top: 20px;">' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Images</h4>' +
                                '<p><strong>Cloth Image:</strong></p>' +
                                '<img src="uploads/custom_tailor/clothPicture/' + data.cloth_image + '" style="max-width: 200px; border-radius: 8px; border: 2px solid var(--primary);">' +
                            '</div>';
                    }
                    break;
                    
                case 'alteration_requests':
                    title = 'Alteration Request Details';
                    detailsHtml = 
                        '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Customer Information</h4>' +
                                '<p><strong>ID:</strong> ' + data.id + '</p>' +
                                '<p><strong>Request ID:</strong> ' + data.request_id + '</p>' +
                                '<p><strong>Customer:</strong> ' + data.customer_name + '</p>' +
                                '<p><strong>Phone:</strong> ' + data.customer_phone + '</p>' +
                                '<p><strong>WhatsApp:</strong> ' + (data.customer_whatsapp || 'N/A') + '</p>' +
                                '<p><strong>Address:</strong> ' + data.customer_address + '</p>' +
                            '</div>' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Alteration Details</h4>' +
                                '<p><strong>Garment:</strong> ' + data.garment + '</p>' +
                                '<p><strong>Type:</strong> ' + data.alteration_type + '</p>' +
                                '<p><strong>Deadline:</strong> ' + (data.deadline || 'Not set') + '</p>' +
                                '<p><strong>Tailor:</strong> ' + data.tailor_name + '</p>' +
                                '<p><strong>Status:</strong> <span class="status-badge status-' + data.status.toLowerCase() + '">' + data.status.toUpperCase() + '</span></p>' +
                                '<p><strong>Created:</strong> ' + data.created_at + '</p>' +
                                '<p><strong>Approved:</strong> ' + (data.approval_date || 'Not approved') + '</p>' +
                            '</div>' +
                        '</div>' +
                        '<div style="margin-top: 20px;">' +
                            '<h4 style="color: var(--primary); margin-bottom: 10px;">Additional Information</h4>' +
                            '<p><strong>Notes:</strong> ' + (data.additional_notes || 'N/A') + '</p>' +
                        '</div>';
                    
                    if (data.cloth_image) {
                        detailsHtml += 
                            '<div style="margin-top: 20px;">' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Images</h4>' +
                                '<p><strong>Cloth Image:</strong></p>' +
                                '<img src="uploads/custom_tailor/clothPicture/' + data.cloth_image + '" style="max-width: 200px; border-radius: 8px; border: 2px solid var(--primary);">' +
                            '</div>';
                    }
                    break;
                    
                case 'tailors':
                    title = 'Tailor Details';
                    detailsHtml = 
                        '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Personal Information</h4>' +
                                '<p><strong>ID:</strong> ' + data.id + '</p>' +
                                '<p><strong>Name:</strong> ' + data.name + '</p>' +
                                '<p><strong>Phone:</strong> ' + data.phone + '</p>' +
                                '<p><strong>Email:</strong> ' + data.email + '</p>' +
                                '<p><strong>Username:</strong> ' + data.username + '</p>' +
                            '</div>' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Professional Details</h4>' +
                                '<p><strong>Specialty:</strong> ' + data.specialty + '</p>' +
                                '<p><strong>Experience:</strong> ' + data.experience + ' years</p>' +
                                '<p><strong>Verified:</strong> ' + (data.verified == 1 ? 'Yes' : 'No') + '</p>' +
                                '<p><strong>Status:</strong> <span class="status-badge status-' + data.status.toLowerCase() + '">' + data.status.toUpperCase() + '</span></p>' +
                                '<p><strong>Created:</strong> ' + data.created_at + '</p>' +
                                '<p><strong>Approved:</strong> ' + (data.approval_time || 'Not approved') + '</p>' +
                            '</div>' +
                        '</div>' +
                        '<div style="margin-top: 20px;">' +
                            '<h4 style="color: var(--primary); margin-bottom: 10px;">Address</h4>' +
                            '<p>' + (data.address || 'N/A') + '</p>' +
                        '</div>';
                    
                    if (data.picture_path) {
                        detailsHtml += 
                            '<div style="margin-top: 20px;">' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Profile Picture</h4>' +
                                '<img src="uploads/TailorPictures/' + data.picture_path + '" style="max-width: 200px; border-radius: 8px; border: 2px solid var(--primary);">' +
                            '</div>';
                    }
                    break;
                    
                case 'orders':
                    title = 'Order Details';
                    detailsHtml = 
                        '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Customer Information</h4>' +
                                '<p><strong>ID:</strong> ' + data.id + '</p>' +
                                '<p><strong>Order ID:</strong> ' + data.order_id + '</p>' +
                                '<p><strong>Name:</strong> ' + data.name + '</p>' +
                                '<p><strong>Phone:</strong> ' + data.phone + '</p>' +
                                '<p><strong>Address:</strong> ' + data.address + '</p>' +
                            '</div>' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Order Details</h4>' +
                                '<p><strong>Product:</strong> ' + data.product_name + '</p>' +
                                '<p><strong>Price:</strong> Rs ' + data.price + '</p>' +
                                '<p><strong>Payment:</strong> ' + data.payment_method + '</p>' +
                                '<p><strong>Status:</strong> <span class="status-badge status-' + data.status.toLowerCase() + '">' + data.status.toUpperCase() + '</span></p>' +
                                '<p><strong>Approved:</strong> ' + (data.approval_date || 'Not approved') + '</p>' +
                            '</div>' +
                        '</div>';
                    break;
                    
                case 'signup_login':
                    title = 'User Details';
                    detailsHtml = 
                        '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">User Information</h4>' +
                                '<p><strong>ID:</strong> ' + data.id + '</p>' +
                                '<p><strong>Username:</strong> ' + data.username + '</p>' +
                                '<p><strong>Email:</strong> ' + data.email + '</p>' +
                                '<p><strong>Password:</strong> ' + data.password + '</p>' +
                            '</div>' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Account Details</h4>' +
                                '<p><strong>Created:</strong> ' + data.created_at + '</p>' +
                            '</div>' +
                        '</div>';
                    break;
                    
                case 'reviews':
                    title = 'Review Details';
                    detailsHtml = 
                        '<div style="display: grid; grid-template-columns: 1fr; gap: 20px;">' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Review Information</h4>' +
                                '<p><strong>ID:</strong> ' + data.id + '</p>' +
                                '<p><strong>Name:</strong> ' + data.name + '</p>' +
                                '<p><strong>Created:</strong> ' + data.created_at + '</p>' +
                            '</div>' +
                            '<div>' +
                                '<h4 style="color: var(--primary); margin-bottom: 10px;">Review Content</h4>' +
                                '<div style="background: rgba(37, 99, 235, 0.1); padding: 15px; border-radius: 8px; border: 1px solid var(--primary);">' +
                                    '<p>' + data.review + '</p>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                    break;
                    
                default:
                    title = 'Details';
                    detailsHtml = '<p>Displaying details for ' + table + ' ID: ' + id + '</p>';
                    
                    detailsHtml += '<div style="margin-top: 20px;"><h4 style="color: var(--primary);">All Data:</h4><pre style="background: #1e293b; padding: 10px; border-radius: 5px; max-height: 300px; overflow: auto;">';
                    for (let key in data) {
                        detailsHtml += key + ': ' + data[key] + '\n';
                    }
                    detailsHtml += '</pre></div>';
            }
            
            document.getElementById('detailsTitle').innerHTML = '<i class="fas fa-info-circle"></i> ' + title;
            document.getElementById('detailsContent').innerHTML = detailsHtml;
            document.getElementById('detailsModal').style.display = 'flex';
        } else {
            showNotification(result.message || 'Error loading details', 'error');
        }
    } catch (error) {
        console.error('Error loading details:', error);
        showNotification('Error loading details: ' + error.message, 'error');
    } finally {
        hideLoading();
    }
}

async function deleteAllRecords(table, database, sectionType, buttonElement) {
    if (!confirm(`WARNING: This will delete ALL records from ${table}!\n\nThis action cannot be undone. Are you sure?`)) return;
    
    if (buttonElement) {
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
        buttonElement.disabled = true;
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'deleteAll');
        params.append('table', table);
        params.append('database', database);
        
        console.log('DEBUG: Sending deleteAll request with params:', params.toString());
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        if (!response.ok) {
            const errorText = await response.text();
            console.error('HTTP error response:', errorText);
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        let result;
        try {
            const responseText = await response.text();
            console.log('DEBUG: Raw response:', responseText);
            result = JSON.parse(responseText);
        } catch (parseError) {
            console.error('JSON parse error:', parseError);
            throw new Error('Invalid JSON response from server');
        }
        
        console.log('DEBUG: Parsed response:', result);
        
        if (result.success) {
            showNotification(`All records deleted from ${table} successfully!`, 'success');
            
            const tableId = table.replace('_', '-');
            console.log('DEBUG: Table ID for DOM:', tableId);
            
            const tbody = document.querySelector(`${tableId} tbody`);
            if (tbody) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="15" style="text-align: center; padding: 20px;">
                            <i class="fas fa-trash" style="font-size: 36px; color: #6b7280; margin-bottom: 10px;"></i>
                            <p>All records have been deleted</p>
                        </td>
                    </tr>`;
            }
            
            const tabButtons = document.querySelectorAll('.tab-btn');
            tabButtons.forEach(tabBtn => {
                if (tabBtn.textContent.includes(table.replace('_', ' '))) {
                    tabBtn.innerHTML = tabBtn.innerHTML.replace(/\(\d+\)/, '(0)');
                }
            });
            
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach(card => {
                if (card.textContent.includes(table.replace('_', ' '))) {
                    const statNumber = card.querySelector('.stat-number');
                    if (statNumber) {
                        statNumber.textContent = '0';
                    }
                }
            });
            
            setTimeout(() => {
                location.reload();
            }, 2000);
        } else {
            showNotification(result.message || 'Error deleting records', 'error');
        }
    } catch (error) {
        console.error('Error deleting all records:', error);
        showNotification('Error deleting records: ' + error.message, 'error');
    } finally {
        hideLoading();
        if (buttonElement) {
            buttonElement.disabled = false;
            buttonElement.innerHTML = '<i class="fas fa-trash"></i> Delete All';
        }
    }
}

function checkAndDisableDeliveredButtons() {
  
    document.querySelectorAll('[class*="status-delivered"]').forEach(row => {
        const actionGroup = row.querySelector('.action-group');
        if (actionGroup) {
         
            actionGroup.querySelectorAll('.action-btn').forEach(btn => {
                if (!btn.classList.contains('btn-reset') && !btn.classList.contains('btn-view')) {
                    btn.style.display = 'none'; 
                    btn.style.pointerEvents = 'none';
                    btn.style.opacity = '0.5';
                }
            });
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    checkAndDisableDeliveredButtons();
    
    const originalUpdateStatus = window.updateStatus;
    window.updateStatus = async function(id, table, status, database, buttonElement) {
        await originalUpdateStatus.call(this, id, table, status, database, buttonElement);
        setTimeout(checkAndDisableDeliveredButtons, 2000); 
    };
});

async function editTailor(id, buttonElement) {
    
    if (buttonElement) {
        buttonElement.disabled = true;
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'viewDetails');
        params.append('table', 'tailors');
        params.append('id', id);
        params.append('database', 'tailor_db');
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        
        if (result.success) {
            const tailor = result.data;
            document.getElementById('editTailorId').value = tailor.id;
            document.getElementById('editTailorName').value = tailor.name;
            document.getElementById('editTailorPhone').value = tailor.phone;
            document.getElementById('editTailorEmail').value = tailor.email;
            document.getElementById('editTailorSpecialty').value = tailor.specialty;
            document.getElementById('editTailorExperience').value = tailor.experience;
            document.getElementById('editTailorStatus').value = tailor.status;
            document.getElementById('editTailorAddress').value = tailor.address || '';
            
            document.getElementById('editTailorModal').style.display = 'flex';
        } else {
            showNotification(result.message || 'Error loading tailor details', 'error');
        }
    } catch (error) {
        console.error('Error loading tailor data:', error);
        showNotification('Error loading tailor details', 'error');
    } finally {
        hideLoading();
       
        if (buttonElement) {
            buttonElement.disabled = false;
            buttonElement.innerHTML = '<i class="fas fa-edit"></i> Edit';
        }
    }
}

async function saveTailorChanges(event) {
    event.preventDefault();
    
    const id = document.getElementById('editTailorId').value;
    const name = document.getElementById('editTailorName').value;
    const phone = document.getElementById('editTailorPhone').value;
    const email = document.getElementById('editTailorEmail').value;
    const specialty = document.getElementById('editTailorSpecialty').value;
    const experience = document.getElementById('editTailorExperience').value;
    const status = document.getElementById('editTailorStatus').value;
    const address = document.getElementById('editTailorAddress').value;    
    const submitButton = event.target.querySelector('button[type="submit"]');
    if (submitButton) {
        submitButton.disabled = true;
        const originalHTML = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'updateTailor');
        params.append('id', id);
        params.append('name', name);
        params.append('phone', phone);
        params.append('email', email);
        params.append('specialty', specialty);
        params.append('experience', experience);
        params.append('status', status);
        params.append('address', address);
        params.append('database', 'tailor_db');
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        
        if (result.success) {
            showNotification('Tailor details updated successfully!', 'success');
            closeModal('editTailorModal');
            setTimeout(() => {
                location.reload();
            }, 1000);
        } else {
            showNotification(result.message || 'Error updating tailor', 'error');

            if (submitButton) {
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-save"></i> Save Changes';
            }
        }
    } catch (error) {
        console.error('Error updating tailor:', error);
        showNotification('Error updating tailor details', 'error');

        if (submitButton) {
            submitButton.disabled = false;
            submitButton.innerHTML = '<i class="fas fa-save"></i> Save Changes';
        }
    } finally {
        hideLoading();
    }
}

async function editUser(id, buttonElement) {
   
    if (buttonElement) {
        buttonElement.disabled = true;
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'viewDetails');
        params.append('table', 'signup_login');
        params.append('id', id);
        params.append('database', 'tailor_db');
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        
        if (result.success) {
            const user = result.data;
            document.getElementById('editUserId').value = user.id;
            document.getElementById('editUserUsername').value = user.username;
            document.getElementById('editUserEmail').value = user.email;
            document.getElementById('editUserPassword').value = '';
            
            document.getElementById('editUserModal').style.display = 'flex';
        } else {
            showNotification(result.message || 'Error loading user details', 'error');
        }
    } catch (error) {
        console.error('Error loading user data:', error);
        showNotification('Error loading user details', 'error');
    } finally {
        hideLoading();

        if (buttonElement) {
            buttonElement.disabled = false;
            buttonElement.innerHTML = '<i class="fas fa-edit"></i> Edit';
        }
    }
}

async function saveUserChanges(event) {
    event.preventDefault();
    
    const id = document.getElementById('editUserId').value;
    const username = document.getElementById('editUserUsername').value;
    const email = document.getElementById('editUserEmail').value;
    const password = document.getElementById('editUserPassword').value;
    
    const submitButton = event.target.querySelector('button[type="submit"]');
    if (submitButton) {
        submitButton.disabled = true;
        const originalHTML = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'updateUser');
        params.append('id', id);
        params.append('username', username);
        params.append('email', email);
        if (password) {
            params.append('password', password);
        }
        params.append('database', 'tailor_db');
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        
        if (result.success) {
            showNotification('User details updated successfully!', 'success');
            closeModal('editUserModal');
            setTimeout(() => {
                location.reload();
            }, 1000);
        } else {
            showNotification(result.message || 'Error updating user', 'error');
      
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-save"></i> Save Changes';
            }
        }
    } catch (error) {
        console.error('Error updating user:', error);
        showNotification('Error updating user details', 'error');
       
        if (submitButton) {
            submitButton.disabled = false;
            submitButton.innerHTML = '<i class="fas fa-save"></i> Save Changes';
        }
    } finally {
        hideLoading();
    }
}

async function testAction(buttonElement) {

    if (buttonElement) {
        buttonElement.disabled = true;
        const originalHTML = buttonElement.innerHTML;
        buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testing...';
    }
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'testAction');
        params.append('table', 'test_table');
        params.append('id', '999');
        params.append('status', 'approved');
        params.append('database', 'tailor_db');
        
        console.log("DEBUG: Sending test request with params:", params.toString());
        
        const response = await fetch('AdminDashboardServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        console.log("DEBUG: AdminDashboardServlet response:", result);
        
        if (result.success) {
            showNotification('Test successful! Action parameter is being sent.', 'success');
        } else {
            showNotification('Test failed: ' + result.message, 'error');
        }
    } catch (error) {
        console.error('Test error:', error);
        showNotification('Test error: ' + error.message, 'error');
    } finally {
        hideLoading();
       
        if (buttonElement) {
            buttonElement.disabled = false;
            buttonElement.innerHTML = '<i class="fas fa-bug"></i> Test Action';
        }
    }
}

function showLoading() {
    document.getElementById('loading').style.display = 'flex';
}

function hideLoading() {
    document.getElementById('loading').style.display = 'none';
}

function showNotification(message, type) {
   
    const existingNotifications = document.querySelectorAll('.notification');
    existingNotifications.forEach(notif => notif.remove());
    
    const notification = document.createElement('div');
    notification.className = 'notification ' + type;
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.style.display = 'none';
        });
    }
});

document.addEventListener('DOMContentLoaded', function() {
    
    const style = document.createElement('style');
    style.textContent = `
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
            background: linear-gradient(135deg, var(--secondary), var(--primary));
        }
        
        .notification.error {
            background: linear-gradient(135deg, var(--danger), #ff758f);
        }
        
        .notification.info {
            background: linear-gradient(135deg, var(--info), #6c8eff);
        }
        
        .notification.warning {
            background: linear-gradient(135deg, var(--warning), #ffeb3b);
        }
        
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        @keyframes slideOut {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
    `;
    document.head.appendChild(style);
    
    setInterval(() => {
        if (document.visibilityState === 'visible') {
            
            if (currentSection !== 'dashboard') {
                location.reload();
            }
        }
    }, 600000);
});

function openAdminEditModal() {
    document.getElementById('adminEditModal').style.display = 'flex';
}

async function updateAdminProfile(event) {
    event.preventDefault();
    
    const submitButton = event.target.querySelector('button[type="submit"]');
    const originalHTML = submitButton.innerHTML;
    submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
    submitButton.disabled = true;
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'updateAdmin');
        params.append('id', document.getElementById('adminId').value);
        params.append('name', document.getElementById('adminName').value);
        params.append('adminKey', document.getElementById('adminKey').value);       
        
        const response = await fetch('AdminManagementServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        
        if (result.success) {
            showNotification('Profile updated successfully!', 'success');
            closeModal('adminEditModal');
          
            if (document.getElementById('adminName').value !== '<%= adminName %>') {
                document.querySelector('.admin-details h3').textContent = document.getElementById('adminName').value;
            }
            
            document.getElementById('adminKey').value = '';
            
            setTimeout(() => location.reload(), 1500);
        } else {
            showNotification(result.message || 'Error updating profile', 'error');
            submitButton.disabled = false;
            submitButton.innerHTML = originalHTML;
        }
    } catch (error) {
        console.error('Error updating profile:', error);
        showNotification('Error updating profile', 'error');
        submitButton.disabled = false;
        submitButton.innerHTML = originalHTML;
    } finally {
        hideLoading();
    }
}

async function updateAdminKey(event) {
    event.preventDefault();
    
    const submitButton = event.target.querySelector('button[type="submit"]');
    const originalHTML = submitButton.innerHTML;
    submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
    submitButton.disabled = true;
    
    showLoading();
    
    try {
        const params = new URLSearchParams();
        params.append('action', 'updateAdminKey');
        params.append('id', document.getElementById('adminKeyId').value);
        params.append('adminKey', document.getElementById('newAdminKey').value);
        
        const response = await fetch('AdminManagementServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        });
        
        const result = await response.json();
        
        if (result.success) {
            showNotification('Admin key updated successfully!', 'success');
            closeModal('changeAdminKeyModal');
            document.getElementById('newAdminKey').value = '';
        } else {
            showNotification(result.message || 'Error updating admin key', 'error');
            submitButton.disabled = false;
            submitButton.innerHTML = originalHTML;
        }
    } catch (error) {
        console.error('Error updating admin key:', error);
        showNotification('Error updating admin key', 'error');
        submitButton.disabled = false;
        submitButton.innerHTML = originalHTML;
    } finally {
        hideLoading();
    }
}

function changeAdminPassword() {
    window.location.href = 'adminPasswordChange.jsp';
}

</script>
</body>
</html>