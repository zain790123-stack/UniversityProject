<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
String tailorName = (String) session.getAttribute("tailorName");
if (tailorName == null) {
    response.sendRedirect("unifiedLogin.jsp");
    return;
}

Connection con = null;
PreparedStatement tp = null;
ResultSet tailor = null;

int allCount = 0;
int suitCount = 0;
int alterationCount = 0;
int pendingCount = 0;
int approvedCount = 0;
int rejectedCount = 0;
int holdCount = 0;
int completedCount = 0;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/tailor_db","root","12345");

    tp = con.prepareStatement(
        "SELECT * FROM tailors WHERE name=?");
    tp.setString(1, tailorName);
    tailor = tp.executeQuery();
    
    if (!tailor.next()) {
        response.sendRedirect("unifiedLogin.jsp");
        return;
    }
    
    List<Map<String, Object>> allRequestsList = new ArrayList<>();
    List<Map<String, Object>> suitRequestsList = new ArrayList<>();
    List<Map<String, Object>> alterationRequestsList = new ArrayList<>();
    List<Map<String, Object>> pendingRequestsList = new ArrayList<>();
    List<Map<String, Object>> approvedRequestsList = new ArrayList<>();
    List<Map<String, Object>> rejectedRequestsList = new ArrayList<>();
    List<Map<String, Object>> holdRequestsList = new ArrayList<>();
    List<Map<String, Object>> completedRequestsList = new ArrayList<>();
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
    PreparedStatement psSuit = con.prepareStatement(
        "SELECT id, request_id, garment, slai, deadline, customer_name, customer_phone, " +
        "customer_whatsapp, customer_address, additional_notes, cloth_image, status, " +
        "approval_date, created_at, client_image, measurements " +
        "FROM suit_requests WHERE tailor_name=? ORDER BY created_at DESC");
    psSuit.setString(1, tailorName);
    ResultSet rsSuit = psSuit.executeQuery();
    
    while(rsSuit.next()) {
        Map<String, Object> suitRequest = new HashMap<>();
        suitRequest.put("id", rsSuit.getInt("id"));
        suitRequest.put("request_id", rsSuit.getString("request_id"));
        suitRequest.put("garment", rsSuit.getString("garment"));
        suitRequest.put("slai", rsSuit.getString("slai"));
        suitRequest.put("deadline", rsSuit.getDate("deadline"));
        suitRequest.put("customer_name", rsSuit.getString("customer_name"));
        suitRequest.put("customer_phone", rsSuit.getString("customer_phone"));
        suitRequest.put("customer_whatsapp", rsSuit.getString("customer_whatsapp"));
        suitRequest.put("customer_address", rsSuit.getString("customer_address"));
        suitRequest.put("additional_notes", rsSuit.getString("additional_notes"));
        suitRequest.put("cloth_image", rsSuit.getString("cloth_image"));
        suitRequest.put("client_image", rsSuit.getString("client_image"));
        suitRequest.put("measurements", rsSuit.getString("measurements"));
        
        String status = rsSuit.getString("status");
        if (status == null || status.trim().isEmpty()) {
            status = "pending";
        }
        suitRequest.put("status", status);
        
        Timestamp approvalDate = rsSuit.getTimestamp("approval_date");
        suitRequest.put("approval_date", approvalDate != null ? datetimeFormat.format(approvalDate) : "");
        
        Timestamp createdAt = rsSuit.getTimestamp("created_at");
        suitRequest.put("created_at", createdAt != null ? datetimeFormat.format(createdAt) : "");
        
        suitRequest.put("type", "Suit");
        
        allRequestsList.add(suitRequest);
        suitRequestsList.add(suitRequest);
        allCount++;
        suitCount++;
        
        switch(status.toLowerCase()) {
            case "pending":
                pendingRequestsList.add(suitRequest);
                pendingCount++;
                break;
            case "approve":
            case "approved":
                approvedRequestsList.add(suitRequest);
                approvedCount++;
                break;
            case "reject":
            case "rejected":
                rejectedRequestsList.add(suitRequest);
                rejectedCount++;
                break;
            case "hold":
                holdRequestsList.add(suitRequest);
                holdCount++;
                break;
            case "complete":
            case "completed":
                completedRequestsList.add(suitRequest);
                completedCount++;
                break;
        }
    }
    rsSuit.close();
    psSuit.close();
    
    PreparedStatement psAlt = con.prepareStatement(
        "SELECT id, request_id, garment, alteration_type, deadline, customer_name, " +
        "customer_phone, customer_whatsapp, customer_address, additional_notes, " +
        "cloth_image, status, approval_date, created_at " +
        "FROM alteration_requests WHERE tailor_name=? ORDER BY created_at DESC");
    psAlt.setString(1, tailorName);
    ResultSet rsAlt = psAlt.executeQuery();
    
    while(rsAlt.next()) {
        Map<String, Object> altRequest = new HashMap<>();
        altRequest.put("id", rsAlt.getInt("id"));
        altRequest.put("request_id", rsAlt.getString("request_id"));
        altRequest.put("garment", rsAlt.getString("garment"));
        altRequest.put("alteration_type", rsAlt.getString("alteration_type"));
        altRequest.put("deadline", rsAlt.getDate("deadline"));
        altRequest.put("customer_name", rsAlt.getString("customer_name"));
        altRequest.put("customer_phone", rsAlt.getString("customer_phone"));
        altRequest.put("customer_whatsapp", rsAlt.getString("customer_whatsapp"));
        altRequest.put("customer_address", rsAlt.getString("customer_address"));
        altRequest.put("additional_notes", rsAlt.getString("additional_notes"));
        altRequest.put("cloth_image", rsAlt.getString("cloth_image"));
        
        String status = rsAlt.getString("status");
        if (status == null || status.trim().isEmpty()) {
            status = "pending";
        }
        altRequest.put("status", status);
        
        Timestamp approvalDate = rsAlt.getTimestamp("approval_date");
        altRequest.put("approval_date", approvalDate != null ? datetimeFormat.format(approvalDate) : "");
        
        Timestamp createdAt = rsAlt.getTimestamp("created_at");
        altRequest.put("created_at", createdAt != null ? datetimeFormat.format(createdAt) : "");
        
        altRequest.put("type", "Alteration");
        
        allRequestsList.add(altRequest);
        alterationRequestsList.add(altRequest);
        allCount++;
        alterationCount++;
        
        switch(status.toLowerCase()) {
            case "pending":
                pendingRequestsList.add(altRequest);
                pendingCount++;
                break;
            case "approve":
            case "approved":
                approvedRequestsList.add(altRequest);
                approvedCount++;
                break;
            case "reject":
            case "rejected":
                rejectedRequestsList.add(altRequest);
                rejectedCount++;
                break;
            case "hold":
                holdRequestsList.add(altRequest);
                holdCount++;
                break;
            case "complete":
            case "completed":
                completedRequestsList.add(altRequest);
                completedCount++;
                break;
        }
    }
    rsAlt.close();
    psAlt.close();
    
    pageContext.setAttribute("allRequests", allRequestsList);
    pageContext.setAttribute("suitRequests", suitRequestsList);
    pageContext.setAttribute("alterationRequests", alterationRequestsList);
    pageContext.setAttribute("pendingRequests", pendingRequestsList);
    pageContext.setAttribute("approvedRequests", approvedRequestsList);
    pageContext.setAttribute("rejectedRequests", rejectedRequestsList);
    pageContext.setAttribute("holdRequests", holdRequestsList);
    pageContext.setAttribute("completedRequests", completedRequestsList);
