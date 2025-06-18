<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.UserDAO, model.ForumPost, model.ForumComment, model.UserActivityScore, model.User, java.text.SimpleDateFormat, java.sql.Timestamp, dao.ForumPostDAO" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi tiết bài viết - JLPT Forum</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --secondary: #1f2937;
            --accent: #f59e0b;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #06b6d4;
            
            --bg-primary: #ffffff;
            --bg-secondary: #f8fafc;
            --bg-tertiary: #f1f5f9;
            --bg-dark: #0f172a;
            
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            
            --border: #e2e8f0;
            --border-light: #f1f5f9;
            
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            
            --radius-sm: 0.375rem;
            --radius: 0.5rem;
            --radius-md: 0.75rem;
            --radius-lg: 1rem;
            --radius-xl: 1.5rem;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-secondary);
            color: var(--text-primary);
            line-height: 1.6;
            font-size: 14px;
        }

        /* Header */
        .header {
            background: var(--bg-primary);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: var(--shadow-sm);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 700;
            font-size: 1.25rem;
            color: var(--primary);
            text-decoration: none;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            border-radius: var(--radius-md);
            overflow: hidden;
        }

        .logo-icon img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .nav {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .nav-link {
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: var(--radius);
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-link:hover, .nav-link.active {
            color: var(--primary);
            background: var(--bg-tertiary);
        }

        .user-menu {
            position: relative;
        }

        .user-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            border: none;
            background: none;
            border-radius: var(--radius);
            cursor: pointer;
            transition: all 0.2s;
        }

        .user-btn:hover {
            background: var(--bg-tertiary);
        }

        .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid var(--border);
        }

        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            min-width: 200px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s;
            z-index: 50;
        }

        .dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: var(--text-primary);
            text-decoration: none;
            transition: all 0.2s;
            border-bottom: 1px solid var(--border-light);
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: var(--bg-tertiary);
        }

        /* Main Container */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Post Container */
        .post-container {
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        /* Post Header */
        .post-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .post-meta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }

        .author-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .author-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid var(--border);
        }

        .author-details h3 {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .author-details p {
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .post-actions {
            position: relative;
        }

        .actions-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: none;
            color: var(--text-muted);
            border-radius: var(--radius);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .actions-btn:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        .actions-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            min-width: 150px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s;
            z-index: 50;
        }

        .actions-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .actions-menu a,
        .actions-menu button {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: var(--text-primary);
            text-decoration: none;
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 1px solid var(--border-light);
        }

        .actions-menu a:last-child,
        .actions-menu button:last-child {
            border-bottom: none;
        }

        .actions-menu a:hover,
        .actions-menu button:hover {
            background: var(--bg-tertiary);
        }

        .actions-menu .delete-btn {
            color: var(--danger);
        }

        .actions-menu .delete-btn:hover {
            background: rgb(239 68 68 / 0.1);
        }

        .post-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1.3;
            margin-bottom: 0.75rem;
        }

        .post-category {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--bg-tertiary);
            color: var(--primary);
            padding: 0.375rem 0.75rem;
            border-radius: var(--radius-sm);
            font-size: 0.875rem;
            font-weight: 500;
        }

        /* Post Content */
        .post-content {
            padding: 1.5rem;
        }

        .post-image {
            width: 100%;
            max-height: 400px;
            border-radius: var(--radius-md);
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .post-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .post-text {
            font-size: 1rem;
            line-height: 1.7;
            color: var(--text-primary);
        }

        /* Post Stats */
        .post-stats {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            background: var(--bg-tertiary);
        }

        .stats-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stats-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .interaction-buttons {
            display: flex;
            gap: 0.75rem;
        }

        .interaction-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            background: var(--bg-primary);
            color: var(--text-secondary);
            border-radius: var(--radius);
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .interaction-btn:hover {
            background: var(--bg-tertiary);
            color: var(--text-primary);
        }

        .interaction-btn.liked {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        /* Comments Section */
        .comments-section {
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }

        .comments-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            background: var(--bg-tertiary);
        }

        .comments-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .comments-list {
            padding: 0;
        }

        .comment-item {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 0.75rem;
        }

        .comment-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid var(--border);
        }

        .comment-author {
            font-weight: 600;
            color: var(--text-primary);
            text-decoration: none;
        }

        .comment-author:hover {
            color: var(--primary);
        }

        .comment-date {
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .comment-content {
            margin-bottom: 0.75rem;
            line-height: 1.6;
        }

        .comment-actions {
            display: flex;
            gap: 1rem;
        }

        .comment-action {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            color: var(--text-muted);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 0.875rem;
            transition: all 0.2s;
        }

        .comment-action:hover {
            color: var(--primary);
        }

        /* Comment Form */
        .comment-form {
            padding: 1.5rem;
            border-top: 1px solid var(--border);
            background: var(--bg-tertiary);
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            background: var(--bg-primary);
            color: var(--text-primary);
            transition: all 0.2s;
            resize: vertical;
            min-height: 100px;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgb(59 130 246 / 0.1);
        }

        .form-footer {
            display: flex;
            justify-content: flex-end;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.625rem 1.25rem;
            border: none;
            border-radius: var(--radius);
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-secondary {
            background: var(--bg-tertiary);
            color: var(--text-secondary);
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            background: var(--bg-secondary);
            color: var(--text-primary);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        /* Related Posts */
        .related-posts {
            background: var(--bg-primary);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-top: 2rem;
        }

        .related-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            background: var(--bg-tertiary);
        }

        .related-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .related-list {
            padding: 0;
        }

        .related-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
        }

        .related-item:hover {
            background: var(--bg-tertiary);
        }

        .related-item:last-child {
            border-bottom: none;
        }

        .related-image {
            width: 80px;
            height: 60px;
            border-radius: var(--radius);
            overflow: hidden;
            flex-shrink: 0;
        }

        .related-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .related-content {
            flex: 1;
            min-width: 0;
        }

        .related-post-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .related-meta {
            color: var(--text-muted);
            font-size: 0.875rem;
            display: flex;
            gap: 1rem;
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s;
        }

        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .modal {
            background: var(--bg-primary);
            border-radius: var(--radius-xl);
            width: 90%;
            max-width: 400px;
            box-shadow: var(--shadow-xl);
            transform: scale(0.9);
            transition: transform 0.3s;
        }

        .modal-overlay.active .modal {
            transform: scale(1);
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
            text-align: center;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .modal-text {
            color: var(--text-secondary);
            line-height: 1.5;
        }

        .modal-footer {
            padding: 1.5rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        /* Alert */
        .alert {
            padding: 1rem;
            border-radius: var(--radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-success {
            background: rgb(16 185 129 / 0.1);
            color: var(--success);
            border: 1px solid rgb(16 185 129 / 0.2);
        }

        /* Back Button */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
        }

        .back-button:hover {
            color: var(--primary);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .post-header {
                padding: 1rem;
            }

            .post-content {
                padding: 1rem;
            }

            .post-stats {
                padding: 1rem;
            }

            .stats-row {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .interaction-buttons {
                width: 100%;
                justify-content: space-between;
            }

            .post-title {
                font-size: 1.5rem;
            }

            .post-meta {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .nav {
                gap: 1rem;
            }

            .nav-link span {
                display: none;
            }
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1.5rem;
            color: var(--text-muted);
        }

        .empty-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-title {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-secondary);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="<%= request.getContextPath() %>/" class="logo">
                <div class="logo-icon">
                    <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo" />
                </div>
                <span>JLPT Forum</span>
            </a>

            <nav class="nav">
                <a href="<%= request.getContextPath() %>/" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/forum" class="nav-link">
                    <i class="fas fa-comments"></i>
                    <span>Diễn đàn</span>
                </a>
                <a href="<%= request.getContextPath() %>/contact" class="nav-link">
                    <i class="fas fa-envelope"></i>
                    <span>Liên hệ</span>
                </a>

                <div class="user-menu">
                    <button class="user-btn" onclick="toggleUserMenu()">
                        <div class="avatar">
                            <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                        </div>
                        <span><%= escapeHtml((String) request.getAttribute("username")) %></span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="dropdown" id="userDropdown">
                        <% 
                            String username = (String) request.getAttribute("username");
                            if ("Guest".equals(username)) {
                        %>
                            <a href="<%= request.getContextPath() %>/login" class="dropdown-item">
                                <i class="fas fa-sign-in-alt"></i>
                                Đăng nhập
                            </a>
                        <% 
                            } else {
                        %>
                            <a href="<%= request.getContextPath() %>/profile" class="dropdown-item">
                                <i class="fas fa-user"></i>
                                Hồ sơ cá nhân
                            </a>
                            <a href="<%= request.getContextPath() %>/settings" class="dropdown-item">
                                <i class="fas fa-cog"></i>
                                Cài đặt
                            </a>
                            <a href="<%= request.getContextPath() %>/logout" class="dropdown-item">
                                <i class="fas fa-sign-out-alt"></i>
                                Đăng xuất
                            </a>
                        <% 
                            }
                        %>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="breadcrumb">
            <a href="<%= request.getContextPath() %>/forum">
                <i class="fas fa-comments"></i>
                Diễn đàn
            </a>
            <i class="fas fa-chevron-right"></i>
            <span>Chi tiết bài viết</span>
        </nav>

        <!-- Back Button -->
        <a href="<%= request.getContextPath() %>/forum" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại diễn đàn
        </a>

        <!-- Alert -->
        <% 
            String message = (String) session.getAttribute("message");
            if (message != null && !message.isEmpty()) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= escapeHtml(message) %>
            </div>
            <% 
                session.removeAttribute("message");
            }
        %>

        <% 
            ForumPost post = (ForumPost) request.getAttribute("postDetail");
            String currentUserId = (String) request.getSession().getAttribute("userId");
            if (post == null) {
        %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3 class="empty-title">Bài viết không tồn tại</h3>
                <p>Bài viết này có thể đã bị xóa hoặc bạn không có quyền truy cập.</p>
            </div>
        <% 
            } else {
                ForumPostDAO postDAO = new ForumPostDAO();
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                String postPicture = post.getPicture() != null ? post.getPicture() : "";
                Timestamp createdDate = post.getCreatedDate();
                String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                boolean hasLiked = currentUserId != null && postDAO.hasUserLikedPost(post.getId(), currentUserId);
                boolean isAuthor = currentUserId != null && post.getPostedBy().equals(currentUserId);
        %>

        <!-- Post Container -->
        <article class="post-container">
            <!-- Post Header -->
            <header class="post-header">
                <div class="post-meta">
                    <div class="author-info">
                        <div class="author-avatar">
                            <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                        </div>
                        <div class="author-details">
                            <h3>
                                <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(post.getPostedBy()) %>" style="color: inherit; text-decoration: none;">
                                    <%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy())) %>
                                </a>
                            </h3>
                            <p>
                                <i class="fas fa-clock"></i>
                                <%= formattedDate %>
                            </p>
                        </div>
                    </div>
                    <% if (isAuthor) { %>
                    <div class="post-actions">
                        <button class="actions-btn" onclick="toggleActionsMenu()">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                        <div class="actions-menu" id="actionsMenu">
                            <a href="<%= request.getContextPath() %>/forum/editPost/<%= post.getId() %>">
                                <i class="fas fa-edit"></i>
                                Chỉnh sửa
                            </a>
                            <button class="delete-btn" onclick="confirmDelete(<%= post.getId() %>)">
                                <i class="fas fa-trash"></i>
                                Xóa bài viết
                            </button>
                        </div>
                    </div>
                    <% } %>
                </div>
                <h1 class="post-title"><%= escapeHtml(post.getTitle()) %></h1>
                <div class="post-category">
                    <i class="fas fa-tag"></i>
                    <%= escapeHtml(post.getCategory()) %>
                </div>
            </header>

            <!-- Post Content -->
            <div class="post-content">
                <% if (postPicture != null && !postPicture.isEmpty()) { %>
                    <div class="post-image">
                        <img src="<%= request.getContextPath() %>/<%= escapeHtml(postPicture) %>" alt="Post image" />
                    </div>
                <% } %>
                <div class="post-text">
                    <%= escapeHtml(post.getContent()).replace("\n", "<br>") %>
                </div>
            </div>

            <!-- Post Stats -->
            <div class="post-stats">
                <div class="stats-row">
                    <div class="stats-info">
                        <div class="stat-item">
                            <i class="fas fa-thumbs-up"></i>
                            <span><%= post.getVoteCount() %> lượt thích</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-comment"></i>
                            <span><%= post.getCommentCount() %> bình luận</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-eye"></i>
                            <span><%= post.getViewCount() %> lượt xem</span>
                        </div>
                    </div>
                    <div class="interaction-buttons">
                        <button class="interaction-btn <%= hasLiked ? "liked" : "" %>" onclick="toggleLike(<%= post.getId() %>, this)">
                            <i class="fas fa-thumbs-up"></i>
                            <span class="like-count"><%= post.getVoteCount() %></span>
                        </button>
                        <button class="interaction-btn" onclick="focusCommentForm()">
                            <i class="fas fa-comment"></i>
                            Bình luận
                        </button>
                        <button class="interaction-btn" onclick="sharePost()">
                            <i class="fas fa-share"></i>
                            Chia sẻ
                        </button>
                    </div>
                </div>
            </div>
        </article>

        <!-- Comments Section -->
        <section class="comments-section">
            <div class="comments-header">
                <h2 class="comments-title">
                    <i class="fas fa-comments"></i>
                    Bình luận (<%= post.getCommentCount() %>)
                </h2>
            </div>

            <div class="comments-list">
                <% 
                    List<ForumComment> comments = post.getComments();
                    if (comments != null && !comments.isEmpty()) {
                        for (ForumComment comment : comments) {
                            Timestamp commentDate = comment.getCommentedDate();
                            String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                %>
                    <div class="comment-item">
                        <div class="comment-header">
                            <div class="comment-avatar">
                                <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                            </div>
                            <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(comment.getCommentedBy()) %>" class="comment-author">
                                <%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy())) %>
                            </a>
                            <span class="comment-date">
                                <i class="fas fa-clock"></i>
                                <%= formattedCommentDate %>
                            </span>
                        </div>
                        <div class="comment-content">
                            <%= escapeHtml(comment.getCommentText()).replace("\n", "<br>") %>
                        </div>
                        <div class="comment-actions">
                            <button class="comment-action">
                                <i class="fas fa-thumbs-up"></i>
                                <%= comment.getVoteCount() %>
                            </button>
                            <button class="comment-action" onclick="replyToComment(<%= comment.getId() %>)">
                                <i class="fas fa-reply"></i>
                                Phản hồi
                            </button>
                        </div>
                    </div>
                <% 
                        }
                    } else {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-comment-slash"></i>
                        </div>
                        <h3 class="empty-title">Chưa có bình luận nào</h3>
                        <p>Hãy là người đầu tiên bình luận cho bài viết này!</p>
                    </div>
                <% 
                    }
                %>
            </div>

            <!-- Comment Form -->
            <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form" id="commentForm">
                <input type="hidden" name="postId" value="<%= post.getId() %>">
                <div class="form-group">
                    <textarea class="form-control" name="commentText" id="commentText" placeholder="Viết bình luận của bạn..." required></textarea>
                </div>
                <div class="form-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Gửi bình luận
                    </button>
                </div>
            </form>
        </section>

        <!-- Related Posts -->
        <section class="related-posts">
            <div class="related-header">
                <h2 class="related-title">
                    <i class="fas fa-link"></i>
                    Bài viết liên quan
                </h2>
            </div>
            <div class="related-list">
                <% 
                    List<ForumPost> relatedPosts = (List<ForumPost>) request.getAttribute("relatedPosts");
                    if (relatedPosts != null && !relatedPosts.isEmpty()) {
                        for (ForumPost relatedPost : relatedPosts) {
                            String relatedPicture = relatedPost.getPicture() != null ? relatedPost.getPicture() : "";
                            Timestamp relatedDate = relatedPost.getCreatedDate();
                            String formattedRelatedDate = relatedDate != null ? sdf.format(relatedDate) : "";
                %>
                    <a href="<%= request.getContextPath() %>/forum/post/<%= relatedPost.getId() %>" class="related-item">
                        <div class="related-image">
                            <img src="<%= request.getContextPath() %>/<%= relatedPicture != null && !relatedPicture.isEmpty() ? escapeHtml(relatedPicture) : "assets/img/learning.jpg" %>" alt="Related post" />
                        </div>
                        <div class="related-content">
                            <h3 class="related-post-title">
                                <%= escapeHtml(relatedPost.getTitle()) %>
                            </h3>
                            <div class="related-meta">
                                <span>
                                    <i class="fas fa-clock"></i>
                                    <%= formattedRelatedDate %>
                                </span>
                                <span>
                                    <i class="fas fa-comment"></i>
                                    <%= relatedPost.getCommentCount() %> bình luận
                                </span>
                                <span>
                                    <i class="fas fa-eye"></i>
                                    <%= relatedPost.getViewCount() %> lượt xem
                                </span>
                            </div>
                        </div>
                    </a>
                <% 
                        }
                    } else {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-link"></i>
                        </div>
                        <h3 class="empty-title">Không có bài viết liên quan</h3>
                        <p>Hiện tại chưa có bài viết nào cùng danh mục.</p>
                    </div>
                <% 
                    }
                %>
            </div>
        </section>

        <% } %>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-exclamation-triangle" style="color: var(--danger);"></i>
                    Xác nhận xóa
                </h3>
                <p class="modal-text">Bạn có chắc chắn muốn xóa bài viết này? Hành động này không thể hoàn tác.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                <button class="btn btn-danger" onclick="deletePost()">Xóa bài viết</button>
            </div>
        </div>
    </div>

    <script>
        let postIdToDelete = null;

        // User menu toggle
        function toggleUserMenu() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        // Actions menu toggle
        function toggleActionsMenu() {
            const menu = document.getElementById('actionsMenu');
            menu.classList.toggle('show');
        }

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(event) {
            const userMenu = document.querySelector('.user-menu');
            const userDropdown = document.getElementById('userDropdown');
            const actionsMenu = document.getElementById('actionsMenu');
            
            if (!userMenu.contains(event.target)) {
                userDropdown.classList.remove('show');
            }
            
            if (!event.target.closest('.post-actions')) {
                actionsMenu.classList.remove('show');
            }
        });

        // Like toggle
        function toggleLike(postId, button) {
            const userId = "<%= request.getSession().getAttribute("userId") != null ? request.getSession().getAttribute("userId") : "" %>";
            if (!userId) {
                alert("Vui lòng đăng nhập để thích bài viết!");
                window.location.href = "<%= request.getContextPath() %>/login";
                return;
            }
            
            const isLiked = button.classList.contains("liked");
            const url = "<%= request.getContextPath() %>/forum/toggleLike";
            
            // Add loading state
            button.disabled = true;
            
            fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update like count in stats
                    const statsLikes = document.querySelector('.stat-item:first-child span');
                    statsLikes.textContent = `${data.voteCount} lượt thích`;
                    
                    // Update button
                    const likeCountSpan = button.querySelector(".like-count");
                    likeCountSpan.textContent = data.voteCount;
                    
                    if (isLiked) {
                        button.classList.remove("liked");
                    } else {
                        button.classList.add("liked");
                    }
                } else {
                    alert(data.message || "Có lỗi xảy ra!");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Có lỗi xảy ra!");
            })
            .finally(() => {
                button.disabled = false;
            });
        }

        // Focus comment form
        function focusCommentForm() {
            const commentText = document.getElementById('commentText');
            commentText.focus();
            commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Reply to comment
        function replyToComment(commentId) {
            const commentText = document.getElementById('commentText');
            commentText.value = `@comment-${commentId} `;
            commentText.focus();
            commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Share post
        function sharePost() {
            if (navigator.share) {
                navigator.share({
                    title: document.title,
                    url: window.location.href
                });
            } else {
                // Fallback: copy to clipboard
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('Đã sao chép liên kết vào clipboard!');
                });
            }
        }

        // Delete confirmation
        function confirmDelete(postId) {
            postIdToDelete = postId;
            document.getElementById('deleteModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            document.body.style.overflow = '';
            postIdToDelete = null;
        }

        function deletePost() {
            if (postIdToDelete) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/forum/deletePost';
                
                const postIdInput = document.createElement('input');
                postIdInput.type = 'hidden';
                postIdInput.name = 'postId';
                postIdInput.value = postIdToDelete;
                
                form.appendChild(postIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Close modal on outside click
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeDeleteModal();
            }
        });

        // Auto-resize textarea
        document.getElementById('commentText').addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
    </script>

    <%@include file="chatbox.jsp" %>
</body>
</html>