%>

<!DOCTYPE html>
<html>
<head>
<title>Tailor Dashboard</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background: #0f172a;
    color: #e5e7eb;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    padding: 0;
}

#loading {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #0f172a;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
    transition: opacity 0.3s;
}

.loader {
    width: 50px;
    height: 50px;
    border: 3px solid #334155;
    border-top-color: #2563eb;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

.header {
    background: linear-gradient(135deg, #020617 0%, #1e293b 100%);
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    position: sticky;
    top: 0;
    z-index: 100;
}

.logo-section {
    display: flex;
    align-items: center;
    gap: 15px;
    flex: 1;
}

.logo {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    object-fit: contain;
    background: white;
    padding: 5px;
}

.site-title {
    color: #60a5fa;
    font-size: 20px;
    font-weight: bold;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.user-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 2px solid #22c55e;
    object-fit: cover;
}

.logout-btn {
    background: #ef4444;
    color: white;
    border: none;
    padding: 6px 12px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
}

.container {
    max-width: 1800px;
    margin: 0 auto;
    padding: 15px;
}

.profile-card {
    background: linear-gradient(135deg, #020617 0%, #1e293b 100%);
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 20px;
    border: 1px solid #334155;
}

.profile-pic {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    border: 3px solid #2563eb;
    object-fit: cover;
}

.profile-info {
    flex: 1;
}

.profile-info h1 {
    color: #60a5fa;
    margin-bottom: 10px;
    font-size: 24px;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 10px;
    margin-bottom: 15px;
}

.info-item {
    background: rgba(30, 41, 59, 0.5);
    padding: 10px;
    border-radius: 6px;
    border-left: 3px solid #2563eb;
}

.info-item strong {
    color: #94a3b8;
    display: block;
    margin-bottom: 3px;
    font-size: 13px;
}

.info-item span {
    color: #e5e7eb;
    font-size: 15px;
}

.edit-profile-btn {
    background: #2563eb;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
}

.nav-tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 20px;
    flex-wrap: wrap;
    background: #020617;
    padding: 12px;
    border-radius: 10px;
    border: 1px solid #334155;
}

.tab-btn {
    background: #1e293b;
    color: #cbd5e1;
    border: none;
    padding: 10px 20px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
    font-size: 14px;
    flex: 1;
    min-width: 140px;
    display: flex;
    align-items: center;
    gap: 8px;
    justify-content: center;
}

.tab-btn.active {
    background: #2563eb;
    color: white;
}

.tab-btn .badge {
    background: rgba(255, 255, 255, 0.2);
    padding: 2px 6px;
    border-radius: 10px;
    font-size: 11px;
}

.content-section {
    display: none;
}

.content-section.active {
    display: block;
    animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

.table-container {
    background: #020617;
    border-radius: 10px;
    overflow: hidden;
    border: 1px solid #334155;
    overflow-x: auto;
    margin-bottom: 20px;
}

.table-header {
    background: #1e293b;
    padding: 15px;
    border-bottom: 2px solid #334155;
}

.table-header h2 {
    color: #60a5fa;
    font-size: 18px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.stats {
    display: flex;
    gap: 15px;
    margin-top: 8px;
}

.stat {
    background: rgba(96, 165, 250, 0.1);
    padding: 6px 12px;
    border-radius: 5px;
    font-size: 13px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    background: #1e293b;
    color: #60a5fa;
    padding: 12px;
    text-align: left;
    font-weight: bold;
    border-bottom: 2px solid #334155;
    position: sticky;
    top: 0;
    white-space: nowrap;
}

td {
    padding: 10px 12px;
    border-bottom: 1px solid #334155;
    vertical-align: middle;
    font-size: 13px;
}

tr:hover {
    background: rgba(30, 41, 59, 0.5);
}

.table-compact th,
.table-compact td {
    padding: 8px 10px;
    font-size: 12px;
}

.status-badge {
    padding: 4px 8px;
    border-radius: 15px;
    font-size: 11px;
    font-weight: bold;
    display: inline-block;
    white-space: nowrap;
}

.status-pending {
    background: rgba(250, 204, 21, 0.2);
    color: #facc15;
}

.status-approve {
    background: rgba(34, 197, 94, 0.2);
    color: #22c55e;
}

.status-reject {
    background: rgba(239, 68, 68, 0.2);
    color: #ef4444;
}

.status-hold {
    background: rgba(56, 189, 248, 0.2);
    color: #38bdf8;
}

.status-complete {
    background: rgba(168, 85, 247, 0.2);
    color: #a855f7;
}

.action-buttons {
    display: flex;
    gap: 6px;
    flex-wrap: wrap;
}

.action-btn {
    padding: 6px 12px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    font-size: 12px;
    display: flex;
    align-items: center;
    gap: 4px;
    min-width: 90px;
    justify-content: center;
    white-space: nowrap;
}

.btn-approve {
    background: #22c55e;
    color: white;
}

.btn-hold {
    background: #38bdf8;
    color: white;
}

.btn-reject {
    background: #ef4444;
    color: white;
}

.btn-complete {
    background: #a855f7;
    color: white;
}

.btn-reset {
    background: #f59e0b;
    color: white;
}

.btn-delete {
    background: #6b7280;
    color: white;
}

.view-btn {
    background: #2563eb;
    color: white;
    border: none;
    padding: 4px 8px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 11px;
    white-space: nowrap;
}

.img-thumb {
    width: 50px;
    height: 50px;
    border-radius: 6px;
    object-fit: cover;
    cursor: pointer;
    border: 2px solid #334155;
}

.img-thumb-small {
    width: 40px;
    height: 40px;
    border-radius: 4px;
    object-fit: cover;
    cursor: pointer;
    border: 1px solid #334155;
}

.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.9);
    z-index: 1000;
    justify-content: center;
    align-items: center;
}

.modal-content {
    background: #020617;
    border-radius: 10px;
    padding: 20px;
    max-width: 90%;
    width: 800px;
    max-height: 80vh;
    overflow-y: auto;
    border: 2px solid #334155;
    position: relative;
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 2px solid #334155;
}

.modal-header h3 {
    color: #60a5fa;
    font-size: 18px;
}

.close-modal {
    background: none;
    border: none;
    color: #94a3b8;
    font-size: 24px;
    cursor: pointer;
    padding: 0;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.modal-body {
    color: #e5e7eb;
    line-height: 1.6;
}

.modal-text {
    background: #1e293b;
    padding: 15px;
    border-radius: 6px;
    white-space: pre-wrap;
    font-family: 'Courier New', monospace;
    font-size: 13px;
    line-height: 1.5;
    max-height: 300px;
    overflow-y: auto;
}

.empty-state {
    text-align: center;
    padding: 40px 15px;
    color: #94a3b8;
}

.empty-state i {
    font-size: 36px;
    margin-bottom: 15px;
    display: block;
}

.success-message {
    background: linear-gradient(135deg, #065f46 0%, #047857 100%);
    color: #d1fae5;
    padding: 12px 15px;
    border-radius: 6px;
    margin: 15px auto;
    max-width: 700px;
    display: flex;
    align-items: center;
    gap: 10px;
}

@media (max-width: 768px) {
    .header {
        flex-direction: column;
        gap: 10px;
        text-align: center;
    }
    
    .logo-section {
        flex-direction: column;
    }
    
    .profile-card {
        flex-direction: column;
        text-align: center;
    }
    
    .profile-pic {
        width: 100px;
        height: 100px;
    }
    
    .nav-tabs {
        flex-direction: column;
    }
    
    .tab-btn {
        min-width: 100%;
    }
    
    .action-buttons {
        flex-direction: column;
    }
    
    .action-btn {
        min-width: 100%;
    }
    
    .table-container {
        margin: 0 -15px;
        border-radius: 0;
    }
}

.col-id { width: 50px; }
.col-req-id { width: 100px; }
.col-type { width: 80px; }
.col-garment { width: 100px; }
.col-customer { width: 120px; }
.col-phone { width: 100px; }
.col-date { width: 100px; }
.col-status { width: 80px; }
.col-actions { width: 200px; }
.col-image { width: 60px; }
</style>
</head>

<body>

<div id="loading">
    <div class="loader"></div>
</div>

<header class="header">
    <div class="logo-section">
        <img src="images/logo1.png" 
             alt="Site Logo" class="logo"
             onerror="this.src='images/logo1.png'">
        <div class="site-title">Tailor Management System</div>
    </div>
    
    <div class="user-info">
        <img src="uploads/TailorPictures/<%= tailor.getString("picture_path") %>" 
             alt="User Avatar" class="user-avatar"
             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyMCIgY3k9IjIwIiByPSIyMCIgZmlsbD0iIzAyMDYxNyIvPjxjaXJjbGUgY3g9IjIwIiBjeT0iMTUiIHI9IjYiIGZpbGw9IiM2MGE1ZmEiLz48Y2lyY2xlIGN4PSIyMCIgY3k9IjMyIiByPSI4IiBmaWxsPSIjMjU2M2ViIi8+PC9zdmc+Jw== '">
        <span><%= tailor.getString("name") %></span>
        <button class="logout-btn" onclick="logout()">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </div>
</header>

<div class="container">

    <%
    String successMsg = (String) session.getAttribute("successMsg");
    if (successMsg != null) {
    %>
    <div class="success-message" id="successMsg">
        <i class="fas fa-check-circle"></i>
        <span><%= successMsg %></span>
    </div>
    <%
        session.removeAttribute("successMsg");
    } 
    %>

    <div class="profile-card">
        <img src="uploads/TailorPictures/<%= tailor.getString("picture_path") %>" 
             alt="Profile Picture" class="profile-pic"
             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIwIiBoZWlnaHQ9IjEyMCIgdmlld0JveD0iMCAwIDEyMCAxMjAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iNjAiIGN5PSI2MCIgcj0iNjAiIGZpbGw9IiMwMjA2MTciLz48Y2lyY2xlIGN4PSI2MCIgY3k9IjQwIiByPSIyMCIgZmlsbD0iIzYwYTVmYSIvPjxjaXJjbGUgY3g9IjYwIiBjeT0iODAiIHI9IjMwIiBmaWxsPSIjMjU2M2ViIi8+PC9zdmc+Jw== '">
        
        <div class="profile-info">
            <h1><%= tailor.getString("name") %></h1>
            
            <div class="info-grid">
                <div class="info-item">
                    <strong>Specialty</strong>
                    <span><%= tailor.getString("specialty") %></span>
                </div>
                <div class="info-item">
                    <strong>Experience</strong>
                    <span><%= tailor.getInt("experience") %> years</span>
                </div>
                <div class="info-item">
                    <strong>Email</strong>
                    <span><%= tailor.getString("email") %></span>
                </div>
                <div class="info-item">
                    <strong>Phone</strong>
                    <span><%= tailor.getString("phone") %></span>
                </div>
                <div class="info-item">
                    <strong>Status</strong>
                    <span class="status-badge status-approve">ACTIVE</span>
                </div>
                <div class="info-item">
                    <strong>Member Since</strong>
                    <span><%= tailor.getDate("created_at") %></span>
                </div>
            </div>
            
            <button class="edit-profile-btn" onclick="location.href='tailorAccount.jsp'">
                <i class="fas fa-edit"></i> Edit Profile
            </button>
        </div>
    </div>

    <div class="nav-tabs">
        <button class="tab-btn active" onclick="showSection('all')">
            <i class="fas fa-list"></i> All Requests
            <span class="badge" id="allCount"><%= allCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('suit')">
            <i class="fas fa-tshirt"></i> Suit
            <span class="badge" id="suitCount"><%= suitCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('alteration')">
            <i class="fas fa-cut"></i> Alteration
            <span class="badge" id="alterationCount"><%= alterationCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('pending')">
            <i class="fas fa-clock"></i> Pending
            <span class="badge" id="pendingCount"><%= pendingCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('approved')">
            <i class="fas fa-check-circle"></i> Approved
            <span class="badge" id="approvedCount"><%= approvedCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('rejected')">
            <i class="fas fa-times-circle"></i> Rejected
            <span class="badge" id="rejectedCount"><%= rejectedCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('hold')">
            <i class="fas fa-pause-circle"></i> On Hold
            <span class="badge" id="holdCount"><%= holdCount %></span>
        </button>
        <button class="tab-btn" onclick="showSection('completed')">
            <i class="fas fa-flag-checkered"></i> Completed
            <span class="badge" id="completedCount"><%= completedCount %></span>
        </button>
    </div>

    <div id="all-section" class="content-section active">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-list"></i> All Requests</h2>
                <div class="stats">
                    <div class="stat">Total: <%= allCount %></div>
                    <div class="stat">Pending: <%= pendingCount %></div>
                    <div class="stat">Approved: <%= approvedCount %></div>
                </div>
            </div>
            <% if (allRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-inbox"></i>
                <p>No requests found</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-type">Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th class="col-phone">Phone</th>
                        <th class="col-status">Status</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : allRequestsList) { 
                    String status = (String) req.get("status");
                    String statusClass = "status-" + status.toLowerCase();
                    if (statusClass.equals("status-approve")) statusClass = "status-approve";
                    if (statusClass.equals("status-complete")) statusClass = "status-complete";
                %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("type")) %></td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><span class="status-badge <%= statusClass %>"><%= status.toUpperCase() %></span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="suit-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-tshirt"></i> Suit Requests - All Fields</h2>
                <div class="stats">
                    <div class="stat">Total: <%= suitCount %></div>
                    <div class="stat">Created: Latest First</div>
                </div>
            </div>
            <% if (suitRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-tshirt"></i>
                <p>No suit requests found</p>
            </div>
            <% } else { %>
            <table class="table-compact">
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-garment">Garment</th>
                        <th>SLAI</th>
                        <th>Measurements</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th>Phone</th>
                        <th>WhatsApp</th>
                        <th>Address</th>
                        <th>Notes</th>
                        <th>Cloth Image</th>
                        <th>Client Image</th>
                        <th>Created At</th>
                        <th class="col-status">Status</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : suitRequestsList) { 
                    String status = (String) req.get("status");
                    String clothImage = (String) req.get("cloth_image");
                    String clientImage = (String) req.get("client_image");
                    String measurements = (String) req.get("measurements");
                    String slai = (String) req.get("slai");
                    String notes = (String) req.get("additional_notes");
                    String whatsapp = (String) req.get("customer_whatsapp");
                    String address = (String) req.get("customer_address");
                    if (measurements == null) measurements = "";
                    if (slai == null) slai = "";
                    if (notes == null) notes = "";
                    if (whatsapp == null) whatsapp = "";
                    if (address == null) address = "";
                %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("garment")) %></td>
                        <td>
                            <% if (!slai.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(slai) %>', 'SLAI')">
                                <i class="fas fa-file-alt"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (!measurements.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(measurements) %>', 'Measurements')">
                                <i class="fas fa-ruler"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><%= escapeHtml(whatsapp) %></td>
                        <td>
                            <% if (!address.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(address) %>', 'Address')">
                                <i class="fas fa-map-marker-alt"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (!notes.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(notes) %>', 'Additional Notes')">
                                <i class="fas fa-sticky-note"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (clothImage != null && !clothImage.isEmpty()) { %>
                            <img src="uploads/custom_tailor/clothPicture/<%= clothImage %>" 
                                 class="img-thumb-small" 
                                 onclick="viewImage(this.src, 'Cloth Image')"
                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHJ4PSI0IiBmaWxsPSIjMDIwNjE3Ii8+PHBhdGggZD0iTTEwIDEwSDMwVjMwSDEwVjEwWiIgZmlsbD0iIzYwYTVmYSIvPjwvc3ZnPg=='">
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">No Image</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (clientImage != null && !clientImage.isEmpty()) { %>
                            <img src="uploads/custom_tailor/CustomerPctures/<%= clientImage %>" 
                                 class="img-thumb-small" 
                                 onclick="viewImage(this.src, 'Client Image')"
                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHJ4PSI0IiBmaWxsPSIjMDIwNjE3Ii8+PHBhdGggZD0iTTEwIDEwSDMwVjMwSDEwVjEwWiIgZmlsbD0iIzYwYTVmYSIvPjwvc3ZnPg=='">
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">No Image</span>
                            <% } %>
                        </td>
                        <td><%= req.get("created_at") %></td>
                        <td><span class="status-badge status-<%= status.toLowerCase() %>"><%= status.toUpperCase() %></span></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons("suit", status, (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="alteration-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-cut"></i> Alteration Requests - All Fields</h2>
                <div class="stats">
                    <div class="stat">Total: <%= alterationCount %></div>
                    <div class="stat">Created: Latest First</div>
                </div>
            </div>
            <% if (alterationRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-cut"></i>
                <p>No alteration requests found</p>
            </div>
            <% } else { %>
            <table class="table-compact">
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-garment">Garment</th>
                        <th>Alteration Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th>Phone</th>
                        <th>WhatsApp</th>
                        <th>Address</th>
                        <th>Notes</th>
                        <th>Cloth Image</th>
                        <th>Created At</th>
                        <th class="col-status">Status</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : alterationRequestsList) { 
                    String status = (String) req.get("status");
                    String clothImage = (String) req.get("cloth_image");
                    String alterationType = (String) req.get("alteration_type");
                    String notes = (String) req.get("additional_notes");
                    String whatsapp = (String) req.get("customer_whatsapp");
                    String address = (String) req.get("customer_address");
                    if (alterationType == null) alterationType = "";
                    if (notes == null) notes = "";
                    if (whatsapp == null) whatsapp = "";
                    if (address == null) address = "";
                %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("garment")) %></td>
                        <td>
                            <% if (!alterationType.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(alterationType) %>', 'Alteration Type')">
                                <i class="fas fa-cut"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><%= escapeHtml(whatsapp) %></td>
                        <td>
                            <% if (!address.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(address) %>', 'Address')">
                                <i class="fas fa-map-marker-alt"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (!notes.isEmpty()) { %>
                            <button class="view-btn" onclick="viewText('<%= escapeJavaScript(notes) %>', 'Additional Notes')">
                                <i class="fas fa-sticky-note"></i> View
                            </button>
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (clothImage != null && !clothImage.isEmpty()) { %>
                            <img src="uploads/custom_tailor/clothPicture/<%= clothImage %>" 
                                 class="img-thumb-small" 
                                 onclick="viewImage(this.src, 'Cloth Image')"
                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHJ4PSI0IiBmaWxsPSIjMDIwNjE3Ii8+PHBhdGggZD0iTTEwIDEwSDMwVjMwSDEwVjEwWiIgZmlsbD0iIzYwYTVmYSIvPjwvc3ZnPg=='">
                            <% } else { %>
                            <span style="color:#94a3b8;font-size:11px;">No Image</span>
                            <% } %>
                        </td>
                        <td><%= req.get("created_at") %></td>
                        <td><span class="status-badge status-<%= status.toLowerCase() %>"><%= status.toUpperCase() %></span></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons("alteration", status, (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="pending-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-clock"></i> Pending Requests</h2>
                <div class="stats">
                    <div class="stat">Total: <%= pendingCount %></div>
                    <div class="stat">Action Required: Approve/Reject/Hold</div>
                </div>
            </div>
            <% if (pendingRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-clock"></i>
                <p>No pending requests</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-type">Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th class="col-phone">Phone</th>
                        <th class="col-status">Status</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : pendingRequestsList) { %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("type")) %></td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><span class="status-badge status-pending">PENDING</span></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons(((String) req.get("type")).toLowerCase(), "pending", (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="approved-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-check-circle"></i> Approved Requests</h2>
                <div class="stats">
                    <div class="stat">Total: <%= approvedCount %></div>
                    <div class="stat">Ready for Completion</div>
                </div>
            </div>
            <% if (approvedRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-check-circle"></i>
                <p>No approved requests</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-type">Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th class="col-phone">Phone</th>
                        <th>Approval Date</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : approvedRequestsList) { %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("type")) %></td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><%= req.get("approval_date") %></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons(((String) req.get("type")).toLowerCase(), "approve", (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="rejected-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-times-circle"></i> Rejected Requests</h2>
                <div class="stats">
                    <div class="stat">Total: <%= rejectedCount %></div>
                    <div class="stat">Can be reset to pending</div>
                </div>
            </div>
            <% if (rejectedRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-times-circle"></i>
                <p>No rejected requests</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-type">Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th class="col-phone">Phone</th>
                        <th class="col-status">Status</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : rejectedRequestsList) { %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("type")) %></td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><span class="status-badge status-reject">REJECTED</span></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons(((String) req.get("type")).toLowerCase(), "reject", (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="hold-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-pause-circle"></i> On Hold Requests</h2>
                <div class="stats">
                    <div class="stat">Total: <%= holdCount %></div>
                    <div class="stat">Temporarily paused</div>
                </div>
            </div>
            <% if (holdRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-pause-circle"></i>
                <p>No hold requests</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-type">Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th class="col-phone">Phone</th>
                        <th class="col-status">Status</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : holdRequestsList) { %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("type")) %></td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><span class="status-badge status-hold">ON HOLD</span></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons(((String) req.get("type")).toLowerCase(), "hold", (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

    <div id="completed-section" class="content-section">
        <div class="table-container">
            <div class="table-header">
                <h2><i class="fas fa-flag-checkered"></i> Completed Requests</h2>
                <div class="stats">
                    <div class="stat">Total: <%= completedCount %></div>
                    <div class="stat">Work finished</div>
                </div>
            </div>
            <% if (completedRequestsList.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-flag-checkered"></i>
                <p>No completed requests</p>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th class="col-id">ID</th>
                        <th class="col-req-id">Req ID</th>
                        <th class="col-type">Type</th>
                        <th class="col-date">Deadline</th>
                        <th class="col-customer">Customer</th>
                        <th class="col-phone">Phone</th>
                        <th class="col-status">Status</th>
                        <th class="col-actions">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> req : completedRequestsList) { %>
                    <tr>
                        <td><%= req.get("id") %></td>
                        <td><%= escapeHtml((String) req.get("request_id")) %></td>
                        <td><%= escapeHtml((String) req.get("type")) %></td>
                        <td><%= req.get("deadline") %></td>
                        <td><%= escapeHtml((String) req.get("customer_name")) %></td>
                        <td><%= escapeHtml((String) req.get("customer_phone")) %></td>
                        <td><span class="status-badge status-complete">COMPLETED</span></td>
                        <td>
                            <div class="action-buttons">
                                <%= getActionButtons(((String) req.get("type")).toLowerCase(), "complete", (Integer) req.get("id")) %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>

</div>

<div id="textModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="textModalTitle"><i class="fas fa-file-alt"></i> Text Details</h3>
            <button class="close-modal" onclick="closeModal('textModal')">&times;</button>
        </div>
        <div class="modal-body">
            <div id="textContent" class="modal-text"></div>
        </div>
    </div>
</div>

<div id="imageModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="imageModalTitle"><i class="fas fa-image"></i> Image Preview</h3>
            <button class="close-modal" onclick="closeModal('imageModal')">&times;</button>
        </div>
        <div class="modal-body" style="text-align: center;">
            <img id="modalImage" src="" alt="Preview" style="max-width: 100%; max-height: 70vh; border-radius: 8px;">
        </div>
    </div>
</div>

<script>

document.getElementById('loading').style.display = 'none';

function showSection(sectionId) {
    
    document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
    });
    
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    document.getElementById(sectionId + '-section').classList.add('active');
    
    event.target.classList.add('active');
    
    document.getElementById(sectionId + '-section').scrollIntoView({behavior: 'smooth'});
}

function viewText(text, title) {
    document.getElementById('textContent').textContent = text;
    document.getElementById('textModalTitle').innerHTML = '<i class="fas fa-file-alt"></i> ' + title;
    document.getElementById('textModal').style.display = 'flex';
}

function viewImage(src, title) {
    document.getElementById('modalImage').src = src;
    document.getElementById('imageModalTitle').innerHTML = '<i class="fas fa-image"></i> ' + (title || 'Image Preview');
    document.getElementById('imageModal').style.display = 'flex';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

async function performAction(id, type, action) {
    if (!confirm('Are you sure you want to ' + action.toUpperCase() + ' this request?')) {
        return;
    }
    
    try {
        const response = await fetch('TailorActionServlet', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + encodeURIComponent(id) + '&action=' + encodeURIComponent(action) + '&table=' + encodeURIComponent(type + '_requests')
        });
        
        const result = await response.text();
        
        if (result === 'success') {
            location.reload();
        } else {
            alert('Failed to perform action: ' + result);
        }
    } catch (error) {
        console.error('Error performing action:', error);
        alert('Network error. Please try again.');
    }
}

function logout() {
    if (confirm('Are you sure you want to logout?')) {
        window.location.href = 'tailorLogout.jsp';
    }
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

setTimeout(function() {
    var msg = document.getElementById('successMsg');
    if (msg) {
        msg.style.transition = 'opacity 0.5s ease';
        msg.style.opacity = '0';
        setTimeout(() => msg.style.display = 'none', 500);
    }
}, 5000);

function initTooltips() {
    var tooltips = document.querySelectorAll('[data-toggle="tooltip"]');
    tooltips.forEach(function(tooltip) {
        tooltip.addEventListener('mouseenter', function() {
            var title = this.getAttribute('title');
            if (title) {
                var tooltipEl = document.createElement('div');
                tooltipEl.className = 'custom-tooltip';
                tooltipEl.textContent = title;
                tooltipEl.style.position = 'absolute';
                tooltipEl.style.background = '#1e293b';
                tooltipEl.style.color = '#e5e7eb';
                tooltipEl.style.padding = '5px 10px';
                tooltipEl.style.borderRadius = '4px';
                tooltipEl.style.fontSize = '12px';
                tooltipEl.style.zIndex = '1000';
                tooltipEl.style.border = '1px solid #334155';
                document.body.appendChild(tooltipEl);
                
                var rect = this.getBoundingClientRect();
                tooltipEl.style.top = (rect.top - tooltipEl.offsetHeight - 5) + 'px';
                tooltipEl.style.left = (rect.left + (rect.width / 2) - (tooltipEl.offsetWidth / 2)) + 'px';
                
                this._tooltip = tooltipEl;
            }
        });
        
        tooltip.addEventListener('mouseleave', function() {
            if (this._tooltip) {
                document.body.removeChild(this._tooltip);
                this._tooltip = null;
            }
        });
    });
}

document.addEventListener('DOMContentLoaded', function() {
    initTooltips();
});
</script>
</body>
</html>

<%!

private String escapeHtml(String str) {
    if (str == null) return "";
    return str.replace("&", "&amp;")
              .replace("<", "&lt;")
              .replace(">", "&gt;")
              .replace("\"", "&quot;")
              .replace("'", "&#39;");
}

private String escapeJavaScript(String str) {
    if (str == null) return "";
    return str.replace("\\", "\\\\")
              .replace("'", "\\'")
              .replace("\"", "\\\"")
              .replace("\n", "\\n")
              .replace("\r", "\\r")
              .replace("\t", "\\t");
}

private String getActionButtons(String type, String status, int id) {
    status = status.toLowerCase();
    
    StringBuilder buttons = new StringBuilder();
    
    switch(status) {
        case "pending":
            buttons.append("<button class='action-btn btn-approve' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'approve')\"><i class='fas fa-check'></i> Approve</button>")
                   .append("<button class='action-btn btn-hold' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'hold')\"><i class='fas fa-pause'></i> Hold</button>")
                   .append("<button class='action-btn btn-reject' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'reject')\"><i class='fas fa-times'></i> Reject</button>")
                   .append("<button class='action-btn btn-delete' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'delete')\"><i class='fas fa-trash'></i> Delete</button>");
            break;
        case "approve":
        case "approved":
            buttons.append("<button class='action-btn btn-complete' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'complete')\"><i class='fas fa-flag-checkered'></i> Complete</button>")
                   .append("<button class='action-btn btn-reset' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'reset')\"><i class='fas fa-undo'></i> Reset</button>");
            break;
        case "reject":
        case "rejected":
        case "hold":
        case "complete":
        case "completed":
            buttons.append("<button class='action-btn btn-reset' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'reset')\"><i class='fas fa-undo'></i> Reset</button>")
                   .append("<button class='action-btn btn-delete' onclick=\"performAction(").append(id).append(", '").append(type).append("', 'delete')\"><i class='fas fa-trash'></i> Delete</button>");
            break;
    }
    
    return buttons.toString();
}
%>

<%
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('Database error occurred: " + e.getMessage().replace("'", "\\'") + "');</script>");
} finally {
    if (tailor != null) try { tailor.close(); } catch (SQLException e) {}
    if (tp != null) try { tp.close(); } catch (SQLException e) {}
    if (con != null) try { con.close(); } catch (SQLException e) {}
}
%>